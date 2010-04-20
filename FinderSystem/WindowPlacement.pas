{*------------------------------------------------------------------------------
  ウィンドウ位置を読み込み、保存、設定クラス
  
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit WindowPlacement;

interface
{ 宣言部 }

uses
  Windows, SysUtils;

type
  TWindowPlacementer = class(TObject)
  private
    { Private 宣言 : あらゆるアクセスからの保護 }
    FWindowPlacement : TWindowPlacement;

  protected
    { Protected 宣言 : 下位クラスのアクセスのみ許可 }

  public
    { Public 宣言 : すべてのアクセスを許可(オブジェクトインスペクタには表示されません) }
    constructor Create;   // コンストラクタ
    destructor Destroy; override;   // デストラクタ

    procedure Load(iSectionName: String = 'Window'; iFilePath: String = '');
    procedure Save(hWnd: HWND; iSectionName: String = 'Window'; iFilePath: String = '');
    procedure SetToWindow(hWnd: HWND);

  published
    { Published 宣言 : すべてのアクセスを許可(オブジェクトインスペクタに表示されます) }

  end;

implementation
{ 実装部 }

{*------------------------------------------------------------------------------
  初期ファイル名取得(実行ファイルと同名のiniファイル)
  @return ResultDescription
------------------------------------------------------------------------------*}
function GetDefaultFileName(): String;
var
  ModuleName: array[0..MAX_PATH] of Char;
begin
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  Result := ExtractFilePath(String(ModuleName)) + ChangeFileExt(ExtractFileName(String(ModuleName)), '') + '.ini';
end;

//******************************************************************************
//  公開プロパティ
//******************************************************************************

//******************************************************************************
//  公開メソッド
//******************************************************************************

{*------------------------------------------------------------------------------
  コンストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TWindowPlacementer.Create;
begin
  inherited;

end;

{*------------------------------------------------------------------------------
  デストラクタ
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TWindowPlacementer.Destroy;
begin

  inherited;
end;

{*------------------------------------------------------------------------------
  ウィンドウ位置情報を読み込み
  @param iSectionName   セクション名
  @param iFilePath   ファイルパス
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.Load(iSectionName: String = 'Window'; iFilePath: String = '');
var
  fileName : String;
begin

  // ファイルパス
  if iFilePath = '' then begin
    fileName := GetDefaultFileName();
  end else begin
    fileName := iFilePath;
  end;

  // iniファイルより前回のウィンドウ情報を取得
  GetPrivateProfileStruct(PChar(iSectionName), PChar('WindowPlacement'), @FWindowPlacement, sizeof(TWindowPlacement), PChar(fileName));

end;

{*------------------------------------------------------------------------------
  ウィンドウ位置情報を設定
  @param hWnd   ウィンドウハンドル
  @param iSectionName   セクション名
  @param iFilePath   ファイルパス
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.Save(hWnd: HWND; iSectionName: String = 'Window'; iFilePath: String = '');
var
  wp : TWindowPlacement;
  fileName : String;
begin
  // ファイルパス
  if iFilePath = '' then begin
    fileName := GetDefaultFileName();
  end else begin
    fileName := iFilePath;
  end;

  // WindowPlacement情報を取得
  wp.length :=Sizeof(TWindowPlacement);
  GetWindowPlacement(hWnd, @wp);

  // 状態保存
  WritePrivateProfileStruct(PChar(iSectionName), PChar('WindowPlacement'), @wp, sizeof(TWindowPlacement) , PChar(fileName));
end;

{*------------------------------------------------------------------------------
  対象ウィンドウへ位置情報設定
  @param hWnd   ウィンドウハンドル
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.SetToWindow(hWnd: HWND);
begin

  SetWindowPlacement(hWnd, @FWindowPlacement);

end;

end.

