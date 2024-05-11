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
#Include DoubleCtrlAltShift.ahk
#Include Functions.ahk
#Include RecordQ.ahk
#Include Info.ahk
class myGlobal {
	static zkeyCount := 0
	static lastPhoto := ""
	static counter := 0
	static monitorCount := 0
	static p_key := 0
	static visual_y := 0
	static normalMode := false
	static dMode := false
	static gMode := false
	static yMode := false
	static fMode := false
	static qMode := false
	static shiftfMode := false
	static altfMode := false
	static cMode := false
	static numlockMode := false
	static visualMode := false
	static visualLineMode := false
	static insertMode := false
	static windowMode := false
	static WindowManagerMode := false
	static mouseManagerMode := false
	static wasInNormalMode := false
	static WasInMouseManagerMode := false
	static WasInRegMode := false
	static WasInWindowManagerMode := false
	static wasInInsertMode := false
	static wasinCmdMode := false
	static recordedKeys := ""
	static recordReg := ""
	; static infcounter := Infos("")
	static infcounter := ""

	static gotoEnd() {
		Send "^{End}"
	}
	static gotoHome() {
		Send "^{Home}"
	}
	static closeTab() {
		Send "^{f4}"
	}
	static reopenTab() {
		Send "^+t"
	}
	static disableClick() {
		if GetKeyState("LButton")
			Click("L Up")
		else if GetKeyState("RButton")
			Click("R Up")
		else if GetKeyState("MButton")
			Click("M Up")
	}

	static h_motion() {
		this.counter
		this.infcounter
		this.visual_x
		if counter != 0 {
			Loop counter {
				if this.visualLineMode {
					return
				}
				if this.visualMode == true
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
			this.infcounter.Destroy()
		}
		else if this.visualMode == true
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

	static j_motion() {
		this.counter
		this.infcounter
		this.visual_y
		if counter != 0 {
			Loop counter {
				if this.visualLineMode == true
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
				else if this.visualMode == true
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
			this.infcounter.Destroy()
		}
		else if this.visualLineMode == true
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
		else if this.visualMode == true
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

	static k_motion() {
		this.counter
		this.infcounter
		this.visual_y
		if counter != 0 {
			Loop counter {
				if this.visualLineMode == true
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
				else if this.visualMode == true
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
			this.infcounter.Destroy()
		}
		else if this.visualLineMode == true
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
		else if this.visualMode == true
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

	static l_motion() {
		this.counter
		this.infcounter
		this.visual_x
		if counter != 0 {
			Loop counter {
				if this.visualLineMode {
					return
				}
				if this.visualMode == true
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
			this.infcounter.Destroy()
		}
		else if this.visualMode == true
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

	static checkj() {
		if GetKeyState("j")
		{
			SetTimer this.j_motion, 20
		}
	}

	static checkk() {
		if GetKeyState("k")
		{
			SetTimer this.k_motion, 20
		}
	}

	static checkl() {
		if GetKeyState("l")
		{
			SetTimer this.l_motion, 20
		}
	}
	static checkh() {
		if GetKeyState("h")
		{
			SetTimer this.j_motion, 20
		}
	}

	static motion(key) {
		this.p_key
		p_key := StrReplace(key, "*")
		this.motionStart()
	}

	static motionStart() {
		this.p_key
		if this.p_key == "h" {
			this.h_motion
		}
		else if this.p_key = "j" {
			this.j_motion
		}
		else if this.p_key == "k" {
			this.k_motion
		}
		else if this.p_key == "l" {
			this.l_motion
		}
		SetTimer this.motionEnd, 10
	}

	static motionEnd() {
		this.p_key
		if GetKeyState(this.p_key) {
			this.motionStart()
			return
		}
		SetTimer , 0
	}

	static reloadfunc() {
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			Infos("changing to english")
			Send "#{space}"
			Sleep 1000
			Reload
		}
		Reload
	}

	static chCounter(number, mode := "") {
		this.counter
		this.infcounter
		if counter >= 0 {
			counter *= 10
			counter += number
			text := mode counter
			infcounter.Destroy()
			infcounter := Infos(text, , true)
		}
	}

	static exitVim() {
		Infos.DestroyAll()
		Infos("Exit Vim", 1500)
		this.normalMode := false
		this.insertMode := false
		this.dMode := false
		this.wasInInsertMode := false
		this.regMode := false
		this.wasInNormalMode := false
		this.gMode := false
		this.yMode := false
		this.cMode := false
		this.fMode := false
		this.qMode := false
		this.numlockMode := false
		this.windowMode := false
		this.WindowManagerMode := false
		this.mouseManagerMode := false
		StateBulb[1].Destroy() ; Vim
		StateBulb[2].Destroy() ; Insert
		StateBulb[3].Destroy() ; Visual
		StateBulb[4].Destroy() ; Special
		StateBulb[5].Destroy() ; Move windows
		StateBulb[6].Destroy() ; Mouse Movement
		StateBulb[7].Destroy() ; mark Mode
		StateBulb[StateBulb.MaxBulbs - 1].Destroy()
		; StateBulb[4].Destroy() ; Delete
		; StateBulb[5].Destroy() ; Change
		; StateBulb[6].Destroy() ; Yank
		; StateBulb[7].Destroy() ; Window
		; StateBulb[8].Destroy() ; Fmode
		this.disableClick()
		this.clearCounter()
		this.exitVisualMode
		Exit
	}

	static gotoNumLockMode() {
		this.numlockMode := true
		this.normalMode := false
		this.mouseManagerMode := false
		StateBulb[4].Create()
	}

	static gotoWindowMode() {
		this.mouseManagerMode := false
		this.normalMode := false
		this.windowMode := true
		StateBulb[4].Create()
	}

	static gotoMwMode() {
		this.mouseManagerMode := false
		this.normalMode := false
		this.WindowManagerMode := true
		StateBulb[5].Create()
	}

	static gotoMouseMode() {
		this.monitorCount
		if monitorCount == 0 {
			monitorCount := MonitorGetCount()
		}
		else if monitorCount != MonitorGetCount() {
			this.reloadfunc()
		}
		this.normalMode := false
		this.mouseManagerMode := true
		this.WasInMouseManagerMode := false
		this.wasinCmdMode := false
		this.WasInRegMode := false
		this.WasInWindowManagerMode := false
		this.fMode := false
		StateBulb[6].Create()
		StateBulb[4].Destroy()
	}

	static gotoFMode() {
		this.normalMode := false
		this.mouseManagerMode := false
		this.fMode := true
		StateBulb[4].Create()
		this.clearCounter()
	}

	static gotoGMode() {
		this.normalMode := false
		this.gMode := true
		StateBulb[4].Create()
	}

	static gotoDMode() {
		this.normalMode := false
		this.dMode := true
		StateBulb[4].Create()
		; langid := Language.GetKeyboardLanguage()
		; if (LangID = 0x040D) {
		; 	Send "{Left}"
		; } else
		; 	Send "{Right}"
	}

	static gotoRegMode() {
		this.normalMode := false
		this.regMode := true
		StateBulb[4].Create()
	}

	static gotoYMode() {
		this.normalMode := false
		this.yMode := true
		StateBulb[4].Create()
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			Send "{Left}"
		} else
			Send "{Right}"
	}

	static gotoCMode() {
		this.normalMode := false
		this.cMode := true
		StateBulb[4].Create()
		; langid := Language.GetKeyboardLanguage()
		; if (LangID = 0x040D) {
		; 	Send "{Left}"
		; } else
		; 	Send "{Right}"
	}

	static gotoNormalnoInfo() {
		StateBulb[6].Destroy() ; Mouse Movement
		StateBulb[5].Destroy() ; Move windows
		StateBulb[4].Destroy()
		if this.visualMode == true {
			StateBulb[3].Destroy()
		}
		if this.insertMode == true {
			StateBulb[2].Destroy()
		}
		this.normalMode := true
		this.visualMode := false
		this.insertMode := false
		this.visualLineMode := false
		this.dMode := false
		this.regMode := false
		this.gMode := false
		this.cMode := false
		this.fMode := false
		this.yMode := false
		this.windowMode := false
		this.WindowManagerMode := false
		this.WasInMouseManagerMode := false
		this.wasinCmdMode := false
		this.WasInRegMode := false
		this.WasInWindowManagerMode := false
		this.mouseManagerMode := false
		StateBulb[1].Create()
	}

	static gotoNormal() {
		this.monitorCount
		if monitorCount == 0 {
			monitorCount := MonitorGetCount()
		}
		else if monitorCount != MonitorGetCount() {
			this.reloadfunc()
		}
		StateBulb[6].Destroy() ; Mouse Movement
		StateBulb[5].Destroy() ; Move windows
		StateBulb[4].Destroy()
		if this.visualMode == true {
			StateBulb[3].Destroy()
		}
		if this.insertMode == true {
			StateBulb[2].Destroy()
		}
		this.normalMode := true
		this.insertMode := false
		this.dMode := false
		this.regMode := false
		this.gMode := false
		this.cMode := false
		this.fMode := false
		this.shiftfMode := false
		this.altfMode := false
		this.yMode := false
		this.windowMode := false
		this.WindowManagerMode := false
		this.WasInMouseManagerMode := false
		this.wasinCmdMode := false
		this.WasInRegMode := false
		this.WasInWindowManagerMode := false
		this.mouseManagerMode := false
		this.clearCounter()
		this.exitVisualMode()
		StateBulb[1].Create()
	}

	static gotoVisual() {
		this.normalMode := true
		this.visualMode := true
		this.insertMode := false
		this.visualLineMode := false
		this.dMode := false
		this.regMode := false
		this.gMode := false
		this.yMode := false
		this.fMode := false
		this.cMode := false
		this.windowMode := false
		this.WindowManagerMode := false
		this.mouseManagerMode := false
		StateBulb[3].Create()
		; Infos.DestroyAll()
		; Infos("Visual Mode", 1500)
	}

	static gotoInsert() {
		StateBulb[6].Destroy() ; Mouse Movement
		StateBulb[5].Destroy() ; Move windows
		StateBulb[4].Destroy()
		if this.visualMode == true {
			StateBulb[3].Destroy()
		}
		this.normalMode := false
		this.insertMode := true
		this.dMode := false
		this.regMode := false
		this.gMode := false
		this.fMode := false
		this.yMode := false
		this.windowMode := false
		this.cMode := false
		this.WindowManagerMode := false
		this.mouseManagerMode := false
		StateBulb[2].Create()
		this.infcounter
		this.infcounter.Destroy()
		this.counter
		this.clearCounter()
		this.exitVisualMode()
	}

	static gotoInsertnoInfo() {
		StateBulb[6].Destroy() ; Mouse Movement
		StateBulb[5].Destroy() ; Move windows
		StateBulb[4].Destroy()
		if this.visualMode == true {
			StateBulb[3].Destroy()
		}
		this.normalMode := false
		this.visualMode := false
		this.insertMode := true
		this.visualLineMode := false
		this.dMode := false
		this.regMode := false
		this.gMode := false
		this.fMode := false
		this.yMode := false
		this.windowMode := false
		this.cMode := false
		this.WindowManagerMode := false
		this.mouseManagerMode := false
		StateBulb[2].Create()
	}

	static capdelChanYanFmotion() {
		StateBulb[4].Create()
		this.normalMode := false
		this.yMode := false
		this.cMode := false
		this.dMode := false
		this.counter
		this.infcounter
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
					this.exitVim()
					infcounter.Destroy()
					counter := 0
					Exit
				} else if check2 == "Escape" {
					counter := 0
					StateBulb[4].Destroy()
					this.normalMode := true
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
				this.exitVim()
				infcounter.Destroy()
				Exit
			} else if check2 == "Escape" {
				StateBulb[4].Destroy()
				this.normalMode := true
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
		Send "{Left}"
		Send "+{Right}"
		this.normalMode := true
		infcounter.Destroy()
		StateBulb[4].Destroy()
	}

	static delChanYanfMotion() {
		StateBulb[4].Create()
		this.normalMode := false
		this.yMode := false
		this.cMode := false
		this.dMode := false
		this.counter
		this.infcounter
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
					this.exitVim()
					infcounter.Destroy()
					counter := 0
					Exit
				} else if check2 == "Escape" {
					StateBulb[4].Destroy()
					this.normalMode := true
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
				this.exitVim()
				infcounter.Destroy()
				Exit
			} else if check2 == "Escape" {
				StateBulb[4].Destroy()
				this.normalMode := true
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
		; Send "{Left}"
		; Send "+{Right}"
		this.normalMode := true
		infcounter.Destroy()
		StateBulb[4].Destroy()
	}


	static capdelChanYanTMotion() {
		this.capdelChanYanFmotion()
		Send "+{Left}"
	}
	static delChanYantMotion() {
		this.delChanYanfMotion()
		Send "+{Left}"
	}

	static openMark() {
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
			this.exitVim()
			inf.Destroy()
			Exit
		}
		else if mark == "Escape" {
			StateBulb[7].Destroy()
			inf.Destroy()
			Exit
		}
		Registers.ValidateKey(mark)
		; try win_id := Marks.MarkA.%mark%
		try {
			win_id := Marks.Read(mark)
		}
		catch {
			Infos("Mark " mark " was not set", 2000)
			StateBulb[7].Destroy()
			inf.Destroy()
			Exit
		}
		WinActivate(Integer(win_id))
		StateBulb[7].Destroy()
		inf.Destroy()
	}

	static saveMark() {
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
			this.exitVim()
			inf.Destroy()
		}
		else if mark == "Escape" {
			StateBulb[7].Destroy()
			inf.Destroy()
			Exit
		}
		Registers.ValidateKey(mark)
		actw := WinExist("A")
		Marks.Pushindex(mark)
		Marks.MarkA.%mark% := actw
		; Infos(Type(actw))
		Marks.Write(actw, mark)
		StateBulb[7].Destroy()
		inf.Destroy()
	}
	static insertReg() {
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
			this.exitVim()
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

	static saveReg() {
		inf := Infos('"', , true)
		StateBulb[7].Create()
		markgi := GetInput("L1", "{esc}{space}{Backspace}")
		mark := markgi.Input
		if mark = "" {
			StateBulb[7].Destroy()
			inf.Destroy()
			Exit
		}
		mark := markgi.EndKey
		var := markgi.EndMods
		var .= markgi.EndMods
		if var == "<!``" {
			this.exitVim()
			inf.Destroy()
		}
		else if mark == "Escape" {
			StateBulb[7].Destroy()
			inf.Destroy()
			Exit
		}
		inf.Destroy()
		infs := '"'
		infs .= mark
		inf := Infos(infs, , true)
		operator := GetInput("L1", "{esc}{space}{Backspace}").Input
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
	static setMouseDefSpeed() {
		Mouse.SmallMove := 20
		Mouse.MediumMove := 70
		Mouse.BigMove := 200
	}

	static backspaceCounter() {
		this.counter
		this.infcounter
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

	static innerword() {
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

	static clearCounter() {
		this.counter := 0
		this.infcounter
		this.infcounter.Destroy()
	}

	static bmotion() {
		this.counter
		this.infcounter
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			if this.counter != 0 {
				Loop this.counter {
					Send "^+{Right}"
				}
			}
			else {
				Send "^+{Right}"
			}
		}
		else if this.counter != 0 {
			Loop this.counter {
				Send "^+{Left}"
			}
		}
		else {
			Send "^+{Left}"
		}
	}

	static wmotion() {
		langid := Language.GetKeyboardLanguage()
		if (LangID = 0x040D) {
			if this.counter != 0 {
				Loop this.counter {
					Send "^+{Left}"
				}
			} else {
				Send "^+{Left}"
			}
		}
		else if this.counter != 0 {
			if this.visualLineMode {
				Exit
			}
			Loop this.counter {
				Send "^+{Right}"
			}
		}
		else {
			Send "^+{Right}"
		}
	}

	static emotion() {
		this.counter
		if this.counter != 0 {
			Loop this.counter {
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


	static findEndLine() {
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

	static search() {
		Send "^f"
	}
	static nextSearch() {
		Send "^f"
		Send "{Enter}"
	}
	static prevSearch() {
		Send "^f"
		Send "+{Enter}"
	}

	static exitVisualMode() {
		this.visualLineMode := false
		this.visualMode := false
		this.visual_y := 0
		this.visual_x := 0
	}


	static StartRecordingKey(key) {
		this.recordedKeys .= key
	}
	static StopRecordingKey() {
		this.recordedKeys
		this.recordReg
		RecordQ.Write(this.recordedKeys, this.recordReg)
	}

	static alwaysOnTop() {
		WinSetAlwaysOnTop -1, "A"
		Title_When_On_Top := "! "       ; change title "! " as required
		t := WinGetTitle("A")
		ExStyle := WinGetExStyle(t)
		if (ExStyle & 0x8) {            ; 0x8 is WS_EX_TOPMOST
			WinSetAlwaysOnTop 0, t      ; Turn OFF and remove Title_When_On_Top
			WinSetTitle (RegexReplace(t, Title_When_On_Top)), "A"
		} else {
			WinSetAlwaysOnTop 1, t      ; Turn ON and add Title_When_On_Top
			WinSetTitle Title_When_On_Top . t, t
		}
	}

	static checkDir() {
		if !DirExist(Registers.RegistersDirectory) {
			DirCreate(Registers.RegistersDirectory)
			Info("missing registers directory added")
		}
		if !DirExist(Marks.MarksDirectory) {
			DirCreate(Marks.MarksDirectory)
			Info("missing marks directory added")
		}
		if !DirExist(MouseMarks.MouseMarksDirectory) {
			DirCreate(MouseMarks.MouseMarksDirectory)
			Info("missing mouse marks directory added")
		}
		if !DirExist(RecordQ.RegistersDirectory) {
			DirCreate(MouseMarks.RegistersDirectory)
			Info("missing recording registers directory added")
		}
	}
}