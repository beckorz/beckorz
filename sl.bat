@echo off
rem SL���ۂ�����

setlocal enabledelayedexpansion
set LINE01=��-�    �ݺ
set LINE02=�R^^^(`�D�L^^^)�m
set LINE03=�@���@�� �`

set T=%TIME:~6,4%
for /l %%i in (80, -1, 0) do (
	cls
	set pad=
	for /l %%j in (1, 1, %%i) do (
		set pad= !pad!
	)
	echo !pad!%LINE01%
	echo !pad!%LINE02%
	echo !pad!%LINE03%
	call :WAIT
)

endlocal
echo on
@exit /b

:WAIT
if !T!==%TIME:~6,4% goto :WAIT
set T=%TIME:~6,4%
