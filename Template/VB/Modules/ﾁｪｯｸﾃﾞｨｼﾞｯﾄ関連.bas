Attribute VB_Name = "M_CheckDigit"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'�e��`�F�b�N�f�B�W�b�g�Z�o�E�`�F�b�N���W���[��
'   M_CheckDigit
'       2006/11/29 DATACOM �������[
'
'�Ή��`�F�b�N�f�B�W�b�g
'�E7�`�F�b�N DR/DSR
'�E9�`�F�b�N DR/DSR
'�E���W�����X10 DR/DSR/���[���Y����
'�E���W�����X11 DR/DSR
'�E���W�����X10 �E�F�C�g3(JAN)
'�E���W�����X16(NW-7)
'�E���W�����X43(CODE39)
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   �萔�錾
'////////////////////////////////////////////////////////////////////////
Private Const cCODE_MAXLENGTH As Integer = 15   '�`�F�b�N�f�B�W�b�g���܂܂Ȃ��R�[�h�̍ő咷
Private Const cMOD16_CHARS As String = "0123456789-$:/.+ABCD"   '���W�����X16�p�ϊ�������
Private Const cMOD43_CHARS As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%"    '���W�����X43�p�ϊ�������

'////////////////////////////////////////////////////////////////////////
'   �񋓌^�錾
'////////////////////////////////////////////////////////////////////////
'====   ���W�����X11�̃T�u�I�v�V����
Public Enum eMod11_SubOption
    OptionCard03    'DR�̏ꍇ�͗]��0/1/10�ɑ΂���1/1/0�ADSR�̏ꍇ��1/0/1��C/D�Ƃ���(DSR�̃f�t�H���g)
    OptionCard04    'DR�̏ꍇ�͗]��0/1/10�ɑ΂���0/1/0�ADSR�̏ꍇ��0/0/1��C/D�Ƃ���(DR�̃f�t�H���g)
    OptionCard23    'DR�̏ꍇ�͗]��0/1/10�ɑ΂���1/1/1�ADSR�̏ꍇ��03�Ɠ���1/0/1��C/D�Ƃ���
End Enum

Private Function CD_ContainsInvalidNumericChar(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_ContainsInvalidNumericChar
'Explanation:�R�[�h�ɐ��l�ȊO�̕����񂪊܂܂�Ă��邩�`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(���l�ȊO�̕��������݂����True��Ԃ�)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   �`�F�b�N
    '********************************************************************
    For wLpi = 1 To Len(iCode)
        If InStr("0123456789", Mid$(iCode, wLpi, 1)) = 0 Then
            CD_ContainsInvalidNumericChar = True
            Exit For
        End If
    Next
    
End Function

Private Function CD_ContainsInvalidMod16Char(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_ContainsInvalidMod16Char
'Explanation:�R�[�h�Ƀ��W�����X16�p�ϊ�������Ƃ��ĕs�K�؂ȕ����񂪊܂܂�Ă��邩�`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(�s�K�؂ȕ��������݂����True��Ԃ�)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   �`�F�b�N
    '********************************************************************
    iCode = UCase$(iCode)
    '====   �擪�Ɩ�����A�`D�̂�
    If InStr("ABCD", Left$(iCode, 1)) = 0 Then
        CD_ContainsInvalidMod16Char = True
        Exit Function
    End If
    If InStr("ABCD", Right$(iCode, 1)) = 0 Then
        CD_ContainsInvalidMod16Char = True
        Exit Function
    End If
    '====   ����ȊO�͐��l�̂�
    For wLpi = 2 To Len(iCode) - 1
        If InStr("0123456789", Mid$(iCode, wLpi, 1)) = 0 Then
            CD_ContainsInvalidMod16Char = True
            Exit For
        End If
    Next
    
End Function

Private Function CD_ContainsInvalidMod43Char(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_ContainsInvalidMod43Char
'Explanation:�R�[�h�Ƀ��W�����X43�p�ϊ�������ȊO�̕����񂪊܂܂�Ă��邩�`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(�ϊ�������ȊO�̕��������݂����True��Ԃ�)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   �`�F�b�N
    '********************************************************************
    iCode = UCase$(iCode)
    For wLpi = 1 To Len(iCode)
        If InStr(cMOD43_CHARS, Mid$(iCode, wLpi, 1)) = 0 Then
            CD_ContainsInvalidMod43Char = True
            Exit For
        End If
    Next

End Function

Public Function CD_Get7DR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get7DR
'Explanation:7�`�F�b�NDR��C/D��Ԃ�(�R�[�h��7�Ŋ������]��)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or CD_ContainsInvalidNumericChar(iCode) Then Exit Function
    CD_Get7DR = Val(iCode) Mod 7
    
End Function

Public Function CD_IsValid7DR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid7DR
'Explanation:7�`�F�b�NDR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid7DR = (Right$(iCode, 1) = CD_Get7DR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get7DSR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get7DSR
'Explanation:7�`�F�b�NDSR��C/D��Ԃ�(�R�[�h��7�Ŋ������]���7�������)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   7�`�F�b�NDR���ʂ��g�p
    '********************************************************************
    wCD = CD_Get7DR(iCode)
    If 0 < Len(wCD) Then
        CD_Get7DSR = 7 - Val(wCD)
    End If
    
End Function

Public Function CD_IsValid7DSR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid7DSR
'Explanation:7�`�F�b�NDSR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid7DSR = (Right$(iCode, 1) = CD_Get7DSR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get9DR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get9DR
'Explanation:9�`�F�b�NDR��C/D��Ԃ�(�R�[�h�̊e���̑��a��9�Ŋ������]��)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or CD_ContainsInvalidNumericChar(iCode) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + Val(Mid$(iCode, wLpi, 1))
    Next
    CD_Get9DR = wNum Mod 9
    
End Function

Public Function CD_IsValid9DR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid9DR
'Explanation:9�`�F�b�NDR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid9DR = (Right$(iCode, 1) = CD_Get9DR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get9DSR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get9DSR
'Explanation:9�`�F�b�NDSR��C/D��Ԃ�(�R�[�h�̊e���̑��a��9�Ŋ������]���9�������)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   9�`�F�b�NDR���ʂ��g�p
    '********************************************************************
    wCD = CD_Get9DR(iCode)
    If 0 < Len(wCD) Then
        CD_Get9DSR = 9 - Val(wCD)
    End If

End Function

Public Function CD_IsValid9DSR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid9DSR
'Explanation:9�`�F�b�NDSR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid9DSR = (Right$(iCode, 1) = CD_Get9DSR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_GetMod10DR(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10DR
'Explanation:���W�����X10DR��C/D��Ԃ�(�R�[�h�̊e���ɃE�F�C�g����Z���A���̐ς̑��a��10�Ŋ������]��)
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or Len(iCode) <> Len(iWait) Or _
        CD_ContainsInvalidNumericChar(iCode) Or CD_ContainsInvalidNumericChar(iWait) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + (Val(Mid$(iCode, wLpi, 1)) * Val(Mid$(iWait, wLpi, 1)))
    Next
    CD_GetMod10DR = wNum Mod 10

End Function

Public Function CD_IsValidMod10DR(ByVal iCode As String, ByVal iWait As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod10DR
'Explanation:���W�����X10DR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod10DR = (Right$(iCode, 1) = CD_GetMod10DR(Left$(iCode, Len(iCode) - 1), iWait))
    
End Function

Public Function CD_GetMod10DSR(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10DSR
'Explanation:���W�����X10DSR��C/D��Ԃ�(�R�[�h�̊e���ɃE�F�C�g����Z���A���̐ς̑��a��10�Ŋ������]���10�������)
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   ���W�����X10DR���ʂ��g�p
    '********************************************************************
    wCD = CD_GetMod10DR(iCode, iWait)
    If 0 < Len(wCD) Then
        CD_GetMod10DSR = ((10 - Val(wCD)) Mod 10)
    End If

End Function

Public Function CD_IsValidMod10DSR(ByVal iCode As String, ByVal iWait As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod10DSR
'Explanation:���W�����X10DSR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod10DSR = (Right$(iCode, 1) = CD_GetMod10DSR(Left$(iCode, Len(iCode) - 1), iWait))

End Function

Public Function CD_GetMod10Luhn(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10Luhn
'Explanation:���W�����X10���[���Y������C/D��Ԃ�(�R�[�h�̊e���ɃE�F�C�g����Z���A���̐ς̊e���̑��a��10�Ŋ������]���10�������)
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wStr                        As String
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or Len(iCode) <> Len(iWait) Or _
        CD_ContainsInvalidNumericChar(iCode) Or CD_ContainsInvalidNumericChar(iWait) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wStr = wStr & (Val(Mid$(iCode, wLpi, 1)) * Val(Mid$(iWait, wLpi, 1)))
    Next
    For wLpi = 1 To Len(wStr)
        wNum = wNum + Val(Mid$(wStr, wLpi, 1))
    Next
    CD_GetMod10Luhn = (10 - (wNum Mod 10)) Mod 10

End Function

Public Function CD_IsValidMod10Luhn(ByVal iCode As String, ByVal iWait As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod10Luhn
'Explanation:���W�����X10���[���Y������C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod10Luhn = (Right$(iCode, 1) = CD_GetMod10Luhn(Left$(iCode, Len(iCode) - 1), iWait))

End Function

Public Function CD_GetMod11DR(ByVal iCode As String, ByVal iWait As String, _
                              Optional ByVal iSubOption As eMod11_SubOption = OptionCard04) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod11DR
'Explanation:���W�����X11DR��C/D��Ԃ�(�R�[�h�̊e���ɃE�F�C�g����Z���A���̐ς̑��a��11�Ŋ������]��)
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'           :iSubOption         I   �T�u�I�v�V����
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long
Dim wModulus                    As Long
Dim wCD                         As String

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or Len(iCode) <> Len(iWait) Or _
        CD_ContainsInvalidNumericChar(iCode) Or CD_ContainsInvalidNumericChar(iWait) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + (Val(Mid$(iCode, wLpi, 1)) * Val(Mid$(iWait, wLpi, 1)))
    Next
    wModulus = wNum Mod 11
    Select Case wModulus
    Case 0
        Select Case iSubOption
        Case OptionCard03: wCD = "1"
        Case OptionCard04: wCD = "0"
        Case OptionCard23: wCD = "1"
        End Select
    Case 1
        wCD = "1"
    Case 10
        Select Case iSubOption
        Case OptionCard03: wCD = "0"
        Case OptionCard04: wCD = "0"
        Case OptionCard23: wCD = "1"
        End Select
    Case Else
        wCD = wModulus
    End Select
    CD_GetMod11DR = wCD

End Function

Public Function CD_IsValidMod11DR(ByVal iCode As String, ByVal iWait As String, _
                                  Optional ByVal iSubOption As eMod11_SubOption = OptionCard04) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod11DR
'Explanation:���W�����X11DR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'           :iSubOption         I   �T�u�I�v�V����
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod11DR = (Right$(iCode, 1) = CD_GetMod11DR(Left$(iCode, Len(iCode) - 1), iWait, iSubOption))

End Function

Public Function CD_GetMod11DSR(ByVal iCode As String, ByVal iWait As String, _
                               Optional ByVal iSubOption As eMod11_SubOption = OptionCard03) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod11DSR
'Explanation:���W�����X11DSR��C/D��Ԃ���C/D��Ԃ�(�R�[�h�̊e���ɃE�F�C�g����Z���A���̐ς̑��a��11�Ŋ������]���11�������)
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'           :iSubOption         I   �T�u�I�v�V����
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long
Dim wModulus                    As Long
Dim wCD                         As String

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or Len(iCode) <> Len(iWait) Or _
        CD_ContainsInvalidNumericChar(iCode) Or CD_ContainsInvalidNumericChar(iWait) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + (Val(Mid$(iCode, wLpi, 1)) * Val(Mid$(iWait, wLpi, 1)))
    Next
    wModulus = wNum Mod 11
    Select Case wModulus
    Case 0
        Select Case iSubOption
        Case OptionCard03: wCD = "1"
        Case OptionCard04: wCD = "0"
        Case OptionCard23: wCD = "1"
        End Select
    Case 1
        wCD = "0"
    Case 10
        wCD = "1"
    Case Else
        wCD = (11 - wModulus)
    End Select
    CD_GetMod11DSR = wCD

End Function

Public Function CD_IsValidMod11DSR(ByVal iCode As String, ByVal iWait As String, _
                                   Optional ByVal iSubOption As eMod11_SubOption = OptionCard03) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod11DSR
'Explanation:���W�����X11DSR��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'           :iWait              I   �E�F�C�g
'           :iSubOption         I   �T�u�I�v�V����
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < iCode Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod11DSR = (Right$(iCode, 1) = CD_GetMod11DSR(Left$(iCode, Len(iCode) - 1), iWait, iSubOption))

End Function

Public Function CD_GetJAN(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetJAN
'Explanation:���W�����X10�E�F�C�g3(JAN)��C/D��Ԃ�(���W�����X10DSR�ŃE�F�C�g���E����3,1,3,1,�c�Ƃ������̂ɓ���)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wFlag                       As Boolean
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or CD_ContainsInvalidNumericChar(iCode) Then Exit Function
    For wLpi = Len(iCode) To 1 Step -1
        If wFlag Then
            wNum = wNum + (Val(Mid$(iCode, wLpi, 1)))
        Else
            wNum = wNum + (Val(Mid$(iCode, wLpi, 1)) * 3)
        End If
        wFlag = Not wFlag
    Next
    CD_GetJAN = ((10 - (wNum Mod 10)) Mod 10)

End Function

Public Function CD_IsValidJAN(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidJAN
'Explanation:���W�����X10�E�F�C�g3(JAN)��C/D���`�F�b�N����
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :Boolean�^(C/D���������Ȃ��ꍇ�ƃR�[�h����������ꍇ��False��Ԃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�`�F�b�N
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValidJAN = (Right$(iCode, 1) = CD_GetJAN(Left$(iCode, Len(iCode) - 1)))

End Function

Public Function CD_GetMod16(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod16
'Explanation:���W�����X16(NW-7)��C/D��Ԃ�(�X�^�[�g�E�X�g�b�v�R�[�h���܂ޑS���𐔒l�ϊ��������a��16�Ŋ������]���16��������ĕ����ϊ����Ȃ���)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = UCase$(Trim$(iCode))
    If Len(iCode) < 3 Or cCODE_MAXLENGTH + 2 < Len(iCode) Or CD_ContainsInvalidMod16Char(iCode) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + (InStr(cMOD16_CHARS, Mid$(iCode, wLpi, 1)) - 1)
    Next
    CD_GetMod16 = Mid$(cMOD16_CHARS, 17 - (wNum Mod 16), 1)

End Function

Public Function CD_GetMod43(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod43
'Explanation:���W�����X43(CODE39)��C/D��Ԃ�(�X�^�[�g�E�X�g�b�v�R�[�h���������l�ϊ������e���̑��a��43�Ŋ������]��𕶎��ϊ����Ȃ���)
'Arguments  :iCode              I   �ΏۃR�[�h
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   �`�F�b�N�f�B�W�b�g�v�Z
    '********************************************************************
    iCode = UCase$(Trim$(iCode))
    If Left$(iCode, 1) = "*" Then iCode = Mid$(iCode, 2)
    If Right$(iCode, 1) = "*" Then iCode = Left$(iCode, Len(iCode) - 1)
    If Len(iCode) = 0 Or CD_ContainsInvalidMod43Char(iCode) Then Exit Function
    For wLpi = 1 To Len(iCode)
        wNum = wNum + (InStr(cMOD43_CHARS, Mid$(iCode, wLpi, 1)) - 1)
        wNum = wNum Mod 43
    Next
    CD_GetMod43 = Mid$(cMOD43_CHARS, wNum + 1, 1)

End Function
