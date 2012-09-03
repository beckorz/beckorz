;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
; AutoHotkey Configuration
;  設定内容
;  - Macintosh
;  - Vi Like
;  - USキーボード(101配列)
;  - JISキーボード(106配列)
;
; NOTE: Fnキー活用してFn+Backspace→Deleteや、CapsLockキー活用はAutoHotkeyでは無理
;       Apple Wireless Keyboard Helper for Windows?? KeySwap??
;
; see:http://sites.google.com/site/autohotkeyjp
;/
;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#UseHook on
; Keyの遅延速度
SetKeyDelay, -1

;-----------------------------
; Common(共通)
;-----------------------------
;Ctrl+H (IMEの基本だがすべてで効くように強制)
^h::send {BackSpace}
; 右Win不使用
;RWin::return

;-----------------------------
; Vi Like With 無変換(vk1Csc079)(JISキーボード用)
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
; ESCキー用 from Viから
vk1Csc079 & ^[::Send {ESC}
; Paste
vk1Csc079 & p::Send ^v

;-----------------------------
; Vi Like With RightWindowsKey(vkFFsc079)
;   (USキーボード用)
;   ※ 要レジストリで、RightWidnowsKey→変換キー
;-----------------------------
vkFFsc079 & h::Send,{Blind}{Left}
vkFFsc079 & j::Send,{Blind}{Down}
vkFFsc079 & k::Send,{Blind}{Up}
vkFFsc079 & l::Send,{Blind}{Right}
vkFFsc079 & x::Send,{Blind}{Del}
vkFFsc079 & a::Send,{Blind}{Home}
vkFFsc079 & 4::Send,{Blind}{End}
vkFFsc079 & b::Send,{Blind}{PgUp}
vkFFsc079 & f::Send,{Blind}{PgDn}
; Undo
vkFFsc079 & u::Send ^z
; ESCキー用 from Viから
vkFFsc079 & ^[::Send {ESC}
; Paste
vkFFsc079 & p::Send ^v

;-----------------------------
; Windows + Mac Command Key
;  (WindowsでMacのキーバインド互換用)
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
; CloseTask(WindowsのAlt+F4)
LWin & q::WinClose,A
LWin & h::WinMinimize,A

;-----------------------------
; IME Switcher
;-----------------------------
; LeftWindows+` ... USキーボード用切り替え
LWIN & vkC0sc029::Send {vk19}
; LeftWindows+Space ... Mac互換IME切り替え
LWIN & space::Send {vk19}

;■Ctrl+Shift+jとCtrl+Shift+: のMac標準IME切り替え互換用
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
; AppKey(USキー用)
;-----------------------------
RAlt::AppsKey

;-----------------------------
; Memo,Test,etc 
;-----------------------------
;eisu - vkf0sc03A
;vkf0sc03A::Send vk19

;-----------------------------
; Firefox Tabで開く
;-----------------------------
LWin & LButton::Send,{Ctrl}{LButton}

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

IME_ON(hWindow, IsON)
{
	; WM_IME_CONTROL    = 0x0283
	; IMC_SETOPENSTATUS = 0x0006
	bufCurrentDetectMode := A_DetectHiddenWindows
	DetectHiddenWindows, On
	buf := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint",hWindow), "UInt", 0x0283, "Int", 0x0006, "Int", IsON)
	DetectHiddenWindows, %bufCurrentDetectMode%
	Return buf
}
