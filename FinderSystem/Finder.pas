{*------------------------------------------------------------------------------
  Finder�N���X
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

unit Finder;

interface
{ �錾�� }

uses
  Windows, Classes;

type
  TFinder = class(TObject)
  private
    { Private �錾 : ������A�N�Z�X����̕ی� }

    FOnChange: TNotifyEvent;
    FOnMouseMove: TNotifyEvent;
    OriginProc: TWndMethod;   /// ���̃E�B���h�E�֐��ێ��p
		FFinding: Boolean;		/// ������

		function GetFinding: Boolean;
		procedure SetFinding(const Value: Boolean);

  protected
    { Protected �錾 : ���ʃN���X�̃A�N�Z�X�̂݋��� }

  public
    { Public �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɂ͕\������܂���) }
    constructor Create;   // �R���X�g���N�^
    destructor Destroy; override;   // �f�X�g���N�^

		property Finding: Boolean			read GetFinding write SetFinding;		// ������

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


//******************************************************************************
//  ���J���\�b�h
//******************************************************************************

{*------------------------------------------------------------------------------
  �R���X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TFinder.Create;
begin

end;

{*------------------------------------------------------------------------------
  �f�X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TFinder.Destroy;
begin
  inherited;
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
end;

end.
