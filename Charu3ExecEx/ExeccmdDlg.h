#if !defined(AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_)
#define AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ExeccmdDlg.h : �w�b�_�[ �t�@�C��
//

/////////////////////////////////////////////////////////////////////////////
// CExeccmdDlg �_�C�A���O

#include "ACEdit.h"

class CExeccmdDlg : public CDialog
{
// �R���X�g���N�V����
public:
	CExeccmdDlg(CWnd* pParent = NULL);   // �W���̃R���X�g���N�^

// �_�C�A���O �f�[�^
	//{{AFX_DATA(CExeccmdDlg)
	enum { IDD = IDD_DIALOG_EXECCMD };
	CACEdit	m_cboExecCmd;
	CString	m_strExecCmd;
	CString	m_strPrefix;
	CString	m_strSuffix;
	//}}AFX_DATA


// �I�[�o�[���C�h
	// ClassWizard �͉��z�֐��̃I�[�o�[���C�h�𐶐����܂��B
	//{{AFX_VIRTUAL(CExeccmdDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV �T�|�[�g
	//}}AFX_VIRTUAL

// �C���v�������e�[�V����
protected:

	// �������ꂽ���b�Z�[�W �}�b�v�֐�
	//{{AFX_MSG(CExeccmdDlg)
	virtual BOOL OnInitDialog();
	virtual void OnOK();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ �͑O�s�̒��O�ɒǉ��̐錾��}�����܂��B

#endif // !defined(AFX_EXECCMDDLG_H__B9A095EE_1F2A_44C3_86CF_6F2DEA3A3925__INCLUDED_)
