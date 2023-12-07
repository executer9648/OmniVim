g_DoubleCtrl := 0
g_ctrl_count := 0
g_ctrl_count2 := 0
g_ctrl_count3 := 0
; This detects "double-clicks" of the ctrl key.
~Ctrl::
{
	global g_ctrl_count
	global g_ctrl_count2
	global g_ctrl_count3
	global g_DoubleCtrl := (A_PriorHotkey = "~Ctrl" and A_TimeSincePriorHotkey < 400)
	if g_DoubleCtrl {
		g_ctrl_count := g_ctrl_count + 1
	}
	else {
		g_ctrl_count := 0
	}
	if g_ctrl_count == 1 and g_DoubleCtrl {
		g_ctrl_count2 := true
	}
	else {
		g_ctrl_count2 := false
	}
	if g_ctrl_count == 2 and g_DoubleCtrl {
		g_ctrl_count3 := true
	}
	else {
		g_ctrl_count3 := false
	}
	Sleep 0
	KeyWait "Ctrl"  ; This prevents the keyboard's auto-repeat feature from interfering.
	; g_ctrl_count2 := (g_ctrl_count == 2 and g_DoubleCtrl)
	; g_ctrl_count3 := (g_ctrl_count == 3 and g_DoubleCtrl)
}

#HotIf g_ctrl_count3

^h::left
^j::Down
^k::up
^l::Right

^!f::
^+f:: {
	StateBulb[4].Create()
	global counter
	global infcounter
	cvar := "" counter
	cvar .= "F"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	if counter != 0 {
		while counter > 0 {
			ih := InputHook("C")
			ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
			ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
			ih.Start()
			ih.Wait()
			check := ih.EndMods
			check .= ih.EndKey
			check2 := ih.EndKey
			if check == "<!``" {
				exitVim()
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Escape" {
				counter := 0
				StateBulb[4].Destroy()
				infcounter.Destroy()
				Exit
			} else if check2 == "Backspace" {
				counter += 2
				trimed := SubStr(var, 1, StrLen(var) - 1)
				var := trimed
			} else if check2 == "Space" {
				Continue
			} else {
				var .= ih.EndKey
			}
			infcounter.Destroy()
			infcounter := Infos(var, , true)
			counter -= 1
		}
		counter := 0
	}
	else {
		ih := InputHook("C")
		ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
		ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
		ih.Start()
		ih.Wait()
		var := ih.EndKey
		check := ih.EndMods
		check .= ih.EndKey
		check2 := ih.EndKey
		if check == "<!``" {
			exitVim()
			infcounter.Destroy()
			Exit
		} else if check2 == "Escape" {
			StateBulb[4].Destroy()
			infcounter.Destroy()
			Exit
		}
	}
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^{insert}"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var, false, -1)
	Send "{Home}"
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

^f:: {
	StateBulb[4].Create()
	global normalMode := false
	global counter
	global infcounter
	cvar := "" counter
	cvar .= "f"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	if counter != 0 {
		while counter > 0 {
			ih := InputHook("C")
			ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
			ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
			ih.Start()
			ih.Wait()
			check := ih.EndMods
			check .= ih.EndKey
			check2 := ih.EndKey
			if check == "<!``" {
				exitVim()
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Escape" {
				StateBulb[4].Destroy()
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Backspace" {
				counter += 2
				trimed := SubStr(var, 1, StrLen(var) - 1)
				var := trimed
			} else if check2 == "Space" {
				Continue
			} else {
				var .= ih.EndKey
			}
			infcounter.Destroy()
			infcounter := Infos(var, , true)
			counter -= 1
		}
		counter := 0
	}
	else {
		ih := InputHook("C")
		ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
		ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
		ih.Start()
		ih.Wait()
		var := ih.EndKey
		check := ih.EndMods
		check .= ih.EndKey
		check2 := ih.EndKey
		if check == "<!``" {
			exitVim()
			infcounter.Destroy()
			Exit
		} else if check2 == "Escape" {
			StateBulb[4].Destroy()
			infcounter.Destroy()
			Exit
		}
	}
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Right}"
	Send "+{End}"
	Send "^{insert}"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var)
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

^w:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				if visualMode == true
				{
					Send "^+{Left}"
				}
				else
				{
					Send "^{Left}"
					Send "+{Left}"
				}
			}
			counter := 0
			infcounter.Destroy()
			Exit
		}
		if visualMode == true
		{
			Send "^+{Left}"
			Exit
		}
		else
		{
			Send "^{Left}"
			Send "+{Left}"
			Exit
		}
		Exit
	}
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Right}"
			}
			else
			{
				Send "^{Right}"
				Send "+{Right}"
			}
		}
		counter := 0
		Exit
	}
	if visualMode == true
	{
		Send "^+{Right}"
	}
	else
	{
		Send "^{Right}"
		Send "+{Right}"
		Exit
	}
	Exit
}

^e:: {
	global counter
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Right}"
				Send "+{Left}"
			}
			else
			{
				Send "+{Right}"
				Send "^{Right}"
				Send "{Left 2}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
		Exit
	}
	Send "+{Right}"
	Send "^{Right}"
	Send "{Left 2}"
	Send "+{Right}"
}

^b:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				if visualMode == true
				{
					Send "^+{Right}"
				}
				else
				{
					Send "{Right}"
					Send "^{Right}"
					Send "+{Left}"
				}
			}
			counter := 0
			infcounter.Destroy()
			Exit
		}
		if visualMode == true
		{
			Send "^+{Right}"
		}
		else
		{
			Send "{Right}"
			Send "^{Right}"
			Send "+{Left}"
			Exit
		}
		Exit
	}
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Left}"
			}
			else
			{
				Send "{Left}"
				Send "^{Left}"
				Send "+{Right}"
			}
		}
		counter := 0
		Exit
	}
	if visualMode == true
	{
		Send "^+{Left}"
	}
	else
	{
		Send "{Left}"
		Send "^{Left}"
		Send "+{Right}"
		Exit
	}
	Exit
}
#HotIf

#HotIf g_ctrl_count2

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
^n:: send "{Down}"
^p:: send "{Up}"
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
	if GetKeyState("vkE8")
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

!+7::7
!+8::8
!+9::9
!+u::4
!+i::5
!+o::6
!+j::1
!+k::2
!+l::3
!+,::0
!+m::0
!+n::0
!+$0::/
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

+z::
{
	global zKey := (A_PriorHotkey = "+z" and A_TimeSincePriorHotkey < 400)
	KeyWait "z"  ; This prevents the keyboard's auto-repeat feature from interfering.
	if zKey {
		Sleep 0
		Send "!{f4}"
	}
}
+q::
{
	global qKey := (A_PriorHotkey = "+z" and A_TimeSincePriorHotkey < 400)
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

!+7::7
!+8::8
!+9::9
!+u::4
!+i::5
!+o::6
!+j::1
!+k::2
!+l::3
!+,::0
!+m::0
!+n::0
!+$0::/
!+BackSpace::BackSpace
!+Enter::Enter
#HotIf