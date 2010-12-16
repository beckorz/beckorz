#UseHook on

; vi like
vk1Csc079 & h::Send {Blind}{Left}
vk1Csc079 & j::Send {Blind}{Down}
vk1Csc079 & k::Send {Blind}{Up}
vk1Csc079 & l::Send {Blind}{Right}
vk1Csc079 & x::Send {Blind}{Del}
vk1Csc079 & a::Send {Blind}{Home}
vk1Csc079 & 4::Send {Blind}{End}
vk1Csc079 & b::Send {Blind}{PgUp}
vk1Csc079 & f::Send {Blind}{PgDn}
vk1Csc079 & u::Send ^z
vk1Csc079 & ^[::Send {ESC}
vk1Csc079 & p::Send ^v
^h::send {BackSpace}

; Modify DosKey
$^n::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {Down}
}
else
{
Send,^n
}
return

$^p::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {Up}
}
else
{
Send,^p
}
return

$^b::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {Left}
}
else
{
Send,^b
}
return

$^f::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {Right}
}
else
{
Send,^f
}
return

$^a::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {Home}
}
else
{
Send,^a
}
return

$^e::
IfWinActive,ahk_class ConsoleWindowClass
{
Send, {End}
}
else
{
Send,^e
}
return

