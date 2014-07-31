'////////////////////////////////////////////////////////////////////////
'   Charu3用Charu3Execプラグイン拡張 pipe実行用スクリプト
'
'       標準入出力の文字列を、コマンドとして再度標準入出力へ受け流すシェルリダイレクト用スクリプト(要はパイプリダイレクト)
'
'   ■使用例
'       1. 事前に、Charu3ExecExのコンソールアプリ起動プラグインをインストール
'       2. nkf も導入
'       3. 下記設定でCharu3に登録(Unicode版を前提)
'           - 名称: コマンドライン(選択範囲実行)(ANSI) (※任意名称で)
'           - テキスト編集: <charuMACRO>$PLUG-IN<.\plugin\Charu3ExecEx_Uni.dll,$SEL>$PLUG-IN</charuMACRO>
'           - 拡張マクロ: ExecCmd=cmd /c nkf32 -s|CSCRIPT .\plugin\scripts\shellexecute.vbs //nologo|nkf32 -w16L0
'       4. エディタ内で実行したい文字列 (例 ping 8.8.8.8) を選択状態にして、Charu3で登録したデータを選択する。(選択する文字列は複数行でも可能で順番に実行される。)
'       5. 結果がCharu3へ貼り付けられる
'
'   @see Keijiweb ver 丙 - Unicode版Charu3で「コンソールアプリ起動プラグイン」を使う。 http://keijiweb.com/dView.pl?m=1&user=keizi&thid=20070419121918&tid=20071025135115
'   @version 2014-07-30 beck
'////////////////////////////////////////////////////////////////////////
Option Explicit

Dim wshell, wobjWshScriptExec, wobjStdOut, arg, strLine

Set wshell = CreateObject("WScript.Shell")

On Error Resume Next
Do Until WScript.StdIn.AtEndOfStream
    ' 受けた標準入出力を実行コマンドとして扱う
    arg = CStr(WScript.StdIn.ReadLine)
    WScript.StdOut.WriteLine arg                ' 実行用コマンドの控えとして出力

    ' コマンドとして実際に実行
    set wobjWshScriptExec = wshell.Exec(arg)    ' 実行
    set wobjStdOut = wobjWshScriptExec.StdOut
    do until wobjStdOut.AtEndOfStream
        ' 受けた結果を元の標準入出力として返す
        strLine = wobjStdOut.ReadLine           ' 結果
        WScript.StdOut.WriteLine strLine        ' 元の標準入出力へ返す
    loop
Loop

Set wshell = Nothing
WScript.Quit
