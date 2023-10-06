class Marks {
	static MarkA := {}
	static MarkIndex := []
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