@rem Windows Update�̗����폜
@rem �V���b�g�_�E���X�N���v�g�ɂł��ݒ肵�Ă����Ƌg�H
@rem �Q�l�Fhttp://zenryokuhp.com/blog/archives/2010/11/windows_xpwindo.php
@echo off
setlocal

net stop "Automatic Updates"
pushd "%windir%\SoftwareDistribution\DataStore" && del /s /q * >nul
popd
net start "Automatic Updates"

endlocal
echo on
@exit /b
