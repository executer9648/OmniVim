class Marks {
	static MarkA := {}
	static MarkIndex := []
	static showMarks() {
		Infos.DestroyAll()
		if this.MarkIndex.Length <= 0 {
			Infos("No Marks Set")
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