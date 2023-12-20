#Include myGlobal.ahk

class Insert extends myGlobal {
	static contextMenu() {
		Send "+f10"
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
	static gotoNumLockMode() {
		super.gotoNumLockMode()
		myGlobal.wasInInsertMode := true
	}
}