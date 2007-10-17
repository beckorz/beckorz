VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_FixedLenFileReader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'固定長ファイル読込用クラス
'   C_FixedLenFileReader
'       2006/05/22 DATACOM うっちー
'
'公開プロパティ
'TargetFilePath             X   対象固定長ファイルパス
'RecordCount                O   現在のレコード件数
'RecordLength               O   レコード長(Byte)
'RecordData                 O   読み取りレコード生データ
'Item(Index)                O   固定長の各フィールド(デフォルトプロパティ)
'FieldCount                 O   フィールド数
'
'公開メソッド
'SetFieldWidths             固定長ファイルの各フィールド長を定義する
'Read                       固定長ファイルから1レコード分読み込む
'IsFileExists               ファイル存在チェック
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   構造体
'////////////////////////////////////////////////////////////////////////
Private Type tFieldDefine
    ByteLength As Integer
    StartPos As Integer
End Type

'////////////////////////////////////////////////////////////////////////
'   メンバ変数
'////////////////////////////////////////////////////////////////////////
Private m_FileNo As Integer             '保持ファイルNo
Private m_TargetFilePath As String      '対象固定長ファイルパス
Private m_RecordCount As Long           '現在のレコード件数
Private m_RecordLength As Long          'レコード長(Byte)
Private m_Field() As tFieldDefine       '各フィールド定義
Private m_RecordData As String          '読み取りレコード生データ

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

Public Property Get RecordLength() As Long
    RecordLength = m_RecordLength
End Property

Public Property Get RecordData() As String
    RecordData = m_RecordData
End Property

Public Property Get Item(ByVal Index As Integer) As String
Attribute Item.VB_UserMemId = 0
    If Index < 0 Or UBound(m_Field) < Index Then
        Item = ""
    Else
        Item = MidA(m_RecordData, m_Field(Index).StartPos, m_Field(Index).ByteLength)
    End If
End Property

Public Property Get FieldCount() As Integer
    FieldCount = UBound(m_Field) + 1
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
    m_RecordLength = 0
    ReDim m_Field(0)
    
End Sub

Public Sub SetFieldWidths(ParamArray FieldWidths() As Variant)
'////////////////////////////////////////////////////////////////////////
'Name       :SetFieldWidths
'Explanation:固定長ファイルの各フィールド長を定義する
'Arguments  :FieldWidths        I   各フィールド長
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer

    '********************************************************************
    '   フィールド定義をセット
    '********************************************************************
    If Not IsMissing(FieldWidths) Then
        ReDim m_Field(UBound(FieldWidths))
        m_RecordLength = 0
        For wLpi = 0 To UBound(FieldWidths)
            m_RecordLength = m_RecordLength + FieldWidths(wLpi)
            m_Field(wLpi).ByteLength = FieldWidths(wLpi)
            m_Field(wLpi).StartPos = 1
            If 0 < wLpi Then
                m_Field(wLpi).StartPos = m_Field(wLpi - 1).StartPos + m_Field(wLpi - 1).ByteLength
            End If
        Next
    End If
    
End Sub

Public Function Read() As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Read
'Explanation:固定長ファイルから1レコード分読み込む
'Return     :Boolean型(ファイル終端に達するか、レコード長分読み込めなくなった時点でTrueを返す)
'////////////////////////////////////////////////////////////////////////
Dim wByte()                 As Byte
    
    '********************************************************************
    '   固定長で読み込む
    '********************************************************************
    If m_FileNo = 0 Or m_RecordLength <= 0 Then
        Read = True
        Exit Function
    End If
    ReDim wByte(m_RecordLength - 1)
    On Error GoTo ERR_FILEREAD
    Get #m_FileNo, , wByte
    On Error GoTo 0
    m_RecordData = StrConv(wByte, vbUnicode)
    If EOF(m_FileNo) Then
        Read = True
        Exit Function
    End If
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

Private Function MidA(ByRef iString As String, ByVal iStart As Long, _
                     Optional ByVal iByteLength As Long = -1) As String
'////////////////////////////////////////////////////////////////////////
'Name       :MidA
'Explanation:文字列から指定したバイト数分の文字列を返す
'Arguments  :iString            O   対象文字列
'           :iStart             I   開始位置
'           :iByteLength        I   バイト数
'Return     :String型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   抽出
    '********************************************************************
    If iByteLength < 0 Then
        MidA = StrConv(MidB$(StrConv(iString, vbFromUnicode), iStart), vbUnicode)
    Else
        MidA = StrConv(MidB$(StrConv(iString, vbFromUnicode), iStart, iByteLength), vbUnicode)
    End If
    
End Function
