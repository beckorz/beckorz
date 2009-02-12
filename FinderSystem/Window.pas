{*------------------------------------------------------------------------------
  ウィンドウ操作ユニット
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit Window;

interface
{ 宣言部 }

uses
  Windows;

  procedure SetWindowTopMost(hWnd: HWND; IsSet: Boolean);
  function IsWindowTopMost(hWnd: HWND): Boolean;
  function GetRectWidth(Rect: TRect): Integer;
  procedure SetRectWidth(var Rect: TRect; Width: Integer);
  function GetRectHeight(Rect: TRect): Integer;
  procedure SetRectHeight(var Rect: TRect; Height: Integer);
  function GetRelativeClientRect(hParent: hWnd; hChild: hWnd): TRect;

type
  { TWindowInfo }
  TWindowInfo = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }
    FParentHandle: HWND;  // 親ウィンドウハンドル
		FHandle: HWND;		// ウィンドウハンドル
		FText: WideString;		// ウィンドウテキスト
		FClassName: WideString;		// クラス名
		FIsTopMost: Boolean;		// 最前面表示
		FIsVisible: Boolean;		// 表示
		FIsEnabled: Boolean;		// 有効
		FIsUnicode: Boolean;		// ユニコード
		FIsZoomed: Boolean;		// 最大化
		FIsIconic: Boolean;		// 最小化
		FIsNormal: Boolean;		// 通常表示
		FStyle: Integer;		// スタイル
		FExStyle: Integer;		// 拡張スタイル
		FRect: TRect;		// 矩形
		FClientRect: TRect;		// 矩形
		FhInstance: Integer;		//

		function GetParentHandle: HWND;
		procedure SetParentHandle(const Val: HWND);
		function GetHandle: HWND;
		procedure SetHandle(const Val: HWND);
		function GetText: WideString;
		procedure SetText(const Val: WideString);
		function GetClassName: WideString;
		procedure SetClassName(const Val: WideString);
		function GetIsTopMost: Boolean;
		procedure SetIsTopMost(const Val: Boolean);
		function GetIsVisible: Boolean;
		procedure SetIsVisible(const Val: Boolean);
		function GetIsEnabled: Boolean;
		procedure SetIsEnabled(const Val: Boolean);
		function GetIsUnicode: Boolean;
		procedure SetIsUnicode(const Val: Boolean);
		function GetIsZoomed: Boolean;
		procedure SetIsZoomed(const Val: Boolean);
		function GetIsIconic: Boolean;
		procedure SetIsIconic(const Val: Boolean);
		function GetIsNormal: Boolean;
		procedure SetIsNormal(const Val: Boolean);
		function GetStyle: Integer;
		procedure SetStyle(const Val: Integer);
		function GetExStyle: Integer;
		procedure SetExStyle(const Val: Integer);
		function GetRect: TRect;
		procedure SetRect(const Val: TRect);
		function GetClientRect: TRect;
		procedure SetClientRect(const Val: TRect);
		function GethInstance: Integer;
		procedure SethInstance(const Val: Integer);
    function GetItemStrings(Wnd: HWnd; var TitleName: WideString): WideString;

  protected
    { Protected 宣言 : 下位クラスのアクセスのみ許可 }

  public
    { Public 宣言 : すべてのアクセスを許可(オブジェクトインスペクタには表示されません) }
    constructor Create;   // コンストラクタ
    destructor Destroy; override;   // デストラクタ

    procedure Load(Handle: HWND);
    procedure Save;

		property ParentHandle: HWND			read GetParentHandle write SetParentHandle;		// 親ウィンドウハンドル
    property Handle: HWND			read GetHandle write SetHandle;		// ウィンドウハンドル
		property Text: WideString			read GetText write SetText;		// ウィンドウテキスト
		property ClassName: WideString  			read GetClassName write SetClassName;   // クラス名
		property IsTopMost: Boolean			read GetIsTopMost write SetIsTopMost;		// 最前面表示
		property IsVisible: Boolean			read GetIsVisible write SetIsVisible;		// 表示
		property IsEnabled: Boolean			read GetIsEnabled write SetIsEnabled;		// 有効
		property IsUnicode: Boolean			read GetIsUnicode write SetIsUnicode;		// ユニコード
		property IsZoomed: Boolean			read GetIsZoomed write SetIsZoomed;		// 最大化
		property IsIconic: Boolean			read GetIsIconic write SetIsIconic;		// 最小化
		property IsNormal: Boolean			read GetIsNormal write SetIsNormal;		// 通常表示
		property Style: Integer			read GetStyle write SetStyle;		// スタイル
		property ExStyle: Integer			read GetExStyle write SetExStyle;		// 拡張スタイル
		property Rect: TRect			read GetRect write SetRect;		// 矩形
		property ClientRect: TRect			read GetClientRect write SetClientRect;		// 矩形
		property hInstance: Integer			read GethInstance write SethInstance;		//

  published
    { Published 宣言 : すべてのアクセスを許可(オブジェクトインスペクタに表示されます) }

  end;

implementation
{ 実装部 }

{*------------------------------------------------------------------------------
  ウィンドウの最前面表示設定切り替え
  @param hWnd   ウィンドウハンドル
  @param IsSet   セットするか
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetWindowTopMost(hWnd: HWND; IsSet: Boolean);
begin

  if IsSet then begin
    SetWindowPos(hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW);
  end else begin
    SetWindowPos(hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE + SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW);
  end;

end;

{*------------------------------------------------------------------------------
  最前面設定か?
  @param hWnd   ウィンドウハンドル
  @return 結果
------------------------------------------------------------------------------*}
function IsWindowTopMost(hWnd: HWND): Boolean;
var
  exStyle:  Integer;
begin
  exStyle := GetWindowLongW(hWnd, GWL_EXSTYLE);
  if (exStyle and WS_EX_TOPMOST) = WS_EX_TOPMOST then begin
    Result := True;
  end else begin
    Result := False;
  end;

end;

{*------------------------------------------------------------------------------
  矩形幅取得
  @param Rect   対象矩形
  @return 幅
------------------------------------------------------------------------------*}
function GetRectWidth(Rect: TRect): Integer;
begin
  Result := Rect.Right - Rect.Left;
end;

{*------------------------------------------------------------------------------
  矩形幅セット
  @param Rect   対象矩形
  @param Width   設定幅
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetRectWidth(var Rect: TRect; Width: Integer);
begin
  Rect.Right := Rect.Left + Width;
end;

{*------------------------------------------------------------------------------
  矩形の高さ取得
  @param Rect   対象矩形
  @return 高さ
------------------------------------------------------------------------------*}
function GetRectHeight(Rect: TRect): Integer;
begin
  Result := Rect.Bottom - Rect.Top;
end;

{*------------------------------------------------------------------------------
  矩形の高さ設定
  @param Rect   矩形
  @param Height   高さ
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetRectHeight(var Rect: TRect; Height: Integer);
begin
  Rect.Bottom := Rect.Top + Height;
end;

{*------------------------------------------------------------------------------
  親ウィンドウに対する子ウィンドウの相対クライアント矩形取得
  @param hParent   親ウィンドウ
  @param hChild   子ウィンドウ
  @return 矩形  
------------------------------------------------------------------------------*}
function GetRelativeClientRect(hParent: hWnd; hChild: hWnd): TRect;
var
  rChild: TRect;
begin
  GetWindowRect(hChild, rChild);

  Windows.ScreenToClient(hParent, rChild.TopLeft);
  Windows.ScreenToClient(hParent, rChild.BottomRight);

  Result := rChild;

end;


{ TWindowInfo }

{*------------------------------------------------------------------------------
  コンストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TWindowInfo.Create;
begin

end;

{*------------------------------------------------------------------------------
  デストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TWindowInfo.Destroy;
begin

  inherited;
end;

{*------------------------------------------------------------------------------
  タイトルとクラス名取得
  @param Wnd   対象ウィンドウハンドル
  @param TitleName   タイトル名
  @return クラス名
------------------------------------------------------------------------------*}
function TWindowInfo.GetItemStrings(Wnd: HWnd;var TitleName:WideString): WideString;
var
  StrTitle: array[0..255] of WideChar;
  StrClass: array[0..255] of WideChar;
begin
  GetWindowTextW(Wnd, StrTitle, 255);
  GetClassNameW(Wnd, StrClass, 255);
  TitleName := StrTitle;
  Result := StrClass;
end;

{*------------------------------------------------------------------------------
  ウィンドウ情報読み込み
  @param Handle   ウィンドウハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.Load(Handle: HWND);
var
  title : WideString;
begin

  FParentHandle := GetParent(Handle); 
  FHandle := Handle;
  // クラス名とタイトル取得
  FClassName := GetItemStrings(FHandle, title);  // クラス名を String で取得
  FText := title;
  FIsVisible := IsWindowVisible(FHandle);
  FIsEnabled := IsWindowEnabled(FHandle);
  FIsTopMost := IsWindowTopMost(FHandle);
  FIsUnicode := IsWindowUnicode(FHandle);
  FIsZoomed := Windows.IsZoomed(FHandle);
  FIsIconic := Windows.IsIconic(FHandle);
  FIsNormal := not (FIsZoomed or FIsIconic);

  FStyle := GetWindowLong(FHandle, GWL_STYLE);
  FExStyle := GetWindowLong(FHandle, GWL_EXSTYLE);

  GetWindowRect(FHandle, FRect);
  Windows.GetClientRect(FHandle, FClientRect);

end;

{*------------------------------------------------------------------------------
  ウィンドウ情報保存
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.Save();
begin

  EnableWindow(FHandle, IsEnabled);                 // 有効設定
  ShowWindow(FHandle, Integer(IsVisible And True)); // 可視設定
  SetWindowTopMost(FHandle, Not IsTopMost);         // 最前面
  SetWindowTextW(FHandle, PWideChar(FText));        // ウィンドウテキスト

  // 再読み込み
  Self.Load(FHandle);

end;

{* 親ウィンドウハンドル *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetParentHandle(): HWND;
begin
	Result := FParentHandle;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetParentHandle(const Val: HWND);
begin
	FParentHandle := Val;
end;

{* ウィンドウハンドル *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetHandle(): HWND;
begin
	Result := FHandle;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetHandle(const Val: HWND);
begin
	FHandle := Val;
end;

{* ウィンドウテキスト *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetText(): WideString;
begin
	Result := FText;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetText(const Val: WideString);
begin
	FText := Val;
end;

{* クラス名 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetClassName(): WideString;
begin
	Result := FClassName;
end;
{*------------------------------------------------------------------------------
  設定
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetClassName(const Val: WideString);
begin
	FClassName := Val;
end;

{* 最前面表示 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsTopMost(): Boolean;
begin
	Result := FIsTopMost;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsTopMost(const Val: Boolean);
begin
	FIsTopMost := Val;
end;

{* 表示 *}

{*------------------------------------------------------------------------------
  表示
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsVisible(): Boolean;
begin
	Result := FIsVisible;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsVisible(const Val: Boolean);
begin
	FIsVisible := Val;
end;

{* 有効 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsEnabled(): Boolean;
begin
	Result := FIsEnabled;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsEnabled(const Val: Boolean);
begin
	FIsEnabled := Val;
end;

{* ユニコード *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsUnicode(): Boolean;
begin
	Result := FIsUnicode;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsUnicode(const Val: Boolean);
begin
	FIsUnicode := Val;
end;


{* 最大化 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsZoomed(): Boolean;
begin
	Result := FIsZoomed;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsZoomed(const Val: Boolean);
begin
	FIsZoomed := Val;
end;

{* 最小化 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsIconic(): Boolean;
begin
	Result := FIsIconic;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsIconic(const Val: Boolean);
begin
	FIsIconic := Val;
end;

{* 通常表示 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsNormal(): Boolean;
begin
	Result := FIsNormal;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsNormal(const Val: Boolean);
begin
	FIsNormal := Val;
end;

{* スタイル *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetStyle(): Integer;
begin
	Result := FStyle;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetStyle(const Val: Integer);
begin
	FStyle := Val;
end;

{* 拡張スタイル *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetExStyle(): Integer;
begin
	Result := FExStyle;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetExStyle(const Val: Integer);
begin
	FExStyle := Val;
end;

{* 矩形 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetRect(): TRect;
begin
	Result := FRect;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetRect(const Val: TRect);
begin
	FRect := Val;
end;

{* クライアント矩形 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetClientRect(): TRect;
begin
	Result := FClientRect;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetClientRect(const Val: TRect);
begin
	FClientRect := Val;
end;

{* インスタンス *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GethInstance(): Integer;
begin
	Result := FhInstance;
end;
{*------------------------------------------------------------------------------
  設定
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SethInstance(const Val: Integer);
begin
	FhInstance := Val;
end;

end.
