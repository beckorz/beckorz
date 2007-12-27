#if !defined(AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_)
#define AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ExeccmdDlg.h : ヘッダー ファイル
//

/////////////////////////////////////////////////////////////////////////////
// CExeccmdDlg ダイアログ

#include "ACEdit.h"

class CExeccmdDlg : public CDialog
{
// コンストラクション
public:
	CExeccmdDlg(CWnd* pParent = NULL);   // 標準のコンストラクタ

// ダイアログ データ
	//{{AFX_DATA(CExeccmdDlg)
	enum { IDD = IDD_DIALOG_EXECCMD };
	CACEdit	m_cboExecCmd;
	CString	m_strExecCmd;
	CString	m_strPrefix;
	CString	m_strSuffix;
	//}}AFX_DATA


// オーバーライド
	// ClassWizard は仮想関数のオーバーライドを生成します。
	//{{AFX_VIRTUAL(CExeccmdDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV サポート
	//}}AFX_VIRTUAL

// インプリメンテーション
protected:

	// 生成されたメッセージ マップ関数
	//{{AFX_MSG(CExeccmdDlg)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ は前行の直前に追加の宣言を挿入します。

#endif // !defined(AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_)
