{*------------------------------------------------------------------------------
  ���C���t�H�[��
  �O���ˑ��R���|�[�l���g : TNT Unicode Controls, Toolbar 2000, TBX, SpTBXLib, TBX Themes
  @Author    beck
  @Version   2009.02.13   beck  Initial revision
-------------------------------------------------------------------------------}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImgList, AppWinFix,
  // MyCommon
  Window, CommonUtil, WindowPlacement
  // TNT
  , TntStdCtrls
  // Toolbar 2000
  , TB2Item, TB2Toolbar, TB2Dock, TB2ExtItems
  // TBX
  , TBX, TBXDkPanels
  // SpTBXLib
  , SpTBXItem, SpTBXDkPanels, SpTBXControls, SpTBXCustomizer
  // Themes
  , TBXAluminumTheme
  , TBXAthenTheme
  , TBXDreamTheme
  , TBXEosTheme
  , TBXMirandaTheme
  , TBXMonaiTheme
  , TBXMonaiXPTheme
  , TBXNexos2Theme
  , TBXNexos3Theme
  , TBXNexos4Theme
  , TBXNexos5Theme
  , TBXNexosXTheme
  , TBXOffice11AdaptiveTheme
  , TBXOffice2003Theme
  , TBXOffice2007Theme
  , TBXOfficeCTheme
  , TBXOfficeKTheme
  , TBXOfficeXPTheme
  , TBXReliferTheme
  , TBXRomaTheme
  , TBXSentimoXTheme
  , TBXStripesTheme
  , TBXTristan2Theme
  , TBXTristanTheme
  , TBXWhidbeyTheme
  , TBXXitoTheme
  , TBXZezioTheme, SpTBXEditors
  , WindowController
  ;

type
  TfrmMain = class(TCustomMainForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pnlFinder: TPanel;
    imlFinder: TImageList;
    dockMain: TSpTBXDock;
    SpTBXGroupBox1: TSpTBXGroupBox;
    chkVisible: TSpTBXCheckBox;
    chkEnabled: TSpTBXCheckBox;
    chkTopMost: TSpTBXCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    btnReload: TSpTBXButton;
    btnAppy: TSpTBXButton;
    SpTBXGroupBox2: TSpTBXGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    tbrMain: TSpTBXToolbar;
    mnuView: TSpTBXSubmenuItem;
    mnuViewTopMost: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXSubmenuItem1: TSpTBXSubmenuItem;
    SpTBXThemeGroupItem1: TSpTBXThemeGroupItem;
    mnuViewOption: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    mnuFile: TSpTBXSubmenuItem;
    mnuFileClose: TSpTBXItem;
    mnuTool: TSpTBXSubmenuItem;
    mnuHelp: TSpTBXSubmenuItem;
    SpTBXItem1: TSpTBXItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    mnuViewThemeTypeNon: TSpTBXItem;
    mnuViewThemeTypeWindows: TSpTBXItem;
    mnuViewThemeTypeTBX: TSpTBXItem;
    Customizer: TSpTBXCustomizer;
    Label8: TLabel;
    Label9: TLabel;
    tbrTool: TSpTBXToolbar;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    tbrSetTextBoxReadOnly: TSpTBXItem;
    tbrRemoveTextBoxReadOnly: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    tbrSetPasswordMask: TSpTBXItem;
    tbrRemovePasswordMask: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    SpTBXItem6: TSpTBXItem;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    SpTBXItem7: TSpTBXItem;
    SpTBXItem8: TSpTBXItem;
    SpTBXItem9: TSpTBXItem;
    SpTBXSeparatorItem8: TSpTBXSeparatorItem;
    SpTBXGroupBox3: TSpTBXGroupBox;
    rdoZoom: TSpTBXRadioButton;
    rdoIconic: TSpTBXRadioButton;
    rdoNormal: TSpTBXRadioButton;
    SpTBXItem10: TSpTBXItem;
    mnuToolFreeMouse: TSpTBXItem;
    SpTBXSeparatorItem9: TSpTBXSeparatorItem;
    mnuToolWindowViewer: TSpTBXItem;
    SpTBXSeparatorItem10: TSpTBXSeparatorItem;
    mnuToolWindowOperate: TSpTBXItem;
    Label10: TLabel;
    Label11: TLabel;
    edtHandle: TSpTBXEdit;
    edtStyle: TSpTBXEdit;
    edtExStyle: TSpTBXEdit;
    edtStyleHex: TSpTBXEdit;
    edtExStyleHex: TSpTBXEdit;
    edtMousePos: TSpTBXEdit;
    edtWinPos: TSpTBXEdit;
    edtColor: TSpTBXEdit;
    edtHandleHex: TSpTBXEdit;
    edtClassName: TSpTBXEdit;
    edtCaption: TSpTBXEdit;
    imlTool: TImageList;
    Image1: TImage;
    chkUnicode: TSpTBXCheckBox;
    procedure mnuToolWindowOperateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlFinderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnAppyClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure mnuViewTopMostClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure mnuViewThemeTypeSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbrSetTextBoxReadOnlyClick(Sender: TObject);
    procedure tbrRemoveTextBoxReadOnlyClick(Sender: TObject);
    procedure tbrSetPasswordMaskClick(Sender: TObject);
    procedure tbrRemovePasswordMaskClick(Sender: TObject);
  private
    { Private �錾 }

    OriginProc: TWndMethod;   //���̃E�B���h�E�֐��ێ��p
    Finding:Boolean;          // �T����
    NowWnd:HWnd;              // ���A�J�[�\�������ɂ�����̂̃n���h��
    FIniPath: String;         // Ini�t�@�C���p�X
    FFinderCanvas: TCanvas;
    procedure Init;
    procedure SubClassProc(var msg: TMessage);
    procedure PaintFinder;    // �F�Ƃ��傫���Ƃ��̏������葱��
    procedure ReadWindowInformation(hWnd: HWND);
    procedure SetThemeType(iWinControl: TWinControl; iThemeType: TSpTBXThemeType; iRecursive: Boolean = True);

  public
    { Public �錾 }

    FWindowInfo: TWindowInfo;

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}


{*------------------------------------------------------------------------------
  �g���`��
  @param Wnd   �E�B���h�E�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure DrawFrameRect(Wnd: HWnd);
var
  DC:HDC;
  RC:TRect;
const
  W=3;

  procedure Line(iDC, iX, iY, iW, iH: Integer);
  begin
    PatBlt(iDC, iX, iY, iW, iH, DSTINVERT);
  end;

begin

  if not IsWindow(Wnd) then exit;

  DC := CreateDC('DISPLAY', nil, nil, nil);
  GetWindowRect(Wnd, RC);
//  OffsetRect(RC, -RC.Left, -RC.Top);

  if not IsRectEmpty(RC) then begin
    with RC do begin
      Line(DC, Left, Top, Right-Left, W);
      Line(DC, Left, Bottom-W, W, -(Bottom-Top-2*W));
      Line(DC, Right-W, Top+W, W, Bottom-Top-2*W);
      Line(DC, Right, Bottom-W, -(Right-Left), W);
    end;
  end;
  ReleaseDC(Wnd, DC);

end;

{*------------------------------------------------------------------------------
  �t�H�[���쐬��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormCreate(Sender: TObject);
var
  appPath : String;
begin
  appPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  FIniPath := appPath + ChangeFileExt(ExtractFileName(Application.ExeName), '') + '.ini';

  Screen.Cursors[1] := LoadCursor(HInstance, 'FINDING'); //�J�[�\����ύX
  OriginProc :=pnlFinder.WindowProc;
  pnlFinder.WindowProc :=SubClassProc;

  FFinderCanvas := TCanvas.Create;
  FFinderCanvas.Handle := GetDC(pnlFinder.Handle);

  FWindowInfo := TWindowInfo.Create;

//������
  Init;

end;

{*------------------------------------------------------------------------------
  �t�H�[���\��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormShow(Sender: TObject);
var
  wp : TWindowPlacementer;
  fileName: String;
  ModuleName: array[0..MAX_PATH] of Char;
  buff : Array[0..MAXBYTE] of Char;
begin

  // �O��̃E�B���h�E�ʒu�����\��
  wp := TWindowPlacementer.Create;
  try
    wp.Load();
    wp.SetToWindow(Self.Handle);
  finally
    wp.Free;
  end;

  // ini�t�@�C�����擾
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  fileName := ExtractFilePath(String(ModuleName)) + ChangeFileExt(ExtractFileName(String(ModuleName)), '') + '.ini';

  // �e�[�}�ݒ�
  GetPrivateProfileString(PChar('System'), PChar('Theme'), PChar('Office2003'), @buff, MAXBYTE, PChar(fileName));
  TBXSetTheme(Copy(buff, 0, StrLen(@buff)));

  mnuViewThemeTypeWindows.Checked := True;
  SpChangeThemeType(Self, thtWindows);

  SetWindowToCenterOfWorkArea(Self.Handle);

end;

{*------------------------------------------------------------------------------
  �t�H�[������
  @param Sender   ParameterDescription
  @param Action   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  wp : TWindowPlacementer;
  fileName: String;
  ModuleName: array[0..MAX_PATH] of Char;
begin

  // �I�u�W�F�N�g�j��
  ReleaseDC(pnlFinder.Handle, FFinderCanvas.Handle);
  FFinderCanvas.Free;

  // ����N�����p�ɃE�B���h�E�ʒu���ۑ�
  wp := TWindowPlacementer.Create;
  try
    wp.Save(Self.Handle);
  finally
    wp.Free;
  end;

  // ini�t�@�C�����擾
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  fileName := ExtractFilePath(String(ModuleName)) + ChangeFileExt(ExtractFileName(String(ModuleName)), '') + '.ini';

  // �e�[�}���ۑ�
  WritePrivateProfileString(PChar('System'), PChar('Theme'), PChar(TBXCurrentTheme), PChar(fileName));

  FWindowInfo.Free;

end;

{*------------------------------------------------------------------------------
  ������
------------------------------------------------------------------------------*}
procedure TfrmMain.Init;
begin
  //�T���I�킵
  Finding := False;
  Screen.Cursor := crDefault;
  imlFinder.Draw(FFinderCanvas, 2, 2, 1, True);

end;

{*------------------------------------------------------------------------------
  �}�E�X�A�b�v
  @param Sender   ParameterDescription
  @param Button   ParameterDescription
  @param Shift   ParameterDescription
  @param X   ParameterDescription
  @param Y   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  if not Finding then exit;

  DrawFrameRect(NowWnd);  // �g�����㏑������
  ReleaseCapture;         // �}�E�X�L���v�`������

  Init; // ���ɖ߂�

end;

{*------------------------------------------------------------------------------
  �}�E�X�ړ�
  @param Sender   ParameterDescription
  @param Shift   ParameterDescription
  @param X   ParameterDescription
  @param Y   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Wnd:HWnd;//�^�[�Q�b�g�̃n���h��
  PT:TPoint;//�J�[�\���ʒu
  tmpWnd: HWnd;
  tmpHdc: HDC;
  color : TColorRef;
begin

  if not Finding then exit; //�T���i�}�E�X�L���v�`���j���łȂ���ΏI�킵

  GetCursorPos(PT);         //�}�E�X�J�[�\���̈ʒu���擾

  // �ʒu
  edtMousePos.Text := '(' + IntToStr(PT.X) + ',' + IntToStr(PT.Y) + ')';

  Wnd:=WindowFromPoint(PT); //�J�[�\���ʒu����n���h�����擾

  // �F
  tmpHdc := GetDC(Wnd);
  color := GetPixel(tmpHdc, PT.X, PT.Y);
  edtColor.Text := '#' + IntToHex(Color, 6);

  if Wnd <> 0 then begin
    Windows.ScreenToClient(Wnd, PT);
    tmpWnd := ChildWindowFromPoint(Wnd, PT);
    if tmpWnd <> 0 then begin
      Wnd := tmpWnd;
    end;
  end;

  if Wnd = NowWnd then exit;  //�O�Ɠ����Ȃ�I�킵

  DrawFrameRect(NowWnd);  //�O�ɏ������g�����㏑���ŏ���

  NowWnd := Wnd;  //�V���ɐݒ�

  DrawFrameRect(NowWnd);  //�^�[�Q�b�g��g���ň͂�

  ReadWindowInformation(NowWnd);  // �E�B���h�E���擾
  ReleaseDC(Wnd, tmpHdc);

end;

{*------------------------------------------------------------------------------
  �K�p�{�^��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.btnAppyClick(Sender: TObject);
begin

  // �ۑ�
  if IsWindow(FWindowInfo.Handle) then begin

    FWindowInfo.Text := edtCaption.Text;
    FWindowInfo.IsTopMost := chkTopMost.Checked;
    FWindowInfo.IsEnabled := chkEnabled.Checked;
    FWindowInfo.IsVisible := chkVisible.Checked;

    FWindowInfo.Save;
  end;

end;

{*------------------------------------------------------------------------------
  Finder�J�n
  @param Sender   ParameterDescription
  @param Button   ParameterDescription
  @param Shift   ParameterDescription
  @param X   ParameterDescription
  @param Y   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.pnlFinderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Finding:=True;  //�T���J�n

  Screen.Cursor:=1; //�J�[�\����ύX

  imlFinder.Draw(FFinderCanvas, 2, 2, 0, True);

  NowWnd := 0;  //������

  SetCapture(Handle); // �����̃t�H�[���E�B���h�E�ɃL���v�`���[�����C�x���g�������Ă���

end;

{*------------------------------------------------------------------------------
  Finder�`��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.PaintFinder();
begin
  if Finding then begin
    imlFinder.Draw(FFinderCanvas, 2, 2, 0, True);
  end else begin
    imlFinder.Draw(FFinderCanvas, 2, 2, 1, True);
  end;

end;

{*------------------------------------------------------------------------------
  �T�u�N���X�v���V�[�W��
  @param msg   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.SubClassProc(var msg: TMessage);
begin

  OriginProc(msg);  // �{���̃E�B���h�E�֐������s

  //�E�B���h�E���b�Z�[�W�ɂ���ď�����U�蕪��
  case msg.Msg of
  WM_PAINT: PaintFinder();
  end;
end;

{*------------------------------------------------------------------------------
  �őO�ʕ\��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuViewTopMostClick(Sender: TObject);
begin
  SetWindowTopMost(Self.Handle, mnuViewTopMost.Checked);  // �őO�ʐݒ�؂�ւ�
  mnuViewTopMost.Checked := not mnuViewTopMost.Checked;   // �`�F�b�N�{�b�N�X
end;

{*------------------------------------------------------------------------------
  ����
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuFileCloseClick(Sender: TObject);
begin
  Self.Close;
end;

{*------------------------------------------------------------------------------
  �E�B���h�E���ǂݍ���
  @param hWnd   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.ReadWindowInformation(hWnd: HWND);
begin

  if not IsWindow(hWnd) then Exit; 

  // �n���h��
  FWindowInfo.Load(hWnd);

  with FWindowInfo do begin
    edtHandle.Text := IntToStr(Handle);
    edtHandleHex.Text := '0x' + IntToHex(Handle, 8);
    edtClassName.Text := ClassName;
    edtCaption.Text := Text;

    chkVisible.Checked := IsVisible;
    chkEnabled.Checked := IsEnabled;
    chkTopMost.Checked := IsTopMost;
    chkUnicode.Checked := IsUnicode;

    rdoZoom.Checked := IsZoomed;
    rdoIconic.Checked := IsIconic;
    rdoNormal.Checked := IsNormal;

    edtStyle.Text := IntToStr(GetWindowLong(hWnd, GWL_STYLE));
    edtStyleHex.Text := '0x' + IntToHex(GetWindowLong(hWnd, GWL_STYLE), 8);
    edtExStyle.Text := IntToStr(GetWindowLong(hWnd, GWL_EXSTYLE));
    edtExStyleHex.Text := '0x' + IntToHex(GetWindowLong(hWnd, GWL_EXSTYLE), 8);

    edtWinPos.Text := '(' + IntToStr(rect.Left) + ',' + IntToStr(rect.Top) + ')-('
                      + IntToStr(rect.Right) + ',' + IntToStr(rect.Bottom) + ') '
                      + IntToStr(rect.Right - rect.Left) + 'x' + IntToStr(rect.Bottom - rect.Top)  + ' ';
    edtWinPos.Text := edtWinPos.Text + '-> (' + IntToStr(ClientRect.Left) + ',' + IntToStr(ClientRect.Top) + ')-('
                      + IntToStr(ClientRect.Right) + ',' + IntToStr(ClientRect.Bottom) + ') '
                      + IntToStr(ClientRect.Right - ClientRect.Left) + 'x' + IntToStr(ClientRect.Bottom - ClientRect.Top)  + '';

    // �E�B���h�E�R���g���[���[�C���X�^���X����������E�B���h�E�ʒu�ǂݍ���
    if Assigned(frmWindowController) then begin
      frmWindowController.LoadWindowPosition();
    end;

  end;

end;

{*------------------------------------------------------------------------------
  �ŐV�\��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.btnReloadClick(Sender: TObject);
begin
  if IsNumeric(edtHandle.Text) then begin
    ReadWindowInformation(StrToInt(edtHandle.Text));
  end;
end;

{*------------------------------------------------------------------------------
  �e�[�}�^�C�v�I��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuViewThemeTypeSelect(Sender: TObject);
begin

  mnuViewThemeTypeNon.Checked := False;
  mnuViewThemeTypeWindows.Checked := False;
  mnuViewThemeTypeTBX.Checked := False;
  if Sender = mnuViewThemeTypeNon then begin
    mnuViewThemeTypeNon.Checked := True;
    SpChangeThemeType(Self, thtNone);
    if Assigned(frmWindowController) then
      SpChangeThemeType(frmWindowController, thtNone);
  end else if Sender = mnuViewThemeTypeWindows then begin
    mnuViewThemeTypeWindows.Checked := True;
    SpChangeThemeType(Self, thtWindows);
    if Assigned(frmWindowController) then
      SpChangeThemeType(frmWindowController, thtWindows);
  end else if Sender = mnuViewThemeTypeTBX then begin
    mnuViewThemeTypeTBX.Checked := True;
    SpChangeThemeType(Self, thtTBX);
    if Assigned(frmWindowController) then
      SpChangeThemeType(frmWindowController, thtTBX);
  end;

end;

{* ���ǂݎ�葮�� *}

{*------------------------------------------------------------------------------
  �ݒ�
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrSetTextBoxReadOnlyClick(Sender: TObject);
begin
  if IsNumeric(edtHandle.Text) then
    SendMessage(StrToInt(edtHandle.Text), EM_SETREADONLY, 1, 0);
end;
{*------------------------------------------------------------------------------
  ����
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrRemoveTextBoxReadOnlyClick(Sender: TObject);
begin
  if IsNumeric(edtHandle.Text) then
    SendMessage(StrToInt(edtHandle.Text), EM_SETREADONLY, 0, 0);
end;

{* ���p�X���[�h�}�X�N *}

{*------------------------------------------------------------------------------
  �ݒ�
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrSetPasswordMaskClick(Sender: TObject);
var
  Wnd: HWND;
begin
  if IsNumeric(edtHandle.Text) then begin
    Wnd := StrToInt(edtHandle.Text);
    PostMessage(Wnd, EM_SETPASSWORDCHAR, 0 + Ord('*') , 0);
    InvalidateRect(Wnd, nil, True);
  end;
end;
{*------------------------------------------------------------------------------
  ����
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrRemovePasswordMaskClick(Sender: TObject);
var
  Wnd: HWND;
begin
  if IsNumeric(edtHandle.Text) then begin
    Wnd := StrToInt(edtHandle.Text);
    PostMessage(Wnd, EM_SETPASSWORDCHAR, 0, 0);
    InvalidateRect(Wnd, nil, True);
  end;
end;

{*------------------------------------------------------------------------------
  �E�B���h�E��������E�B���h�E�\���E��\��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuToolWindowOperateClick(Sender: TObject);
begin

  mnuToolWindowOperate.Checked := not mnuToolWindowOperate.Checked;
  if not Assigned(frmWindowController) then begin
    // �������̏ꍇ�͐�������B
    frmWindowController := TfrmWindowController.Create(Self, GetDesktopWindow());
    SpChangeThemeType(frmWindowController, thtWindows);
    frmWindowController.LoadWindowPosition(); // �E�B���h�E�ʒu�ǂݍ���
    frmWindowController.Show;
  end else begin
    // �����ς݂̏ꍇ�͔j������B
    mnuToolWindowOperate.Checked := not Assigned(frmWindowController);
    frmWindowController.Free;
    frmWindowController := nil;
  end;

end;

{*------------------------------------------------------------------------------
  �e�[�}�^�C�v�I��
  @param iWinControl   ParameterDescription
  @param iThemeType   ParameterDescription
  @param iRecursive   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.SetThemeType(iWinControl: TWinControl; iThemeType: TSpTBXThemeType; iRecursive: Boolean = True);
begin
//
  SpChangeThemeType(iWinControl, iThemeType, iRecursive);

  if Assigned(frmWindowController) then
    SpChangeThemeType(frmWindowController, iThemeType, iRecursive);

end;

end.
