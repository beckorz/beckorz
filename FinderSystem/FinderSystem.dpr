{*------------------------------------------------------------------------------
  FinderSystemプロジェクトファイル
  @Author    beck
  @Version   2009.02.13   beck	Initial revision
-------------------------------------------------------------------------------}

program FinderSystem;

uses
  HeapChecker,
  Forms,
  Main in 'Main.pas' {frmMain},
  Finder in 'Finder.pas',
  Window in 'Window.pas',
  CommonUtil in 'CommonUtil.pas',
  WindowPlacement in 'WindowPlacement.pas',
  WindowController in 'WindowController.pas' {frmWindowController},
  AppWinFix in 'AppWinFix.pas';

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
