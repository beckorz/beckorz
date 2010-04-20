{*------------------------------------------------------------------------------
  OleAcc.dll操作ユニット
  
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit OleAcc;

interface

uses
  Windows, ActiveX, Shdocvw_tlb, MSHTML;

  function GetIEFromHWND(Handle: HWND; var IE: IWebbrowser2): HRESULT;

type
{*------------------------------------------------------------------------------
  ObjectFromLResult
  @param LRESULT   結果
  @param IID   インターフェース
  @param wParam   パラメータ
  @param pObject   取得オブジェクト
  @return 結果
------------------------------------------------------------------------------*}
  TObjectFromLResult =
    function(LRESULT: lResult; const IID: TIID; wParam: wParam; out pObject): HRESULT; stdcall;

implementation

{*------------------------------------------------------------------------------
  ウィンドウハンドルから IEオブジェクト(Trident)取得
  @param Handle   対象ウィンドウハンドル
  @param IE   IEオブジェクト
  @return 結果
------------------------------------------------------------------------------*}
function GetIEFromHWND(Handle: HWND; var IE: IWebbrowser2): HRESULT;
var
  hInst: HWND;
  lRes: Cardinal;
  Msg: Integer;
  pDoc: IHTMLDocument2;
  ObjectFromLresult: TObjectFromLResult;
begin
  hInst := LoadLibrary('Oleacc.dll');
  @ObjectFromLresult := GetProcAddress(hInst, 'ObjectFromLresult');
  if @ObjectFromLresult <> nil then begin
    try
      Msg := RegisterWindowMessage('WM_HTML_GETOBJECT');                      // ユーザー定義メッセージ登録
      SendMessageTimeOut(Handle, Msg, 0, 0, SMTO_ABORTIFHUNG, 1000, lRes);    // TimeOut設定
      Result := ObjectFromLresult(lRes, IHTMLDocument2, 0, pDoc);
      if Result = S_OK then begin
        (pDoc.parentWindow as IServiceprovider).QueryService(IWebbrowserApp, IWebbrowser2, IE);
      end;
    finally
      FreeLibrary(hInst);
    end;
  end;
end;

end.
