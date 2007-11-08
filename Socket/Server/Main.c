#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#pragma comment(lib, "ws2_32.lib")		// WinSock
#pragma comment(lib, "COMCTL32.LIB")	// CommonControl32

// 定数定義
#define WM_SOCKET WM_USER + 1	// ソケット用独自メッセージ定義
#define ID_SEND 101				// 送る
#define ID_UPDATE 102			// リスト更新
#define INI_FILE 
#define MAX_USER 5				// MAX接続ユーザー

// 構造体
typedef struct userinfo {
	int			OnlineEnabled;	// ユーザー
	SOCKADDR_IN from;			// 接続したクライアントに関する情報
	char        szName[32];		// ユーザー名
}USERINFO;

USERINFO UserInfo[MAX_USER];

// プロトタイプ
static int   GetClientName(SOCKET, LPSTR, int);				// クライアント名
static BOOL  Bind(SOCKET, WORD);							// 関連付け
static HMENU InitMenu(void);
HFONT SetFont(LPCTSTR, int);					// フォント設定
void WriteINIFileWindowPos(void);				// INIファイル書き込み

int ListView_Init(HWND);						// リストビュー初期化
int ListView_ListUpdate(HWND);						// ユーザーリストを更新
void ServerLogIn(SOCKADDR_IN, char *, HWND);	// サーバーがログイン
void ServerLogOut(SOCKADDR_IN, char *, HWND);	// ユーザーがログアウト
int  all_send(SOCKET, char *);					// 全クライアントに送信
int  nNo = 0;									// 現在ユーザー数

WORD      wPort = 54321;
WSADATA   wsadata;

static LRESULT CALLBACK WindowProc(HWND, UINT, WPARAM, LPARAM);

//*****************************************************************************
//
// WinMain
//
//*****************************************************************************
int WINAPI WinMain(HINSTANCE hinst, HINSTANCE hinstPrev, LPSTR lpszCmdLine, int nCmdShow)
{
	char       szAppName[] = "Server";
	MSG        msg;
	HWND       hwnd;
	WNDCLASSEX wc = {0};

	// Classを登録
	wc.cbSize        = sizeof(WNDCLASSEX);
	wc.hCursor       = (HCURSOR)LoadImage(NULL, MAKEINTRESOURCE(IDC_ARROW), IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_SHARED);
	wc.hInstance     = hinst;
	wc.hIcon		 = LoadIcon(NULL,MAKEINTRESOURCE(IDI_APPLICATION));
	wc.lpfnWndProc   = WindowProc;
	wc.hbrBackground = (HBRUSH)GetStockObject(GRAY_BRUSH);
	wc.lpszClassName = szAppName;

	if (!RegisterClassEx(&wc)){
		return 0;
	}

	hwnd = CreateWindowEx(/*WS_EX_TOPMOST*/0, 
		                  szAppName, 
						  szAppName, 
						  WS_OVERLAPPEDWINDOW, 
						  CW_USEDEFAULT, 
						  CW_USEDEFAULT, 
						  500, 300, NULL, NULL, 
						  hinst, NULL);
	if (hwnd == NULL){
		return 0;
	}

	ShowWindow(hwnd, nCmdShow);
	UpdateWindow(hwnd);
	
	while (GetMessage(&msg, NULL, 0, 0) > 0) {
		if(!IsDialogMessage(hwnd, &msg)){ // Tabキー移動用
		  TranslateMessage(&msg);
		  DispatchMessage(&msg);
		}
//		TranslateMessage(&msg);
//		DispatchMessage(&msg);
	}

	return (int)msg.wParam;
}

//*****************************************************************************
//
// Windows メッセージプロシージャ
//
//*****************************************************************************
static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{

	static int    nClientCount = 0;
	static HWND   hwndEditBox  = NULL;
	static HWND   hwndListView = NULL;				// ListView
	static HMENU  hmenu        = NULL;
	static SOCKET hsocListen   = INVALID_SOCKET;
	static HFONT hFont;								// フォント
	INITCOMMONCONTROLSEX ic;

	switch (uMsg) {
	case WM_CREATE: {
		// Create時

		HINSTANCE hinst = ((LPCREATESTRUCT)lParam)->hInstance;

		//*****************************************************************************
		//	Socket作成
		//*****************************************************************************
		WSAStartup(MAKEWORD(1, 1), &wsadata);			// Socket作成 1.1

		hsocListen = socket(AF_INET, SOCK_DGRAM, 0);	// 
		if (!Bind(hsocListen, wPort))
			return -1;

		WSAAsyncSelect(hsocListen, hwnd, WM_SOCKET, FD_ACCEPT | FD_READ | FD_CLOSE);	// WM_SOCKETをウィンドウプロシージャで取得できるようにする
		
		//*****************************************************************************
		//	子ウィンドウ作成
		//*****************************************************************************
		hwndEditBox = CreateWindowEx(WS_EX_CLIENTEDGE, "EDIT", "", WS_CHILD | WS_HSCROLL | WS_VSCROLL | WS_VISIBLE | WS_BORDER | WS_TABSTOP | ES_AUTOVSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_AUTOHSCROLL | ES_NOHIDESEL | ES_WANTRETURN, 0, 0, 0, 0, hwnd, (HMENU)1, hinst, NULL);

		ic.dwSize = sizeof(INITCOMMONCONTROLSEX);	//
		ic.dwICC = ICC_LISTVIEW_CLASSES;			// 
		InitCommonControlsEx(&ic);					// 初期化
		hwndListView = CreateWindowEx(WS_EX_CLIENTEDGE, "SysListView32", "", WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT | WS_CLIPCHILDREN | WS_CLIPSIBLINGS, 0, 0, 0, 0, hwnd, (HMENU)3, hinst, NULL);

		ListView_Init(hwndListView);

		//*****************************************************************************
		//	フォント設定
		//*****************************************************************************
        hFont = SetFont((LPCTSTR)"ＭＳ ゴシック", 12);
		SendMessage(hwndEditBox, WM_SETFONT, (WPARAM)hFont, (LPARAM)MAKELPARAM(FALSE, 0));

		//*****************************************************************************
		//	メニュー作成
		//*****************************************************************************
		hmenu = InitMenu();
		SetMenu(hwnd, hmenu);
		
		return 0;
	}

	case WM_COMMAND:
		if (LOWORD(wParam) == ID_SEND) {
			int  nLen;
			char szBuf[256];

			//=============================================================================
			//	リスト内のクライアントにメッセージ
			//=============================================================================
/*			nSel = (int)SendMessage(hwndListBox, LB_GETCURSEL, 0, 0);
			if (nSel == -1) {
				MessageBox(NULL, "クライアントを選択してください。", NULL, MB_ICONWARNING);
				return 0;
			}*/
			nLen = GetWindowText(hwndEditBox, szBuf, sizeof(szBuf));				// 送信メッセージ取得
//			send([nSel].hsocServer, szBuf, nLen, 0);								// 送信
//			sendto(hsocListen, "ログイン完了", (int)strlen("ログイン完了"), 0, (SOCKADDR *)&client, clientlen);
		}
		return 0;

	case WM_SOCKET:
		//*****************************************************************************
		// Socket用独自メッセージ
		switch (WSAGETSELECTEVENT(lParam)) {
		case FD_ACCEPT: {
		}
		case FD_READ: {
			// ■UDP接続ん時全部ここに来る
			int  nLen;
			char szBuf[256];
			SOCKADDR_IN client;
			int clientlen; 
			char szMsg[256];
			int i;

			clientlen = (int)sizeof(client);	// 

//			nLen = recv((SOCKET)wParam, szBuf, sizeof(szBuf) - 1, 0);
			nLen = recvfrom(hsocListen, szBuf, (int)sizeof(szBuf) - 1, 0, (SOCKADDR *)&client, &clientlen);	// 受信
			if (nLen == SOCKET_ERROR) {
				MessageBox(hwnd, "受信エラーです", "FD_READ", MB_OK);
				return FALSE;
			}

			szBuf[nLen+1] = '\0';

			// メッセージバッファ取得
			for (i =3; i < nLen; i++) {
				szMsg[i - 3] = szBuf[i];
			}
			szMsg[nLen - 3] = '\0';

			if (szBuf[2] == 0x00) {
				// ログイン要求
 				all_send(hsocListen, (LPSTR)lstrcat(szMsg," がログインしました。"));	// 全クライアントに送信
				ServerLogIn(client, (LPSTR)szMsg, hwndListView);						// サーバーにログイン
				nNo++;																	// ユーザーカウントアップ
				ListView_ListUpdate(hwndListView);											// ユーザーリスト更新

			} else if (szBuf[2] == 0x01) {
				MessageBox(hwnd, "サーバーログイン要求", "FD_READ", MB_OK);
			} else if (szBuf[2] == 0x02) {
				MessageBox(hwnd, lstrcat(szMsg,"からユーザーリスト取得要求"), "FD_READ", MB_OK);
			} else if (szBuf[2] == 0x09) {
				// ログアウト要求
				//strcpy(szMsg, szBuf + 3);
				//szMsg[szBuf[1]-3] = '\0';
				ServerLogOut(client, (LPSTR)szMsg, hwndListView);			// サーバーからログアウト
				all_send(hsocListen, (LPSTR)szMsg);							// クライアントへ通知
				ListView_ListUpdate(hwndListView);								// ユーザーリスト更新
			}
			break;
		}
		case FD_CLOSE: {
			// 切断
			char szClient[256];

//			i = GetClientName(hsocListen, UserInfo, szClient, nClientCount);
			lstrcat(szClient, " が切断しました。");

//			closesocket(UserInfo[i].from);

			/*SendMessage(hwndListBox, LB_DELETESTRING, i, 0);
			for (; i < nClientCount - 1; i++)
				UserInfo[i] = UserInfo[i + 1]; // DATA構造体の要素をずらす

			if (--nClientCount == 0) {
				EnableMenuItem(hmenu, ID_SEND, MF_GRAYED);
				DrawMenuBar(hwnd);
			}*/

			break;
		}
		}
		return 0;
	
	case WM_SIZE: {
		//	■Windowサイズ変更
		int cx = LOWORD(lParam) / 3;
		MoveWindow(hwndListView, 0, 0, cx, HIWORD(lParam), TRUE);
		MoveWindow(hwndEditBox, cx, 0, LOWORD(lParam) - cx, HIWORD(lParam), TRUE);
		return 0;
	}

	case WM_DESTROY:
		//	■Window破棄
        DeleteObject(hFont);
		closesocket(hsocListen);
		WSACleanup();
		PostQuitMessage(0);
		return 0;

	default:
		break;
	}

	return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

//*****************************************************************************
//
// 関連付け
//
//*****************************************************************************
static BOOL Bind(SOCKET hsocListen, WORD wPort)
{
	SOCKADDR_IN sai = {0};

	sai.sin_family      = AF_INET;
	sai.sin_port        = htons(wPort);
	sai.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(hsocListen, (LPSOCKADDR)&sai, sizeof(sai)) == SOCKET_ERROR) {
		MessageBox(NULL, "ローカルアドレスとソケット関連付けに失敗しました。", NULL, MB_ICONWARNING);
		return FALSE;
	}

//	if (listen(hsocListen, 5) == SOCKET_ERROR) {
//		MessageBox(NULL, "接続キューの作成に失敗しました。", NULL, MB_ICONWARNING);
//		return FALSE;
//	}

	return TRUE;
}

//*****************************************************************************
//
// クライアント名を取得
//
//*****************************************************************************
static int GetClientName(SOCKET hsoc, LPSTR lpszName, int nClientCount)
{
	int i;

	for (i = 0; i < nClientCount; i++) {
//		if (hsoc == lpData[].from.sin_addr) {
			LPSTR lpszIPAddress;
			lpszIPAddress = inet_ntoa(UserInfo[i].from.sin_addr);
			lstrcpy(lpszName, lpszIPAddress);
			//lpData[i].si.sin_addr;

			/*LPHOSTENT lphe;
			lphe = gethostbyaddr((char *)&lpData[i].si.sin_addr, 4, AF_INET);
			lstrcpy(lpszName, lphe->h_name);*/
			
			return i;
//		}
	}

	return -1;
}

//*****************************************************************************
//
//	メニュー初期化
//
//*****************************************************************************
static HMENU InitMenu(void)
{
	int          i;
	int          nCount   = 2;
	int          nIds[]   = {ID_SEND};
	int          nState[] = {MFS_GRAYED};
	HMENU        hmenu;
	LPSTR        lpsz[]   = {"送信"};
	MENUITEMINFO mii      = {0};
	
	hmenu = CreateMenu();

	mii.fMask  = MIIM_TYPE | MIIM_ID | MIIM_STATE;
	mii.fType  = MFT_STRING;
	mii.cbSize = sizeof(MENUITEMINFO);

	for (i = 0; i < nCount; i++) {
		mii.wID        = nIds[i];
		mii.fState     = nState[i];
		mii.dwTypeData = lpsz[i];
		InsertMenuItem(hmenu, 0, FALSE, &mii);
	}

	return hmenu;
}

//*****************************************************************************
//
//	リストビュー初期化
//
//*****************************************************************************
int ListView_Init(HWND hwndListView)
{
	DWORD dwStyle;				// ListView用スタイル
	LVCOLUMN col;				// ListViewのカラム

	dwStyle = ListView_GetExtendedListViewStyle(hwndListView);
	dwStyle |= LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES | LVS_EX_HEADERDRAGDROP;
	SendMessage(hwndListView, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, dwStyle);

	col.mask = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;
	col.fmt = LVCFMT_LEFT;
	col.cx = 100;
	col.pszText = "ID";
	col.iSubItem = 0;
	SendMessage(hwndListView, LVM_INSERTCOLUMN, 0, (LPARAM)&col);

	col.cx = 50;
	col.pszText = "IPアドレス";
	col.iSubItem = 1;
	SendMessage(hwndListView, LVM_INSERTCOLUMN, 1, (LPARAM)&col);

	col.cx = 50;
	col.pszText = "ポート";
	col.iSubItem = 2;
	SendMessage(hwndListView, LVM_INSERTCOLUMN, 2, (LPARAM)&col);

	return 0;

}

//*****************************************************************************
//
//	フォントをセットする
//
//*****************************************************************************
HFONT SetFont(LPCTSTR face, int h)
{
    HFONT hFont;
    hFont = CreateFont(h,			// フォント高さ
        0,							// 文字幅
        0,							// テキストの角度
        0,							// ベースラインとｘ軸との角度
        FW_REGULAR,					// フォントの重さ（太さ）
        FALSE,						// イタリック体
        FALSE,						// アンダーライン
        FALSE,						// 打ち消し線
        SHIFTJIS_CHARSET,			// 文字セット
        OUT_DEFAULT_PRECIS,			// 出力精度
        CLIP_DEFAULT_PRECIS,		// クリッピング精度
        PROOF_QUALITY,				// 出力品質
        FIXED_PITCH | FF_MODERN,	// ピッチとファミリー
        face);						// 書体名
    return hFont;
}


void WriteINIFileWindowPos(){

/*	wsprintf(szTemp, "%d", rcWinSize.left);
	WritePrivateProfileString("Window", "Left", szTemp, ini_path);
	wsprintf(szTemp, "%d", rcWinSize.top);
	WritePrivateProfileString("Window", "Top", szTemp, ini_path);
	wsprintf(szTemp, "%d", rcWinSize.right - rcWinSize.left);
	WritePrivateProfileString("Window", "Width", szTemp, ini_path);
	wsprintf(szTemp, "%d", rcWinSize.bottom - rcWinSize.top);
	WritePrivateProfileString("Window", "Height", szTemp, ini_path);
	*/
}

//*****************************************************************************
// サーバーにログイン
// 引数
//		addr
//		ユーザー名
//*****************************************************************************
void ServerLogIn(SOCKADDR_IN sa, char *lpszName, HWND hwndListView)
{
	int		i;				/* ループ用変数 */
	int		iHaving;		/* 概にオンラインしている */
    LV_ITEM item;
	char	szBuf[256];

	iHaving = 0;
	
	// 概にログインしているかチェック
	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1 && strcmp(UserInfo[i].szName,lpszName) == 0) {
			iHaving = 1;
		}
	}

	// ログインしていない場合、リストに追加
	if (iHaving == 0) {
		// 
		for (i = 0; i < MAX_USER; i++) {
			if (UserInfo[i].OnlineEnabled == 0) {
				UserInfo[i].from = sa;
				UserInfo[i].OnlineEnabled = 1;
				strcpy(UserInfo[i].szName, lpszName);

				// リストにユーザー追加
				memset(&item, 0, sizeof(LV_ITEM));
				item.mask = LVIF_TEXT;
				item.pszText = lpszName;
				item.iItem = 0;
				item.iSubItem = 0;
				SendMessage(hwndListView, LVM_INSERTITEM, 0, (LPARAM)&item);

				item.pszText =  inet_ntoa(sa.sin_addr); //htonl(sa.sin_addr);
				item.iSubItem = 1;
				SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);

				sprintf(szBuf, "%d", htons((unsigned short)sa.sin_port));	// ポート番号取得
				item.pszText = szBuf;
				item.iSubItem = 2;
				SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);

				break;
			}
		}
	}

//			data[nClientCount].hsocServer = accept(hsocListen, (LPSOCKADDR)&si, &nLen);
//			data[nClientCount].si         = si;
//			UserInfo[nClientCount].from		= 
//			UserInfo[nClientCount].from		= 
			
//			WSAAsyncSelect(data[nClientCount].hsocServer, hwnd, WM_SOCKET, FD_READ | FD_CLOSE);
			
/*			GetClientName(data[nClientCount].hsocServer, data, szBuf, nClientCount + 1);
			SendMessage(hwndListBox, LB_ADDSTRING, 0, (LPARAM)szBuf);*/

//	return 0;
}

//*****************************************************************************
// サーバーにログアウト
// 引数
//		addr	=	クライアント側ソケットハンドル
//		char *	=	ユーザー名
//		HWND	=	リストビューのウィンドウハンドル
//*****************************************************************************
void ServerLogOut(SOCKADDR_IN addr, char *lpszName, HWND hwndListView)
{
	int i;

	for (i = 0; i < MAX_USER; i++) {
		// アドレスとユーザー名が一致した場合
		if (addr.sin_addr.s_addr == UserInfo[i].from.sin_addr.s_addr &&
			strcmp(lpszName, UserInfo[i].szName) == 0) {
			UserInfo[i].OnlineEnabled = 0;
			nNo--;
			break;
		}
	}
//	return 0;
}

//*****************************************************************************
// 全クライアントへ送信
// 引数
//		addr
//		ユーザー名
//		リストビューのウィンドウハンドル
//*****************************************************************************
int all_send(SOCKET s, char *lpszMessage)
{
	int i;	

	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1)
			// オンライン中のクライアントへ送信
			sendto(s, lpszMessage, (int)strlen(lpszMessage), 0, (SOCKADDR *)&UserInfo[i].from, (int)sizeof(UserInfo[i].from));
		}
	return 0;
}

//*****************************************************************************
// ユーザーリスト更新
// 引数
//		リストビューのウィンドウハンドル
//*****************************************************************************
int ListView_ListUpdate(HWND hwndListView)
{
	int i;
    LV_ITEM item;
	char	szBuf[256];

    SendMessage(hwndListView, LVM_DELETEALLITEMS, 0, 0);
	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1) {
			// リストにユーザー追加
			memset(&item, 0, sizeof(LV_ITEM));
			item.mask = LVIF_TEXT;
			item.pszText = UserInfo[i].szName;
			item.iItem = 0;
			item.iSubItem = 0;
			SendMessage(hwndListView, LVM_INSERTITEM, 0, (LPARAM)&item);

			item.pszText =  inet_ntoa(UserInfo[i].from.sin_addr); //htonl(sa.sin_addr);
			item.iSubItem = 1;
			SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);

			sprintf(szBuf, "%d", htons((unsigned short)UserInfo[i].from.sin_port));	// ポート番号取得
			item.pszText = szBuf;
			item.iSubItem = 2;
			SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);
		}
	}
	return 0;
}