@rem �R���p�C���p�o�b�`
@rem 	2008/01/16�@�������[
@rem 
@rem VisualStudio�t����nmake�g�p�O�񂾂��ǁA�Ȃ����GNU make�Ƃ��ł������J���H
@rem 
@rem �R���p�C�����AGBDK�ꎮ�́��������
@rem 	http://code-gb.hp.infoseek.co.jp/puroguramingutuuru.shtml
@rem ���{��\���p�p�b�P�[�WELISAGB�ŕK�v�ɂȂ�I���W�i���Ōb�����t�H���g�́��������
@rem 	http://hp.vector.co.jp/authors/VA002310/original.htm
@rem GB�t�@�C���Ɍb�����t�H���g���������邽�߂�PATCHGB�́��������
@rem ���������p�X�ʂ��̖ʓ|������patchgb.exe��lcc.exe�Ɠ����p�X�ɒu���Ă���
@rem 	http://page.freett.com/gameboy/tool.html

@echo off
setlocal

rem lcc.exe�̃p�X
set LCCPATH=C:\SDK\gbz80-gb\2-1-5\bin
rem ���ϐ�PATH��lcc.exe�ւ̃p�X���ʂ��Ă��Ȃ���Βǉ�
for %%I in (lcc.exe) do (
	set LCC=%%~$PATH:I
)
if "%LCC%"=="" set PATH=%PATH%;%LCCPATH%

rem nmake�ŃR���p�C��
nmake /nologo
if errorlevel 1 goto :END
rem ���ł�zip���k�����Ⴃ�H
set YESNO=N
set /p YESNO=zip���k���܂����H(y/N)�F
set YESNO=%YESNO: =%
if /i "%YESNO:~0,1%"=="y" (
	nmake /nologo zip
) else (
	rem set /p�Ŗ����͎���ERRORLEVEL��1�ɂȂ�̂����Z�b�g���邽�߂ɓK���ȃR�}���h���s
	ver > nul
)

:END
if errorlevel 1 (
	echo �����L�[�������ƏI�����܂��B
	pause > nul
)

endlocal
echo on
