@echo off
echo --------------------------------------------------
echo    Oracle10g用リスナーログローテーション
echo --------------------------------------------------

setlocal
rem ～環境に応じて設定変更ここから～
rem Oracleリスナーログ出力ディレクトリ(lsnrctl show log_directoryで確認)
set LOGDIR="D:\oracle\product\10.2.0\db_1\network\log"
rem 基本ログファイル名
set ORGLOG=listener.log
rem テンポラリログファイル名
set TMPLOG=listener.tmp.log
rem ローテーションログファイル名(listener_yyyymmdd.log)
set NEWLOG=listener_%date:/=%.log
rem ローテーションログファイルマスク
set LOGMASK=listener_*.log
rem 保存件数
set SAVECOUNT=7
rem ～環境に応じて設定変更ここまで～

pushd %LOGDIR%
lsnrctl set log_file %TMPLOG%
type %ORGLOG% >> %NEWLOG%
del /f %ORGLOG%
lsnrctl set log_file %ORGLOG%
type %TMPLOG% >> %NEWLOG%
del /f %TMPLOG%
for /f "skip=%SAVECOUNT% delims=\" %%F in ('dir /b /o-d %LOGMASK%') do del /f "%%F"
popd

endlocal
echo on
@exit /b
