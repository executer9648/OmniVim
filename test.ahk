#Requires AutoHotkey v2.0
#Include TapHoldManager.ahk
#SingleInstance force

#SingleInstance force
#MaxThreadsBuffer True
#MaxThreads 255
#MaxThreadsPerHotkey 255
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
#MaxThreadsBuffer True
#MaxThreads 255
#MaxThreadsPerHotkey 255

thm := TapHoldManager()
thm.Add("Lctrl", MyFunc1)
; thm.Add("2", MyFunc2, 250, 500, 2, , "ahk_exe notepad.exe")


MyFunc1(isHold, taps, state) {
	if (state == 0)
		Send "{LCtrl Up}"
	if (isHold) {
		; Holds
		if (taps == 1) {
			Send "{Lctrl down}"
			if GetKeyState('Lctrl', 'p') == 0
				Send "{LCtrl Up}"
		}
	} else {
		; Taps
		if (taps == 1) {
			SendLevel 1
			SendEvent "{Esc}"
			MsgBox "esc"
		}
	}
}