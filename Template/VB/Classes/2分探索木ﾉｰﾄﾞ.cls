VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_BinaryTreeNode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'２分探索木のノードを表現するクラス
'   C_BinaryTreeNode
'       2006/11/28 DATACOM うっちー
'
'公開プロパティ
'LeftNode                   X   左(小さい方)のノードを設定・取得
'RightNode                  X   右(大きい方)のノードを設定・取得
'Key                        X   ノード値を設定・取得
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   メンバ変数
'////////////////////////////////////////////////////////////////////////
Private m_LeftNode As C_BinaryTreeNode
Private m_RightNode As C_BinaryTreeNode
Private m_Key As Variant

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Property Set LeftNode(ByRef iNode As C_BinaryTreeNode)
    Set m_LeftNode = iNode
End Property
Public Property Get LeftNode() As C_BinaryTreeNode
    Set LeftNode = m_LeftNode
End Property

Public Property Set RightNode(ByRef iNode As C_BinaryTreeNode)
    Set m_RightNode = iNode
End Property
Public Property Get RightNode() As C_BinaryTreeNode
    Set RightNode = m_RightNode
End Property

Public Property Let Key(ByRef iKey As Variant)
    m_Key = iKey
End Property
Public Property Get Key() As Variant
    Key = m_Key
End Property
