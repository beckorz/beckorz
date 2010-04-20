{*------------------------------------------------------------------------------
  Finderクラス
<p>
  パネルクラスと、イメージリストコントロールを使って、ファインダー機能と描画を担当<br />

  NOTE: マウスカーソルとか依存性が微妙な作りなので修正する必要あり<br />

  TODO: キャプチャーイベントもこっち側でフォーム側に通知する
  TODO: 子ウィンドウ検索機能もFinderクラスが担当させる
</p>
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit Finder;

interface
{ 宣言部 }

uses
  Windows, Messages, Classes, ExtCtrls, Controls, Graphics, Forms;

type
  /// TFinder (ファインディング担当クラス)
  TFinder = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }

    FOriginProc: TWndMethod;    /// 元のウィンドウ関数保持用
    FFinderPanel: TPanel;       /// ファインダーコントロールのパネル
    FImlFinder: TImageList;     /// Finderのイメージリスト
		FFinding: Boolean;		      /// 検索中
    FFinderCanvas: TCanvas;     /// Finder描画キャンバス

    FOnChange: TNotifyEvent;
    FOnMouseMove: TNotifyEvent;

    procedure SubClassProc(var msg: TMessage);
    procedure PaintFinder();

		function GetFinding: Boolean;
		procedure SetFinding(const Value: Boolean);

  protected
    { Protected 宣言 : 下位クラスのアクセスのみ許可 }

  public
    { Public 宣言 : すべてのアクセスを許可(オブジェクトインスペクタには表示されません) }
    constructor Create(var FinderPanel: TPanel; var ImageList: TImageList);   // コンストラクタ
    destructor Destroy; override;   // デストラクタ

		property Finding: Boolean			read GetFinding write SetFinding;		/// 検索中

    procedure DrawFrameRect(Wnd: HWnd); /// 枠線描画

  published
    { Published 宣言 : すべてのアクセスを許可(オブジェクトインスペクタに表示されます) }

//    property OnChange;
//    property OnMouseMove;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseMove: TNotifyEvent read FOnMouseMove write FOnMouseMove;

  end;

implementation
{ 実装部 }

//******************************************************************************
//  内部関数
//******************************************************************************

{*------------------------------------------------------------------------------
  サブクラス化用ウィンドウプロシージャ
  @param msg   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TFinder.SubClassProc(var msg: TMessage);
begin

  FOriginProc(msg);  // 本来のウィンドウ関数を実行

  //ウィンドウメッセージによって処理を振り分け
  case msg.Msg of
  WM_PAINT: PaintFinder();
  end;
end;

{*------------------------------------------------------------------------------
  Finder描画
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TFinder.PaintFinder();
begin
  if FFinding then begin
    FImlFinder.Draw(FFinderCanvas, 2, 2, 0, True);
  end else begin
    FImlFinder.Draw(FFinderCanvas, 2, 2, 1, True);
  end;
end;

//******************************************************************************
//  公開メソッド
//******************************************************************************

{*------------------------------------------------------------------------------
  コンストラクタ(依存コンポーネントもここで参照させる)
  @param FinderPanel   Finderコントロール用パネル
  @param ImageList   Finder用画像描画用イメージリスト
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TFinder.Create(var FinderPanel: TPanel; var ImageList: TImageList);
begin

  // サブクラス化
  FFinderPanel := FinderPanel;              // 対象ファインダーパネル退避
  FOriginProc := FinderPanel.WindowProc;    // 元ウィンドウプロシージャを退避
  FinderPanel.WindowProc := SubClassProc;   // ウィンドウプロシージャをサブクラス化プロシージャに置き換え

  FImlFinder := ImageList;                  // イメージリスト退避

  // Finderキャンバス(Finderパネル)
  FFinderCanvas := TCanvas.Create;
  FFinderCanvas.Handle := GetDC(FFinderPanel.Handle);

  FImlFinder.Draw(FFinderCanvas, 2, 2, 1, True);

end;

{*------------------------------------------------------------------------------
  デストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TFinder.Destroy;
begin
  FFinderPanel.WindowProc := FOriginProc;   // 元のウィンドウプロシージャに戻す

  // オブジェクト破棄
  ReleaseDC(FFinderPanel.Handle, FFinderCanvas.Handle);
  FFinderCanvas.Free;

  inherited;
end;

{*------------------------------------------------------------------------------
  枠線描画
  @param Wnd   ウィンドウハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TFinder.DrawFrameRect(Wnd: HWnd);
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

//******************************************************************************
//  公開プロパティ
//******************************************************************************

{* 検索中 *}

{*------------------------------------------------------------------------------
  取得
  @return ResultDescription
------------------------------------------------------------------------------*}
function TFinder.GetFinding(): Boolean;
begin
	Result := FFinding;
end;
{*------------------------------------------------------------------------------
  設定
  @param Value   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TFinder.SetFinding(const Value: Boolean);
begin

	FFinding := Value;

  if Value then begin

    Screen.Cursor := 1;         // カーソルを変更
    PaintFinder();              // ファインダー描画
    SetCapture(FFinderPanel.Parent.Handle); // オーナーフォームウィンドウにキャプチャーしたイベントが入ってくる

  end else begin

//    if FFinding then exit;

    ReleaseCapture;         // マウスキャプチャ解除
    PaintFinder();          // ファインダー描画
//    DrawFrameRect(NowWnd);  // 枠線を上書き消去

    Screen.Cursor := crDefault; // カーソルを元に戻す

  end;

end;

end.
