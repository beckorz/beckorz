{*------------------------------------------------------------------------------
  ���ʃ��[�e�B���e�B���j�b�g
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit CommonUtil;

interface
{ �錾�� }

uses
  Windows;

  function IsNumeric(S : String) : Boolean;
  function IsDebugging() : Boolean;

implementation
{ ������ }

{*------------------------------------------------------------------------------
  ���l��?
  @param S   ������
  @return ����
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
  �f�o�b�O����?
  @return ����
------------------------------------------------------------------------------*}
function IsDebugging() : Boolean;
begin
  Result := (DebugHook <> 0)
end;

end.
