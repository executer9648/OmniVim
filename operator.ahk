#Include vimv3.ahk
#Include manager.ahk

class operator {
	isSuper := true
	__New() {
		return
	}
	static action() {
		return
	}
}
class yOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "^c"
		Send "{left}"
		Registers(manager.reg).WriteOrAppend()
	}
	action2() {
		oldclip := A_Clipboard
		Send "+{Home}"
		Send "^c"
		ClipWait 1
		var1 := A_Clipboard
		Send "{Right}"
		Send "+{End}"
		Send "^c"
		ClipWait 1
		var2 := A_Clipboard
		Send "{Left}"
		Send "+{Right}"
		A_Clipboard := var1 var2
		Registers(manager.reg).WriteOrAppend()
		A_Clipboard := oldclip
	}
}
class dOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "^x"
		Registers(manager.reg).WriteOrAppend()
	}
	action2() {
		Send "{Home}+{End}"
		Send "^x"
		Send "{Delete}"
		Registers(manager.reg).WriteOrAppend()
	}
}
class cOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "^x"
		Send "{left}"
		Registers(manager.reg).WriteOrAppend()
		gotoInsert()
	}
	action2() {
		Send "{Home}+{End}"
		Send "^x"
		Registers(manager.reg).WriteOrAppend()
		gotoInsert()
	}
}
class rOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		SendText manager.getkey(1)
		Send "{Left}"
		Send "+{Right}"
	}
}
class sOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "{Delete}"
		gotoInsert()
	}
}
class xOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "{Delete}"
		Send "+{Right}"
	}
}
class shiftxOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "{bs}"
	}
}
class pOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Registers(manager.reg).Paste()
	}
}
class shiftpOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		Send "{Left}"
		Registers(manager.reg).Paste()
	}
}
class guOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait
		formatstr := A_Clipboard
		string1 := StrLower(formatstr)
		SendText string1
		A_Clipboard := oldclip
	}
}
class gshiftuOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait
		formatstr := A_Clipboard
		string1 := StrUpper(formatstr)
		SendText string1
		A_Clipboard := oldclip
	}
}
class tildaOpr extends operator {
	__New() {
		super.isSuper := false
	}
	action() {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait
		formatstr := A_Clipboard
		if RegExMatch(formatstr, "^[A-Z\s\p{P}!]+$") {
			string1 := StrLower(formatstr)
			SendText string1
		}
		else if RegExMatch(formatstr, "^[a-z\s\p{P}!]+$") {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		else {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		A_Clipboard := oldclip
		Send "{Left}"
		Send "+{Right}"
	}
}