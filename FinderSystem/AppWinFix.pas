{*------------------------------------------------------------------------------
  VCLのアプリケーションウィンドウの修正用ユニット

  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

{ -----------------------------------
アプリケーションウィンドウに対する対処
    WindowVistaではかなり必須のようです。
    いいかげん、この問題に根本的に対処できないだろうか。
    もう5～10年来問題が放置されてる。

◆使い方
・  このユニットをusesに加えておく
      uses +AppWinFix

・  メインフォームでは
    継承元をTForm→TCustomMainFormに変更する
      TForm1 = class(TCustomMainForm)

・  アプリケーション全体を最大化/最小化/リストア化する場合は
      ApplicationMaximize/ApplicationMinimize/ApplicationRestore
    を使うこと

・  サブフォームでは
    継承元をTForm→TCustomSubFormに変更する
      TForm2 = class(TCustomSubForm)
    変更しなくても問題にはならないが動作が限定される

・  サブフォームでは
    生成時にタスクバーへの登録挙動やZオーダーを決めるために
      ①Form2 := TForm2.Create(Self, Self(=Form1).Handle);
      ②Form3 := TForm3.Create(Self, Application.Handle);
      ③Form4 := TForm4.Create(Self, GetDesktopWindow(=0));
    をCreateの引数で選択することができる。
    Form1はメインフォーム。

      ①Form1.Handleを指定した時
          Form2は常にForm1よりも手前にくる
          (他アプリの前面にくるわけではない)
          Form2はタスクバーに登録されない

      ②Application.Handleを指定した時
          Form1とForm3はZオーダーは切り替え可能
          Form3はタスクバーに登録されない

      ③GetDesktopWindowを指定した時
          Form1とForm4はZオーダーは切り替え可能
          Form4はタスクバーに登録される

    このような挙動を示す。
    継承元をTForm→TCustomSubFormに変更していない場合は
    「②Application.Handleを指定した時」と同じ動作になる。

・  TCustomSubFormを指定したサブフォームでは
    AppMinHideプロパティをTrue/Falseで指定することができる。
    Trueの場合(指定しない場合のデフォルト)
      アプリケーション全体(メインフォーム)が最小化した時に、非表示になる。
    Falseの場合、
      アプリケーション全体が最小化しても、表示されている。
      ただしCreateの引数が①の時はこのフラグは無視されて
      最小化した時に、非表示になる。

・	実際に使い勝手がよいサブフォームは③②①の順番だと思う。
	ダイアログとして使うなら①を利用するとよいだろう。

2006/11/19 21:40
・  作成
2006/12/10 0:23
・	TCustomMainForm.CreateParamsのParams.ExStyleを変更

参考────────────────────
D_DevLog アプリケーションウィンドウに対する対処 (4)
http://ddev.blog46.fc2.com/blog-entry-70.html#more
ここのユニットから改造している

Delphiで、Windows Vista Readyアプリケーションを作る
http://bdn.borland.com/article/33747
//----------------------------------- }

unit AppWinFix;

interface

uses
  Windows, Controls, Forms, Dialogs, Messages, Classes, SysUtils;

type
  { メインフォーム用 }
  TCustomMainForm = class(TForm)
  private
    FWindowList: TList;
    procedure RestoreAllForm;
    procedure HideAllForm;
  protected
    procedure DoShow; override;   // privateだった
//    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {↓アプリケーションの最小最大通常化メソッド}
    procedure ApplicationMaximize;
    procedure ApplicationMinimize;
    procedure ApplicationRestore;
  end;

type
  { サブフォーム用 }
  TCustomSubForm = class(TForm)
  private
    FParentWinHandle: HWND;
    FAppMinHide: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;  // privateだった
  public
    constructor Create(AOwner: TComponent; ParentWinHandle: HWND);
    property ParentWinHandle: HWND read FParentWinHandle write FParentWinHandle;
  published
    property AppMinHide: Boolean read FAppMinHide write FAppMinHide;
  end;

implementation

{ TCustomMainForm }

{*------------------------------------------------------------------------------
  最大化
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationMaximize;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0 );
end;

{*------------------------------------------------------------------------------
  最小化
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationMinimize;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0 );
end;

{*------------------------------------------------------------------------------
  元に戻す
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.ApplicationRestore;
begin
  SendMessage(Handle, WM_SYSCOMMAND, SC_RESTORE, 0 );
end;

{*------------------------------------------------------------------------------
  すべてのフォーム非表示
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
  {↑MainFormの最小化タイミングにあわせて
     表示されているFormがTCustomSubFormなら非表示にする
     AppMinHideプロパティもチェックしている}
end;

{*------------------------------------------------------------------------------
  全てのウィンドウを元に戻す
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
  {↑MainFormの元に戻すタイミングにあわせて
     非表示になったFormを表示する}
  FWindowList.Clear;
end;

{*------------------------------------------------------------------------------
  コンストラクタ
  @param AOwner   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TCustomMainForm.Create(AOwner: TComponent);
begin
  FWindowList := TList.Create;
  inherited;
end;

{*------------------------------------------------------------------------------
  パラメータ作成
  @param Params   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
//  Params.ExStyle := Params.ExStyle and not WS_EX_TOOLWINDOW or WS_EX_APPWINDOW;
  {↑↓上記記述ではMainFormにBorderStyle:=bsToolWindowを指定している場合などに
       誤動作が起きるので、下記のようにしておく}
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
  {↑MainFormをタスクバーに登録}
end;

{*------------------------------------------------------------------------------
  デストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TCustomMainForm.Destroy;
begin
  inherited;
  FWindowList.Free;
end;

{*------------------------------------------------------------------------------
  アクティブ時
  @return ResultDescription
------------------------------------------------------------------------------*}
//procedure TCustomMainForm.WMActivate(var Message: TWMActivate);
//begin
//  inherited;
//  ShowWindow(Application.Handle, SW_HIDE);
//end;
{↓↑WMActiveで行うよりDoShowイベントで行った方がよいので変更}

{*------------------------------------------------------------------------------
  表示
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomMainForm.DoShow;
begin
  inherited;
  ShowWindow(Application.Handle,SW_HIDE);
  //タスクマネージャー内のApplicationWindowの登録を消す
end;

{*------------------------------------------------------------------------------
  サイズ変更時
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
  システムコマンド
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
  サブフォーム作成時
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
  パラメータ作成
  @param Params   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TCustomSubForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FParentWinHandle;
end;

initialization
  {↓パッケージに組み込むとIDEのタスクバーボタンが消えてしまうので、その対策処理}
  if not SameText(ExtractFileName(Application.ExeName), 'bds.exe') then begin
    {↓アプリケーションウィンドウをタスクボタンから消し画面の存在も消す}
    ShowWindow(Application.Handle, SW_HIDE);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) and not WS_EX_APPWINDOW
      or WS_EX_TOOLWINDOW);
  //  ShowWindow(Application.Handle, SW_SHOW);

//    Application.ModalPopupMode := pmExplicit;
    {↑D_DevLog：アプリケーションウィンドウに対する対処 (2)：2006/11/07(火)より
       ShowModal同様、ShowMessageやTOpenDialog等のコモンダイアログで
       フォームのタスクバーボタンをクリックしたときの問題が発生する。
       ことへの対応}
  end;
end.

