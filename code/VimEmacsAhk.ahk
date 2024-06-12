#Include StateBulb.ahk
#Include Info.ahk
#Include Mouse.ahk
#Include WindowManager.ahk
#Include Runner.ahk
#Include Registers.ahk
#Include mouseMove.ahk
#Include GetInput.ahk
#Include Language.ahk
#Include HoverScreenshot.ahk
#Include EasyWindowDragginKde.ahk
#Include Marks.ahk
#Include MouseMarks.ahk
#Include DoubleCtrlAltShift.ahk
#Include Functions.ahk
#Include myGlobal.ahk
#Include RecordQ.ahk
#Include RecordKeys.ahk
;#Include "C:\Users\Benni\komorebi.ahk"
#SingleInstance force
#MaxThreadsBuffer true
#MaxThreads 250
#MaxThreadsPerHotkey 255
#UseHook
#Requires AutoHotkey v2.0
InstallKeybdHook
A_HotkeyInterval := 0
A_MaxHotkeysPerInterval := 9999
A_MenuMaskKey := "vkFF"
SetMouseDelay -1
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"

Info("Script Reloaded-Active", 2000)
myGlobal.checkDir()


;################ Global Key-Bindings ################

#HotIf WinActive("A")
#!h:: {
	KeyWait "LWin"
	KeyWait "Alt"
	KeyWait "h"
	Send "#{Left}"
}
#!j:: {
	KeyWait "LWin"
	KeyWait "Alt"
	KeyWait "j"
	Send "#{Down}"
}
#!k:: {
	KeyWait "LWin"
	KeyWait "Alt"
	KeyWait "k"
	Send "#{Up}"
}
#!l:: {
	KeyWait "LWin"
	KeyWait "Alt"
	KeyWait "l"
	Send "#{Right}"
}
#HotIf

+#a:: myGlobal.lastPhoto := HoverScreenshot().UseRecentScreenshot().Show()
+^#r:: {
	reloadfunc()
}

#SuspendExempt
+^#s:: {
	if A_IsSuspended {
		Info("Script Resumed", 2000)
	}
	else {
		Info("Script Suspended", 2000)
	}
	Suspend
}
#SuspendExempt False

; *CapsLock::LCtrl

+#LButton::+#Left
+#RButton::+#Right

#WheelDown:: Send "#{down}"
#Wheelup:: Send "#{up}"
+#WheelDown:: Send "#{Left}"
+#Wheelup:: Send "#{Right}"

^#h:: Send "^#{Left}"
^#l:: Send "^#{Right}"
;----------------------
+#h:: Send "+#{Left}"
+#j:: Send "+#{Down}"
+#k:: Send "+#{Up}"
+#l:: Send "+#{Right}"

; `(tilda) SECTION =================
^`::CapsLock
`::`
~!`:: return
` & h::Left
` & j::Down
` & k::Up
` & l::Right
` & b::Left
` & p::Up
` & n::Down
` & f::Right
` & y::WheelUp
` & e::WheelDown

; TAB SECTION =================
tab & Space::vkE8
tab::tab
tab & v:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		send "{WheelUp}"
	else
		send "{WheelDown}"
}
tab & `:: {
	if GetKeyState("shift") or GetKeyState("vkE8") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^{insert}"
		ClipWait
		formatstr := A_Clipboard
		if (formatstr == oldclip) {
			exit
		}
		if RegExMatch(formatstr, "^[A-Z\s\p{P}]+$") {
			string1 := StrLower(formatstr)
			SendText string1
		}
		else if RegExMatch(formatstr, "^[a-z\s\p{P}]+$") {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		else {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		A_Clipboard := oldclip
	}
	else
		exitVim()
}
tab & ':: {
	if GetKeyState("ctrl") or GetKeyState("vkE8") or GetKeyState("shift")
		saveReg()
	else
		openMark()
}
tab & `;:: {
	Runner.openRunner()
}
tab & m:: {
	if GetKeyState("shift") or GetKeyState("Ctrl")
		openMouseMark()
	else
		saveMark()
}
tab & y::+insert
tab & ,:: {
	Send "^{Home}"
}
tab & .:: {
	Send "^{End}"
}
Tab & b:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^{Left}"
	else
		Send "{Left}"
}
Tab & h::BackSpace
Tab & k:: {
	Send "+{end}"
	Sleep 10
	Send "{bs}"
}
Tab & n::Down
Tab & p::Up
Tab & f:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^{Right}"
	else
		Send "{Right}"
}
Tab & a::Home
Tab & g:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^{End}"
	else
		Send "^{Home}"
}
Tab & x:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^+t"
	else
		Send "^{f4}"
}
Tab & r:: {
	insertReg()
}
Tab & s::^f
Tab & =::+f10
Tab & d:: {
	if GetKeyState("ctrl") or GetKeyState("vkE8")
		Send "^{Delete}"
	else
		Send "{Delete}"
}
Tab & w:: {
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
Tab & u:: {
	Send "+{Home}"
	Sleep 10
	Send "{bs}"
}
tab & e::End
;===========================================

^!n:: {
	gotoNumLockMode()
}

; Set initial state to normal (disabled)
global counter := 0
global hide := false
global monitorCount := 0
global p_key := 0
global visual_y := 0
global normalMode := false
global dMode := false
global gMode := false
global yMode := false
global fMode := false
global qMode := false
global recordMode := false
global shiftfMode := false
global altfMode := false
global cMode := false
global numlockMode := false
global visualMode := false
global visualLineMode := false
global insertMode := false
global windowMode := false
global fancywmMode := false
global gkomorebi := false
global WindowManagerMode := false
global mouseManagerMode := false
global wasInNormalMode := false
global WasInMouseManagerMode := false
global WasInRegMode := false
global WasInWindowManagerMode := false
global wasInInsertMode := false
global wasinCmdMode := false
global infcounter := Infos("")
infcounter.Destroy()

; Define the hotkey to enable the keybindings
tab & [::
^[:: {
	gotoNormal()
	Exit
}

tab & ]::
^]:: {
	gotoNormal()
	gotoMouseMode()
	setMouseDefSpeed()
}

+#w:: {
	global fancywmMode := true
	StateBulb[StateBulb.MaxBulbs - 1].Create()
}
^#w:: {
	global gkomorebi := true
	StateBulb[StateBulb.MaxBulbs - 1].Create()
}

#HotIf Marks.recording = 1
HotIf "Marks.recording = 1"
~LButton:: {
	Marks.saveSessionByMouse(Marks._session)
}
!`::
tab & `::
Esc:: {
	Marks.stopRecording(Marks._session)
}
#HotIf
; Numlock Mode - replaces the keyboard to numlock
#HotIf numlockMode = 1
HotIf "numlockMode = 1"

Esc:: {
	if wasInInsertMode {
		gotoInsert()
	}
	else if wasInNormalMode {
		gotoNormal()
	}
	else if WasInMouseManagerMode {
		gotoMouseMode()
	}
	StateBulb[4].Destroy() ; Special
	global numlockMode := false
}

^!n:: {
	if wasInInsertMode {
		gotoInsert()
	}
	else if wasInNormalMode {
		gotoNormal()
	}
	else if WasInMouseManagerMode {
		gotoNormal()
		gotoMouseMode()
	}
	StateBulb[4].Destroy() ; Special
	global numlockMode := false
}
!`:: {
	exitVim()
	Exit
}

u::4
i::5
o::6
j::1
k::2
l::3
,::0
m::0
n::0
$0::/
#HotIf

; F mode - for mouse positioning according to keyboard layout
#HotIf fMode = 1
HotIf "fMode = 1"

if MonitorGetPrimary() != 1 {
	secondM := -A_ScreenWidth
}
else {
	secondM := A_ScreenWidth
}

`:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 1, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 1, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x1, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x1, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	Exit
}
1:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x2, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 2, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 2, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x2, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x2, Mouse.tildaCol)
		gotoMouseMode()
	}
	Exit
}
2:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x3, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 3, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 3, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x3, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x3, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
3:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 4, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 4, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x4, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x4, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
4:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x5, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 5, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 5, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x5, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x5, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
5:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x6, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 6, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 6, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x6, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x6, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
6:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x7, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 7, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 7, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x7, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x7, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
7:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x8, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 8, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 8, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x8, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x8, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
8:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x9, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 9, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 9, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x9, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x9, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
9:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x10, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 10, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 10, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x10, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x10, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
0:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x11, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 11, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 11, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x11, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x11, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
-:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x12, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 12, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 12, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x12, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x12, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
=:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x13, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 13, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 13, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x13, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x13, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
BackSpace:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x14, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 14, Mouse.numberRow), Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 14, Mouse.numberRow), Mouse.tildaCol)
			Exit
		}
		MouseMove(Mouse.x14, Mouse.tildaCol)
	}
	else {
		MouseMove(Mouse.x14, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}

tab:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 1, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 1, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x1, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x1, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
q:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x2, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 2, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 2, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x2, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x2, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
w:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x3, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 3, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 3, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x3, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x3, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
e:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 4, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 4, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x4, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x4, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
r:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 5, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 5, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x5, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x5, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
t:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 6, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 6, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x6, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x6, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
y:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 7, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 7, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x7, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x7, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
u:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 8, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 8, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x8, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x8, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
i:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 9, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 9, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x9, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x9, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
o:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 10, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 10, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x10, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x10, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
p:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 11, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 11, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x11, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x11, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
[:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 12, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 12, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x12, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x12, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
]:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 13, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 13, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x13, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x13, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
\:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 14, Mouse.numberRow), Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 14, Mouse.numberRow), Mouse.tabCol)
			Exit
		}
		MouseMove(Mouse.x14, Mouse.tabCol)
	}
	else {
		MouseMove(Mouse.x14, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
LControl:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 1, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 1, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax1, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax1, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
a:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 2, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 2, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax2, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax2, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
s:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 3, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 3, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax3, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax3, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
d:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 4, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 4, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax4, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax4, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
f:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 5, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 5, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax5, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax5, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
g:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 6, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 6, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax6, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax6, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
h:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 7, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 7, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax7, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax7, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
j:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 8, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 8, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax8, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax8, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
k:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 9, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 9, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax9, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax9, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
l:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 10, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 10, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax10, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax10, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
`;:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 11, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 11, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax11, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax11, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
':: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 12, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 12, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax12, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax12, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
Enter:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 13, Mouse.aRow), Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 13, Mouse.aRow), Mouse.capsCol)
			Exit
		}
		MouseMove(Mouse.ax13, Mouse.capsCol)
	}
	else {
		MouseMove(Mouse.ax13, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}

LShift:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 1, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 1, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx1, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx1, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
z:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 2, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 2, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx2, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx2, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
x:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 3, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 3, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx3, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx3, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
c:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 4, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 4, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx4, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx4, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
v:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 5, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 5, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx5, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx5, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
b:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 6, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 6, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx6, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx6, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
n:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 7, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 7, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx7, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx7, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
m:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 8, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 8, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx8, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx8, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
,:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 9, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 9, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx9, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx9, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
.:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 10, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 10, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx10, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx10, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
/:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 11, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 11, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx11, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx11, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
RShift:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 12, Mouse.zRow), Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 12, Mouse.zRow), Mouse.shiftCol)
			Exit
		}
		MouseMove(Mouse.zx12, Mouse.shiftCol)
	}
	else {
		MouseMove(Mouse.zx12, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}

LWin:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 1, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 1, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx1, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx1, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
LAlt:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 2, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 2, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx2, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx2, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Space:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 3, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 3, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx3, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx3, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
RAlt:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 4, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 4, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx4, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx4, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
; fn key
AppsKey:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 5, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 5, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx5, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx5, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Rctrl:: {
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.getx(counter, 6, Mouse.spaceRow), Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else if altfMode {
		if counter != 0 {
			if counter > monitorCount {
				gotoNormal()
				gotoMouseMode()
				infcounter.Destroy()
				Exit
			}
			MouseMove(Mouse.getx(counter, 6, Mouse.spaceRow), Mouse.spaceCol)
			Exit
		}
		MouseMove(Mouse.sx6, Mouse.spaceCol)
	}
	else {
		MouseMove(Mouse.sx6, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}

Alt & f::
Esc:: {
	global counter
	global infcounter
	infcounter.Destroy()
	gotoNormal()
	gotoMouseMode()
}

!`:: {
	exitVim()
	Exit
}

#HotIf


; Window Mode - this is after pressing ctrl+w should implement the vim version
#HotIf windowMode = 1
HotIf "windowMode = 1"

*-:: Return
*`;:: Return
*=:: Return
*,:: Return
*.:: Return
*/:: Return
*':: Return
[:: Return
]:: Return
*\:: Return
*a:: Return
*b:: Return
*c:: Return
*d:: Return
*e:: Return
*f:: Return
*g:: Return
*h:: Return
*i:: Return
*j:: Return
*k:: Return
*l:: Return
*m:: Return
*n:: Return
*o:: Return
*p:: Return
*r:: Return
*s:: Return
*u:: Return
*v:: Return
*x:: Return
*y:: Return
*z:: Return
0:: {
	chCounter(0)
}
1:: {
	chCounter(1)
}
2:: {
	chCounter(2)
}
3:: {
	chCounter(3)
}
4:: {
	chCounter(4)
}
5:: {
	chCounter(5)
}
6:: {
	chCounter(6)
}
7:: {
	chCounter(7)
}
8:: {
	chCounter(8)
}
9:: {
	chCounter(9)
}

!`:: {
	exitVim()
}
BackSpace:: {
	backspaceCounter()
}

Esc:: {
	global WasInMouseManagerMode
	global wasInNormalMode
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else if (wasInNormalMode == true) {
		gotoNormal()
	}
	else {
		global wasInNormalMode := false
		global WindowManagerMode := false
		StateBulb[4].Destroy() ; Special
		disableClick()
	}
	clearCounter()
}
*q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^{f4}"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
	}
	Send "^{f4}"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}
+q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "!{f4}"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
	}
	Send "!{f4}"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

r:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^r"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^r"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

+r:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+r"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "+^r"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^t"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^t"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

+t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+t"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^+t"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

w:: {
	Send "^!{Tab}"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

#HotIf

; Yank Mode
#HotIf yMode = 1
HotIf "yMode = 1"

!`:: {
	exitVim()
}

BackSpace:: {
	backspaceCounter()
}
Esc:: {
	gotoNormal()
	clearCounter()
}

*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*i:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return
*-:: Return
*`;:: Return
*=:: Return
*,:: Return
*.:: Return
*/:: Return
*':: Return
[:: Return
]:: Return
*\:: Return

1:: {
	chCounter(1, "y")
}
2:: {
	chCounter(2, "y")
}
3:: {
	chCounter(3, "y")
}
4:: {
	chCounter(4, "y")
}
5:: {
	chCounter(5, "y")
}
6:: {
	chCounter(6, "y")
}
7:: {
	chCounter(7, "y")
}
8:: {
	chCounter(8, "y")
}
9:: {
	chCounter(9, "y")
}

f:: {
	clearCounter()
	global yMode := false
	delChanYanfMotion()
	Send "^{Insert}"
	Send "{Left}"
	Send "+{Right}"
	gotoNormal()
	Exit
}

t:: {
	clearCounter()
	global yMode := false
	delChanYantMotion()
	Send "^{Insert}"
	Send "{Left}"
	Send "+{Right}"
	gotoNormal()
	Exit
}

+f:: {
	clearCounter()
	global yMode := false
	capdelChanYanFmotion()
	Send "^{Insert}"
	Send "{Left}"
	Send "+{Right}"
	gotoNormal()
	Exit
}

+t:: {
	clearCounter()
	global yMode := false
	capdelChanYanTMotion()
	Send "^{Insert}"
	Send "{Left}"
	Send "+{Right}"
	gotoNormal()
	Exit
}

i:: {
	clearCounter
	innerword()
	Send "^{insert}"
	Send "{Left}"
	gotoNormal()
}

y:: {
	A_Clipboard := ""
	Send "+{Home}"
	Send "^{insert}"
	ClipWait 1
	var1 := A_Clipboard
	A_Clipboard := ""
	Send "{Right}"
	Send "+{End}"
	Send "^{insert}"
	ClipWait 1
	var2 := A_Clipboard
	Send "{Left}"
	Send "+{Right}"
	A_Clipboard := var1 var2
	gotoNormal()
}

b:: {
	bmotion()
	Send "^{insert}"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	gotoNormal()
}

w:: {
	wmotion()
	Send "^{insert}"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{Left}"
		Send "+{right}"
	}
	gotoNormal()
}

0::
{
	global counter
	if counter != 0 {
		chCounter(0, "y")
	}
	else {
		Send "+{home}"
		Send "^{insert}"
		gotoNormal()
	}
}

+4::
{
	Send "+{End}"
	Send "^{insert}"
	gotoNormal()
}
#HotIf

; Change Mode
#HotIf cMode = 1
HotIf "cMode = 1"
BackSpace:: {
	backspaceCounter
}
Esc:: {
	gotoNormal()
	clearCounter()
}

!`:: {
	exitVim()
}

-:: Return
`;:: Return
=:: Return
,:: Return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return
*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*i:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return

1:: {
	chCounter(1, "c")
}
2:: {
	chCounter(2, "c")
}
3:: {
	chCounter(3, "c")
}
4:: {
	chCounter(4, "c")
}
5:: {
	chCounter(5, "c")
}
6:: {
	chCounter(6, "c")
}
7:: {
	chCounter(7, "c")
}
8:: {
	chCounter(8, "c")
}
9:: {
	chCounter(9, "c")
}

f:: {
	global cMode := false
	delChanYanfMotion()
	Send "^x"
	gotoInsert()
	clearCounter()
}
t:: {
	global cMode := false
	delChanYantMotion()
	Send "^x"
	gotoInsert()
	clearCounter()
}
+f:: {
	global cMode := false
	capdelChanYanFmotion()
	Send "^x"
	gotoInsert()
	clearCounter()
}
+t:: {
	global cMode := false
	capdelChanYanTMotion()
	Send "^x"
	gotoInsert()
	clearCounter()
}

i:: {
	innerword()
	Send "^x"
	gotoInsert()
	clearCounter()
}

c:: {
	findEndLine()
	Send "^x"
	gotoInsert()
	clearCounter()
}

b:: {
	bmotion()
	Send "^x"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	gotoInsert()
}

w:: {
	wmotion()
	Send "^x"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{Left}"
		Send "+{right}"
	}
	gotoInsert()
}

0::
{
	global counter
	if counter != 0 {
		chCounter(0, "c")
	}
	else {
		Send "+{home}"
		Send "^x"
		gotoInsert()
	}
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoInsert()
}

#HotIf


; G mode - this is after pressing g should be like g in vim
#HotIf gMode = 1
HotIf "gMode = 1"
-:: Return
`;:: Return
=:: Return
,:: Return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return
*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*i:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return
t:: {
	global WasInMouseManagerMode
	if counter != 0 {
		Loop counter {
			Send "^{tab}"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
	}
	if WasInMouseManagerMode == true {
		Send "^{tab}"
		gotoNormal()
		gotoMouseMode()
	}
	else {
		Send "^{tab}"
		gotoNormal()
	}
	clearCounter()
}
+t:: {
	global WasInMouseManagerMode
	if counter != 0 {
		Loop counter {
			Send "^+{tab}"
		}
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
	}
	if WasInMouseManagerMode == true {
		Send "^+{tab}"
		gotoNormal()
		gotoMouseMode()
	}
	else {
		Send "^+{tab}"
		gotoNormal()
	}
	clearCounter()
}
g:: {
	global WasInMouseManagerMode
	if WasInMouseManagerMode == true {
		if visualMode == true {
			Send "+^{Home}"
		} else
			Send "^{Home}"
		gotoNormal()
		gotoMouseMode()
	}
	else {
		if visualMode == true {
			Send "+^{Home}"
		} else
			Send "^{Home}"
		gotoNormal()
	}
	clearCounter()
}

BackSpace:: {
	backspaceCounter()
}
Esc:: {
	global WasInMouseManagerMode
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	clearCounter()
}

!`:: {
	exitVim()
}

0:: {
	chCounter(0)
}
1:: {
	chCounter(1)
}
2:: {
	chCounter(2)
}
3:: {
	chCounter(3)
}
4:: {
	chCounter(4)
}
5:: {
	chCounter(5)
}
6:: {
	chCounter(6)
}
7:: {
	chCounter(7)
}
8:: {
	chCounter(8)
}
9:: {
	chCounter(9)
}
#HotIf

; Delete mode
#HotIf dMode = 1
HotIf "dMode = 1"

-:: Return
=:: Return
,:: Return
`;:: Return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return
*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*i:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return
1:: {
	chCounter(1, "d")
}
2:: {
	chCounter(2, "d")
}
3:: {
	chCounter(3, "d")
}
4:: {
	chCounter(4, "d")
}
5:: {
	chCounter(5, "d")
}
6:: {
	chCounter(6, "d")
}
7:: {
	chCounter(7, "d")
}
8:: {
	chCounter(8, "d")
}
9:: {
	chCounter(9, "d")
}

f:: {
	global dMode := false
	delChanYanfMotion()
	Send "^x"
	gotoNormal()
	clearCounter()
}

t:: {
	global dMode := false
	delChanYantMotion()
	Send "^x"
	gotoNormal()
	clearCounter()
}
+f:: {
	global dMode := false
	capdelChanYanFmotion()
	Send "^x"
	gotoNormal()
	clearCounter()
}

+t:: {
	global dMode := false
	capdelChanYanTMotion()
	Send "^x"
	gotoNormal()
	clearCounter()
}

i:: {
	innerword()
	Send "^x"
	gotoNormal()
	clearCounter()
}

BackSpace:: {
	backspaceCounter()
}
Esc:: {
	gotoNormal()
	clearCounter()
}

!`:: {
	exitVim()
}

d:: {
	t := findEndLine()
	Send "^x"
	if t {
		Send "{delete}"
	}
	gotoNormal()
	clearCounter()
}

b:: {
	bmotion()
	Send "^x"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	gotoNormal()
}

w:: {
	wmotion()
	Send "^x"
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
		Send "+{right}"
	}
	else {
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
	}
	gotoNormal()
}

0::
{
	global counter
	if counter != 0 {
		chCounter(0, "d")
	}
	else {
		Send "+{home}"
		Send "^x"
		gotoNormal()
	}
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoNormal()
}
#HotIf


; Insert Mode
#HotIf insertMode = 1
HotIf "insertMode = 1"

+!`:: {
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "^{insert}"
	ClipWait
	formatstr := A_Clipboard
	if (formatstr == oldclip) {
		exit
	}
	if RegExMatch(formatstr, "^[A-Z\s\p{P}]+$") {
		string1 := StrLower(formatstr)
		SendText string1
	}
	else if RegExMatch(formatstr, "^[a-z\s\p{P}]+$") {
		string1 := StrUpper(formatstr)
		SendText string1
	}
	else {
		string1 := StrUpper(formatstr)
		SendText string1
	}
	A_Clipboard := oldclip
}

!w::^c

^y::^v

^=::+f10

!^,:: {
	Send "^{Home}"
}
!^.:: {
	Send "^{End}"
}

!s:: {
	Send "^f"
}
^s:: {
	Send "^f"
	Send "{Enter}"
}
+^s:: {
	Send "^f"
	Send "+{Enter}"
}
^x:: {
	Send "^{f4}"
}
^+x:: {
	Send "^+t"
}

^!n:: {
	global wasInInsertMode := true
	gotoNumLockMode()
}

^r:: {
	global insertMode := false
	insertReg()
	global insertMode := true
}

!`:: {
	exitVim()
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else if (wasinCmdMode == true) {
		Send "{Esc}"
	}
	else {
		gotoNormal()
	}
}

^u:: {
	Send "+{Home}"
	Sleep 10
	Send "{bs}"
}

^k:: {
	Send "+{end}"
	Sleep 10
	Send "{bs}"
}
^w:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^+{Right}"
		Sleep 10
		Send "{bs}"
	}
	else {
		Send "^+{Left}"
		Sleep 10
		Send "{bs}"
	}
}

^a:: {
	Send "{Home}"
}

^e:: {
	Send "{End}"
}

^b:: {
	Send "{Left}"
}

^n:: {
	Send "{Down}"
}

^h:: {
	Send "{BS}"
}

^d:: {
	Send "{Delete}"
}

^p:: {
	Send "{Up}"
}

^f:: {
	Send "{Right}"
}

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

+!b:: {
	Send "^+{Left}"
}

+!f:: {
	Send "^+{Right}"
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

^v:: {
	Send "{wheeldown}"
}

!v:: {
	Send "{Wheelup}"
}

#HotIf


; Normal Mode
#HotIf normalMode = 1
HotIf "normalMode = 1"

tab & ':: {
	global normalMode := false
	if GetKeyState("ctrl") or GetKeyState("vkE8") or GetKeyState("shift")
		saveReg()
	else
		openMark()
	global mouseManagerMode := true
}

zkeyCount := 0
+z::
{
	global zkeyCount
	global zKey := (A_PriorHotkey = "+z" and A_TimeSincePriorHotkey < 400)
	if zKey {
		zkeyCount := zkeyCount + 1
	}
	else {
		zkeyCount := 0
	}
	if zKey and zkeyCount == 1 {
		Sleep 0
		Send "!{f4}"
	}
}
qkeyCount := 0
+q::
{
	global qkeyCount
	global qKey := (A_PriorHotkey = "~+z" and A_TimeSincePriorHotkey < 400)
	if qKey {
		qkeyCount := qkeyCount + 1
	}
	else {
		qkeyCount := 0
	}
	if qKey and qkeyCount == 1 {
		Sleep 0
		Send "!{f4}"
	}
}
z & q:: {
	if GetKeyState("shift")
		Send "!{f4}"
}
z & u:: {
	Send "{WheelUp}"
	Send "{WheelLeft}"
}
z & o:: {
	Send "{WheelUp}"
	Send "{WheelRight}"
}
z & n:: {
	Send "{WheelLeft}"
	Send "{WheelDown}"
}
z & ,:: {
	Send "{WheelDown}"
	Send "{WheelRight}"
}
z & l:: {
	Send "{WheelRight}"
}
z & j:: {
	Send "{WheelDown}"
}
z & k:: {
	Send "{WheelUp}"
}
z & =:: {
	Send "{Left}"
	Send "+{f10}"
}

!+a:: {
	Send "!+a"
	gotoInsert()
}

BackSpace:: {
	backspaceCounter()
}

-:: Return
`;:: Return
+;:: {
	gotoInsertnoInfo()
	clearCounter()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoNormalnoInfo()
}
`:: Return
+`:: {
	exitVisualMode()
	clearCounter()
	if visualMode == true {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^{insert}"
		ClipWait
		formatstr := A_Clipboard
		if RegExMatch(formatstr, "^[A-Z\s\p{P}!]+$") {
			string1 := StrLower(formatstr)
			SendText string1
		}
		else if RegExMatch(formatstr, "^[a-z\s\p{P}!]+$") {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		else {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		Send "{Left}"
		Send "+{Right}"
		gotoNormal()
		A_Clipboard := oldclip
	}
	else {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^{insert}"
		ClipWait
		formatstr := A_Clipboard
		if RegExMatch(formatstr, "^[A-Z\s\p{P}]+$") {
			string1 := StrLower(formatstr)
			SendText string1
		}
		else if RegExMatch(formatstr, "^[a-z\s\p{P}]+$") {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		else {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		Send "{Left}"
		Send "+{Right}"
		A_Clipboard := oldclip
	}
}
=:: Return
,:: Return
.:: Return
/:: {
	clearCounter()
	Send "^f"
	gotoInsert()
}
':: {
	global normalMode := false
	exitVisualMode()
	clearCounter()
	openMark()
	global normalMode := true
}
+':: {
	global normalMode := false
	saveReg()
	global normalMode := true
	exitVisualMode()
	clearCounter()
}
[:: Return
\:: Return
m:: {
	gotoMwMode()
}
n:: {
	Send "^f"
	Send "{Enter}"
	exitVisualMode()
}
+n:: {
	Send "^f"
	Send "+{Enter}"
	exitVisualMode()
}
^!n:: {
	global wasInNormalMode := true
	gotoNumLockMode()
}
q:: Return
r:: {
	global normalMode := false
	exitVisualMode()
	StateBulb[4].Create()
	secReg := GetInput("L1", "{esc}{Backspace}").Input
	SendText secReg
	StateBulb[4].Destroy()
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
}
s:: {
	Send "{BS}"
	exitVisualMode()
	gotoInsert()
}
z:: Return

1:: {
	chCounter(1)
}
2:: {
	chCounter(2)
}
3:: {
	chCounter(3)
}
4:: {
	chCounter(4)
}
5:: {
	chCounter(5)
}
6:: {
	chCounter(6)
}
7:: {
	chCounter(7)
}
8:: {
	chCounter(8)
}
9:: {
	chCounter(9)
}

t:: {
	clearCounter()
	global normalMode := false
	delChanYantMotion()
	send "{Right}"
	send "{left}"
	send "+{right}"
	global normalMode := true
	Exit
}

+t:: {
	clearCounter()
	global normalMode := false
	capdelChanYanFmotion()
	send "{Right}"
	send "{left}"
	send "+{right}"
	global normalMode := true
	Exit
}

+f:: {
	global normalMode := false
	capdelChanYanFmotion()
	send "{Right}"
	send "{left}"
	send "+{right}"
	global normalMode := true
}

f:: {
	global normalMode := false
	delChanYanfMotion()
	send "{Right}"
	send "{left}"
	send "+{right}"
	global normalMode := true
}


g:: {
	exitVisualMode()
	gotoGMode()
}

+g:: {
	if visualMode == true {
		Send "+^{End}"
	}
	else {
		Send "^{End}"
	}
}

^w:: {
	if visualMode == true {
		Exit
	}
	else {
		wasInNormalMode := true
		gotoWindowMode()
	}
}

#t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "#t"
		}
	}
	else
		Send "#t"
	clearCounter()
	exitVisualMode()
}


!`:: {
	exitVim()
}

+c:: {
	Send "+{End}"
	Send "^x"
	gotoInsert()
}

+d:: {
	Send "+{End}"
	Send "^x"
	exitVisualMode()
}

d::
{
	global counter
	global infcounter
	if visualMode == true {
		Send "^x"
		gotoNormal()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "d"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoDMode()
}

!^y::
{
	Send "^{WheelUp}"
}

!^e::
{
	Send "^{WheelDown}"
}
+^y::
{
	Send "+{WheelUp}"
}
+^e::
{
	Send "+{WheelDown}"
}

^e:: {
	Send "{WheelDown}"
}

^y:: {
	Send "{WheelUp}"
}

Esc:: {
	global infcounter
	global counter
	if visualMode == true
	{
		gotoNormal()
	}
	else
	{
		if counter == 0
			Send "{Esc}"
		clearCounter()
	}
}

v:: {
	global visualMode
	Global visualLineMode
	if visualMode == true {
		gotoNormal()
		Exit
	}
	Global visualMode := true
	global visual_x := 0
	StateBulb[3].Create()
}

+v:: {
	Send "{Home}"
	Send "+{End}"
	Global visualMode := true
	Global visualLineMode := true
	global visual_y := 0
	StateBulb[3].Create()
}

*i:: {
	if visualMode == true
	{
		Send "^{Left}"
		Send "^+{Right}"
	}
	else
	{
		Send "{Left}"
		gotoInsert()
	}
}

$h:: {
	h_motion()
}

$j:: {
	j_motion()
}

$k:: {
	k_motion()
}

$l:: {
	l_motion()
}

Space:: {
	if visualMode == true
	{
		Send "+{Right}"
	}
	else
	{
		Send "{Left}"
		Send "{Right}"
		Send "+{Right}"
	}
}

+a:: {
	Send "{end}"
	gotoInsert()
}

+i:: {
	Send "{home}"
	gotoInsert()
}

+j:: {
	Send "{end}{Delete}"
	exitVisualMode()
}

c:: {
	global counter
	global infcounter
	if visualMode == true {
		Send "^x"
		gotoInsert()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "c"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoCMode()
}

x:: {
	Send "{Delete}"
	Send "+{Right}"
	exitVisualMode()
}
+x:: {
	Send "{bs}"
	Send "{Left}"
	Send "+{Right}"
	exitVisualMode()
}

$e:: {
	emotion()
	if !visualMode {
		Send "{Right}"
		Send "{Left}"
		Send "+{Right}"
	}
	clearCounter()
}

$b:: {
	bmotion()
	if !visualMode {
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			Send "{Right}"
			Send "+{Left}"
		}
		else {
			Send "{Left}"
			Send "+{right}"
		}
	}
	clearCounter()
}

$w:: {
	wmotion()
	if !visualMode {
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			Send "{Left}"
			Send "+{Right}"
		}
		else {
			Send "{Right}"
			Send "+{Right}"
		}
	}
	clearCounter()
}

O:: {
	Send "{End}"
	Sleep 10
	Send "+{Enter}"
	gotoInsert()
}

+O:: {
	Send "{Home}"
	Sleep 10
	Send "+{Enter}{Up}"
	gotoInsert()
}

u:: {
	Send "^z"
	exitVisualMode()
}

^r:: {
	Send "^y"
	exitVisualMode()
}

+y:: {
	Send "+{End}"
	Send "^{insert}"
	Send "{Left}"
	Send "+{Right}"
	exitVisualMode()
}

y:: {
	global counter
	global infcounter
	if visualMode == true {
		Send "^{insert}"
		Send "{Left}"
		gotoNormal()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "y"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoYMode()
}

+p:: {
	Send "{Left}"
	sleep 10
	Send "+{insert}"
	exitVisualMode()
}

p:: {
	if visualMode == true {
		Send "+{insert}"
		Exit
	}
	Send "{Right}"
	Send "+{insert}"
	exitVisualMode()
}

0::
{
	global counter
	global infcounter
	if counter != 0 {
		counter *= 10
		infcounter.Destroy()
		infcounter := Infos(counter, , true)
		exit
	}
	if visualMode == true
	{
		Send "+{home}"
	}
	else
	{
		Send "{home}"
		Send "+{Right}"
		Exit
	}
}

+4::
{
	if visualMode == true
	{
		Send "+{End}"
	}
	else
	{
		Send "{End}"
		Send "{Left}"
		Send "+{Right}"
		Exit
	}
}

a:: {
	Send "{Left}"
	Send "{Right}"
	gotoInsert()
	Exit
}

*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return

#HotIf

; Window Manager Mode - for moving the window using keyboard
#HotIf WindowManagerMode = 1
HotIf "WindowManagerMode = 1"

!f:: {
	global WasInWindowManagerMode := true
	gotoFMode()
}
*a:: return
*b:: return
*c:: return
*d:: return
*e:: return
*f:: return
*g:: return
*h:: return
*i:: return
*j:: return
*k:: return
*l:: return
*m:: return
*n:: return
*o:: return
*p:: return
*q:: return
*r:: return
*s:: return
*t:: return
*u:: return
*v:: return
*w:: return
*x:: return
*y:: return
*z:: return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return


h:: WindowManager().MoveLeft(Mouse.MediumMove)
k:: WindowManager().MoveUp(Mouse.MediumMove)
j:: WindowManager().MoveDown(Mouse.MediumMove)
l:: WindowManager().MoveRight(Mouse.MediumMove)
u:: WindowManager().MoveUpLeft(Mouse.MediumMove)
o:: WindowManager().MoveUpRight(Mouse.MediumMove)
n:: WindowManager().MoveDownLeft(Mouse.MediumMove)
,:: WindowManager().MoveDownRight(Mouse.MediumMove)

+h:: WindowManager().MoveLeft(Mouse.SmallMove)
+k:: WindowManager().MoveUp(Mouse.SmallMove)
+j:: WindowManager().MoveDown(Mouse.SmallMove)
+l:: WindowManager().MoveRight(Mouse.SmallMove)
+u:: WindowManager().MoveUpLeft(Mouse.SmallMove)
+o:: WindowManager().MoveUpRight(Mouse.SmallMove)
+n:: WindowManager().MoveDownLeft(Mouse.SmallMove)
+,:: WindowManager().MoveDownRight(Mouse.SmallMove)

; space & h:: WindowManager().MoveLeft(Mouse.SmallMove)
; space & k:: WindowManager().MoveUp(Mouse.SmallMove)
; space & j:: WindowManager().MoveDown(Mouse.SmallMove)
; space & l:: WindowManager().MoveRight(Mouse.SmallMove)
; space & u:: WindowManager().MoveUpLeft(Mouse.SmallMove)
; space & o:: WindowManager().MoveUpRight(Mouse.SmallMove)
; space & n:: WindowManager().MoveDownLeft(Mouse.SmallMove)
; space & ,:: WindowManager().MoveDownRight(Mouse.SmallMove)

^h:: WindowManager().MoveLeft(Mouse.BigMove)
^k:: WindowManager().MoveUp(Mouse.BigMove)
^j:: WindowManager().MoveDown(Mouse.BigMove)
^l:: WindowManager().MoveRight(Mouse.BigMove)
^u:: WindowManager().MoveUpLeft(Mouse.BigMove)
^o:: WindowManager().MoveUpRight(Mouse.BigMove)
^n:: WindowManager().MoveDownLeft(Mouse.BigMove)
^,:: WindowManager().MoveDownRight(Mouse.BigMove)

s:: WindowManager().DecreaseWidth(Mouse.MediumMove)
d:: WindowManager().IncreaseHeight(Mouse.MediumMove)
f:: WindowManager().DecreaseHeight(Mouse.MediumMove)
g:: WindowManager().IncreaseWidth(Mouse.MediumMove)
e:: {
	WindowManager().DecreaseWidth(Mouse.MediumMove)
	WindowManager().DecreaseHeight(Mouse.MediumMove)
}
v:: {
	WindowManager().IncreaseHeight(Mouse.MediumMove)
	WindowManager().IncreaseWidth(Mouse.MediumMove)
}

+s:: WindowManager().DecreaseWidth(Mouse.SmallMove)
+d:: WindowManager().IncreaseHeight(Mouse.SmallMove)
+f:: WindowManager().DecreaseHeight(Mouse.SmallMove)
+g:: WindowManager().IncreaseWidth(Mouse.SmallMove)
+e:: {
	WindowManager().DecreaseWidth(Mouse.SmallMove)
	WindowManager().DecreaseHeight(Mouse.SmallMove)
}
+v:: {
	WindowManager().IncreaseHeight(Mouse.SmallMove)
	WindowManager().IncreaseWidth(Mouse.SmallMove)
}

; space & s:: WindowManager().DecreaseWidth(Mouse.SmallMove)
; space & d:: WindowManager().IncreaseHeight(Mouse.SmallMove)
; space & f:: WindowManager().DecreaseHeight(Mouse.SmallMove)
; space & g:: WindowManager().IncreaseWidth(Mouse.SmallMove)
; space & e:: {
; 	WindowManager().DecreaseWidth(Mouse.SmallMove)
; 	WindowManager().DecreaseHeight(Mouse.SmallMove)
; }
; space & v:: {
; 	WindowManager().IncreaseHeight(Mouse.SmallMove)
; 	WindowManager().IncreaseWidth(Mouse.SmallMove)
; }


^s:: WindowManager().DecreaseWidth(Mouse.BigMove)
^d:: WindowManager().IncreaseHeight(Mouse.BigMove)
^f:: WindowManager().DecreaseHeight(Mouse.BigMove)
^g:: WindowManager().IncreaseWidth(Mouse.BigMove)
^e:: {
	WindowManager().DecreaseWidth(Mouse.BigMove)
	WindowManager().DecreaseHeight(Mouse.BigMove)
}
^v:: {
	WindowManager().IncreaseHeight(Mouse.BigMove)
	WindowManager().IncreaseWidth(Mouse.BigMove)
}


1:: WinMove(0, 0, , , "A")
2:: WinMove(Mouse.FarLeftX, 0, , , "A")
3:: WinMove(Mouse.HighLeftX, 0, , , "A")
4:: WinMove(Mouse.MiddleLeftX, 0, , , "A")
5:: WinMove(Mouse.LowLeftX, 0, , , "A")
6:: WinMove(Mouse.LessThanMiddleX, 0, , , "A")
7:: WinMove(Mouse.MiddleX, 0, , , "A")
8:: WinMove(Mouse.MoreThanMiddleX, 0, , , "A")
9:: WinMove(Mouse.LowRightX, 0, , , "A")
0:: WinMove(Mouse.MiddleRightX, 0, , , "A")

+1:: WinMove(0, Mouse.MiddleY, , , "A")
+2:: WinMove(Mouse.FarLeftX, Mouse.MiddleY, , , "A")
+3:: WinMove(Mouse.HighLeftX, Mouse.MiddleY, , , "A")
+4:: WinMove(Mouse.MiddleLeftX, Mouse.MiddleY, , , "A")
+5:: WinMove(Mouse.LowLeftX, Mouse.MiddleY, , , "A")
+6:: WinMove(Mouse.LessThanMiddleX, Mouse.MiddleY, , , "A")
+7:: WinMove(Mouse.MiddleX, Mouse.MiddleY, , , "A")
+8:: WinMove(Mouse.MoreThanMiddleX, Mouse.MiddleY, , , "A")
+9:: WinMove(Mouse.LowRightX, Mouse.MiddleY, , , "A")
+0:: WinMove(Mouse.MiddleRightX, Mouse.MiddleY, , , "A")

^1:: WinMove(0, Mouse.LowY, , , "A")
^2:: WinMove(Mouse.FarLeftX, Mouse.LowY, , , "A")
^3:: WinMove(Mouse.HighLeftX, Mouse.LowY, , , "A")
^4:: WinMove(Mouse.MiddleLeftX, Mouse.LowY, , , "A")
^5:: WinMove(Mouse.LowLeftX, Mouse.LowY, , , "A")
^6:: WinMove(Mouse.LessThanMiddleX, Mouse.LowY, , , "A")
^7:: WinMove(Mouse.MiddleX, Mouse.LowY, , , "A")
^8:: WinMove(Mouse.MoreThanMiddleX, Mouse.LowY, , , "A")
^9:: WinMove(Mouse.LowRightX, Mouse.LowY, , , "A")
^0:: WinMove(Mouse.MiddleRightX, Mouse.LowY, , , "A")

!a:: WindowManager().SetFullHeight()
!q:: WindowManager().SetHalfHeight()
!w:: WindowManager().SetHalfWidth()
!e:: WindowManager().SetFullWidth()

m::
^m::
!m::
Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
}

!`:: {
	exitVim()
}

#HotIf

; Mouse Manager Mode - for moving the mouse using keyboard
#HotIf mouseManagerMode = 1
HotIf "mouseManagerMode = 1"

tab & ':: {
	global mouseManagerMode := false
	if GetKeyState("ctrl") or GetKeyState("vkE8") or GetKeyState("shift")
		saveReg()
	else
		openMark()
	global mouseManagerMode := true
}

m:: {
	global mouseManagerMode := false
	saveMark()
	global mouseManagerMode := true
}
':: {
	global mouseManagerMode := false
	openMark()
	global mouseManagerMode := true
}

#t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "#t"
		}
		clearCounter()
		Exit
	}
	Send "#t"
}

!h::!Left
!j::!Down
!k::!up
!l::!Right

1:: chCounter(1)
2:: chCounter(2)
3:: chCounter(3)
4:: chCounter(4)
5:: chCounter(5)
6:: chCounter(6)
7:: chCounter(7)
8:: chCounter(8)
9:: chCounter(9)
0:: chCounter(0)

zkeyCount := 0
+z::
{
	global zkeyCount
	global zKey := (A_PriorHotkey = "+z" and A_TimeSincePriorHotkey < 400)
	if zKey {
		zkeyCount := zkeyCount + 1
	}
	else {
		zkeyCount := 0
	}
	if zKey and zkeyCount == 1 {
		Sleep 0
		Send "!{f4}"
	}
}
qkeyCount := 0
+q::
{
	global qkeyCount
	global qKey := (A_PriorHotkey = "~+z" and A_TimeSincePriorHotkey < 400)
	if qKey {
		qkeyCount := qkeyCount + 1
	}
	else {
		qkeyCount := 0
	}
	if qKey and qkeyCount == 1 {
		Sleep 0
		Send "!{f4}"
	}
}
z & q:: {
	if GetKeyState("shift")
		Send "!{f4}"
}
z & u:: {
	Send "{WheelUp}"
	Send "{WheelLeft}"
}
z & o:: {
	Send "{WheelUp}"
	Send "{WheelRight}"
}
z & n:: {
	Send "{WheelLeft}"
	Send "{WheelDown}"
}
z & ,:: {
	Send "{WheelDown}"
	Send "{WheelRight}"
}
z & h:: {
	Send "{WheelLeft}"
}
z & l:: {
	Send "{WheelRight}"
}
z & j:: {
	Send "{WheelDown}"
}
z & k:: {
	Send "{WheelUp}"
}
z & =:: {
	Send "{Left}"
	Send "+{f10}"
}

+;:: {
	gotoInsertnoInfo()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoNormalnoInfo()
	gotoMouseMode()
}

+':: {
	global mouseManagerMode := false
	saveReg()
	global mouseManagerMode := true
	clearCounter()
}


^!n:: {
	global WasInMouseManagerMode := true
	gotoNumLockMode()
}
~!+a:: {
	global WasInMouseManagerMode := true
	clearCounter()
	disableClick()
	gotoInsert()
}

r:: Return
z:: Return
.:: Return
+.:: Return
^.:: Return
space & .:: Return
/:: {
	global WasInMouseManagerMode := true
	global infcounter
	infcounter.Destroy()
	Send "^f"
	disableClick()
	gotoInsert()
}
+/:: return
^/:: return
[:: Return
]:: Return
\:: Return
+G:: {
	Send "^{End}"
}
x:: {
	Send "{Delete}"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
+x:: {
	Send "{BackSpace}"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
d:: {
	Send "{Delete}"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
c:: {
	Send "{Delete}"
	global WasInMouseManagerMode := true
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
	gotoInsert()
	Exit
}
y:: {
	Send "^{insert}"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
p:: {
	Send "+{insert}"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
^w:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoWindowMode()
}
f:: {
	gotoFMode()
}
+f:: {
	global shiftfMode := true
	gotoFMode()
}
!f:: {
	global altfMode := true
	gotoFMode()
}
g:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoGMode()
}
i:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
}
a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
}
^a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{Home}"
}
+i:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{Home}"
}
+a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{End}"
}
!m::
^m:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoMwMode()
	clearCounter()
}

Tab & u::
!u:: {
	Send "^z"
}
^r:: {
	Send "^y"
}

t:: Click()
!t:: Click("Right")
tab & t:: {
	if GetKeyState("Shift") {
		Send "{Shift Up}"
		Click("Right")
		Send "{Shift Down}"
	}
	else if GetKeyState("Ctrl") {
		Send "{ctrl Up}"
		Click("Right")
		Send "{ctrl Down}"
	}
	else
		Click("Right")
}
+t:: {
	Send "{Shift Up}"
	Click()
	Send "{Shift Down}"
}
^t:: {
	Send "{ctrl Up}"
	Click()
	Send "{ctrl Down}"
}
b:: Click("Middle")

v:: Mouse.HoldIfUp("L")
!v:: Mouse.HoldIfUp("R")
tab & v:: Mouse.HoldIfUp("R")
+b:: Mouse.HoldIfUp("M")
!b:: Mouse.HoldIfUp("M")
tab & b:: Mouse.HoldIfUp("M")

!1:: {
	shiftSpeed()
}
!2:: {
	normalSpeed()
}
!3:: {
	controlSpeed()
}
!4:: {
	mouseslowfastSpeed()
}

Hotkey "u", ButtonAcceleration
Hotkey "o", ButtonAcceleration
Hotkey "n", ButtonAcceleration
Hotkey ",", ButtonAcceleration
Hotkey "j", ButtonAcceleration
Hotkey "h", ButtonAcceleration
Hotkey "k", ButtonAcceleration
Hotkey "l", ButtonAcceleration
Hotkey "+u", ButtonAcceleration
Hotkey "+o", ButtonAcceleration
Hotkey "+n", ButtonAcceleration
Hotkey "+,", ButtonAcceleration
Hotkey "+h", ButtonAcceleration
Hotkey "+j", ButtonAcceleration
Hotkey "+k", ButtonAcceleration
Hotkey "+l", ButtonAcceleration

Hotkey "^u", ButtonAcceleration
Hotkey "^o", ButtonAcceleration
Hotkey "^n", ButtonAcceleration
Hotkey "^,", ButtonAcceleration
Hotkey "^h", ButtonAcceleration
Hotkey "^j", ButtonAcceleration
Hotkey "^k", ButtonAcceleration
Hotkey "^l", ButtonAcceleration

^f::
space & f:: Click "WD 20"

^b::
space & b:: Click "WU 20"

space & e::wheeldown
space & y::WheelUp
space & ,:: {
	ButtonAcceleration('+,')
}
space & n:: {
	ButtonAcceleration('+n')
}
space & o:: {
	ButtonAcceleration('+o')
}
space & u:: {
	ButtonAcceleration('+u')
}
space & h:: {
	ButtonAcceleration('+h')
}
space & j:: {
	ButtonAcceleration('+j')
}
space & k:: {
	ButtonAcceleration('+k')
}
space & l:: {
	ButtonAcceleration('+l')
}

hotkey "!q", ButtonSpeedUp
hotkey "!a", ButtonSpeedDown
hotkey "!w", ButtonAccelerationSpeedUp
hotkey "!s", ButtonAccelerationSpeedDown
hotkey "!e", ButtonMaxSpeedUp
hotkey "!d", ButtonMaxSpeedDown

!`:: {
	exitVim()
}
Esc:: {
	global counter
	if counter == 0
		Send "{Esc}"
	clearCounter()
}
BackSpace:: {
	backspaceCounter()
}

!^y::
{
	Send "^{WheelUp}"
}

!^e::
{
	Send "^{WheelDown}"
}
+^y::
{
	Send "+{WheelUp}"
}
+^e::
{
	Send "+{WheelDown}"
}
^e:: {
	Send "{WheelDown}"
}
^y:: {
	Send "{WheelUp}"
}
#HotIf


#HotIf fancywmMode = 1
HotIf "fancywmMode = 1"

Esc:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

Enter:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action PullWindowUp')
}

!1:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop1')
}
!2:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop2')
}
!3:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop3')
}
!4:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop4')
}
!5:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop5')
}
!6:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop6')
}
!7:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop7')
}
!8:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action SwitchToDesktop8')
}

+1::
+!1:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop1')
	Run('fancywm.exe --action SwitchToDesktop1')
}
+2::
+!2:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop2')
	Run('fancywm.exe --action SwitchToDesktop2')
}
+3::
+!3:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop3')
	Run('fancywm.exe --action SwitchToDesktop3')
}
+4::
+!4:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop4')
	Run('fancywm.exe --action SwitchToDesktop4')
}
+5::
+!5:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop5')
	Run('fancywm.exe --action SwitchToDesktop5')
}
+6::
+!6:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop6')
	Run('fancywm.exe --action SwitchToDesktop6')
}
+7::
+!7:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop7')
	Run('fancywm.exe --action SwitchToDesktop7')
}
+8::
+!8:: {
	global fancywmMode := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Run('fancywm.exe --action MoveToDesktop8')
	Run('fancywm.exe --action SwitchToDesktop8')
}

q:: {
	global fancywmMode := false
	Run('fancywm.exe --action ToggleManager')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

!x:: {
	global fancywmMode := false
	global hide
	hide := !hide
	HideShowTaskbar(hide)
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

f:: {
	global fancywmMode := false
	Run('fancywm.exe --action ToggleFloatingMode')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
r:: {
	global fancywmMode := false
	Run('fancywm.exe --action RefreshWorkspace')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

#+h::
h:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveFocusLeft')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

#+k::
k:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveFocusUp')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
#+l::
l:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveFocusRight')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
#+j::
j:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveFocusDown')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

+h:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveLeft')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+j:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveDown')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+k:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveUp')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+l:: {
	global fancywmMode := false
	Run('fancywm.exe --action MoveRight')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

^+h:: {
	global fancywmMode := false
	Run('fancywm.exe --action SwapLeft')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+j:: {
	global fancywmMode := false
	Run('fancywm.exe --action SwapDown')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+k:: {
	global fancywmMode := false
	Run('fancywm.exe --action SwapUp')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+l:: {
	global fancywmMode := false
	Run('fancywm.exe --action SwapRight')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^v:: {
	global fancywmMode := false
	Run('fancywm.exe --action CreateVerticalPanel')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^h:: {
	global fancywmMode := false
	Run('fancywm.exe --action CreateHorizontalPanel')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^s:: {
	global fancywmMode := false
	Run('fancywm.exe --action CreateStackPanel')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

]:: {
	global fancywmMode := false
	Run('fancywm.exe --action IncreaseWidth')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
[:: {
	global fancywmMode := false
	Run('fancywm.exe --action DecreaseWidth')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
':: {
	global fancywmMode := false
	Run('fancywm.exe --action IncreaseHeight')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
`;:: {
	global fancywmMode := false
	Run('fancywm.exe --action DecreaseHeight')
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}


#+x::
x:: {
	global fancywmMode := false
	MouseGetPos , , &KDE_id
	KDE_id := WinActive("A")
	; Toggle between maximized and restored state.
	if WinGetMinMax(KDE_id)
		WinRestore KDE_id
	Else
		WinMaximize KDE_id
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

#+m::
m:: {
	global fancywmMode := false
	MouseGetPos , , &KDE_id
	KDE_id := WinActive("A")
	; Toggle between maximized and restored state.
	WinMinimize KDE_id
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

#HotIf

; Functions
disableClick() {
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}

h_motion()
{
	global counter
	global infcounter
	global visual_x
	if counter != 0 {
		Loop counter {
			if visualLineMode {
				return
			}
			if visualMode == true
			{
				if visual_x == 0 {
					Send "{right}"
					Send "+{Left}"
					Send "+{Left}"
				}
				else {
					Send "+{left}"
				}
				visual_x := visual_x - 1
			}
			else
			{
				Send "{Left}"
				Send "{Left}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
	}
	else if visualMode == true
	{
		if visual_x == 0 {
			Send "{right}"
			Send "+{Left}"
			Send "+{Left}"
		}
		else {
			Send "+{left}"
		}
		visual_x := visual_x - 1
	}
	else
	{
		Send "{Left}"
		Send "{Left}"
		Send "+{Right}"
	}
}

j_motion()
{
	global counter
	global infcounter
	global visual_y
	if counter != 0 {
		Loop counter {
			if visualLineMode == true
			{
				if visual_y == 0 {
					Send "{Home}"
					Send "+{End}"
					Send "+{Down}"
					Send "+{End}"
				}
				else if visual_y < 0 {
					Send "+{Down}"
					Send "+{End}"
				}
				else if visual_y > 0 {
					Send "+{Down}"
					Send "+{Home}"
				}
				visual_y := visual_y - 1
			}
			else if visualMode == true
			{
				Send "+{Down}"
			}
			else
			{
				Send "{Left}"
				Send "{Down}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
	}
	else if visualLineMode == true
	{
		if visual_y == 0 {
			Send "{Home}"
			Send "+{End}"
			Send "+{Down}"
			Send "+{End}"
		}
		else if visual_y < 0 {
			Send "+{Down}"
			Send "+{End}"
		}
		else if visual_y > 0 {
			Send "+{Down}"
			Send "+{Home}"
		}
		visual_y := visual_y - 1
	}
	else if visualMode == true
	{
		Send "+{Down}"
	}
	else
	{
		Send "{Left}"
		Send "{Down}"
		Send "+{Right}"
	}
}

k_motion() {
	global counter
	global infcounter
	global visual_y
	if counter != 0 {
		Loop counter {
			if visualLineMode == true
			{
				if visual_y == 0 {
					Send "{End}"
					Send "+{Home}"
					Send "+{Up}"
					Send "+{Home}"
				}
				else if visual_y < 0 {
					Send "+{Up}"
					Send "+{End}"
				}
				else if visual_y > 0 {
					Send "+{Up}"
					Send "+{Home}"
				}
				visual_y := visual_y + 1
			}
			else if visualMode == true
			{
				Send "+{Up}"
			}
			else
			{
				Send "{Left}"
				Send "{Up}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
	}
	else if visualLineMode == true
	{
		if visual_y == 0 {
			Send "{End}"
			Send "+{Home}"
			Send "+{Up}"
			Send "+{Home}"
		}
		else if visual_y < 0 {
			Send "+{Up}"
			Send "+{End}"
		}
		else if visual_y > 0 {
			Send "+{Up}"
			Send "+{Home}"
		}
		visual_y := visual_y + 1
	}
	else if visualMode == true
	{
		Send "+{Up}"
	}
	else
	{
		Send "{Left}"
		Send "{Up}"
		Send "+{Right}"
	}
}

l_motion() {
	global counter
	global infcounter
	global visual_x
	if counter != 0 {
		Loop counter {
			if visualLineMode {
				return
			}
			if visualMode == true
			{
				if visual_x == 0 {
					Send "{Left}"
					Send "+{Right}"
					Send "+{Right}"
				}
				else {
					Send "+{Right}"
				}
				visual_x := visual_x + 1
				Send "+{Right}"
			}
			else
			{
				Send "{Left}"
				Send "{Right}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
	}
	else if visualMode == true
	{
		if visual_x == 0 {
			Send "{Left}"
			Send "+{Right}"
			Send "+{Right}"
		}
		else {
			Send "+{Right}"
		}
		visual_x := visual_x + 1
		Send "+{Right}"
	}
	else
	{
		Send "{Left}"
		Send "{Right}"
		Send "+{Right}"
	}
}

reloadfunc() {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Infos("changing to english")
		Send "#{space}"
		Sleep 1000
	}
	Reload
}

chCounter(number, mode := "") {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += number
		text := mode counter
		infcounter.Destroy()
		infcounter := Infos(text, , true)
	}
}

exitVim() {
	Infos.DestroyAll()
	Infos("Exit Vim", 1500)
	global fancywmMode := false
	global gkomorebi := false
	global normalMode := false
	global insertMode := false
	global dMode := false
	global wasInInsertMode := false
	global regMode := false
	global wasInNormalMode := false
	global gMode := false
	global yMode := false
	global cMode := false
	global fMode := false
	global qMode := false
	global numlockMode := false
	global windowMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[1].Destroy() ; Vim
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[7].Destroy() ; mark Mode
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	StateBulb[StateBulb.MaxBulbs].Destroy()
	; StateBulb[4].Destroy() ; Delete
	; StateBulb[5].Destroy() ; Change
	; StateBulb[6].Destroy() ; Yank
	; StateBulb[7].Destroy() ; Window
	; StateBulb[8].Destroy() ; Fmode
	disableClick()
	clearCounter()
	exitVisualMode
	Exit
}
gotoNumLockMode() {
	global numlockMode := true
	global normalMode := false
	global mouseManagerMode := false
	StateBulb[4].Create()
}

gotoWindowMode() {
	global mouseManagerMode := false
	global normalMode := false
	global windowMode := true
	StateBulb[4].Create()
}

gotoMwMode() {
	global mouseManagerMode := false
	global normalMode := false
	global WindowManagerMode := true
	StateBulb[5].Create()
}

gotoMouseMode() {
	global monitorCount
	if monitorCount == 0 {
		monitorCount := MonitorGetCount()
	}
	else if monitorCount != MonitorGetCount() {
		reloadfunc()
	}
	global normalMode := false
	global mouseManagerMode := true
	global WasInMouseManagerMode := false
	global wasinCmdMode := false
	global WasInRegMode := false
	global WasInWindowManagerMode := false
	global fMode := false
	StateBulb[6].Create()
	StateBulb[4].Destroy()
}

gotoFMode() {
	global normalMode := false
	global mouseManagerMode := false
	global fMode := true
	StateBulb[4].Create()
	clearCounter()
}

gotoGMode() {
	global normalMode := false
	global gMode := true
	StateBulb[4].Create()
}

gotoDMode() {
	global normalMode := false
	global dMode := true
	StateBulb[4].Create()
	; langid := Language.GetKeyboardLanguage()
	; if (LangID = 0x040D) {
	; 	Send "{Left}"
	; } else
	; 	Send "{Right}"
}

gotoRegMode() {
	global normalMode := false
	global regMode := true
	StateBulb[4].Create()
}

gotoYMode() {
	global normalMode := false
	global yMode := true
	StateBulb[4].Create()
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
	} else
		Send "{Right}"
}

gotoCMode() {
	global normalMode := false
	global cMode := true
	StateBulb[4].Create()
	; langid := Language.GetKeyboardLanguage()
	; if (LangID = 0x040D) {
	; 	Send "{Left}"
	; } else
	; 	Send "{Right}"
}

gotoNormalnoInfo() {
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	if insertMode == true {
		StateBulb[2].Destroy()
	}
	global normalMode := true
	global visualMode := false
	global insertMode := false
	global visualLineMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global cMode := false
	global fMode := false
	global yMode := false
	global windowMode := false
	global WindowManagerMode := false
	global WasInMouseManagerMode := false
	global wasinCmdMode := false
	global WasInRegMode := false
	global WasInWindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[1].Create()
}

gotoNormal() {
	global monitorCount
	if monitorCount == 0 {
		monitorCount := MonitorGetCount()
	}
	else if monitorCount != MonitorGetCount() {
		reloadfunc()
	}
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	if insertMode == true {
		StateBulb[2].Destroy()
	}
	global normalMode := true
	global insertMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global cMode := false
	global fMode := false
	global shiftfMode := false
	global altfMode := false
	global yMode := false
	global windowMode := false
	global WindowManagerMode := false
	global WasInMouseManagerMode := false
	global wasinCmdMode := false
	global WasInRegMode := false
	global WasInWindowManagerMode := false
	global mouseManagerMode := false
	clearCounter()
	exitVisualMode()
	StateBulb[1].Create()
}

gotoVisual() {
	global normalMode := true
	global visualMode := true
	global insertMode := false
	global visualLineMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global yMode := false
	global fMode := false
	global cMode := false
	global windowMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[3].Create()
	; Infos.DestroyAll()
	; Infos("Visual Mode", 1500)
}

gotoInsert() {
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	global normalMode := false
	global insertMode := true
	global dMode := false
	global regMode := false
	global gMode := false
	global fMode := false
	global yMode := false
	global windowMode := false
	global cMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[2].Create()
	global infcounter
	infcounter.Destroy()
	global counter
	clearCounter()
	exitVisualMode()
}

gotoInsertnoInfo() {
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	global normalMode := false
	global visualMode := false
	global insertMode := true
	global visualLineMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global fMode := false
	global yMode := false
	global windowMode := false
	global cMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[2].Create()
}

capdelChanYanFmotion() {
	global visual_x := 0
	global visual_y := 0
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
				global normalMode := true
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
			global normalMode := true
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
		Send "+{Right}"
	}
	infcounter.Destroy()
	StateBulb[4].Destroy()
	return FoundPos
}

delChanYanfMotion() {
	global visual_x := 0
	global visual_y := 0
	StateBulb[4].Create()
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
				global normalMode := true
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
			global normalMode := true
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
		Send "+{Right}"
	}
	infcounter.Destroy()
	StateBulb[4].Destroy()
	return FoundPos
}


capdelChanYanTMotion() {
	val := capdelChanYanFmotion()
	Send "+{Left}"
	return val
}
delChanYantMotion() {
	val := delChanYanfMotion()
	Send "+{Left}"
	return val
}

openMark() {
	inf := Infos('`'', , true)
	StateBulb[7].Create()
	marko := InputHook("C")
	marko.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	marko.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	marko.Start()
	marko.Wait()
	var := marko.EndMods
	var .= marko.EndKey
	mark := marko.EndKey
	if var == "<!``" {
		exitVim()
		inf.Destroy()
		Exit
	}
	else if mark == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	if Marks.validateMark(mark)
	{
		win_id := StrSplit(Marks.Read(mark), ",")
		win_id := Integer(win_id[1])
		WinActivate(Integer(win_id))
	}
	StateBulb[7].Destroy()
	inf.Destroy()
}

openMouseMark() {
	inf := Infos('openMouseMark', , true)
	StateBulb[7].Create()
	marko := InputHook("C")
	marko.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	marko.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	marko.Start()
	marko.Wait()
	var := marko.EndMods
	var .= marko.EndKey
	mark := marko.EndKey
	if var == "<!``" {
		exitVim()
		inf.Destroy()
		Exit
	}
	else if mark == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	{
		pos := StrSplit(MouseMarks.Read(mark), ",")
		xpos := Integer(pos[1])
		ypos := Integer(pos[2])
		MouseMove(xpos, ypos, 0)
	}
	StateBulb[7].Destroy()
	inf.Destroy()
}

saveMark() {
	inf := Infos('m', , true)
	StateBulb[7].Create()
	marko := InputHook("C")
	marko.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	marko.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	marko.Start()
	marko.Wait()
	var := marko.EndMods
	var .= marko.EndKey
	mark := marko.EndKey
	if var == "<!``" {
		exitVim()
		inf.Destroy()
	}
	else if mark == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	Registers.ValidateKey(mark)
	actw := WinExist("A")
	Marks.saveMarkinFile(mark, actw)
	StateBulb[7].Destroy()
	inf.Destroy()
}

saveMouseMark() {
	inf := Infos('Saving Mouse Mark', , true)
	StateBulb[7].Create()
	marko := InputHook("C")
	marko.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	marko.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	marko.Start()
	marko.Wait()
	var := marko.EndMods
	var .= marko.EndKey
	mark := marko.EndKey
	if var == "<!``" {
		exitVim()
		inf.Destroy()
	}
	else if mark == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	Registers.ValidateKey(mark)
	MouseGetPos &xPos, &yPos
	MouseMarks.saveMarkinFile(mark, xPos, yPos)
	StateBulb[7].Destroy()
	inf.Destroy()
}

insertReg() {
	inf := Infos('"', , true)
	StateBulb[7].Create()
	marko := InputHook("C")
	marko.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	marko.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	marko.Start()
	marko.Wait()
	var := marko.EndMods
	var .= marko.EndKey
	mark := marko.EndKey
	if var == "<!``" {
		exitVim()
		Exit
	}
	else if mark == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	Registers(mark).Paste()
	StateBulb[7].Destroy()
	inf.Destroy()
}

saveReg() {
	inf := Infos('"', , true)
	StateBulb[7].Create()
	markgi := GetInput("L1", "{Esc}{space}{Backspace}")
	mark := markgi.Input
	if mark = "" {
		StateBulb[7].Destroy()
		inf.Destroy()
		Exit
	}
	var := markgi.EndMods
	var .= markgi.EndMods
	if var == "<!``" {
		exitVim()
		inf.Destroy()
	}
	inf.Destroy()
	infs := '"'
	infs .= mark
	inf := Infos(infs, , true)
	operator := GetInput("L1", "{Esc}{space}{Backspace}").Input
	if (operator == "y") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^{insert}"
		ClipWait 1
		Sleep 10
		Registers(mark).WriteOrAppend()
		Sleep 10
		Send "{Left}"
		Send "+{Right}"
		A_Clipboard := oldclip
	}
	else if (operator == "d") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^x"
		ClipWait 1
		Sleep 10
		Registers(mark).WriteOrAppend()
		A_Clipboard := oldclip
	}
	else if (operator == "p") {
		Registers(mark).Paste()
		Sleep 10
		Send "{right}"
		Send "{left}"
		Send "+{Right}"
	}
	else if (operator == "l") {
		Registers(mark).Look()
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "m") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(mark).Move(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "s") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(mark).SwitchContents(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "x") {
		Registers(mark).Truncate()
		Send "{Left}"
		Send "+{Right}"
	}
	StateBulb[7].Destroy()
	inf.Destroy()
}

setMouseDefSpeed() {
	Mouse.SmallMove := 20
	Mouse.MediumMove := 70
	Mouse.BigMove := 200
}

backspaceCounter() {
	global counter
	global infcounter
	counter := counter / 10
	counter := Floor(counter)
	if counter == 0 {
		infcounter.Destroy()
		Send "{BackSpace}"
	} else {
		infcounter.Destroy()
		infcounter := Infos(counter, , true)
	}
}

innerword() {
	Send "^{Left}"
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "+{End}"
	Send "^{insert}"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := 0
	if FoundPos == 0
		FoundPos := InStr(Haystack, " ")
	if FoundPos == 0
		FoundPos := InStr(Haystack, ".")
	if FoundPos == 0
		FoundPos := InStr(Haystack, ",")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "/")
	if FoundPos == 0
		FoundPos := InStr(Haystack, ";")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "'")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "[")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "]")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "\")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "\s")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "\r")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "\n")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "\t")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "-")
	if FoundPos == 0
		FoundPos := InStr(Haystack, "=")
	if FoundPos == 0
		Send "^+{Right}"
	else {
		loop FoundPos {
			Send "+{Right}"
		}
		Send "+{Left}"
	}
	sleep 100
}

clearCounter() {
	global counter := 0
	global infcounter
	infcounter.Destroy()
}

bmotion() {
	global visual_x := 0
	global visual_y := 0
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				Send "^+{Right}"
			}
		}
		else {
			Send "^+{Right}"
		}
	}
	else if counter != 0 {
		Loop counter {
			Send "^+{Left}"
		}
	}
	else {
		Send "^+{Left}"
	}
}

wmotion() {
	global visual_x := 0
	global visual_y := 0
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				Send "^+{Left}"
			}
		} else {
			Send "^+{Left}"
		}
	}
	else if counter != 0 {
		if visualLineMode {
			Exit
		}
		Loop counter {
			Send "^+{Right}"
		}
	}
	else {
		Send "^+{Right}"
	}
}

emotion() {
	global visual_x := 0
	global visual_y := 0
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+{Right}"
		}
		Send "+{Left}"
	}
	else {
		if A_PriorHotkey == "e" {
			Send "^+{Right}"
		}
		Send "^+{Right}"
		Send "+{Left}"
	}
}


findEndLine() {
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Home}+{End}"
	Send "^{insert}"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := 0
	pattern := "[\p{P}a-zA-Z0-9\.*?+[{|()^$\s\r\n`r`n`s]"
	FoundPos := RegExMatch(Haystack, pattern, , -1)
	if FoundPos == 0
	{
		Send "+{End}"
	}
	else {
		loop FoundPos {
			Send "+{Right}"
		}
		Send "+{Left}"
		sleep 100
		return 1
	}
	sleep 100
	return 0
}

exitVisualMode() {
	global visualLineMode := false
	global visualMode := false
	global visual_y := 0
	global visual_x := 0
}

StartRecordingKey(key) {
	global recordMode := true
	RecordQ.Reg := key
}

StopRecordingKey(text) {
	global recordMode := false
	RecordQ.Write(text)
	Infos("stoped recording macro " RecordQ.Reg)
	RecordQ.Reg := ""
}

HideShowTaskbar(action) {
	static ABM_SETSTATE := 0xA, ABS_AUTOHIDE := 0x1, ABS_ALWAYSONTOP := 0x2
	size := 2 * A_PtrSize + 2 * 4 + 16 + A_PtrSize
	APPBARDATA := Buffer(size, 0)
	NumPut("int", size, APPBARDATA)
	NumPut("int", WinExist("ahk_class Shell_TrayWnd"), APPBARDATA, A_PtrSize)
	NumPut("int", action ? ABS_AUTOHIDE : ABS_ALWAYSONTOP, APPBARDATA, size - A_PtrSize)
	DllCall("Shell32\SHAppBarMessage", "UInt", ABM_SETSTATE, "ptr", APPBARDATA)
}

Komorebic(cmd) {
	RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

#HotIf gkomorebi = 1
HotIf "gkomorebi = 1"


Esc:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

!1:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 0")
}

!2:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 1")
}
!3:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 2")
}
!4:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 3")
}
!5:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 4")
}
!6:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 5")
}
!7:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 6")
}
!8:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("focus-workspace 7")
}

+1::
+!1:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 0")
}
+2::
+!2:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 1")
}
+3::
+!3:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 2")
}
+4::
+!4:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 3")
}
+5::
+!5:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 4")
}
+6::
+!6:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 5")
}
+7::
+!7:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 6")
}
+8::
+!8:: {
	global gkomorebi := false
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	Komorebic("move-to-workspace 7")
}

q:: {
	global gkomorebi := false
	Komorebic("toggle-pause")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

f:: {
	global gkomorebi := false
	Komorebic("toggle-float")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
r:: {
	global gkomorebi := false
	Komorebic("retile")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

m:: {
	global gkomorebi := false
	Komorebic("minimize")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
x:: {
	global gkomorebi := false
	Komorebic("toggle-monocle")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
h:: {
	global gkomorebi := false
	Komorebic("focus left")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
j:: {
	global gkomorebi := false
	Komorebic("focus down")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
k:: {
	global gkomorebi := false
	Komorebic("focus up")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
l:: {
	global gkomorebi := false
	Komorebic("focus right")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

+h:: {
	global gkomorebi := false
	Komorebic("move left")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+j:: {
	global gkomorebi := false
	Komorebic("move down")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+k:: {
	global gkomorebi := false
	Komorebic("move up")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
+l:: {
	global gkomorebi := false
	Komorebic("move right")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

^+h:: {
	global gkomorebi := false
	Komorebic("stack left")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+j:: {
	global gkomorebi := false
	Komorebic("stack down")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+k:: {
	global gkomorebi := false
	Komorebic("stack up")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
^+l:: {
	global gkomorebi := false
	Komorebic("stack right")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}

^s:: {
	global gkomorebi := false
	Komorebic("unstack")
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}


!q:: Komorebic("close")

; Focus windows

!+[:: Komorebic("cycle-focus previous")
!+]:: Komorebic("cycle-focus next")


![:: Komorebic("cycle-stack previous")
!]:: Komorebic("cycle-stack next")

; Resize
!=:: Komorebic("resize-axis horizontal increase")
!-:: Komorebic("resize-axis horizontal decrease")
!+=:: Komorebic("resize-axis vertical increase")
!+_:: Komorebic("resize-axis vertical decrease")


; Layouts
!x:: Komorebic("flip-layout horizontal")
!y:: Komorebic("flip-layout vertical")
#HotIf