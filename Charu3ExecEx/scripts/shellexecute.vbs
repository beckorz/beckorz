'////////////////////////////////////////////////////////////////////////
'   Charu3�pCharu3Exec�v���O�C���g�� pipe���s�p�X�N���v�g
'
'       �W�����o�͂̕�������A�R�}���h�Ƃ��čēx�W�����o�͂֎󂯗����V�F�����_�C���N�g�p�X�N���v�g(�v�̓p�C�v���_�C���N�g)
'
'   ���g�p��
'       1. ���O�ɁACharu3ExecEx�̃R���\�[���A�v���N���v���O�C�����C���X�g�[��
'       2. nkf ������
'       3. ���L�ݒ��Charu3�ɓo�^(Unicode�ł�O��)
'           - ����: �R�}���h���C��(�I��͈͎��s)(ANSI) (���C�Ӗ��̂�)
'           - �e�L�X�g�ҏW: <charuMACRO>$PLUG-IN<.\plugin\Charu3ExecEx_Uni.dll,$SEL>$PLUG-IN</charuMACRO>
'           - �g���}�N��: ExecCmd=cmd /c nkf32 -s|CSCRIPT .\plugin\scripts\shellexecute.vbs //nologo|nkf32 -w16L0
'       4. �G�f�B�^���Ŏ��s������������ (�� ping 8.8.8.8) ��I����Ԃɂ��āACharu3�œo�^�����f�[�^��I������B(�I�����镶����͕����s�ł��\�ŏ��ԂɎ��s�����B)
'       5. ���ʂ�Charu3�֓\��t������
'
'   @see Keijiweb ver �� - Unicode��Charu3�Łu�R���\�[���A�v���N���v���O�C���v���g���B http://keijiweb.com/dView.pl?m=1&user=keizi&thid=20070419121918&tid=20071025135115
'   @version 2014-07-30 beck
'////////////////////////////////////////////////////////////////////////
Option Explicit

Dim wshell, wobjWshScriptExec, wobjStdOut, arg, strLine

Set wshell = CreateObject("WScript.Shell")

On Error Resume Next
Do Until WScript.StdIn.AtEndOfStream
    ' �󂯂��W�����o�͂����s�R�}���h�Ƃ��Ĉ���
    arg = CStr(WScript.StdIn.ReadLine)
    WScript.StdOut.WriteLine arg                ' ���s�p�R�}���h�̍T���Ƃ��ďo��

    ' �R�}���h�Ƃ��Ď��ۂɎ��s
    set wobjWshScriptExec = wshell.Exec(arg)    ' ���s
    set wobjStdOut = wobjWshScriptExec.StdOut
    do until wobjStdOut.AtEndOfStream
        ' �󂯂����ʂ����̕W�����o�͂Ƃ��ĕԂ�
        strLine = wobjStdOut.ReadLine           ' ����
        WScript.StdOut.WriteLine strLine        ' ���̕W�����o�͂֕Ԃ�
    loop
Loop

Set wshell = Nothing
WScript.Quit
