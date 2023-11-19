g_DoubleCtrl := 0
; This detects "double-clicks" of the ctrl key.
~Ctrl::
{
	global g_DoubleCtrl := (A_PriorHotkey = "~Ctrl" and A_TimeSincePriorHotkey < 400)
	Sleep 0
	KeyWait "Ctrl"  ; This prevents the keyboard's auto-repeat feature from interfering.
}
#HotIf g_DoubleCtrl

^+LButton::+#Left
^+RButton::+#Right
^LButton:: {
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
	if WinGetMinMax(KDE_id)
		return
	; Get the initial window position.
	WinGetPos &KDE_WinX1, &KDE_WinY1, , , KDE_id
	Loop
	{
		if !GetKeyState("LButton", "P") ; Break if button has been released.
			break
		MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
		KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
		WinMove KDE_WinX2, KDE_WinY2, , , KDE_id ; Move the window to the new position.
	}
}
^RButton:: {
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
	if WinGetMinMax(KDE_id)
		return
	; Get the initial window position and size.
	WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
		KDE_WinLeft := 1
	else
		KDE_WinLeft := -1
	if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
		KDE_WinUp := 1
	else
		KDE_WinUp := -1
	Loop
	{
		if !GetKeyState("RButton", "P") ; Break if button has been released.
			break
		MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
		; Get the current window position and size.
		WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		; Then, act according to the defined region.
		WinMove KDE_WinX1 + (KDE_WinLeft + 1) / 2 * KDE_X2  ; X of resized window
			, KDE_WinY1 + (KDE_WinUp + 1) / 2 * KDE_Y2  ; Y of resized window
			, KDE_WinW - KDE_WinLeft * KDE_X2  ; W of resized window
			, KDE_WinH - KDE_WinUp * KDE_Y2  ; H of resized window
			, KDE_id
		KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
		KDE_Y1 := (KDE_Y2 + KDE_Y1)
	}
}
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

!+m::1
!+,::2
!+.::3
!+j::4
!+k::5
!+l::6
!+u::7
!+i::8
!+o::9
!+7::/
!+8::/
!+9::*
!+0::-
!+Space::0
!+RAlt::.
!+BackSpace::BackSpace
!+Enter::Enter
#HotIf
g_DoubleShift := 0
; This detects "double-clicks" of the ctrl key.
~Shift::
{
	global g_DoubleShift := (A_PriorHotkey = "~Shift" and A_TimeSincePriorHotkey < 400)
	Sleep 0
	KeyWait "Shift"  ; This prevents the keyboard's auto-repeat feature from interfering.
}
#HotIf g_DoubleShift

~+z::
{
	global zKey := (A_PriorHotkey = "~+z" and A_TimeSincePriorHotkey < 400)
	if zKey {
		Sleep 0
		KeyWait "Alt"  ; This prevents the keyboard's auto-repeat feature from interfering.
		Send "!{f4}"
	}
}
~+q::
{
	global qKey := (A_PriorHotkey = "~+q" and A_TimeSincePriorHotkey < 400)
	if qKey {
		Sleep 0
		Send "!{f4}"
	}
}
^+LButton::+#Left
^+RButton::+#Right

+m::1
+,::2
+.::3
+j::4
+k::5
+l::6
+u::7
+i::8
+o::9
+7::/
+8::/
+0::/
+9::*
+Space::0
+RAlt::.
+BackSpace::BackSpace
+Enter::Enter

; +h::Left
; +j::Down
; +k::Up
; +l::Right
+LButton:: {
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
	if WinGetMinMax(KDE_id)
		return
	; Get the initial window position.
	WinGetPos &KDE_WinX1, &KDE_WinY1, , , KDE_id
	Loop
	{
		if !GetKeyState("LButton", "P") ; Break if button has been released.
			break
		MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
		KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
		WinMove KDE_WinX2, KDE_WinY2, , , KDE_id ; Move the window to the new position.
	}
}
+RButton:: {
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
	if WinGetMinMax(KDE_id)
		return
	; Get the initial window position and size.
	WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
		KDE_WinLeft := 1
	else
		KDE_WinLeft := -1
	if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
		KDE_WinUp := 1
	else
		KDE_WinUp := -1
	Loop
	{
		if !GetKeyState("RButton", "P") ; Break if button has been released.
			break
		MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
		; Get the current window position and size.
		WinGetPos &KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, KDE_id
		KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
		KDE_Y2 -= KDE_Y1
		; Then, act according to the defined region.
		WinMove KDE_WinX1 + (KDE_WinLeft + 1) / 2 * KDE_X2  ; X of resized window
			, KDE_WinY1 + (KDE_WinUp + 1) / 2 * KDE_Y2  ; Y of resized window
			, KDE_WinW - KDE_WinLeft * KDE_X2  ; W of resized window
			, KDE_WinH - KDE_WinUp * KDE_Y2  ; H of resized window
			, KDE_id
		KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
		KDE_Y1 := (KDE_Y2 + KDE_Y1)
	}
}
+#LButton::+#Left
+#RButton::+#Right

!+m::1
!+,::2
!+.::3
!+j::4
!+k::5
!+l::6
!+u::7
!+i::8
!+o::9
!+7::/
!+8::/
!+9::*
!+0::-
!+Space::0
!+RAlt::.
!+BackSpace::BackSpace
!+Enter::Enter
#HotIf