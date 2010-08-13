{*------------------------------------------------------------------------------
  �E�B���h�E����E���擾���j�b�g
  
  @Author   $Author$
  @Version  $Id$
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
  function GetDesktopWorkArea(): TRect;
  procedure SetWindowToCenterOfWorkArea(Handle: HWND);

type

  /// TWindowInfo (�E�B���h�E���Ǘ��N���X)
  TWindowInfo = class(TObject)
  private
    { Private �錾 : ������A�N�Z�X����̕ی� }
    FParentHandle: HWND;  /// �e�E�B���h�E�n���h��
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

  /// DumpSeek
  TDumpSeek = class(TObject)
  private
    { Private �錾 : ������A�N�Z�X����̕ی� }

    _dx : Integer;
    _dy : Integer;
    dx  : Integer;
    dy  : Integer;
    hChildFound : HWND; // ��������

    procedure DumpIntoParentWindow(Handle: HWND; pt: TPoint);
    procedure DumpChildWindowLocal(Handle: HWND; pt: TPoint);
    procedure DumpIntoChildWindow(Handle: HWND; pt: TPoint);
    procedure DumpParentWindowLocal(Handle: HWND; pt: TPoint);

  protected
    { Protected �錾 : ���ʃN���X�̃A�N�Z�X�̂݋��� }

  public
    { Public �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɂ͕\������܂���) }
    constructor Create;   // �R���X�g���N�^
    destructor Destroy; override;   // �f�X�g���N�^

    function SeekDumpWindow(Handle: HWND; pt: TPoint): HWND;

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

{*------------------------------------------------------------------------------
  �f�X�N�g�b�v�̍�Ɨ̈�(�^�X�N�o�[����������`)���擾
  @return ��Ɨ̈�(��`)
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
  �E�B���h�E����Ɨ̈�(�f�X�N�g�b�v�̃^�X�N�o�[���������̈�)�̒����ɕ\��
  ��{�́AFormCreate���Ɏg���B
  �A���A�t�H�[����Position�v���p�e�B�ŁA�]�v�ȃZ���^�[�\���͂��Ȃ����B
  poDefaultPosOnly�Ƃ��̏����l�Őݒ�ł��鎖���m�F
  ���̐ݒ�ɂ���ƁA�t�H�[���T�C�Y�����������Ȃ��Ă��܂��B
  (Delphi��VCL��FormCreate��ɕ␳�������Ă���ׂ��Ǝv��)
  @param Handle   �ΏۃE�B���h�E�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure SetWindowToCenterOfWorkArea(Handle: HWND);
var
  win: TRECT;       // �ΏۃE�B���h�E�̋�`
  wa: TRECT;        // ���[�N�G���A�̋�`
//  width : integer;
//  height : integer;
begin

  GetWindowRect(Handle, win);   // �ΏۃE�B���h�E�̋�`�擾
  wa := GetDesktopWorkArea();   // ���[�N�G���A�̋�`�擾

  with win do begin
//    // �����E����ޔ�
//    width := Right - Left;
//    height := Bottom - Top;

    // �������Ɨ̈�̒����֕␳����B
    Top := ((wa.Bottom - wa.Top) - (Bottom - Top)) div 2 + wa.Top;
    Left := ((wa.Right - wa.Left) - (Right - Left)) div 2 + wa.Left;
    // �^�X�N�o�[�ʒu�������Ȃ��ꍇ�́A�^�X�N�o�[�ʒu�̕���D��
    if Top < wa.Top then begin   Top := wa.Top;   end;
    if Left < wa.Left then begin Left := wa.Left; end;

    // �␳�����ʒu���ŃE�B���h�E���ړ�����
//    SetWindowPos(Handle, 0, win.Top, win.Left, 0, 0, SWP_NOZORDER or SWP_NOSIZE);
//    MoveWindow(Handle, Left, Top, width, height, True);
  end;

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

  FStyle := GetWindowLongW(FHandle, GWL_STYLE);
  FExStyle := GetWindowLongW(FHandle, GWL_EXSTYLE);

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
//  SetWindowLong(FHandle, GWL_STYLE, FStyle);        // �X�^�C��
//  SetWindowLong(FHandle, GWL_EXSTYLE, FExStyle);    // �g���X�^�C��

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
    // �q�E�B���h�E������܂�
    while (IsWindow(hChild)) do begin
      GetWindowRect(hChild, wndRect);
      if((wndRect.Left < pt.X) and (pt.X < wndRect.Right) and
         (wndRect.Top  < pt.Y) and (pt.Y < wndRect.Bottom)) then begin
        DumpIntoChildWindow(hChild, pt);
      end;
      hChild := GetWindow(hChild, GW_HWNDNEXT); // ���̎q�E�B���h�E
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
  �E�B���h�E����
  @param Handle   �����J�n����E�B���h�E�n���h��
  @param pt   ��������ʒu
  @return ���������q�E�B���h�E�n���h��
------------------------------------------------------------------------------*}
function TDumpSeek.SeekDumpWindow(Handle: HWND; pt: TPoint): HWND;
begin
  hChildFound := 0;

  _dx := 99999;
  _dy := 99999;

  DumpChildWindowLocal(Handle, pt);   // �q�E�B���h�E����
  DumpParentWindowLocal(Handle, pt);  // �e�E�B���h�E����

  Result := hChildFound;

end;

end.
