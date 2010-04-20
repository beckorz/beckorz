{*------------------------------------------------------------------------------
  パス操作系ユニット

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
  長いファイルから短いファイル名に変換
  @param iLongName   長いファイル名
  @return 短いファイル名(無かったら、空で返す?
------------------------------------------------------------------------------*}
function GetShortPathString(const iLongName: String): String;
var
  len: Integer;
begin
  len := GetShortPathName(PChar(iLongName), PChar(Result), 0);
  SetLength(Result, len);
end;

{*------------------------------------------------------------------------------
  Windowsディレクトリ名称を取得
  (Windowsディレクトリがルートディレクトリの場合、最後にバックスラッシュが付きます)
  @return Windowsディレクトリ名
------------------------------------------------------------------------------*}
function GetWindowsDirectoryName(): String;
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetWindowsDirectory(Buf, SizeOf(Buf));
  Result := String(Buf);
end;

{*------------------------------------------------------------------------------
  Windowsのシステムディレクトリパス取得
  @return Windowsのシステムディレクトリパス
------------------------------------------------------------------------------*}
function GetSystemDirirectoryName(): String;
var
  Buf: array[0..MAX_PATH-1] of Char;
begin
  GetSystemDirectory(Buf, SizeOf(Buf));
  Result := String(Buf);
end;

{*------------------------------------------------------------------------------
  ファイルが存在するか?
  (アクセス許可を持たないファイルでもチェックできるので、DelphiのFileExistsより良いです。
  但し、FileExistsは、ワイルドカード指定が可能だが、こっちはできないところに違いがあります。)
  @param iPathName  チェックするパス名
  @return 存在していた場合 True を返す
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
  フォルダが存在しているかチェック
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
  特別なフォルダパス名を取得

  注意) Shell用ユニットを作成してそっちに移動するべき

  @param FolderID   フォルダID
  @return フォルダ名
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
