#Include myGlobal.ahk

class Insert extends myGlobal {
	static contextMenu() {
		Send "+f10"
	}
	static gotoNumLockMode() {
		super.gotoNumLockMode()
		myGlobal.wasInInsertMode := true
	}
	static insertReg() {
		myGlobal.insertMode := false
		super.insertReg()
		myGlobal.insertMode := true
	}

	static deleteToBack() {
		Send "+{Home}"
		Sleep 10
		Send "{bs}"
	}
	static deleteToEnd() {
		Send "+{end}"
		Sleep 10
		Send "{bs}"
	}

	static deleteWordEng() {
		Send "^+{Left}"
		Sleep 10
		Send "{bs}"
	}

	static deleteWordHeb() {
		Send "^+{Right}"
		Sleep 10
		Send "{bs}"
	}
	static deleteWordEngF() {
		Send "^+{Right}"
		Sleep 10
		Send "{Delete}"

	}
	static deleteWordHebF() {
		Send "^+{Left}"
		Sleep 10
		Send "{Delete}"
	}
}