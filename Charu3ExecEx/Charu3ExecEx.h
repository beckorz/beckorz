// Charu3ExecEx.h : CHARU3EXECEX アプリケーションのメイン ヘッダー ファイルです。
//

#if !defined(AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_)
#define AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// メイン シンボル

//---------------------------------------------------
// データ構造体
//---------------------------------------------------
struct STRING_DATA
{
	char	m_cKind;		//データ種別
	char	m_cIcon;		//アイコン種別
	int		m_nMyID;		//データのID
	int		m_nParentID;	//親データのID
	time_t	m_timeCreate;	//作成日時
	time_t	m_timeEdit;		//変更日時
	CString  m_strTitle;	//設定データタイトル
	CString  m_strData;		//設定データ文字列
	CString  m_strMacro;	//拡張用文字列データ
};

//---------------------------------------------------
//	定数
//---------------------------------------------------
#define	HIST_EXEC	_T("ExecCmd.hst")
#define HIST_MAX	50
#define BUFFER_SIZE 4096

/////////////////////////////////////////////////////////////////////////////
// CCharu3ExecExApp
// このクラスの動作の定義に関しては Charu3ExecEx.cpp ファイルを参照してください。
//

class CCharu3ExecExApp : public CWinApp
{
public:
	CCharu3ExecExApp();

// オーバーライド
	// ClassWizard は仮想関数のオーバーライドを生成します。
	//{{AFX_VIRTUAL(CCharu3ExecExApp)
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CCharu3ExecExApp)
		// メモ -  ClassWizard はこの位置にメンバ関数を追加または削除します。
		//         この位置に生成されるコードを編集しないでください。
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//---------------------------------------------------
//	マクロ
//---------------------------------------------------
#define		MINVAL(x, y)	((x) < (y) ? (x) : (y))

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ は前行の直前に追加の宣言を挿入します。

#endif // !defined(AFX_CHARU3EXECEX_H__B84B11A6_910A_4FB7_B36D_837827E0F15D__INCLUDED_)
