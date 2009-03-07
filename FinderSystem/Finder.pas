{*------------------------------------------------------------------------------
  Finderクラス
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit Finder;

interface
{ 宣言部 }

uses
  Windows, Classes;

type
  TFinder = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }

    FOnChange: TNotifyEvent;
    FOnMouseMove: TNotifyEvent;
    OriginProc: TWndMethod;   /// 元のウィンドウ関数保持用
		FFinding: Boolean;		/// 検索中

		function GetFinding: Boolean;
		procedure SetFinding(const Value: Boolean);

  protected
    { Protected 宣言 : 下位クラスのアクセスのみ許可 }

  public
    { Public 宣言 : すべてのアクセスを許可(オブジェクトインスペクタには表示されません) }
    constructor Create;   // コンストラクタ
    destructor Destroy; override;   // デストラクタ

		property Finding: Boolean			read GetFinding write SetFinding;		// 検索中

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


//******************************************************************************
//  公開メソッド
//******************************************************************************

{*------------------------------------------------------------------------------
  コンストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TFinder.Create;
begin

end;

{*------------------------------------------------------------------------------
  デストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TFinder.Destroy;
begin
  inherited;
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
end;

end.
