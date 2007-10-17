Attribute VB_Name = "M_CheckDigit"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'各種チェックディジット算出・チェックモジュール
'   M_CheckDigit
'       2006/11/29 DATACOM うっちー
'
'対応チェックディジット
'・7チェック DR/DSR
'・9チェック DR/DSR
'・モジュラス10 DR/DSR/ルーンズ方式
'・モジュラス11 DR/DSR
'・モジュラス10 ウェイト3(JAN)
'・モジュラス16(NW-7)
'・モジュラス43(CODE39)
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const cCODE_MAXLENGTH As Integer = 15   'チェックディジットを含まないコードの最大長
Private Const cMOD16_CHARS As String = "0123456789-$:/.+ABCD"   'モジュラス16用変換文字列
Private Const cMOD43_CHARS As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%"    'モジュラス43用変換文字列

'////////////////////////////////////////////////////////////////////////
'   列挙型宣言
'////////////////////////////////////////////////////////////////////////
'====   モジュラス11のサブオプション
Public Enum eMod11_SubOption
    OptionCard03    'DRの場合は余り0/1/10に対して1/1/0、DSRの場合は1/0/1をC/Dとする(DSRのデフォルト)
    OptionCard04    'DRの場合は余り0/1/10に対して0/1/0、DSRの場合は0/0/1をC/Dとする(DRのデフォルト)
    OptionCard23    'DRの場合は余り0/1/10に対して1/1/1、DSRの場合は03と同じ1/0/1をC/Dとする
End Enum

Private Function CD_ContainsInvalidNumericChar(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_ContainsInvalidNumericChar
'Explanation:コードに数値以外の文字列が含まれているかチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(数値以外の文字が存在すればTrueを返す)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   チェック
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
'Explanation:コードにモジュラス16用変換文字列として不適切な文字列が含まれているかチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(不適切な文字が存在すればTrueを返す)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   チェック
    '********************************************************************
    iCode = UCase$(iCode)
    '====   先頭と末尾はA～Dのみ
    If InStr("ABCD", Left$(iCode, 1)) = 0 Then
        CD_ContainsInvalidMod16Char = True
        Exit Function
    End If
    If InStr("ABCD", Right$(iCode, 1)) = 0 Then
        CD_ContainsInvalidMod16Char = True
        Exit Function
    End If
    '====   それ以外は数値のみ
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
'Explanation:コードにモジュラス43用変換文字列以外の文字列が含まれているかチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(変換文字列以外の文字が存在すればTrueを返す)
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   チェック
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
'Explanation:7チェックDRのC/Dを返す(コードを7で割った余り)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジット計算
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) = 0 Or cCODE_MAXLENGTH < Len(iCode) Or CD_ContainsInvalidNumericChar(iCode) Then Exit Function
    CD_Get7DR = Val(iCode) Mod 7
    
End Function

Public Function CD_IsValid7DR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid7DR
'Explanation:7チェックDRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid7DR = (Right$(iCode, 1) = CD_Get7DR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get7DSR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get7DSR
'Explanation:7チェックDSRのC/Dを返す(コードを7で割った余りを7から引く)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   7チェックDR結果を使用
    '********************************************************************
    wCD = CD_Get7DR(iCode)
    If 0 < Len(wCD) Then
        CD_Get7DSR = 7 - Val(wCD)
    End If
    
End Function

Public Function CD_IsValid7DSR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid7DSR
'Explanation:7チェックDSRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid7DSR = (Right$(iCode, 1) = CD_Get7DSR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get9DR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get9DR
'Explanation:9チェックDRのC/Dを返す(コードの各桁の総和を9で割った余り)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:9チェックDRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid9DR = (Right$(iCode, 1) = CD_Get9DR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_Get9DSR(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_Get9DSR
'Explanation:9チェックDSRのC/Dを返す(コードの各桁の総和を9で割った余りを9から引く)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   9チェックDR結果を使用
    '********************************************************************
    wCD = CD_Get9DR(iCode)
    If 0 < Len(wCD) Then
        CD_Get9DSR = 9 - Val(wCD)
    End If

End Function

Public Function CD_IsValid9DSR(ByVal iCode As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValid9DSR
'Explanation:9チェックDSRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValid9DSR = (Right$(iCode, 1) = CD_Get9DSR(Left$(iCode, Len(iCode) - 1)))
    
End Function

Public Function CD_GetMod10DR(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10DR
'Explanation:モジュラス10DRのC/Dを返す(コードの各桁にウェイトを乗算し、その積の総和を10で割った余り)
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス10DRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod10DR = (Right$(iCode, 1) = CD_GetMod10DR(Left$(iCode, Len(iCode) - 1), iWait))
    
End Function

Public Function CD_GetMod10DSR(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10DSR
'Explanation:モジュラス10DSRのC/Dを返す(コードの各桁にウェイトを乗算し、その積の総和を10で割った余りを10から引く)
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wCD                         As String

    '********************************************************************
    '   モジュラス10DR結果を使用
    '********************************************************************
    wCD = CD_GetMod10DR(iCode, iWait)
    If 0 < Len(wCD) Then
        CD_GetMod10DSR = ((10 - Val(wCD)) Mod 10)
    End If

End Function

Public Function CD_IsValidMod10DSR(ByVal iCode As String, ByVal iWait As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :CD_IsValidMod10DSR
'Explanation:モジュラス10DSRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod10DSR = (Right$(iCode, 1) = CD_GetMod10DSR(Left$(iCode, Len(iCode) - 1), iWait))

End Function

Public Function CD_GetMod10Luhn(ByVal iCode As String, ByVal iWait As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod10Luhn
'Explanation:モジュラス10ルーンズ方式のC/Dを返す(コードの各桁にウェイトを乗算し、その積の各桁の総和を10で割った余りを10から引く)
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wStr                        As String
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス10ルーンズ方式でC/Dをチェックする
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
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
'Explanation:モジュラス11DRのC/Dを返す(コードの各桁にウェイトを乗算し、その積の総和を11で割った余り)
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'           :iSubOption         I   サブオプション
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long
Dim wModulus                    As Long
Dim wCD                         As String

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス11DRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'           :iSubOption         I   サブオプション
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
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
'Explanation:モジュラス11DSRのC/Dを返すのC/Dを返す(コードの各桁にウェイトを乗算し、その積の総和を11で割った余りを11から引く)
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'           :iSubOption         I   サブオプション
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long
Dim wModulus                    As Long
Dim wCD                         As String

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス11DSRでC/Dをチェックする
'Arguments  :iCode              I   対象コード
'           :iWait              I   ウェイト
'           :iSubOption         I   サブオプション
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    iWait = Trim$(iWait)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < iCode Or Len(iCode) - 1 <> Len(iWait) Then Exit Function
    CD_IsValidMod11DSR = (Right$(iCode, 1) = CD_GetMod11DSR(Left$(iCode, Len(iCode) - 1), iWait, iSubOption))

End Function

Public Function CD_GetJAN(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetJAN
'Explanation:モジュラス10ウェイト3(JAN)のC/Dを返す(モジュラス10DSRでウェイトを右から3,1,3,1,…としたものに同じ)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wFlag                       As Boolean
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス10ウェイト3(JAN)でC/Dをチェックする
'Arguments  :iCode              I   対象コード
'Return     :Boolean型(C/Dが正しくない場合とコードが長すぎる場合にFalseを返す)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   チェックディジットチェック
    '********************************************************************
    iCode = Trim$(iCode)
    If Len(iCode) < 2 Or cCODE_MAXLENGTH + 1 < Len(iCode) Then Exit Function
    CD_IsValidJAN = (Right$(iCode, 1) = CD_GetJAN(Left$(iCode, Len(iCode) - 1)))

End Function

Public Function CD_GetMod16(ByVal iCode As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :CD_GetMod16
'Explanation:モジュラス16(NW-7)のC/Dを返す(スタート・ストップコードを含む全桁を数値変換した総和を16で割った余りを16から引いて文字変換しなおす)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
'Explanation:モジュラス43(CODE39)のC/Dを返す(スタート・ストップコードを除き数値変換した各桁の総和を43で割った余りを文字変換しなおす)
'Arguments  :iCode              I   対象コード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Long
Dim wNum                        As Long

    '********************************************************************
    '   チェックディジット計算
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
