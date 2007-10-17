VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_CsvFileReader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'CSVファイル読込用クラス
'   C_CsvFileReader
'       2006/05/22 DATACOM うっちー
'
'公開プロパティ
'TargetFilePath             X   対象CSVファイルパス
'RecordCount                O   現在のレコード件数
'RecordData                 O   読み取りレコード生データ
'Item(Index)                O   CSVの各フィールド(デフォルトプロパティ)
'FieldCount                 O   フィールド数
'CutDoubleQuotation         X   ダブルクォーテーション除去フラグ
'
'公開メソッド
'Read                       CSVファイルから1レコード分読み込む
'IsFileExists               ファイル存在チェック
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   メンバ変数
'////////////////////////////////////////////////////////////////////////
Private m_FileNo As Integer             '保持ファイルNo
Private m_TargetFilePath As String      '対象CSVファイルパス
Private m_RecordCount As Long           '現在のレコード件数
Private m_RecordData As String          '読み取りレコード生データ
Private m_CSV() As String               'CSV分割配列
Private m_CutDoubleQuotation As Boolean 'ダブルクォーテーション除去フラグ

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ取得/設定
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Public Property Get TargetFilePath() As String
    TargetFilePath = m_TargetFilePath
End Property

Public Property Let TargetFilePath(ByVal iTargetFilePath As String)
    If Not IsFileExists(iTargetFilePath) Then Exit Property
    If m_FileNo <> 0 Then Close #m_FileNo
    m_FileNo = FreeFile
    Open iTargetFilePath For Binary As #m_FileNo
    m_TargetFilePath = iTargetFilePath
    Call Initialize
End Property

Public Property Get RecordCount() As Long
    RecordCount = m_RecordCount
End Property

Public Property Get RecordData() As String
    RecordData = m_RecordData
End Property

Public Property Get Item(ByVal Index As Integer) As String
Attribute Item.VB_UserMemId = 0
    If Index < 0 Or UBound(m_CSV) < Index Then
        Item = ""
    Else
        Item = m_CSV(Index)
    End If
End Property

Public Property Get FieldCount() As Integer
    FieldCount = UBound(m_CSV) + 1
End Property

Public Property Get CutDoubleQuotation() As Boolean
    CutDoubleQuotation = m_CutDoubleQuotation
End Property

Public Property Let CutDoubleQuotation(ByVal iCutDoubleQuotation As Boolean)
    m_CutDoubleQuotation = iCutDoubleQuotation
End Property

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   イベントプロシージャ/メソッド
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Initialize
'Explanation:クラスInitializeイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   メンバ変数初期化
    '********************************************************************
    m_CutDoubleQuotation = True
    Call Initialize
    
End Sub

Private Sub Class_Terminate()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Terminate
'Explanation:クラスTerminateイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ファイルが開いていれば閉じる
    '********************************************************************
    If m_FileNo <> 0 Then
        On Error Resume Next
        Close #m_FileNo
        On Error GoTo 0
    End If
    
End Sub

Private Sub Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Initialize
'Explanation:メンバ変数初期化
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    m_RecordCount = 0
    ReDim m_CSV(0)
    
End Sub

Public Function Read() As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Read
'Explanation:CSVファイルから1レコード分読み込む
'Return     :Boolean型(ファイル終端に達するか、レコード長分読み込めなくなった時点でTrueを返す)
'////////////////////////////////////////////////////////////////////////
    
    '********************************************************************
    '   1行読込＆CSV分割
    '********************************************************************
    If m_FileNo = 0 Then
        Read = True
        Exit Function
    End If
    On Error GoTo ERR_FILEREAD
    Line Input #m_FileNo, m_RecordData
    On Error GoTo 0
    If EOF(m_FileNo) Then
        Read = True
        Exit Function
    End If
    m_CSV = SplitCSV(m_RecordData)
    m_RecordCount = m_RecordCount + 1
    
Exit Function

ERR_FILEREAD:
    '********************************************************************
    '   ファイル読込失敗
    '********************************************************************
    Read = True
    
End Function

Public Function IsFileExists(ByVal iFileName As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :IsFileExists
'Explanation:ファイル存在チェック
'Arguments  :iFileName          I   対象ファイル名(フルパス)
'Return     :Boolean型(True：存在する　False：存在しない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   存在チェック
    '********************************************************************
    iFileName = Trim$(iFileName)
    On Error Resume Next
    IsFileExists = Not (((GetAttr(iFileName) And vbVolume) = vbVolume) Or ((GetAttr(iFileName) And vbDirectory) = vbDirectory))
    On Error GoTo 0

End Function

Private Function SplitCSV(ByVal iStr As String) As String()
'////////////////////////////////////////////////////////////////////////
'Name       :SplitCSV
'Explanation:Excel形式CSV文字列の分割
'           :　[,]の直後以外に["]が来るパターンに関してはExcelと違う動作をします
'Arguments  :iStr               I   対象となるCSV文字列
'Return     :String型(分割された文字列配列を返す)
'////////////////////////////////////////////////////////////////////////
Dim wCSV()                      As String
Dim wSplitCnt                   As Long
Dim wCurPos                     As Long
Dim wCommaNext                  As Long
Dim wQuotNext                   As Long
Dim wDQuotEnd                   As Long

    '********************************************************************
    '   初期化
    '********************************************************************
    iStr = Trim$(iStr) & ","    '番兵
    wCurPos = 1
    
    '********************************************************************
    '   [,]と["]を検索するループ
    '********************************************************************
    Do
        '================================================================
        '   走査位置より先の[,]と["]を検索
        '================================================================
        wCommaNext = InStr(wCurPos, iStr, ",")
        wQuotNext = InStr(wCurPos, iStr, """")
        If wCommaNext = 0 Then Exit Do
        If wQuotNext = 0 Or wCommaNext < wQuotNext Then
            '------------------------------------------------------------
            '   [,]が先に見つかったのでその部分まで抽出
            '------------------------------------------------------------
            ReDim Preserve wCSV(wSplitCnt)
            wCSV(wSplitCnt) = Mid$(iStr, wCurPos, wCommaNext - wCurPos)
            'wCSV(wSplitCnt) = Trim$(wCSV(wSplitCnt))    'Trim
            wCurPos = wCommaNext + 1
            wSplitCnt = wSplitCnt + 1
        Else
            '------------------------------------------------------------
            '   走査位置を["](開始)の次の位置まで移動して["](終了)を検索
            '------------------------------------------------------------
            wCurPos = wQuotNext + 1
            wQuotNext = InStr(wCurPos, iStr, """")
            '------------------------------------------------------------
            '   [""]なら無視してさらに先の["](終了)を検索
            '------------------------------------------------------------
            Do While Mid$(iStr, wQuotNext, 2) = """"""
                wDQuotEnd = wQuotNext + 2
                wQuotNext = InStr(wDQuotEnd, iStr, """")
                If wQuotNext = 0 Then Exit Do   '["]閉じ忘れのデータ
            Loop
            '------------------------------------------------------------
            '   "～"の部分を抽出
            '------------------------------------------------------------
            If wQuotNext Then
                ReDim Preserve wCSV(wSplitCnt)
                wCSV(wSplitCnt) = Mid$(iStr, wCurPos, wQuotNext - wCurPos)
                
                '====   以下は必要に応じて…
                If m_CutDoubleQuotation Then
                    wCSV(wSplitCnt) = Replace(wCSV(wSplitCnt), """", "")    '["]削除
                Else
                    wCSV(wSplitCnt) = Replace(wCSV(wSplitCnt), """""", """")    '[""]→["]
                End If
                'wCSV(wSplitCnt) = Trim$(wCSV(wSplitCnt))    'Trim
                
                wCurPos = InStr(wQuotNext + 1, iStr, ",") + 1
                wSplitCnt = wSplitCnt + 1
            Else
                '====   ["]閉じ忘れなので残りを抽出して終了
                ReDim Preserve wCSV(wSplitCnt)
                wCSV(wSplitCnt) = Mid$(iStr, wCurPos)
                
                '====   以下は必要に応じて
                If m_CutDoubleQuotation Then
                    wCSV(wSplitCnt) = Replace(wCSV(wSplitCnt), """", "")    '["]削除
                Else
                    wCSV(wSplitCnt) = Replace(wCSV(wSplitCnt), """""", """")    '[""]→["]
                End If
                'wCSV(wSplitCnt) = Trim$(wCSV(wSplitCnt))    'Trim
                
                wCSV(wSplitCnt) = Left$(wCSV(wSplitCnt), Len(wCSV(wSplitCnt)) - 1) '番兵削除
                Exit Do
            End If
        End If
    Loop
    SplitCSV = wCSV
    
End Function

