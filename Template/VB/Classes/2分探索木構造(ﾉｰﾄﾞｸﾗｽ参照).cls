VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_BinaryTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'２分探索木構造を表現するクラス
'   C_BinaryTree
'       2006/11/28 DATACOM うっちー
'       ・C_BinaryTreeNode.clsが必要です
'
'公開プロパティ
'NodeCount                  O   保持しているノード数を取得
'NodeArray                  O   保持しているノードを値の昇順/降順に格納した配列を取得
'TreeText                   O   保持しているノードを疑似ツリー状態のテキストで取得
'
'公開メソッド
'Add                        ２分探索木にノード追加
'Remove                     ２分探索木からノード削除
'RemoveAll                  ２分探索木からノード全削除
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   列挙型宣言
'////////////////////////////////////////////////////////////////////////
Public Enum eSortOder
    Ascend
    Descend
End Enum

'////////////////////////////////////////////////////////////////////////
'   メンバ変数
'////////////////////////////////////////////////////////////////////////
Private m_Root As C_BinaryTreeNode

Private m_NodeCount As Long
Private m_NodeArray() As Variant
Private m_Depth As Long
Private m_Order As eSortOder
Private m_Width As Integer
Private m_TreeText As String

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Property Get NodeCount() As Long
    NodeCount = m_NodeCount
End Property

Public Property Get NodeArray(Optional ByVal iOrder As eSortOder = Ascend) As Variant
Attribute NodeArray.VB_UserMemId = 0
    NodeArray = Array()
    If m_Root Is Nothing Then Exit Property
    ReDim m_NodeArray(m_NodeCount - 1)
    m_Depth = 0
    m_Order = iOrder
    Call GetSortedNodes(m_Root)
    NodeArray = m_NodeArray
End Property

Public Property Get TreeText(Optional ByVal iNodeWidth As Integer = 0) As String
    m_TreeText = ""
    If m_Root Is Nothing Then Exit Property
    m_Depth = 0
    m_Order = Descend
    m_Width = iNodeWidth
    Call GetTreeText(m_Root)
    TreeText = m_TreeText
End Property

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メソッド
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Function Add(ByVal iKey As Variant) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Add
'Explanation:２分探索木にノード追加
'Arguments  :iKey               I   追加値
'Return     :Boolean型(False:既に追加値が存在する　True:追加した)
'////////////////////////////////////////////////////////////////////////
Dim wNode                       As C_BinaryTreeNode
Dim wParentNode                 As C_BinaryTreeNode
Dim wNewNode                    As C_BinaryTreeNode

    '********************************************************************
    '   初期化チェック＆ルートノード定義
    '********************************************************************
    If m_Root Is Nothing Then
        m_NodeCount = 1
        Set m_Root = New C_BinaryTreeNode
        m_Root.Key = iKey
        Add = True
        Exit Function
    End If

    '********************************************************************
    '   検索して末端ノード更新
    '********************************************************************
    Set wNode = Find(iKey, wParentNode)
    If Not wNode Is Nothing Then Exit Function
    Set wNewNode = New C_BinaryTreeNode
    wNewNode.Key = iKey
    If iKey < wParentNode.Key Then
        Set wParentNode.LeftNode = wNewNode
    Else
        Set wParentNode.RightNode = wNewNode
    End If
    
    m_NodeCount = m_NodeCount + 1
    Add = True
    
End Function

Public Function Remove(ByVal iKey As Variant) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Remove
'Explanation:２分探索木からノード削除
'Arguments  :iKey               I   削除値
'Return     :Boolean型(False:削除値なし　True:削除した)
'////////////////////////////////////////////////////////////////////////
Dim wNode                       As C_BinaryTreeNode
Dim wParentNode                 As C_BinaryTreeNode
Dim wMaxNode                    As C_BinaryTreeNode
Dim wMaxParentNode              As C_BinaryTreeNode

    '********************************************************************
    '   削除ノード検索
    '********************************************************************
    If m_Root Is Nothing Then Exit Function
    Set wNode = Find(iKey, wParentNode)
    If wNode Is Nothing Then Exit Function
    
    '********************************************************************
    '   ノード再構築
    '********************************************************************
    If wNode.RightNode Is Nothing Then
        '================================================================
        '   左にしかノードがない or 末端ノード
        '================================================================
        If Not wParentNode Is Nothing Then
            If iKey < wParentNode.Key Then
                Set wParentNode.LeftNode = wNode.LeftNode
            Else
                Set wParentNode.RightNode = wNode.LeftNode
            End If
        Else
            Set m_Root = wNode.LeftNode
        End If
    ElseIf wNode.LeftNode Is Nothing Then
        '================================================================
        '   右にしかノードがない
        '================================================================
        If Not wParentNode Is Nothing Then
            If iKey < wParentNode.Key Then
                Set wParentNode.LeftNode = wNode.RightNode
            Else
                Set wParentNode.RightNode = wNode.RightNode
            End If
        Else
            Set m_Root = wNode.RightNode
        End If
    Else
        '================================================================
        '   両方にノードがある
        '================================================================
        '====   小さい方のノードから最大ノードを検索
        Set wMaxNode = wNode.LeftNode
        Set wMaxParentNode = wNode
        Do Until wMaxNode.RightNode Is Nothing
            Set wMaxParentNode = wMaxNode
            Set wMaxNode = wMaxNode.RightNode
        Loop
        '====   最大ノード位置に最大ノードの左リンクを詰める
        If wMaxNode.Key < wMaxParentNode.Key Then
            Set wMaxParentNode.LeftNode = wMaxNode.LeftNode
        Else
            Set wMaxParentNode.RightNode = wMaxNode.LeftNode
        End If
        '====   最大ノードを削除ノードのリンクに置換
        Set wMaxNode.LeftNode = wNode.LeftNode
        Set wMaxNode.RightNode = wNode.RightNode
        '====   削除ノード位置に最大ノードを配置
        If Not wParentNode Is Nothing Then
            If wMaxNode.Key < wParentNode.Key Then
                Set wParentNode.LeftNode = wMaxNode
            Else
                Set wParentNode.RightNode = wMaxNode
            End If
        Else
            Set m_Root = wMaxNode
        End If
    End If
    m_NodeCount = m_NodeCount - 1
    Remove = True
    
End Function

Public Sub RemoveAll()
'////////////////////////////////////////////////////////////////////////
'Name       :RemoveAll
'Explanation:２分探索木から全ノード削除
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    m_NodeCount = 0
    Set m_Root = Nothing
    
End Sub

Private Function Find(ByVal iKey As Variant, ByRef oParentNode As C_BinaryTreeNode) As C_BinaryTreeNode
'////////////////////////////////////////////////////////////////////////
'Name       :Find
'Explanation:ノードを検索する
'Arguments  :iKey               I   検索値
'           :oParentNode        O   見つかったノードの親ノード
'Return     :C_BinaryTreeNode型(見つかった場合はそのインスタンス、見つからない場合はNothing)
'////////////////////////////////////////////////////////////////////////
Dim wNode                       As C_BinaryTreeNode

    '********************************************************************
    '   検索
    '********************************************************************
    Set wNode = m_Root
    Do Until wNode Is Nothing
        Select Case wNode.Key
        Case Is > iKey  '====   検索値の方が小さい
            Set oParentNode = wNode
            Set wNode = wNode.LeftNode
        Case Is < iKey  '====   検索値の方が大きい
            Set oParentNode = wNode
            Set wNode = wNode.RightNode
        Case iKey       '====   発見
            Exit Do
        End Select
    Loop
    Set Find = wNode
    
End Function

Private Sub GetSortedNodes(ByRef iNode As C_BinaryTreeNode)
'////////////////////////////////////////////////////////////////////////
'Name       :GetSortedNodes
'Explanation:全ノードを再帰的に走査して配列に格納
'Arguments  :iNode              I   走査ノード
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ノード末端まで再帰的に全ノード走査
    '********************************************************************
    Select Case m_Order
    Case eSortOder.Ascend
        If Not iNode.LeftNode Is Nothing Then
            Call GetSortedNodes(iNode.LeftNode)
        End If
    Case eSortOder.Descend
        If Not iNode.RightNode Is Nothing Then
            Call GetSortedNodes(iNode.RightNode)
        End If
    End Select
    
    m_NodeArray(m_Depth) = iNode.Key
    m_Depth = m_Depth + 1
        
    Select Case m_Order
    Case eSortOder.Ascend
        If Not iNode.RightNode Is Nothing Then
            Call GetSortedNodes(iNode.RightNode)
        End If
    Case eSortOder.Descend
        If Not iNode.LeftNode Is Nothing Then
            Call GetSortedNodes(iNode.LeftNode)
        End If
    End Select
    
End Sub

Private Sub GetTreeText(ByRef iNode As C_BinaryTreeNode)
'////////////////////////////////////////////////////////////////////////
'Name       :GetTreeText
'Explanation:全ノードを再帰的に走査して疑似ツリー状態で文字列に格納
'Arguments  :iNode              I   走査ノード
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ノード末端まで再帰的に全ノード走査
    '********************************************************************
    Select Case m_Order
    Case eSortOder.Ascend
        If Not iNode.LeftNode Is Nothing Then
            m_Depth = m_Depth + 1
            Call GetTreeText(iNode.LeftNode)
            m_Depth = m_Depth - 1
        End If
    Case eSortOder.Descend
        If Not iNode.RightNode Is Nothing Then
            m_Depth = m_Depth + 1
            Call GetTreeText(iNode.RightNode)
            m_Depth = m_Depth - 1
        End If
    End Select
    
    m_TreeText = m_TreeText & _
                 String$(m_Depth * m_Width, " ") & _
                 Format$(iNode.Key, String$(m_Width, "@")) & vbNewLine
    
    Select Case m_Order
    Case eSortOder.Ascend
        If Not iNode.RightNode Is Nothing Then
            m_Depth = m_Depth + 1
            Call GetTreeText(iNode.RightNode)
            m_Depth = m_Depth - 1
        End If
    Case eSortOder.Descend
        If Not iNode.LeftNode Is Nothing Then
            m_Depth = m_Depth + 1
            Call GetTreeText(iNode.LeftNode)
            m_Depth = m_Depth - 1
        End If
    End Select

End Sub

