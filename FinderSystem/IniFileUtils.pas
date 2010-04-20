{*------------------------------------------------------------------------------
  INIファイル操作ユニット
  
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit IniFileUtils;

interface

uses
  Windows;

//  function GetIniString(const Section, Key: String; Default: String; const Filename: String): String;
//  function GetIniInt(const Section, Key: String; const Default, Min, Max: Longint; const Filename: String): Longint;
//  function GetIniBool(const Section, Key: String; const Default: Boolean; const Filename: String): Boolean;
  function IniKeyExists(const Section, Key, Filename: String): Boolean;
  function IsIniSectionEmpty(const Section, Filename: String): Boolean;
  function SetIniString(const Section, Key, Value, Filename: String): Boolean;
//  function SetIniInt(const Section, Key: String; const Value: Longint; const Filename: String): Boolean;
//  function SetIniBool(const Section, Key: String; const Value: Boolean; const Filename: String): Boolean;
  procedure DeleteIniEntry(const Section, Key, Filename: String);
  procedure DeleteIniSection(const Section, Filename: String);

implementation

{*------------------------------------------------------------------------------
  INIファイルから文字列取得
  @param Section   ParameterDescription
  @param Key   ParameterDescription
  @param Filename   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
//function GetIniString(const Section, Key: String; Default: String; const Filename: String): String;
//var
//  BufSize, Len: Integer;
//begin
//  { On Windows 9x, Get*ProfileString can modify the lpDefault parameter, so
//    make sure it's unique and not read-only }
//  UniqueString(Default);
//  BufSize := 256;
//  while True do begin
//    SetString(Result, nil, BufSize);
//    if Filename <> '' then begin
//      Len := GetPrivateProfileString(PChar(Section), PChar(Key), PChar(Default), @Result[1], BufSize, PChar(Filename));
//    end else begin
//      Len := GetProfileString(PChar(Section), PChar(Key), PChar(Default), @Result[1], BufSize);
//    end;
//    { Work around bug present on Windows NT/2000 (not 95): When lpDefault is
//      too long to fit in the buffer, nSize is returned (null terminator
//      counted) instead of nSize-1 (what it's supposed to return). So don't
//      trust the returned length; calculate it ourself.
//      Note: This also ensures the string can never include embedded nulls. }
//    if Len <> 0 then begin
//      Len := StrLen(PChar(Result));
//    end;
//    { Break if the string fits, or if it's apparently 64 KB or longer.
//      No point in increasing buffer size past 64 KB because the length
//      returned by Windows 2000 seems to be mod 65536. And Windows 95 returns
//      0 on values longer than ~32 KB.
//      Note: The docs say the function returns "nSize minus one" if the buffer
//      is too small, but I'm willing to bet it can be "minus two" if the last
//      character is double-byte. Let's just be extremely paranoid and check for
//      BufSize-8. }
//    if (Len < BufSize-8) or (BufSize >= 65536) then begin
//      SetLength(Result, Len);
//      Break;
//    end;
//    { Otherwise double the buffer size and try again }
//    BufSize := BufSize * 2;
//  end;
//end;

{*------------------------------------------------------------------------------
  INIファイルから数値取得
  @param Section   ParameterDescription
  @param Key   ParameterDescription
  @param Min   ParameterDescription
  @param Max   ParameterDescription
  @param Filename   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
//function GetIniInt(const Section, Key: String; const Default, Min, Max: Longint; const Filename: String): Longint;
//{ Reads a Longint from an INI file. If the Longint read is not between Min/Max
//  then it returns Default. If Min=Max then Min/Max are ignored }
//var
//  S: String;
//  E: Integer;
//begin
//  S := GetIniString(Section, Key, '', Filename);
//  if S = '' then begin
//    Result := Default
//  end else begin
//    Val(S, Result, E);
//    if (E <> 0) or ((Min <> Max) and ((Result < Min) or (Result > Max))) then begin
//      Result := Default;
//    end;
//  end;
//end;

{*------------------------------------------------------------------------------
  INIファイルからBooleanで取得
  @param Section   ParameterDescription
  @param Key   ParameterDescription
  @param Filename   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
//function GetIniBool(const Section, Key: String; const Default: Boolean; const Filename: String): Boolean;
//begin
//  Result := GetIniInt(Section, Key, Ord(Default), 0, 0, Filename) <> 0;
//end;

{*------------------------------------------------------------------------------
  INIファイルにキーが存在しているか?
  @param Section   セクション名
  @param Key   キー名
  @param Filename   ファイル名
  @return 結果
------------------------------------------------------------------------------*}
function IniKeyExists(const Section, Key, Filename: String): Boolean;
  {*----------------------------------------------------------------------------

    @param  Default ParameterDescription
    @return ResultDescription
  ----------------------------------------------------------------------------*}
  function Equals(const Default: PChar): Boolean;
  var
    Test: array[0..7] of Char;
  begin
    Test[0] := #0;
    if Filename <> '' then begin
      GetPrivateProfileString(PChar(Section), PChar(Key), Default,
        Test, SizeOf(Test), PChar(Filename))
    end else begin
      GetProfileString(PChar(Section), PChar(Key), Default, Test, SizeOf(Test));
    end;
    Result := lstrcmp(Test, Default) = 0;
  end;
begin
  { If the key does not exist, a default string is returned both times. }
  Result := not Equals('x1234x') or not Equals('x5678x');  { <- don't change }
end;

{*------------------------------------------------------------------------------
  INIファイルのセクションが空か?
  @param Section   セクション名
  @param Filename   ファイル名
  @return 結果
------------------------------------------------------------------------------*}
function IsIniSectionEmpty(const Section, Filename: String): Boolean;
var
  Test: array[0..255] of Char;
begin
  Test[0] := #0;
  if Filename <> '' then begin
    GetPrivateProfileString(PChar(Section), nil, '', Test,
      SizeOf(Test), PChar(Filename))
  end else begin
    GetProfileString(PChar(Section), nil, '', Test, SizeOf(Test));
  end;
  Result := Test[0] = #0;
end;

{*------------------------------------------------------------------------------
  INIファイルに文字列セット
  @param Section   セクション名
  @param Key   キー名
  @param Value   値
  @param Filename   ファイル名
  @return 結果
------------------------------------------------------------------------------*}
function SetIniString(const Section, Key, Value, Filename: String): Boolean;
begin
  if Filename <> '' then begin
    Result := WritePrivateProfileString(PChar(Section), PChar(Key),
      PChar(Value), PChar(Filename))
  end else begin
    Result := WriteProfileString(PChar(Section), PChar(Key), PChar(Value));
  end;
end;

{*------------------------------------------------------------------------------

  @param Section   ParameterDescription
  @param Key   ParameterDescription
  @param Value   ParameterDescription
  @param Filename   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
//function SetIniInt(const Section, Key: String; const Value: Longint; const Filename: String): Boolean;
//begin
//  Result := SetIniString(Section, Key, IntToStr(Value), Filename);
//end;

{*------------------------------------------------------------------------------

  @param Section   ParameterDescription
  @param Key   ParameterDescription
  @param Value   ParameterDescription
  @param Filename   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
//function SetIniBool(const Section, Key: String; const Value: Boolean; const Filename: String): Boolean;
//begin
//  Result := SetIniInt(Section, Key, Ord(Value), Filename);
//end;

{*------------------------------------------------------------------------------
  INIファイルのエントリを削除
  @param Section   セクション名
  @param Key   キー名
  @param Filename   ファイル名
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure DeleteIniEntry(const Section, Key, Filename: String);
begin
  if Filename <> '' then begin
    WritePrivateProfileString(PChar(Section), PChar(Key), nil, PChar(Filename))
  end else begin
    WriteProfileString(PChar(Section), PChar(Key), nil);
  end;
end;

{*------------------------------------------------------------------------------
  INIファイルのセクションを削除
  @param Section  セクション名
  @param Filename   ファイル名
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure DeleteIniSection(const Section, Filename: String);
begin
  if Filename <> '' then begin
    WritePrivateProfileString(PChar(Section), nil, nil, PChar(Filename))
  end else begin
    WriteProfileString(PChar(Section), nil, nil);
  end;
end;

end.
