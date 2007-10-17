VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_MRU"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'////////////////////////////////////////////////////////////////////////
'最近使ったファイル一覧(Most Recently Used)を管理するクラス
'   C_MRU
'       2005/08/18 DATACOM うっちー
'
'公開プロパティ
'MRUMax                     X   管理する最大数(Default:5)
'MRUCount                   I   最近使ったファイル一覧の数
'MRUList(Index)             I   最近使ったファイル(Index:1～)(デフォルトプロパティ)
'Duplication                X   ファイル一覧で重複を許可するか？(True:許可する　False:許可しない(Default))
'
'公開メソッド
'Add                        最近使ったファイル一覧へのファイル追加
'RemoveAll                  最近使ったファイル一覧を削除
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_MRUMax As Integer                 '管理する最大数
Private m_MRUCount As Integer               '最近使ったファイル一覧数
Private m_MRUList() As String               '最近使ったファイル一覧
Private m_Duplication As Boolean            'ファイル一覧で重複を許可するか？

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ設定/参照
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Public Property Let MRUMax(ByVal iMRUMax As Integer)
    If m_MRUMax < 1 Then
        m_MRUMax = 5
    Else
        m_MRUMax = iMRUMax
        ReDim Preserve m_MRUList(m_MRUMax)
    End If
End Property

Public Property Get MRUMax() As Integer
    MRUMax = m_MRUMax
End Property

Public Property Get MRUCount() As Integer
    MRUCount = m_MRUCount
End Property

Public Property Get MRUList(ByVal Index As Integer) As String
Attribute MRUList.VB_UserMemId = 0
    If Index < 1 Or m_MRUCount < Index Then Exit Property
    MRUList = m_MRUList(Index)
End Property

Public Property Let Duplication(ByVal iDuplication As Boolean)
    m_Duplication = iDuplication
End Property

Public Property Get Duplication() As Boolean
    Duplication = m_Duplication
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
    m_MRUMax = 5
    m_MRUCount = 0
    ReDim m_MRUList(m_MRUMax)
    m_Duplication = False
    
End Sub

Public Sub Add(ByVal Item As String)
'////////////////////////////////////////////////////////////////////////
'Name       :Add
'Explanation:最近使ったファイル一覧へのファイル追加
'Arguments  :Item               I   対象ファイル
'////////////////////////////////////////////////////////////////////////
Dim wLpi                        As Integer
Dim wList()                     As String
Dim wMRUCount                   As Integer

    '********************************************************************
    '   既存リストをワークにコピー
    '********************************************************************
    ReDim wList(m_MRUMax)
    For wLpi = 1 To m_MRUCount
        wList(wLpi) = m_MRUList(wLpi)
    Next
    
    '********************************************************************
    '   ワークからシフトしてコピー
    '********************************************************************
    m_MRUList(1) = Item
    wMRUCount = 1
    For wLpi = 1 To m_MRUCount
        If m_Duplication = False And wList(wLpi) = Item Then GoTo CONTINUE
        If m_MRUMax < wMRUCount + 1 Then Exit For
        wMRUCount = wMRUCount + 1
        m_MRUList(wMRUCount) = wList(wLpi)
CONTINUE:
    Next
    m_MRUCount = wMRUCount

End Sub

Public Sub RemoveAll()
'////////////////////////////////////////////////////////////////////////
'Name       :RemoveAll
'Explanation:最近使ったファイル一覧を削除
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   初期化
    '********************************************************************
    m_MRUCount = 0
    ReDim m_MRUList(m_MRUMax)

End Sub
