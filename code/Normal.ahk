#Include myGlobal.ahk

class Normal extends myGlobal {

	static closeWindow() {
		myGlobal.zkeyCount
		this.zKey := (A_PriorHotkey = "+z" and A_TimeSincePriorHotkey < 400)
		if this.zKey {
			myGlobal.zkeyCount := myGlobal.zkeyCount + 1
		}
		else {
			myGlobal.zkeyCount := 0
		}
		if this.zKey and myGlobal.zkeyCount == 1 {
			Sleep 10
			Send "!{f4}"
		}
	}
}