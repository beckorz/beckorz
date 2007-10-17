VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_Log"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'簡易ログ出力クラス
'   C_Log
'       2005/02/14 DATACOM うっちー
'
'公開プロパティ
'LogFileName                X   出力ファイル名(フルパス)
'LogCount                   O   ログ出力行数
'MaxLineCount               X   ログ保持行数
'
'公開メソッド
'OutputLog                  ログ出力
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_FileNo                As Integer
Private m_FileName              As String
Private m_LogCount              As Long
Private m_MaxLineCount          As Integer

Public Property Let LogFileName(ByVal iLogFileName As String)
    m_FileName = iLogFileName
End Property

Public Property Get LogFileName() As String
    LogFileName = m_FileName
End Property

Public Property Get LogCount() As Long
    LogCount = m_LogCount
End Property

Public Property Let MaxLineCount(ByVal iMaxLineCount As Integer)
    m_MaxLineCount = iMaxLineCount
    If m_MaxLineCount < 0 Then m_MaxLineCount = 0
End Property

Public Property Get MaxLineCount() As Integer
    MaxLineCount = m_MaxLineCount
End Property

Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Initialize
'Explanation:クラスInitializeイベントプロシージャ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   メンバ変数初期化
    '********************************************************************
    m_FileNo = 0
    m_FileName = ""
    m_LogCount = 0
    m_MaxLineCount = 0
    
End Sub

Private Sub Class_Terminate()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Terminate
'Explanation:クラスTerminateイベントプロシージャ
'////////////////////////////////////////////////////////////////////////
Dim wTail                       As String

    '********************************************************************
    '   開いているファイルがあれば閉じる
    '********************************************************************
    If m_FileNo <> 0 Then
        '================================================================
        '   ファイルクローズ
        '================================================================
        On Error Resume Next
        Close #m_FileNo
        On Error GoTo 0
        '================================================================
        '   ログ保持行数超過分を切り捨てる
        '================================================================
        If 0 < m_MaxLineCount Then
            If GetFileTail(m_FileName, wTail, m_MaxLineCount + 1) = 0 Then
                On Error Resume Next
                m_FileNo = FreeFile
                Open m_FileName For Output As #m_FileNo
                Print #m_FileNo, wTail;
                Close #m_FileNo
                On Error GoTo 0
            End If
        End If
    End If
    
End Sub

Public Function OutputLog(ByVal iMsg As String, Optional ByVal iDateTimeFormat As String = "") As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :OutputLog
'Explanation:ログ出力
'Arguments  :iMsg               I   出力文字列
'           :iDateTimeFormat    I   省略可、Format$の書式を指定すると出力文字列の前に日時を付加する
'Return     :Boolean型(False：正常　True：失敗)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ファイルをまだ開いていなければ開く
    '********************************************************************
    If m_FileNo = 0 Then
        On Error GoTo ERR_FILEACCESS
        m_FileNo = FreeFile
        Open m_FileName For Append As #m_FileNo
        On Error GoTo 0
    End If
    
    '********************************************************************
    '   ログ出力
    '********************************************************************
    m_LogCount = m_LogCount + 1
    If iDateTimeFormat <> "" Then iMsg = Format$(Now, iDateTimeFormat) & " " & iMsg
    On Error GoTo ERR_FILEACCESS
    Print #m_FileNo, iMsg
    On Error GoTo 0
    
Exit Function

ERR_FILEACCESS:
    '********************************************************************
    '   Error
    '********************************************************************
    OutputLog = True

End Function

Private Function GetFileTail(ByVal iFileName As String, ByRef oText As String, _
                             Optional ByVal iLineCount As Long = 10) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :GetFileTail
'Explanation:ファイルの末尾指定行分だけ読み込む
'Arguments  :iFileName          I   対象ファイル名
'           :oText              O   読み込みテキスト
'           :iLineCount         I   読み込み行数
'Return     :Long型(0:正常 0以外:失敗)
'////////////////////////////////////////////////////////////////////////
Const CR                        As Byte = 13
Const LF                        As Byte = 10
Dim wFileLen                    As Long
Dim wFileNo                     As Integer
Dim wText()                     As Byte
Dim wTail                       As Long
Dim wCounter                    As Long
Dim wCPos                       As Long
Dim wCPos2                      As Long

    oText = ""
    '********************************************************************
    '   ファイル存在チェック/ファイルオープン
    '********************************************************************
    If iLineCount <= 0 Then Exit Function
    On Error GoTo ERR_FILEOPEN
    wFileLen = FileLen(iFileName)
    If wFileLen = 0 Then Exit Function
    wFileNo = FreeFile
    Open iFileName For Input Access Read Shared As #wFileNo
    On Error GoTo 0
    
    '********************************************************************
    '   ファイル内容一括読込
    '********************************************************************
    wText = InputB(wFileLen, wFileNo)
    
    '********************************************************************
    '   ファイルクローズ
    '********************************************************************
    On Error Resume Next
    Close #wFileNo
    On Error GoTo 0
    
    '********************************************************************
    '   改行カウント
    '********************************************************************
    '====   判定簡略化のため1Byte増やす
    ReDim Preserve wText(wFileLen)
    '====   ファイル終端が改行でないものも考慮する
    If wText(wTail) <> CR And wText(wTail) <> LF Then wCounter = wCounter + 1
    wTail = wFileLen - 1
    '====   改行検索ループ
    For wCPos = wTail To 0 Step -1
        If wText(wCPos) = LF Or (wText(wCPos) = CR And wText(wCPos + 1) <> LF) Then
            If wText(wCPos) = CR Then
                wText(wCPos) = LF
                wCPos2 = wCPos - 1
                Do While 0 <= wCPos2 And wText(wCPos2) = CR
                    wText(wCPos2) = LF
                    wCPos2 = wCPos2 - 1
                Loop
            End If
            wCounter = wCounter + 1
            If iLineCount = wCounter - 1 Then Exit For
        End If
    Next
    wCPos = wCPos + 1
    
    '********************************************************************
    '   結果を返す
    '********************************************************************
    ReDim Preserve wText(wFileLen - 1)
    oText = StrConv(MidB(wText, wCPos + 1), vbUnicode)
    
Exit Function

ERR_FILEOPEN:
    '********************************************************************
    '   Error
    '********************************************************************
    GetFileTail = Err.Number
    
End Function


