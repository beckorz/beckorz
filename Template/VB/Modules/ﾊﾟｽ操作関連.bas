Attribute VB_Name = "M_PathOperation"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'パス操作関連API関数ラッパーモジュール
'   M_PathOperation
'       2006/11/21 DATACOM うっちー
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   Win32API関数宣言
'////////////////////////////////////////////////////////////////////////
Private Declare Function PathAddBackslash Lib "Shlwapi" Alias "PathAddBackslashA" _
    (ByVal lpszPath As String) As Long
Private Declare Function PathAddExtension Lib "Shlwapi" Alias "PathAddExtensionA" _
    (ByVal pszPath As String, _
    ByVal pszExtension As String) As Boolean
Private Declare Function PathAppend Lib "Shlwapi" Alias "PathAppendA" _
    (ByVal pszPath As String, _
    ByVal pszMore As String) As Boolean
Private Declare Function PathBuildRoot Lib "Shlwapi" Alias "PathBuildRootA" _
    (ByVal szRoot As String, _
    ByVal iDrive As Long) As Long
Private Declare Function PathCanonicalize Lib "Shlwapi" Alias "PathCanonicalizeA" _
    (ByVal lpszDst As String, _
    ByVal lpszSrc As String) As Boolean
Private Declare Function PathCombine Lib "Shlwapi" Alias "PathCombineA" _
    (ByVal lpszDest As String, _
    ByVal lpszDir As String, _
    ByVal lpszFile As String) As Long
Private Declare Function PathCommonPrefix Lib "Shlwapi" Alias "PathCommonPrefixA" _
    (ByVal pszFile1 As String, _
    ByVal pszFile2 As String, _
    ByVal pszPath As String) As Long
Private Declare Function PathCompactPath Lib "Shlwapi" Alias "PathCompactPathA" _
    (ByVal hDC As Long, _
    ByVal lpszPath As String, _
    ByVal dx As Long) As Boolean
Private Declare Function PathCompactPathEx Lib "Shlwapi" Alias "PathCompactPathExA" _
    (ByVal pszOut As String, _
    ByVal pszSrc As String, _
    ByVal cchMax As Long, _
    ByVal dwFlags As Long) As Boolean
Private Declare Function PathFileExists Lib "Shlwapi" Alias "PathFileExistsA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathFindExtension Lib "Shlwapi" Alias "PathFindExtensionA" _
    (ByVal pPath As String) As Long
Private Declare Function lstrlen Lib "Kernel32" Alias "lstrlenA" _
    (ByVal lpString As Long) As Long
Private Declare Function lstrcpyn Lib "Kernel32" Alias "lstrcpynA" _
    (ByVal lpString1 As String, _
    ByVal lpString2 As Long, _
    ByVal iMaxLength As Long) As Long
Private Declare Function PathFindFileName Lib "Shlwapi" Alias "PathFindFileNameA" _
    (ByVal pPath As String) As Long
Private Declare Function PathFindNextComponent Lib "Shlwapi" Alias "PathFindNextComponentA" _
    (ByVal pszPath As String) As Long
Private Declare Function PathFindOnPath Lib "Shlwapi" Alias "PathFindOnPathA" _
    (ByVal pszFile As String, _
    ppszOtherDirs As String) As Boolean
Private Declare Function PathGetArgs Lib "Shlwapi" Alias "PathGetArgsA" _
    (ByVal pszPath As String) As Long
Private Declare Function PathGetCharType Lib "Shlwapi" Alias "PathGetCharTypeA" _
    (ByVal ch As Long) As Long
Private Declare Function PathGetDriveNumber Lib "Shlwapi" Alias "PathGetDriveNumberA" _
    (ByVal lpsz As String) As Long
Private Declare Function PathIsContentType Lib "Shlwapi" Alias "PathIsContentTypeA" _
    (ByVal pszPath As String, _
    ByVal pszContentType As String) As Boolean
Private Declare Function PathIsDirectory Lib "Shlwapi" Alias "PathIsDirectoryA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathIsFileSpec Lib "Shlwapi" Alias "PathIsFileSpecA" _
    (ByVal lpszPath As String) As Boolean
Private Declare Function PathIsPrefix Lib "Shlwapi" Alias "PathIsPrefixA" _
    (ByVal pszPrefix As String, _
    ByVal pszPath As String) As Boolean
Private Declare Function PathIsRelative Lib "Shlwapi" Alias "PathIsRelativeA" _
    (ByVal lpszPath As String) As Boolean
Private Declare Function PathIsRoot Lib "Shlwapi" Alias "PathIsRootA" _
    (ByVal pPath As String) As Boolean
Private Declare Function PathIsSameRoot Lib "Shlwapi" Alias "PathIsSameRootA" _
    (ByVal pszPath1 As String, _
    ByVal pszPath2 As String) As Boolean
Private Declare Function PathIsSystemFolder Lib "Shlwapi" Alias "PathIsSystemFolderA" _
    (ByVal pszPath As String, _
    ByVal dwAttrb As Long) As Boolean
Private Declare Function PathIsUNC Lib "Shlwapi" Alias "PathIsUNCA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathIsUNCServer Lib "Shlwapi" Alias "PathIsUNCServerA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathIsUNCServerShare Lib "Shlwapi" Alias "PathIsUNCServerShareA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathIsURL Lib "Shlwapi" Alias "PathIsURLA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathMatchSpec Lib "Shlwapi" Alias "PathMatchSpecA" _
    (ByVal pszFileParam As String, _
    ByVal pszSpec As String) As Boolean
Private Declare Sub PathQuoteSpaces Lib "Shlwapi" Alias "PathQuoteSpacesA" _
    (ByVal lpsz As String)
Private Declare Function PathRelativePathTo Lib "Shlwapi" Alias "PathRelativePathToA" _
    (ByVal pszPath As String, _
    ByVal pszFrom As String, _
    ByVal dwAttrFrom As Long, _
    ByVal pszTo As String, _
    ByVal dwAttrTo As Long) As Boolean
Private Declare Sub PathRemoveArgs Lib "Shlwapi" Alias "PathRemoveArgsA" _
    (ByVal pszPath As String)
Private Declare Function PathRemoveBackslash Lib "Shlwapi" Alias "PathRemoveBackslashA" _
    (ByVal lpszPath As String) As Long
Private Declare Sub PathRemoveExtension Lib "Shlwapi" Alias "PathRemoveExtensionA" _
    (ByVal pszPath As String)
Private Declare Function PathRemoveFileSpec Lib "Shlwapi" Alias "PathRemoveFileSpecA" _
    (ByVal pszPath As String) As Boolean
Private Declare Function PathRenameExtension Lib "Shlwapi" Alias "PathRenameExtensionA" _
    (ByVal pszPath As String, _
    ByVal pszExt As String) As Boolean
Private Declare Function PathSearchAndQualify Lib "Shlwapi" Alias "PathSearchAndQualifyA" _
    (ByVal pcszPath As String, _
    ByVal pszFullyQualifiedPath As String, _
    ByVal cchFullyQualifiedPath As Long) As Boolean
Private Declare Function PathSkipRoot Lib "Shlwapi" Alias "PathSkipRootA" _
    (ByVal pszPath As String) As Long
Private Declare Sub PathStripPath Lib "Shlwapi" Alias "PathStripPathA" _
    (ByVal pszPath As String)
Private Declare Function PathStripToRoot Lib "Shlwapi" Alias "PathStripToRootA" _
    (ByVal szRoot As String) As Boolean
Private Declare Sub PathUnquoteSpaces Lib "Shlwapi" Alias "PathUnquoteSpacesA" _
    (ByVal lpsz As String)
    
'////////////////////////////////////////////////////////////////////////
'   定数宣言
'////////////////////////////////////////////////////////////////////////
Private Const MAX_PATH As Long = 260

Public Const GCT_INVALID As Long = 0        'パスに使用できない文字
Public Const GCT_LFNCHAR As Long = 1        '長い形式のファイル名に使用できる文字
Public Const GCT_SHORTCHAR As Long = 2      '短い形式のファイル名に使用できる文字
Public Const GCT_WILD As Long = 4           'ワイルドカード文字
Public Const GCT_SEPARATOR As Long = 8      'パスの区切り文字

Private Function GetStrBeforeNULL(ByRef iString) As String
'////////////////////////////////////////////////////////////////////////
'Name       :GetStrBeforeNULL
'Explanation:NULL終端文字列のNULL手前までを返す
'Arguments  :iString            O   対象文字列
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wIndex                      As Long

    '********************************************************************
    '   結果を返す
    '********************************************************************
    wIndex = InStr(iString, vbNullChar)
    If wIndex <= 0 Then
        GetStrBeforeNULL = iString
    Else
        GetStrBeforeNULL = Left$(iString, wIndex - 1)
    End If
    
End Function

Public Function Path_AddBackslash(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_AddBackslash
'Explanation:パス文字列の末尾にバックスラッシュを追加する
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathAddBackslash(wPath)
    If wRet Then
        Path_AddBackslash = GetStrBeforeNULL(wPath)
    Else
        Path_AddBackslash = iPath
    End If
    
End Function

Public Function Path_AddExtension(ByVal iPath As String, ByVal iExtension As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_AddExtension
'Explanation:パス文字列に拡張子を追加する
'Arguments  :iPath              I   対象パス
'           :iExtension         I   追加する拡張子(".txt"等)
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathAddExtension(wPath, iExtension)
    If wRet Then
        Path_AddExtension = GetStrBeforeNULL(wPath)
    Else
        Path_AddExtension = iPath
    End If
    
End Function

Public Function Path_Append(ByVal iPath As String, ByVal iMore As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_Append
'Explanation:パス文字列にパスを追加する
'Arguments  :iPath              I   対象パス
'           :iMore              I   追加するパス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathAppend(wPath, iMore)
    If wRet Then
        Path_Append = GetStrBeforeNULL(wPath)
    Else
        Path_Append = iPath
    End If

End Function

Public Function Path_BuildRoot(ByVal iDrive As Byte) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_BuildRoot
'Explanation:ドライブ番号からルートパスを取得する
'Arguments  :iDrive             I   ドライブ番号(0～25)
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathBuildRoot(wPath, iDrive)
    If wRet Then
        Path_BuildRoot = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_Canonicalize(ByVal iSrc As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_Canonicalize
'Explanation:相対パス文字列を絶対パスに変換する
'Arguments  :iSrc               I   相対パス文字列
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathCanonicalize(wPath, iSrc)
    If wRet Then
        Path_Canonicalize = GetStrBeforeNULL(wPath)
    Else
        Path_Canonicalize = iSrc
    End If

End Function

Public Function Path_Combine(ByVal iDir As String, ByVal iFile As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_Combine
'Explanation:ディレクトリパスとファイルパスを合成する
'Arguments  :iDir               I   ディレクトリパス
'           :iFile              I   ファイルパス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathCombine(wPath, iDir, iFile)
    If wRet Then
        Path_Combine = GetStrBeforeNULL(wPath)
    End If

End Function

Public Function Path_CommonPrefix(ByVal iFile1 As String, ByVal iFile2 As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_CommonPrefix
'Explanation:2つのパスで共通している部分を取得する
'           :単純な前方一致検索で相対パスもそのまま比較されることに注意
'Arguments  :iFile1             I   対象パス1
'           :iFile2             I   対象パス2
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathCommonPrefix(iFile1, iFile2, wPath)
    If wRet Then
        Path_CommonPrefix = GetStrBeforeNULL(wPath)
    End If

End Function

Public Function Path_CompactPath(ByVal hDC As Long, ByVal iPath As String, ByVal iWidth As Long) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_CompactPath
'Explanation:指定幅に合わせてパス文字列を省略する
'           :PictureBox等フォント設定可能なDCを持つコントロールに直接Printする際に使える
'Arguments  :hDC                I   対象デバイスコンテキストハンドル
'           :iPath              I   対象パス
'           :iWidth             I   幅(ピクセル単位)
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathCompactPath(hDC, wPath, iWidth)
    If wRet Then
        Path_CompactPath = GetStrBeforeNULL(wPath)
    Else
        Path_CompactPath = iPath
    End If
    
End Function

Public Function Path_CompactPathEx(ByVal iPath As String, ByVal iMax As Long) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_CompactPathEx
'Explanation:指定バイト数でパス文字列を省略する
'           :パスに2バイト文字が含まれると文字化けする可能性あり
'Arguments  :iPath              I   対象パス
'           :iMax               I   バイト数
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathCompactPathEx(wPath, iPath, iMax + 1, 0)
    If wRet Then
        Path_CompactPathEx = GetStrBeforeNULL(wPath)
    Else
        Path_CompactPathEx = iPath
    End If

End Function

Public Function Path_FileExists(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FileExists
'Explanation:対象パスが存在するか判定
'           :飽くまでパスの判定でありファイル・ディレクトリの区別はないことに注意
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:存在する　False:存在しない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_FileExists = PathFileExists(iPath)
    
End Function

Public Function Path_FindExtension(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FindExtension
'Explanation:パスから拡張子部分("."あり)を取得
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wExtension                  As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathFindExtension(iPath)
    If wRet Then
        wLen = lstrlen(wRet) + 1
        wRet = lstrcpyn(wExtension, wRet, wLen)
        If wRet Then
            Path_FindExtension = GetStrBeforeNULL(wExtension)
        End If
    End If

End Function

Public Function Path_FindFileName(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FindFileName
'Explanation:パスからファイル名部分を取得
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wFileName                   As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathFindFileName(iPath)
    If wRet Then
        wLen = lstrlen(wRet) + 1
        wRet = lstrcpyn(wFileName, wRet, wLen)
        If wRet Then
            Path_FindFileName = GetStrBeforeNULL(wFileName)
        End If
    End If
    
End Function

Public Function Path_FindNextComponent(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FindNextComponent
'Explanation:パスの次の構成要素を検索する
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathFindNextComponent(iPath)
    If wRet Then
        wLen = lstrlen(wRet) + 1
        wRet = lstrcpyn(wPath, wRet, wLen)
        If wRet Then
            Path_FindNextComponent = GetStrBeforeNULL(wPath)
        End If
    End If

End Function

Public Function Path_FindOnPath(ByVal iFile As String, _
                                ParamArray iOtherDirs() As Variant) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FindOnPath
'Explanation:標準(環境変数)のパス＋追加指定したパスからファイルを検索して絶対パスを返す
'Arguments  :iFile              I   対象ファイル
'           :iOtherDirs         I   追加指定パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH
Dim wRet                        As Boolean
Dim wOtherDirs                  As String

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iFile & vbNullChar
    If Not IsMissing(iOtherDirs) Then
        wOtherDirs = Join(iOtherDirs, vbNullChar) & vbNullChar
    End If
    wRet = PathFindOnPath(wPath, wOtherDirs)
    If wRet Then
        Path_FindOnPath = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_GetArgs(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_GetArgs
'Explanation:パスからコマンドライン引数部分を取得
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathGetArgs(iPath)
    If wRet Then
        wLen = lstrlen(wRet) + 1
        wRet = lstrcpyn(wPath, wRet, wLen)
        If wRet Then
            Path_GetArgs = GetStrBeforeNULL(wPath)
        End If
    End If

End Function

Public Function Path_GetCharType(ByVal iChar As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Path_GetCharType
'Explanation:パスを構成する文字の種別を判定する
'Arguments  :iChar              I   対象文字
'Return     :Long型(GCT_XXX定数の組み合わせ)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_GetCharType = PathGetCharType(Asc(iChar))
    
End Function

Public Function Path_GetDriveNumber(ByVal iPath As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Path_GetDriveNumber
'Explanation:パス名からドライブ番号を取得
'Arguments  :iPath              I   対象パス
'Return     :Long型(0:A～25:Z, 失敗時には-1)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_GetDriveNumber = PathGetDriveNumber(iPath)
    
End Function

Public Function Path_IsContentType(ByVal iPath As String, ByVal iContentType As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsContentType
'Explanation:パスが指定されたコンテントタイプか判定(拡張子判定)
'Arguments  :iPath              I   対象パス
'           :iContentType       I   対象コンテントタイプ("text/plain"や"image/gif"等)
'Return     :Boolean型(True:コンテントタイプと合致する　False:コンテントタイプと合致しない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsContentType = PathIsContentType(iPath, iContentType)
    
End Function

Public Function Path_IsDirectory(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsDirectory
'Explanation:対象ディレクトリが存在するか判定
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:存在する　False:存在しない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsDirectory = PathIsDirectory(iPath)
    
End Function

Public Function Path_IsFileSpec(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsFileSpec
'Explanation:パスに区切り文字が含まれているかを判定
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:含まれない　False:含まれる)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsFileSpec = PathIsFileSpec(iPath)
    
End Function

Public Function Path_IsPrefix(ByVal iPrefix As String, ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsPrefix
'Explanation:パスに指定プリフィックスが含まれるか判定
'Arguments  :iPrefix            I   対象プリフィックス("C:\", ".", "..", "..\"等、"\\"は不可)
'           :iPath              I   対象パス
'Return     :Boolean型(True:含まれる　False:含まれない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsPrefix = PathIsPrefix(iPrefix, iPath)
    
End Function

Public Function Path_IsRelative(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsRelative
'Explanation:パスが相対パスか判定
'           :単に先頭が"."や".."で始まっているかどうか判定するだけなので注意
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:相対パス　False:絶対パス)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsRelative = PathIsRelative(iPath)
    
End Function

Public Function Path_IsRoot(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsRoot
'Explanation:パスがルートパスか判定
'           :"C:"等、末尾の"\"がないとルートパスではないと判定されるので注意
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:ルートパス　False:ルートパス以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsRoot = PathIsRoot(iPath)
    
End Function

Public Function Path_IsSameRoot(ByVal iPath1 As String, ByVal iPath2 As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsSameRoot
'Explanation:2つのパスが同じルートパスか判定
'Arguments  :iPath1             I   対象パス1
'           :iPath2             I   対象パス2
'Return     :Boolean型(True:同じルートパス　False:違うルートパス)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsSameRoot = PathIsSameRoot(iPath1, iPath2)
    
End Function

Public Function Path_IsSystemFolder(ByVal iPath As String, _
                                    Optional ByVal iAttrb As VbFileAttribute) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsSystemFolder
'Explanation:パスがシステムフォルダか判定
'           :パスを指定せずに属性を指定した際にはシステムフォルダ属性が含まれるか判定
'           :飽くまで"フォルダ"か判定するのでio.sys等のファイルではFalseになることに注意
'Arguments  :iPath              I   対象パス
'           :iAttrb             I   ファイル属性
'Return     :Boolean型(True:システムフォルダ　False:システムフォルダ以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsSystemFolder = PathIsSystemFolder(iPath, iAttrb)
    
End Function

Public Function Path_IsUNC(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNC
'Explanation:パスがUNC表記か判定
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:UNC表記　False:UNK表記以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsUNC = PathIsUNC(iPath)
    
End Function

Public Function Path_IsUNCServer(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNCServer
'Explanation:パスがサーバー名を表すUNCか判定
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:サーバー名を表している　False:それ以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsUNCServer = PathIsUNCServer(iPath)
    
End Function

Public Function Path_IsUNCServerShare(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNCServerShare
'Explanation:パスが共有名を表すUNCか判定
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:共有名を表している　False:それ以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsUNCServerShare = PathIsUNCServerShare(iPath)
    
End Function

Public Function Path_IsURL(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsURL
'Explanation:パスがURLを表すパスか判定
'           :2バイト以上の英数文字+":"だけでURLと判断されるようなので注意
'Arguments  :iPath              I   対象パス
'Return     :Boolean型(True:URLを表している　False:それ以外)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_IsURL = PathIsURL(iPath)
    
End Function

Public Function Path_MatchSpec(ByVal iFileParam As String, ByVal iSpec As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_MatchSpec
'Explanation:パスが検索文字列に一致するか判定
'Arguments  :iFileParam         I   対象パス
'           :iSpec              I   検索文字列(ワイルドカード可)
'Return     :Boolean型(True:一致する　False:一致しない)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    Path_MatchSpec = PathMatchSpec(iFileParam, iSpec)
    
End Function

Public Function Path_QuoteSpaces(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_QuoteSpaces
'Explanation:パスに空白が含まれていたらダブルクォーテーションで囲む
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathQuoteSpaces(wPath)
    Path_QuoteSpaces = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RelativePathTo(ByVal iFrom As String, ByVal iAttrFrom As VbFileAttribute, ByVal iTo As String, ByVal iAttrTo As VbFileAttribute) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RelativePathTo
'Explanation:FromパスからToパスを参照する相対パスを返す
'Arguments  :iFrom              I   参照元パス
'           :iAttrFrom          I   参照元パス属性(ファイルかディレクトリか)
'           :iTo                I   参照先パス
'           :iAttrTo            I   参照先パス属性
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathRelativePathTo(wPath, iFrom, iAttrFrom, iTo, iAttrTo)
    If wRet Then
        Path_RelativePathTo = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_RemoveArgs(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveArgs
'Explanation:パスからコマンドライン引数部分を削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathRemoveArgs(wPath)
    Path_RemoveArgs = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RemoveBackslash(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveBackslash
'Explanation:パス文字列の末尾からバックスラッシュを削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathRemoveBackslash(wPath)
    If wRet Then
        Path_RemoveBackslash = GetStrBeforeNULL(wPath)
    Else
        Path_RemoveBackslash = iPath
    End If
    
End Function

Public Function Path_RemoveExtension(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveExtension
'Explanation:パスから拡張子部分を削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathRemoveExtension(wPath)
    Path_RemoveExtension = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RemoveFileSpec(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveFileSpec
'Explanation:パスからファイル名部分を削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathRemoveFileSpec(wPath)
    If wRet Then
        Path_RemoveFileSpec = GetStrBeforeNULL(wPath)
    Else
        Path_RemoveFileSpec = iPath
    End If
    
End Function

Public Function Path_RenameExtension(ByVal iPath As String, ByVal iExtension As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RenameExtension
'Explanation:パスの拡張子を変更する
'           :パスに拡張子がない場合には指定した拡張子が追加される
'Arguments  :iPath              I   対象パス
'           :iExtension         I   変更する拡張子
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathRenameExtension(wPath, iExtension)
    If wRet Then
        Path_RenameExtension = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_SearchAndQualify(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_SearchAndQualify
'Explanation:カレントディレクトリを考慮してフルパスを取得する
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathSearchAndQualify(iPath, wPath, MAX_PATH)
    If wRet Then
        Path_SearchAndQualify = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_SkipRoot(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_SkipRoot
'Explanation:パスから共有名部分を削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wRet = PathSkipRoot(iPath)
    If wRet Then
        wLen = lstrlen(wRet) + 1
        wRet = lstrcpyn(wPath, wRet, wLen)
        If wRet Then
            Path_SkipRoot = GetStrBeforeNULL(wPath)
        End If
    Else
        Path_SkipRoot = iPath
    End If

End Function

Public Function Path_StripPath(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_StripPath
'Explanation:パスからファイル名部分を取得
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathStripPath(wPath)
    Path_StripPath = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_StripToRoot(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_StripToRoot
'Explanation:パスからルートパス部分を取得
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    wRet = PathStripToRoot(wPath)
    If wRet Then
        Path_StripToRoot = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_UnquoteSpaces(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_UnquoteSpaces
'Explanation:パス前後のダブルクォーテーションを削除
'Arguments  :iPath              I   対象パス
'Return     :String型
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API関数呼び出し
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathUnquoteSpaces(wPath)
    Path_UnquoteSpaces = GetStrBeforeNULL(wPath)
    
End Function
