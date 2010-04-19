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
  StdCtrls, SpTBXEditors, CommonUtil, Window, SpTBXTabs, TB2Dock,
  TB2Toolbar, ImgList;

type
  TfrmWindowController = class(TCustomSubForm)
    SpTBXStatusBar1: TSpTBXStatusBar;
    SpTBXLabelItem1: TSpTBXLabelItem;
    SpTBXLabelItem2: TSpTBXLabelItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    btnClose: TSpTBXButton;
    imlTool: TImageList;
    SpTBXTabControl1: TSpTBXTabControl;
    SpTBXTabItem6: TSpTBXTabItem;
    SpTBXTabSheet1: TSpTBXTabSheet;
    SpTBXTabItem7: TSpTBXTabItem;
    SpTBXTabSheet2: TSpTBXTabSheet;
    SpTBXGroupBox1: TSpTBXGroupBox;
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
    SpTBXToolbar1: TSpTBXToolbar;
    SpTBXItem6: TSpTBXItem;
    SpTBXItem7: TSpTBXItem;
    SpTBXItem8: TSpTBXItem;
    SpTBXItem9: TSpTBXItem;
    SpTBXToolbar2: TSpTBXToolbar;
    SpTBXTabItem8: TSpTBXTabItem;
    SpTBXTabSheet3: TSpTBXTabSheet;
    SpTBXTabItem9: TSpTBXTabItem;
    SpTBXTabSheet4: TSpTBXTabSheet;
    SpTBXTabItem10: TSpTBXTabItem;
    SpTBXTabSheet5: TSpTBXTabSheet;
    edtStyle: TSpTBXEdit;
    SpTBXLabel5: TSpTBXLabel;
    btnApplyStyle: TSpTBXButton;
    SpTBXButton3: TSpTBXButton;
    btnGetStyle: TSpTBXButton;
    SpTBXButton5: TSpTBXButton;
    chkStyles0: TSpTBXCheckBox;
    chkStyles1: TSpTBXCheckBox;
    chkStyles2: TSpTBXCheckBox;
    chkStyles3: TSpTBXCheckBox;
    chkStyles4: TSpTBXCheckBox;
    chkStyles5: TSpTBXCheckBox;
    chkStyles6: TSpTBXCheckBox;
    chkStyles7: TSpTBXCheckBox;
    chkStyles8: TSpTBXCheckBox;
    chkStyles9: TSpTBXCheckBox;
    chkStyles10: TSpTBXCheckBox;
    chkStyles11: TSpTBXCheckBox;
    chkStyles12: TSpTBXCheckBox;
    chkStyles13: TSpTBXCheckBox;
    chkStyles14: TSpTBXCheckBox;
    chkStyles15: TSpTBXCheckBox;
    chkStyles16: TSpTBXCheckBox;
    chkStyles17: TSpTBXCheckBox;
    chkStyles18: TSpTBXCheckBox;
    chkStyles19: TSpTBXCheckBox;
    chkStyles20: TSpTBXCheckBox;
    chkStyles21: TSpTBXCheckBox;
    edtExStyle: TSpTBXEdit;
    SpTBXLabel6: TSpTBXLabel;
    chkExStyles0: TSpTBXCheckBox;
    btnApplyExStyle: TSpTBXButton;
    btnGetExStyle: TSpTBXButton;
    chkExStyles1: TSpTBXCheckBox;
    chkExStyles2: TSpTBXCheckBox;
    chkExStyles3: TSpTBXCheckBox;
    chkExStyles4: TSpTBXCheckBox;
    chkExStyles5: TSpTBXCheckBox;
    chkExStyles6: TSpTBXCheckBox;
    chkExStyles7: TSpTBXCheckBox;
    chkExStyles8: TSpTBXCheckBox;
    chkExStyles9: TSpTBXCheckBox;
    SpTBXLabel7: TSpTBXLabel;
    SpTBXCheckBox1: TSpTBXCheckBox;
    SpTBXTrackBar1: TSpTBXTrackBar;
    SpTBXCheckBox2: TSpTBXCheckBox;
    SpTBXLabel8: TSpTBXLabel;
    SpTBXLabel9: TSpTBXLabel;
    SpTBXLabel10: TSpTBXLabel;
    SpTBXEdit1: TSpTBXEdit;
    SpTBXEdit2: TSpTBXEdit;
    SpTBXEdit3: TSpTBXEdit;
    SpTBXButton4: TSpTBXButton;
    btnApplyTransparent: TSpTBXButton;
    SpTBXButton6: TSpTBXButton;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    SpTBXItem4: TSpTBXItem;
    SpTBXButton7: TSpTBXButton;
    SpTBXButton8: TSpTBXButton;
    procedure btnAppyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbPositionChange(Sender: TObject);
    procedure btnGetWindowInfoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkStylesClick(Sender: TObject);
    procedure btnApplyStyleClick(Sender: TObject);
    procedure btnGetStyleClick(Sender: TObject);
    procedure chkExStylesClick(Sender: TObject);
    procedure btnApplyExStyleClick(Sender: TObject);
    procedure btnGetExStyleClick(Sender: TObject);
  private
    { Private �錾 }
    FStyle : Integer;
    FExStyle : Integer;
    procedure SetWindowPosition();
  public
    { Public �錾 }
    procedure LoadWindowPosition();
    procedure LoadStyle();
    procedure LoadExStyle();
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

  chkStyles0.Hint  := '���E�������E�B���h�E���쐬���܂� (0x' + IntToHex(WS_BORDER, 8) + ')';
  chkStyles1.Hint  := '�^�C�g���o�[�����E�B���h�E���쐬���܂��B(WS_BORDER | WS_DLGFRAME) (0x' + IntToHex(WS_CAPTION, 8) + ')';
  chkStyles2.Hint  := '�q�E�B���h�E���쐬���܂� (0x' + IntToHex(WS_CHILD, 8) + ')';
  chkStyles3.Hint  := ' (0x' + IntToHex(WS_CLIPCHILDREN, 8) + ')';
  chkStyles4.Hint  := ' (0x' + IntToHex(WS_CLIPSIBLINGS, 8) + ')';
  chkStyles5.Hint  := '���� (�g�p�s�\) �ȃE�B���h�E���쐬���܂� (0x' + IntToHex(WS_DISABLED, 8) + ')';
  chkStyles6.Hint  := '�_�C�A���O�{�b�N�X�ň�ʓI�Ɏg����X�^�C���̋��E�����E�B���h�E���쐬���܂� (0x' + IntToHex(WS_DLGFRAME, 8) + ')';
  chkStyles7.Hint  := ' (0x' + IntToHex(WS_GROUP, 8) + ')';
  chkStyles8.Hint  := '�����X�N���[���o�[�����E�B���h�E���쐬���܂� (0x' + IntToHex(WS_HSCROLL, 8) + ')';
  chkStyles9.Hint  := '�E�B���h�E���ő剻�̏�Ԃō쐬���܂� (0x' + IntToHex(WS_MAXIMIZE, 8) + ')';
  chkStyles10.Hint := '�ő剻�{�^�������E�B���h�E���쐬���܂��B WS_SYSMENU �X�^�C�����w�肷��K�v������܂� (0x' + IntToHex(WS_MAXIMIZEBOX, 8) + ')';
  chkStyles11.Hint := '�E�B���h�E���ŏ����̏�Ԃō쐬���܂� (0x' + IntToHex(WS_MINIMIZE, 8) + ')';
  chkStyles12.Hint := '�ŏ����{�^�������E�B���h�E���쐬���܂��B WS_SYSMENU �X�^�C�����w�肷��K�v������܂� (0x' + IntToHex(WS_MINIMIZEBOX, 8) + ')';
  chkStyles13.Hint := ' (0x' + IntToHex(WS_OVERLAPPED, 8) + ')';
  chkStyles14.Hint := ' (0x' + IntToHex(WS_OVERLAPPEDWINDOW, 8) + ')';
  chkStyles15.Hint := ' (0x' + IntToHex($80000000, 8) + ')';
  chkStyles16.Hint := ' (0x' + IntToHex($80000000 or WS_BORDER or WS_SYSMENU, 8) + ')';
  chkStyles17.Hint := '�^�C�g���o�[��ɃE�B���h�E���j���[�{�b�N�X�����E�B���h�E���쐬���܂��B (0x' + IntToHex(WS_SYSMENU, 8) + ')';
  chkStyles18.Hint := ' (0x' + IntToHex(WS_TABSTOP, 8) + ')';
  chkStyles19.Hint := '�T�C�Y�ύX���E�����E�B���h�E���쐬���܂� (0x' + IntToHex(WS_THICKFRAME, 8) + ')';
  chkStyles20.Hint := '����Ԃ̃E�B���h�E���쐬���܂� (0x' + IntToHex(WS_VSCROLL, 8) + ')';
  chkStyles21.Hint := '�����X�N���[���o�[�����E�B���h�E���쐬���܂� (0x' + IntToHex(WS_VSCROLL, 8) + ')';

  chkExStyles0.Hint  := '�E�B���h�E������オ�������̋��E�������� (0x' + IntToHex(WS_EX_WINDOWEDGE, 8) + ')';
  chkExStyles1.Hint  := '��������Ō����鋫�E�������E�B���h�E (0x' + IntToHex(WS_EX_CLIENTEDGE, 8) + ')';
  chkExStyles2.Hint  := '���[�U�[�̓��͂��󂯕t���Ȃ����ڗp�́A���̓I�Ɍ����鋫�E�X�^�C�������E�B���h�E (0x' + IntToHex(WS_EX_STATICEDGE, 8) + ')';
  chkExStyles3.Hint  := '��d�̋��E�������E�B���h�E���쐬���܂� (0x' + IntToHex(WS_EX_DLGMODALFRAME, 8) + ')';
  chkExStyles4.Hint  := 'WS_EX_WINDOWEDGE �� WS_EX_CLIENTEDGE  (0x' + IntToHex(WS_EX_OVERLAPPEDWINDOW, 8) + ')';
  chkExStyles5.Hint  := '���߃E�B���h�E���쐬���܂� (0x' + IntToHex(WS_EX_TRANSPARENT, 8) + ')';
  chkExStyles6.Hint  := '�_�C�A���O�{�b�N�X�ň�ʓI�Ɏg����X�^�C���̋��E�����E�B���h�E���쐬���܂� (0x' + IntToHex(WS_EX_TOOLWINDOW, 8) + ')';
  chkExStyles7.Hint  := '�E���獶�ւ̓ǂݎ�菇�������v���p�e�B���������E�B���h�E (0x' + IntToHex(WS_EX_RTLREADING, 8) + ')';
  chkExStyles8.Hint  := '�_�C�A���O�{�b�N�X�̃^�C�g���o�[�Ɂm?�n�{�^����ǉ����܂� (0x' + IntToHex(WS_EX_CONTEXTHELP, 8) + ')';
  chkExStyles9.Hint  := '�����X�N���[���o�[���N���C�A���g�̈�̍����ɒu����܂� (0x' + IntToHex(WS_EX_LEFTSCROLLBAR, 8) + ')';

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

{*------------------------------------------------------------------------------
  �X�^�C���ǂݍ���
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.LoadStyle;
begin

  // �C�x���g�𔭐������Ȃ��悤��nil
  chkStyles0.OnClick  := nil;
  chkStyles1.OnClick  := nil;
  chkStyles2.OnClick  := nil;
  chkStyles3.OnClick  := nil;
  chkStyles4.OnClick  := nil;
  chkStyles5.OnClick  := nil;
  chkStyles6.OnClick  := nil;
  chkStyles7.OnClick  := nil;
  chkStyles8.OnClick  := nil;
  chkStyles9.OnClick  := nil;
  chkStyles10.OnClick := nil;
  chkStyles11.OnClick := nil;
  chkStyles12.OnClick := nil;
  chkStyles13.OnClick := nil;
  chkStyles14.OnClick := nil;
  chkStyles15.OnClick := nil;
  chkStyles16.OnClick := nil;
  chkStyles17.OnClick := nil;
  chkStyles18.OnClick := nil;
  chkStyles19.OnClick := nil;
  chkStyles20.OnClick := nil;
  chkStyles21.OnClick := nil;

  frmMain.FWindowInfo.Load(frmMain.FWindowInfo.Handle);
  FStyle := frmMain.FWindowInfo.Style;
  edtStyle.Text := '0x' + IntToHex(FStyle, 8);

  chkStyles0.Checked  := ((FStyle and WS_BORDER) = WS_BORDER);
  chkStyles1.Checked  := ((FStyle and WS_CAPTION) = WS_CAPTION);
  chkStyles2.Checked  := ((FStyle and WS_CHILD) = WS_CHILD);
  chkStyles3.Checked  := ((FStyle and WS_CLIPCHILDREN) = WS_CLIPCHILDREN);
  chkStyles4.Checked  := ((FStyle and WS_CLIPSIBLINGS) = WS_CLIPSIBLINGS);
  chkStyles5.Checked  := ((FStyle and WS_DISABLED) = WS_DISABLED);
  chkStyles6.Checked  := ((FStyle and WS_DLGFRAME) = WS_DLGFRAME);
  chkStyles7.Checked  := ((FStyle and WS_GROUP) = WS_GROUP);
  chkStyles8.Checked  := ((FStyle and WS_HSCROLL) = WS_HSCROLL);
  chkStyles9.Checked  := ((FStyle and WS_MAXIMIZE) = WS_MAXIMIZE);
  chkStyles10.Checked := ((FStyle and WS_MAXIMIZEBOX) = WS_MAXIMIZEBOX);
  chkStyles11.Checked := ((FStyle and WS_MINIMIZE) = WS_MINIMIZE);
  chkStyles12.Checked := ((FStyle and WS_MINIMIZEBOX) = WS_MINIMIZEBOX);
  chkStyles13.Checked := ((FStyle and WS_OVERLAPPED) = WS_OVERLAPPED);
  chkStyles14.Checked := ((FStyle and WS_OVERLAPPEDWINDOW) = WS_OVERLAPPEDWINDOW);
  chkStyles15.Checked := ((FStyle and WS_POPUP) = WS_POPUP);
  chkStyles16.Checked := ((FStyle and WS_POPUPWINDOW) = WS_POPUPWINDOW);
  chkStyles17.Checked := ((FStyle and WS_SYSMENU) = WS_SYSMENU);
  chkStyles18.Checked := ((FStyle and WS_TABSTOP) = WS_TABSTOP);
  chkStyles19.Checked := ((FStyle and WS_THICKFRAME) = WS_THICKFRAME);
  chkStyles20.Checked := ((FStyle and WS_VISIBLE) = WS_VISIBLE);
  chkStyles21.Checked := ((FStyle and WS_VSCROLL) = WS_VSCROLL);

  chkStyles0.OnClick  := chkStylesClick;
  chkStyles1.OnClick  := chkStylesClick;
  chkStyles2.OnClick  := chkStylesClick;
  chkStyles3.OnClick  := chkStylesClick;
  chkStyles4.OnClick  := chkStylesClick;
  chkStyles5.OnClick  := chkStylesClick;
  chkStyles6.OnClick  := chkStylesClick;
  chkStyles7.OnClick  := chkStylesClick;
  chkStyles8.OnClick  := chkStylesClick;
  chkStyles9.OnClick  := chkStylesClick;
  chkStyles10.OnClick := chkStylesClick;
  chkStyles11.OnClick := chkStylesClick;
  chkStyles12.OnClick := chkStylesClick;
  chkStyles13.OnClick := chkStylesClick;
  chkStyles14.OnClick := chkStylesClick;
  chkStyles15.OnClick := chkStylesClick;
  chkStyles16.OnClick := chkStylesClick;
  chkStyles17.OnClick := chkStylesClick;
  chkStyles18.OnClick := chkStylesClick;
  chkStyles19.OnClick := chkStylesClick;
  chkStyles20.OnClick := chkStylesClick;
  chkStyles21.OnClick := chkStylesClick;

end;

{*------------------------------------------------------------------------------
  �g���X�^�C����ǂݍ���
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.LoadExStyle;
begin
  // �C�x���g�𔭐������Ȃ��悤��nil
  chkExStyles0.OnClick  := nil;
  chkExStyles1.OnClick  := nil;
  chkExStyles2.OnClick  := nil;
  chkExStyles3.OnClick  := nil;
  chkExStyles4.OnClick  := nil;
  chkExStyles5.OnClick  := nil;
  chkExStyles6.OnClick  := nil;
  chkExStyles7.OnClick  := nil;
  chkExStyles8.OnClick  := nil;
  chkExStyles9.OnClick  := nil;

  frmMain.FWindowInfo.Load(frmMain.FWindowInfo.Handle);
  FExStyle := frmMain.FWindowInfo.ExStyle;
  edtExStyle.Text := '0x' + IntToHex(FExStyle, 8);

  chkExStyles0.Checked  := ((FExStyle and WS_EX_WINDOWEDGE) = WS_EX_WINDOWEDGE);
  chkExStyles1.Checked  := ((FExStyle and WS_EX_CLIENTEDGE) = WS_EX_CLIENTEDGE);
  chkExStyles2.Checked  := ((FExStyle and WS_EX_STATICEDGE) = WS_EX_STATICEDGE);
  chkExStyles3.Checked  := ((FExStyle and WS_EX_DLGMODALFRAME) = WS_EX_DLGMODALFRAME);
  chkExStyles4.Checked  := ((FExStyle and WS_EX_OVERLAPPEDWINDOW) = WS_EX_OVERLAPPEDWINDOW);
  chkExStyles5.Checked  := ((FExStyle and WS_EX_TRANSPARENT) = WS_EX_TRANSPARENT);
  chkExStyles6.Checked  := ((FExStyle and WS_EX_TOOLWINDOW) = WS_EX_TOOLWINDOW);
  chkExStyles7.Checked  := ((FExStyle and WS_EX_RTLREADING) = WS_EX_RTLREADING);
  chkExStyles8.Checked  := ((FExStyle and WS_EX_CONTEXTHELP) = WS_EX_CONTEXTHELP);
  chkExStyles9.Checked  := ((FExStyle and WS_EX_LEFTSCROLLBAR) = WS_EX_LEFTSCROLLBAR);

  chkExStyles0.OnClick  := chkExStylesClick;
  chkExStyles1.OnClick  := chkExStylesClick;
  chkExStyles2.OnClick  := chkExStylesClick;
  chkExStyles3.OnClick  := chkExStylesClick;
  chkExStyles4.OnClick  := chkExStylesClick;
  chkExStyles5.OnClick  := chkExStylesClick;
  chkExStyles6.OnClick  := chkExStylesClick;
  chkExStyles7.OnClick  := chkExStylesClick;
  chkExStyles8.OnClick  := chkExStylesClick;
  chkExStyles9.OnClick  := chkExStylesClick;

end;

{*------------------------------------------------------------------------------
  �R���g���[�����̂��琔�l���擾(�R���g���[���z��p)
  @param obj   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
function GetIdOfControlName(objName : String): Integer;
var
  i : integer;
  s : String;
begin

  for i := 1 to Length(objName) do begin
    case Ord(objName[i]) of
      48..57: s := s + Copy(objName, i, 1);
    else ;
    end;
  end;

  Result := StrToIntDef(s, 0);

end;

{*------------------------------------------------------------------------------
  �X�^�C���̃`�F�b�N�{�b�N�X(�R���g���[���z��)
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.chkStylesClick(Sender: TObject);
var
  id : Integer;
begin

  // �e�X�^�C���̎��O��
  id := GetIdOfControlName(TWinControl(Sender).Name);
  case id of
    0:  FStyle := (FStyle xor WS_BORDER);
    1:  FStyle := (FStyle xor WS_CAPTION);
    2:  FStyle := (FStyle xor WS_CHILD);
    3:  FStyle := (FStyle xor WS_CLIPCHILDREN);
    4:  FStyle := (FStyle xor WS_CLIPSIBLINGS);
    5:  FStyle := (FStyle xor WS_DISABLED);
    6:  FStyle := (FStyle xor WS_DLGFRAME);
    7:  FStyle := (FStyle xor WS_GROUP);
    8:  FStyle := (FStyle xor WS_HSCROLL);
    9:  FStyle := (FStyle xor WS_MAXIMIZE);
    10: FStyle := (FStyle xor WS_MAXIMIZEBOX);
    11: FStyle := (FStyle xor WS_MINIMIZE);
    12: FStyle := (FStyle xor WS_MINIMIZEBOX);
    13: FStyle := (FStyle xor WS_OVERLAPPED);
    14: FStyle := (FStyle xor WS_OVERLAPPEDWINDOW);
    15: FStyle := (FStyle xor WS_POPUP);
    16: FStyle := (FStyle xor WS_POPUPWINDOW);
    17: FStyle := (FStyle xor WS_SYSMENU);
    18: FStyle := (FStyle xor WS_TABSTOP);
    19: FStyle := (FStyle xor WS_THICKFRAME);
    20: FStyle := (FStyle xor WS_VISIBLE);
    21: FStyle := (FStyle xor WS_VSCROLL);
  else ;
  end;

  edtStyle.Text := '0x' + IntToHex(FStyle, 8);

//  MessageBox(Self.Handle, PChar(IntToHex(FStyle, 8)), '������', MB_OK);

end;

{*------------------------------------------------------------------------------
  �X�^�C���K�p
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnApplyStyleClick(Sender: TObject);
begin
  SetWindowLong(frmMain.FWindowInfo.Handle, GWL_STYLE, FStyle);
end;

{*------------------------------------------------------------------------------
  �X�^�C���擾
  @param Sender   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnGetStyleClick(Sender: TObject);
begin
  LoadStyle();
end;

{*------------------------------------------------------------------------------
  �g���X�^�C�����O��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.chkExStylesClick(Sender: TObject);
var
  id : Integer;
begin

  // �e�X�^�C���̎��O��
  id := GetIdOfControlName(TWinControl(Sender).Name);
  case id of
    0:  FExStyle := (FExStyle xor WS_EX_WINDOWEDGE);
    1:  FExStyle := (FExStyle xor WS_EX_CLIENTEDGE);
    2:  FExStyle := (FExStyle xor WS_EX_STATICEDGE);
    3:  FExStyle := (FExStyle xor WS_EX_DLGMODALFRAME);
    4:  FExStyle := (FExStyle xor WS_EX_OVERLAPPEDWINDOW);
    5:  FExStyle := (FExStyle xor WS_EX_TRANSPARENT);
    6:  FExStyle := (FExStyle xor WS_EX_TOOLWINDOW);
    7:  FExStyle := (FExStyle xor WS_EX_RTLREADING);
    8:  FExStyle := (FExStyle xor WS_EX_CONTEXTHELP);
    9:  FExStyle := (FExStyle xor WS_EX_LEFTSCROLLBAR);
  else ;
  end;

  edtExStyle.Text := '0x' + IntToHex(FExStyle, 8);

end;

{*------------------------------------------------------------------------------
  �g���X�^�C���K�p
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnApplyExStyleClick(Sender: TObject);
begin
  SetWindowLong(frmMain.FWindowInfo.Handle, GWL_EXSTYLE, FExStyle);
end;

{*------------------------------------------------------------------------------
  �g���X�^�C���ǂݍ���
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnGetExStyleClick(Sender: TObject);
begin
  LoadExStyle();
end;

end.
