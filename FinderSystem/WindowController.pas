{*------------------------------------------------------------------------------
  �E�B���h�E��������t�H�[��
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit WindowController;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  TB2Item, TBX, SpTBXItem, SpTBXControls, TBXDkPanels, AppWinFix, ComCtrls,
  StdCtrls, SpTBXEditors, CommonUtil, Window;

type
  TfrmWindowController = class(TCustomSubForm)
    SpTBXGroupBox1: TSpTBXGroupBox;
    SpTBXStatusBar1: TSpTBXStatusBar;
    SpTBXLabelItem1: TSpTBXLabelItem;
    SpTBXLabelItem2: TSpTBXLabelItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    btnClose: TSpTBXButton;
    SpTBXGroupBox2: TSpTBXGroupBox;
    SpTBXLabel1: TSpTBXLabel;
    SpTBXLabel2: TSpTBXLabel;
    SpTBXLabel3: TSpTBXLabel;
    SpTBXLabel4: TSpTBXLabel;
    edtPosX: TSpTBXEdit;
    edtPosY: TSpTBXEdit;
    edtPosWidth: TSpTBXEdit;
    edtPosHeight: TSpTBXEdit;
    trbPosX: TSpTBXTrackBar;
    trbPosY: TSpTBXTrackBar;
    trbPosWidth: TSpTBXTrackBar;
    trbPosHeight: TSpTBXTrackBar;
    btnAppy: TSpTBXButton;
    btnGetWindowInfo: TSpTBXButton;
    SpTBXButton2: TSpTBXButton;
    procedure btnAppyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbPositionChange(Sender: TObject);
    procedure btnGetWindowInfoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private �錾 }
    procedure SetWindowPosition();
  public
    { Public �錾 }
    procedure LoadWindowPosition();
  end;

var
  frmWindowController: TfrmWindowController;

implementation

{$R *.dfm}

uses
  Main;

{*------------------------------------------------------------------------------
  ����
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnCloseClick(Sender: TObject);
begin
  // �Ăяo�����̃`�F�b�N�{�b�N�X���O��
  frmMain.mnuToolWindowOperate.Checked := not frmMain.mnuToolWindowOperate.Checked;
  Self.Close;
end;

{*------------------------------------------------------------------------------
  �t�H�[���쐬��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.FormCreate(Sender: TObject);
begin
  AppMinHide := False;
end;

{*------------------------------------------------------------------------------
  �g���b�N�o�[�ɂ��ʒu�ύX(�g���b�N�o�[�̋��ʃC�x���g)
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.trbPositionChange(Sender: TObject);
begin

  if Sender = trbPosX then begin               edtPosX.Text      := IntToStr(trbPosX.Position);
  end else if Sender = trbPosY then begin      edtPosY.Text      := IntToStr(trbPosY.Position);
  end else if Sender = trbPosWidth then begin  edtPosWidth.Text  := IntToStr(trbPosWidth.Position);
  end else if Sender = trbPosHeight then begin edtPosHeight.Text := IntToStr(trbPosHeight.Position);
  end;

  SetWindowPosition();

end;

{*------------------------------------------------------------------------------
  �E�B���h�E���擾
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnGetWindowInfoClick(Sender: TObject);
begin
  LoadWindowPosition();
end;

{*------------------------------------------------------------------------------
  �t�H�[�������
  @param Sender   ParameterDescription
  @param Action   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;           // �������j��
  frmWindowController := nil; // nil�Z�b�g(Assigned�`�F�b�N�̈�)
end;

{*------------------------------------------------------------------------------
  �K�p
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnAppyClick(Sender: TObject);
begin
  SetWindowPosition();
end;

{*------------------------------------------------------------------------------
  �E�B���h�E�̈ʒu��ǂݍ���
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.LoadWindowPosition();
var
  win: TRect;
begin

  // �C�x���g���������Ȃ��悤��nil
  trbPosX.OnChange := nil;
  trbPosY.OnChange := nil;
  trbPosWidth.OnChange := nil;
  trbPosHeight.OnChange := nil;

  // �E�B���h�E�̈ʒu����ݒ�(�E�B���h�E�����݂��Ă���ꍇ
  if (frmMain.FWindowInfo.Handle <> 0) and IsWindow(frmMain.FWindowInfo.Handle) then begin
    // �N���C�A���g��`�擾
    win := GetRelativeClientRect(frmMain.FWindowInfo.ParentHandle, frmMain.FWindowInfo.Handle);
    with win do begin
      edtPosX.Text := IntToStr(win.Left);
      edtPosY.Text := IntToStr(win.Top);
      edtPosWidth.Text := IntToStr(GetRectWidth(win));
      edtPosHeight.Text := IntToStr(GetRectHeight(win));
    end;
  end else begin
    // �E�B���h�E�n���h���������̏ꍇ
    edtPosX.Text := IntToStr(0);
    edtPosY.Text := IntToStr(0);
    edtPosWidth.Text := IntToStr(0);
    edtPosHeight.Text := IntToStr(0);
  end;

  // �g���b�N�o�[�̐ݒ�
  if IsNumeric(edtPosX.Text) then      trbPosX.Position      := StrToInt(edtPosX.Text);
  if IsNumeric(edtPosY.Text) then      trbPosY.Position      := StrToInt(edtPosY.Text);
  if IsNumeric(edtPosWidth.Text) then  trbPosWidth.Position  := StrToInt(edtPosWidth.Text);
  if IsNumeric(edtPosHeight.Text) then trbPosHeight.Position := StrToInt(edtPosHeight.Text);

  // �C�x���g�֘A�t����߂�
  trbPosX.OnChange := trbPositionChange;
  trbPosY.OnChange := trbPositionChange;
  trbPosWidth.OnChange := trbPositionChange;
  trbPosHeight.OnChange := trbPositionChange;
end;

{*------------------------------------------------------------------------------
  �E�B���h�E�̈ʒu��ݒ�
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.SetWindowPosition();
var
  Left, Top, Width, Height: Integer;
begin

  if not IsNumeric(edtPosX.Text)      then Exit else Left   := StrToInt(edtPosX.Text);
  if not IsNumeric(edtPosY.Text)      then Exit else Top    := StrToInt(edtPosY.Text);
  if not IsNumeric(edtPosWidth.Text)  then Exit else Width  := StrToInt(edtPosWidth.Text);
  if not IsNumeric(edtPosHeight.Text) then Exit else Height := StrToInt(edtPosHeight.Text);

  MoveWindow(frmMain.FWindowInfo.Handle, Left, Top, Width, Height, True);

end;

end.
