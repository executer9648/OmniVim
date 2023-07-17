#Requires AutoHotkey v2.0
#Include TapHoldManager.ahk
#SingleInstance force
thm := TapHoldManager()
thm.Add("Lctrl", MyFunc1)
; thm.Add("2", MyFunc2, 250, 500, 2, , "ahk_exe notepad.exe")


MyFunc1(isHold, taps, state) {
	if (!state)
		thm.ResumeHotkey("Lctrl")
	if (isHold) {
		; Holds
		if (taps == 1) {
			thm.PauseHotkey("Lctrl")
		} else if (taps == 2) {
			msgbox "taps 2H"
		}
	} else {
		; Taps
		if (taps == 1) {
			msgbox "taps 1"
		} else if (taps == 2) {
			msgbox "taps 2"
		}
	}
}


; MyFunc2(isHold, taps, state) {
; 	ToolTip "key: 2`n" (isHold ? "HOLD" : "TAP") "`nTaps: " taps "`nState: " state
; }

; $F1:: ; pause hotkey "2"
; {
; 	thm.PauseHotkey("2")
; }

; $F2:: ; resume hotkey "2"
; {
; 	thm.ResumeHotkey("2")
; }

; $F3:: ; remove hotkey "2"
; {
; 	thm.RemoveHotkey("2")
; }
