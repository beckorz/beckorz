VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_CipherSaber"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'CipherSaberによる暗号化/復号化クラス
'   C_CipherSaber
'       2005/12/07 DATACOM うっちー
'
'公開メソッド
'Encrypt                    暗号化(バイト配列データ)
'Decrypt                    復号化(バイト配列データ)
'StrEncrypt                 暗号化後、Base64エンコード
'StrDecrypt                 Base64デコード後、復号化
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   構造体宣言
'////////////////////////////////////////////////////////////////////////
Private Type RC4_STATE
    x As Integer
    y As Integer
    m(255) As Integer
End Type

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_rc4state As RC4_STATE

Public Sub Encrypt(ByRef iKey As String, ByRef oSource() As Byte)
'////////////////////////////////////////////////////////////////////////
'Name       :Encrypt
'Explanation:CipherSaberによる暗号化
'Arguments  :iKey               O   暗号化パスワード
'           :oSource            O   暗号化対象データ
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wVector(9)                  As Byte
Dim wRC4Key()                   As Byte
Dim wLen                        As Long

    '********************************************************************
    '   初期化ベクタ生成
    '********************************************************************
    Randomize
    For wLpi = 0 To 9
        wVector(wLpi) = CByte(Rnd() * 255)
    Next
    
    '********************************************************************
    '   暗号化パスワードに初期化ベクタを連結してRC4鍵生成
    '********************************************************************
    wRC4Key = StrConv(iKey, vbFromUnicode)
    ReDim Preserve wRC4Key(UBound(wRC4Key) + 10)
    For wLpi = 9 To 0 Step -1
        wRC4Key(UBound(wRC4Key) + wLpi - 9) = wVector(wLpi)
    Next
    
    '********************************************************************
    '   RC4による暗号化
    '********************************************************************
    Call rc4_init(wRC4Key)
    Call rc4_crypt(oSource)
    
    '********************************************************************
    '   初期化ベクタと暗号文を連結した結果を返す
    '********************************************************************
    wLen = UBound(oSource)
    ReDim Preserve oSource(wLen + 10)
    For wLpi = wLen To 0 Step -1
        oSource(wLpi + 10) = oSource(wLpi)
    Next
    For wLpi = 0 To 9
        oSource(wLpi) = wVector(wLpi)
    Next

End Sub

Public Sub Decrypt(ByRef iKey As String, ByRef oSource() As Byte)
'////////////////////////////////////////////////////////////////////////
'Name       :Decrypt
'Explanation:CipherSaberによる復号化
'Arguments  :iKey               O   復号化パスワード
'           :oSource            O   復号化対象データ
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wVector(9)                  As Byte
Dim wRC4Key()                   As Byte

    '********************************************************************
    '   初期化ベクタ読込
    '********************************************************************
    For wLpi = 0 To 9
        wVector(wLpi) = oSource(wLpi)
    Next
    
    '********************************************************************
    '   復号化パスワードと初期化ベクタを連結してRC4鍵生成
    '********************************************************************
    wRC4Key = StrConv(iKey, vbFromUnicode)
    ReDim Preserve wRC4Key(UBound(wRC4Key) + 10)
    For wLpi = 9 To 0 Step -1
        wRC4Key(UBound(wRC4Key) + wLpi - 9) = wVector(wLpi)
    Next
    
    '********************************************************************
    '   初期化ベクタを除いた分を暗号文とする
    '********************************************************************
    For wLpi = 0 To UBound(oSource) - 10
        oSource(wLpi) = oSource(wLpi + 10)
    Next
    ReDim Preserve oSource(UBound(oSource) - 10)
    
    '********************************************************************
    '   RC4による復号化
    '********************************************************************
    Call rc4_init(wRC4Key)
    Call rc4_crypt(oSource)
    
End Sub

Public Function StrEncrypt(ByRef iKey As String, ByRef iSource As String, _
                           Optional ByVal iWidth As Integer = 0) As String
'////////////////////////////////////////////////////////////////////////
'Name       :StrEncrypt
'Explanation:暗号化後、Base64エンコードした結果を返す
'Arguments  :iKey               O   暗号化パスワード
'           :iSource            O   対象文字列
'           :iWidth             I   改行を挿入する位置
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wData()                     As Byte

    '********************************************************************
    '   暗号化
    '********************************************************************
    If Len(iSource) = 0 Then Exit Function
    wData = StrConv(iSource, vbFromUnicode)
    Call Encrypt(iKey, wData)
    StrEncrypt = Base64Encode(wData, iWidth)
    
End Function

Public Function StrDecrypt(ByRef iKey As String, ByRef iSource As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :StrDecrypt
'Explanation:Base64デコード後、復号化した結果を返す
'Arguments  :iKey               O   復号化パスワード
'           :iSource            O   対象文字列
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wData()                     As Byte

    '********************************************************************
    '   復号化
    '********************************************************************
    If Len(iSource) = 0 Then Exit Function
    Call Base64Decode(iSource, wData)
    Call Decrypt(iKey, wData)
    StrDecrypt = StrConv(wData, vbUnicode)
    
End Function

Private Sub rc4_init(ByRef iKey() As Byte)
'////////////////////////////////////////////////////////////////////////
'Name       :rc4_init
'Explanation:RC4初期化
'Arguments  :iKey               O   暗号化パスワード
'////////////////////////////////////////////////////////////////////////
Dim i                           As Integer
Dim j                           As Integer
Dim k                           As Long
Dim a                           As Integer
Dim length                      As Long

    '********************************************************************
    '   鍵セットアップ
    '********************************************************************
    length = UBound(iKey) + 1
    With m_rc4state
        .x = 0
        .y = 0
        For i = 0 To 255
            .m(i) = i
        Next
        For i = 0 To 255
            a = .m(i)
            j = (j + a + iKey(k)) Mod 256
            .m(i) = .m(j)
            .m(j) = a
            k = (k + 1) Mod length
        Next
    End With
    
End Sub

Private Sub rc4_crypt(ByRef oSource() As Byte)
'////////////////////////////////////////////////////////////////////////
'Name       :rc4_crypt
'Explanation:RC4による暗号化/復号化
'Arguments  :oSource            O   暗号化/復号化データ
'////////////////////////////////////////////////////////////////////////
Dim i                           As Long
Dim a                           As Integer
Dim b                           As Integer
Dim length                      As Long

    '********************************************************************
    '   暗号化/復号化
    '********************************************************************
    With m_rc4state
        For i = 0 To UBound(oSource)
            .x = (.x + 1) Mod 256
            a = .m(.x)
            .y = (.y + a) Mod 256
            b = .m(.y)
            .m(.x) = b
            .m(.y) = a
            oSource(i) = oSource(i) Xor .m((a + b) Mod 256)
        Next
    End With
    
End Sub

Private Function Base64Encode(ByRef iSource() As Byte, Optional ByVal iWidth As Integer = 76) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Base64Encode
'Explanation:対象バイト配列をBase64エンコード
'Arguments  :iSource            O   対象バイト配列
'           :iWidth             I   改行を挿入する位置
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wReadCount                  As Long
Dim wEndCount                   As Long
Dim wWriteCount                 As Long
Dim wNoCRLF                     As Long
Dim wLen                        As Long
Dim wSize                       As Long
Dim wBuf                        As String
Dim wB1                         As Long
Dim wB2                         As Long

    If UBound(iSource) < 0 Then Exit Function
    '********************************************************************
    '   エンコード結果を格納する文字列バッファを確保
    '********************************************************************
    wReadCount = LBound(iSource)
    wEndCount = UBound(iSource)
    wWriteCount = 1
    wNoCRLF = 0
    wLen = wEndCount - wReadCount + 1
    If wLen Mod 3 Then
        wSize = (wLen \ 3) * 4 + 4
    Else
        wSize = (wLen \ 3) * 4
    End If
    If 1 < iWidth Then
        wSize = wSize + (wSize \ iWidth + 1) * 2
    End If
    wBuf = Space$(wSize)
    
    '********************************************************************
    '   エンコード処理
    '********************************************************************
    Do
        '================================================================
        '   1Byte目処理
        '================================================================
        wB1 = iSource(wReadCount)
        wReadCount = wReadCount + 1
        Mid$(wBuf, wWriteCount, 1) = CodeConv(wB1 \ 4)
        wWriteCount = wWriteCount + 1
        wNoCRLF = wNoCRLF + 1
        Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
        If wReadCount <= wEndCount Then
            '------------------------------------------------------------
            '   2Byte目処理
            '------------------------------------------------------------
            wB2 = iSource(wReadCount)
            wReadCount = wReadCount + 1
            Mid$(wBuf, wWriteCount, 1) = CodeConv((wB1 And 3) * 16 + wB2 \ 16)
            wWriteCount = wWriteCount + 1
            wNoCRLF = wNoCRLF + 1
            Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
            If wReadCount <= wEndCount Then
                '====   3Byte目
                wB1 = iSource(wReadCount)
                wReadCount = wReadCount + 1
                Mid$(wBuf, wWriteCount, 1) = CodeConv((wB2 And 15) * 4 + wB1 \ 64)
                wWriteCount = wWriteCount + 1
                wNoCRLF = wNoCRLF + 1
                Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
                Mid$(wBuf, wWriteCount, 1) = CodeConv(wB1 And 63)
                wWriteCount = wWriteCount + 1
                wNoCRLF = wNoCRLF + 1
                Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
            Else
                '====   3Byte目処理＆1Padding出力
                Mid$(wBuf, wWriteCount, 1) = CodeConv((wB2 And 15) * 4)
                wWriteCount = wWriteCount + 1
                wNoCRLF = wNoCRLF + 1
                Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
                Mid$(wBuf, wWriteCount, 1) = "="
                wWriteCount = wWriteCount + 1
                wNoCRLF = wNoCRLF + 1
                Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
            End If
        Else
            '------------------------------------------------------------
            '   2Byte目処理＆2Padding出力
            '------------------------------------------------------------
            Mid$(wBuf, wWriteCount, 1) = CodeConv((wB1 And 3) * 16)
            wWriteCount = wWriteCount + 1
            wNoCRLF = wNoCRLF + 1
            Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
            Mid$(wBuf, wWriteCount, 1) = "="
            wWriteCount = wWriteCount + 1
            wNoCRLF = wNoCRLF + 1
            Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
            Mid$(wBuf, wWriteCount, 1) = "="
            wWriteCount = wWriteCount + 1
            wNoCRLF = wNoCRLF + 1
            Call AddCRLF(iWidth, wBuf, wWriteCount, wNoCRLF)
        End If
    Loop Until wEndCount < wReadCount

    '********************************************************************
    '   結果を返す
    '********************************************************************
    Base64Encode = wBuf
    
End Function

Private Function CodeConv(ByVal iCode As Long) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CodeConv
'Explanation:Base64変換テーブルを使って文字変換
'Arguments  :iCode              I   変換対象6bitコード
'Return     :String型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   変換
    '********************************************************************
    Select Case iCode
    Case Is <= 25   '====   A-Z
        CodeConv = Chr$(iCode + 65)
    Case Is <= 51   '====   a-z
        CodeConv = Chr$(iCode + 71)
    Case Is <= 61   '====   0-9
        CodeConv = Chr$(iCode - 4)
    Case 62         '====   +
        CodeConv = "+"
    Case 63         '====   /
        CodeConv = "/"
    Case Else
        CodeConv = ""
    End Select
    
End Function

Private Sub AddCRLF(ByVal iWidth As Integer, ByRef oBuf As String, ByRef oWriteCount As Long, ByVal iNoCRLFCount As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :AddCRLF
'Explanation:改行を挿入
'Arguments  :iWidth             I   改行を挿入する位置
'           :oBuf               O   対象バッファ
'           :oWriteCount        O   書き込み位置
'           :iNoCRLFCount       I   書き込み位置(改行無視)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   改行を挿入
    '********************************************************************
    If 1 < iWidth Then
        If iNoCRLFCount Mod iWidth = 0 Then
            Mid$(oBuf, oWriteCount, 2) = vbCrLf
            oWriteCount = oWriteCount + 2
        End If
    End If
    
End Sub

Private Function Base64Decode(ByVal iText As String, ByRef oResult() As Byte) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Base64Decode
'Explanation:Base64エンコードされた文字列をデコード
'Arguments  :iText              I   対象文字列
'           :oResult            O   デコード結果(バイト配列)
'Return     :Long型(デコード結果バイト数)
'////////////////////////////////////////////////////////////////////////
Dim wLen                        As Long
Dim wReadCount                  As Long
Dim wWriteCount                 As Long
Dim wSubCount                   As Long
Dim wCode                       As Long
Dim wByte                       As Long
Dim w6Bit                       As Long

    '********************************************************************
    '   デコード結果を格納するバッファを確保
    '********************************************************************
    wLen = Len(iText)
    wReadCount = 1
    wWriteCount = 0
    If wLen <= 0 Then
        ReDim oResult(0)
        Exit Function
    End If
    ReDim oResult(wLen - 1)
    
    '********************************************************************
    '   デコード処理
    '********************************************************************
    Do
        wSubCount = 0
        Do
            '============================================================
            '   Base64文字列から6bitコードに変換
            '============================================================
            wCode = Asc(Mid$(iText, wReadCount + wSubCount, 1))
            Select Case wCode
            Case 65 To 90   '====   A-Z
                wSubCount = wSubCount + 1
                w6Bit = wCode - 65
            Case 97 To 122  '====   a-z
                wSubCount = wSubCount + 1
                w6Bit = wCode - 71
            Case 48 To 57   '====   0-9
                wSubCount = wSubCount + 1
                w6Bit = wCode + 4
            Case 43         '====   +
                wSubCount = wSubCount + 1
                w6Bit = 62
            Case 47         '====   /
                wSubCount = wSubCount + 1
                w6Bit = 63
            Case 61         '====   =
                wSubCount = wSubCount + 1
                w6Bit = 255
            Case Else
                wReadCount = wReadCount + 1
                If wLen < wReadCount Then
                    ReDim Preserve oResult(wWriteCount - 1)
                    Base64Decode = wWriteCount
                    Exit Function
                End If
            End Select
            '============================================================
            '   4つの6bitコードから3byteに戻す
            '============================================================
            Select Case wSubCount
            Case 1
                wByte = w6Bit * 4
            Case 2
                oResult(wWriteCount) = wByte Or w6Bit \ 16
                wWriteCount = wWriteCount + 1
                wByte = (w6Bit And 15) * 16
            Case 3
                If w6Bit <= 64 Then
                    oResult(wWriteCount) = wByte Or w6Bit \ 4
                    wWriteCount = wWriteCount + 1
                    wByte = (w6Bit And 3) * 64
                End If
            Case 4
                If w6Bit <= 64 Then
                    oResult(wWriteCount) = wByte Or w6Bit
                    wWriteCount = wWriteCount + 1
                End If
            End Select
        Loop Until 4 <= wSubCount
        wReadCount = wReadCount + 4
    Loop Until wLen < wReadCount
    
    '********************************************************************
    '   結果を返す
    '********************************************************************
    ReDim Preserve oResult(wWriteCount - 1)
    Base64Decode = wWriteCount

End Function

