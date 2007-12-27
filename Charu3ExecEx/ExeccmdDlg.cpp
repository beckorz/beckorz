// ExeccmdDlg.cpp : �C���v�������e�[�V���� �t�@�C��
//

#include "stdafx.h"
#include "Charu3ExecEx.h"
#include "ExeccmdDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CExeccmdDlg �_�C�A���O


CExeccmdDlg::CExeccmdDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExeccmdDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExeccmdDlg)
	m_strExecCmd = _T("");
	m_strPrefix = _T("");
	m_strSuffix = _T("");
	//}}AFX_DATA_INIT
}


void CExeccmdDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExeccmdDlg)
	DDX_Control(pDX, IDC_COMBO_EXECCMD, m_cboExecCmd);
	DDX_CBString(pDX, IDC_COMBO_EXECCMD, m_strExecCmd);
	DDX_Text(pDX, IDC_EDIT_PREFIX, m_strPrefix);
	DDX_Text(pDX, IDC_EDIT_SUFFIX, m_strSuffix);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CExeccmdDlg, CDialog)
	//{{AFX_MSG_MAP(CExeccmdDlg)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CExeccmdDlg ���b�Z�[�W �n���h��

BOOL CExeccmdDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: ���̈ʒu�ɏ������̕⑫������ǉ����Ă�������
	CComboBox	*pCB_ExecCmd = (CComboBox *)GetDlgItem(IDC_COMBO_EXECCMD);
	CStdioFile	file;
	CString	strBuf;
	int	nCount;

	//*******************************************************************
	//	���s�R�}���h���C�������t�@�C���ǂݍ���
	//*******************************************************************
	m_cboExecCmd.Init();
	m_cboExecCmd.SetMode();
	if (file.Open(HIST_EXEC, CStdioFile::modeRead) != NULL) {
		for (nCount = 0; nCount < HIST_MAX; nCount++) {
			if (!file.ReadString(strBuf)) break;
			pCB_ExecCmd->AddString(strBuf);
			m_cboExecCmd.AddSearchString(strBuf);
		}
		file.Close();
	}

	//*******************************************************************
	//	�f�t�H���g�ݒ肪�Ȃ��ė���������Έ�ԏ�̃��m��I���ς݂�
	//*******************************************************************
	if ((0 < pCB_ExecCmd->GetCount()) && (m_strExecCmd.GetLength() ==0)) pCB_ExecCmd->SetCurSel(0);
	
	this->SetForegroundWindow();

	return TRUE;  // �R���g���[���Ƀt�H�[�J�X��ݒ肵�Ȃ��Ƃ��A�߂�l�� TRUE �ƂȂ�܂�
	              // ��O: OCX �v���p�e�B �y�[�W�̖߂�l�� FALSE �ƂȂ�܂�
}

void CExeccmdDlg::OnOK() 
{
	// TODO: ���̈ʒu�ɂ��̑��̌��ؗp�̃R�[�h��ǉ����Ă�������
	CComboBox	*pCB_ExecCmd = (CComboBox *)GetDlgItem(IDC_COMBO_EXECCMD);
	CStdioFile	file;
	CString	strBuf;
	int nCount, nListCount;

	//*******************************************************************
	//	���s�R�}���h���C�������t�@�C����������
	//*******************************************************************
	UpdateData();
	//	���͓��e�����ɗ������X�g�ɂ���΃��X�g�̕����폜
	if ((nCount = pCB_ExecCmd->FindStringExact(-1, m_strExecCmd)) != CB_ERR) {
		pCB_ExecCmd->DeleteString(nCount);
	}
	//	�������X�g�̂P�ԏ�ɒǉ����đI��
	if (0 < m_strExecCmd.GetLength()) {
		pCB_ExecCmd->InsertString(0, m_strExecCmd);
		pCB_ExecCmd->SetCurSel(0);
	}
	//	�t�@�C������
	if (file.Open(HIST_EXEC, CStdioFile::modeCreate | CStdioFile::modeWrite) != NULL) {
		nListCount = MINVAL(pCB_ExecCmd->GetCount(), HIST_MAX);
		for (nCount = 0; nCount < nListCount; nCount++) {
			pCB_ExecCmd->GetLBText(nCount, strBuf);
			file.WriteString(strBuf + _T("\n"));
		}
		file.Close();
	}
	
	CDialog::OnOK();
}
