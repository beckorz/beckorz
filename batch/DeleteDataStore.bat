@rem Windows Updateの履歴削除
@rem シャットダウンスクリプトにでも設定しておくと吉？
@rem 参考：http://zenryokuhp.com/blog/archives/2010/11/windows_xpwindo.php
@echo off
setlocal

net stop "Automatic Updates"
pushd "%windir%\SoftwareDistribution\DataStore" && del /s /q * >nul
popd
net start "Automatic Updates"

endlocal
echo on
@exit /b
