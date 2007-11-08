#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#pragma comment(lib, "ws2_32.lib")		// WinSock
#pragma comment(lib, "COMCTL32.LIB")	// CommonControl32

// �萔��`
#define WM_SOCKET WM_USER + 1	// �\�P�b�g�p�Ǝ����b�Z�[�W��`
#define ID_SEND 101				// ����
#define ID_UPDATE 102			// ���X�g�X�V
#define INI_FILE 
#define MAX_USER 5				// MAX�ڑ����[�U�[

// �\����
typedef struct userinfo {
	int			OnlineEnabled;	// ���[�U�[
	SOCKADDR_IN from;			// �ڑ������N���C�A���g�Ɋւ�����
	char        szName[32];		// ���[�U�[��
}USERINFO;

USERINFO UserInfo[MAX_USER];

// �v���g�^�C�v
static int   GetClientName(SOCKET, LPSTR, int);				// �N���C�A���g��
static BOOL  Bind(SOCKET, WORD);							// �֘A�t��
static HMENU InitMenu(void);
HFONT SetFont(LPCTSTR, int);					// �t�H���g�ݒ�
void WriteINIFileWindowPos(void);				// INI�t�@�C����������

int ListView_Init(HWND);						// ���X�g�r���[������
int ListView_ListUpdate(HWND);						// ���[�U�[���X�g���X�V
void ServerLogIn(SOCKADDR_IN, char *, HWND);	// �T�[�o�[�����O�C��
void ServerLogOut(SOCKADDR_IN, char *, HWND);	// ���[�U�[�����O�A�E�g
int  all_send(SOCKET, char *);					// �S�N���C�A���g�ɑ��M
int  nNo = 0;									// ���݃��[�U�[��

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

	// Class��o�^
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
		if(!IsDialogMessage(hwnd, &msg)){ // Tab�L�[�ړ��p
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
// Windows ���b�Z�[�W�v���V�[�W��
//
//*****************************************************************************
static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{

	static int    nClientCount = 0;
	static HWND   hwndEditBox  = NULL;
	static HWND   hwndListView = NULL;				// ListView
	static HMENU  hmenu        = NULL;
	static SOCKET hsocListen   = INVALID_SOCKET;
	static HFONT hFont;								// �t�H���g
	INITCOMMONCONTROLSEX ic;

	switch (uMsg) {
	case WM_CREATE: {
		// Create��

		HINSTANCE hinst = ((LPCREATESTRUCT)lParam)->hInstance;

		//*****************************************************************************
		//	Socket�쐬
		//*****************************************************************************
		WSAStartup(MAKEWORD(1, 1), &wsadata);			// Socket�쐬 1.1

		hsocListen = socket(AF_INET, SOCK_DGRAM, 0);	// 
		if (!Bind(hsocListen, wPort))
			return -1;

		WSAAsyncSelect(hsocListen, hwnd, WM_SOCKET, FD_ACCEPT | FD_READ | FD_CLOSE);	// WM_SOCKET���E�B���h�E�v���V�[�W���Ŏ擾�ł���悤�ɂ���
		
		//*****************************************************************************
		//	�q�E�B���h�E�쐬
		//*****************************************************************************
		hwndEditBox = CreateWindowEx(WS_EX_CLIENTEDGE, "EDIT", "", WS_CHILD | WS_HSCROLL | WS_VSCROLL | WS_VISIBLE | WS_BORDER | WS_TABSTOP | ES_AUTOVSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_AUTOHSCROLL | ES_NOHIDESEL | ES_WANTRETURN, 0, 0, 0, 0, hwnd, (HMENU)1, hinst, NULL);

		ic.dwSize = sizeof(INITCOMMONCONTROLSEX);	//
		ic.dwICC = ICC_LISTVIEW_CLASSES;			// 
		InitCommonControlsEx(&ic);					// ������
		hwndListView = CreateWindowEx(WS_EX_CLIENTEDGE, "SysListView32", "", WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT | WS_CLIPCHILDREN | WS_CLIPSIBLINGS, 0, 0, 0, 0, hwnd, (HMENU)3, hinst, NULL);

		ListView_Init(hwndListView);

		//*****************************************************************************
		//	�t�H���g�ݒ�
		//*****************************************************************************
        hFont = SetFont((LPCTSTR)"�l�r �S�V�b�N", 12);
		SendMessage(hwndEditBox, WM_SETFONT, (WPARAM)hFont, (LPARAM)MAKELPARAM(FALSE, 0));

		//*****************************************************************************
		//	���j���[�쐬
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
			//	���X�g���̃N���C�A���g�Ƀ��b�Z�[�W
			//=============================================================================
/*			nSel = (int)SendMessage(hwndListBox, LB_GETCURSEL, 0, 0);
			if (nSel == -1) {
				MessageBox(NULL, "�N���C�A���g��I�����Ă��������B", NULL, MB_ICONWARNING);
				return 0;
			}*/
			nLen = GetWindowText(hwndEditBox, szBuf, sizeof(szBuf));				// ���M���b�Z�[�W�擾
//			send([nSel].hsocServer, szBuf, nLen, 0);								// ���M
//			sendto(hsocListen, "���O�C������", (int)strlen("���O�C������"), 0, (SOCKADDR *)&client, clientlen);
		}
		return 0;

	case WM_SOCKET:
		//*****************************************************************************
		// Socket�p�Ǝ����b�Z�[�W
		switch (WSAGETSELECTEVENT(lParam)) {
		case FD_ACCEPT: {
		}
		case FD_READ: {
			// ��UDP�ڑ��񎞑S�������ɗ���
			int  nLen;
			char szBuf[256];
			SOCKADDR_IN client;
			int clientlen; 
			char szMsg[256];
			int i;

			clientlen = (int)sizeof(client);	// 

//			nLen = recv((SOCKET)wParam, szBuf, sizeof(szBuf) - 1, 0);
			nLen = recvfrom(hsocListen, szBuf, (int)sizeof(szBuf) - 1, 0, (SOCKADDR *)&client, &clientlen);	// ��M
			if (nLen == SOCKET_ERROR) {
				MessageBox(hwnd, "��M�G���[�ł�", "FD_READ", MB_OK);
				return FALSE;
			}

			szBuf[nLen+1] = '\0';

			// ���b�Z�[�W�o�b�t�@�擾
			for (i =3; i < nLen; i++) {
				szMsg[i - 3] = szBuf[i];
			}
			szMsg[nLen - 3] = '\0';

			if (szBuf[2] == 0x00) {
				// ���O�C���v��
 				all_send(hsocListen, (LPSTR)lstrcat(szMsg," �����O�C�����܂����B"));	// �S�N���C�A���g�ɑ��M
				ServerLogIn(client, (LPSTR)szMsg, hwndListView);						// �T�[�o�[�Ƀ��O�C��
				nNo++;																	// ���[�U�[�J�E���g�A�b�v
				ListView_ListUpdate(hwndListView);											// ���[�U�[���X�g�X�V

			} else if (szBuf[2] == 0x01) {
				MessageBox(hwnd, "�T�[�o�[���O�C���v��", "FD_READ", MB_OK);
			} else if (szBuf[2] == 0x02) {
				MessageBox(hwnd, lstrcat(szMsg,"���烆�[�U�[���X�g�擾�v��"), "FD_READ", MB_OK);
			} else if (szBuf[2] == 0x09) {
				// ���O�A�E�g�v��
				//strcpy(szMsg, szBuf + 3);
				//szMsg[szBuf[1]-3] = '\0';
				ServerLogOut(client, (LPSTR)szMsg, hwndListView);			// �T�[�o�[���烍�O�A�E�g
				all_send(hsocListen, (LPSTR)szMsg);							// �N���C�A���g�֒ʒm
				ListView_ListUpdate(hwndListView);								// ���[�U�[���X�g�X�V
			}
			break;
		}
		case FD_CLOSE: {
			// �ؒf
			char szClient[256];

//			i = GetClientName(hsocListen, UserInfo, szClient, nClientCount);
			lstrcat(szClient, " ���ؒf���܂����B");

//			closesocket(UserInfo[i].from);

			/*SendMessage(hwndListBox, LB_DELETESTRING, i, 0);
			for (; i < nClientCount - 1; i++)
				UserInfo[i] = UserInfo[i + 1]; // DATA�\���̗̂v�f�����炷

			if (--nClientCount == 0) {
				EnableMenuItem(hmenu, ID_SEND, MF_GRAYED);
				DrawMenuBar(hwnd);
			}*/

			break;
		}
		}
		return 0;
	
	case WM_SIZE: {
		//	��Window�T�C�Y�ύX
		int cx = LOWORD(lParam) / 3;
		MoveWindow(hwndListView, 0, 0, cx, HIWORD(lParam), TRUE);
		MoveWindow(hwndEditBox, cx, 0, LOWORD(lParam) - cx, HIWORD(lParam), TRUE);
		return 0;
	}

	case WM_DESTROY:
		//	��Window�j��
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
// �֘A�t��
//
//*****************************************************************************
static BOOL Bind(SOCKET hsocListen, WORD wPort)
{
	SOCKADDR_IN sai = {0};

	sai.sin_family      = AF_INET;
	sai.sin_port        = htons(wPort);
	sai.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(hsocListen, (LPSOCKADDR)&sai, sizeof(sai)) == SOCKET_ERROR) {
		MessageBox(NULL, "���[�J���A�h���X�ƃ\�P�b�g�֘A�t���Ɏ��s���܂����B", NULL, MB_ICONWARNING);
		return FALSE;
	}

//	if (listen(hsocListen, 5) == SOCKET_ERROR) {
//		MessageBox(NULL, "�ڑ��L���[�̍쐬�Ɏ��s���܂����B", NULL, MB_ICONWARNING);
//		return FALSE;
//	}

	return TRUE;
}

//*****************************************************************************
//
// �N���C�A���g�����擾
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
//	���j���[������
//
//*****************************************************************************
static HMENU InitMenu(void)
{
	int          i;
	int          nCount   = 2;
	int          nIds[]   = {ID_SEND};
	int          nState[] = {MFS_GRAYED};
	HMENU        hmenu;
	LPSTR        lpsz[]   = {"���M"};
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
//	���X�g�r���[������
//
//*****************************************************************************
int ListView_Init(HWND hwndListView)
{
	DWORD dwStyle;				// ListView�p�X�^�C��
	LVCOLUMN col;				// ListView�̃J����

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
	col.pszText = "IP�A�h���X";
	col.iSubItem = 1;
	SendMessage(hwndListView, LVM_INSERTCOLUMN, 1, (LPARAM)&col);

	col.cx = 50;
	col.pszText = "�|�[�g";
	col.iSubItem = 2;
	SendMessage(hwndListView, LVM_INSERTCOLUMN, 2, (LPARAM)&col);

	return 0;

}

//*****************************************************************************
//
//	�t�H���g���Z�b�g����
//
//*****************************************************************************
HFONT SetFont(LPCTSTR face, int h)
{
    HFONT hFont;
    hFont = CreateFont(h,			// �t�H���g����
        0,							// ������
        0,							// �e�L�X�g�̊p�x
        0,							// �x�[�X���C���Ƃ����Ƃ̊p�x
        FW_REGULAR,					// �t�H���g�̏d���i�����j
        FALSE,						// �C�^���b�N��
        FALSE,						// �A���_�[���C��
        FALSE,						// �ł�������
        SHIFTJIS_CHARSET,			// �����Z�b�g
        OUT_DEFAULT_PRECIS,			// �o�͐��x
        CLIP_DEFAULT_PRECIS,		// �N���b�s���O���x
        PROOF_QUALITY,				// �o�͕i��
        FIXED_PITCH | FF_MODERN,	// �s�b�`�ƃt�@�~���[
        face);						// ���̖�
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
// �T�[�o�[�Ƀ��O�C��
// ����
//		addr
//		���[�U�[��
//*****************************************************************************
void ServerLogIn(SOCKADDR_IN sa, char *lpszName, HWND hwndListView)
{
	int		i;				/* ���[�v�p�ϐ� */
	int		iHaving;		/* �T�ɃI�����C�����Ă��� */
    LV_ITEM item;
	char	szBuf[256];

	iHaving = 0;
	
	// �T�Ƀ��O�C�����Ă��邩�`�F�b�N
	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1 && strcmp(UserInfo[i].szName,lpszName) == 0) {
			iHaving = 1;
		}
	}

	// ���O�C�����Ă��Ȃ��ꍇ�A���X�g�ɒǉ�
	if (iHaving == 0) {
		// 
		for (i = 0; i < MAX_USER; i++) {
			if (UserInfo[i].OnlineEnabled == 0) {
				UserInfo[i].from = sa;
				UserInfo[i].OnlineEnabled = 1;
				strcpy(UserInfo[i].szName, lpszName);

				// ���X�g�Ƀ��[�U�[�ǉ�
				memset(&item, 0, sizeof(LV_ITEM));
				item.mask = LVIF_TEXT;
				item.pszText = lpszName;
				item.iItem = 0;
				item.iSubItem = 0;
				SendMessage(hwndListView, LVM_INSERTITEM, 0, (LPARAM)&item);

				item.pszText =  inet_ntoa(sa.sin_addr); //htonl(sa.sin_addr);
				item.iSubItem = 1;
				SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);

				sprintf(szBuf, "%d", htons((unsigned short)sa.sin_port));	// �|�[�g�ԍ��擾
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
// �T�[�o�[�Ƀ��O�A�E�g
// ����
//		addr	=	�N���C�A���g���\�P�b�g�n���h��
//		char *	=	���[�U�[��
//		HWND	=	���X�g�r���[�̃E�B���h�E�n���h��
//*****************************************************************************
void ServerLogOut(SOCKADDR_IN addr, char *lpszName, HWND hwndListView)
{
	int i;

	for (i = 0; i < MAX_USER; i++) {
		// �A�h���X�ƃ��[�U�[������v�����ꍇ
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
// �S�N���C�A���g�֑��M
// ����
//		addr
//		���[�U�[��
//		���X�g�r���[�̃E�B���h�E�n���h��
//*****************************************************************************
int all_send(SOCKET s, char *lpszMessage)
{
	int i;	

	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1)
			// �I�����C�����̃N���C�A���g�֑��M
			sendto(s, lpszMessage, (int)strlen(lpszMessage), 0, (SOCKADDR *)&UserInfo[i].from, (int)sizeof(UserInfo[i].from));
		}
	return 0;
}

//*****************************************************************************
// ���[�U�[���X�g�X�V
// ����
//		���X�g�r���[�̃E�B���h�E�n���h��
//*****************************************************************************
int ListView_ListUpdate(HWND hwndListView)
{
	int i;
    LV_ITEM item;
	char	szBuf[256];

    SendMessage(hwndListView, LVM_DELETEALLITEMS, 0, 0);
	for (i = 0; i < MAX_USER; i++) {
		if (UserInfo[i].OnlineEnabled == 1) {
			// ���X�g�Ƀ��[�U�[�ǉ�
			memset(&item, 0, sizeof(LV_ITEM));
			item.mask = LVIF_TEXT;
			item.pszText = UserInfo[i].szName;
			item.iItem = 0;
			item.iSubItem = 0;
			SendMessage(hwndListView, LVM_INSERTITEM, 0, (LPARAM)&item);

			item.pszText =  inet_ntoa(UserInfo[i].from.sin_addr); //htonl(sa.sin_addr);
			item.iSubItem = 1;
			SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);

			sprintf(szBuf, "%d", htons((unsigned short)UserInfo[i].from.sin_port));	// �|�[�g�ԍ��擾
			item.pszText = szBuf;
			item.iSubItem = 2;
			SendMessage(hwndListView, LVM_SETITEM, 0, (LPARAM)&item);
		}
	}
	return 0;
}