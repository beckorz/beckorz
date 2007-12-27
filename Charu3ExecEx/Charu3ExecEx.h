// Charu3ExecEx.h : CHARU3EXECEX �A�v���P�[�V�����̃��C�� �w�b�_�[ �t�@�C���ł��B
//

#if !defined(AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_)
#define AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// ���C�� �V���{��

//---------------------------------------------------
// �f�[�^�\����
//---------------------------------------------------
struct STRING_DATA
{
	char	m_cKind;		//�f�[�^���
	char	m_cIcon;		//�A�C�R�����
	int		m_nMyID;		//�f�[�^��ID
	int		m_nParentID;	//�e�f�[�^��ID
	time_t	m_timeCreate;	//�쐬����
	time_t	m_timeEdit;		//�ύX����
	CString  m_strTitle;	//�ݒ�f�[�^�^�C�g��
	CString  m_strData;		//�ݒ�f�[�^������
	CString  m_strMacro;	//�g���p������f�[�^
};

//---------------------------------------------------
//	�萔
//---------------------------------------------------
#define	HIST_EXEC	_T("ExecCmd.hst")
#define HIST_MAX	50
#define BUFFER_SIZE 4096

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp
// ���̃N���X�̓���̒�`�Ɋւ��Ă� Charu3ExecEx.cpp �t�@�C�����Q�Ƃ��Ă��������B
//

class CCharu3ExecExApp : public CWinApp
{
public:
	CCharu3ExecExApp();

// �I�[�o�[���C�h
	// ClassWizard �͉��z�֐��̃I�[�o�[���C�h�𐶐����܂��B
	//{{AFX_VIRTUAL(CCharu3ExecExApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CCharu3ExecExApp)
		// ���� -  ClassWizard �͂��̈ʒu�Ƀ����o�֐���ǉ��܂��͍폜���܂��B
		//         ���̈ʒu�ɐ��������R�[�h��ҏW���Ȃ��ł��������B
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//---------------------------------------------------
//	�}�N��
//---------------------------------------------------
#define		MINVAL(x, y)	((x) < (y) ? (x) : (y))

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ �͑O�s�̒��O�ɒǉ��̐錾��}�����܂��B

#endif // !defined(AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_)
