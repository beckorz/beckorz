{*------------------------------------------------------------------------------
  �E�B���h�E���샆�j�b�g
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit Window;

interface
{ �錾�� }

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
    { Private �錾 : ������A�N�Z�X����̕ی� }
    FParentHandle: HWND;  // �e�E�B���h�E�n���h��
		FHandle: HWND;		// �E�B���h�E�n���h��
		FText: WideString;		// �E�B���h�E�e�L�X�g
		FClassName: WideString;		// �N���X��
		FIsTopMost: Boolean;		// �őO�ʕ\��
		FIsVisible: Boolean;		// �\��
		FIsEnabled: Boolean;		// �L��
		FIsUnicode: Boolean;		// ���j�R�[�h
		FIsZoomed: Boolean;		// �ő剻
		FIsIconic: Boolean;		// �ŏ���
		FIsNormal: Boolean;		// �ʏ�\��
		FStyle: Integer;		// �X�^�C��
		FExStyle: Integer;		// �g���X�^�C��
		FRect: TRect;		// ��`
		FClientRect: TRect;		// ��`
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
    { Protected �錾 : ���ʃN���X�̃A�N�Z�X�̂݋��� }

  public
    { Public �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɂ͕\������܂���) }
    constructor Create;   // �R���X�g���N�^
    destructor Destroy; override;   // �f�X�g���N�^

    procedure Load(Handle: HWND);
    procedure Save;

		property ParentHandle: HWND			read GetParentHandle write SetParentHandle;		// �e�E�B���h�E�n���h��
    property Handle: HWND			read GetHandle write SetHandle;		// �E�B���h�E�n���h��
		property Text: WideString			read GetText write SetText;		// �E�B���h�E�e�L�X�g
		property ClassName: WideString  			read GetClassName write SetClassName;   // �N���X��
		property IsTopMost: Boolean			read GetIsTopMost write SetIsTopMost;		// �őO�ʕ\��
		property IsVisible: Boolean			read GetIsVisible write SetIsVisible;		// �\��
		property IsEnabled: Boolean			read GetIsEnabled write SetIsEnabled;		// �L��
		property IsUnicode: Boolean			read GetIsUnicode write SetIsUnicode;		// ���j�R�[�h
		property IsZoomed: Boolean			read GetIsZoomed write SetIsZoomed;		// �ő剻
		property IsIconic: Boolean			read GetIsIconic write SetIsIconic;		// �ŏ���
		property IsNormal: Boolean			read GetIsNormal write SetIsNormal;		// �ʏ�\��
		property Style: Integer			read GetStyle write SetStyle;		// �X�^�C��
		property ExStyle: Integer			read GetExStyle write SetExStyle;		// �g���X�^�C��
		property Rect: TRect			read GetRect write SetRect;		// ��`
		property ClientRect: TRect			read GetClientRect write SetClientRect;		// ��`
		property hInstance: Integer			read GethInstance write SethInstance;		//

  published
    { Published �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɕ\������܂�) }

  end;

implementation
{ ������ }

{*------------------------------------------------------------------------------
  �E�B���h�E�̍őO�ʕ\���ݒ�؂�ւ�
  @param hWnd   �E�B���h�E�n���h��
  @param IsSet   �Z�b�g���邩
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
  �őO�ʐݒ肩?
  @param hWnd   �E�B���h�E�n���h��
  @return ����
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
  ��`���擾
  @param Rect   �Ώۋ�`
  @return ��
------------------------------------------------------------------------------*}
function GetRectWidth(Rect: TRect): Integer;
begin
  Result := Rect.Right - Rect.Left;
end;

{*------------------------------------------------------------------------------
  ��`���Z�b�g
  @param Rect   �Ώۋ�`
  @param Width   �ݒ蕝
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetRectWidth(var Rect: TRect; Width: Integer);
begin
  Rect.Right := Rect.Left + Width;
end;

{*------------------------------------------------------------------------------
  ��`�̍����擾
  @param Rect   �Ώۋ�`
  @return ����
------------------------------------------------------------------------------*}
function GetRectHeight(Rect: TRect): Integer;
begin
  Result := Rect.Bottom - Rect.Top;
end;

{*------------------------------------------------------------------------------
  ��`�̍����ݒ�
  @param Rect   ��`
  @param Height   ����
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetRectHeight(var Rect: TRect; Height: Integer);
begin
  Rect.Bottom := Rect.Top + Height;
end;

{*------------------------------------------------------------------------------
  �e�E�B���h�E�ɑ΂���q�E�B���h�E�̑��΃N���C�A���g��`�擾
  @param hParent   �e�E�B���h�E
  @param hChild   �q�E�B���h�E
  @return ��`  
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
  �R���X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TWindowInfo.Create;
begin

end;

{*------------------------------------------------------------------------------
  �f�X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TWindowInfo.Destroy;
begin

  inherited;
end;

{*------------------------------------------------------------------------------
  �^�C�g���ƃN���X���擾
  @param Wnd   �ΏۃE�B���h�E�n���h��
  @param TitleName   �^�C�g����
  @return �N���X��
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
  �E�B���h�E���ǂݍ���
  @param Handle   �E�B���h�E�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.Load(Handle: HWND);
var
  title : WideString;
begin

  FParentHandle := GetParent(Handle); 
  FHandle := Handle;
  // �N���X���ƃ^�C�g���擾
  FClassName := GetItemStrings(FHandle, title);  // �N���X���� String �Ŏ擾
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
  �E�B���h�E���ۑ�
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.Save();
begin

  EnableWindow(FHandle, IsEnabled);                 // �L���ݒ�
  ShowWindow(FHandle, Integer(IsVisible And True)); // ���ݒ�
  SetWindowTopMost(FHandle, Not IsTopMost);         // �őO��
  SetWindowTextW(FHandle, PWideChar(FText));        // �E�B���h�E�e�L�X�g

  // �ēǂݍ���
  Self.Load(FHandle);

end;

{* �e�E�B���h�E�n���h�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetParentHandle(): HWND;
begin
	Result := FParentHandle;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetParentHandle(const Val: HWND);
begin
	FParentHandle := Val;
end;

{* �E�B���h�E�n���h�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetHandle(): HWND;
begin
	Result := FHandle;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetHandle(const Val: HWND);
begin
	FHandle := Val;
end;

{* �E�B���h�E�e�L�X�g *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetText(): WideString;
begin
	Result := FText;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetText(const Val: WideString);
begin
	FText := Val;
end;

{* �N���X�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetClassName(): WideString;
begin
	Result := FClassName;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetClassName(const Val: WideString);
begin
	FClassName := Val;
end;

{* �őO�ʕ\�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsTopMost(): Boolean;
begin
	Result := FIsTopMost;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsTopMost(const Val: Boolean);
begin
	FIsTopMost := Val;
end;

{* �\�� *}

{*------------------------------------------------------------------------------
  �\��
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsVisible(): Boolean;
begin
	Result := FIsVisible;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsVisible(const Val: Boolean);
begin
	FIsVisible := Val;
end;

{* �L�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsEnabled(): Boolean;
begin
	Result := FIsEnabled;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsEnabled(const Val: Boolean);
begin
	FIsEnabled := Val;
end;

{* ���j�R�[�h *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsUnicode(): Boolean;
begin
	Result := FIsUnicode;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsUnicode(const Val: Boolean);
begin
	FIsUnicode := Val;
end;


{* �ő剻 *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsZoomed(): Boolean;
begin
	Result := FIsZoomed;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsZoomed(const Val: Boolean);
begin
	FIsZoomed := Val;
end;

{* �ŏ��� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsIconic(): Boolean;
begin
	Result := FIsIconic;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsIconic(const Val: Boolean);
begin
	FIsIconic := Val;
end;

{* �ʏ�\�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetIsNormal(): Boolean;
begin
	Result := FIsNormal;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetIsNormal(const Val: Boolean);
begin
	FIsNormal := Val;
end;

{* �X�^�C�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetStyle(): Integer;
begin
	Result := FStyle;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetStyle(const Val: Integer);
begin
	FStyle := Val;
end;

{* �g���X�^�C�� *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetExStyle(): Integer;
begin
	Result := FExStyle;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetExStyle(const Val: Integer);
begin
	FExStyle := Val;
end;

{* ��` *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetRect(): TRect;
begin
	Result := FRect;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetRect(const Val: TRect);
begin
	FRect := Val;
end;

{* �N���C�A���g��` *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GetClientRect(): TRect;
begin
	Result := FClientRect;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SetClientRect(const Val: TRect);
begin
	FClientRect := Val;
end;

{* �C���X�^���X *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TWindowInfo.GethInstance(): Integer;
begin
	Result := FhInstance;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Val   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowInfo.SethInstance(const Val: Integer);
begin
	FhInstance := Val;
end;

end.
