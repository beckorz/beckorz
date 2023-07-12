;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
; AutoHotkey Configuration
;  設定内容
;  - Macintosh
;  - Vi Like
;  - USキーボード(101配列)
;  - JPキーボード(106配列)
;
; NOTE: Fnキー活用してFn+Backspace→Deleteや、CapsLockキー活用はAutoHotkeyでは無理
;       Apple Wireless Keyboard Helper for Windows?? KeySwap??
;
; @see: http://sites.google.com/site/autohotkeyjp
;
; @param: {string} キーボード種類を指定(キーボード種類名の最後にjpかusを付与すること)
;                  e.g.) surfaceus      ... Microsoft Surface の USキーボード
;                  e.g.) k760us         ... Logicool k760 USキーボード
;                  e.g.) thinkpadx280jp ... Thinkpad X280 JP キーボード
;
;_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#UseHook on
; Keyの遅延速度
SetKeyDelay, -1

;-----------------------------
; 定数(定数値は小文字で統一)
;-----------------------------

; 汎用キーボード
keyboardJP := "jp"                   ; JPキーボード(一般的な106キーボード)
keyboardUS := "us"                   ; USキーボード(101キーボード等で、変換キー等無い物)

isKeyboardJP = false
isKeyboardUS = false

; キーボード個別種別名(種類が増えてきたらここに列挙すること)
keyboardSurfaceUS := "surfaceus"     ; Surface USキーボード
keyboardK760US := "k760us"           ; Logicool(Logitech K760) USキーボード
keyboardX280US := "thinkpadx280jp"   ; Thinkpad X280(JPキーボード)

currentKeyboard := "jp"

; 引数でキーボード指定された場合
ArgCount=%0%
if (ArgCount == 1) {
    ; キーボード指定
    currentKeyboard = %1%
    StringLower, currentKeyboard, currentKeyboard

    ; 汎用キーボード名があれば取得
    isKeyboardJP := (RegexMatch(currentKeyboard, "jp$", _) > 0)
    isKeyboardUS := (RegexMatch(currentKeyboard, "us$", _) > 0)
}
MsgBox, CurrentKeyboard: %currentKeyboard%

;-----------------------------
; 関数
;-----------------------------

; 引数対応のリロード関数(通常のReloadは引数に非対応な為)
ReloadWithArgs() { ;retains the exact arg structure except for ensuring /r is present
    RegexMatch(DllCall("GetCommandLineW", "Str") ;parse out path to autohotkey.exe and "/r" if already present
        , "^([^\s""]+|""[^""]+?"")(\s+/[rR])?\s+(?<args>.*)$", _)
    Run "%A_AhkPath%" /r %_args%
}

; IMEがONになっているか
IME_IsON(hWindow) {
    ; WM_IME_CONTROL    = 0x0283
    ; IMC_GETOPENSTATUS = 0x0005
    bufCurrentDetectMode := A_DetectHiddenWindows
    DetectHiddenWindows, On
    buf := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", hWindow), "UInt", 0x0283, "Int", 0x0005, "Int", 0)
    DetectHiddenWindows, %bufCurrentDetectMode%
    Return buf
}

; IMEをONにする
IME_ON(hWindow, IsON) {
    ; WM_IME_CONTROL    = 0x0283
    ; IMC_SETOPENSTATUS = 0x0006
    bufCurrentDetectMode := A_DetectHiddenWindows
    DetectHiddenWindows, On
    buf := DllCall("user32.dll\SendMessageA", "UInt", DllCall("imm32.dll\ImmGetDefaultIMEWnd", "Uint", hWindow), "UInt", 0x0283, "Int", 0x0006, "Int", IsON)
    DetectHiddenWindows, %bufCurrentDetectMode%
    Return buf
}


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
; Vi Like With 変換/無変換(vk1Csc079)(JPキーボード用)
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
;   K760us
;   (USキーボード用)
;   ※ 要レジストリで、RightWidnowsKey→変換キー(vkFFsc079)
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
LWIN & s::
    if (GetKeyState("shift", "P")) {
        ; Win+Shift+s > Native windows screen shot
        Send #+s
    } else {
        ; Save
        Send ^s
    }
    return

LWIN & y::Send ^y
; TabNew
LWIN & t::Send ^t
; CloseTask(WindowsのAlt+F4)
LWin & q::WinClose,A

LWin & h::
    ; 仮想デスクトップ移動 ←
    if GetKeyState("vk1C", "P") && GetKeyState("LWin", "P") && GetKeyState("LCtrl", "P") {
        SendEvent {LWin down}{LCtrl down}{Left down}{LWin up}{LCtrl up}{Left up}
    } else if GetKeyState("LWin", "P") && GetKeyState("LCtrl", "P") {
        SendEvent {LWin down}{LCtrl down}{Left down}{LWin up}{LCtrl up}{Left up}
    } else if GetKeyState("LWin", "P") {
        ; Minimize Window
        WinMinimize,A
    }
    return
LWin & l::
    ; 仮想デスクトップ移動 →
    if GetKeyState("vk1C", "P") && GetKeyState("LWin", "P") && GetKeyState("LCtrl", "P") {
        SendEvent {LWin down}{LCtrl down}{Right down}{LWin up}{LCtrl up}{Right up}
    } else if GetKeyState("LWin", "P") && GetKeyState("LCtrl", "P") {
        SendEvent {LWin down}{LCtrl down}{Right down}{LWin up}{LCtrl up}{Right up}
    }
    return

;-----------------------------
; IME Switcher
;-----------------------------
; LeftWindows+` ... USキーボード用切り替え
LWIN & vkC0::
    if (isKeyboardUS) {
        MsgBox, hoge
        Send {vk19}
    }
    return
; LeftWindows+Space ... Mac互換IME切り替え
LWIN & space::Send {vk19}

;-----------------------------
;■Ctrl+Shift+jとCtrl+Shift+: のMac標準IME切り替え互換用
;-----------------------------
^+j::
    if (IME_IsON(WinExist("A")) == 0) {
        Send, {vk19}
    }
    return
; Ctrl + : (US:027,JP:028)
;^+vkBA::
^+;::
    if (IME_IsON(WinExist("A")) == 1) {
        Send, {vk19}
    }
    return

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
;-----------------------------
; RDP Active window screenshot
;  Ctrl+Alt+-
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

;-----------------------------
; Windows TerminalでCtrl+P, Ctrl+Nの履歴表示
;-----------------------------
#IfWinActive,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
^P::Send, {Up}
^N::Send, {Down}
#IfWinActive

;-----------------------------
; 変換キーの2連打でAutoHotkeyの設定をReload
;-----------------------------
vk1C::
    if (isKeyboardJP) {
        If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200) {
            ; Reload
            ReloadWithArgs()
            MsgBox "Reloaded"
        }

        ;-----------------------------
        ; 上の変換キー連打設定リロード機能を入れるとIME Onの時だけ、カーソル移動しようとして、Ctrl+変換を押すとコントロールメニューが出てしまうのを無効化
        ;-----------------------------
        LCTRL & vk1C::Return
    }
    Return

vkFF::
    if (currentKeyboard == keyboardK760US) {
        ; K760US向け
        If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200) {
            ; Reload
            ReloadWithArgs()
            MsgBox "Reloaded"
        }
    }
    Return

;-----------------------------
; AppsKey(AppsKey無し用)
;-----------------------------
RAlt::
    if (currentKeyboard == keyboardSurfaceUS) {
        ; SurfaceUS向け
        ; Surface USはキー数が足りなくAltを潰してしまうと、Vimキーバインドが出来ないので除外
        ; 設定リロード
        ; TODO: 動作確認
        If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 200) {
            ; Reload
            ReloadWithArgs()
            MsgBox "Reloaded"
        }
    } else {
        Send, {AppsKey}
    }
    Return
