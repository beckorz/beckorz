{*------------------------------------------------------------------------------
  メインフォーム
  外部依存コンポーネント : TNT Unicode Controls, Toolbar 2000, TBX, SpTBXLib, TBX Themes
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
    { Private 宣言 }

    OriginProc: TWndMethod;   //元のウィンドウ関数保持用
    Finding:Boolean;          // 探索中
    NowWnd:HWnd;              // 今、カーソル足下にあるもののハンドル
    FIniPath: String;         // Iniファイルパス
    FFinderCanvas: TCanvas;
    procedure Init;
    procedure SubClassProc(var msg: TMessage);
    procedure PaintFinder;    // 色とか大きさとかの初期化手続き
    procedure ReadWindowInformation(hWnd: HWND);
    procedure SetThemeType(iWinControl: TWinControl; iThemeType: TSpTBXThemeType; iRecursive: Boolean = True);

  public
    { Public 宣言 }

    FWindowInfo: TWindowInfo;

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}


{*------------------------------------------------------------------------------
  枠線描画
  @param Wnd   ウィンドウハンドル
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
  フォーム作成時
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormCreate(Sender: TObject);
var
  appPath : String;
begin
  appPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  FIniPath := appPath + ChangeFileExt(ExtractFileName(Application.ExeName), '') + '.ini';

  Screen.Cursors[1] := LoadCursor(HInstance, 'FINDING'); //カーソルを変更
  OriginProc :=pnlFinder.WindowProc;
  pnlFinder.WindowProc :=SubClassProc;

  FFinderCanvas := TCanvas.Create;
  FFinderCanvas.Handle := GetDC(pnlFinder.Handle);

  FWindowInfo := TWindowInfo.Create;

//初期化
  Init;

end;

{*------------------------------------------------------------------------------
  フォーム表示
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

  // 前回のウィンドウ位置復元表示
  wp := TWindowPlacementer.Create;
  try
    wp.Load();
    wp.SetToWindow(Self.Handle);
  finally
    wp.Free;
  end;

  // iniファイル名取得
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  fileName := ExtractFilePath(String(ModuleName)) + ChangeFileExt(ExtractFileName(String(ModuleName)), '') + '.ini';

  // テーマ設定
  GetPrivateProfileString(PChar('System'), PChar('Theme'), PChar('Office2003'), @buff, MAXBYTE, PChar(fileName));
  TBXSetTheme(Copy(buff, 0, StrLen(@buff)));

  mnuViewThemeTypeWindows.Checked := True;
  SpChangeThemeType(Self, thtWindows);

  SetWindowToCenterOfWorkArea(Self.Handle);

end;

{*------------------------------------------------------------------------------
  フォーム閉じる
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

  // オブジェクト破棄
  ReleaseDC(pnlFinder.Handle, FFinderCanvas.Handle);
  FFinderCanvas.Free;

  // 次回起動時用にウィンドウ位置情報保存
  wp := TWindowPlacementer.Create;
  try
    wp.Save(Self.Handle);
  finally
    wp.Free;
  end;

  // iniファイル名取得
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  fileName := ExtractFilePath(String(ModuleName)) + ChangeFileExt(ExtractFileName(String(ModuleName)), '') + '.ini';

  // テーマ名保存
  WritePrivateProfileString(PChar('System'), PChar('Theme'), PChar(TBXCurrentTheme), PChar(fileName));

  FWindowInfo.Free;

end;

{*------------------------------------------------------------------------------
  初期化
------------------------------------------------------------------------------*}
procedure TfrmMain.Init;
begin
  //探索終わし
  Finding := False;
  Screen.Cursor := crDefault;
  imlFinder.Draw(FFinderCanvas, 2, 2, 1, True);

end;

{*------------------------------------------------------------------------------
  マウスアップ
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

  DrawFrameRect(NowWnd);  // 枠線を上書き消去
  ReleaseCapture;         // マウスキャプチャ解除

  Init; // 元に戻す

end;

{*------------------------------------------------------------------------------
  マウス移動
  @param Sender   ParameterDescription
  @param Shift   ParameterDescription
  @param X   ParameterDescription
  @param Y   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Wnd:HWnd;//ターゲットのハンドル
  PT:TPoint;//カーソル位置
  tmpWnd: HWnd;
  tmpHdc: HDC;
  color : TColorRef;
begin

  if not Finding then exit; //探索（マウスキャプチャ）中でなければ終わし

  GetCursorPos(PT);         //マウスカーソルの位置を取得

  // 位置
  edtMousePos.Text := '(' + IntToStr(PT.X) + ',' + IntToStr(PT.Y) + ')';

  Wnd:=WindowFromPoint(PT); //カーソル位置からハンドルを取得

  // 色
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

  if Wnd = NowWnd then exit;  //前と同じなら終わし

  DrawFrameRect(NowWnd);  //前に書いた枠線を上書きで消す

  NowWnd := Wnd;  //新たに設定

  DrawFrameRect(NowWnd);  //ターゲットを枠線で囲む

  ReadWindowInformation(NowWnd);  // ウィンドウ情報取得
  ReleaseDC(Wnd, tmpHdc);

end;

{*------------------------------------------------------------------------------
  適用ボタン
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.btnAppyClick(Sender: TObject);
begin

  // 保存
  if IsWindow(FWindowInfo.Handle) then begin

    FWindowInfo.Text := edtCaption.Text;
    FWindowInfo.IsTopMost := chkTopMost.Checked;
    FWindowInfo.IsEnabled := chkEnabled.Checked;
    FWindowInfo.IsVisible := chkVisible.Checked;

    FWindowInfo.Save;
  end;

end;

{*------------------------------------------------------------------------------
  Finder開始
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
  Finding:=True;  //探索開始

  Screen.Cursor:=1; //カーソルを変更

  imlFinder.Draw(FFinderCanvas, 2, 2, 0, True);

  NowWnd := 0;  //初期化

  SetCapture(Handle); // 自分のフォームウィンドウにキャプチャーしたイベントが入ってくる

end;

{*------------------------------------------------------------------------------
  Finder描画
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
  サブクラスプロシージャ
  @param msg   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.SubClassProc(var msg: TMessage);
begin

  OriginProc(msg);  // 本来のウィンドウ関数を実行

  //ウィンドウメッセージによって処理を振り分け
  case msg.Msg of
  WM_PAINT: PaintFinder();
  end;
end;

{*------------------------------------------------------------------------------
  最前面表示
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuViewTopMostClick(Sender: TObject);
begin
  SetWindowTopMost(Self.Handle, mnuViewTopMost.Checked);  // 最前面設定切り替え
  mnuViewTopMost.Checked := not mnuViewTopMost.Checked;   // チェックボックス
end;

{*------------------------------------------------------------------------------
  閉じる
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuFileCloseClick(Sender: TObject);
begin
  Self.Close;
end;

{*------------------------------------------------------------------------------
  ウィンドウ情報読み込み
  @param hWnd   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.ReadWindowInformation(hWnd: HWND);
begin

  if not IsWindow(hWnd) then Exit; 

  // ハンドル
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

    // ウィンドウコントローラーインスタンスがあったらウィンドウ位置読み込み
    if Assigned(frmWindowController) then begin
      frmWindowController.LoadWindowPosition();
    end;

  end;

end;

{*------------------------------------------------------------------------------
  最新表示
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
  テーマタイプ選択
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

{* ■読み取り属性 *}

{*------------------------------------------------------------------------------
  設定
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrSetTextBoxReadOnlyClick(Sender: TObject);
begin
  if IsNumeric(edtHandle.Text) then
    SendMessage(StrToInt(edtHandle.Text), EM_SETREADONLY, 1, 0);
end;
{*------------------------------------------------------------------------------
  解除
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.tbrRemoveTextBoxReadOnlyClick(Sender: TObject);
begin
  if IsNumeric(edtHandle.Text) then
    SendMessage(StrToInt(edtHandle.Text), EM_SETREADONLY, 0, 0);
end;

{* ■パスワードマスク *}

{*------------------------------------------------------------------------------
  設定
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
  解除
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
  ウィンドウ統合操作ウィンドウ表示・非表示
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmMain.mnuToolWindowOperateClick(Sender: TObject);
begin

  mnuToolWindowOperate.Checked := not mnuToolWindowOperate.Checked;
  if not Assigned(frmWindowController) then begin
    // 未生成の場合は生成する。
    frmWindowController := TfrmWindowController.Create(Self, GetDesktopWindow());
    SpChangeThemeType(frmWindowController, thtWindows);
    frmWindowController.LoadWindowPosition(); // ウィンドウ位置読み込み
    frmWindowController.Show;
  end else begin
    // 生成済みの場合は破棄する。
    mnuToolWindowOperate.Checked := not Assigned(frmWindowController);
    frmWindowController.Free;
    frmWindowController := nil;
  end;

end;

{*------------------------------------------------------------------------------
  テーマタイプ選択
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
