Option Explicit

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   Wikiアドインツール (WikiSupport.xla) + α
'
'   << 注意 >>
'   本家 : http://www.ideamans.com/tool/wikisupportaddin.php
'   上記サイトからインストール後、これのソースを入れ替え
'   多分、インストーラー形式からWikiSupport.xlaだけ抜いてソース入れ替えて使うのもあり?
'   Documents and Settings\[ユーザー名]\Application Data\Microsoft\AddIns\WikiSupport.xla
'
'   << 変更履歴 >>
'   2007/08/07  beck    本家 v0.81を元にソース最適化+表内の | 文字のエスケープ処理対応
'                       左揃え(LEFT:)をデフォルトとして無効化
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

'---定数宣言
Private Const csTableSplitEscapeChar  As String = "&#x7c;"  ' テーブルの表組みのエスケープ文字

Private Const csEditPopup   As String = "編集(&E)"          ' 編集メニューポップアップ
Private Const csWikiPopup   As String = "Wiki(&K)"          ' Wikiメニューポップアップ

Private Const csCopyForWikiWithFormat       As String = "書式付きWiki形式でコピー"  ' メニュー項目名
Private Const csCopyForWikiWithFormatDesc   As String = "選択した範囲を書式付きWikiフォーマットに変換してコピーします"  ' メニュー項目の解説

Private Const csCopyForWikiWithoutFormat        As String = "書式無しWiki形式でコピー"  ' メニュー項目名
Private Const csCopyForWikiWithoutFormatDesc    As String = "選択した範囲を書式無しWikiフォーマットに変換してコピーします"  ' メニュー項目の解説

'********************************************************************************
'   内部関数
'********************************************************************************

'////////////////////////////////////////////////////////////////////////////////
'   カラー値をHTML式16進数の文字列に変換
'////////////////////////////////////////////////////////////////////////////////
Private Function ToHexColor(color As Long) As String
    Dim sColor As String
    sColor = Hex(color)
    sColor = String(6 - Len(sColor), "0") & sColor
    
    '---RとBの入れ替え(MS仕様とHTML仕様の違い)
    sColor = Right(sColor, 2) & Mid(sColor, 3, 2) & Left(sColor, 2)
    ToHexColor = "#" & sColor
End Function

'////////////////////////////////////////////////////////////////////////////////
'   選択範囲をWiki形式テキストに変換し、クリップボードにコピー
'////////////////////////////////////////////////////////////////////////////////
Private Sub CopyForWiki(Optional ByVal bWithFormat As Boolean = True)
    Dim rng As Range
    Dim r As Integer, c As Integer, i As Integer, j As Integer
    Dim matrix() As String
    Dim wiki As String, original As String, align As String
    
    '---Wikiテキスト用のバッファを確保
    ReDim matrix(selection.Rows.Count, selection.Columns.Count) As String
    
    '---セルを走査
    For r = 1 To selection.Rows.Count
        For c = 1 To selection.Columns.Count
            If matrix(r, c) <> ">" And matrix(r, c) <> "~" Then
                Set rng = selection.Cells(r, c)
                '---値の設定
                matrix(r, c) = Replace$(Trim$(rng.Text), vbLf, "&br;")      '
                matrix(r, c) = Replace$(matrix(r, c), "|", csTableSplitEscapeChar)  ' | 文字のエスケープ
                
                '---書式情報
                If bWithFormat Then
                    '---強調
                    If rng.Font.Bold Then
                        matrix(r, c) = "''" & matrix(r, c) & "''"
                    End If
                    
                    '---斜体
                    If rng.Font.Italic Then
                        matrix(r, c) = "'''" & matrix(r, c) & "'''"
                    End If
                    
                    '---取消線
                    If rng.Font.Strikethrough Then
                        matrix(r, c) = "%%" & matrix(r, c) & "%%"
                    End If
                    
                    '---文字寄せ
                    If rng.HorizontalAlignment = xlRight Or (rng.HorizontalAlignment = xlGeneral And IsNumeric(rng.Value)) Then
                        align = "RIGHT:"
                    ElseIf rng.HorizontalAlignment = xlCenter Then
                        align = "CENTER:"
                    Else
                        ' Leftをデフォルトとして無効化
                        'align = "LEFT:"
                        align = ""
                    End If
                    matrix(r, c) = align & matrix(r, c)
                    
                    '---文字色
                    If rng.Font.ColorIndex <> xlAutomatic Then
                        matrix(r, c) = "COLOR(" & ToHexColor(rng.Font.color) & "):" & matrix(r, c)
                    End If
                    
                    '---背景色
                    If rng.Interior.Pattern = xlSolid And rng.Interior.ColorIndex <> xlAutomatic And rng.Interior.ColorIndex <> xlNone Then
                        matrix(r, c) = "BGCOLOR(" & ToHexColor(rng.Interior.color) & "):" & matrix(r, c)
                    End If
                End If
                
                '---結合セル
                original = matrix(r, c)
                If rng.MergeCells Then
                    For i = 1 To rng.MergeArea.Rows.Count
                        For j = 1 To rng.MergeArea.Columns.Count
                            If i = 1 And j = rng.MergeArea.Columns.Count Then
                                matrix(r + i - 1, c + j - 1) = original
                            ElseIf i = 1 Then
                                matrix(r + i - 1, c + j - 1) = ">"
                            Else
                                matrix(r + i - 1, c + j - 1) = "~"
                            End If
                        Next
                    Next
                    
                    '---結合セルの外側へスキップ
                    c = c + rng.MergeArea.Columns.Count - 1
                End If
                
            End If
        Next
    Next
    
    '---パイプ(|)区切りで連結
    For r = 1 To selection.Rows.Count
        wiki = wiki & "|"
        For c = 1 To selection.Columns.Count
            wiki = wiki & matrix(r, c) & "|"
        Next
        wiki = wiki & vbNewLine
    Next
    
    '---クリップボードにコピー
    Dim cb As New DataObject
    cb.SetText wiki
    cb.PutInClipboard
End Sub

'********************************************************************************
'   公開メソッド
'********************************************************************************

'////////////////////////////////////////////////////////////////////////////////
'   選択範囲を書式付きWiki形式テキストに変換し、クリップボードにコピー
'       (右クリックメニューから OnActionで関連付け)
'////////////////////////////////////////////////////////////////////////////////
Public Sub CopyForWikiWithFormat()
    Call CopyForWiki(True)
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   選択範囲を書式無しWiki形式テキストに変換し、クリップボードにコピー
'       (右クリックメニューから OnActionで関連付け)
'////////////////////////////////////////////////////////////////////////////////
Public Sub CopyForWikiWithoutFormat()
    Call CopyForWiki(False)
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   読み込み時
'////////////////////////////////////////////////////////////////////////////////
Public Sub Auto_Open()
    Dim popup As CommandBarPopup, menuItem As CommandBarControl
    
    '********************************************************************************
    '   右クリックメニューへ追加
    '********************************************************************************
    '---右クリックメニューと編集ポップアップを取得
    '---取得できなければWikiポップアップを追加
    On Error Resume Next
    
    Set popup = CommandBars.ActiveMenuBar.Controls(csEditPopup)
    If Err.Number Then
        Set popup = CommandBars.ActiveMenuBar.Controls.Add(csWikiPopup)
    End If
    
    On Error GoTo 0
    
    '---ポップアップにメニュー項目を追加
    '---書式付きコピー
    Set menuItem = popup.Controls.Add(msoControlButton, 1, , , True)
    With menuItem
        .Caption = csCopyForWikiWithFormat
        .OnAction = "Wiki.CopyForWikiWithFormat"
        .DescriptionText = csCopyForWikiWithFormatDesc
    End With
    
    menuItem.Copy CommandBars("Cell")
    
    '---書式無しコピー
    Set menuItem = popup.Controls.Add(msoControlButton, 1, , , True)
    With menuItem
        .Caption = csCopyForWikiWithoutFormat
        .OnAction = "Wiki.CopyForWikiWithoutFormat"
        .DescriptionText = csCopyForWikiWithoutFormatDesc
    End With
    
    menuItem.Copy CommandBars("Cell")
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   終了時
'////////////////////////////////////////////////////////////////////////////////
Public Sub Auto_Close()
    Dim popup As CommandBarPopup, menuItem As CommandBarControl
    
    On Error Resume Next
    
    '********************************************************************************
    '   右クリックメニューを削除
    '********************************************************************************
    '---コンテキストメニューから削除
    CommandBars("Cell").Controls(csCopyForWikiWithFormat).Delete
    CommandBars("Cell").Controls(csCopyForWikiWithoutFormat).Delete
    
    '---編集ポップアップまたはWikiポップアップを取得
    Set popup = CommandBars.ActiveMenuBar.Controls(csEditPopup)
    If Err.Number Then
        Err.Clear
        Set popup = CommandBars.ActiveMenuBar.Controls(csWikiPopup)
    End If
    
    '---処理を中断
    If Err.Number Then
        Exit Sub
    End If
    
    '---メニュー項目を削除
    '---書式付きコピー
    popup.Controls(csCopyForWikiWithFormat).Delete
    '---書式無しコピー
    popup.Controls(csCopyForWikiWithoutFormat).Delete
    
    '---組み込みでなければポップアップも削除
    If Not popup.BuiltIn Then
        popup.Delete
    End If
    
    On Error GoTo 0

End Sub
