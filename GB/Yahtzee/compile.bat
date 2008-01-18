@rem コンパイル用バッチ
@rem 	2008/01/16　うっちー
@rem 
@rem VisualStudio付属のnmake使用前提だけど、なければGNU makeとかでもいいカモ？
@rem 
@rem コンパイラ等、GBDK一式は↓から入手
@rem 	http://code-gb.hp.infoseek.co.jp/puroguramingutuuru.shtml
@rem 日本語表示用パッケージELISAGBで必要になるオリジナル版恵梨沙フォントは↓から入手
@rem 	http://hp.vector.co.jp/authors/VA002310/original.htm
@rem GBファイルに恵梨沙フォントをくっつけるためのPATCHGBは↓から入手
@rem あちこちパス通すの面倒だからpatchgb.exeはlcc.exeと同じパスに置いてけれ
@rem 	http://page.freett.com/gameboy/tool.html

@echo off
setlocal

rem lcc.exeのパス
set LCCPATH=C:\SDK\gbz80-gb\2-1-5\bin
rem 環境変数PATHにlcc.exeへのパスが通っていなければ追加
for %%I in (lcc.exe) do (
	set LCC=%%~$PATH:I
)
if "%LCC%"=="" set PATH=%PATH%;%LCCPATH%

rem nmakeでコンパイル
nmake /nologo
if errorlevel 1 goto :END
rem ついでにzip圧縮しちゃぅ？
set YESNO=N
set /p YESNO=zip圧縮しますか？(y/N)：
set YESNO=%YESNO: =%
if /i "%YESNO:~0,1%"=="y" (
	nmake /nologo zip
) else (
	rem set /pで未入力時にERRORLEVELが1になるのをリセットするために適当なコマンド実行
	ver > nul
)

:END
if errorlevel 1 (
	echo 何かキーを押すと終了します。
	pause > nul
)

endlocal
echo on
