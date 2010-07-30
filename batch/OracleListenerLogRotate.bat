@echo off
echo --------------------------------------------------
echo    Oracle10g�p���X�i�[���O���[�e�[�V����
echo --------------------------------------------------

setlocal
rem �`���ɉ����Đݒ�ύX��������`
rem Oracle���X�i�[���O�o�̓f�B���N�g��(lsnrctl show log_directory�Ŋm�F)
set LOGDIR="D:\oracle\product\10.2.0\db_1\network\log"
rem ��{���O�t�@�C����
set ORGLOG=listener.log
rem �e���|�������O�t�@�C����
set TMPLOG=listener.tmp.log
rem ���[�e�[�V�������O�t�@�C����(listener_yyyymmdd.log)
set NEWLOG=listener_%date:/=%.log
rem ���[�e�[�V�������O�t�@�C���}�X�N
set LOGMASK=listener_*.log
rem �ۑ�����
set SAVECOUNT=7
rem �`���ɉ����Đݒ�ύX�����܂Ł`

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
