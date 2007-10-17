Attribute VB_Name = "M_RndVal"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'乱数による値生成
'   M_RndVal
'       2006/11/22 DATACOM うっちー
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const cALPHACAPLOWER As Long = &H41         '半角英大文字の開始文字コード(A)
Private Const cALPHACAPUPPER As Long = &H5A         '半角英大文字の終了文字コード(Z)
Private Const cALPHASMLLOWER As Long = &H61         '半角英小文字の開始文字コード(a)
Private Const cALPHASMLUPPER As Long = &H7A         '半角英小文字の終了文字コード(z)
Private Const cNUMLOWER As Long = &H30              '半角数字の開始文字コード(0)
Private Const cNUMUPPER As Long = &H39              '半角数字の終了文字コード(9)
Private Const cKANALOWER As Long = &HA6             '半角カナの開始文字コード(ｦ)
Private Const cKANAUPPER As Long = &HDD             '半角カナの終了文字コード(ﾝ)
Private Const cNUMZENLOWER As Long = &H824F         '全角数字の開始文字コード(０)
Private Const cNUMZENUPPER As Long = &H8258         '全角数字の終了文字コード(９)
Private Const cALPHACAPZENLOWER As Long = &H8260    '全角英大文字の開始文字コード(Ａ)
Private Const cALPHACAPZENUPPER As Long = &H8279    '全角英大文字の終了文字コード(Ｚ)
Private Const cALPHASMLZENLOWER As Long = &H8281    '全角英小文字の開始文字コード(ａ)
Private Const cALPHASMLZENUPPER As Long = &H829A    '全角英小文字の終了文字コード(ｚ)
Private Const cHIRALOWER As Long = &H829F           '全角ひらがなの開始文字コード(ぁ)
Private Const cHIRAUPPER As Long = &H82F1           '全角ひらがなの終了文字コード(ん)
Private Const cKANAZENLOWER As Long = &H8340        '全角カナの開始文字コード(ァ)
Private Const cKANAZENUPPER As Long = &H8394        '全角カナの終了文字コード(ヴ)
Private Const cSJIS1LOWER As Long = &H889F          '第一水準漢字の開始文字コード(亜)
Private Const cSJIS1UPPER As Long = &H9872          '第一水準漢字の終了文字コード(腕)
Private Const cSJIS2LOWER1 As Long = &H989F         '第二水準漢字の開始文字コード１(弌)
Private Const cSJIS2UPPER1 As Long = &H9FFC         '第二水準漢字の終了文字コード１(滌)
Private Const cSJIS2LOWER2 As Long = &HE040         '第二水準漢字の開始文字コード２(漾)
Private Const cSJIS2UPPER2 As Long = &HEAA4         '第二水準漢字の終了文字コード２(熙)

'////////////////////////////////////////////////////////////////////////
'   列挙型宣言
'////////////////////////////////////////////////////////////////////////
'====   文字種フラグ
Public Enum STRMASK
    STRMASK_ALPHACAP = 1        '半角英大文字
    STRMASK_ALPHASML = 2        '半角英小文字
    STRMASK_NUM = 4             '半角数字
    STRMASK_KANA = 8            '半角カナ
    STRMASK_NUMZEN = 16         '全角数字
    STRMASK_ALPHACAPZEN = 32    '全角英大文字
    STRMASK_ALPHASMLZEN = 64    '全角英小文字
    STRMASK_HIRA = 128          '全角ひらがな
    STRMASK_KANAZEN = 256       '全角カナ
    STRMASK_SJIS1 = 512         '第一水準漢字
    STRMASK_SJIS2 = 1024        '第二水準漢字
    STRMASK_ALPHA = STRMASK_ALPHACAP Or STRMASK_ALPHASML                '半角英字(大文字/小文字)
    STRMASK_ALPHAZEN = STRMASK_ALPHACAPZEN Or STRMASK_ALPHASMLZEN       '全角英字(大文字/小文字)
    STRMASK_ALPHANUM = STRMASK_ALPHA Or STRMASK_NUM                     '半角英数
    STRMASK_ALPHANUMZEN = STRMASK_ALPHAZEN Or STRMASK_NUMZEN            '全角英数
End Enum

Public Function Rnd_Integer(ByVal iMin As Integer, ByVal iMax As Integer) As Integer
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Integer
'Explanation:ランダムな数値(Integer)を返す
'Arguments  :iMin               I    最小値
'           :iMax               I    最大値
'Return     :Integer型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Integer = Int((CLng(iMax) - CLng(iMin) + 1) * Rnd + iMin)

End Function

Public Function Rnd_Long(ByVal iMin As Long, ByVal iMax As Long) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Long
'Explanation:ランダムな数値(Long)を返す
'Arguments  :iMin               I    最小値
'           :iMax               I    最大値
'Return     :Long型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Long = Int((CCur(iMax) - CCur(iMin) + 1) * Rnd + iMin)

End Function

Public Function Rnd_Single(ByVal iMin As Single, ByVal iMax As Single) As Single
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Single
'Explanation:ランダムな数値(Single)を返す
'Arguments  :iMin               I    最小値
'           :iMax               I    最大値
'Return     :Single型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Single = (iMax - iMin) * Rnd + iMin

End Function

Public Function Rnd_Date(ByVal iMin As Date, ByVal iMax As Date) As Date
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Date
'Explanation:ランダムな日付(Date)を返す
'Arguments  :iMin               I    最小値
'           :iMax               I    最大値
'Return     :Date型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Date = DateAdd("d", Rnd_Long(0, DateDiff("d", iMin, iMax)), iMin)

End Function

Public Function Rnd_Time(ByVal iMin As Date, ByVal iMax As Date) As Date
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_Time
'Explanation:ランダムな時刻(Date)を返す
'Arguments  :iMin               I    最小値
'           :iMax               I    最大値
'Return     :Date型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   Return
    '********************************************************************
    Rnd_Time = DateAdd("s", Rnd_Long(0, DateDiff("s", iMin, iMax)), iMin)

End Function

Public Function Rnd_String(ByVal iLength As Integer, ByVal iType As STRMASK) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Rnd_String
'Explanation:ランダムな文字列(String)を返す
'Arguments  :iLength            I    生成文字列長
'           :iType              I    文字種フラグ(組み合わせ可)
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wType()             As STRMASK
Dim wCount              As Integer
Dim wLpi                As Integer
Dim wString             As String

    If iLength = 0 Or iType = 0 Then Exit Function
    '********************************************************************
    '   文字種フラグの組み合わせを分解
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
    '   文字数分生成
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
'Explanation:ランダムな文字(String)を返す
'Arguments  :iType              I    文字種フラグ
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wCode               As Long
Dim wLow                As Integer

    '********************************************************************
    '   文字種フラグ判定
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
        '   &H837Fのみ未定義なので再生成ループ
        '================================================================
        Do
            wCode = Rnd_Long(cKANAZENLOWER, cKANAZENUPPER)
        Loop While wCode = &H837F
        Rnd_String_Sub = Chr$(wCode)
    Case STRMASK_SJIS1
        '================================================================
        '   下位バイトが&H7F、あるいは&H40～&HFCの範囲外の場合は未定義なので再生成ループ
        '================================================================
        Do
            wCode = Rnd_Long(cSJIS1LOWER, cSJIS1UPPER)
            wLow = wCode And &HFF
        Loop While wLow = &H7F Or wLow < &H40 Or &HFC < wLow
        Rnd_String_Sub = Chr$(wCode)
    Case STRMASK_SJIS2
        '================================================================
        '   下位バイトが&H7F、あるいは&H40～&HFCの範囲外の場合は未定義なので再生成ループ
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
