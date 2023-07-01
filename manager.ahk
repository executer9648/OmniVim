class manager {
	static getkey(counter) {
		while counter > 0 {
			ih := InputHook("C")
			ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
			ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
			ih.Start()
			ih.Wait()
			check := ih.EndMods
			check .= ih.EndKey
			check2 := ih.EndKey
			if check == "<!Escape" {
				return "exitVim"
			} else if check2 == "Escape" {
				return "cancel"
			} else if check2 == "Backspace" {
				counter += 2
				trimed := SubStr(var, 1, StrLen(var) - 1)
				var := trimed
			} else if check2 == "Space" {
				return "cancel"
			} else {
				var .= ih.EndKey
			}
			vimInfo.changeText(var)
			counter -= 1
		}
		return var
	}
	static reg := "1"
	static visualMode := false
}