#Include Array.ahk
#Include MouseWindowH.ahk
class MouseMarks {
	static MarkA := {}
	static MarkIndex := []
	static Sessions := {}
	static sessionNames := []
	static mouseWindows := []
	static recording := false
	static MouseMarksDirectory := "C:\Veem\MouseMarks"
	static _session := ""

	static GetPath(key) => MouseMarks.MouseMarksDirectory "\mouseMark_" key ".txt"

	static __TryGetMarkText(path) {
		if FileExist(path)
			text := ReadFile(path)
		else
			text := ""
		return text
	}

	static Read(key) {
		path := MouseMarks.GetPath(key)
		return this.__TryGetMarkText(path)
	}

	/**
	 * Write the contents of your clipboard to a register
	 */
	static Write(text, key) {
		path := MouseMarks.GetPath(key)
		WriteFile(path, text)
		Info(key " mouse mark written", Registers.InfoTimeout)
	}


	static showMouseMarks() {
		closedMouseMarks := ""
		numofMouseMarks := 0
		Infos.DestroyAll()
		loop files, this.MouseMarksDirectory "\*.txt" {

			mark := StrSplit(A_LoopFilePath, "mouseMark_")
			mark := StrSplit(mark[2], ".txt")
			mark := mark[1]

			markText := StrSplit(this.__TryGetMarkText(A_LoopFilePath), ",")

			xpos := Integer(markText[1])
			ypos := Integer(markText[2])
			Infos(mark, , , true, xpos, ypos)
		}
	}

	static saveMarkinFile(mark, xpos, ypos) {
		Infos.DestroyAll
		Infos("x: " xpos "y: " ypos)
		markContents := xpos "," ypos
		MouseMarks.Write(markContents, mark)
	}

	static showMark(mark) {
		Infos.DestroyAll()
		pos := StrSplit(MouseMarks.Read(mark), ",")
		xpos := Integer(pos[1])
		ypos := Integer(pos[2])
		Infos(mark, , , true, xpos, ypos)
	}

	static clearMouseMarks() {
		numofMouseMarks := 0
		Infos.DestroyAll()
		loop files, this.MouseMarksDirectory "\*.txt" {

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
				numofMouseMarks += 1
				continue
			}
		}
		if (numofMouseMarks == 0) {
			Infos("No Closed MouseMarks", 2000)
			exit
		}
		Infos("Deleted Closed MouseMarks")
	}

	static clearMark(mark) {
		Infos.DestroyAll()
		if FileExist(this.MouseMarksDirectory "\mark_" mark ".txt")
			FileDelete(this.MouseMarksDirectory "\mark_" mark ".txt")
		Infos("Delted Mark " mark)
	}

	static killMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No MouseMarks Set", 2000)
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