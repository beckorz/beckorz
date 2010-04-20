{*------------------------------------------------------------------------------
  Finder�N���X
<p>
  �p�l���N���X�ƁA�C���[�W���X�g�R���g���[�����g���āA�t�@�C���_�[�@�\�ƕ`���S��<br />

  NOTE: �}�E�X�J�[�\���Ƃ��ˑ����������ȍ��Ȃ̂ŏC������K�v����<br />

  TODO: �L���v�`���[�C�x���g�����������Ńt�H�[�����ɒʒm����
  TODO: �q�E�B���h�E�����@�\��Finder�N���X���S��������
</p>
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit Finder;

interface
{ �錾�� }

uses
  Windows, Messages, Classes, ExtCtrls, Controls, Graphics, Forms;

type
  /// TFinder (�t�@�C���f�B���O�S���N���X)
  TFinder = class(TObject)
  private
    { Private �錾 : ������A�N�Z�X����̕ی� }

    FOriginProc: TWndMethod;    /// ���̃E�B���h�E�֐��ێ��p
    FFinderPanel: TPanel;       /// �t�@�C���_�[�R���g���[���̃p�l��
    FImlFinder: TImageList;     /// Finder�̃C���[�W���X�g
		FFinding: Boolean;		      /// ������
    FFinderCanvas: TCanvas;     /// Finder�`��L�����o�X

    FOnChange: TNotifyEvent;
    FOnMouseMove: TNotifyEvent;

    procedure SubClassProc(var msg: TMessage);
    procedure PaintFinder();

		function GetFinding: Boolean;
		procedure SetFinding(const Value: Boolean);

  protected
    { Protected �錾 : ���ʃN���X�̃A�N�Z�X�̂݋��� }

  public
    { Public �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɂ͕\������܂���) }
    constructor Create(var FinderPanel: TPanel; var ImageList: TImageList);   // �R���X�g���N�^
    destructor Destroy; override;   // �f�X�g���N�^

		property Finding: Boolean			read GetFinding write SetFinding;		/// ������

    procedure DrawFrameRect(Wnd: HWnd); /// �g���`��

  published
    { Published �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɕ\������܂�) }

//    property OnChange;
//    property OnMouseMove;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnMouseMove: TNotifyEvent read FOnMouseMove write FOnMouseMove;

  end;

implementation
{ ������ }

//******************************************************************************
//  �����֐�
//******************************************************************************

{*------------------------------------------------------------------------------
  �T�u�N���X���p�E�B���h�E�v���V�[�W��
  @param msg   ParameterDescription
  @return ResultDescription  
------------------------------------------------------------------------------*}
procedure TFinder.SubClassProc(var msg: TMessage);
begin

  FOriginProc(msg);  // �{���̃E�B���h�E�֐������s

  //�E�B���h�E���b�Z�[�W�ɂ���ď�����U�蕪��
  case msg.Msg of
  WM_PAINT: PaintFinder();
  end;
end;

{*------------------------------------------------------------------------------
  Finder�`��
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
//  ���J���\�b�h
//******************************************************************************

{*------------------------------------------------------------------------------
  �R���X�g���N�^(�ˑ��R���|�[�l���g�������ŎQ�Ƃ�����)
  @param FinderPanel   Finder�R���g���[���p�p�l��
  @param ImageList   Finder�p�摜�`��p�C���[�W���X�g
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TFinder.Create(var FinderPanel: TPanel; var ImageList: TImageList);
begin

  // �T�u�N���X��
  FFinderPanel := FinderPanel;              // �Ώۃt�@�C���_�[�p�l���ޔ�
  FOriginProc := FinderPanel.WindowProc;    // ���E�B���h�E�v���V�[�W����ޔ�
  FinderPanel.WindowProc := SubClassProc;   // �E�B���h�E�v���V�[�W�����T�u�N���X���v���V�[�W���ɒu������

  FImlFinder := ImageList;                  // �C���[�W���X�g�ޔ�

  // Finder�L�����o�X(Finder�p�l��)
  FFinderCanvas := TCanvas.Create;
  FFinderCanvas.Handle := GetDC(FFinderPanel.Handle);

  FImlFinder.Draw(FFinderCanvas, 2, 2, 1, True);

end;

{*------------------------------------------------------------------------------
  �f�X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TFinder.Destroy;
begin
  FFinderPanel.WindowProc := FOriginProc;   // ���̃E�B���h�E�v���V�[�W���ɖ߂�

  // �I�u�W�F�N�g�j��
  ReleaseDC(FFinderPanel.Handle, FFinderCanvas.Handle);
  FFinderCanvas.Free;

  inherited;
end;

{*------------------------------------------------------------------------------
  �g���`��
  @param Wnd   �E�B���h�E�n���h��
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
//  ���J�v���p�e�B
//******************************************************************************

{* ������ *}

{*------------------------------------------------------------------------------
  �擾
  @return ResultDescription
------------------------------------------------------------------------------*}
function TFinder.GetFinding(): Boolean;
begin
	Result := FFinding;
end;
{*------------------------------------------------------------------------------
  �ݒ�
  @param Value   ParameterDescription
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TFinder.SetFinding(const Value: Boolean);
begin

	FFinding := Value;

  if Value then begin

    Screen.Cursor := 1;         // �J�[�\����ύX
    PaintFinder();              // �t�@�C���_�[�`��
    SetCapture(FFinderPanel.Parent.Handle); // �I�[�i�[�t�H�[���E�B���h�E�ɃL���v�`���[�����C�x���g�������Ă���

  end else begin

//    if FFinding then exit;

    ReleaseCapture;         // �}�E�X�L���v�`������
    PaintFinder();          // �t�@�C���_�[�`��
//    DrawFrameRect(NowWnd);  // �g�����㏑������

    Screen.Cursor := crDefault; // �J�[�\�������ɖ߂�

  end;

end;

end.
