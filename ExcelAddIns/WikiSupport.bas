Option Explicit

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   Wiki�A�h�C���c�[�� (WikiSupport.xla) + ��
'
'   << ���� >>
'   �{�� : http://www.ideamans.com/tool/wikisupportaddin.php
'   ��L�T�C�g����C���X�g�[����A����̃\�[�X�����ւ�
'   �����A�C���X�g�[���[�`������WikiSupport.xla���������ă\�[�X����ւ��Ďg���̂�����?
'   Documents and Settings\[���[�U�[��]\Application Data\Microsoft\AddIns\WikiSupport.xla
'
'   << �ύX���� >>
'   2007/08/07  beck    �{�� v0.81�����Ƀ\�[�X�œK��+�\���� | �����̃G�X�P�[�v�����Ή�
'                       ������(LEFT:)���f�t�H���g�Ƃ��Ė�����
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

'---�萔�錾
Private Const csTableSplitEscapeChar  As String = "&#x7c;"  ' �e�[�u���̕\�g�݂̃G�X�P�[�v����

Private Const csEditPopup   As String = "�ҏW(&E)"          ' �ҏW���j���[�|�b�v�A�b�v
Private Const csWikiPopup   As String = "Wiki(&K)"          ' Wiki���j���[�|�b�v�A�b�v

Private Const csCopyForWikiWithFormat       As String = "�����t��Wiki�`���ŃR�s�["  ' ���j���[���ږ�
Private Const csCopyForWikiWithFormatDesc   As String = "�I�������͈͂������t��Wiki�t�H�[�}�b�g�ɕϊ����ăR�s�[���܂�"  ' ���j���[���ڂ̉��

Private Const csCopyForWikiWithoutFormat        As String = "��������Wiki�`���ŃR�s�["  ' ���j���[���ږ�
Private Const csCopyForWikiWithoutFormatDesc    As String = "�I�������͈͂���������Wiki�t�H�[�}�b�g�ɕϊ����ăR�s�[���܂�"  ' ���j���[���ڂ̉��

'********************************************************************************
'   �����֐�
'********************************************************************************

'////////////////////////////////////////////////////////////////////////////////
'   �J���[�l��HTML��16�i���̕�����ɕϊ�
'////////////////////////////////////////////////////////////////////////////////
Private Function ToHexColor(color As Long) As String
    Dim sColor As String
    sColor = Hex(color)
    sColor = String(6 - Len(sColor), "0") & sColor
    
    '---R��B�̓���ւ�(MS�d�l��HTML�d�l�̈Ⴂ)
    sColor = Right(sColor, 2) & Mid(sColor, 3, 2) & Left(sColor, 2)
    ToHexColor = "#" & sColor
End Function

'////////////////////////////////////////////////////////////////////////////////
'   �I��͈͂�Wiki�`���e�L�X�g�ɕϊ����A�N���b�v�{�[�h�ɃR�s�[
'////////////////////////////////////////////////////////////////////////////////
Private Sub CopyForWiki(Optional ByVal bWithFormat As Boolean = True)
    Dim rng As Range
    Dim r As Integer, c As Integer, i As Integer, j As Integer
    Dim matrix() As String
    Dim wiki As String, original As String, align As String
    
    '---Wiki�e�L�X�g�p�̃o�b�t�@���m��
    ReDim matrix(selection.Rows.Count, selection.Columns.Count) As String
    
    '---�Z���𑖍�
    For r = 1 To selection.Rows.Count
        For c = 1 To selection.Columns.Count
            If matrix(r, c) <> ">" And matrix(r, c) <> "~" Then
                Set rng = selection.Cells(r, c)
                '---�l�̐ݒ�
                matrix(r, c) = Replace$(Trim$(rng.Text), vbLf, "&br;")      '
                matrix(r, c) = Replace$(matrix(r, c), "|", csTableSplitEscapeChar)  ' | �����̃G�X�P�[�v
                
                '---�������
                If bWithFormat Then
                    '---����
                    If rng.Font.Bold Then
                        matrix(r, c) = "''" & matrix(r, c) & "''"
                    End If
                    
                    '---�Α�
                    If rng.Font.Italic Then
                        matrix(r, c) = "'''" & matrix(r, c) & "'''"
                    End If
                    
                    '---�����
                    If rng.Font.Strikethrough Then
                        matrix(r, c) = "%%" & matrix(r, c) & "%%"
                    End If
                    
                    '---������
                    If rng.HorizontalAlignment = xlRight Or (rng.HorizontalAlignment = xlGeneral And IsNumeric(rng.Value)) Then
                        align = "RIGHT:"
                    ElseIf rng.HorizontalAlignment = xlCenter Then
                        align = "CENTER:"
                    Else
                        ' Left���f�t�H���g�Ƃ��Ė�����
                        'align = "LEFT:"
                        align = ""
                    End If
                    matrix(r, c) = align & matrix(r, c)
                    
                    '---�����F
                    If rng.Font.ColorIndex <> xlAutomatic Then
                        matrix(r, c) = "COLOR(" & ToHexColor(rng.Font.color) & "):" & matrix(r, c)
                    End If
                    
                    '---�w�i�F
                    If rng.Interior.Pattern = xlSolid And rng.Interior.ColorIndex <> xlAutomatic And rng.Interior.ColorIndex <> xlNone Then
                        matrix(r, c) = "BGCOLOR(" & ToHexColor(rng.Interior.color) & "):" & matrix(r, c)
                    End If
                End If
                
                '---�����Z��
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
                    
                    '---�����Z���̊O���փX�L�b�v
                    c = c + rng.MergeArea.Columns.Count - 1
                End If
                
            End If
        Next
    Next
    
    '---�p�C�v(|)��؂�ŘA��
    For r = 1 To selection.Rows.Count
        wiki = wiki & "|"
        For c = 1 To selection.Columns.Count
            wiki = wiki & matrix(r, c) & "|"
        Next
        wiki = wiki & vbNewLine
    Next
    
    '---�N���b�v�{�[�h�ɃR�s�[
    Dim cb As New DataObject
    cb.SetText wiki
    cb.PutInClipboard
End Sub

'********************************************************************************
'   ���J���\�b�h
'********************************************************************************

'////////////////////////////////////////////////////////////////////////////////
'   �I��͈͂������t��Wiki�`���e�L�X�g�ɕϊ����A�N���b�v�{�[�h�ɃR�s�[
'       (�E�N���b�N���j���[���� OnAction�Ŋ֘A�t��)
'////////////////////////////////////////////////////////////////////////////////
Public Sub CopyForWikiWithFormat()
    Call CopyForWiki(True)
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   �I��͈͂���������Wiki�`���e�L�X�g�ɕϊ����A�N���b�v�{�[�h�ɃR�s�[
'       (�E�N���b�N���j���[���� OnAction�Ŋ֘A�t��)
'////////////////////////////////////////////////////////////////////////////////
Public Sub CopyForWikiWithoutFormat()
    Call CopyForWiki(False)
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   �ǂݍ��ݎ�
'////////////////////////////////////////////////////////////////////////////////
Public Sub Auto_Open()
    Dim popup As CommandBarPopup, menuItem As CommandBarControl
    
    '********************************************************************************
    '   �E�N���b�N���j���[�֒ǉ�
    '********************************************************************************
    '---�E�N���b�N���j���[�ƕҏW�|�b�v�A�b�v���擾
    '---�擾�ł��Ȃ����Wiki�|�b�v�A�b�v��ǉ�
    On Error Resume Next
    
    Set popup = CommandBars.ActiveMenuBar.Controls(csEditPopup)
    If Err.Number Then
        Set popup = CommandBars.ActiveMenuBar.Controls.Add(csWikiPopup)
    End If
    
    On Error GoTo 0
    
    '---�|�b�v�A�b�v�Ƀ��j���[���ڂ�ǉ�
    '---�����t���R�s�[
    Set menuItem = popup.Controls.Add(msoControlButton, 1, , , True)
    With menuItem
        .Caption = csCopyForWikiWithFormat
        .OnAction = "Wiki.CopyForWikiWithFormat"
        .DescriptionText = csCopyForWikiWithFormatDesc
    End With
    
    menuItem.Copy CommandBars("Cell")
    
    '---���������R�s�[
    Set menuItem = popup.Controls.Add(msoControlButton, 1, , , True)
    With menuItem
        .Caption = csCopyForWikiWithoutFormat
        .OnAction = "Wiki.CopyForWikiWithoutFormat"
        .DescriptionText = csCopyForWikiWithoutFormatDesc
    End With
    
    menuItem.Copy CommandBars("Cell")
End Sub

'////////////////////////////////////////////////////////////////////////////////
'   �I����
'////////////////////////////////////////////////////////////////////////////////
Public Sub Auto_Close()
    Dim popup As CommandBarPopup, menuItem As CommandBarControl
    
    On Error Resume Next
    
    '********************************************************************************
    '   �E�N���b�N���j���[���폜
    '********************************************************************************
    '---�R���e�L�X�g���j���[����폜
    CommandBars("Cell").Controls(csCopyForWikiWithFormat).Delete
    CommandBars("Cell").Controls(csCopyForWikiWithoutFormat).Delete
    
    '---�ҏW�|�b�v�A�b�v�܂���Wiki�|�b�v�A�b�v���擾
    Set popup = CommandBars.ActiveMenuBar.Controls(csEditPopup)
    If Err.Number Then
        Err.Clear
        Set popup = CommandBars.ActiveMenuBar.Controls(csWikiPopup)
    End If
    
    '---�����𒆒f
    If Err.Number Then
        Exit Sub
    End If
    
    '---���j���[���ڂ��폜
    '---�����t���R�s�[
    popup.Controls(csCopyForWikiWithFormat).Delete
    '---���������R�s�[
    popup.Controls(csCopyForWikiWithoutFormat).Delete
    
    '---�g�ݍ��݂łȂ���΃|�b�v�A�b�v���폜
    If Not popup.BuiltIn Then
        popup.Delete
    End If
    
    On Error GoTo 0

End Sub
