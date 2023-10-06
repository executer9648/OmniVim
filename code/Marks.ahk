class Marks {
	static MarkA := {}
	static MarkIndex := []
	static showMarks() {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set")
			return
		}
		for i in this.MarkIndex {
			arr := StrSplit(WinGetTitle(this.MarkA.%i%), " - ")
			; for str in arr {
			; 	Infos(A_Index ": " str)
			; }
			; Infos(arr.Length)
			Infos(i ": " arr[arr.Length])
		}
	}
	static showMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set")
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
			Infos("No Marks Set")
			return
		}
		this.MarkA := {}
		this.MarkIndex := []
		Infos("Delted Marks")
	}
	static clearMark(mark) {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set")
			return
		}
		this.MarkA.%mark% := ""
		for i in this.MarkIndex {
			if i == mark
				this.MarkIndex[A_Index] := ""
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
}