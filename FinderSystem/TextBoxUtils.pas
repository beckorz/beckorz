{*------------------------------------------------------------------------------
  �e�L�X�g�{�b�N�X�n���샆�j�b�g
  @Author    beck
  @Version   2009.03.05   beck	Initial revision
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
  �e�L�X�g�{�b�N�X�̃o�C�g�P�ʂł̓��͗}��

  comctrl32.dll �̃o�[�W����6�ȍ~(XP�ȍ~)�ŁAANSI�x�[�X����Unicode�x�[�X�ɕς������
  �������Ŕ��肳���̂Œ���

  @param hWnd   �E�B���h�E�n���h��
  @param iByte  �o�C�g������(comctrl32.dll ver6.0�ȍ~�͕�����)
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTexLimitMaxByte(hWnd: HWND; iLen: Integer);
begin
  SendMessage(hWnd, EM_LIMITTEXT, iLen, 0);
end;

{*------------------------------------------------------------------------------
  �G�f�B�b�g�R���g���[��(�e�L�X�g�{�b�N�X)�̓��͂𐔎������ɐ���
  @param hWnd   �E�B���h�E�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextStyle_Number(hWnd: HWND);
begin
  SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) xor ES_NUMBER);
end;

{*------------------------------------------------------------------------------
  �G�f�B�b�g�{�b�N�X�X�^�C����ύX(�啶�����͐����؂�ւ�)
  @param  Handle  �ΏۃG�f�B�b�g�{�b�N�X�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextBoxStyle_Upper(Handle: hWnd);
begin
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) xor ES_UPPERCASE);
end;

{*------------------------------------------------------------------------------
  �G�f�B�b�g�{�b�N�X�X�^�C����ύX(���������͐����؂�ւ�)
  @param  Handle  �ΏۃG�f�B�b�g�{�b�N�X�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetTextBoxStyle_Lower(Handle: hWnd);
begin
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) xor ES_LOWERCASE);
end;

end.