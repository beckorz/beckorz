{*------------------------------------------------------------------------------
  ���C���t�H�[��

  �O���ˑ��R���|�[�l���g : TNT Unicode Controls, Toolbar 2000, TBX, SpTBXLib, TBX Themes

  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ImgList, MSHTML, Graphics,
  {* WebBrowser *}
  Shdocvw_tlb,
//  WebBrowser,

  // MyCommon
  Window, CommonUtil, WindowPlacement, AppWinFix, OleAcc, Finder, Glass,
  WindowController, Controls
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
  , TBXZezioTheme
  , TBXDamsokaTheme
  , TBXEchoTheme
  , TBXEos9Theme
  , TBXNewOfficeAdaptiveTheme
  , TBXNewOfficeTheme
  , TBXOffice11XPTheme

  , SpTBXEditors, TntExtCtrls
  ;

type
  TfrmMain = class(TCustomMainForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    SpTBXSeparatorItem11: TSpTBXSeparatorItem;
    mnuViewFindType: TSpTBXSubmenuItem;
    mnuViewFindTypeStandard: TSpTBXItem;
    mnuViewFindTypeDetail: TSpTBXItem;
    pnlFinder: TTntPanel;
    chkGlassForm: TSpTBXCheckBox;
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
    procedure mnuViewFindTypeSelect(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuToolFreeMouseModeClick(Sender: TObject);
  private
    { Private �錾 }

    NowWnd:HWnd;              /// ���A�J�[�\�������ɂ�����̂̃n���h��
    FIniPath: String;         /// Ini�t�@�C���p�X
    FFinder: TFinder;         /// Finder�I�u�W�F�N�g
    procedure ReadWindowInformation(hWnd: HWND);
    procedure SetThemeType(iWinControl: TWinControl; iThemeType: TSpTBXThemeType; iRecursive: Boolean = True);

  public
    { Public �錾 }

    FWindowInfo: TWindowInfo; /// �E�B���h�E���

  end;

  const
    CLASS_NAME_IE : String = 'Internet Explorer_Server';  /// Browser IE Trident �N���X��

var
  frmMain: TfrmMain;
  HookHandle: HHOOK = 0;

const
  FORM_ALPHA = 255;
  MENU_ALPHA = 180;

implementation

{$R *.dfm}

//-----------------------------------------------------------------------------
//  �t�b�N��
function HookCallWndProc(nCode: Integer; wParam: WPARAM; pEvnt: PEventMsg): LRESULT; stdcall;
var
  cwps: TCWPStruct;
  szClass: array[0..127] of Char;
begin
  //  �K���ǂ���
  if (nCode = HC_ACTION) then begin
    //  �g���ɂ����̂ŃL���X�g����
    cwps := PCWPStruct(pEvnt)^;
    //  �쐬�̃^�C�~���O��
    if (cwps.message = WM_CREATE) then begin
      //  �쐬�����E�B���h�E�̃N���X�����擾����
      FillChar(szClass, SizeOf(szClass), 0);
      GetClassName(cwps.hwnd, szClass, 127);
      //  �R�����_�C�A���O(���j���[���_�C�A���O�Ɠ����N���X��)�Ȃ�
      if (szClass = '#32768') or (szClass = 'TSpTBXPopupWindow') then begin
        //  ���̃X�^�C���ɓ����ʂ�X�^�C����t��������
        SetWindowLongW(cwps.hwnd, GWL_EXSTYLE,
                      GetWindowLongW(cwps.hwnd, GWL_EXSTYLE) or WS_EX_LAYERED);
        //  �����x��ݒ肷��
        SetLayeredWindowAttributes(cwps.hwnd, 0, MENU_ALPHA, LWA_ALPHA);
      end;
    end;
  end;
  //  �����Ƃ���Ă����l�ɔC����
  Result := CallNextHookEx(WH_CALLWNDPROC, nCode, wParam, Longint(pEvnt));
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

  // Finder�N���X�쐬
  FFinder := TFinder.Create(pnlFinder, imlFinder);

  FWindowInfo := TWindowInfo.Create;

//  HookHandle := SetWindowsHookEx(WH_CALLWNDPROC, @HookCallWndProc, 0, GetWindowThreadProcessId(Handle));

  //������
//  Init;

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
  mnuViewFindTypeStandard.Checked := True;
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

  FFinder.Free; // Finder�I�u�W�F�N�g�j��

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
  if not FFinder.Finding then Exit;

  FFinder.DrawFrameRect(NowWnd);  // �g�����㏑������

  FFinder.Finding := False;
  
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
  hWindowUnderTheMouse: HWND;
  DumpSeek: TDumpSeek;        // �q�E�B���h�E�����N���X
  hChildFound : HWND;
begin

  if not FFinder.Finding then Exit; //�T���i�}�E�X�L���v�`���j���łȂ���ΏI�킵
  
  GetCursorPos(PT);         //�}�E�X�J�[�\���̈ʒu���擾

  // �ʒu
  edtMousePos.Text := '(' + IntToStr(PT.X) + ',' + IntToStr(PT.Y) + ')';

  Wnd := WindowFromPoint(PT); //�J�[�\���ʒu����n���h�����擾
  hWindowUnderTheMouse := Wnd;

  // �F
  tmpHdc := GetDC(Wnd);
  color := GetPixel(tmpHdc, PT.X, PT.Y);
  edtColor.Text := '#' + IntToHex(Color, 6);
  edtColor.Color := tcolor(Color);

  // �ʏ팟��
  if mnuViewFindTypeStandard.Checked then begin
    if (hWindowUnderTheMouse <> 0) then begin
      Wnd := hWindowUnderTheMouse;

      if Wnd <> 0 then begin
        Windows.ScreenToClient(Wnd, PT);
        tmpWnd := RealChildWindowFromPoint(Wnd, PT);
        if tmpWnd <> 0 then begin
          Wnd := tmpWnd;
        end;
      end;
    end;
  end;

  // �ڍ׌���
  if mnuViewFindTypeDetail.Checked then begin
    DumpSeek := TDumpSeek.Create;
    try
      hChildFound := DumpSeek.SeekDumpWindow(hWindowUnderTheMouse, PT);
      if (IsWindow(hChildFound) and (hChildFound <> 0)) then begin
        hWindowUnderTheMouse := hChildFound;
        Wnd := hWindowUnderTheMouse;
      end;
    finally
      DumpSeek.Free;
    end;
  end;


  if Wnd = NowWnd then Exit;  // �O�Ɠ����Ȃ�I�킵

  FFinder.DrawFrameRect(NowWnd);  // �O�ɏ������g�����㏑���ŏ���

  NowWnd := Wnd;  // �V���ɐݒ�

  FFinder.DrawFrameRect(NowWnd);  // �^�[�Q�b�g��g���ň͂�

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

  NowWnd := 0;  //������
  FFinder.Finding := True;  /// �T���J�n

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
var
  IE: IWebBrowser2;
  doc : Variant;
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

    edtStyle.Text := IntToStr(GetWindowLongW(hWnd, GWL_STYLE));
    edtStyleHex.Text := '0x' + IntToHex(GetWindowLongW(hWnd, GWL_STYLE), 8);
    edtExStyle.Text := IntToStr(GetWindowLongW(hWnd, GWL_EXSTYLE));
    edtExStyleHex.Text := '0x' + IntToHex(GetWindowLongW(hWnd, GWL_EXSTYLE), 8);

    edtWinPos.Text := '(' + IntToStr(rect.Left) + ',' + IntToStr(rect.Top) + ')-('
                      + IntToStr(rect.Right) + ',' + IntToStr(rect.Bottom) + ') '
                      + IntToStr(rect.Right - rect.Left) + 'x' + IntToStr(rect.Bottom - rect.Top)  + ' ';
    edtWinPos.Text := edtWinPos.Text + '-> (' + IntToStr(ClientRect.Left) + ',' + IntToStr(ClientRect.Top) + ')-('
                      + IntToStr(ClientRect.Right) + ',' + IntToStr(ClientRect.Bottom) + ') '
                      + IntToStr(ClientRect.Right - ClientRect.Left) + 'x' + IntToStr(ClientRect.Bottom - ClientRect.Top)  + '';

    if ClassName = CLASS_NAME_IE then begin
      // IE

      //Get Iwebbrowser2 from Handle
      GetIEFromHWnd(Handle, IE);
      doc := IE.Document as IHtmlDocument2;
      edtCaption.Text := doc.documentElement.innerHTML;
//      edtCaption.Text := IE.LocationName + ' - ' + IE.LocationURL;              // Title��URL
//      edtCaption.Text := IE.Path + ' - ' + IE.Name + ' - '; // + IE.StatusText; // ���s�p�X + IE�̃I�u�W�F�N�g����
//      edtCaption.Text := doc.;

    end;

    // �E�B���h�E�R���g���[���[�C���X�^���X����������E�B���h�E�ʒu�ǂݍ���
    if Assigned(frmWindowController) then begin
      frmWindowController.LoadWindowPosition();
      frmWindowController.LoadStyle();
      frmWindowController.LoadExStyle();
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

  mnuViewThemeTypeNon.Checked := (Sender = mnuViewThemeTypeNon);
  mnuViewThemeTypeWindows.Checked := (Sender = mnuViewThemeTypeWindows);
  mnuViewThemeTypeTBX.Checked := (Sender = mnuViewThemeTypeTBX);
  if Sender = mnuViewThemeTypeNon then begin
    SpChangeThemeType(Self, thtNone);
    if Assigned(frmWindowController) then
      SpChangeThemeType(frmWindowController, thtNone);
  end else if Sender = mnuViewThemeTypeWindows then begin
    SpChangeThemeType(Self, thtWindows);
    if Assigned(frmWindowController) then
      SpChangeThemeType(frmWindowController, thtWindows);
  end else if Sender = mnuViewThemeTypeTBX then begin
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
    frmWindowController.LoadStyle();          // �X�^�C���ǂݍ���
    frmWindowController.LoadExStyle();        // �g���X�^�C��
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

{*------------------------------------------------------------------------------
  �����^�C�v
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuViewFindTypeSelect(Sender: TObject);
begin

  mnuViewFindTypeStandard.Checked := (Sender = mnuViewFindTypeStandard);
  mnuViewFindTypeDetail.Checked := (Sender = mnuViewFindTypeDetail);

end;

{*------------------------------------------------------------------------------
  �A�N�e�B�u��
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormActivate(Sender: TObject);
begin
  GlassForm(frmMain, clBtnFace);
end;

{*------------------------------------------------------------------------------
  �t�H�[����j����
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if (HookHandle <> 0) then UnhookWindowsHookEx(HookHandle);
  HookHandle := 0;
end;

{*------------------------------------------------------------------------------
  �t���[�}�E�X���[�h
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuToolFreeMouseModeClick(Sender: TObject);
begin

  NowWnd := 0;  /// ������
  FFinder.Finding := True;  /// �T���J�n

end;

end.
