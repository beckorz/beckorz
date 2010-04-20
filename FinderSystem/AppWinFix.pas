{*------------------------------------------------------------------------------
  VCL�̃A�v���P�[�V�����E�B���h�E�̏C���p���j�b�g

  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

{ -----------------------------------
�A�v���P�[�V�����E�B���h�E�ɑ΂���Ώ�
    WindowVista�ł͂��Ȃ�K�{�̂悤�ł��B
    ����������A���̖��ɍ��{�I�ɑΏ��ł��Ȃ����낤���B
    ����5�`10�N����肪���u����Ă�B

���g����
�E  ���̃��j�b�g��uses�ɉ����Ă���
      uses +AppWinFix

�E  ���C���t�H�[���ł�
    �p������TForm��TCustomMainForm�ɕύX����
      TForm1 = class(TCustomMainForm)

�E  �A�v���P�[�V�����S�̂��ő剻/�ŏ���/���X�g�A������ꍇ��
      ApplicationMaximize/ApplicationMinimize/ApplicationRestore
    ���g������

�E  �T�u�t�H�[���ł�
    �p������TForm��TCustomSubForm�ɕύX����
      TForm2 = class(TCustomSubForm)
    �ύX���Ȃ��Ă����ɂ͂Ȃ�Ȃ������삪���肳���

�E  �T�u�t�H�[���ł�
    �������Ƀ^�X�N�o�[�ւ̓o�^������Z�I�[�_�[�����߂邽�߂�
      �@Form2 := TForm2.Create(Self, Self(=Form1).Handle);
      �AForm3 := TForm3.Create(Self, Application.Handle);
      �BForm4 := TForm4.Create(Self, GetDesktopWindow(=0));
    ��Create�̈����őI�����邱�Ƃ��ł���B
    Form1�̓��C���t�H�[���B

      �@Form1.Handle���w�肵����
          Form2�͏��Form1������O�ɂ���
          (���A�v���̑O�ʂɂ���킯�ł͂Ȃ�)
          Form2�̓^�X�N�o�[�ɓo�^����Ȃ�

      �AApplication.Handle���w�肵����
          Form1��Form3��Z�I�[�_�[�͐؂�ւ��\
          Form3�̓^�X�N�o�[�ɓo�^����Ȃ�

      �BGetDesktopWindow���w�肵����
          Form1��Form4��Z�I�[�_�[�͐؂�ւ��\
          Form4�̓^�X�N�o�[�ɓo�^�����

    ���̂悤�ȋ����������B
    �p������TForm��TCustomSubForm�ɕύX���Ă��Ȃ��ꍇ��
    �u�AApplication.Handle���w�肵�����v�Ɠ�������ɂȂ�B

�E  TCustomSubForm���w�肵���T�u�t�H�[���ł�
    AppMinHide�v���p�e�B��True/False�Ŏw�肷�邱�Ƃ��ł���B
    True�̏ꍇ(�w�肵�Ȃ��ꍇ�̃f�t�H���g)
      �A�v���P�[�V�����S��(���C���t�H�[��)���ŏ����������ɁA��\���ɂȂ�B
    False�̏ꍇ�A
      �A�v���P�[�V�����S�̂��ŏ������Ă��A�\������Ă���B
      ������Create�̈������@�̎��͂��̃t���O�͖��������
      �ŏ����������ɁA��\���ɂȂ�B

�E	���ۂɎg�����肪�悢�T�u�t�H�[���͇B�A�@�̏��Ԃ��Ǝv���B
	�_�C�A���O�Ƃ��Ďg���Ȃ�@�𗘗p����Ƃ悢���낤�B

2006/11/19 21:40
�E  �쐬
2006/12/10 0:23
�E	TCustomMainForm.CreateParams��Params.ExStyle��ύX

�Q�l����������������������������������������
D_DevLog �A�v���P�[�V�����E�B���h�E�ɑ΂���Ώ� (4)
http://ddev.blog46.fc2.com/blog-entry-70.html#more
�����̃��j�b�g����������Ă���

Delphi�ŁAWindows Vista Ready�A�v���P�[�V���������
http://bdn.borland.com/article/33747
//----------------------------------- }

unit AppWinFix;

interface

uses
  Windows, Controls, Forms, Dialogs, Messages, Classes, SysUtils;

type
  { ���C���t�H�[���p }
  TCustomMainForm = class(TForm)
  private
    FWindowList: TList;
    procedure RestoreAllForm;
    procedure HideAllForm;
  protected
    procedure DoShow; override;   // private������
//    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {���A�v���P�[�V�����̍ŏ��ő�ʏ퉻���\�b�h}
    procedure ApplicationMaximize;
    procedure ApplicationMinimize;
    procedure ApplicationRestore;
  end;

type
  { �T�u�t�H�[���p }
  TCustomSubForm = class(TForm)
  private
    FParentWinHandle: HWND;
    FAppMinHide: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;  // private������
  public
    constructor Create(AOwner: TComponent; ParentWinHandle: HWND);
    property ParentWinHandle: HWND read FParentWinHandle write FParentWinHandle;
  published
    property AppMinHide: Boolean read FAppMinHide write FAppMinHide;
  end;

implementation

{ TCustomMainForm }

{*------------------------------------------------------------------------------
  �ő剻
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationMaximize;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0 );
end;

{*------------------------------------------------------------------------------
  �ŏ���
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationMinimize;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0 );
end;

{*------------------------------------------------------------------------------
  ���ɖ߂�
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationRestore;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0 );
end;

{*------------------------------------------------------------------------------
  ���ׂẴt�H�[����\��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.HideAllForm;
var
  i: Integer;
begin

  for i := 0 to Screen.FormCount - 1 do begin
    if Screen.Forms[i] = Self then
      Continue;

    if Screen.Forms[i].Visible then begin
      if (Screen.Forms[i] is TCustomSubForm)
        and (TCustomSubForm(Screen.Forms[i]).AppMinHide = False) then begin

      end else begin
        FWindowList.Add(Screen.Forms[i]);
        Screen.Forms[i].Visible := False;
      end;
    end;

  end;
  {��MainForm�̍ŏ����^�C�~���O�ɂ��킹��
     �\������Ă���Form��TCustomSubForm�Ȃ��\���ɂ���
     AppMinHide�v���p�e�B���`�F�b�N���Ă���}
end;

{*------------------------------------------------------------------------------
  �S�ẴE�B���h�E�����ɖ߂�
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.RestoreAllForm;
var
  i: Integer;
begin

  for i := 0 to Screen.FormCount - 1 do begin
    if Screen.Forms[i] = Self then
      Continue;

    if FWindowList.IndexOf(Screen.Forms[i]) <> -1 then begin
      Screen.Forms[i].Visible := True;
    end;

  end;
  {��MainForm�̌��ɖ߂��^�C�~���O�ɂ��킹��
     ��\���ɂȂ���Form��\������}
  FWindowList.Clear;
end;

{*------------------------------------------------------------------------------
  �R���X�g���N�^
  @param AOwner   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TCustomMainForm.Create(AOwner: TComponent);
begin
  FWindowList := TList.Create;
  inherited;
end;

{*------------------------------------------------------------------------------
  �p�����[�^�쐬
  @param Params   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
//  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
  {������L�L�q�ł�MainForm��BorderStyle:=bsToolWindow���w�肵�Ă���ꍇ�Ȃǂ�
       �듮�삪�N����̂ŁA���L�̂悤�ɂ��Ă���}
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
  {��MainForm���^�X�N�o�[�ɓo�^}
end;

{*------------------------------------------------------------------------------
  �f�X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TCustomMainForm.Destroy;
begin
  inherited;
  FWindowList.Free;
end;

{*------------------------------------------------------------------------------
  �A�N�e�B�u��
  @return ResultDescription
------------------------------------------------------------------------------*}
//procedure TCustomMainForm.WMActivate(var Message: TWMActivate);
//begin
//  inherited;
//  ShowWindow(Application.Handle, SW_HIDE);
//end;
{����WMActive�ōs�����DoShow�C�x���g�ōs���������悢�̂ŕύX}

{*------------------------------------------------------------------------------
  �\��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.DoShow;
begin
  inherited;
  ShowWindow(Application.Handle,SW_HIDE);
  //�^�X�N�}�l�[�W���[����ApplicationWindow�̓o�^������
end;

{*------------------------------------------------------------------------------
  �T�C�Y�ύX��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.WMSize(var Message: TWMSize);
begin

  case Message.SizeType of
    SIZE_MINIMIZED: HideAllForm;
    SIZE_RESTORED,
    SIZE_MAXIMIZED: RestoreAllForm;
  end;

  inherited;

end;

{*------------------------------------------------------------------------------
  �V�X�e���R�}���h
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.WMSysCommand(var Message: TWmSysCommand);
begin

  case (Message.CmdType and $FFF0) of
    SC_MINIMIZE: begin
      ShowWindow(Handle, SW_MINIMIZE);

      if Assigned(Application.OnMinimize) then
        Application.OnMinimize(Self);

      Message.Result := 0;
    end;
    SC_RESTORE: begin
      ShowWindow(Handle, SW_RESTORE);

      if Assigned(Application.OnRestore) then
        Application.OnRestore(Self);

      Message.Result := 0;
    end;
  else
    inherited;
  end;

end;

{ TCustomSubForm }

{*------------------------------------------------------------------------------
  �T�u�t�H�[���쐬��
  @param AOwner   ParameterDescription
  @param ParentWinHandle   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TCustomSubForm.Create(AOwner: TComponent; ParentWinHandle: HWND);
begin
  FParentWinHandle := ParentWinHandle;
  AppMinHide := True;
  inherited Create(AOwner);
end;

{*------------------------------------------------------------------------------
  �p�����[�^�쐬
  @param Params   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomSubForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FParentWinHandle;
end;

initialization
  {���p�b�P�[�W�ɑg�ݍ��ނ�IDE�̃^�X�N�o�[�{�^���������Ă��܂��̂ŁA���̑΍􏈗�}
  if not SameText(ExtractFileName(Application.ExeName), 'bds.exe') then begin
    {���A�v���P�[�V�����E�B���h�E���^�X�N�{�^�����������ʂ̑��݂�����}
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW
      or WS_EX_TOOLWINDOW);
  //  ShowWindow(Application.Handle, SW_SHOW);

//    Application.ModalPopupMode := pmExplicit;
    {��D_DevLog�F�A�v���P�[�V�����E�B���h�E�ɑ΂���Ώ� (2)�F2006/11/07(��)���
       ShowModal���l�AShowMessage��TOpenDialog���̃R�����_�C�A���O��
       �t�H�[���̃^�X�N�o�[�{�^�����N���b�N�����Ƃ��̖�肪��������B
       ���Ƃւ̑Ή�}
  end;
end.

