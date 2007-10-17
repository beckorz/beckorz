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
'       2006/11/24 DATACOM うっちー
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
'
'※内部的に配列を増加させて保持しているため、ノード削除/追加を繰り返すと肥大化することに注意
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const cNULLINDEX As Integer = -1

'////////////////////////////////////////////////////////////////////////
'   列挙型宣言
'////////////////////////////////////////////////////////////////////////
Public Enum eSortOder
    Ascend
    Descend
End Enum

'////////////////////////////////////////////////////////////////////////
'   構造体宣言
'////////////////////////////////////////////////////////////////////////
'====   ２分探索木ノード
Private Type tBinaryTreeNode
    LIndex As Long
    RIndex As Long
    Key As Variant
End Type

'////////////////////////////////////////////////////////////////////////
'   メンバ変数
'////////////////////////////////////////////////////////////////////////
Private m_NodeCount As Long
Private m_RootIndex As Long
Private m_BT() As tBinaryTreeNode
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
    If m_NodeCount = 0 Then Exit Property
    ReDim m_NodeArray(m_NodeCount - 1)
    m_Depth = 0
    m_Order = iOrder
    Call GetSortedNodes(m_RootIndex)
    NodeArray = m_NodeArray
End Property

Public Property Get TreeText(Optional ByVal iNodeWidth As Integer = 0) As String
    m_TreeText = ""
    If m_NodeCount = 0 Then Exit Property
    m_Depth = 0
    m_Order = Descend
    m_Width = iNodeWidth
    Call GetTreeText(m_RootIndex)
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
Dim wIndex                      As Long
Dim wLastIndex                  As Long

    '********************************************************************
    '   初期化チェック＆ルートノード定義
    '********************************************************************
    If m_NodeCount = 0 Then
        m_NodeCount = 1
        m_RootIndex = 0
        Erase m_BT
        ReDim m_BT(0)
        With m_BT(0)
            .LIndex = cNULLINDEX
            .RIndex = cNULLINDEX
            .Key = iKey
        End With
        Add = True
        Exit Function
    End If
    
    '********************************************************************
    '   検索して末端ノード更新
    '********************************************************************
    If Find(iKey, wIndex) Then Exit Function
    wLastIndex = UBound(m_BT)
    With m_BT(wIndex)
        If iKey < .Key Then
            .LIndex = wLastIndex + 1
        Else
            .RIndex = wLastIndex + 1
        End If
    End With
    
    '********************************************************************
    '   ノード追加
    '********************************************************************
    ReDim Preserve m_BT(wLastIndex + 1)
    With m_BT(wLastIndex + 1)
        .LIndex = cNULLINDEX
        .RIndex = cNULLINDEX
        .Key = iKey
    End With
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
Dim wIndex                      As Long
Dim wPIndex                     As Long
Dim wMaxIndex                   As Long
Dim wMaxPIndex                  As Long

    '********************************************************************
    '   削除値検索
    '********************************************************************
    If m_NodeCount = 0 Then Exit Function
    If Not Find(iKey, wIndex, wPIndex) Then Exit Function
    
    '********************************************************************
    '   ノード再構築
    '********************************************************************
    If m_BT(wIndex).RIndex = cNULLINDEX Then
        '================================================================
        '   左にしかノードがない or 末端ノード
        '================================================================
        If wPIndex <> cNULLINDEX Then
            If iKey < m_BT(wPIndex).Key Then
                m_BT(wPIndex).LIndex = m_BT(wIndex).LIndex
            Else
                m_BT(wPIndex).RIndex = m_BT(wIndex).LIndex
            End If
        Else
            m_RootIndex = m_BT(wIndex).LIndex
        End If
    ElseIf m_BT(wIndex).LIndex = cNULLINDEX Then
        '================================================================
        '   右にしかノードがない
        '================================================================
        If wPIndex <> cNULLINDEX Then
            If iKey < m_BT(wPIndex).Key Then
                m_BT(wPIndex).LIndex = m_BT(wIndex).RIndex
            Else
                m_BT(wPIndex).RIndex = m_BT(wIndex).RIndex
            End If
        Else
            m_RootIndex = m_BT(wIndex).RIndex
        End If
    Else
        '================================================================
        '   両方にノードがある
        '================================================================
        '====   小さい方のノードから最大ノードを検索
        wMaxIndex = m_BT(wIndex).LIndex
        wMaxPIndex = wIndex
        Do While m_BT(wMaxIndex).RIndex <> cNULLINDEX
            wMaxPIndex = wMaxIndex
            wMaxIndex = m_BT(wMaxIndex).RIndex
        Loop
        '====   最大ノード位置に最大ノードの左リンクを詰める
        If m_BT(wMaxIndex).Key < m_BT(wMaxPIndex).Key Then
            m_BT(wMaxPIndex).LIndex = m_BT(wMaxIndex).LIndex
        Else
            m_BT(wMaxPIndex).RIndex = m_BT(wMaxIndex).LIndex
        End If
        '====   最大ノードを削除ノードのリンクに置換
        m_BT(wMaxIndex).LIndex = m_BT(wIndex).LIndex
        m_BT(wMaxIndex).RIndex = m_BT(wIndex).RIndex
        '====   削除ノード位置に最大ノードを配置
        If wPIndex <> cNULLINDEX Then
            If m_BT(wMaxIndex).Key < m_BT(wPIndex).Key Then
                m_BT(wPIndex).LIndex = wMaxIndex
            Else
                m_BT(wPIndex).RIndex = wMaxIndex
            End If
        Else
            m_RootIndex = wMaxIndex
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
    m_RootIndex = cNULLINDEX
    Erase m_BT
    
End Sub

Private Function Find(ByVal iKey As Variant, _
                      Optional ByRef oIndex As Long = cNULLINDEX, _
                      Optional ByRef oPIndex As Long = cNULLINDEX) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Find
'Explanation:ノードを検索する
'Arguments  :iKey               I   検索値
'           :oIndex             O   見つかった場合はそのインデックス、見つからない場合は親になるインデックス
'           :oPIndex            O   見つかった場合は親のインデックス、見つからない場合は親の親インデックス
'Return     :Boolean型(False:見つからない　True:見つかった)
'////////////////////////////////////////////////////////////////////////
Dim wIndex                      As Long

    '********************************************************************
    '   検索
    '********************************************************************
    If m_NodeCount = 0 Then Exit Function
    wIndex = m_RootIndex
    oPIndex = cNULLINDEX
    Do While wIndex <> cNULLINDEX
        Select Case m_BT(wIndex).Key
        Case Is > iKey  '====   検索値の方が小さい
            If m_BT(wIndex).LIndex = cNULLINDEX Then Exit Do
            oPIndex = wIndex
            wIndex = m_BT(wIndex).LIndex
        Case Is < iKey  '====   検索値の方が大きい
            If m_BT(wIndex).RIndex = cNULLINDEX Then Exit Do
            oPIndex = wIndex
            wIndex = m_BT(wIndex).RIndex
        Case iKey       '====   検索値発見
            Find = True
            Exit Do
        End Select
    Loop
    oIndex = wIndex
    
End Function

Private Sub GetSortedNodes(ByVal iIndex As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :GetSortedNodes
'Explanation:全ノードを再帰的に走査して配列に格納
'Arguments  :iIndex             I   走査開始インデックス
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ノード末端まで再帰的に全ノード走査
    '********************************************************************
    Select Case m_Order
    Case eSortOder.Ascend
        If m_BT(iIndex).LIndex <> cNULLINDEX Then
            Call GetSortedNodes(m_BT(iIndex).LIndex)
        End If
    Case eSortOder.Descend
        If m_BT(iIndex).RIndex <> cNULLINDEX Then
            Call GetSortedNodes(m_BT(iIndex).RIndex)
        End If
    End Select
    
    m_NodeArray(m_Depth) = m_BT(iIndex).Key
    m_Depth = m_Depth + 1
        
    Select Case m_Order
    Case eSortOder.Ascend
        If m_BT(iIndex).RIndex <> cNULLINDEX Then
            Call GetSortedNodes(m_BT(iIndex).RIndex)
        End If
    Case eSortOder.Descend
        If m_BT(iIndex).LIndex <> cNULLINDEX Then
            Call GetSortedNodes(m_BT(iIndex).LIndex)
        End If
    End Select
    
End Sub

Private Sub GetTreeText(ByVal iIndex As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :GetTreeText
'Explanation:全ノードを再帰的に走査して疑似ツリー状態で文字列に格納
'Arguments  :iIndex             I   走査開始インデックス
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ノード末端まで再帰的に全ノード走査
    '********************************************************************
    Select Case m_Order
    Case eSortOder.Ascend
        If m_BT(iIndex).LIndex <> cNULLINDEX Then
            m_Depth = m_Depth + 1
            Call GetTreeText(m_BT(iIndex).LIndex)
            m_Depth = m_Depth - 1
        End If
    Case eSortOder.Descend
        If m_BT(iIndex).RIndex <> cNULLINDEX Then
            m_Depth = m_Depth + 1
            Call GetTreeText(m_BT(iIndex).RIndex)
            m_Depth = m_Depth - 1
        End If
    End Select
    
    m_TreeText = m_TreeText & _
                 String$(m_Depth * m_Width, " ") & _
                 Format$(m_BT(iIndex).Key, String$(m_Width, "@")) & vbNewLine
    
    Select Case m_Order
    Case eSortOder.Ascend
        If m_BT(iIndex).RIndex <> cNULLINDEX Then
            m_Depth = m_Depth + 1
            Call GetTreeText(m_BT(iIndex).RIndex)
            m_Depth = m_Depth - 1
        End If
    Case eSortOder.Descend
        If m_BT(iIndex).LIndex <> cNULLINDEX Then
            m_Depth = m_Depth + 1
            Call GetTreeText(m_BT(iIndex).LIndex)
            m_Depth = m_Depth - 1
        End If
    End Select

End Sub
