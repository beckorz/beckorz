{*------------------------------------------------------------------------------
  共通ユーティリティユニット
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit CommonUtil;

interface
{ 宣言部 }

uses
  Windows;

  function IsNumeric(S : String) : Boolean;
  function IsDebugging() : Boolean;

implementation
{ 実装部 }

{*------------------------------------------------------------------------------
  メモリ領域確保 (from SysUtils.pas of Delphi VCL)
  @param Size   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

{*------------------------------------------------------------------------------
  数値か?
  @param S   文字列
  @return 結果
------------------------------------------------------------------------------*}
function IsNumeric(S : String) : Boolean;
var
  E : Integer;
  R : Integer;
begin
  Val(S, R, E);
  Result := (E = 0);
end;

{*------------------------------------------------------------------------------
  デバッグ中か?
  @return 結果
------------------------------------------------------------------------------*}
function IsDebugging() : Boolean;
begin
  Result := (DebugHook <> 0)
end;

{*------------------------------------------------------------------------------
  ワイルドカード文字が存在しているか? (*,? 文字判定)
  @param Pattern   判定したい文字列
  @return ワイルドカード文字が存在していた場合 True
------------------------------------------------------------------------------*}
function IsWildcard(const iPattern: String): Boolean;
begin
  Result := (Pos('*', iPattern) <> 0) or (Pos('?', iPattern) <> 0);
end;

{*------------------------------------------------------------------------------
  GetLastError()関数で取得できるエラーコードからエラーメッセージ名を取得
  @param ErrorCode   エラーコード(GetLastErrorから取得できるエラーコード対応)
  @return エラーメッセージ(OSの言語対応
------------------------------------------------------------------------------*}
function GetLastErrorString(ErrorCode: Integer): String;
const
  MAX_MES = 512;
var
  Buf: PChar;
begin
  Buf := AllocMem(MAX_MES);
  try
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, ErrorCode,
                  (SUBLANG_DEFAULT shl 10) + LANG_NEUTRAL,
                  Buf, MAX_MES, nil);
  finally
    Result := Buf;
    FreeMem(Buf);
  end;
end;


end.
