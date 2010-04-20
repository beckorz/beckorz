{*------------------------------------------------------------------------------
  �E�B���h�E�ʒu��ǂݍ��݁A�ۑ��A�ݒ�N���X
  
  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

unit WindowPlacement;

interface
{ �錾�� }

uses
  Windows, SysUtils;

type
  TWindowPlacementer = class(TObject)
  private
    { Private �錾 : ������A�N�Z�X����̕ی� }
    FWindowPlacement : TWindowPlacement;

  protected
    { Protected �錾 : ���ʃN���X�̃A�N�Z�X�̂݋��� }

  public
    { Public �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɂ͕\������܂���) }
    constructor Create;   // �R���X�g���N�^
    destructor Destroy; override;   // �f�X�g���N�^

    procedure Load(iSectionName: String = 'Window'; iFilePath: String = '');
    procedure Save(hWnd: HWND; iSectionName: String = 'Window'; iFilePath: String = '');
    procedure SetToWindow(hWnd: HWND);

  published
    { Published �錾 : ���ׂẴA�N�Z�X������(�I�u�W�F�N�g�C���X�y�N�^�ɕ\������܂�) }

  end;

implementation
{ ������ }

{*------------------------------------------------------------------------------
  �����t�@�C�����擾(���s�t�@�C���Ɠ�����ini�t�@�C��)
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
//  ���J�v���p�e�B
//******************************************************************************

//******************************************************************************
//  ���J���\�b�h
//******************************************************************************

{*------------------------------------------------------------------------------
  �R���X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
constructor TWindowPlacementer.Create;
begin
  inherited;

end;

{*------------------------------------------------------------------------------
  �f�X�g���N�^
  @return ResultDescription
------------------------------------------------------------------------------*}
destructor TWindowPlacementer.Destroy;
begin

  inherited;
end;

{*------------------------------------------------------------------------------
  �E�B���h�E�ʒu����ǂݍ���
  @param iSectionName   �Z�N�V������
  @param iFilePath   �t�@�C���p�X
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.Load(iSectionName: String = 'Window'; iFilePath: String = '');
var
  fileName : String;
begin

  // �t�@�C���p�X
  if iFilePath = '' then begin
    fileName := GetDefaultFileName();
  end else begin
    fileName := iFilePath;
  end;

  // ini�t�@�C�����O��̃E�B���h�E�����擾
  GetPrivateProfileStruct(PChar(iSectionName), PChar('WindowPlacement'), @FWindowPlacement, sizeof(TWindowPlacement), PChar(fileName));

end;

{*------------------------------------------------------------------------------
  �E�B���h�E�ʒu����ݒ�
  @param hWnd   �E�B���h�E�n���h��
  @param iSectionName   �Z�N�V������
  @param iFilePath   �t�@�C���p�X
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.Save(hWnd: HWND; iSectionName: String = 'Window'; iFilePath: String = '');
var
  wp : TWindowPlacement;
  fileName : String;
begin
  // �t�@�C���p�X
  if iFilePath = '' then begin
    fileName := GetDefaultFileName();
  end else begin
    fileName := iFilePath;
  end;

  // WindowPlacement�����擾
  wp.length :=Sizeof(TWindowPlacement);
  GetWindowPlacement(hWnd, @wp);

  // ��ԕۑ�
  WritePrivateProfileStruct(PChar(iSectionName), PChar('WindowPlacement'), @wp, sizeof(TWindowPlacement) , PChar(fileName));
end;

{*------------------------------------------------------------------------------
  �ΏۃE�B���h�E�ֈʒu���ݒ�
  @param hWnd   �E�B���h�E�n���h��
  @return ResultDescription
------------------------------------------------------------------------------*}
procedure TWindowPlacementer.SetToWindow(hWnd: HWND);
begin

  SetWindowPlacement(hWnd, @FWindowPlacement);

end;

end.

