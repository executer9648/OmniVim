g_DoubleCtrl := 0
; This detects "double-clicks" of the ctrl key.
~Ctrl::
{
	global g_DoubleCtrl := (A_PriorHotkey = "~Ctrl" and A_TimeSincePriorHotkey < 400)
	Sleep 0
	KeyWait "Ctrl"  ; This prevents the keyboard's auto-repeat feature from interfering.
}
#HotIf g_DoubleCtrl
^Space::vkE8
^h::Backspace
^b::Left
^f::right
^n::Down
^p::up
^a::Home
^e::End
^y::^v
^,::^Home
^g::^Home
^.:: Send "^{End}"
^k::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "+{end}"
		Sleep 10
		Send "{bs}"
	}
}
^x::
{
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^+t"
	else
		Send "^{f4}"
}
^;:: Runner.openRunner()
^m:: saveMark()
^':: openMark()
^r:: insertReg()
^u::
{
	Send "+{Home}"
	Sleep 10
	Send "{bs}"
}
^s::^f
^=::+f10
^d::Delete
^w::
{
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^+{Right}"
		Sleep 10
		Send "{bs}"
		Exit
	}
	Send "^+{Left}"
	Sleep 10
	Send "{bs}"
}
^v::WheelDown
#HotIf
g_DoubleAlt := 0
; This detects "double-clicks" of the ctrl key.
~Alt::
{
	global g_DoubleAlt := (A_PriorHotkey = "~Alt" and A_TimeSincePriorHotkey < 400)
	Sleep 0
	KeyWait "Alt"  ; This prevents the keyboard's auto-repeat feature from interfering.
}
#HotIf g_DoubleAlt
!v::WheelUp
!d:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^+{Left}"
	}
	else {
		Send "^+{Right}"
	}
	Sleep 10
	Send "{Delete}"
}
!b:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^{Right}"
	}
	else {
		Send "^{Left}"
	}
}
!f:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^{Left}"
	}
	else {
		Send "^{Right}"
	}
}
!g::^End
!x::^+t
#HotIf