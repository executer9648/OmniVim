#SingleInstance force
#MaxThreadsBuffer True
#MaxThreads 255
#MaxThreadsPerHotkey 255
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
InstallKeybdHook

A_HotkeyInterval := 0
A_MenuMaskKey := "vkFF"

SetMouseDelay -1
CoordMode "Mouse", "Screen"

$CapsLock::Control
+!#Control::CapsLock

#HotIf WinActive("A")
; ~Alt:: Send "{Blind}{vkE8}"
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

~Alt:: Send "{Blind}{vkFF}"
; ; #InputLevel 1
; ; LAlt:: SendEvent "h"
; ; #InputLevel 0
; ; h & j:: MsgBox "works"

Info("Script Reloaded-Active", 2000)

+^#r:: {
	Reload
}
#SuspendExempt
+^#s:: {
	if A_IsSuspended {
		Info("Script Resumed", 2000)
	}
	else {
		Info("Script Suspended", 2000)
	}
	Suspend  ; Ctrl+Alt+S
}
#SuspendExempt False
+#e:: Edit
^#h:: Send "^#{Left}"
^#l:: Send "^#{Right}"

+#h:: Send "+#{Left}"
+#j:: Send "+#{Down}"
+#k:: Send "+#{Up}"
+#l:: Send "+#{Right}"

^!h:: Send "{Left}"
^!j:: Send "{Down}"
^!k:: Send "{Up}"
^!l:: Send "{Right}"

^!n:: {
	gotoNumLockMode()
}

; Set initial state to normal (disabled)
global counter := 0
global monitorCount := 0
global p_key := 0
global normalMode := false
global dMode := false
global gMode := false
global yMode := false
global fMode := false
global shiftfMode := false
global cMode := false
global numlockMode := false
global visualMode := false
global visualLineMode := false
global insertMode := false
global windowMode := false
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
; Info("Script Active", 2)

chCounter(number, mode := "") {
	global counter
	global infcounter
	if counter >= 0 {
		counter *= 10
		counter += number
	}
	text := mode counter
	infcounter.Destroy()
	infcounter := Infos(text, , true)
}

exitVim() {
	Infos.DestroyAll()
	Infos("Exit Vim", 1500)
	Global normalMode := false
	Global insertMode := false
	global dMode := false
	global wasInInsertMode := false
	global regMode := false
	global wasInNormalMode := false
	global gMode := false
	global yMode := false
	global cMode := false
	global fMode := false
	global numlockMode := false
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
		Reload
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
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
	} else
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
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
	} else
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
	global monitorCount
	if monitorCount == 0 {
		monitorCount := MonitorGetCount()
	}
	else if monitorCount != MonitorGetCount() {
		Reload
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
	global visualMode := false
	global insertMode := false
	global visualLineMode := false
	global dMode := false
	global regMode := false
	global gMode := false
	global cMode := false
	global fMode := false
	global shiftfMode := false
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
	global infcounter
	infcounter.Destroy()
	global counter
	counter := 0
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

;numlock replacer
#HotIf numlockMode = 1
HotIf "numlockMode = 1"

Esc:: {
	if WasInMouseManagerMode == true {
		gotoNormal()
		gotoMouseMode()
	}
	else if wasInInsertMode {
		gotoInsert()
	}
	else {
		gotoNormal()
	}
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
		gotoMouseMode()
	}
	StateBulb[4].Destroy() ; Special
	global numlockMode := false
}

!Esc:: {
	exitVim()
	Exit
}

u:: Send "4"
i:: Send "5"
o:: Send "6"
j:: Send "1"
k:: Send "2"
l:: Send "3"
,:: Send "0"
m:: Send "0"
n:: Send "0"

; l::
; RAlt:: Send "."
; space:: {
; 	Send "0"
; }
; n:: {
; 	Send "1"
; }
; m:: {
; 	Send "2"
; }
; ,:: {
; 	Send "3"
; }
; h:: {
; 	Send "4"
; }
; j:: {
; 	Send "5"
; }
; k:: {
; 	Send "6"
; }
; y:: {
; 	Send "7"
; }
; u:: {
; 	Send "8"
; }
; i:: {
; 	Send "9"
; }
; 7:: Send "/"
; 8:: Send "*"
; 9:: Send "-"

#HotIf
; f mode
#HotIf fMode = 1
HotIf "fMode = 1"

if MonitorGetPrimary() != 1 {
	secondM := -A_ScreenWidth
}
else {
	secondM := A_ScreenWidth
}

`:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.x1 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x2 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x3 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x4 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x5 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x6 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x7 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x8 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x9 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x10 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x11 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x12 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x13 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x14 + secondM, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	else {
		MouseMove(Mouse.x14, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}

tab:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.x1 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else {
		MouseMove(Mouse.x1, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
q:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x2, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.x2 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
	}
	else {
		MouseMove(Mouse.x2, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
w:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x3, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else if shiftfMode {
		MouseMove(Mouse.x3 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x4 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x5 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x6 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x7 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x8 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x9 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x10 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x11 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x12 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x13 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.x14 + secondM, Mouse.tabCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax1 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax2 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax3 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax4 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax5 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax6 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax7 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax8 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax9 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax10 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax11 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax12 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.ax13 + secondM, Mouse.capsCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx1 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx2 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx3 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx4 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx5 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx6 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx7 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx8 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx9 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx10 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx11 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.zx12 + secondM, Mouse.shiftCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx1 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx2 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx3 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx4 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx5 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
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
	else if shiftfMode {
		MouseMove(Mouse.sx6 + secondM, Mouse.spaceCol)
		gotoNormal()
		gotoMouseMode()
	}
	else {
		MouseMove(Mouse.sx6, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}

Esc:: {
	gotoNormal()
	gotoMouseMode()
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
^w:: Return
^e:: Return

!Esc:: {
	exitVim()
	Exit
}
BackSpace:: {
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

Esc:: {
	global infcounter
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
		infcounter.Destroy()
	}
	else {
		gotoNormal()
		infcounter.Destroy()
	}
	Exit
}
*q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^{f4}"
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
	Send "^{f4}"
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

BackSpace:: {
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
Esc:: {
	global infcounter
	gotoNormal()
	infcounter.Destroy()
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
	Send "^c"
	Exit
}


y:: {
	global infcounter
	Send "+{Home}"
	Send "^c"
	ClipWait 1
	var1 := A_Clipboard
	Send "{Right}"
	Send "+{End}"
	Send "^c"
	ClipWait 1
	var2 := A_Clipboard
	Send "{Left}"
	Send "+{Right}"
	A_Clipboard := var1 var2
	gotoNormal()
	infcounter.Destroy()
	Exit
}

b:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Right}"
			}
			counter := 0
		}
		else {
			Send "^+{Right}"
		}
		Send "^c"
		Send "{Left}"
		Send "+{right}"
		gotoNormal()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Left}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Left}"
	}
	Send "^c"
	Send "{right}"
	Send "{Left}"
	Send "+{right}"
	gotoNormal()
	infcounter.Destroy()
	Exit
}

w:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Left}"
			}
			counter := 0
		} else {
			Send "^+{Left}"
		}
		Send "^c"
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
		gotoNormal()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Right}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Right}"
	}
	Send "^c"
	Send "{Left}"
	Send "+{right}"
	gotoNormal()
	infcounter.Destroy()
	Exit
}

0::
{
	global counter
	if counter != 0 {
		chCounter(0, "y")
	}
	else {
		Send "+{home}"
		Send "^c"
		gotoNormal()
		Exit
	}
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
BackSpace:: {
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
Esc:: {
	global infcounter
	gotoNormal()
	infcounter.Destroy()
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
	infcounter.Destroy()
	gotoInsert()
	Exit
}

c:: {
	global infcounter
	Send "{Home}+{End}"
	Send "^x"
	gotoInsert()
	infcounter.Destroy()
	Exit
}

b:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Right}"
			}
			counter := 0
		}
		else {
			Send "^+{Right}"
		}
		Send "^x"
		Send "{Left}"
		Send "+{right}"
		gotoInsert()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Left}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Left}"
	}
	Send "^x"
	Send "{right}"
	Send "{Left}"
	Send "+{right}"
	gotoInsert()
	infcounter.Destroy()
	Exit
}

w:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Left}"
			}
			counter := 0
		} else {
			Send "^+{Left}"
		}
		Send "^x"
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
		gotoInsert()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Right}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Right}"
	}
	Send "^x"
	Send "{Left}"
	Send "+{right}"
	gotoInsert()
	infcounter.Destroy()
	Exit
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
		Exit
	}
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
	global WasInMouseManagerMode
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
	global WasInMouseManagerMode
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
	global WasInMouseManagerMode
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

BackSpace:: {
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
Esc:: {
	global WasInMouseManagerMode
	global infcounter
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
		infcounter.Destroy()
	}
	else {
		gotoNormal()
		infcounter.Destroy()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
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

BackSpace:: {
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
Esc:: {
	global infcounter
	gotoNormal()
	infcounter.Destroy()
}

!Esc:: {
	exitVim()
	Exit
}

d:: {
	global infcounter
	Send "{Home}+{End}"
	Send "^x"
	Send "{Delete}"
	gotoNormal()
	infcounter.Destroy()
	Exit
}

b:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Right}"
			}
			counter := 0
		}
		else {
			Send "^+{Right}"
		}
		Send "^x"
		Send "{Left}"
		Send "+{right}"
		gotoNormal()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Left}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Left}"
	}
	Send "^x"
	Send "{right}"
	Send "{Left}"
	Send "+{right}"
	gotoNormal()
	infcounter.Destroy()
	Exit
}

w:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
		if counter != 0 {
			Loop counter {
				Send "^+{Left}"
			}
			counter := 0
		} else {
			Send "^+{Left}"
		}
		Send "^x"
		Send "{right}"
		Send "{Left}"
		Send "+{right}"
		gotoNormal()
		infcounter.Destroy()
		Exit
	}
	else if counter != 0 {
		Send "{Left}"
		Loop counter {
			Send "^+{Right}"
		}
		counter := 0
	}
	else {
		Send "{Left}"
		Send "^+{Right}"
	}
	Send "^x"
	Send "{Left}"
	Send "+{right}"
	gotoNormal()
	infcounter.Destroy()
	Exit
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
		Exit
	}
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoNormal()
	Exit
}

#HotIf


; insert Mode
#HotIf insertMode = 1
HotIf "insertMode = 1"

^!n:: {
	global wasInInsertMode := true
	gotoNumLockMode()
}

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
	Sleep 10
	Send "{BS}"
	Exit
}

^x:: {
	Send "+{Home}"
	Sleep 10
	Send "{BS}"
	Exit
}

^k:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "+{Home}"
		Sleep 10
		Send "{bs}"
	}
	else {
		Send "+{end}"
		Sleep 10
		Send "{bs}"
	}
}
^w:: {
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
	Exit
}

^a:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{End}"
	}
	else {
		Send "{Home}"
	}
}

^e:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Home}"
	}
	else {
		Send "{End}"
	}
}

^b:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Right}"
	}
	else {
		Send "{Left}"
	}
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
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "{Left}"
	}
	else {
		Send "{Right}"
	}
}

!l:: {
	Send "{Right}"
	Exit
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
	Exit
}

+!f:: {
	Send "^+{Right}"
	Exit
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

z & =:: {
	Send "{Left}"
	Send "+{f10}"
}

!+a:: {
	Send "!+a"
	gotoInsert()
}

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
^!n:: {
	global wasInNormalMode := true
	gotoNumLockMode()
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

; hotkey "h", motion
; hotkey "j", motion
; hotkey "k", motion
; hotkey "l", motion

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
	Exit
}
+x:: {
	Send "{bs}"
	Send "{Left}"
	Send "+{Right}"
	Exit
}

$b:: {
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

$w:: {
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
	Sleep 10
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
	global counter
	global infcounter
	if visualMode == true {
		Send "^c"
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
	Send "^v"
	Exit
}

p:: {
	if visualMode == true {
		Send "v"
		Exit
	}
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

m::
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

^!n:: {
	global WasInMouseManagerMode := true
	gotoNumLockMode()
}
~!+a:: {
	global WasInMouseManagerMode := true
	global infcounter
	infcounter.Destroy()
	disableClick()
	gotoInsert()
}

r:: Return
z:: Return
.:: Return
/:: {
	Send "^f"
	disableClick()
	gotoInsert()
	Exit
}
':: Return
[:: Return
]:: Return
\:: Return
+G:: {
	Send "{End}"
}

x:: {
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
	Send "^c"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
p:: {
	Send "^v"
	if GetKeyState("LButton")
		Click("L Up")
	else if GetKeyState("RButton")
		Click("R Up")
	else if GetKeyState("MButton")
		Click("M Up")
}
^w:: {
	if visualMode == true {
		Exit
	}
	else {
		global WasInMouseManagerMode := true
		disableClick()
		gotoWindowMode()
	}
	Exit
}

f:: {
	gotoFMode()
}
+f:: {
	global shiftfMode := true
	gotoFMode()
}
g:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoGMode()
	Exit
}
i:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Exit
}
m:: {
	global WasInMouseManagerMode := true
	disableClick()
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

+u:: {
	Send "^z"
}
^r:: {
	Send "^y"
}

t:: Click()
!t:: Click("Right")
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
+!t:: {
	Send "{Shift Up}"
	Click("Right")
	Send "{Shift Down}"
}
^!t:: {
	Send "{ctrl Up}"
	Click("Right")
	Send "{ctrl Down}"
}
b:: Click("Middle")

v:: Mouse.HoldIfUp("L")
!v:: Mouse.HoldIfUp("R")
+b:: Mouse.HoldIfUp("M")

Hotkey "u", ButtonAcceleration
Hotkey "o", ButtonAcceleration
Hotkey "n", ButtonAcceleration
Hotkey ",", ButtonAcceleration
Hotkey "h", ButtonAcceleration
Hotkey "j", ButtonAcceleration
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

; Esc:: {
; 	gotoNormal()
; 	Exit
; }

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
	}
}

j_motion()
{
	global counter
	global infcounter
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
		infcounter.Destroy()
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
	}
}

k_motion() {
	global counter
	global infcounter
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
		infcounter.Destroy()
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
	}
}

l_motion() {
	global counter
	global infcounter
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
		infcounter.Destroy()
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
	}
}

checkj() {
	if GetKeyState("j")
	{
		SetTimer j_motion, 20
	}
}

checkk() {
	if GetKeyState("k")
	{
		SetTimer k_motion, 20
	}
}

checkl() {
	if GetKeyState("l")
	{
		SetTimer l_motion, 20
	}
}
checkh() {
	if GetKeyState("h")
	{
		SetTimer j_motion, 20
	}
}

motion(key) {
	global p_key
	p_key := StrReplace(key, "*")
	motionStart()
}

motionStart() {
	global p_key
	if p_key == "h" {
		h_motion
	}
	if p_key = "j" {
		j_motion
	}
	if p_key == "k" {
		k_motion
	}
	if p_key == "l" {
		l_motion
	}
	SetTimer motionEnd, 100
}

motionEnd() {
	global p_key
	if GetKeyState(p_key, "P") {
		motionStart()
	}
}