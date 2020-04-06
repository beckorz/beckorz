@echo off

cd /d %~dp0

echo Need: NTFS file system.
echo Need: Administrative right.

pause

SET DIR_HOME=%USERPROFILE%
mklink    %DIR_HOME%\AutoHotkey.ahk         %~dp0AutoHotkey.ahk

pause
