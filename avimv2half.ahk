#SingleInstance force
#MaxThreadsBuffer true
#MaxThreads 250
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
#Include TapHoldManager.ahk
#Requires AutoHotkey v2.0

InstallKeybdHook
; InstallMouseHook

; XButton1 & LButton::+LButton

A_HotkeyInterval := 0
A_MaxHotkeysPerInterval := 9999
A_MenuMaskKey := "vkFF"

SetMouseDelay -1
CoordMode "Mouse", "Screen"

$CapsLock::LCtrl
+!#Control::CapsLock

#HotIf WinActive("A")
~Alt:: Send "{Blind}{vkE8}"
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

Info("Script Reloaded-Active", 2000)

reloadfunc() {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Infos("changing to english")
		Send "#{space}"
		Sleep 1000
		Reload
	}
	Reload
}

+^#e:: Edit
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
	Suspend  ; Ctrl+Alt+S
}
#SuspendExempt False
^#h:: Send "^#{Left}"
^#l:: Send "^#{Right}"

+#h:: Send "+#{Left}"
+#j:: Send "+#{Down}"
+#k:: Send "+#{Up}"
+#l:: Send "+#{Right}"
; `(tilda) SECTION =================
^`::CapsLock
`::`
; !`::!`
~!`:: return
` & h::Left
` & k::Up
` & j::Down
` & l::Right
` & y::WheelUp
` & e::WheelDown
` & g:: {
	if GetKeyState("Shift")
		Send "{End}"
	else
		Send "{Home}"
}

; TAB SECTION =================
tab::Tab
tab & `:: exitVim()
tab & ,:: {
	Send "^{Home}"
}
tab & .:: {
	Send "^{End}"
}
Tab & b:: {
	if GetKeyState("ctrl")
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
	if GetKeyState("ctrl")
		Send "^{Right}"
	else
		Send "{Right}"
}
Tab & a::Home
Tab & g:: {
	if GetKeyState("ctrl")
		Send "^{End}"
	else
		Send "^{Home}"
}
Tab & x:: {
	if GetKeyState("ctrl")
		Send "^+t"
	else
		Send "^{f4}"
}
Tab & r:: {
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
	MsgBox var
	if var == "<!``" {
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
Tab & s::^f
Tab & =::+f10
Tab & d:: {
	if GetKeyState("ctrl")
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
; tab & y::WheelUp
; tab & e::WheelDown
tab & e::End

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
global altfMode := false
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
		text := mode counter
		infcounter.Destroy()
		infcounter := Infos(text, , true)
	}
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
	disableClick()
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
	global visualMode := false
	global insertMode := false
	global visualLineMode := false
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

;numlock replacer
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
	global counter
	global monitorCount
	global infcounter
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
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

!`:: {
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
	global WasInMouseManagerMode
	global wasInNormalMode
	if (WasInMouseManagerMode == true) {
		gotoNormal()
		gotoMouseMode()
		infcounter.Destroy()
	}
	else if (wasInNormalMode == true) {
		gotoNormal()
		infcounter.Destroy()
	}
	else {
		global wasInNormalMode := false
		global WindowManagerMode := false
		global counter := 0
		Infos.DestroyAll()
		StateBulb[4].Destroy() ; Special
		disableClick()
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

!`:: {
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
	A_Clipboard := ""
	Send "+{Home}"
	Send "^c"
	ClipWait 1
	var1 := A_Clipboard
	A_Clipboard := ""
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

!`:: {
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
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Home}+{End}"
	Send "^c"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := 0
	pattern := "[\p{P}a-zA-Z0-9\.*?+[{|()^$\s\r\n`r`n`s]"
	FoundPos := RegExMatch(Haystack, pattern, , -1)
	; MsgBox FoundPos
	if FoundPos == 0
	{
		Send "+{End}"
	}
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
		Send "^{Home}"
		gotoNormal()
		gotoMouseMode()
	}
	else {
		Send "^{Home}"
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

!`:: {
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

!`:: {
	exitVim()
	Exit
}

d:: {
	global infcounter
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Home}+{End}"
	Send "^c"
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
		sleep 100
		Send "^x"
		infcounter.Destroy()
		gotoNormal()
	}
	else {
		loop FoundPos {
			Send "+{Right}"
		}
		Send "+{Left}"
		sleep 100
		Send "^x"
		Send "{delete}"
		infcounter.Destroy()
		gotoNormal()
	}
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
	if var == "<!``" {
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

!`:: {
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
		Exit
	}
	Send "^+{Left}"
	Sleep 10
	Send "{bs}"
	Exit
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
#HotIf


; normal Mode
#HotIf normalMode = 1
HotIf "normalMode = 1"

Z & Q:: {
	Send "!{f4}"
}
Z & Z:: {
	Send "!{f4}"
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
	reg := GetInput("L1", "{esc}{space}{Backspace}").Input
	if reg = "" {
		StateBulb[7].Destroy()
		global normalMode := true
		inf.Destroy()
		Exit
	}

	inf.Destroy()
	infs := '"'
	infs .= reg
	inf := Infos(infs, , true)

	operator := GetInput("L1", "{esc}{space}{Backspace}").Input

	if (operator == "y") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait 1
		Sleep 10
		Registers(reg).WriteOrAppend()
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
		Registers(reg).WriteOrAppend()
		A_Clipboard := oldclip
	}
	else if (operator == "p") {
		Registers(reg).Paste()
		Sleep 10
		Send "{right}"
		Send "{left}"
		Send "+{Right}"
	}
	else if (operator == "l") {
		Registers(reg).Look()
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "m") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(reg).Move(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "s") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(reg).SwitchContents(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "x") {
		Registers(reg).Truncate()
		Send "{Left}"
		Send "+{Right}"
	}
	StateBulb[7].Destroy()
	global normalMode := true
	global visualLineMode := false
	global visualMode := false
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
	secReg := GetInput("L1", "{esc}{space}{Backspace}").Input
	SendText secReg
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
		wasInNormalMode := true
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

!`:: {
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

$+^y::
{
	Send "^{WheelDown}"
}
$+^e::
{
	Send "^{WheelUp}"
}

^e:: {
	Send "{WheelDown}"
}

^y:: {
	Send "{WheelUp}"
}

^esc:: {
	global normalMode := false
	StateBulb[4].Create()
	key := GetInput("ML1", "").Input
	; MsgBox key
	Send key
	StateBulb[4].Destroy()
	global normalMode := true
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
	global visualMode
	Global visualLineMode
	if visualMode == true {
		gotoNormal()
		Exit
	}
	Global visualMode := true
	Send "{Left}"
	StateBulb[3].Create()
	Exit
}

+v:: {
	Send "{Home}"
	Send "+{End}"
	Global visualMode := true
	Global visualLineMode := true
	StateBulb[3].Create()
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
	Sleep 10
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
	sleep 10
	Send "^v"
	Exit
}

p:: {
	if visualMode == true {
		Send "^v"
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

!`:: {
	exitVim()
	Exit
}

#HotIf

#HotIf mouseManagerMode = 1
HotIf "mouseManagerMode = 1"

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

!h::!Left
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


Z & Z:: {
	Send "!{f4}"
}
Z & Q:: {
	Send "!{f4}"
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
	inf := Infos('"', , true)
	global mouseManagerMode := false
	StateBulb[7].Create()
	rego := InputHook("C")
	rego.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	rego.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	rego.Start()
	rego.Wait()
	var := rego.EndMods
	var .= rego.EndKey
	reg := rego.EndKey
	if var == "<!``" {
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
	if var == "<!``" {
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
	global mouseManagerMode := true
	inf.Destroy()
}


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
	Exit
}
+/:: return
^/:: return
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
!f:: {
	global altfMode := true
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
a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Exit
}
^a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{Home}"
	Exit
}
+i:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{Home}"
	Exit
}
+a:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoInsert()
	Send "{End}"
	Exit
}
m:: {
	global WasInMouseManagerMode := true
	disableClick()
	gotoMwMode()
	Exit
}

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
; !,::{
; 	ButtonAcceleration('^,')
; }
; !n::{
; 	ButtonAcceleration('^n')
; }
; !o::{
; 	ButtonAcceleration('^o')
; }
; !u::{
; 	ButtonAcceleration('^u')
; }
; !h::{
; 	ButtonAcceleration('^h')
; }
; !j::{
; 	ButtonAcceleration('^j')
; }
; !k::{
; 	ButtonAcceleration('^k')
; }
; !l::{
; 	ButtonAcceleration('^l')
; }


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

; !Esc:: {
; 	exitVim()
; }
!`:: {
	exitVim()
}
Esc:: {
	global infcounter
	global counter
	if counter == 0
		Send "{Esc}"
	infcounter.Destroy()
	counter := 0
	Exit
}
^esc:: {
	global mouseManagerMode := false
	StateBulb[4].Create()
	key := GetInput("ML1", "").Input
	MsgBox key
	; MsgBox A_ThisHotkey
	if A_ThisHotkey == "~LAlt"
	{
		Send "{LAlt Down}%key%{LAlt Up}"
	}
	Send key
	StateBulb[4].Destroy()
	global mouseManagerMode := true
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

!^y::
{
	Send "^{WheelUp}"
	Exit
}

!^e::
{
	Send "^{WheelDown}"
	Exit
}
+^y::
{
	Send "+{WheelDown}"
	Exit
}

+^e::
{
	Send "+{WheelUp}"
	Exit
}
^e:: {
	; active_id := WinGetID("A")
	; ControlSend "{WheelDown}", active_id
	Send "{WheelDown}"
}
^y:: {
	; active_id := WinGetID("A")
	; ControlSend "{WheelUp}", active_id
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
	else if p_key = "j" {
		j_motion
	}
	else if p_key == "k" {
		k_motion
	}
	else if p_key == "l" {
		l_motion
	}
	SetTimer motionEnd, 10
}

motionEnd() {
	global p_key
	if GetKeyState(p_key) {
		motionStart()
		return
	}
	SetTimer , 0
}