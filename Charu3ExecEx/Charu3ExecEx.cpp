// Charu3ExecEx.cpp : DLL 用の初期化処理の定義を行います。
//

#include "stdafx.h"
#include "Charu3ExecEx.h"
#include "ExeccmdDlg.h"
#include <locale.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

//
//	メモ!
//
//		この DLL が MFC DLL に対して動的にリンクされる場合、
//		MFC 内で呼び出されるこの DLL からエクスポートされた
//		どの関数も関数の最初に追加される AFX_MANAGE_STATE 
//		マクロを含んでいなければなりません。
//
//		例:
//
//		extern "C" BOOL PASCAL EXPORT ExportedFunction()
//		{
//			AFX_MANAGE_STATE(AfxGetStaticModuleState());
//			// 通常関数の本体はこの位置にあります
//		}
//
//		このマクロが各関数に含まれていること、MFC 内の
//		どの呼び出しより優先することは非常に重要です。
//		これは関数内の最初のステートメントでなければな
//		らないことを意味します、コンストラクタが MFC 
//		DLL 内への呼び出しを行う可能性があるので、オブ
//		ジェクト変数の宣言よりも前でなければなりません。
//
//		詳細については MFC テクニカル ノート 33 および
//		58 を参照してください。
//

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp

BEGIN_MESSAGE_MAP(CCharu3ExecExApp, CWinApp)
	//{{AFX_MSG_MAP(CCharu3ExecExApp)
		// メモ - ClassWizard はこの位置にマッピング用のマクロを追加または削除します。
		//        この位置に生成されるコードを編集しないでください。
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp の構築

CCharu3ExecExApp::CCharu3ExecExApp()
{
	// TODO: この位置に構築用のコードを追加してください。
	// ここに InitInstance の中の重要な初期化処理をすべて記述してください。
}

/////////////////////////////////////////////////////////////////////////////
// 唯一の CCharu3ExecExApp オブジェクト

CCharu3ExecExApp theApp;

/////////////////////////////////////////////////////////////////////////////
// プロトタイプ宣言

BOOL CreateChildProcess(TCHAR *strExecCmd, 
						HANDLE hChildStdin, HANDLE hChildStdout, HANDLE hChildStderr);
DWORD WINAPI ReadFromPipeThread(LPVOID lpvThreadParam);

/////////////////////////////////////////////////////////////////////////////
// 外部変数宣言

HANDLE hChildProcess = NULL;
BOOL bRunThread = TRUE;
TCHAR *strOutput = NULL;
size_t nNowBytes = 0;
int nMaxBytes = 0;
BOOL bBufferFull = FALSE;

/////////////////////////////////////////////////////////////////////////////
// Charu3用エクスポート関数
extern "C" __declspec (dllexport) bool CharuPlugIn
	(TCHAR *strSource, TCHAR *strResult, int nSize, STRING_DATA *data, void *pVoid)
{
	//*******************************************************************
	//	初期化
	//*******************************************************************
	_tsetlocale(LC_ALL, _T(""));
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	bool isRet = false;
#ifndef _UNICODE
	ZeroMemory(strResult, nSize);
#else
	ZeroMemory(strResult, nSize * 2);
#endif

	//*******************************************************************
	//	拡張文字列データから"ExecCmd=～"等を検索
	//*******************************************************************
	CString strMacro = data->m_strMacro;
	CString strExecCmd = _T("");
	CString strPrefix = _T("");
	CString strSuffix = _T("");
	BOOL bShowDialog = FALSE;
	TCHAR *strToken;

	strToken = _tcstok(strMacro.GetBuffer(strMacro.GetLength()), _T("\r\n"));
	while (strToken != NULL) {
		if (_tcsstr(strToken, _T("ExecCmd=")) != NULL) {
			strExecCmd = (strToken + 8);
		} else if (_tcsstr(strToken, _T("Prefix=")) != NULL) {
			strPrefix = (strToken + 7);
		} else if (_tcsstr(strToken, _T("Suffix=")) != NULL) {
			strSuffix = (strToken + 7);
		} else if (_tcsstr(strToken, _T("ShowDialog=yes")) != NULL) {
			bShowDialog = TRUE;
		}
		strToken = _tcstok(NULL, _T("\r\n"));
	}

	//*******************************************************************
	//	拡張文字列データに実行プログラムがないかShowDialog指定があればダイアログ表示
	//*******************************************************************
	if ((strExecCmd.GetLength() == 0) || bShowDialog) {
		CExeccmdDlg dlg;
		dlg.m_strExecCmd = strExecCmd;
		dlg.m_strPrefix = strPrefix;
		dlg.m_strSuffix = strSuffix;
		if (dlg.DoModal() == IDOK) {
			strExecCmd = dlg.m_strPrefix + dlg.m_strExecCmd + dlg.m_strSuffix;
		} else {
			return isRet;
		}
	} else {
		strExecCmd = strPrefix + strExecCmd + strSuffix;	// ShowDialogが無い場合は、Prefix + ExecCmd + Suffixで生成
	}
	//	実行プログラム指定がなければ終了
	if (strExecCmd.GetLength() == 0) {
		return isRet;
	}

	//*******************************************************************
	//	パイプ初期化
	//*******************************************************************
	HANDLE hOutputReadTmp, hOutputRead, hOutputWrite,
		   hInputWriteTmp, hInputRead, hInputWrite,
		   hErrorWrite;
	HANDLE hParent = GetCurrentProcess();
	SECURITY_ATTRIBUTES sa;
	sa.nLength = sizeof(SECURITY_ATTRIBUTES);
	sa.lpSecurityDescriptor = NULL;
	sa.bInheritHandle = TRUE;

	if (!CreatePipe(&hOutputReadTmp, &hOutputWrite, &sa, 0)) {
		AfxMessageBox(_T("標準出力パイプ作成に失敗しました。"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hOutputWrite, hParent, &hErrorWrite, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("標準エラー出力パイプ複製に失敗しました。"), MB_ICONERROR);
		return isRet;
	}
	if (!CreatePipe(&hInputRead, &hInputWriteTmp, &sa, 0)) {
		AfxMessageBox(_T("標準入力パイプ作成に失敗しました。"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hOutputReadTmp, hParent, &hOutputRead, 0, FALSE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("標準出力パイプ複製に失敗しました。"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hInputWriteTmp, hParent, &hInputWrite, 0, FALSE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("標準入力パイプ複製に失敗しました。"), MB_ICONERROR);
		return isRet;
	}
	CloseHandle(hOutputReadTmp);
	CloseHandle(hInputWriteTmp);

	//*******************************************************************
	//	指定プログラム起動
	//*******************************************************************
	if (!CreateChildProcess(strExecCmd.GetBuffer(strExecCmd.GetLength()), 
		                    hInputRead, hOutputWrite, hErrorWrite)) {
		return isRet;
	}
	CloseHandle(hInputRead);
	CloseHandle(hOutputWrite);
	CloseHandle(hErrorWrite);

	//*******************************************************************
	//	標準出力からの読み取りスレッド作成
	//*******************************************************************
	HANDLE hThread;
	DWORD dwThreadID;
	strOutput = strResult;
	nMaxBytes = nSize;
#ifdef _UNICODE
	nMaxBytes *= 2;
#endif
	
	if ((hThread = CreateThread(NULL, 0, ReadFromPipeThread, (LPVOID)hOutputRead, 0, &dwThreadID)) == NULL) {
		AfxMessageBox(_T("標準出力読み取りスレッド作成に失敗しました。"), MB_ICONERROR);
		return isRet;
	}

	//*******************************************************************
	//	標準入力への書き込み
	//*******************************************************************
	DWORD dwWroteBytes = 0;
	size_t nBytesToWrite = _tcslen(strSource);

#ifdef _UNICODE
	nBytesToWrite *= 2;
	//	BOM書き込み
	if (0 < nBytesToWrite) {
		WriteFile(hInputWrite, "\xFF\xFE", 2, &dwWroteBytes, NULL);
	}
#endif
	if (!WriteFile(hInputWrite, strSource, nBytesToWrite, &dwWroteBytes, NULL)) {
		if (GetLastError() != ERROR_BROKEN_PIPE) {
			AfxMessageBox(_T("標準入力書き込みに失敗しました。"), MB_ICONERROR);
			return isRet;
		}
	}
	CloseHandle(hInputWrite);

	//*******************************************************************
	//	起動プログラム/読み取りスレッド終了待ち
	//*******************************************************************
	if (WaitForSingleObject(hThread, INFINITE) == WAIT_FAILED) {
		AfxMessageBox(_T("読み取りスレッド監視に失敗しました。"), MB_ICONERROR);
	}
	CloseHandle(hOutputRead);

	//*******************************************************************
	//	終了
	//*******************************************************************
	Sleep(50);
	return isRet;
}

BOOL CreateChildProcess(TCHAR *strExecCmd, 
						HANDLE hChildStdin, HANDLE hChildStdout, HANDLE hChildStderr)
{
	//*******************************************************************
	//	指定プログラム起動
	//*******************************************************************
	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(STARTUPINFO));
	si.cb = sizeof(STARTUPINFO);
	si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
	si.hStdOutput = hChildStdout;
	si.hStdInput = hChildStdin;
	si.hStdError = hChildStderr;
	si.wShowWindow = SW_HIDE;
	if (!CreateProcess(NULL, strExecCmd, NULL, NULL, TRUE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi)) {
		CString strErrMsg;
		strErrMsg.Format(_T("指定プログラム起動に失敗しました。\n%s"), (LPCTSTR)strExecCmd);
		AfxMessageBox(strErrMsg, MB_ICONEXCLAMATION);
		return FALSE;
	}
	hChildProcess = pi.hProcess;
	CloseHandle(pi.hThread);

	return TRUE;
}

DWORD WINAPI ReadFromPipeThread(LPVOID lpvThreadParam)
{
	//*******************************************************************
	//	標準入力からの読み取り
	//*******************************************************************
	HANDLE hPipeRead = (HANDLE)lpvThreadParam;
	DWORD dwReadBytes;
	TCHAR strBuf[BUFFER_SIZE];
#ifndef _UNICODE
	DWORD dwBytesToRead = BUFFER_SIZE - 1;
#else
	DWORD dwBytesToRead = (BUFFER_SIZE - 1) * 2;
#endif

	for (;;) {
#ifndef _UNICODE
		ZeroMemory(strBuf, BUFFER_SIZE);
#else
		ZeroMemory(strBuf, BUFFER_SIZE*2);
#endif
		if (!ReadFile(hPipeRead, strBuf, dwBytesToRead, &dwReadBytes, NULL) || !dwReadBytes) {
			if (GetLastError() == ERROR_BROKEN_PIPE) {
				break;
			} else {
				AfxMessageBox(_T("標準出力からの読み取りに失敗しました。"), MB_ICONERROR);
				return FALSE;
			}
		}
		if (!bBufferFull) {
			if (nNowBytes + dwReadBytes < (unsigned int)nMaxBytes) {
				_tcscat(strOutput, strBuf);
				nNowBytes += dwReadBytes;
			} else {
				bBufferFull = TRUE;
				AfxMessageBox(_T("出力結果が大きすぎるため読み捨てます。"), MB_ICONINFORMATION);
#ifndef _UNICODE
				_tcsncat(strOutput, strBuf, nMaxBytes - nNowBytes - 1);
#else
				_tcsncat(strOutput, strBuf, (nMaxBytes - nNowBytes - 1) / 2);
#endif
				//	残りは処理させても仕方がないので子プロセス強制終了
				TerminateProcess(hChildProcess, 0);
			}
		}
	}

	return TRUE;
}
