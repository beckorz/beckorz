{*------------------------------------------------------------------------------
  FinderSystemプロジェクトファイル

  @Author   $Author$
  @Version  $Id$
-------------------------------------------------------------------------------}

program FinderSystem;

uses
  HeapChecker,
  Forms,
  Main in 'Main.pas' {frmMain},
  WindowController in 'WindowController.pas' {frmWindowController},
  Finder in 'Finder.pas',
  Window in 'Window.pas',
  CommonUtil in 'CommonUtil.pas',
  WindowPlacement in 'WindowPlacement.pas',
  AppWinFix in 'AppWinFix.pas',
  OleAcc in 'OleAcc.pas',
  PathUtils in 'PathUtils.pas',
  IniFileUtils in 'IniFileUtils.pas',
  TextBoxUtils in 'TextBoxUtils.pas',
  Glass in 'Glass.pas';

{$R *.res}
{$R cur.res}  // カーソル

begin

  HeapChecker.OutputClassName := True;
  HeapChecker.DumpLeakMemory := True;
//  heapChecker.DisabledChecking := False;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  
end.
