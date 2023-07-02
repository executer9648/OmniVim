#Include operator.ahk
#Include vimInfo.ahk
#Include manager.ahk
#Include Language.ahk

class motion {
	static directionCounter := 0
	static w_motion(counter := 0, opr := operator(), ishelper := false) {
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			langid := Language.GetKeyboardLanguage()
			if (LangID = 0x040D) {
				Send "^+{Left}"
			}
			else {
				Send "^+{Right}"
			}
		}

		; opr action
		if ishelper or manager.visualMode {
			return
		}
		else if !opr.isSuper {
			opr.action()
		}
		else {
			Send "{Right}"
			Send "+{Right}"
		}
	}
	static b_motion(counter := 0, opr := operator(), ishelper := false) {
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			langid := Language.GetKeyboardLanguage()
			if (LangID = 0x040D) {
				Send "^+{Righ}"
			}
			else {
				Send "^+{Left}"
			}
		}

		; opr action
		if ishelper or manager.visualMode {
			return
		}
		else if !opr.isSuper {
			opr.action()
		}
		else {
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static e_motion(counter := 0, opr := operator()) {
		motion.w_motion(counter, , true)
		Send "+{Left}"

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
		return
	}
	static ge_motion(counter := 0, opr := operator()) { ; need further testing !todo
		motion.b_motion(counter, , true)
		Send "+{Left}"

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static f_motion(counter := 0, opr := operator()) {
		if counter == 0
			counter := 1
		var := manager.getkey(counter)
		if var == "exitVim"
			return "exitVim"
		else if var == "cancel"
			return "cancel"
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
			Send "+{Right}"
		}

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
		return "cancel"
	}

	static shift_f_motion(counter := 0, opr := operator()) {
		if counter == 0
			counter := 1
		var := manager.getkey(counter)
		if var == "exitVim"
			return "exitVim"
		else if var == "cancel"
			return "cancel"
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "{Left}"
		Send "+{Home}"
		Send "^c"
		Send "{Right}"
		ClipWait 1
		Haystack := A_Clipboard
		FoundPos := InStr(Haystack, var, false, -1)
		loop FoundPos {
			Send "+{Left}"
		}

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Left}"
			Send "+{Right}"
		}
		return "cancel"
	}
	static h_motion(counter := 0, opr := operator(), ishelper := false) {
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "+{Left}"
		}

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static j_motion(counter := 0) {
		if manager.visualLineMode == true
			this.directionCounter -= 1
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "+{Down}"
		}
		if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static k_motion(counter := 0) {
		if manager.visualLineMode == true {
			this.directionCounter += 1
			if this.directionCounter > 0 {
				Send "{end}"
				Send "+{home}"
			}

		}
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "+{Up}"
		}
		if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static l_motion(counter := 0, opr := operator()) {
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "+{Right}"
		}

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static n_motion(counter := 0) {
		Send "^f"
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "{Enter}"
		}
	}
	static shift_n_motion(counter := 0) {
		Send "^f"
		if counter == 0 {
			counter := 1
		}
		Loop counter {
			Send "+{Enter}"
		}
	}
	static n0_motion(opr := operator()) {
		Send "+{Home}"

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static n4_motion(opr := operator()) {
		Send "+{End}"

		; opr action
		if !opr.isSuper {
			opr.action()
		}
		else if manager.visualMode {
			return
		}
		else {
			Send "{Right}"
			Send "{Left}"
			Send "+{Right}"
		}
	}
	static i_motion(opr := operator()) {
		this.inner()
		if manager.visualMode
			return
		opr.action()
	}

	static inner() {
		Send "^{Left}"
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
	}
}