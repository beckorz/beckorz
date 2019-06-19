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
; ESCー用 CTRL+[
LCTRL & [::Send, {ESC}
; 右Win不使用 > レジストリで行う事が推奨
;RWin::return

;-----------------------------
; Vi Like With 変換/無変換(vk1Csc079)(JISキーボード用)
;-----------------------------
vk1C & h::Send,{Blind}{Left}
vk1C & j::Send,{Blind}{Down}
vk1C & k::Send,{Blind}{Up}
vk1C & l::Send,{Blind}{Right}
vk1C & x::Send,{Blind}{Del}
vk1C & a::Send,{Blind}{Home}
vk1C & 4::Send,{Blind}{End}
vk1C & b::Send,{Blind}{PgUp}
vk1C & f::Send,{Blind}{PgDn}
; Undo
vk1C & u::Send, ^z
; ESCキー用 from Viから
vk1C & [::Send, {ESC}
; Paste
vk1C & p::Send, ^v

;-----------------------------
; Vi Like With RightWindowsKey(vkFFsc079)
;   (USキーボード用)
;   ※ 要レジストリで、RightWidnowsKey→変換キー
;-----------------------------
vkFF & h::Send,{Blind}{Left}
vkFF & j::Send,{Blind}{Down}
vkFF & k::Send,{Blind}{Up}
vkFF & l::Send,{Blind}{Right}
vkFF & x::Send,{Blind}{Del}
vkFF & a::Send,{Blind}{Home}
vkFF & 4::Send,{Blind}{End}
vkFF & b::Send,{Blind}{PgUp}
vkFF & f::Send,{Blind}{PgDn}
; Undo
vkFF & u::Send ^z
; ESCキー用 from Viから
vkFF & [::Send {ESC}
; Paste
vkFF & p::Send ^v
; Vim Paste(Insert利用)
;Numpad0::Send ^v

;Logitech Wireless Solar Keyboard K760
;vkAC::Send,{F5}
;vk91::Send,{F6}
;vk13::Send,{F7}
;vkB3::Send,{F9}
vkAD::Send {Volume_Mute}
vkAE::
 Send {Volume_Down 5}
 SoundBeep
 return
vkAF::
 Send {Volume_Up 5}
 SoundBeep
 return

;-----------------------------
; Vi Like With RAlt(vkFFsc079)
;   (Surface book USキーボード用)
;    ※ 要registryで、RAlt → 変換キー
;-----------------------------

;-----------------------------
; ELECOM TK-FBM036
;   (USキーボード用)
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
LWIN & vkC0::Send {vk19}
; LeftWindows+Space ... Mac互換IME切り替え
LWIN & space::Send {vk19}

;-----------------------------
;■Ctrl+Shift+jとCtrl+Shift+: のMac標準IME切り替え互換用
;-----------------------------
^+j::
If IME_IsON(WinExist("A")) == 0{
    Send, {vk19}
}
return
; Ctrl + : (US:027,JIS:028)
;^+vkBA::
^+;::
If IME_IsON(WinExist("A")) == 1{
    Send, {vk19}
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
;   TODO: Surfaceの時だめなので、引数等で変更か？
;-----------------------------
RAlt::AppsKey

;-----------------------------
; PrintScreen(Mac風PrintScreen)(Macキーボード用)
; LWin+Shift+3 = PrintScreen
; LWin+Shift+4 = Alt+PrintScreen
;-----------------------------
LWin & 3::
GetKeyState, state, Shift
if state = D
    Send,{PrintScreen}
Return

LWin & 4::
GetKeyState, state, Shift
if state = D
    Send,!{PrintScreen}
Return

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

;-----------------------------
; RDP Active window screenshot
;  (通常テンキーの-キーだが、通常の-キーでもスクリーンショットとれるように)
;-----------------------------
#IfWinActive,ahk_class TscShellContainerClass
^!-::Send, ^!{NumpadSub}
#IfWinActive

;-----------------------------
; コマンドプロンプトでCtrl+P, Ctrl+Nの履歴表示
;-----------------------------
#IfWinActive,ahk_class ConsoleWindowClass
^P::Send, {Up}
^N::Send, {Down}
#IfWinActive

