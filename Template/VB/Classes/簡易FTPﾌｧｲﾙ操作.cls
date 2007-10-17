VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "C_FTP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   簡易FTP操作クラス
'       2003/10/21　うっちー
'       ・C_FTPFiles.clsが必要です…
'       ・約4GBを超えるファイルはWININET.DLLの仕様で4294967295になります…
'       ・Unix系サーバーのシンボリックリンクには未対応です…
'       ・クラスインスタンス作成/解放時にインターネットへの接続/切断を行います
'       ・公開プロパティ一覧
'           hInet　…　インターネット接続ハンドル(読込専用)、有効な接続がない場合は0
'           hSession　…　FTPセッションハンドル(読込専用)、有効な接続がない場合は0
'           ServerHost　…　接続サーバー名を設定/取得
'           ServerPort　…　接続ポート番号を設定/取得
'           FTPUserName　…　接続ユーザー名を設定/取得
'           FTPPassword　…　接続パスワードを設定/取得
'           Passive　…　パッシブモードの設定/取得
'           CurDir　…　カレントディレクトリの設定/取得
'           RemoteFiles　…　検索ファイル情報
'       ・公開メソッド一覧
'           OpenSession　…　FTPサーバーに接続します
'           CloseSession　…　FTPサーバーから切断します
'           FindFile　…　ファイル一覧検索を開始します
'           NextFile　…　次のファイルを検索します
'           FileExists　…　ファイルの存在をチェックします
'           DirectoryExists　…　ディレクトリの存在をチェックします
'           PutFile　…　ファイルを送信します
'           GetFile　…　ファイルを受信します
'           RenameFile　…　ファイル名を変更します
'           DeleteFile　…　ファイルを削除します
'           MakeDir　…　ディレクトリを作成します
'           RemoveDir　…　ディレクトリを削除します
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

'////////////////////////////////////////////////////////////////////////
'   列挙型定義
'////////////////////////////////////////////////////////////////////////
Public Enum eTRANSFER
    transBinary
    transAscii
End Enum

'////////////////////////////////////////////////////////////////////////
'   イベント宣言
'////////////////////////////////////////////////////////////////////////
Public Event FTPError(ByVal ErrNumber As Long, ByVal ErrDescription As String)

'////////////////////////////////////////////////////////////////////////
'   メンバ変数宣言
'////////////////////////////////////////////////////////////////////////
Private m_hInet As Long
Private m_hSession As Long
Private m_hFind As Long
Private m_ServerHost As String
Private m_ServerPort As Long
Private m_FTPUserName As String
Private m_FTPPassword As String
Private m_Passive As Long
Public RemoteFiles As C_FTPFiles

'////////////////////////////////////////////////////////////////////////
'   Win32API関数　各種定義
'////////////////////////////////////////////////////////////////////////
Private Const MAX_PATH = 260

Private Const FILE_ATTRIBUTE_READONLY = &H1
Private Const FILE_ATTRIBUTE_HIDDEN = &H2
Private Const FILE_ATTRIBUTE_SYSTEM = &H4
Private Const FILE_ATTRIBUTE_DIRECTORY = &H10
Private Const FILE_ATTRIBUTE_ARCHIVE = &H20
Private Const FILE_ATTRIBUTE_NORMAL = &H80
Private Const FILE_ATTRIBUTE_TEMPORARY = &H100
Private Const FILE_ATTRIBUTE_COMPRESSED = &H800
Private Const FILE_ATTRIBUTE_OFFLINE = &H1000

Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type

Private Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type

Private Type WIN32_FIND_DATA
    dwFileAttributes As Long
    ftCreationTime As FILETIME
    ftLastAccessTime As FILETIME
    ftLastWriteTime As FILETIME
    nFileSizeHigh As Long
    nFileSizeLow As Long
    dwReserved0 As Long
    dwReserved1 As Long
    cFileName As String * MAX_PATH
    cAlternate As String * 14
End Type

Private Declare Function FileTimeToSystemTime Lib "kernel32" _
    (lpFileTime As FILETIME, _
    lpSystemTime As SYSTEMTIME) As Long

Private Declare Function FormatMessage Lib "kernel32" Alias "FormatMessageA" _
    (ByVal dwFlags As Long, _
    lpSource As Any, _
    ByVal dwMessageId As Long, _
    ByVal dwLanguageId As Long, _
    ByVal lpBuffer As String, _
    ByVal nSize As Long, _
    Arguments As Long) As Long

    Private Const FORMAT_MESSAGE_ALLOCATE_BUFFER = &H100
    Private Const FORMAT_MESSAGE_IGNORE_INSERTS = &H200
    Private Const FORMAT_MESSAGE_FROM_STRING = &H400
    Private Const FORMAT_MESSAGE_FROM_HMODULE = &H800
    Private Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000
    Private Const FORMAT_MESSAGE_MAX_WIDTH_MASK = &HFF
    Private Const FORMAT_MESSAGE_ARGUMENT_ARRAY = &H2000
    
    Private Const LANG_NEUTRAL = &H0
    Private Const SUBLANG_DEFAULT = &H1

'////////////////////////////////////////////////////////////////////////
'   WININET.DLL関連　各種定義
'////////////////////////////////////////////////////////////////////////
Private Const INTERNET_MAX_HOST_NAME_LENGTH = 256
Private Const INTERNET_MAX_USER_NAME_LENGTH = 128
Private Const INTERNET_MAX_PASSWORD_LENGTH = 128

Private Const INTERNET_DEFAULT_FTP_PORT = 21

Private Const ERROR_NO_MORE_FILES = 18
Private Const INTERNET_ERROR_BASE = 12000

Private Const INTERNET_FLAG_RELOAD As Long = &H80000000     ' ADD:1999-12-15

'====   WINNET関連エラーコード一覧
Private Const ERROR_INTERNET_OUT_OF_HANDLES = (INTERNET_ERROR_BASE + 1)
Private Const ERROR_INTERNET_TIMEOUT = (INTERNET_ERROR_BASE + 2)
Private Const ERROR_INTERNET_EXTENDED_ERROR = (INTERNET_ERROR_BASE + 3)
Private Const ERROR_INTERNET_INTERNAL_ERROR = (INTERNET_ERROR_BASE + 4)
Private Const ERROR_INTERNET_INVALID_URL = (INTERNET_ERROR_BASE + 5)
Private Const ERROR_INTERNET_UNRECOGNIZED_SCHEME = (INTERNET_ERROR_BASE + 6)
Private Const ERROR_INTERNET_NAME_NOT_RESOLVED = (INTERNET_ERROR_BASE + 7)
Private Const ERROR_INTERNET_PROTOCOL_NOT_FOUND = (INTERNET_ERROR_BASE + 8)
Private Const ERROR_INTERNET_INVALID_OPTION = (INTERNET_ERROR_BASE + 9)
Private Const ERROR_INTERNET_BAD_OPTION_LENGTH = (INTERNET_ERROR_BASE + 10)
Private Const ERROR_INTERNET_OPTION_NOT_SETTABLE = (INTERNET_ERROR_BASE + 11)
Private Const ERROR_INTERNET_SHUTDOWN = (INTERNET_ERROR_BASE + 12)
Private Const ERROR_INTERNET_INCORRECT_USER_NAME = (INTERNET_ERROR_BASE + 13)
Private Const ERROR_INTERNET_INCORRECT_PASSWORD = (INTERNET_ERROR_BASE + 14)
Private Const ERROR_INTERNET_LOGIN_FAILURE = (INTERNET_ERROR_BASE + 15)
Private Const ERROR_INTERNET_INVALID_OPERATION = (INTERNET_ERROR_BASE + 16)
Private Const ERROR_INTERNET_OPERATION_CANCELLED = (INTERNET_ERROR_BASE + 17)
Private Const ERROR_INTERNET_INCORRECT_HANDLE_TYPE = (INTERNET_ERROR_BASE + 18)
Private Const ERROR_INTERNET_INCORRECT_HANDLE_STATE = (INTERNET_ERROR_BASE + 19)
Private Const ERROR_INTERNET_NOT_PROXY_REQUEST = (INTERNET_ERROR_BASE + 20)
Private Const ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND = (INTERNET_ERROR_BASE + 21)
Private Const ERROR_INTERNET_BAD_REGISTRY_PARAMETER = (INTERNET_ERROR_BASE + 22)
Private Const ERROR_INTERNET_NO_DIRECT_ACCESS = (INTERNET_ERROR_BASE + 23)
Private Const ERROR_INTERNET_NO_CONTEXT = (INTERNET_ERROR_BASE + 24)
Private Const ERROR_INTERNET_NO_CALLBACK = (INTERNET_ERROR_BASE + 25)
Private Const ERROR_INTERNET_REQUEST_PENDING = (INTERNET_ERROR_BASE + 26)
Private Const ERROR_INTERNET_INCORRECT_FORMAT = (INTERNET_ERROR_BASE + 27)
Private Const ERROR_INTERNET_ITEM_NOT_FOUND = (INTERNET_ERROR_BASE + 28)
Private Const ERROR_INTERNET_CANNOT_CONNECT = (INTERNET_ERROR_BASE + 29)
Private Const ERROR_INTERNET_CONNECTION_ABORTED = (INTERNET_ERROR_BASE + 30)
Private Const ERROR_INTERNET_CONNECTION_RESET = (INTERNET_ERROR_BASE + 31)
Private Const ERROR_INTERNET_FORCE_RETRY = (INTERNET_ERROR_BASE + 32)
Private Const ERROR_INTERNET_INVALID_PROXY_REQUEST = (INTERNET_ERROR_BASE + 33)
Private Const ERROR_INTERNET_NEED_UI = (INTERNET_ERROR_BASE + 34)

Private Const ERROR_INTERNET_HANDLE_EXISTS = (INTERNET_ERROR_BASE + 36)
Private Const ERROR_INTERNET_SEC_CERT_DATE_INVALID = (INTERNET_ERROR_BASE + 37)
Private Const ERROR_INTERNET_SEC_CERT_CN_INVALID = (INTERNET_ERROR_BASE + 38)
Private Const ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR = (INTERNET_ERROR_BASE + 39)
Private Const ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR = (INTERNET_ERROR_BASE + 40)
Private Const ERROR_INTERNET_MIXED_SECURITY = (INTERNET_ERROR_BASE + 41)
Private Const ERROR_INTERNET_CHG_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 42)
Private Const ERROR_INTERNET_POST_IS_NON_SECURE = (INTERNET_ERROR_BASE + 43)
Private Const ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED = (INTERNET_ERROR_BASE + 44)
Private Const ERROR_INTERNET_INVALID_CA = (INTERNET_ERROR_BASE + 45)
Private Const ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP = (INTERNET_ERROR_BASE + 46)
Private Const ERROR_INTERNET_ASYNC_THREAD_FAILED = (INTERNET_ERROR_BASE + 47)
Private Const ERROR_INTERNET_REDIRECT_SCHEME_CHANGE = (INTERNET_ERROR_BASE + 48)
Private Const ERROR_INTERNET_DIALOG_PENDING = (INTERNET_ERROR_BASE + 49)
Private Const ERROR_INTERNET_RETRY_DIALOG = (INTERNET_ERROR_BASE + 50)
Private Const ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR = (INTERNET_ERROR_BASE + 52)
Private Const ERROR_INTERNET_INSERT_CDROM = (INTERNET_ERROR_BASE + 53)

Private Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" _
    (ByVal lpszAgent As String, _
    ByVal dwAccessType As Long, _
    ByVal lpszProxy As String, _
    ByVal lpszProxyBypass As String, _
    ByVal dwFlags As Long) As Long

    ' Access Types for InternetOpen()
    Private Const INTERNET_OPEN_TYPE_PRECONFIG = 0                   '// use registry configuration
    Private Const INTERNET_OPEN_TYPE_DIRECT = 1                      '// direct to net
    Private Const INTERNET_OPEN_TYPE_PROXY = 3                       '// via named proxy
    Private Const INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4 '// prevent using java/script/INS

Private Declare Function InternetCloseHandle Lib "wininet.dll" _
    (ByVal hInet As Long) As Long

Private Declare Function InternetConnect Lib "wininet.dll" Alias "InternetConnectA" _
    (ByVal hInternet As Long, _
    ByVal lpszRemoteHostName As String, _
    ByVal nRemoteHostPort As Long, _
    ByVal lpszUserName As String, _
    ByVal lpszPassword As String, _
    ByVal dwService As Long, _
    ByVal dwFlags As Long, _
    ByVal dwContext As Long) As Long

    ' dwService
    Private Const INTERNET_SERVICE_FTP = 1
    ' dwFlags
    Private Const INTERNET_FLAG_PASSIVE = &H8000000
    ' dwContext
    Private Const INTERNET_NO_CALLBACK = 0
        
Private Declare Function FtpCreateDirectory Lib "wininet.dll" Alias "FtpCreateDirectoryA" _
    (ByVal hConnect As Long, _
    lpszDirectory As Any) As Long

Private Declare Function FtpRemoveDirectory Lib "wininet.dll" Alias "FtpRemoveDirectoryA" _
    (ByVal hConnect As Long, _
    lpszDirectory As Any) As Long

Private Declare Function FtpSetCurrentDirectory Lib "wininet.dll" Alias "FtpSetCurrentDirectoryA" _
    (ByVal hConnect As Long, _
    ByVal lpszDirectory As String) As Long

Private Declare Function FtpGetCurrentDirectory Lib "wininet.dll" Alias "FtpGetCurrentDirectoryA" _
    (ByVal hConnect As Long, _
    lpszCurrentDirectory As Any, _
    lpdwCurrentDirectory As Any) As Long

Private Declare Function FtpFindFirstFile Lib "wininet.dll" Alias "FtpFindFirstFileA" _
    (ByVal hConnect As Long, _
    ByVal lpszSearchFile As String, _
    lpFindFileData As WIN32_FIND_DATA, _
    ByVal dwFlags As Long, _
    ByVal dwContext As Long) As Long

Private Declare Function InternetFindNextFile Lib "wininet.dll" Alias "InternetFindNextFileA" _
    (ByVal hFind As Long, _
    lpvFindData As WIN32_FIND_DATA) As Long

Private Declare Function FtpGetFile Lib "wininet.dll" Alias "FtpGetFileA" _
    (ByVal hConnect As Long, _
    lpszRemoteFile As Any, _
    lpszNewFile As Any, _
    ByVal fFailIfExists As Long, _
    ByVal dwFlagsAndAttributes As Long, _
    ByVal dwFlags As Long, _
    ByVal dwContext As Long) As Long

Private Declare Function FtpPutFile Lib "wininet.dll" Alias "FtpPutFileA" _
    (ByVal hFtpSession As Long, _
    lpszLocalFile As Any, _
    lpszNewRemoteFile As Any, _
    ByVal dwFlags As Long, _
    ByVal dwContext As Long) As Long
        
    ' dwFlags
    Private Const INTERNET_FLAG_TRANSFER_ASCII = &H1
    Private Const INTERNET_FLAG_TRANSFER_BINARY = &H2

Private Declare Function FtpRenameFile Lib "wininet.dll" _
    Alias "FtpRenameFileA" ( _
    ByVal hConnect As Long, _
    lpszExisting As Any, _
    lpszNew As Any) As Long

Private Declare Function FtpDeleteFile Lib "wininet.dll" Alias "FtpDeleteFileA" _
    (ByVal hConnect As Long, _
    lpszFileName As Any) As Long

Private Declare Function InternetGetLastResponseInfo Lib "wininet.dll" Alias "InternetGetLastResponseInfoA" _
    (lpdwError As Long, _
    lpszBuffer As Any, _
    lpdwBufferLength As Long) As Long

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   メンバ関数定義
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Private Sub Class_Initialize()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Initialize
'Explanation:コンストラクタ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   メンバ変数の初期化
    '********************************************************************
    m_ServerHost = vbNullString
    m_ServerPort = INTERNET_DEFAULT_FTP_PORT
    m_FTPUserName = "anonymous"
    m_FTPPassword = vbNullString
    m_Passive = 0
    
    '********************************************************************
    '   インターネットハンドル取得
    '********************************************************************
    m_hInet = InternetOpen(vbNullString, INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
    If m_hInet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    
End Sub

Private Sub Class_Terminate()
'////////////////////////////////////////////////////////////////////////
'Name       :Class_Terminate
'Explanation:デストラクタ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   リモートファイル一覧/FTPセッション/インターネットハンドル解放
    '********************************************************************
    Set RemoteFiles = Nothing
    Call CloseSession
    If InternetCloseHandle(m_hInet) = 0 Then Call RaiseErrEvents(Err.LastDllError)
    
End Sub

Public Sub OpenSession(Optional ByVal iServerHost As String = vbNullString, _
                       Optional ByVal iServerPort As Long = INTERNET_DEFAULT_FTP_PORT, _
                       Optional ByVal iFTPUserName As String = "anonymous", _
                       Optional ByVal iFTPPassword As String = vbNullString, _
                       Optional ByVal iPassive As Boolean = False)
'////////////////////////////////////////////////////////////////////////
'Name       :OpenSession
'Explanation:FTP接続
'Arguments  :iServerHost        I   対象サーバー名
'           :iServerPort        I   対象サーバーポート番号
'           :iFTPUserName       I   ユーザー名
'           :iFTPPassword       I   パスワード
'           :iPassive           I   パッシブモードフラグ
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   メンバ変数セット
    '********************************************************************
    If iServerHost <> vbNullString Then m_ServerHost = Trim$(iServerHost)
    If iServerPort <> INTERNET_DEFAULT_FTP_PORT Then m_ServerPort = iServerPort
    If iFTPUserName <> "anonymous" Then m_FTPUserName = Trim$(iFTPUserName)
    If iFTPPassword <> vbNullString Then m_FTPPassword = Trim$(iFTPPassword)
    If iPassive Then m_Passive = INTERNET_FLAG_PASSIVE
    
    '********************************************************************
    '   FTPセッションを開く
    '********************************************************************
    m_hSession = InternetConnect(m_hInet, m_ServerHost, m_ServerPort, m_FTPUserName, m_FTPPassword, INTERNET_SERVICE_FTP, m_Passive, INTERNET_NO_CALLBACK)
    If m_hSession = 0 Then
        Call RaiseErrEvents(Err.LastDllError)
    End If
    
End Sub

Public Sub CloseSession()
'////////////////////////////////////////////////////////////////////////
'Name       :CloseSession
'Explanation:FTP切断
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   FTPセッションを閉じる
    '********************************************************************
    Call CloseFileSession
    If m_hSession <> 0 Then
        If InternetCloseHandle(m_hSession) = 0 Then
            Call RaiseErrEvents(Err.LastDllError)
        Else
            m_hSession = 0
        End If
    End If
    
End Sub

Private Sub CloseFileSession()
'////////////////////////////////////////////////////////////////////////
'Name       :CloseFileSession
'Explanation:ディレクトリ検索ハンドルの解放
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   ディレクトリ検索ハンドルを閉じる
    '********************************************************************
    If m_hFind <> 0 Then
        If InternetCloseHandle(m_hFind) = 0 Then
            Call RaiseErrEvents(Err.LastDllError)
        Else
            m_hFind = 0
        End If
    End If
    
End Sub

Public Sub FindFile(Optional ByVal iFileMask As String = "*.*")
'////////////////////////////////////////////////////////////////////////
'Name       :FindFile
'Explanation:ファイル検索開始
'Arguments  :iFileMask          I   検索ファイルマスク
'////////////////////////////////////////////////////////////////////////
Dim wFILEINFO                   As WIN32_FIND_DATA

    '********************************************************************
    '   リモートファイル一覧初期化
    '********************************************************************
    Call CloseFileSession
    Set RemoteFiles = Nothing
    Set RemoteFiles = New C_FTPFiles
    RemoteFiles.SearchEnd = False
    
    '********************************************************************
    '   ファイル情報取得
    '********************************************************************
    With wFILEINFO
        .cFileName = String$(MAX_PATH, vbNullChar)
        m_hFind = FtpFindFirstFile(m_hSession, iFileMask, wFILEINFO, INTERNET_FLAG_RELOAD, 0)
        If m_hFind = 0 Then
            Call RaiseErrEvents(Err.LastDllError)
            RemoteFiles.SearchEnd = True
        Else
            Call SetFileInfo(wFILEINFO)
        End If
    End With
    
End Sub

Public Sub NextFile()
'////////////////////////////////////////////////////////////////////////
'Name       :NextFile
'Explanation:次のファイルを検索
'////////////////////////////////////////////////////////////////////////
Dim wFILEINFO                   As WIN32_FIND_DATA
Dim wRet                        As Long

    If RemoteFiles.SearchEnd Then Exit Sub
    '********************************************************************
    '   次のファイル情報取得
    '********************************************************************
    With wFILEINFO
        .cFileName = String$(MAX_PATH, vbNullChar)
        wRet = InternetFindNextFile(m_hFind, wFILEINFO)
        If wRet = 0 Then
            Call RaiseErrEvents(Err.LastDllError)
        Else
            Call SetFileInfo(wFILEINFO)
        End If
    End With

End Sub

Private Sub SetFileInfo(ByRef iFILEINFO As WIN32_FIND_DATA)
'////////////////////////////////////////////////////////////////////////
'Name       :SetFileInfo
'Explanation:ファイル情報をVBから扱いやすい形に変換
'Arguments  :iFILEINFO          I   ファイル情報
'////////////////////////////////////////////////////////////////////////
Dim wSYSTIME                    As SYSTEMTIME
Dim wUnsinedLong                As Double

    '********************************************************************
    '   ファイル情報の各種メンバに変換した値を格納
    '********************************************************************
    With RemoteFiles
        '================================================================
        '   ファイル名
        '================================================================
        .FileName = Left$(iFILEINFO.cFileName, InStr(iFILEINFO.cFileName, vbNullChar) - 1)
        '================================================================
        '   更新日付
        '================================================================
        Call FileTimeToSystemTime(iFILEINFO.ftLastWriteTime, wSYSTIME)
        .FileDate = CDate(wSYSTIME.wYear & "/" & wSYSTIME.wMonth & "/" & wSYSTIME.wDay & " " & _
                          wSYSTIME.wHour & ":" & wSYSTIME.wMinute & ":" & wSYSTIME.wSecond)
        '================================================================
        '   ファイルサイズ(約4GBを超えるファイルはWININET.DLLの仕様で4294967295になります)
        '================================================================
        If 0 <= iFILEINFO.nFileSizeLow Then
            .FileSize = iFILEINFO.nFileSizeLow
        Else
            wUnsinedLong = CDbl(iFILEINFO.nFileSizeLow)
            wUnsinedLong = wUnsinedLong + 4294967296#
            .FileSize = wUnsinedLong
        End If
        '================================================================
        '   ファイル属性
        '================================================================
        If (iFILEINFO.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY Then
            .FileType = vbDirectory
        Else
            If iFILEINFO.dwFileAttributes = 0 Then
                '====   属性0はおそらくシンボリックリンク？ 本体の属性を判断しかねるためとりあえずAliasとして返す
                .FileType = vbAlias
            Else
                .FileType = vbNormal
            End If
        End If
    End With
    
End Sub

Public Function FileExists(ByVal iFileName As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :FileExists
'Explanation:ファイル存在チェック(カレントディレクトリ内のみ)
'Arguments  :iFileName          I   対象ファイル名
'Return     :Boolean型(False：見つからない　True：見つかった)
'////////////////////////////////////////////////////////////////////////
Dim wFoundFlag                  As Boolean

    '********************************************************************
    '   リモートファイル一覧取得＆対象ファイル検索
    '********************************************************************
    Call FindFile
    Do Until RemoteFiles.SearchEnd
        If RemoteFiles.FileName = iFileName Then
            If (RemoteFiles.FileType And vbDirectory) <> vbDirectory And RemoteFiles.FileType <> vbAlias Then
                wFoundFlag = True
                Exit Do
            End If
        End If
        Call NextFile
    Loop
    FileExists = wFoundFlag

End Function

Public Function DirectoryExists(ByVal iDirName As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :DirectoryExists
'Explanation:ディレクトリ存在チェック(カレントディレクトリ内のみ)
'Arguments  :iDirName           I   対象ディレクトリ名
'Return     :Boolean型(False：見つからない　True：見つかった)
'////////////////////////////////////////////////////////////////////////
Dim wFoundFlag                  As Boolean

    '********************************************************************
    '   リモートファイル一覧取得＆対象ディレクトリ検索
    '********************************************************************
    Call FindFile
    Do Until RemoteFiles.SearchEnd
        If RemoteFiles.FileName = iDirName Then
            If (RemoteFiles.FileType And vbDirectory) = vbDirectory Then
                wFoundFlag = True
                Exit Do
            End If
        End If
        Call NextFile
    Loop
    DirectoryExists = wFoundFlag

End Function

Public Function PutFile(ByVal iLocalFile As String, ByVal iRemoteFile As String, _
                        Optional ByVal iTransfer As eTRANSFER = transBinary) As Integer
'////////////////////////////////////////////////////////////////////////
'Name       :PutFile
'Explanation:ファイル送信
'Arguments  :iLocalFile         I   ローカルファイル名称(フルパス)
'           :iRemoteFile        I   リモートファイル名称
'           :iTransfer          I   転送モード
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wLocal()                    As Byte
Dim wRemote()                   As Byte
Dim wTransfer                   As Long
Dim wRet                        As Long

    '********************************************************************
    '   Put
    '********************************************************************
    wLocal = StrConv(iLocalFile & vbNullChar, vbFromUnicode)
    wRemote = StrConv(iRemoteFile & vbNullChar, vbFromUnicode)
    wTransfer = IIf(iTransfer = transBinary, INTERNET_FLAG_TRANSFER_BINARY, INTERNET_FLAG_TRANSFER_ASCII)
    Screen.MousePointer = vbHourglass
    wRet = FtpPutFile(m_hSession, wLocal(0), wRemote(0), wTransfer, INTERNET_NO_CALLBACK)
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    PutFile = wRet
    
End Function

Public Function GetFile(ByVal iRemoteFile As String, ByVal iLocalFile As String, _
                        Optional ByVal iExistsError As Boolean = False, _
                        Optional ByVal iTransfer As eTRANSFER = transBinary) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :GetFile
'Explanation:ファイル受信
'Arguments  :iRemoteFile        I   リモートファイル名称
'           :iLocalFile         I   ローカルファイル名称
'           :iExistsError       I   既に存在するときエラーとするか上書きするか
'           :iTransfer          I   転送モード
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wRemote()                   As Byte
Dim wLocal()                    As Byte
Dim wTransfer                   As Long
Dim wRet                        As Long

    '********************************************************************
    '   Get
    '********************************************************************
    wRemote = StrConv(iRemoteFile & vbNullChar, vbFromUnicode)
    wLocal = StrConv(iLocalFile & vbNullChar, vbFromUnicode)
    wTransfer = IIf(iTransfer = transBinary, INTERNET_FLAG_TRANSFER_BINARY, INTERNET_FLAG_TRANSFER_ASCII)
    Screen.MousePointer = vbHourglass
    wRet = FtpGetFile(m_hSession, wRemote(0), wLocal(0), -1 * iExistsError, 0, INTERNET_FLAG_RELOAD Or wTransfer, INTERNET_NO_CALLBACK)
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    GetFile = wRet

End Function

Public Function RenameFile(ByVal iOldName As String, ByVal iNewName As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :RenameFile
'Explanation:ファイル名変更
'Arguments  :iOldName           I   元ファイル名
'           :iNewName           I   新ファイル名
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wOld()                      As Byte
Dim wNew()                      As Byte
Dim wRet                        As Long

    '********************************************************************
    '   Rename
    '********************************************************************
    wOld = StrConv(iOldName & vbNullChar, vbFromUnicode)
    wNew = StrConv(iNewName & vbNullChar, vbFromUnicode)
    Screen.MousePointer = vbHourglass
    wRet = FtpRenameFile(m_hSession, wOld(0), wNew(0))
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    RenameFile = wRet
    
End Function

Public Function DeleteFile(ByVal iFileName As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :DeleteFile
'Explanation:ファイル削除
'Arguments  :iFileName          I   対象ファイル名
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wFileName()                 As Byte
Dim wRet                        As Long

    '********************************************************************
    '   Delete
    '********************************************************************
    wFileName = StrConv(iFileName & vbNullChar, vbFromUnicode)
    Screen.MousePointer = vbHourglass
    wRet = FtpDeleteFile(m_hSession, wFileName(0))
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    DeleteFile = wRet
    
End Function

Public Function MakeDir(ByVal iDirName As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :MakeDir
'Explanation:ディレクトリ作成
'Arguments  :iDirName           I   ディレクトリ名
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wDirName()                  As Byte
Dim wRet                        As Long

    '********************************************************************
    '   MkDir
    '********************************************************************
    wDirName = StrConv(iDirName & vbNullChar, vbFromUnicode)
    Screen.MousePointer = vbHourglass
    wRet = FtpCreateDirectory(m_hSession, wDirName(0))
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    MakeDir = wRet
    
End Function

Public Function RemoveDir(ByVal iDirName As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :RemoveDir
'Explanation:ディレクトリ削除
'Arguments  :iDirName           I   対象ディレクトリ名
'Return     :Long型(0：失敗　0以外：成功)
'////////////////////////////////////////////////////////////////////////
Dim wDirName()                  As Byte
Dim wRet                        As Long

    '********************************************************************
    '   RmDir
    '********************************************************************
    wDirName = StrConv(iDirName & vbNullChar, vbFromUnicode)
    Screen.MousePointer = vbHourglass
    wRet = FtpRemoveDirectory(m_hSession, wDirName(0))
    Screen.MousePointer = vbDefault
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)
    RemoveDir = wRet

End Function

Private Sub RaiseErrEvents(ByVal iErrNumber As Long)
'////////////////////////////////////////////////////////////////////////
'Name       :RaiseErrEvents
'Explanation:エラーイベントを発生させる
'Arguments  :iErrNumber         I   発生元エラーコード
'////////////////////////////////////////////////////////////////////////
Dim wErrDescription             As String
Dim wBuf(255)                   As Byte
Dim wLen                        As Long

    '********************************************************************
    '   エラーコードごとの処理
    '********************************************************************
    Select Case iErrNumber
    Case ERROR_NO_MORE_FILES
        '================================================================
        '   ファイルが存在しない(エラーと見なさず抜ける)
        '================================================================
        RemoteFiles.SearchEnd = True
        Exit Sub
    Case ERROR_INTERNET_EXTENDED_ERROR
        '================================================================
        '   拡張エラー情報の取得
        '================================================================
        wLen = 255
        Call InternetGetLastResponseInfo(iErrNumber, wBuf(0), wLen)
        wErrDescription = StrConv(wBuf, vbUnicode)
        wErrDescription = Left$(wErrDescription, InStr(wErrDescription, vbNullChar) - 1)
    Case ERROR_INTERNET_CANNOT_CONNECT
        '================================================================
        '   接続失敗
        '================================================================
        wErrDescription = "接続に失敗しました。"
    Case ERROR_INTERNET_INCORRECT_PASSWORD
        '================================================================
        '   不正パスワード
        '================================================================
        wErrDescription = "パスワードが不正です。"
    Case Else
        '================================================================
        '   上記以外
        '================================================================
        wErrDescription = GetErrMsg(iErrNumber)
    End Select
    
    '********************************************************************
    '   上記で処理していないものもとりあえずエラーとし、イベント起動
    '********************************************************************
    If Len(Trim$(wErrDescription)) = 0 Then wErrDescription = "FTPでエラーが発生しました。"
    RaiseEvent FTPError(iErrNumber, wErrDescription)

End Sub

Private Function GetErrMsg(ByVal iErrNumber As Long) As String
'////////////////////////////////////////////////////////////////////////
'Name       :GetErrMsg
'Explanation:DLLのエラーメッセージ取得
'Arguments  :iErrNumber         I   対象エラーコード
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wBuf                        As String * 256

    '********************************************************************
    '   FormatMessage
    '********************************************************************
    wRet = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM Or FORMAT_MESSAGE_IGNORE_INSERTS Or FORMAT_MESSAGE_MAX_WIDTH_MASK, _
                         ByVal 0, _
                         iErrNumber, _
                         MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), _
                         wBuf, _
                         255, _
                         ByVal 0)
    GetErrMsg = Left$(wBuf, wRet)
    
End Function

Private Function MAKELANGID(ByVal usPrimaryLanguage As Integer, ByVal usSubLanguage As Integer) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :MAKELANGID
'Explanation:MAKELANGIDマクロ互換関数
'Arguments  :usPrimaryLanguage  I   プライマリ言語ID
'           :usSubLanguage      I   セカンダリ言語ID
'Return     :Long型
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   デフォルト言語ID取得
    '********************************************************************
    On Error GoTo ERR_PROCESS
    MAKELANGID = usSubLanguage * (2 ^ 10) + usPrimaryLanguage
    On Error GoTo 0
    
Exit Function

ERR_PROCESS:
    MsgBox Err.Number & vbNewLine & Err.Description, vbCritical, "FTP Class"
    
End Function

'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
'
'   プロパティ設定/取得
'
'_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

Public Property Get hInet() As Long
    hInet = m_hInet
End Property

Public Property Get hSession() As Long
    hSession = m_hSession
End Property

Public Property Let ServerHost(ByVal iServerHost As String)
    m_ServerHost = IIf(Trim$(iServerHost) = "", vbNullString, Trim$(iServerHost))
End Property

Public Property Get ServerHost() As String
    ServerHost = IIf(m_ServerHost = vbNullString, "", m_ServerHost)
End Property

Public Property Let ServerPort(ByVal iServerPort As Long)
    m_ServerPort = iServerPort
End Property

Public Property Get ServerPort() As Long
    ServerPort = m_ServerPort
End Property

Public Property Let FTPUserName(ByVal iFTPUserName As String)
    m_FTPUserName = IIf(Trim$(iFTPUserName) = "", vbNullString, Trim$(iFTPUserName))
End Property

Public Property Get FTPUserName() As String
    FTPUserName = IIf(m_FTPUserName = vbNullString, "", m_FTPUserName)
End Property

Public Property Let FTPPassword(ByVal iFTPPassword As String)
    m_FTPPassword = IIf(Trim$(iFTPPassword) = "", vbNullString, Trim$(iFTPPassword))
End Property

Public Property Get FTPPassword() As String
    FTPPassword = IIf(m_FTPPassword = vbNullString, "", m_FTPPassword)
End Property

Public Property Let Passive(ByVal iPassive As Boolean)
    m_Passive = IIf(iPassive, INTERNET_FLAG_PASSIVE, 0)
End Property

Public Property Get Passive() As Boolean
    Passive = (m_Passive = INTERNET_FLAG_PASSIVE)
End Property

Public Property Let CurDir(ByVal iCurDir As String)
'////////////////////////////////////////////////////////////////////////
'Property   :Let CurDir
'Explanation:カレントディレクトリ設定
'Arguments  :iCurDir            I   カレントディレクトリ
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wDir                        As String

    '********************************************************************
    '   ディレクトリ移動
    '********************************************************************
    If m_hSession = 0 Then Exit Property
    wDir = iCurDir
'    If Left$(wDir, 1) = "\" Or Left$(wDir, 1) = "/" Then wDir = Mid$(wDir, 2)
    wRet = FtpSetCurrentDirectory(m_hSession, wDir)
    If wRet = 0 Then Call RaiseErrEvents(Err.LastDllError)

End Property

Public Property Get CurDir() As String
'////////////////////////////////////////////////////////////////////////
'Property   :Get CurDir
'Explanation:カレントディレクトリ取得
'Return     :String型(カレントディレクトリ)
'////////////////////////////////////////////////////////////////////////
Dim wDir(MAX_PATH)              As Byte
Dim wLen                        As Long
Dim wRet                        As Long
Dim wBuf                        As String

    '********************************************************************
    '   カレントディレクトリ取得
    '********************************************************************
    If m_hSession = 0 Then CurDir = ""
    wLen = MAX_PATH
    wRet = FtpGetCurrentDirectory(m_hSession, wDir(0), wLen)
    If wRet <> 0 Then
        wBuf = StrConv(wDir, vbUnicode)
        CurDir = Left$(wBuf, InStr(wBuf, vbNullChar) - 1)
    Else
        Call RaiseErrEvents(Err.LastDllError)
    End If
    
End Property

