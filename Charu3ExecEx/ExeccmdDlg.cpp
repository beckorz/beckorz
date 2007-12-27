// ExeccmdDlg.cpp : インプリメンテーション ファイル
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
// CExeccmdDlg ダイアログ


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
// CExeccmdDlg メッセージ ハンドラ

BOOL CExeccmdDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: この位置に初期化の補足処理を追加してください
	CComboBox	*pCB_ExecCmd = (CComboBox *)GetDlgItem(IDC_COMBO_EXECCMD);
	CStdioFile	file;
	CString	strBuf;
	int	nCount;

	//*******************************************************************
	//	実行コマンドライン履歴ファイル読み込み
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
	//	デフォルト設定がなくて履歴があれば一番上のモノを選択済みに
	//*******************************************************************
	if ((0 < pCB_ExecCmd->GetCount()) && (m_strExecCmd.GetLength() ==0)) pCB_ExecCmd->SetCurSel(0);
	
	this->SetForegroundWindow();

	return TRUE;  // コントロールにフォーカスを設定しないとき、戻り値は TRUE となります
	              // 例外: OCX プロパティ ページの戻り値は FALSE となります
}

void CExeccmdDlg::OnOK() 
{
	// TODO: この位置にその他の検証用のコードを追加してください
	CComboBox	*pCB_ExecCmd = (CComboBox *)GetDlgItem(IDC_COMBO_EXECCMD);
	CStdioFile	file;
	CString	strBuf;
	int nCount, nListCount;

	//*******************************************************************
	//	実行コマンドライン履歴ファイル書き込み
	//*******************************************************************
	UpdateData();
	//	入力内容が既に履歴リストにあればリストの方を削除
	if ((nCount = pCB_ExecCmd->FindStringExact(-1, m_strExecCmd)) != CB_ERR) {
		pCB_ExecCmd->DeleteString(nCount);
	}
	//	履歴リストの１番上に追加して選択
	if (0 < m_strExecCmd.GetLength()) {
		pCB_ExecCmd->InsertString(0, m_strExecCmd);
		pCB_ExecCmd->SetCurSel(0);
	}
	//	ファイル書込
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
