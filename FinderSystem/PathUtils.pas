{*------------------------------------------------------------------------------
  �p�X����n���j�b�g

  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit PathUtils;

interface

uses
  Windows, ShlObj, ActiveX;

  function GetShortPathString(const iLongName: String): String;
  function GetWindowsDirectoryName(): String;
  function GetSystemDirirectoryName(): String;
  function ExistsFile(const iFileName: String): Boolean;

implementation


//function InternalGetFileAttr(const Name: String): Integer;
//begin
//  Result := GetFileAttributes(PChar(RemoveBackslashUnlessRoot(Name)));
//end;

{*------------------------------------------------------------------------------
  �����t�@�C������Z���t�@�C�����ɕϊ�
  @param iLongName   �����t�@�C����
  @return �Z���t�@�C����(����������A��ŕԂ�?
------------------------------------------------------------------------------*}
function GetShortPathString(const iLongName: String): String;
var
  len: Integer;
begin
  len := GetShortPathName(PChar(iLongName), PChar(Result), 0);
  SetLength(Result, len);
end;

{*------------------------------------------------------------------------------
  Windows�f�B���N�g�����̂��擾
  (Windows�f�B���N�g�������[�g�f�B���N�g���̏ꍇ�A�Ō�Ƀo�b�N�X���b�V�����t���܂�)
  @return Windows�f�B���N�g����
------------------------------------------------------------------------------*}
function GetWindowsDirectoryName(): String;
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetWindowsDirectory(Buf, SizeOf(Buf));
  Result := String(Buf);
end;

{*------------------------------------------------------------------------------
  Windows�̃V�X�e���f�B���N�g���p�X�擾
  @return Windows�̃V�X�e���f�B���N�g���p�X
------------------------------------------------------------------------------*}
function GetSystemDirirectoryName(): String;
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetSystemDirectory(Buf, SizeOf(Buf));
  Result := String(Buf);
end;

{*------------------------------------------------------------------------------
  �t�@�C�������݂��邩?
  (�A�N�Z�X���������Ȃ��t�@�C���ł��`�F�b�N�ł���̂ŁADelphi��FileExists���ǂ��ł��B
  �A���AFileExists�́A���C���h�J�[�h�w�肪�\�����A�������͂ł��Ȃ��Ƃ���ɈႢ������܂��B)
  @param iPathName  �`�F�b�N����p�X��
  @return ���݂��Ă����ꍇ True ��Ԃ�
------------------------------------------------------------------------------*}
function ExistsFile(const iFileName: String): Boolean;
{ Returns True if the specified file exists.
  This function is better than Delphi's FileExists function because it works
  on files in directories that don't have "list" permission. There is, however,
  one other difference: FileExists allows wildcards, but this function does
  not. }
var
  Attr: Integer;
begin
  Attr := GetFileAttributes(PChar(iFileName));
  Result := (Attr <> -1) and (Attr and FILE_ATTRIBUTE_DIRECTORY = 0); //  faDirectory = 16
end;

{*------------------------------------------------------------------------------
  �t�H���_�����݂��Ă��邩�`�F�b�N
  @param Name   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
//function DirExists(const iPathName: String): Boolean;
//{ Returns True if the specified directory name exists. The specified name
//  may include a trailing backslash.
//  NOTE: Delphi's FileCtrl unit has a similar function called DirectoryExists.
//  However, the implementation is different between Delphi 1 and 2. (Delphi 1
//  does not count hidden or system directories as existing.) }
//var
//  Attr: Integer;
//begin
//  Attr := InternalGetFileAttr(iPathName);
//  Result := (Attr <> -1) and (Attr and FILE_ATTRIBUTE_DIRECTORY <> 0);  // faDirectory = 16
//end;

{*------------------------------------------------------------------------------
  ���ʂȃt�H���_�p�X�����擾

  ����) Shell�p���j�b�g���쐬���Ă������Ɉړ�����ׂ�

  @param FolderID   �t�H���_ID
  @return �t�H���_��
------------------------------------------------------------------------------*}
function GetShellFolderPath(const FolderID: Integer): String;
var
  pidl: PItemIDList;
  Buffer: array[0..MAX_PATH-1] of Char;
  Malloc: IMalloc;
begin
  Result := '';
  if FAILED(SHGetMalloc(Malloc)) then
    Malloc := nil;
  if SUCCEEDED(SHGetSpecialFolderLocation(0, FolderID, pidl)) then begin
    if SHGetPathFromIDList(pidl, Buffer) then
      Result := Buffer;
    if Assigned(Malloc) then
      Malloc.Free(pidl);
  end;
end;

end.
