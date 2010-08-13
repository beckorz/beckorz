{*------------------------------------------------------------------------------
  テキストボックス系操作ユニット
  
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit TextBoxUtils;

interface

uses
  Windows, Messages;

  procedure SetTexLimitMaxByte(hWnd: HWND; iLen: Integer);
  procedure SetTextStyle_Number(hWnd: HWND);
  procedure SetTextBoxStyle_Upper(Handle: hWnd);
  procedure SetTextBoxStyle_Lower(Handle: hWnd);

implementation

{*------------------------------------------------------------------------------
  テキストボックスのバイト単位での入力抑制

  comctrl32.dll のバージョン6以降(XP以降)で、ANSIベースからUnicodeベースに変わった為
  文字数で判定されるので注意

  @param hWnd   ウィンドウハンドル
  @param iByte  バイト制限数(comctrl32.dll ver6.0以降は文字数)
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTexLimitMaxByte(hWnd: HWND; iLen: Integer);
begin
  SendMessage(hWnd, EM_LIMITTEXT, iLen, 0);
end;

{*------------------------------------------------------------------------------
  エディットコントロール(テキストボックス)の入力を数字だけに制限
  @param hWnd   ウィンドウハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextStyle_Number(hWnd: HWND);
begin
  SetWindowLongW(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) xor ES_NUMBER);
end;

{*------------------------------------------------------------------------------
  エディットボックススタイルを変更(大文字入力制限切り替え)
  @param  Handle  対象エディットボックスハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextBoxStyle_Upper(Handle: hWnd);
begin
  SetWindowLongW(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) xor ES_UPPERCASE);
end;

{*------------------------------------------------------------------------------
  エディットボックススタイルを変更(小文字入力制限切り替え)
  @param  Handle  対象エディットボックスハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextBoxStyle_Lower(Handle: hWnd);
begin
  SetWindowLongW(Handle, GWL_STYLE, GetWindowLongW(Handle, GWL_STYLE) xor ES_LOWERCASE);
end;

end.
