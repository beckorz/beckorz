// Charu3ExecEx.cpp : DLL �p�̏����������̒�`���s���܂��B
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
//	����!
//
//		���� DLL �� MFC DLL �ɑ΂��ē��I�Ƀ����N�����ꍇ�A
//		MFC ���ŌĂяo����邱�� DLL ����G�N�X�|�[�g���ꂽ
//		�ǂ̊֐����֐��̍ŏ��ɒǉ������ AFX_MANAGE_STATE 
//		�}�N�����܂�ł��Ȃ���΂Ȃ�܂���B
//
//		��:
//
//		extern "C" BOOL PASCAL EXPORT ExportedFunction()
//		{
//			AFX_MANAGE_STATE(AfxGetStaticModuleState());
//			// �ʏ�֐��̖{�̂͂��̈ʒu�ɂ���܂�
//		}
//
//		���̃}�N�����e�֐��Ɋ܂܂�Ă��邱�ƁAMFC ����
//		�ǂ̌Ăяo�����D�悷�邱�Ƃ͔��ɏd�v�ł��B
//		����͊֐����̍ŏ��̃X�e�[�g�����g�łȂ���΂�
//		��Ȃ����Ƃ��Ӗ����܂��A�R���X�g���N�^�� MFC 
//		DLL ���ւ̌Ăяo�����s���\��������̂ŁA�I�u
//		�W�F�N�g�ϐ��̐錾�����O�łȂ���΂Ȃ�܂���B
//
//		�ڍׂɂ��Ă� MFC �e�N�j�J�� �m�[�g 33 �����
//		58 ���Q�Ƃ��Ă��������B
//

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp

BEGIN_MESSAGE_MAP(CCharu3ExecExApp, CWinApp)
	//{{AFX_MSG_MAP(CCharu3ExecExApp)
		// ���� - ClassWizard �͂��̈ʒu�Ƀ}�b�s���O�p�̃}�N����ǉ��܂��͍폜���܂��B
		//        ���̈ʒu�ɐ��������R�[�h��ҏW���Ȃ��ł��������B
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp �̍\�z

CCharu3ExecExApp::CCharu3ExecExApp()
{
	// TODO: ���̈ʒu�ɍ\�z�p�̃R�[�h��ǉ����Ă��������B
	// ������ InitInstance �̒��̏d�v�ȏ��������������ׂċL�q���Ă��������B
}

/////////////////////////////////////////////////////////////////////////////
// �B��� CCharu3ExecExApp �I�u�W�F�N�g

CCharu3ExecExApp theApp;

/////////////////////////////////////////////////////////////////////////////
// �v���g�^�C�v�錾

BOOL CreateChildProcess(TCHAR *strExecCmd, 
						HANDLE hChildStdin, HANDLE hChildStdout, HANDLE hChildStderr);
DWORD WINAPI ReadFromPipeThread(LPVOID lpvThreadParam);

/////////////////////////////////////////////////////////////////////////////
// �O���ϐ��錾

HANDLE hChildProcess = NULL;
BOOL bRunThread = TRUE;
TCHAR *strOutput = NULL;
size_t nNowBytes = 0;
int nMaxBytes = 0;
BOOL bBufferFull = FALSE;

/////////////////////////////////////////////////////////////////////////////
// Charu3�p�G�N�X�|�[�g�֐�
extern "C" __declspec (dllexport) bool CharuPlugIn
	(TCHAR *strSource, TCHAR *strResult, int nSize, STRING_DATA *data, void *pVoid)
{
	//*******************************************************************
	//	������
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
	//	�g��������f�[�^����"ExecCmd=�`"��������
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
	//	�g��������f�[�^�Ɏ��s�v���O�������Ȃ���ShowDialog�w�肪����΃_�C�A���O�\��
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
		strExecCmd = strPrefix + strExecCmd + strSuffix;	// ShowDialog�������ꍇ�́APrefix + ExecCmd + Suffix�Ő���
	}
	//	���s�v���O�����w�肪�Ȃ���ΏI��
	if (strExecCmd.GetLength() == 0) {
		return isRet;
	}

	//*******************************************************************
	//	�p�C�v������
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
		AfxMessageBox(_T("�W���o�̓p�C�v�쐬�Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hOutputWrite, hParent, &hErrorWrite, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("�W���G���[�o�̓p�C�v�����Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}
	if (!CreatePipe(&hInputRead, &hInputWriteTmp, &sa, 0)) {
		AfxMessageBox(_T("�W�����̓p�C�v�쐬�Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hOutputReadTmp, hParent, &hOutputRead, 0, FALSE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("�W���o�̓p�C�v�����Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}
	if (!DuplicateHandle(hParent, hInputWriteTmp, hParent, &hInputWrite, 0, FALSE, DUPLICATE_SAME_ACCESS)) {
		AfxMessageBox(_T("�W�����̓p�C�v�����Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}
	CloseHandle(hOutputReadTmp);
	CloseHandle(hInputWriteTmp);

	//*******************************************************************
	//	�w��v���O�����N��
	//*******************************************************************
	if (!CreateChildProcess(strExecCmd.GetBuffer(strExecCmd.GetLength()), 
		                    hInputRead, hOutputWrite, hErrorWrite)) {
		return isRet;
	}
	CloseHandle(hInputRead);
	CloseHandle(hOutputWrite);
	CloseHandle(hErrorWrite);

	//*******************************************************************
	//	�W���o�͂���̓ǂݎ��X���b�h�쐬
	//*******************************************************************
	HANDLE hThread;
	DWORD dwThreadID;
	strOutput = strResult;
	nMaxBytes = nSize;
#ifdef _UNICODE
	nMaxBytes *= 2;
#endif
	
	if ((hThread = CreateThread(NULL, 0, ReadFromPipeThread, (LPVOID)hOutputRead, 0, &dwThreadID)) == NULL) {
		AfxMessageBox(_T("�W���o�͓ǂݎ��X���b�h�쐬�Ɏ��s���܂����B"), MB_ICONERROR);
		return isRet;
	}

	//*******************************************************************
	//	�W�����͂ւ̏�������
	//*******************************************************************
	DWORD dwWroteBytes = 0;
	size_t nBytesToWrite = _tcslen(strSource);

#ifdef _UNICODE
	nBytesToWrite *= 2;
	//	BOM��������
	if (0 < nBytesToWrite) {
		WriteFile(hInputWrite, "\xFF\xFE", 2, &dwWroteBytes, NULL);
	}
#endif
	if (!WriteFile(hInputWrite, strSource, nBytesToWrite, &dwWroteBytes, NULL)) {
		if (GetLastError() != ERROR_BROKEN_PIPE) {
			AfxMessageBox(_T("�W�����͏������݂Ɏ��s���܂����B"), MB_ICONERROR);
			return isRet;
		}
	}
	CloseHandle(hInputWrite);

	//*******************************************************************
	//	�N���v���O����/�ǂݎ��X���b�h�I���҂�
	//*******************************************************************
	if (WaitForSingleObject(hThread, INFINITE) == WAIT_FAILED) {
		AfxMessageBox(_T("�ǂݎ��X���b�h�Ď��Ɏ��s���܂����B"), MB_ICONERROR);
	}
	CloseHandle(hOutputRead);

	//*******************************************************************
	//	�I��
	//*******************************************************************
	Sleep(50);
	return isRet;
}

BOOL CreateChildProcess(TCHAR *strExecCmd, 
						HANDLE hChildStdin, HANDLE hChildStdout, HANDLE hChildStderr)
{
	//*******************************************************************
	//	�w��v���O�����N��
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
		strErrMsg.Format(_T("�w��v���O�����N���Ɏ��s���܂����B\n%s"), (LPCTSTR)strExecCmd);
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
	//	�W�����͂���̓ǂݎ��
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
				AfxMessageBox(_T("�W���o�͂���̓ǂݎ��Ɏ��s���܂����B"), MB_ICONERROR);
				return FALSE;
			}
		}
		if (!bBufferFull) {
			if (nNowBytes + dwReadBytes < (unsigned int)nMaxBytes) {
				_tcscat(strOutput, strBuf);
				nNowBytes += dwReadBytes;
			} else {
				bBufferFull = TRUE;
				AfxMessageBox(_T("�o�͌��ʂ��傫�����邽�ߓǂݎ̂Ă܂��B"), MB_ICONINFORMATION);
#ifndef _UNICODE
				_tcsncat(strOutput, strBuf, nMaxBytes - nNowBytes - 1);
#else
				_tcsncat(strOutput, strBuf, (nMaxBytes - nNowBytes - 1) / 2);
#endif
				//	�c��͏��������Ă��d�����Ȃ��̂Ŏq�v���Z�X�����I��
				TerminateProcess(hChildProcess, 0);
			}
		}
	}

	return TRUE;
}
