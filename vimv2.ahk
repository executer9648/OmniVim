#SingleInstance
#MaxThreadsBuffer True
#MaxThreads 255
#MaxThreadsPerHotkey 155
#UseHook
#Include StateBulb.ahk
#Include Info.ahk
#Include Mouse.ahk
#Include WindowManager.ahk
#Include Runner.ahk
#Include Registers.ahk
#Include mousetest.ahk
#Include GetInput.ahk
#Include Language.ahk

A_HotkeyInterval := 0
A_MenuMaskKey := "vkFF"

SetWinDelay -1
SetControlDelay -1
SetMouseDelay -1
ListLines 0
SetKeyDelay 10000
SetMouseDelay -1
CoordMode "Mouse", "Screen"

$CapsLock::Control
+!#Control::CapsLock

~Alt:: Send "{Blind}{vkFF}"
; #InputLevel 1
; LAlt:: SendEvent "h"
; #InputLevel 0
; h & j:: MsgBox "works"

+^#r:: Reload
#SuspendExempt
+^#s:: Suspend  ; Ctrl+Alt+S
#SuspendExempt False
+#e:: Edit
^#h:: Send "^#{Left}"
^#l:: Send "^#{Right}"

+#h:: Send "+#{Left}"
+#j:: Send "+#{Down}"
+#k:: Send "+#{Up}"
+#l:: Send "+#{Right}"

!#h:: Send "#{Left}"
!#j:: Send "#{Down}"
!#k:: Send "#{Up}"
!#l:: Send "#{Right}"

!h:: Send "{Left}"
!j:: Send "{Down}"
!k:: Send "{Up}"
!l:: Send "{Right}"

; Set initial state to normal (disabled)
global counter := 0
global normalMode := false
global dMode := false
global gMode := false
global yMode := false
global fMode := false
global cMode := false
global visualMode := false
global visualLineMode := false
global insertMode := false
global windowMode := false
global WindowManagerMode := false
global mouseManagerMode := false
global WasInMouseManagerMode := false
global WasInRegMode := false
global WasInWindowManagerMode := false
global wasinCmdMode := false
global infcounter := Infos("")
infcounter.Destroy()

exitVim() {
	Infos.DestroyAll()
	Infos("Exit Vim", 1500)
	Global normalMode := false
	Global insertMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global yMode := false
	global cMode := false
	global fMode := false
	global windowMode := false
	Global visualMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	Global visualLineMode := false
	global counter := 0
	StateBulb[1].Destroy() ; Vim
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[7].Destroy() ; reg Mode
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	; StateBulb[4].Destroy() ; Delete
	; StateBulb[5].Destroy() ; Change
	; StateBulb[6].Destroy() ; Yank
	; StateBulb[7].Destroy() ; Window
	; StateBulb[8].Destroy() ; Fmode
	Exit
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
	Send "{Right}"
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
	Send "{Right}"
}

gotoCMode() {
	global normalMode := false
	global cMode := true
	StateBulb[4].Create()
	Send "{Right}"
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
	global counter := 0
	StateBulb[1].Create()
	; Infos.DestroyAll()
	; Infos("Normal Mode", 1500)
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
	; Infos.DestroyAll()
	; Infos("Insert Mode", 1500)
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

fMotion() {
	StateBulb[4].Create()
	global normalMode := false
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var)
	Send "{Home}"
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
}

delChanYanfMotion() {
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
			if check == "<!Escape" {
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
		if check == "<!Escape" {
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
	Send "^c"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var)
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

delChanYanFMotionc() {
	StateBulb[4].Create()
	global normalMode := false
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
			if check == "<!Escape" {
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
		if check == "<!Escape" {
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
	Send "^c"
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
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

delChanYantMotion() {
	StateBulb[4].Create()
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var)
	Send "{Home}"
	loop FoundPos {
		Send "+{Right}"
	}
	Send "{Left}"
}


; Define the hotkey to enable the keybindings
^[:: {
	gotoNormal()
	Exit
}

^]:: {
	gotoNormal()
	gotoMouseMode()
	Mouse.SmallMove := 20
	Mouse.MediumMove := 70
	Mouse.BigMove := 200
	exit
}

; mylang() {
; 	; SetFormat, Integer, H
; 	; aac1 := DllCall("GetKeyboardLayout", int, DllCall("GetWindowThreadProcessId", int, WinActive("A"), int, 0))
; 	; MsgBox AAC1 = %aac1%
; 	; SetFormat, Integer, D

; 	VarSetStrCapacity(kbd, 9)
; 	if DllCall("GetKeyboardLayoutNameA", uint, &kbd)
; 		MsgBox %kbd%
; 	return
; }

; f mode
#HotIf fMode = 1
HotIf "fMode = 1"

`:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x1, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	Exit
}
1:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x2, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x2, Mouse.tildaCol)
		gotoMouseMode()
	}
	Exit
}
2:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x3, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x3, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
3:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x4, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
4:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x5, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x5, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
5:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x6, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x6, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
6:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x7, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x7, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
7:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x8, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x8, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
8:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x9, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x9, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
9:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x10, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x10, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
0:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x11, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x11, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
-:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x12, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x12, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
=:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x13, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x13, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
BackSpace:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x14, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x14, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}

tab:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x1, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
q:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x2, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
w:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x3, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
e:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x4, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
r:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x5, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
t:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x6, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
y:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x7, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
u:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x8, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
i:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x9, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
o:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x10, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
p:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x11, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
[:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x12, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
]:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x13, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
\:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x14, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
LControl:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax1, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
a:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax2, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
s:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax3, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
d:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax4, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
f:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax5, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
g:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax6, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
h:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax7, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
j:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax8, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
k:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax9, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
l:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax10, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
`;:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax11, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
':: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax12, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
Enter:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax13, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}

LShift:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx1, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
z:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx2, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
x:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx3, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
c:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx4, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
v:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx5, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
b:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx6, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
n:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx7, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
m:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx8, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
,:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx9, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
.:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx10, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
/:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx11, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
RShift:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx12, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}

LWin:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx1, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
LAlt:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx2, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Space:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx3, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
RAlt:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx4, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
; fn key
AppsKey:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx5, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Rctrl:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx6, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

#HotIf

; window mode
#HotIf windowMode = 1
HotIf "windowMode = 1"

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
a:: Return
b:: Return
c:: Return
d:: Return
e:: Return
f:: Return
g:: Return
h:: Return
i:: Return
j:: Return
k:: Return
l:: Return
m:: Return
n:: Return
o:: Return
p:: Return
r:: Return
s:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
0:: Return
1:: Return
2:: Return
3:: Return
4:: Return
5:: Return
6:: Return
7:: Return
8:: Return
9:: Return
^w:: Return
^e:: Return

!Esc:: {
	exitVim()
	Exit
}
Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}
*q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^w"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^w"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}
+q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "!{f4}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "!{f4}"
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^t"
		}
		counter := 0
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
	Exit
}

+t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+t"
		}
		counter := 0
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
	Exit
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
	Exit
}

#HotIf

; yank mode
#HotIf yMode = 1
HotIf "yMode = 1"

!Esc:: {
	exitVim()
	Exit
}

Esc:: {
	gotoNormal()
	Exit
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
a:: Return
c:: Return
d:: Return
g:: Return
h:: Return
j:: Return
k:: Return
l:: Return
m:: Return
n:: Return
o:: Return
p:: Return
q:: Return
r:: Return
s:: Return
u:: Return
v:: Return
x:: Return
z:: Return
1:: Return
2:: Return
3:: Return
4:: Return
5:: Return
6:: Return
7:: Return
8:: Return
9:: Return

f:: {
	delChanYanfMotion()
	Send "^c"
	gotoNormal()
	Exit
}

t:: {
	delChanYantMotion()
	Send "^c"
	gotoNormal()
	Exit
}

i:: {
	Send "^{Left}"
	Send "^+{Right}"
	Send "+{Left}"
	Send "^c"
	gotoNormal()
	Exit
}

y:: {
	Send "{Home}+{End}"
	Send "^c"
	gotoNormal()
	Exit
}

b:: {
	Send "^+{Left}"
	Send "^c"
	gotoNormal()
	Exit
}

w:: {
	Send "^+{Right}"
	Send "^c"
	gotoNormal()
	Exit
}

0::
{
	Send "+{home}"
	Send "^c"
	gotoNormal()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^c"
	gotoNormal()
	Exit
}

; Change mode
#HotIf cMode = 1
HotIf "cMode = 1"
Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
	Exit
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
a:: Return
d:: Return
g:: Return
h:: Return
j:: Return
k:: Return
l:: Return
m:: Return
n:: Return
o:: Return
p:: Return
q:: Return
r:: Return
s:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
1:: Return
2:: Return
3:: Return
4:: Return
5:: Return
6:: Return
7:: Return
8:: Return
9:: Return

f:: {
	delChanYanfMotion()
	Send "^x"
	gotoInsert()
	Exit
}
t:: {
	delChanYantMotion()
	Send "^x"
	gotoInsert()
	Exit
}

i:: {
	Send "^{Left}"
	; Send "^+{Right}"
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "+{End}"
	Send "^c"
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
	Send "^x"
	gotoInsert()
	Exit
}

c:: {
	Send "{Home}+{End}"
	Send "^x"
	gotoInsert()
	Exit
}

b:: {
	Send "{Left}"
	Send "^+{Left}"
	Send "^x"
	gotoInsert()
	Exit
}

w:: {
	Send "{Left}"
	Send "^+{Right}"
	Send "^x"
	gotoInsert()
	Exit
}

0::
{
	Send "+{home}"
	Send "^x"
	gotoInsert()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoInsert()
	Exit
}

#HotIf


; g mode
#HotIf gMode = 1
HotIf "gMode = 1"
t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^{tab}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
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
	Exit
}
+t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+{tab}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoNormal()
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
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
	Exit
}
g:: {
	if WasInMouseManagerMode == true {
		Send "{Home}"
		gotoNormal()
		gotoMouseMode()
	}
	else {
		Send "{Home}"
		gotoNormal()
	}
	Exit
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
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
a:: Return
c:: Return
g:: Return
h:: Return
j:: Return
k:: Return
l:: Return
m:: Return
n:: Return
o:: Return
p:: Return
q:: Return
r:: Return
s:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
1:: Return
2:: Return
3:: Return
4:: Return
5:: Return
6:: Return
7:: Return
8:: Return
9:: Return

f:: {
	delChanYanfMotion()
	Send "^x"
	gotoNormal()
	Exit
}

t:: {
	delChanYantMotion()
	Send "^x"
	gotoNormal()
	Exit
}

i:: {
	; Send "^{Left}"
	; Send "^+{Right}"
	; Send "^x"
	; gotoNormal()
	; Exit
	Send "^{Left}"
	; Send "^+{Right}"
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "+{End}"
	Send "^c"
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
	if FoundPos == 0 {
		Send "^+{Right}"
	}
	else {
		loop FoundPos {
			Send "+{Right}"
		}
	}
	sleep 100
	Send "^x"
	gotoNormal()
	Exit
}

Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

d:: {
	Send "{Home}+{End}"
	Send "^x"
	Send "{Delete}"
	gotoNormal()
	Exit
}

b:: {
	Send "{Left}"
	Send "^+{Left}"
	Send "^x"
	gotoNormal()
	Exit
}

w:: {
	Send "{Left}"
	Send "^+{Right}"
	Send "^x"
	gotoNormal()
	Exit
}

0::
{
	Send "+{home}"
	Send "^x"
	gotoNormal()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoNormal()
	Exit
}

#HotIf

; #HotIf WinActive("A")
; ~Alt:: Send "{Blind}{vkE8}"
; #HotIf

; insert Mode
#HotIf insertMode = 1
HotIf "insertMode = 1"

^r:: {
	global insertMode := false
	inf := Infos('"', , true)
	StateBulb[7].Create()
	rego := InputHook("C")
	rego.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	rego.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	rego.Start()
	rego.Wait()
	var := rego.EndMods
	var .= rego.EndKey
	reg := rego.EndKey
	if var == "<!Escape" {
		exitVim()
		Exit
	}
	else if reg == "Escape" {
		StateBulb[7].Destroy()
		inf.Destroy()
		global insertMode := true
		Exit
	}
	Registers(reg).Paste()
	StateBulb[7].Destroy()
	inf.Destroy()
	global insertMode := true
}

#Space:: {
	Language.ToggleBulb()
}
!Esc:: {
	exitVim()
	gotoNormal()
	Exit
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
	Exit
}

^u:: {
	Send "{Home}+{End}"
	Send "{BS}"
	Exit
}

^x:: {
	Send "+{Home}"
	Send "{BS}"
	Exit
}

^k:: Send "+{end}{bs}"

^w:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^+{Right}"
		Send "{bs}"
		Exit
	}
	Send "^+{Left}"
	Send "{bs}"
	Exit
}

^a:: {
	Send "{Home}"
	Exit
}

^e:: {
	Send "{End}"
	Exit
}

^b:: {
	Send "{Left}"
	Exit
}

!h:: {
	Send "{Left}"
	Exit
}

^n:: {
	Send "{Down}"
	Exit
}

^h:: {
	Send "{BS}"
	Exit
}

^d:: {
	Send "{Delete}"
	Exit
}

^p:: {
	Send "{Up}"
	Exit
}

!j:: {
	Send "{Down}"
	Exit
}

!k:: {
	Send "{Up}"
	Exit
}

^f:: {
	Send "{Right}"
	Exit
}

!l:: {
	Send "{Right}"
	Exit
}

!d:: {
	Send "^+{Right}"
	Send "{Delete}"
	Exit
}

+!b:: {
	Send "^+{Left}"
	Exit
}

+!f:: {
	Send "^+{Right}"
	Exit
}

!b:: {
	Send "^{Left}"
	Exit
}

!f:: {
	Send "^{Right}"
	Exit
}

^!h:: {
	Send "^{Left}"
	Exit
}

^!l:: {
	Send "^{Right}"
	Exit
}


#HotIf


; normal Mode
#HotIf normalMode = 1
HotIf "normalMode = 1"

BackSpace:: {
	global counter
	global infcounter
	counter := counter / 10
	counter := Floor(counter)
	if counter == 0 {
		infcounter.Destroy()
	} else {
		infcounter.Destroy()
		infcounter := Infos(counter, , true)
	}
	Send "{BackSpace}"
}

#Space:: {
	Language.ToggleBulb()
}
-:: Return
`;:: Return
+;:: {
	gotoInsertnoInfo()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoNormalnoInfo()
}
`:: Return
+`:: {
	if visualMode == true {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
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
		Send "^c"
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
	Exit
}
=:: Return
,:: Return
.:: Return
/:: {
	Send "^f"
	gotoInsert()
	Exit
}
':: Return
+':: {
	inf := Infos('"', , true)
	global normalMode := false
	StateBulb[7].Create()
	rego := InputHook("C")
	rego.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	rego.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	rego.Start()
	rego.Wait()
	var := rego.EndMods
	var .= rego.EndKey
	reg := rego.EndKey
	if var == "<!Escape" {
		exitVim()
		inf.Destroy()
		Exit
	}
	else if reg == "Escape" {
		StateBulb[7].Destroy()
		global normalMode := true
		inf.Destroy()
		Exit
	}
	inf.Destroy()
	infs := '"'
	infs .= reg
	inf := Infos(infs, , true)
	rego := InputHook("C")
	rego.KeyOpt("{All}", "ESI") ;End Keys & Ruppress
	rego.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	rego.Start()
	rego.Wait()
	var := rego.EndMods
	var .= rego.EndKey
	operator := rego.EndKey
	if var == "<!Escape" {
		exitVim()
		inf.Destroy()
		Exit
	}
	else if operator == "Escape" {
		StateBulb[7].Destroy()
		global normalMode := true
		inf.Destroy()
		Exit
	}
	else if (operator == "y") {
		Send "^c"
		ClipWait 1
		Sleep 10
		Registers(reg).WriteOrAppend()
	}
	else if (operator == "d") {
		Send "^x"
		ClipWait 1
		Sleep 10
		Registers(reg).WriteOrAppend()
	}
	else if (operator == "p") {
		Registers(reg).Paste()
	}
	else if (operator == "l") {
		Registers(reg).Look()
	}
	else if (operator == "m") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(reg).Move(secReg)
	}
	else if (operator == "s") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(reg).SwitchContents(secReg)
	}
	else if (operator == "x") {
		Registers(reg).Truncate()
	}
	StateBulb[7].Destroy()
	global normalMode := true
	inf.Destroy()
}
[:: Return
\:: Return
m:: {
	gotoMwMode()
	Exit
}
n:: {
	Send "^f"
	Send "{Enter}"
	Exit
}
+n:: {
	Send "^f"
	Send "+{Enter}"
	Exit
}
q:: Return
r:: {
	global normalMode := false
	StateBulb[4].Create()
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	check := ih.EndMods
	check .= ih.EndKey
	check2 := ih.EndKey
	if check == "<!Escape" {
		exitVim()
		Exit
	} else if check2 == "Escape" {
		StateBulb[4].Destroy()
		global normalMode := true
		Exit
	} else if check2 == "Backspace" {
		StateBulb[4].Destroy()
		global normalMode := true
		Exit
	} else if check2 == "Space" {
		StateBulb[4].Destroy()
		global normalMode := true
		Exit
	}
	SendText check2
	StateBulb[4].Destroy()
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
}
s:: {
	Send "{BS}"
	gotoInsert()
	Exit
}
t:: Return
z:: Return

1:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 1
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
2:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 2
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
3:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 3
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
4:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 4
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
5:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 5
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
6:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 6
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
7:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 7
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
8:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 8
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}
9:: {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += 9
	}
	infcounter.Destroy()
	infcounter := Infos(counter, , true)
}


+f:: {
	StateBulb[4].Create()
	global normalMode := false
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
			if check == "<!Escape" {
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
		if check == "<!Escape" {
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
	Send "^c"
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
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

f:: {
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
			if check == "<!Escape" {
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
		if check == "<!Escape" {
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
	Send "^c"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var)
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}


g:: {
	gotoGMode()
	Exit
}

+g:: {
	Send "^{End}"
	Exit
}

$^w:: {
	if visualMode == true {
		Exit
	}
	else {
		gotoWindowMode()
	}
	Exit
}

#t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "#t"
		}
		counter := 0
		infcounter.Destroy()
		Exit
	}
	Send "#t"
}

e:: {
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

!Esc:: {
	exitVim()
}

+c:: {
	Send "+{End}"
	Send "^x"
	gotoInsert()
	Exit
}

+d:: {
	Send "+{End}"
	Send "^x"
	Exit
}

d::
{
	if visualMode == true {
		Send "^x"
		gotoNormal()
		Exit
	}
	if counter != 0
		cvar := "" counter
	gotoDMode()
}

+^y::
{
	Send "+{WheelDown}"
}

+^e::
{
	Send "+{WheelUp}"
}

^e::
{
	Send "{WheelDown}"
}

^y::
{
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
		infcounter.Destroy()
		counter := 0
		Exit
	}
}

v:: {
	Global visualMode := true
	Send "{Left}"
	StateBulb[3].Create()
	; Infos.DestroyAll()
	; Infos("Visual Mode", 1500)
	Exit
}

+v:: {
	Send "{Home}"
	Send "+{End}"
	Global visualMode := true
	Global visualLineMode := true
	StateBulb[3].Create()
	; Infos.DestroyAll()
	; Infos("Visual Mode", 1500)
	Exit
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
		Exit
	}
}

h:: {
	global counter
	global infcounter
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "+{left}"
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
		Exit
	}
	if visualMode == true
	{
		Send "+{left}"
	}
	else
	{
		Send "{Left}"
		Send "{Left}"
		Send "+{Right}"
		Exit
	}
}

j:: {
	global counter
	if counter != 0 {
		Loop counter {
			if visualLineMode == true
			{
				Send "+{Down}"
				Send "+{End}"
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
		Exit
	}
	if visualLineMode == true
	{
		Send "+{Down}"
		Send "+{End}"
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
		Exit
	}
}

k:: {
	global counter
	if counter != 0 {
		Loop counter {
			if visualLineMode == true
			{
				Send "+{Up}"
				Send "+{Home}"
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
		Exit
	}
	if visualLineMode == true
	{
		Send "+{Up}"
		Send "+{Home}"
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
		Exit
	}
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
		Exit
	}
}

l:: {
	global counter
	if counter != 0 {
		Loop counter {
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
		counter := 0
		Exit
	}
	if visualMode == true
	{
		Send "+{Right}"
	}
	else
	{
		Send "{Left}"
		Send "{Right}"
		Send "+{Right}"
		Exit
	}
}

^!h:: {
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

^!l:: {
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

!h:: {
	Send "{Left}"
	Exit
}
!l:: {
	Send "{Right}"
	Exit
}
!j:: {
	Send "{Down}"
	Exit
}
!k:: {
	Send "{Up}"
	Exit
}

+a:: {
	Send "{end}"
	gotoInsert()
	Exit
}

+i:: {
	Send "{home}"
	gotoInsert()
	Exit
}

+j:: {
	Send "{end}{Delete}"
	Exit
}

c:: {
	if visualMode == true {
		Send "^x"
		gotoInsert()
		Exit
	}
	else {
		gotoCMode()
	}
}

x:: {
	Send "{Delete}"
	Send "+{Right}"
	Exit
}

b:: {
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

w:: {
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

O:: {
	Send "{End}"
	Send "+{Enter}"
	gotoInsert()
	Exit
}

+O:: {
	Send "{Home}"
	Send "+{Enter}{Up}"
	gotoInsert()
	Exit
}

u:: {
	Send "^z"
	Exit
}

^r:: {
	Send "^y"
	Exit
}

+y:: {
	Send "+{End}"
	Send "^c"
	Send "{Left}"
	Send "+{Right}"
	Exit
}

y:: {
	if visualMode == true {
		Send "^c"
		Exit
	}
	else {
		gotoYMode()
	}
}

+p:: {
	Send "{Left}"
	Send "^v"
	Exit
}

p:: {
	Send "{Right}"
	Send "^v"
	Exit
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

; !j:: {
; 	if visualLineMode == true
; 	{
; 		Send "+{Down}"
; 		Send "+{End}"
; 	}
; 	else if visualMode == true
; 	{
; 		Send "+{Down}"
; 	}
; 	else
; 	{
; 		Send "{Left}"
; 		Send "{Down}"
; 		Send "+{Right}"
; 		Exit
; 	}
; }

; !k:: {
; 	if visualLineMode == true
; 	{
; 		Send "+{Up}"
; 		Send "+{Home}"
; 	}
; 	else if visualMode == true
; 	{
; 		Send "+{Up}"
; 	}
; 	else
; 	{
; 		Send "{Left}"
; 		Send "{Up}"
; 		Send "+{Right}"
; 		Exit
; 	}
; }

#HotIf


#HotIf WindowManagerMode = 1
HotIf "WindowManagerMode = 1"

b:: Return
c:: Return
i:: Return
m:: Return
!f:: {
	global WasInWindowManagerMode := true
	gotoFMode()
	Exit
}
n:: Return
o:: Return
p:: Return
r:: Return
t:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
,:: Return
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

+h:: WindowManager().MoveLeft(Mouse.SmallMove)
+k:: WindowManager().MoveUp(Mouse.SmallMove)
+j:: WindowManager().MoveDown(Mouse.SmallMove)
+l:: WindowManager().MoveRight(Mouse.SmallMove)

^h:: WindowManager().MoveLeft(Mouse.BigMove)
^k:: WindowManager().MoveUp(Mouse.BigMove)
^j:: WindowManager().MoveDown(Mouse.BigMove)
^l:: WindowManager().MoveRight(Mouse.BigMove)


s:: WindowManager().DecreaseWidth(Mouse.MediumMove)
d:: WindowManager().IncreaseHeight(Mouse.MediumMove)
f:: WindowManager().DecreaseHeight(Mouse.MediumMove)
g:: WindowManager().IncreaseWidth(Mouse.MediumMove)

+s:: WindowManager().DecreaseWidth(Mouse.SmallMove)
+d:: WindowManager().IncreaseHeight(Mouse.SmallMove)
+f:: WindowManager().DecreaseHeight(Mouse.SmallMove)
+g:: WindowManager().IncreaseWidth(Mouse.SmallMove)

^s:: WindowManager().DecreaseWidth(Mouse.BigMove)
^d:: WindowManager().IncreaseHeight(Mouse.BigMove)
^f:: WindowManager().DecreaseHeight(Mouse.BigMove)
^g:: WindowManager().IncreaseWidth(Mouse.BigMove)

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

a:: WindowManager().SetFullHeight()
q:: WindowManager().SetHalfHeight()
w:: WindowManager().SetHalfWidth()
e:: WindowManager().SetFullWidth()

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

#HotIf

#HotIf mouseManagerMode = 1
HotIf "mouseManagerMode = 1"

c:: Return
r:: Return
z:: Return
.:: Return
/:: {
	Send "^f"
	gotoInsert()
	Exit
}
':: Return
[:: Return
]:: Return
\:: Return

x:: {
	Send "{BackSpace}"
}
d:: {
	Send "{Delete}"
}
y:: {
	Send "^c"
}
p:: {
	Send "^v"
}
^w:: {
	if visualMode == true {
		Exit
	}
	else {
		global WasInMouseManagerMode := true
		gotoWindowMode()
	}
	Exit
}

f:: {
	gotoFMode()
}
g:: {
	global WasInMouseManagerMode := true
	gotoGMode()
	Exit
}
i:: {
	global WasInMouseManagerMode := true
	gotoInsert()
	Exit
}
m:: {
	global WasInMouseManagerMode := true
	gotoMwMode()
	Exit
}

!h:: Send "!{Left}"
!j:: Send "!{Down}"
!k:: Send "!{Up}"
!l:: Send "!{Right}"

+h:: Mouse.MoveLeft(Mouse.MediumMove)
+k:: Mouse.MoveUp(Mouse.MediumMove)
+j:: Mouse.MoveDown(Mouse.MediumMove)
+l:: Mouse.MoveRight(Mouse.MediumMove)


Hotkey "u", ButtonAcceleration
Hotkey "o", ButtonAcceleration
Hotkey "n", ButtonAcceleration
Hotkey ",", ButtonAcceleration
Hotkey "h", ButtonAcceleration
Hotkey "j", ButtonAcceleration
Hotkey "k", ButtonAcceleration
Hotkey "l", ButtonAcceleration

hotkey "q", ButtonSpeedUp
hotkey "a", ButtonSpeedDown
hotkey "w", ButtonAccelerationSpeedUp
hotkey "s", ButtonAccelerationSpeedDown
hotkey "+q", ButtonMaxSpeedUp
hotkey "+a", ButtonMaxSpeedDown

; h:: Mouse.MoveLeft(Mouse.SmallMove)
; k:: Mouse.MoveUp(Mouse.SmallMove)
; j:: Mouse.MoveDown(Mouse.SmallMove)
; l:: Mouse.MoveRight(Mouse.SmallMove)

^h:: Mouse.MoveLeft(Mouse.BigMove)
^k:: Mouse.MoveUp(Mouse.BigMove)
^j:: Mouse.MoveDown(Mouse.BigMove)
^l:: Mouse.MoveRight(Mouse.BigMove)

t:: Click()
+t:: Click("Right")
*b:: Click("Middle")

v:: Mouse.HoldIfUp("L")
+v:: Mouse.HoldIfUp("R")
#b:: Mouse.HoldIfUp("M")

1:: MouseMove(Mouse.FarLeftX, Mouse.MiddleY)
2:: MouseMove(Mouse.HighLeftX, Mouse.MiddleY)
3:: MouseMove(Mouse.MiddleLeftX, Mouse.MiddleY)
4:: MouseMove(Mouse.LowLeftX, Mouse.MiddleY)
5:: MouseMove(Mouse.LessThanMiddleX, Mouse.MiddleY)
6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.MiddleY)
7:: MouseMove(Mouse.LowRightX, Mouse.MiddleY)
8:: MouseMove(Mouse.MiddleRightX, Mouse.MiddleY)
9:: MouseMove(Mouse.HighRightX, Mouse.MiddleY)
0:: MouseMove(Mouse.FarRightX, Mouse.MiddleY)

^1:: MouseMove(Mouse.FarLeftX, Mouse.TopY)
^2:: MouseMove(Mouse.HighLeftX, Mouse.TopY)
^3:: MouseMove(Mouse.MiddleLeftX, Mouse.TopY)
^4:: MouseMove(Mouse.LowLeftX, Mouse.TopY)
^5:: MouseMove(Mouse.LessThanMiddleX, Mouse.TopY)
^6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.TopY)
^7:: MouseMove(Mouse.LowRightX, Mouse.TopY)
^8:: MouseMove(Mouse.MiddleRightX, Mouse.TopY)
^9:: MouseMove(Mouse.HighRightX, Mouse.TopY)
^0:: MouseMove(Mouse.FarRightX, Mouse.TopY)

+1:: MouseMove(Mouse.FarLeftX, Mouse.BottomY)
+2:: MouseMove(Mouse.HighLeftX, Mouse.BottomY)
+3:: MouseMove(Mouse.MiddleLeftX, Mouse.BottomY)
+4:: MouseMove(Mouse.LowLeftX, Mouse.BottomY)
+5:: MouseMove(Mouse.LessThanMiddleX, Mouse.BottomY)
+6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.BottomY)
+7:: MouseMove(Mouse.LowRightX, Mouse.BottomY)
+8:: MouseMove(Mouse.MiddleRightX, Mouse.BottomY)
+9:: MouseMove(Mouse.HighRightX, Mouse.BottomY)
+0:: MouseMove(Mouse.FarRightX, Mouse.BottomY)

Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
}

$^e::
{
	Send "{WheelDown}"
}

$^y::
{
	Send "{WheelUp}"
}
#HotIf