VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_CheckEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'コントロール内容編集チェッククラス
'   C_CheckEdit
'       2007/05/16 DATACOM うっちー
'
'公開プロパティ
'なし
'
'公開メソッド
'Add                        チェック対象コントロール追加
'Remove                     チェック対象からコントロールを削除
'Memorize                   チェック対象コントロールの既定プロパティを保持
'Check                      チェック対象コントロールの既定プロパティが編集済みかチェック
'Undo                       チェック対象コントロールの既定プロパティを保持内容に復帰
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   Win32API関数定義
'////////////////////////////////////////////////////////////////////////
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" _
    (ByVal hwnd As Long, _
    ByVal wMsg As Long, _
    ByVal wParam As Long, _
    lParam As Any) As Long

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const CB_SETCURSEL = &H14E

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_Controls          As Collection

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   イベントプロシージャ
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Explanation:クラスInitializeイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Collectionオブジェクトインスタンス作成
    '********************************************************************
    Set m_Controls = New Collection
    
End Sub

Private Sub Class_Terminate()
'////////////////////////////////////////////////////////////////////////
'Explanation:クラスTerminateイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Collectionオブジェクトインスタンス解放
    '********************************************************************
    Set m_Controls = Nothing
    
End Sub

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メソッド
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Public Sub Add(ByRef iControl As VB.Control, Optional ByVal iSubInfo As Variant)
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象コントロール追加
'Arguments  :iControl           O   対象コントロール
'           :iSubInfo           I   サブ情報
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Collection追加
    '********************************************************************
    m_Controls.Add NewControl.Init(iControl, iSubInfo)
    
End Sub

Public Sub Remove(Optional ByRef iControl As VB.Control)
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象からコントロールを削除
'Arguments  :iControl           O   対象コントロール(省略時は全コントロール)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   Collectionから削除
    '********************************************************************
    If iControl Is Nothing Then
        '================================================================
        '   全て削除
        '================================================================
        For wLpi = m_Controls.Count To 1 Step -1
            m_Controls.Remove wLpi
        Next
    Else
        '================================================================
        '   対象コントロールを削除
        '================================================================
        For wLpi = m_Controls.Count To 1 Step -1
            If m_Controls(wLpi).Control Is iControl Then
                m_Controls.Remove wLpi
                Exit For
            End If
        Next
    End If
    
End Sub

Public Sub Memorize(Optional ByRef iControl As VB.Control)
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象コントロールの既定プロパティを保持
'Arguments  :iControl           O   Memorize対象コントロール(省略時はチェック対象コントロール全て)
'////////////////////////////////////////////////////////////////////////
Dim wCheckControl               As C_CheckControl

    '********************************************************************
    '   Collection列挙＆既定プロパティ保持
    '********************************************************************
    For Each wCheckControl In m_Controls
        If (iControl Is Nothing) Or (wCheckControl.Control Is iControl) Then
            '============================================================
            '   種類別既定プロパティ保持(必要に応じて追加・修正)
            '============================================================
            With wCheckControl
                Select Case TypeName(.Control)
                Case "TextBox", "imText"
                    .Memory = .Control.Text
                Case "CheckBox", "OptionButton", "imNumber", "imNumLite", _
                     "imDate", "imTime", "imMask"
                    .Memory = .Control.Value
                Case "ComboBox", "ListBox"
                    .Memory = .Control.ListIndex
                Case "VSFlexGrid"
                    .Memory = .Control.Cell(0, 0, 0, .Control.Rows - 1, .Control.Cols - 1)
                End Select
            End With
        End If
    Next

End Sub

Public Function Check(Optional ByRef iControl As VB.Control, Optional ByRef oBeforeVal As Variant, Optional ByRef oSubInfo As Variant) As Boolean
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象コントロールの既定プロパティが編集済みかチェック
'Arguments  :iControl           O   Check対象コントロール(省略時はチェック対象コントロール全て)
'           :oBeforeVal         O   編集済みコントロールの編集前プロパティ値
'           :oSubInfo           O   編集済みコントロールのサブ情報
'Return     :Boolean型(True：編集済みコントロールあり False：編集済みコントロールなし)
'////////////////////////////////////////////////////////////////////////
Dim wCheckControl               As C_CheckControl

    '********************************************************************
    '   Collection列挙＆保持プロパティと現プロパティの比較
    '********************************************************************
    For Each wCheckControl In m_Controls
        If (iControl Is Nothing) Or (wCheckControl.Control Is iControl) Then
            '============================================================
            '   種類別保持プロパティ比較(必要に応じて追加・修正)
            '============================================================
            With wCheckControl
                Select Case TypeName(.Control)
                Case "TextBox", "imText"
                    If .Memory <> .Control.Text Then
                        oBeforeVal = .Memory
                        oSubInfo = .SubInfo
                        Check = True
                        Exit For
                    End If
                Case "CheckBox", "OptionButton", "imNumber", "imNumLite", _
                     "imDate", "imTime", "imMask"
                    If .Memory <> .Control.Value Then
                        oBeforeVal = .Memory
                        oSubInfo = .SubInfo
                        Check = True
                        Exit For
                    End If
                Case "ComboBox", "ListBox"
                    If .Memory <> .Control.ListIndex Then
                        oBeforeVal = .Memory
                        oSubInfo = .SubInfo
                        Check = True
                        Exit For
                    End If
                Case "VSFlexGrid"
                    If .Memory <> .Control.Cell(0, 0, 0, .Control.Rows - 1, .Control.Cols - 1) Then
                        oBeforeVal = .Memory
                        oSubInfo = .SubInfo
                        Check = True
                        Exit For
                    End If
                End Select
            End With
        End If
    Next
    
End Function

Public Sub Undo(Optional ByRef oControl As VB.Control)
'////////////////////////////////////////////////////////////////////////
'Explanation:チェック対象コントロールの既定プロパティを保持内容に復帰
'Arguments  :oControl           O   Undo対象コントロール(省略時はチェック対象コントロール全て)
'////////////////////////////////////////////////////////////////////////
Dim wCheckControl               As C_CheckControl

    '********************************************************************
    '   Collection列挙＆保持プロパティを復帰
    '********************************************************************
    If oControl Is Nothing Then
        '================================================================
        '   チェック対象コントロール全てを復帰
        '================================================================
        For Each wCheckControl In m_Controls
            Call UndoSub(wCheckControl)
        Next
    Else
        '================================================================
        '   指定Undo対象コントロールを復帰
        '================================================================
        For Each wCheckControl In m_Controls
            If wCheckControl.Control Is oControl Then
                Call UndoSub(wCheckControl)
                Exit For
            End If
        Next
    End If
    
End Sub

Private Sub UndoSub(ByRef iCtrlInfo As C_CheckControl)
'////////////////////////////////////////////////////////////////////////
'Explanation:Undo用サブルーチン
'Arguments  :iCtrlInfo          O   Undo対象コントロール情報
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   種類別保持プロパティ復帰(必要に応じて追加・修正)
    '********************************************************************
    With iCtrlInfo
        Select Case TypeName(.Control)
        Case "TextBox", "imText"
            .Control.Text = .Memory
        Case "CheckBox", "OptionButton", "imNumber", "imNumLite", _
             "imDate", "imTime", "imMask"
            .Control.Value = .Memory
        Case "ComboBox"
            '====   Clickイベントを発生させないようにSendMessageで処理
            Call SendMessage(.Control.hwnd, CB_SETCURSEL, .Memory, ByVal 0)
        Case "ListBox"
            .Control.ListIndex = .Memory
        Case "VSFlexGrid"
            .Control.Cell(0, 0, 0, .Control.Rows - 1, .Control.Cols - 1) = .Memory
        End Select
    End With
    
End Sub

Private Function NewControl() As C_CheckControl
'////////////////////////////////////////////////////////////////////////
'Explanation:インスタンス作成と同時にメソッド実行用中間メソッド
'Return     :C_CheckControl型
'////////////////////////////////////////////////////////////////////////
    
    Set NewControl = New C_CheckControl
    
End Function

