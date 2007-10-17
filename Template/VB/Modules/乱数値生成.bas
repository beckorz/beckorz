Attribute VB_Name = "M_RndVal"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'�����ɂ��l����
'   M_RndVal
'       2006/11/22 DATACOM �������[
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   �萔�錾
'////////////////////////////////////////////////////////////////////////
Private Const cALPHACAPLOWER As Long = &H41         '���p�p�啶���̊J�n�����R�[�h(A)
Private Const cALPHACAPUPPER As Long = &H5A         '���p�p�啶���̏I�������R�[�h(Z)
Private Const cALPHASMLLOWER As Long = &H61         '���p�p�������̊J�n�����R�[�h(a)
Private Const cALPHASMLUPPER As Long = &H7A         '���p�p�������̏I�������R�[�h(z)
Private Const cNUMLOWER As Long = &H30              '���p�����̊J�n�����R�[�h(0)
Private Const cNUMUPPER As Long = &H39              '���p�����̏I�������R�[�h(9)
Private Const cKANALOWER As Long = &HA6             '���p�J�i�̊J�n�����R�[�h(�)
Private Const cKANAUPPER As Long = &HDD             '���p�J�i�̏I�������R�[�h(�)
Private Const cNUMZENLOWER As Long = &H824F         '�S�p�����̊J�n�����R�[�h(�O)
Private Const cNUMZENUPPER As Long = &H8258         '�S�p�����̏I�������R�[�h(�X)
Private Const cALPHACAPZENLOWER As Long = &H8260    '�S�p�p�啶���̊J�n�����R�[�h(�`)
Private Const cALPHACAPZENUPPER As Long = &H8279    '�S�p�p�啶���̏I�������R�[�h(�y)
Private Const cALPHASMLZENLOWER As Long = &H8281    '�S�p�p�������̊J�n�����R�[�h(��)
Private Const cALPHASMLZENUPPER As Long = &H829A    '�S�p�p�������̏I�������R�[�h(��)
Private Const cHIRALOWER As Long = &H829F           '�S�p�Ђ炪�Ȃ̊J�n�����R�[�h(��)
Private Const cHIRAUPPER As Long = &H82F1           '�S�p�Ђ炪�Ȃ̏I�������R�[�h(��)
Private Const cKANAZENLOWER As Long = &H8340        '�S�p�J�i�̊J�n�����R�[�h(�@)
Private Const cKANAZENUPPER As Long = &H8394        '�S�p�J�i�̏I�������R�[�h(��)
Private Const cSJIS1LOWER As Long = &H889F          '��ꐅ�������̊J�n�����R�[�h(��)
Private Const cSJIS1UPPER As Long = &H9872          '��ꐅ�������̏I�������R�[�h(�r)
Private Const cSJIS2LOWER1 As Long = &H989F         '��񐅏������̊J�n�����R�[�h�P(��)
Private Const cSJIS2UPPER1 As Long = &H9FFC         '��񐅏������̏I�������R�[�h�P(��)
Private Const cSJIS2LOWER2 As Long = &HE040         '��񐅏������̊J�n�����R�[�h�Q(�@)
Private Const cSJIS2UPPER2 As Long = &HEAA4         '��񐅏������̏I�������R�[�h�Q(�)

'////////////////////////////////////////////////////////////////////////
'   �񋓌^�錾
'////////////////////////////////////////////////////////////////////////
'====   ������t���O
Public Enum STRMASK
    STRMASK_ALPHACAP = 1        '���p�p�啶��
    STRMASK_ALPHASML = 2        '���p�p������
    STRMASK_NUM = 4             '���p����
    STRMASK_KANA = 8            '���p�J�i
    STRMASK_NUMZEN = 16         '�S�p����
    STRMASK_ALPHACAPZEN = 32    '�S�p�p�啶��
    STRMASK_ALPHASMLZEN = 64    '�S�p�p������
    STRMASK_HIRA = 128          '�S�p�Ђ炪��
    STRMASK_KANAZEN = 256       '�S�p�J�i
    STRMASK_SJIS1 = 512         '��ꐅ������
    STRMASK_SJIS2 = 1024        '��񐅏�����
    STRMASK_ALPHA = STRMASK_ALPHACAP Or STRMASK_ALPHASML                '���p�p��(�啶��/������)
    STRMASK_ALPHAZEN = STRMASK_ALPHACAPZEN Or STRMASK_ALPHASMLZEN       '�S�p�p��(�啶��/������)
    STRMASK_ALPHANUM = STRMASK_ALPHA Or STRMASK_NUM                     '���p�p��
    STRMASK_ALPHANUMZEN = STRMASK_ALPHAZEN Or STRMASK_NUMZEN            '�S�p�p��
End Enum

Public Function Rnd_Integer(ByVal iMin As Integer, ByVal iMax As Integer) As Integer
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Integer
'Explanation:�����_���Ȑ��l(Integer)��Ԃ�
'Arguments  :iMin               I    �ŏ��l
'           :iMax               I    �ő�l
'Return     :Integer�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Integer = Int((CLng(iMax) - CLng(iMin) + 1) * Rnd + iMin)

End Function

Public Function Rnd_Long(ByVal iMin As Long, ByVal iMax As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Long
'Explanation:�����_���Ȑ��l(Long)��Ԃ�
'Arguments  :iMin               I    �ŏ��l
'           :iMax               I    �ő�l
'Return     :Long�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Long = Int((CCur(iMax) - CCur(iMin) + 1) * Rnd + iMin)

End Function

Public Function Rnd_Single(ByVal iMin As Single, ByVal iMax As Single) As Single
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Single
'Explanation:�����_���Ȑ��l(Single)��Ԃ�
'Arguments  :iMin               I    �ŏ��l
'           :iMax               I    �ő�l
'Return     :Single�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Single = (iMax - iMin) * Rnd + iMin

End Function

Public Function Rnd_Date(ByVal iMin As Date, ByVal iMax As Date) As Date
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Date
'Explanation:�����_���ȓ��t(Date)��Ԃ�
'Arguments  :iMin               I    �ŏ��l
'           :iMax               I    �ő�l
'Return     :Date�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Date = DateAdd("d", Rnd_Long(0, DateDiff("d", iMin, iMax)), iMin)

End Function

Public Function Rnd_Time(ByVal iMin As Date, ByVal iMax As Date) As Date
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Time
'Explanation:�����_���Ȏ���(Date)��Ԃ�
'Arguments  :iMin               I    �ŏ��l
'           :iMax               I    �ő�l
'Return     :Date�^
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Time = DateAdd("s", Rnd_Long(0, DateDiff("s", iMin, iMax)), iMin)

End Function

Public Function Rnd_String(ByVal iLength As Integer, ByVal iType As STRMASK) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_String
'Explanation:�����_���ȕ�����(String)��Ԃ�
'Arguments  :iLength            I    ����������
'           :iType              I    ������t���O(�g�ݍ��킹��)
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wType()             As STRMASK
Dim wCount              As Integer
Dim wLpi                As Integer
Dim wString             As String

    If iLength = 0 Or iType = 0 Then Exit Function
    '********************************************************************
    '   ������t���O�̑g�ݍ��킹�𕪉�
    '********************************************************************
    ReDim wType(0)
    If iType And STRMASK_ALPHACAP Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_ALPHACAP
        wCount = wCount + 1
    End If
    If iType And STRMASK_ALPHASML Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_ALPHASML
        wCount = wCount + 1
    End If
    If iType And STRMASK_NUM Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_NUM
        wCount = wCount + 1
    End If
    If iType And STRMASK_KANA Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_KANA
        wCount = wCount + 1
    End If
    If iType And STRMASK_NUMZEN Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_NUMZEN
        wCount = wCount + 1
    End If
    If iType And STRMASK_ALPHACAPZEN Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_ALPHACAPZEN
        wCount = wCount + 1
    End If
    If iType And STRMASK_ALPHASMLZEN Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_ALPHASMLZEN
        wCount = wCount + 1
    End If
    If iType And STRMASK_HIRA Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_HIRA
        wCount = wCount + 1
    End If
    If iType And STRMASK_KANAZEN Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_KANAZEN
        wCount = wCount + 1
    End If
    If iType And STRMASK_SJIS1 Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_SJIS1
        wCount = wCount + 1
    End If
    If iType And STRMASK_SJIS2 Then
        ReDim Preserve wType(wCount)
        wType(wCount) = STRMASK_SJIS2
        wCount = wCount + 1
    End If
    
    '********************************************************************
    '   ������������
    '********************************************************************
    For wLpi = 1 To iLength
        wString = wString & Rnd_String_Sub(wType(Rnd_Integer(0, wCount - 1)))
    Next

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_String = wString

End Function

Private Function Rnd_String_Sub(ByVal iType As STRMASK) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_String_Sub
'Explanation:�����_���ȕ���(String)��Ԃ�
'Arguments  :iType              I    ������t���O
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wCode               As Long
Dim wLow                As Integer

    '********************************************************************
    '   ������t���O����
    '********************************************************************
    Select Case iType
    Case STRMASK_ALPHACAP
        Rnd_String_Sub = Chr$(Rnd_Long(cALPHACAPLOWER, cALPHACAPUPPER))
    Case STRMASK_ALPHASML
        Rnd_String_Sub = Chr$(Rnd_Long(cALPHASMLLOWER, cALPHASMLUPPER))
    Case STRMASK_NUM
        Rnd_String_Sub = Chr$(Rnd_Long(cNUMLOWER, cNUMUPPER))
    Case STRMASK_KANA
        Rnd_String_Sub = Chr$(Rnd_Long(cKANALOWER, cKANAUPPER))
    Case STRMASK_NUMZEN
        Rnd_String_Sub = Chr$(Rnd_Long(cNUMZENLOWER, cNUMZENUPPER))
    Case STRMASK_ALPHACAPZEN
        Rnd_String_Sub = Chr$(Rnd_Long(cALPHACAPZENLOWER, cALPHACAPZENUPPER))
    Case STRMASK_ALPHASMLZEN
        Rnd_String_Sub = Chr$(Rnd_Long(cALPHASMLZENLOWER, cALPHASMLZENUPPER))
    Case STRMASK_HIRA
        Rnd_String_Sub = Chr$(Rnd_Long(cHIRALOWER, cHIRAUPPER))
    Case STRMASK_KANAZEN
        '================================================================
        '   &H837F�̂ݖ���`�Ȃ̂ōĐ������[�v
        '================================================================
        Do
            wCode = Rnd_Long(cKANAZENLOWER, cKANAZENUPPER)
        Loop While wCode = &H837F
        Rnd_String_Sub = Chr$(wCode)
    Case STRMASK_SJIS1
        '================================================================
        '   ���ʃo�C�g��&H7F�A���邢��&H40�`&HFC�͈̔͊O�̏ꍇ�͖���`�Ȃ̂ōĐ������[�v
        '================================================================
        Do
            wCode = Rnd_Long(cSJIS1LOWER, cSJIS1UPPER)
            wLow = wCode And &HFF
        Loop While wLow = &H7F Or wLow < &H40 Or &HFC < wLow
        Rnd_String_Sub = Chr$(wCode)
    Case STRMASK_SJIS2
        '================================================================
        '   ���ʃo�C�g��&H7F�A���邢��&H40�`&HFC�͈̔͊O�̏ꍇ�͖���`�Ȃ̂ōĐ������[�v
        '================================================================
        Do
            Select Case Rnd_Integer(0, 1)
            Case 0: wCode = Rnd_Long(cSJIS2LOWER1, cSJIS2UPPER1)
            Case 1: wCode = Rnd_Long(cSJIS2LOWER2, cSJIS2UPPER2)
            End Select
            wLow = wCode And &HFF
        Loop While wLow = &H7F Or wLow < &H40 Or &HFC < wLow
        Rnd_String_Sub = Chr$(wCode)
    End Select

End Function
