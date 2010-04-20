{*------------------------------------------------------------------------------
  OleAcc.dll���샆�j�b�g
  
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
  @param LRESULT   ����
  @param IID   �C���^�[�t�F�[�X
  @param wParam   �p�����[�^
  @param pObject   �擾�I�u�W�F�N�g
  @return ����
------------------------------------------------------------------------------*}
  TObjectFromLResult =
    function(LRESULT: lResult; const IID: TIID; wParam: wParam; out pObject): HRESULT; stdcall;

implementation

{*------------------------------------------------------------------------------
  �E�B���h�E�n���h������ IE�I�u�W�F�N�g(Trident)�擾
  @param Handle   �ΏۃE�B���h�E�n���h��
  @param IE   IE�I�u�W�F�N�g
  @return ����
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
      Msg := RegisterWindowMessage('WM_HTML_GETOBJECT');                      // ���[�U�[��`���b�Z�[�W�o�^
      SendMessageTimeOut(Handle, Msg, 0, 0, SMTO_ABORTIFHUNG, 1000, lRes);    // TimeOut�ݒ�
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
