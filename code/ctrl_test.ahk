g_DoubleCtrl := 0
; This detects "double-clicks" of the ctrl key.
~Ctrl::
{
	global g_DoubleCtrl := (A_PriorHotkey = "~Ctrl" and A_TimeSincePriorHotkey < 400)
	Sleep 0
	KeyWait "Ctrl"  ; This prevents the keyboard's auto-repeat feature from interfering.
}
#HotIf g_DoubleCtrl
^h::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "{Backspace}"
	}
}
^a::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "{Home}"
	}
}
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
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		if GetKeyState("ctrl") or GetKeyState("vkE8")
			Send "^+t"
		else
			Send "^{f4}"
	}
}
^e::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "{End}"
	}
}
^;::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Runner.openRunner()
	}
}
^m::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		saveMark()
	}
}
^'::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		openMark()
	}
}
^r::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		insertReg()
	}
}
^u::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "+{Home}"
		Sleep 10
		Send "{bs}"
	}
}
^s::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "^f"
	}
}
^=::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		Send "+f10"
	}
}
^d::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
	{
		if GetKeyState("ctrl") or GetKeyState("vkE8")
			Send "^{Delete}"
		else
			Send "{Delete}"
	}
}
^w::
{
	global g_DoubleCtrl  ; Declare it since this hotkey function must modify it.
	if g_DoubleCtrl
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
}
#HotIf