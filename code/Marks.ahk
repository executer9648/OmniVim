#Include Array.ahk
#Include MouseWindowH.ahk
class Marks {
	static MarkA := {}
	static MarkIndex := []
	static Sessions := {}
	static sessionNames := []
	static mouseWindows := []
	static recording := false
	static MarksDirectory := "C:\OmniVim\Marks"
	static _session := ""

	static GetPath(key) => Marks.MarksDirectory "\mark_" key ".txt"

	static __TryGetMarkText(path) {
		if FileExist(path)
			text := ReadFile(path)
		else
			text := ""
		return text
	}

	static Read(key) {
		path := Marks.GetPath(key)
		return this.__TryGetMarkText(path)
	}

	/**
	 * Write the contents of your clipboard to a register
	 */
	static Write(text, key) {
		path := Marks.GetPath(key)
		WriteFile(path, text)
		Info(key " window mark written", Registers.InfoTimeout)
	}


	static showMarks() {
		closedMarks := ""
		numofmarks := 0
		Infos.DestroyAll()
		loop files, this.MarksDirectory "\*.txt" {

			mark := StrSplit(A_LoopFilePath, "mark_")
			mark := StrSplit(mark[2], ".txt")
			mark := mark[1]

			markText := StrSplit(this.__TryGetMarkText(A_LoopFilePath), ",")

			win_id := Integer(markText[1])

			exename := StrSplit(markText[2], "\")
			exename := StrSplit(exename[exename.Length], ".exe")
			exename := exename[1]

			if !WinExist(win_id) {
				closedMarks .= mark ": " exename " - closed"
				closedMarks .= "`n"
				numofmarks += 1
				continue
			}
			Infos(mark ": " WinGetTitle(win_id) " | " exename)
			numofmarks += 1
		}
		if (numofmarks == 0) {
			Infos("No Marks Set", 2000)
			exit
		}
		else {
			if not (closedMarks == "") {
				closedMarks .= "`n|--> To reopen them up do the command `"mark 'key'`""
				Infos(closedMarks)
			}
		}
	}

	static validateMark(mark) {
		Infos.DestroyAll()
		Registers.ValidateKey(mark)
		markText := Marks.Read(mark)
		if !markText {
			Infos("mark `"" mark "`" not set")
			return 0
		}
		markText := StrSplit(markText, ",")
		win_id := Integer(markText[1])
		exePathName := markText[2]
		windowClass := markText[3]
		exename := StrSplit(markText[2], "\")
		operator := ""
		if !WinExist(win_id) {
			; found other exe window
			idsPath := WinGetList("ahk_exe " exePathName)
			actw := ""
			for id in idsPath {
				if (WinGetClass(id) == windowClass)
				{
					actw := id
					break
				}
			}
			if actw {
				Infos("Original window closed`nFound similar!`nWould you like to update the Mark or save a new instance [(Y)es/(N)ew/ ]")
				operator := GetInput("L1", "{esc}{space}{Backspace}").Input
				if (operator == "y") {
					Infos("Updated Mark " mark "with new window id" actw, 3000)
					this.saveMarkinFile(mark, actw)
					return 1
				}
				else if (operator == "n") {
					operator := "y"
				}
				else {
					return 0
				}
			}
			; no other exe window found
			if !operator {
				Infos.DestroyAll()
				Infos("Mark " mark " window closed")
				Infos("Would you like to open " exename[exename.Length] " [y/n/ ]`nn - Would clear mark")
				operator := GetInput("L1", "{esc}{space}{Backspace}").Input
			}
			if (operator == "y") {
				Infos.DestroyAll()
				Run markText[2], , , &w_pid
				actw := WinWaitActive("ahk_class " markText[3], , 5.5)
				this.saveMarkinFile(mark, actw)
			}
			else if (operator == "n") {
				this.clearMark(mark)
				Infos.DestroyAll()
				return 0
			}
			Infos.DestroyAll()
			return 0
		}
		return 1
	}

	static saveMarkinFile(mark, actw) {
		Infos.DestroyAll()
		Infos("window Title: " WinGetTitle(actw), Registers.InfoTimeout)
		Infos("window Process Path: " WinGetProcessPath(actw), Registers.InfoTimeout)
		windowPath := WinGetProcessPath(actw)
		windowClass := WinGetClass(actw)
		markContents := actw "," windowPath "," windowClass
		Marks.Write(markContents, mark)
	}

	static showMark(mark) {
		Infos.DestroyAll()
		if this.validateMark(mark)
		{
			markText := StrSplit(Marks.Read(mark), ",")
			win_id := Integer(markText[1])
			exename := StrSplit(markText[2], "\")
			Infos(mark ": " WinGetTitle(win_id) "-" win_id " | " exename[exename.Length])
		}
	}

	static clearMarks() {
		numofmarks := 0
		Infos.DestroyAll()
		loop files, this.MarksDirectory "\*.txt" {

			mark := StrSplit(A_LoopFilePath, "mark_")
			mark := StrSplit(mark[2], ".txt")
			mark := mark[1]

			markText := StrSplit(this.__TryGetMarkText(A_LoopFilePath), ",")

			win_id := Integer(markText[1])

			exename := StrSplit(markText[2], "\")
			exename := StrSplit(exename[exename.Length], ".exe")
			exename := exename[1]

			if !WinExist(win_id) {
				FileDelete A_LoopFilePath
				numofmarks += 1
				continue
			}
		}
		if (numofmarks == 0) {
			Infos("No Closed Marks", 2000)
			exit
		}
		Infos("Deleted Closed Marks")
	}

	static clearMark(mark) {
		Infos.DestroyAll()
		if FileExist(this.MarksDirectory "\mark_" mark ".txt")
			FileDelete(this.MarksDirectory "\mark_" mark ".txt")
		Infos("Delted Mark " mark)
	}

	static killMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set", 2000)
			return
		}
		WinClose(this.MarkA.%mark%)
		this.MarkA.%mark% := ""
		for i in this.MarkIndex {
			if i == mark {
				this.MarkIndex.RemoveAt(A_Index)
			}
		}
		Infos("Delted Mark " mark)
	}
	static isExist(index) {
		for i in this.MarkIndex {
			if i == index
				return true
		}
		return false
	}
	static Pushindex(index) {
		if !this.isExist(index) {
			this.MarkIndex.Push(index)
		}
	}
	static saveSession(sessionName) {
		SetTitleMatchMode "RegEx"
		list := WinGetList("ahk_exe .*exe")
		this.Sessions.%sessionName% := list
		Infos("Saved session " sessionName, 2000)
	}
	static saveSessionByMouse(sessionName) {
		mwh := MouseWindowH()
		MouseGetPos(, , &mouseWin)
		WinGetPos(&x, &y, &w, &h, mouseWin)
		mwh.setHeight(h)
		mwh.setWidth(w)
		mwh.setxPos(x)
		mwh.setyPos(y)
		mwh.setHandler(mouseWin)
		; if WinGetTransparent(mouseWin) == 240 {
		for i in this.Sessions.%sessionName%{
			if (i._handler) == (mwh._handler) {
				WinSetTransparent "Off", mwh._handler
				this.Sessions.%sessionName%.RemoveAt(A_Index)
				Infos("Window removed: " WinGetTitle(mwh._handler) " (from session " sessionName ")", 4000)
				return
			}
		}
		; }
		; WinSetTransparent 240, mwh._handler
		this.Sessions.%sessionName%.Push(mwh)
		title := StrSplit(WinGetTitle(mwh._handler), " - ")
		if title.Length == 0 {
			Infos("Window saved: " WinGetTitle(mwh._handler) " (into session " sessionName ")", 4000)
		}
		else {
			Infos("Window saved: " title[title.Length] " (into session " sessionName ")", 4000)
		}
	}
	static startRecording(sessionName) {
		StateBulb[7].Create()
		Infos("Started recording windows from mouse Click", 2000)
		this.recording := true
		this._session := sessionName
		this.Sessions.%sessionName% := []
		this.sessionNames.Push(sessionName)
	}
	static stopRecording(sessionName) {
		StateBulb[7].Destroy()
		Infos("Stopped recording " sessionName, 2000)
		this.recording := false
		this._session := sessionName
		if this.Sessions.%sessionName%.Length == 0 {
			this.sessionNames.Pop()
			return
		}
		for i in this.Sessions.%sessionName%{
			WinSetTransparent "Off", i._handler
		}
	}
	static showSessionRecored() {
		if this.sessionNames.Length <= 0 {
			Infos("no session saved", 2000)
		}
		for sessionName in this.sessionNames {
			try for i in this.Sessions.%sessionName% {
				arr := StrSplit(WinGetTitle(i._handler), " - ")
				Infos("Session " sessionName ":" arr[arr.Length])
			}
			catch {
				Infos("no session saved as " sessionName, 2000)
			}
		}
	}
	static showSession(sessionName) {

	}
	static openRecoredSession(sessionName) {
		try for i in this.Sessions.%sessionName%{
			WinMove(i._xPos, i._yPos, i._width, i._height, i._handler)
		}
		catch {
			Infos("No session saved as " sessionName, 2000)
			return
		}
		Infos("activated session " sessionName, 2000)
	}
	static openSession(sessionName) {
		try for win in this.Sessions.%sessionName%{
			arr := this.Sessions.%sessionName%
			try WinActivate(this.Sessions.%sessionName%[arr.Length - A_Index + 1])
			catch {
				continue
			}
		}
		catch {
			Infos("No session saved as " sessionName, 2000)
			return
		}
		Infos("activated session " sessionName, 2000)
	}
}