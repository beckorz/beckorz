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

end.
