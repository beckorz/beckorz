{*------------------------------------------------------------------------------
  ウィンドウ統合操作フォーム
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
    { Private 宣言 }
    procedure SetWindowPosition();
  public
    { Public 宣言 }
    procedure LoadWindowPosition();
  end;

var
  frmWindowController: TfrmWindowController;

implementation

{$R *.dfm}

uses
  Main;

{*------------------------------------------------------------------------------
  閉じる
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnCloseClick(Sender: TObject);
begin
  // 呼び出し元のチェックボックスを外す
  frmMain.mnuToolWindowOperate.Checked := not frmMain.mnuToolWindowOperate.Checked;
  Self.Close;
end;

{*------------------------------------------------------------------------------
  フォーム作成時
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.FormCreate(Sender: TObject);
begin
  AppMinHide := False;
end;

{*------------------------------------------------------------------------------
  トラックバーによる位置変更(トラックバーの共通イベント)
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
  ウィンドウ情報取得
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnGetWindowInfoClick(Sender: TObject);
begin
  LoadWindowPosition();
end;

{*------------------------------------------------------------------------------
  フォームを閉じる
  @param Sender   ParameterDescription
  @param Action   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;           // メモリ破棄
  frmWindowController := nil; // nilセット(Assignedチェックの為)
end;

{*------------------------------------------------------------------------------
  適用
  @param Sender   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.btnAppyClick(Sender: TObject);
begin
  SetWindowPosition();
end;

{*------------------------------------------------------------------------------
  ウィンドウの位置を読み込み
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TfrmWindowController.LoadWindowPosition();
var
  win: TRect;
begin

  // イベント発生させないようにnil
  trbPosX.OnChange := nil;
  trbPosY.OnChange := nil;
  trbPosWidth.OnChange := nil;
  trbPosHeight.OnChange := nil;

  // ウィンドウの位置情報を設定(ウィンドウが存在している場合
  if (frmMain.FWindowInfo.Handle <> 0) and IsWindow(frmMain.FWindowInfo.Handle) then begin
    // クライアント矩形取得
    win := GetRelativeClientRect(frmMain.FWindowInfo.ParentHandle, frmMain.FWindowInfo.Handle);
    with win do begin
      edtPosX.Text := IntToStr(win.Left);
      edtPosY.Text := IntToStr(win.Top);
      edtPosWidth.Text := IntToStr(GetRectWidth(win));
      edtPosHeight.Text := IntToStr(GetRectHeight(win));
    end;
  end else begin
    // ウィンドウハンドルが無効の場合
    edtPosX.Text := IntToStr(0);
    edtPosY.Text := IntToStr(0);
    edtPosWidth.Text := IntToStr(0);
    edtPosHeight.Text := IntToStr(0);
  end;

  // トラックバーの設定
  if IsNumeric(edtPosX.Text) then      trbPosX.Position      := StrToInt(edtPosX.Text);
  if IsNumeric(edtPosY.Text) then      trbPosY.Position      := StrToInt(edtPosY.Text);
  if IsNumeric(edtPosWidth.Text) then  trbPosWidth.Position  := StrToInt(edtPosWidth.Text);
  if IsNumeric(edtPosHeight.Text) then trbPosHeight.Position := StrToInt(edtPosHeight.Text);

  // イベント関連付けを戻す
  trbPosX.OnChange := trbPositionChange;
  trbPosY.OnChange := trbPositionChange;
  trbPosWidth.OnChange := trbPositionChange;
  trbPosHeight.OnChange := trbPositionChange;
end;

{*------------------------------------------------------------------------------
  ウィンドウの位置を設定
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
