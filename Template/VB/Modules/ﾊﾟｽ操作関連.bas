Attribute VB_Name = "M_PathOperation"
Option Explicit
'////////////////////////////////////////////////////////////////////////
'�p�X����֘AAPI�֐����b�p�[���W���[��
'   M_PathOperation
'       2006/11/21 DATACOM �������[
'////////////////////////////////////////////////////////////////////////

'////////////////////////////////////////////////////////////////////////
'   Win32API�֐��錾
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
'   �萔�錾
'////////////////////////////////////////////////////////////////////////
Private Const MAX_PATH As Long = 260

Public Const GCT_INVALID As Long = 0        '�p�X�Ɏg�p�ł��Ȃ�����
Public Const GCT_LFNCHAR As Long = 1        '�����`���̃t�@�C�����Ɏg�p�ł��镶��
Public Const GCT_SHORTCHAR As Long = 2      '�Z���`���̃t�@�C�����Ɏg�p�ł��镶��
Public Const GCT_WILD As Long = 4           '���C���h�J�[�h����
Public Const GCT_SEPARATOR As Long = 8      '�p�X�̋�؂蕶��

Private Function GetStrBeforeNULL(ByRef iString) As String
'////////////////////////////////////////////////////////////////////////
'Name       :GetStrBeforeNULL
'Explanation:NULL�I�[�������NULL��O�܂ł�Ԃ�
'Arguments  :iString            O   �Ώە�����
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wIndex                      As Long

    '********************************************************************
    '   ���ʂ�Ԃ�
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
'Explanation:�p�X������̖����Ƀo�b�N�X���b�V����ǉ�����
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X������Ɋg���q��ǉ�����
'Arguments  :iPath              I   �Ώۃp�X
'           :iExtension         I   �ǉ�����g���q(".txt"��)
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X������Ƀp�X��ǉ�����
'Arguments  :iPath              I   �Ώۃp�X
'           :iMore              I   �ǉ�����p�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�h���C�u�ԍ����烋�[�g�p�X���擾����
'Arguments  :iDrive             I   �h���C�u�ԍ�(0�`25)
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wRet = PathBuildRoot(wPath, iDrive)
    If wRet Then
        Path_BuildRoot = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_Canonicalize(ByVal iSrc As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_Canonicalize
'Explanation:���΃p�X��������΃p�X�ɕϊ�����
'Arguments  :iSrc               I   ���΃p�X������
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�f�B���N�g���p�X�ƃt�@�C���p�X����������
'Arguments  :iDir               I   �f�B���N�g���p�X
'           :iFile              I   �t�@�C���p�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wRet = PathCombine(wPath, iDir, iFile)
    If wRet Then
        Path_Combine = GetStrBeforeNULL(wPath)
    End If

End Function

Public Function Path_CommonPrefix(ByVal iFile1 As String, ByVal iFile2 As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_CommonPrefix
'Explanation:2�̃p�X�ŋ��ʂ��Ă��镔�����擾����
'           :�P���ȑO����v�����ő��΃p�X�����̂܂ܔ�r����邱�Ƃɒ���
'Arguments  :iFile1             I   �Ώۃp�X1
'           :iFile2             I   �Ώۃp�X2
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wRet = PathCommonPrefix(iFile1, iFile2, wPath)
    If wRet Then
        Path_CommonPrefix = GetStrBeforeNULL(wPath)
    End If

End Function

Public Function Path_CompactPath(ByVal hDC As Long, ByVal iPath As String, ByVal iWidth As Long) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_CompactPath
'Explanation:�w�蕝�ɍ��킹�ăp�X��������ȗ�����
'           :PictureBox���t�H���g�ݒ�\��DC�����R���g���[���ɒ���Print����ۂɎg����
'Arguments  :hDC                I   �Ώۃf�o�C�X�R���e�L�X�g�n���h��
'           :iPath              I   �Ώۃp�X
'           :iWidth             I   ��(�s�N�Z���P��)
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�w��o�C�g���Ńp�X��������ȗ�����
'           :�p�X��2�o�C�g�������܂܂��ƕ�����������\������
'Arguments  :iPath              I   �Ώۃp�X
'           :iMax               I   �o�C�g��
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�Ώۃp�X�����݂��邩����
'           :�O���܂Ńp�X�̔���ł���t�@�C���E�f�B���N�g���̋�ʂ͂Ȃ����Ƃɒ���
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:���݂���@False:���݂��Ȃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_FileExists = PathFileExists(iPath)
    
End Function

Public Function Path_FindExtension(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_FindExtension
'Explanation:�p�X����g���q����("."����)���擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wExtension                  As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X����t�@�C�����������擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wFileName                   As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X�̎��̍\���v�f����������
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�W��(���ϐ�)�̃p�X�{�ǉ��w�肵���p�X����t�@�C�����������Đ�΃p�X��Ԃ�
'Arguments  :iFile              I   �Ώۃt�@�C��
'           :iOtherDirs         I   �ǉ��w��p�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH
Dim wRet                        As Boolean
Dim wOtherDirs                  As String

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X����R�}���h���C�������������擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X���\�����镶���̎�ʂ𔻒肷��
'Arguments  :iChar              I   �Ώە���
'Return     :Long�^(GCT_XXX�萔�̑g�ݍ��킹)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_GetCharType = PathGetCharType(Asc(iChar))
    
End Function

Public Function Path_GetDriveNumber(ByVal iPath As String) As Long
'////////////////////////////////////////////////////////////////////////
'Name       :Path_GetDriveNumber
'Explanation:�p�X������h���C�u�ԍ����擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Long�^(0:A�`25:Z, ���s���ɂ�-1)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_GetDriveNumber = PathGetDriveNumber(iPath)
    
End Function

Public Function Path_IsContentType(ByVal iPath As String, ByVal iContentType As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsContentType
'Explanation:�p�X���w�肳�ꂽ�R���e���g�^�C�v������(�g���q����)
'Arguments  :iPath              I   �Ώۃp�X
'           :iContentType       I   �ΏۃR���e���g�^�C�v("text/plain"��"image/gif"��)
'Return     :Boolean�^(True:�R���e���g�^�C�v�ƍ��v����@False:�R���e���g�^�C�v�ƍ��v���Ȃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsContentType = PathIsContentType(iPath, iContentType)
    
End Function

Public Function Path_IsDirectory(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsDirectory
'Explanation:�Ώۃf�B���N�g�������݂��邩����
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:���݂���@False:���݂��Ȃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsDirectory = PathIsDirectory(iPath)
    
End Function

Public Function Path_IsFileSpec(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsFileSpec
'Explanation:�p�X�ɋ�؂蕶�����܂܂�Ă��邩�𔻒�
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:�܂܂�Ȃ��@False:�܂܂��)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsFileSpec = PathIsFileSpec(iPath)
    
End Function

Public Function Path_IsPrefix(ByVal iPrefix As String, ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsPrefix
'Explanation:�p�X�Ɏw��v���t�B�b�N�X���܂܂�邩����
'Arguments  :iPrefix            I   �Ώۃv���t�B�b�N�X("C:\", ".", "..", "..\"���A"\\"�͕s��)
'           :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:�܂܂��@False:�܂܂�Ȃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsPrefix = PathIsPrefix(iPrefix, iPath)
    
End Function

Public Function Path_IsRelative(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsRelative
'Explanation:�p�X�����΃p�X������
'           :�P�ɐ擪��"."��".."�Ŏn�܂��Ă��邩�ǂ������肷�邾���Ȃ̂Œ���
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:���΃p�X�@False:��΃p�X)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsRelative = PathIsRelative(iPath)
    
End Function

Public Function Path_IsRoot(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsRoot
'Explanation:�p�X�����[�g�p�X������
'           :"C:"���A������"\"���Ȃ��ƃ��[�g�p�X�ł͂Ȃ��Ɣ��肳���̂Œ���
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:���[�g�p�X�@False:���[�g�p�X�ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsRoot = PathIsRoot(iPath)
    
End Function

Public Function Path_IsSameRoot(ByVal iPath1 As String, ByVal iPath2 As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsSameRoot
'Explanation:2�̃p�X���������[�g�p�X������
'Arguments  :iPath1             I   �Ώۃp�X1
'           :iPath2             I   �Ώۃp�X2
'Return     :Boolean�^(True:�������[�g�p�X�@False:�Ⴄ���[�g�p�X)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsSameRoot = PathIsSameRoot(iPath1, iPath2)
    
End Function

Public Function Path_IsSystemFolder(ByVal iPath As String, _
                                    Optional ByVal iAttrb As VbFileAttribute) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsSystemFolder
'Explanation:�p�X���V�X�e���t�H���_������
'           :�p�X���w�肹���ɑ������w�肵���ۂɂ̓V�X�e���t�H���_�������܂܂�邩����
'           :�O���܂�"�t�H���_"�����肷��̂�io.sys���̃t�@�C���ł�False�ɂȂ邱�Ƃɒ���
'Arguments  :iPath              I   �Ώۃp�X
'           :iAttrb             I   �t�@�C������
'Return     :Boolean�^(True:�V�X�e���t�H���_�@False:�V�X�e���t�H���_�ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsSystemFolder = PathIsSystemFolder(iPath, iAttrb)
    
End Function

Public Function Path_IsUNC(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNC
'Explanation:�p�X��UNC�\�L������
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:UNC�\�L�@False:UNK�\�L�ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsUNC = PathIsUNC(iPath)
    
End Function

Public Function Path_IsUNCServer(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNCServer
'Explanation:�p�X���T�[�o�[����\��UNC������
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:�T�[�o�[����\���Ă���@False:����ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsUNCServer = PathIsUNCServer(iPath)
    
End Function

Public Function Path_IsUNCServerShare(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsUNCServerShare
'Explanation:�p�X�����L����\��UNC������
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:���L����\���Ă���@False:����ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsUNCServerShare = PathIsUNCServerShare(iPath)
    
End Function

Public Function Path_IsURL(ByVal iPath As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_IsURL
'Explanation:�p�X��URL��\���p�X������
'           :2�o�C�g�ȏ�̉p������+":"������URL�Ɣ��f�����悤�Ȃ̂Œ���
'Arguments  :iPath              I   �Ώۃp�X
'Return     :Boolean�^(True:URL��\���Ă���@False:����ȊO)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_IsURL = PathIsURL(iPath)
    
End Function

Public Function Path_MatchSpec(ByVal iFileParam As String, ByVal iSpec As String) As Boolean
'////////////////////////////////////////////////////////////////////////
'Name       :Path_MatchSpec
'Explanation:�p�X������������Ɉ�v���邩����
'Arguments  :iFileParam         I   �Ώۃp�X
'           :iSpec              I   ����������(���C���h�J�[�h��)
'Return     :Boolean�^(True:��v����@False:��v���Ȃ�)
'////////////////////////////////////////////////////////////////////////

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    Path_MatchSpec = PathMatchSpec(iFileParam, iSpec)
    
End Function

Public Function Path_QuoteSpaces(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_QuoteSpaces
'Explanation:�p�X�ɋ󔒂��܂܂�Ă�����_�u���N�H�[�e�[�V�����ň͂�
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathQuoteSpaces(wPath)
    Path_QuoteSpaces = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RelativePathTo(ByVal iFrom As String, ByVal iAttrFrom As VbFileAttribute, ByVal iTo As String, ByVal iAttrTo As VbFileAttribute) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RelativePathTo
'Explanation:From�p�X����To�p�X���Q�Ƃ��鑊�΃p�X��Ԃ�
'Arguments  :iFrom              I   �Q�ƌ��p�X
'           :iAttrFrom          I   �Q�ƌ��p�X����(�t�@�C�����f�B���N�g����)
'           :iTo                I   �Q�Ɛ�p�X
'           :iAttrTo            I   �Q�Ɛ�p�X����
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wRet = PathRelativePathTo(wPath, iFrom, iAttrFrom, iTo, iAttrTo)
    If wRet Then
        Path_RelativePathTo = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_RemoveArgs(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveArgs
'Explanation:�p�X����R�}���h���C�������������폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathRemoveArgs(wPath)
    Path_RemoveArgs = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RemoveBackslash(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveBackslash
'Explanation:�p�X������̖�������o�b�N�X���b�V�����폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X����g���q�������폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathRemoveExtension(wPath)
    Path_RemoveExtension = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_RemoveFileSpec(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_RemoveFileSpec
'Explanation:�p�X����t�@�C�����������폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X�̊g���q��ύX����
'           :�p�X�Ɋg���q���Ȃ��ꍇ�ɂ͎w�肵���g���q���ǉ������
'Arguments  :iPath              I   �Ώۃp�X
'           :iExtension         I   �ύX����g���q
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�J�����g�f�B���N�g�����l�����ăt���p�X���擾����
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wRet = PathSearchAndQualify(iPath, wPath, MAX_PATH)
    If wRet Then
        Path_SearchAndQualify = GetStrBeforeNULL(wPath)
    End If
    
End Function

Public Function Path_SkipRoot(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_SkipRoot
'Explanation:�p�X���狤�L���������폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Long
Dim wLen                        As Long
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X����t�@�C�����������擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathStripPath(wPath)
    Path_StripPath = GetStrBeforeNULL(wPath)
    
End Function

Public Function Path_StripToRoot(ByVal iPath As String) As String
'////////////////////////////////////////////////////////////////////////
'Name       :Path_StripToRoot
'Explanation:�p�X���烋�[�g�p�X�������擾
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wRet                        As Boolean
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
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
'Explanation:�p�X�O��̃_�u���N�H�[�e�[�V�������폜
'Arguments  :iPath              I   �Ώۃp�X
'Return     :String�^
'////////////////////////////////////////////////////////////////////////
Dim wPath                       As String * MAX_PATH

    '********************************************************************
    '   API�֐��Ăяo��
    '********************************************************************
    wPath = iPath & vbNullChar
    Call PathUnquoteSpaces(wPath)
    Path_UnquoteSpaces = GetStrBeforeNULL(wPath)
    
End Function
