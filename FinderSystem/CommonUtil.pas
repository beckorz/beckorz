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
  �������̈�m�� (from SysUtils.pas of Delphi VCL)
  @param Size   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

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

{*------------------------------------------------------------------------------
  ���C���h�J�[�h���������݂��Ă��邩? (*,? ��������)
  @param Pattern   ���肵����������
  @return ���C���h�J�[�h���������݂��Ă����ꍇ True
------------------------------------------------------------------------------*}
function IsWildcard(const iPattern: String): Boolean;
begin
  Result := (Pos('*', iPattern) <> 0) or (Pos('?', iPattern) <> 0);
end;

{*------------------------------------------------------------------------------
  GetLastError()�֐��Ŏ擾�ł���G���[�R�[�h����G���[���b�Z�[�W�����擾
  @param ErrorCode   �G���[�R�[�h(GetLastError����擾�ł���G���[�R�[�h�Ή�)
  @return �G���[���b�Z�[�W(OS�̌���Ή�
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
