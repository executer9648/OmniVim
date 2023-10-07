#Include Array.ahk
#Include MouseWindowH.ahk
class Marks {
	static MarkA := {}
	static MarkIndex := []
	static Sessions := {}
	static sessionNames := []
	static mouseWindows := []
	static recording := false
	static _session := ""

	static showMarks() {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set", 2000)
			return
		}
		for i in this.MarkIndex {
			arr := StrSplit(WinGetTitle(this.MarkA.%i%), " - ")
			Infos(i ": " arr[arr.Length])
		}
	}
	static showMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set", 2000)
			return
		}
		try arr := StrSplit(WinGetTitle(this.MarkA.%mark%), " - ")
		catch {
			Infos("Mark " mark " not Set")
			return
		}
		Infos(mark ": " arr[arr.Length])
	}
	static clearMarks() {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set", 2000)
			return
		}
		this.MarkA := {}
		this.MarkIndex := []
		Infos("Delted Marks")
	}
	static clearMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set", 2000)
			return
		}
		this.MarkA.%mark% := ""
		for i in this.MarkIndex {
			if i == mark
				this.MarkIndex.RemoveAt(A_Index)
		}
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
		WinSetTransparent 200, mwh._handler
		this.Sessions.%sessionName%.Push(mwh)
		title := StrSplit(WinGetTitle(mwh._handler), " - ")
		Infos("Window saved: " title[title.Length] " (into session " sessionName ")", 4000)
	}
	static startRecording(sessionName) {
		Infos("Started recording windows from mouse Click", 2000)
		this.recording := true
		this._session := sessionName
		this.Sessions.%sessionName% := []
		this.sessionNames.Push(sessionName)
	}
	static stopRecording(sessionName) {
		Infos("Stopped recording " sessionName, 2000)
		this.recording := false
		this._session := sessionName
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