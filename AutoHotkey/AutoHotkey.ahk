;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
; AutoHotkey Configuration
;  �ݒ���e
;  - Macintosh
;  - Vi Like
;  - US�L�[�{�[�h(101�z��)
;  - JIS�L�[�{�[�h(106�z��)
;
; NOTE: Fn�L�[���p����Fn+Backspace��Delete��ACapsLock�L�[���p��AutoHotkey�ł͖���
;       Apple Wireless Keyboard Helper for Windows?? KeySwap??
;
; see:http://sites.google.com/site/autohotkeyjp
;
;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#UseHook on
; Key�̒x�����x
SetKeyDelay, -1

;-----------------------------
; Common(����)
;-----------------------------
;Ctrl+H (IME�̊�{�������ׂĂŌ����悤�ɋ���)
^h::send {BackSpace}
; �EWin�s�g�p
;RWin::return

;-----------------------------
; Vi Like With ���ϊ�(vk1Csc079)(JIS�L�[�{�[�h�p)
;-----------------------------
vk1Csc079 & h::Send,{Blind}{Left}
vk1Csc079 & j::Send,{Blind}{Down}
vk1Csc079 & k::Send,{Blind}{Up}
vk1Csc079 & l::Send,{Blind}{Right}
vk1Csc079 & x::Send,{Blind}{Del}
vk1Csc079 & a::Send,{Blind}{Home}
vk1Csc079 & 4::Send,{Blind}{End}
vk1Csc079 & b::Send,{Blind}{PgUp}
vk1Csc079 & f::Send,{Blind}{PgDn}
; Undo
vk1Csc079 & u::Send ^z
; ESC�L�[�p from Vi����
;vk1Csc079 & ^[::Send {ESC}
; Paste
vk1Csc079 & p::Send ^v

;-----------------------------
; Vi Like With RightWindowsKey(vkFFsc079)
;
;   (US�L�[�{�[�h�p)
;   �� �v���W�X�g���ŁARightWidnowsKey���ϊ��L�[
;      RWin + L�� Windows�Ƀ��b�N��������V���[�g�J�b�g�ƃ_�u���Ă���׉��
;-----------------------------
vkFFsc079 & h::Send,{Blind}{Left}
vkFFsc079 & j::Send,{Blind}{Down}
vkFFsc079 & k::Send,{Blind}{Up}
vkFFsc079 & l::Send,{Blind}{Right}
vkFFsc079 & x::Send,{Blind}{Del}
vkFFsc079 & ^::Send,{Blind}{Home}
vkFFsc079 & 4::Send,{Blind}{End}
vkFFsc079 & b::Send,{Blind}{PgUp}
vkFFsc079 & f::Send,{Blind}{PgDn}
; Undo
vkFFsc079 & u::Send ^z
; ESC�L�[�p from Vi����
;vkFFsc079 & ^[::Send {ESC}
^[::Send {ESC}
; Paste
vkFFsc079 & p::Send ^v
; Vim Paste(Insert���p)
;Numpad0::Send ^v

;-----------------------------
;Logitech Wireless Solar Keyboard K760
;-----------------------------
;vkACsc132::Send,{F5}
;vk91sc046::Send,{F6}
;vk13sc045::Send,{F7}
;vkB3sc122::Send,{F9}
;vkADsc120::Send {Volume_Mute}
;vkAEsc12E::
 Send {Volume_Down 5}
 SoundBeep
 return
;vkAFsc130::
 Send {Volume_Up 5}
 SoundBeep
 return

;-----------------------------
; ELECOM TK-FBM036
;   (US�L�[�{�[�h�p)
;-----------------------------
;vkACsc132::Send,{F1}
;vkAAsc165::Send,{F2}
;vkAAsc165::Send,{F3}
;vkB1sc110::Send,{F4}
;vkB3sc122::Send,{F5}
;vkB0sc119::Send,{F6}
;vkADsc120::Send,{F7}
;vkAEsc12E::Send,{F8}
;vkAFsc130::Send,{F9}
;vkAFsc130::Send,{F10}


;-----------------------------
; Windows + Mac Command Key
;  (Windows��Mac�̃L�[�o�C���h�݊��p)
;-----------------------------
; Undo
LWIN & z::Send ^z
; Cut
LWIN & x::Send ^x
; Copy
LWIN & c::Send ^c
; Paste
LWIN & v::Send ^v 
; Close
LWIN & w::Send ^w
; Save
LWIN & s::Send ^s
LWIN & y::Send ^y
; TabNew
LWIN & t::Send ^t
; CloseTask(Windows��Alt+F4)
LWin & q::WinClose,A
LWin & h::WinMinimize,A

;-----------------------------
; IME Switcher
;-----------------------------
; LeftWindows+` ... US�L�[�{�[�h�p�؂�ւ�
LWIN & vkC0sc029::Send {vk19}
; LeftWindows+Space ... Mac�݊�IME�؂�ւ�
LWIN & space::Send {vk19}

;��Ctrl+Shift+j��Ctrl+Shift+: ��Mac�W��IME�؂�ւ��݊��p
^+j::
If IME_IsON(WinExist("A")) == 0{
Send {vk19}
}else{
}
return
; Ctrl + : (US:027,JIS:028)
^+vkBAsc027::
If IME_IsON(WinExist("A")) == 1{
Send {vk19}
}else{
}
return
;-----------------------------
; Alt + Tab Task Switch
;-----------------------------
;Windows - vkFFsc079 - LWin
;Windows - vk5Csc15C - RWin
;LWin & Tab::Send,{Blind}{Alt}{vk09sc00F}
;LWin & Tab::AltTab
;LWin & +Tab::ShiftAltTab

;-----------------------------
; AppKey(US�L�[�p)
;-----------------------------
RAlt::AppsKey

;-----------------------------
; Memo,Test,etc 
;-----------------------------
;eisu - vkf0sc03A
;vkf0sc03A::Send vk19

;-----------------------------
; Firefox Tab�ŊJ��
;-----------------------------
LWin & LButton::Send,{Ctrl}{LButton}


;-----------------------------
; PrintScreen(Mac��PrintScreen)(Mac�L�[�{�[�h�p)
; LWin+Shift+3 = PrintScreen
; LWin+Shift+4 = Alt+PrintScreen
;-----------------------------
LWin & +3::Send,{PrintScreen}
LWin & +4::Send,!{PrintScreen}


;=============================
; Functions
;=============================
IME_IsON(hWindow)
{
	; WM_IME_CONTROL    = 0x0283
	; IMC_GETOPENSTATUS = 0x0005
	bufCurrentDetectMode := A_DetectHiddenWindows
	DetectHiddenWindows, On
	buf := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint",hWindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
	DetectHiddenWindows, %bufCurrentDetectMode%
	Return buf
}

}
