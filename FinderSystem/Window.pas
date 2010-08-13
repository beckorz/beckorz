{*------------------------------------------------------------------------------
  ウィンドウ操作・情報取得ユニット
  
  @Author   $Author$
  @Version  $Id$
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
  function GetDesktopWorkArea(): TRect;
  procedure SetWindowToCenterOfWorkArea(Handle: HWND);

type

  /// TWindowInfo (ウィンドウ情報管理クラス)
  TWindowInfo = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }
    FParentHandle: HWND;  /// 親ウィンドウハンドル
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

  /// DumpSeek
  TDumpSeek = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }

    _dx : Integer;
    _dy : Integer;
    dx  : Integer;
    dy  : Integer;
    hChildFound : HWND; // 見つかった

    procedure DumpIntoParentWindow(Handle: HWND; pt: TPoint);
    procedure DumpChildWindowLocal(Handle: HWND; pt: TPoint);
    procedure DumpIntoChildWindow(Handle: HWND; pt: TPoint);
    procedure DumpParentWindowLocal(Handle: HWND; pt: TPoint);

  protected
    { Protected 宣言 : 下位クラスのアクセスのみ許可 }

  public
    { Public 宣言 : すべてのアクセスを許可(オブジェクトインスペクタには表示されません) }
    constructor Create;   // コンストラクタ
    destructor Destroy; override;   // デストラクタ

    function SeekDumpWindow(Handle: HWND; pt: TPoint): HWND;

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

{*------------------------------------------------------------------------------
  デスクトップの作業領域(タスクバーを除いた矩形)を取得
  @return 作業領域(矩形)
------------------------------------------------------------------------------*}
function GetDesktopWorkArea(): TRect;
var
  workArea  :  TRect;
begin
  Result := workArea;
  if  SystemParametersInfo(SPI_GETWORKAREA, 0, @workArea, 0) then begin
    Result := workArea;
  end;
end;

{*------------------------------------------------------------------------------
  ウィンドウを作業領域(デスクトップのタスクバーを除いた領域)の中央に表示
  基本は、FormCreate時に使う。
  但し、フォームのPositionプロパティで、余計なセンター表示はしない事。
  poDefaultPosOnlyとかの初期値で設定できる事を確認
  他の設定にすると、フォームサイズがおかしくなってしまう。
  (DelphiのVCLがFormCreate後に補正をかけている為だと思う)
  @param Handle   対象ウィンドウハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetWindowToCenterOfWorkArea(Handle: HWND);
var
  win: TRECT;       // 対象ウィンドウの矩形
  wa: TRECT;        // ワークエリアの矩形
//  width : integer;
//  height : integer;
begin

  GetWindowRect(Handle, win);   // 対象ウィンドウの矩形取得
  wa := GetDesktopWorkArea();   // ワークエリアの矩形取得

  with win do begin
//    // 高さ・幅を退避
//    width := Right - Left;
//    height := Bottom - Top;

    // 左上を作業領域の中央へ補正する。
    Top := ((wa.Bottom - wa.Top) - (Bottom - Top)) div 2 + wa.Top;
    Left := ((wa.Right - wa.Left) - (Right - Left)) div 2 + wa.Left;
    // タスクバー位置よりも少ない場合は、タスクバー位置の方を優先
    if Top < wa.Top then begin   Top := wa.Top;   end;
    if Left < wa.Left then begin Left := wa.Left; end;

    // 補正した位置情報でウィンドウを移動する
//    SetWindowPos(Handle, 0, win.Top, win.Left, 0, 0, SWP_NOZORDER or SWP_NOSIZE);
//    MoveWindow(Handle, Left, Top, width, height, True);
  end;

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

  FStyle := GetWindowLongW(FHandle, GWL_STYLE);
  FExStyle := GetWindowLongW(FHandle, GWL_EXSTYLE);

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
//  SetWindowLong(FHandle, GWL_STYLE, FStyle);        // スタイル
//  SetWindowLong(FHandle, GWL_EXSTYLE, FExStyle);    // 拡張スタイル

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

{ TDumpSeek }

constructor TDumpSeek.Create;
begin

end;

destructor TDumpSeek.Destroy;
begin

  inherited;
end;

{*------------------------------------------------------------------------------
                                                                                
  @param Handle   ParameterDescription
  @param pt   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TDumpSeek.DumpChildWindowLocal(Handle: HWND; pt: TPoint);
var
  hChild: HWND;
  wndRect: TRECT;
begin
  // check if there is at least one child
  hChild := GetWindow(Handle, GW_CHILD);
  GetWindowRect(hChild, wndRect);
  if (IsWindow(hChild)) then begin
    // 子ウィンドウがあるまで
    while (IsWindow(hChild)) do begin
      GetWindowRect(hChild, wndRect);
      if((wndRect.Left < pt.X) and (pt.X < wndRect.Right) and
         (wndRect.Top  < pt.Y) and (pt.Y < wndRect.Bottom)) then begin
        DumpIntoChildWindow(hChild, pt);
      end;
      hChild := GetWindow(hChild, GW_HWNDNEXT); // 次の子ウィンドウ
      if (GetParent(hChild) = 0) then begin
        Exit;
      end;
    end;
  end;

end;

{*------------------------------------------------------------------------------

  @param Handle   ParameterDescription
  @param pt   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TDumpSeek.DumpIntoChildWindow(Handle: HWND; pt: TPoint);
var
	wndRect: TRECT;
begin
	if (not IsWindow(Handle)) then Exit;

	GetWindowRect(Handle, wndRect);
	if ((wndRect.Left < pt.x) and (pt.X < wndRect.Right) and
	    (wndRect.Top  < pt.y) and (pt.Y < wndRect.Bottom)) then begin
		if ((IsWindow(Handle)) and (Handle <> 0)) then begin
			dx := wndRect.Right  - wndRect.Left;
			dy := wndRect.Bottom - wndRect.Top;
			if ((_dx > dx) and (_dy > dy)) then begin
				hChildFound := Handle;
				_dx := dx;
				_dy := dy;
      end;
			DumpChildWindowLocal(Handle, pt);
		end;
	end;

end;

{*------------------------------------------------------------------------------

  @param Handle   ParameterDescription
  @param pt   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TDumpSeek.DumpIntoParentWindow(Handle: HWND; pt: TPoint);
var
  wndRect: TRECT;
begin
  if (not IsWindow(Handle)) then Exit;
  GetWindowRect(Handle, wndRect);
  if ((wndRect.Left < pt.X) and (pt.X < wndRect.Right) and
     (wndRect.Top   < pt.Y) and (pt.Y < wndRect.Bottom)) then begin
    if (IsWindow(Handle) and (Handle <> 0)) then begin
      dx := wndRect.Right - wndRect.Left;
      dy := wndRect.Bottom - wndRect.Top;
      if (( _dx > dx) and (_dy > dy)) then begin
        hChildFound := Handle;
        _dx := dx;
        _dy := dy;
      end;
      DumpChildWindowLocal(Handle, pt);
    end;
  end;

end;

{*------------------------------------------------------------------------------

  @param Handle   ParameterDescription
  @param pt   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TDumpSeek.DumpParentWindowLocal(Handle: HWND; pt: TPoint);
var
	hParent: HWND;
begin
	// retrieve its parent
	hParent := GetParent(Handle);
	// check if it and its parent is a window dialog frame
	if(((GetWindowLongW(Handle, GWL_STYLE) and WS_DLGFRAME) = WS_DLGFRAME) and
	   ((GetWindowLongW(hParent, GWL_STYLE) and WS_DLGFRAME) = WS_DLGFRAME)) then begin
		Exit;
	end;
	if ((IsWindow(hParent)) and (hParent <> 0)) then begin
		DumpChildWindowLocal(hParent, pt);
		DumpParentWindowLocal(hParent, pt);
	end;

end;

{*------------------------------------------------------------------------------
  ウィンドウ検索
  @param Handle   検索開始するウィンドウハンドル
  @param pt   検索する位置
  @return 見つかった子ウィンドウハンドル
------------------------------------------------------------------------------*}
function TDumpSeek.SeekDumpWindow(Handle: HWND; pt: TPoint): HWND;
begin
  hChildFound := 0;

  _dx := 99999;
  _dy := 99999;

  DumpChildWindowLocal(Handle, pt);   // 子ウィンドウ検索
  DumpParentWindowLocal(Handle, pt);  // 親ウィンドウ検索

  Result := hChildFound;

end;

end.
