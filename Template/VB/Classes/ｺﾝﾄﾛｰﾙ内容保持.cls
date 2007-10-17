VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_CheckControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'コントロール内容保持用クラス(C_CheckEditで内部的に使用)
'   C_CheckControl
'       2007/05/16 DATACOM うっちー
'
'公開プロパティ
'Control                    O   対象コントロール
'Memory                     X   保持内容
'SubInfo                    X   サブ情報
'
'公開メソッド
'Init                       チェック対象コントロール情報初期化
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_Control           As VB.Control
Public Memory               As Variant
Public SubInfo              As Variant

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ設定/参照
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Public Property Get Control() As VB.Control
    Set Control = m_Control
End Property

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メソッド
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Public Function Init(ByRef iControl As VB.Control, Optional ByVal iSubInfo As Variant) As C_CheckControl
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象コントロール情報初期化
'Arguments  :iControl           O   対象コントロール
'           :iSubInfo           I   サブ情報
'Return     :C_CheckControl型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    Set m_Control = iControl
    SubInfo = iSubInfo
    Set Init = Me
    
End Function
