#Include VimEmacsAhk - Copy.ahk
; Normal Mode
#HotIf normalMode = 1

Z & Q:: {
	Send "!{f4}"
}
z & h:: {
	Send "{WheelLeft}"
}
z & l:: {
	Send "{WheelRight}"
}
z & j:: {
	Send "{WheelDown}"
}
z & k:: {
	Send "{WheelUp}"
}
z & =:: {
	Send "{Left}"
	Send "+{f10}"
}

!+a:: {
	Send "!+a"
	gotoInsert()
}

BackSpace:: {
	global counter
	global infcounter
	counter := counter / 10
	counter := Floor(counter)
	if counter == 0 {
		infcounter.Destroy()
	} else {
		infcounter.Destroy()
		infcounter := Infos(counter, , true)
	}
}

-:: Return
`;:: Return
+;:: {
	gotoInsertnoInfo()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoNormalnoInfo()
}
`:: Return
+`:: {
	if visualMode == true {
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
		Send "{Left}"
		Send "+{Right}"
		gotoNormal()
		A_Clipboard := oldclip
	}
	else {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait
		formatstr := A_Clipboard
		if RegExMatch(formatstr, "^[A-Z\s\p{P}]+$") {
			string1 := StrLower(formatstr)
			SendText string1
		}
		else if RegExMatch(formatstr, "^[a-z\s\p{P}]+$") {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		else {
			string1 := StrUpper(formatstr)
			SendText string1
		}
		Send "{Left}"
		Send "+{Right}"
		A_Clipboard := oldclip
	}
	Exit
}
=:: Return
,:: Return
.:: Return
/:: {
	Send "^f"
	gotoInsert()
	Exit
}
':: {
	global normalMode := false
	openMark()
	global normalMode := true
}
+':: {
	inf := Infos('"', , true)
	global normalMode := false
	StateBulb[7].Create()
	mark := GetInput("L1", "{esc}{space}{Backspace}").Input
	if mark = "" {
		StateBulb[7].Destroy()
		global normalMode := true
		inf.Destroy()
		Exit
	}

	inf.Destroy()
	infs := '"'
	infs .= mark
	inf := Infos(infs, , true)

	operator := GetInput("L1", "{esc}{space}{Backspace}").Input

	if (operator == "y") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^c"
		ClipWait 1
		Sleep 10
		Registers(mark).WriteOrAppend()
		Sleep 10
		Send "{Left}"
		Send "+{Right}"
		A_Clipboard := oldclip
	}
	else if (operator == "d") {
		oldclip := A_Clipboard
		A_Clipboard := ""
		Send "^x"
		ClipWait 1
		Sleep 10
		Registers(mark).WriteOrAppend()
		A_Clipboard := oldclip
	}
	else if (operator == "p") {
		Registers(mark).Paste()
		Sleep 10
		Send "{right}"
		Send "{left}"
		Send "+{Right}"
	}
	else if (operator == "l") {
		Registers(mark).Look()
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "m") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(mark).Move(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "s") {
		secReg := GetInput("L1", "{Esc}").Input
		Registers(mark).SwitchContents(secReg)
		Send "{Left}"
		Send "+{Right}"
	}
	else if (operator == "x") {
		Registers(mark).Truncate()
		Send "{Left}"
		Send "+{Right}"
	}
	StateBulb[7].Destroy()
	global normalMode := true
	global visualLineMode := false
	global visualMode := false
	inf.Destroy()
}
[:: Return
\:: Return
m:: {
	gotoMwMode()
	Exit
}
n:: {
	Send "^f"
	Send "{Enter}"
	Exit
}
+n:: {
	Send "^f"
	Send "+{Enter}"
	Exit
}
^!n:: {
	global wasInNormalMode := true
	gotoNumLockMode()
}
q:: Return
r:: {
	global normalMode := false
	StateBulb[4].Create()
	secReg := GetInput("L1", "{esc}{space}{Backspace}").Input
	SendText secReg
	StateBulb[4].Destroy()
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
}
s:: {
	Send "{BS}"
	gotoInsert()
	Exit
}
t:: Return
z:: Return

1:: {
	chCounter(1)
}
2:: {
	chCounter(2)
}
3:: {
	chCounter(3)
}
4:: {
	chCounter(4)
}
5:: {
	chCounter(5)
}
6:: {
	chCounter(6)
}
7:: {
	chCounter(7)
}
8:: {
	chCounter(8)
}
9:: {
	chCounter(9)
}


+f:: {
	StateBulb[4].Create()
	global normalMode := false
	global counter
	global infcounter
	cvar := "" counter
	cvar .= "F"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	if counter != 0 {
		while counter > 0 {
			ih := InputHook("C")
			ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
			ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
			ih.Start()
			ih.Wait()
			check := ih.EndMods
			check .= ih.EndKey
			check2 := ih.EndKey
			if check == "<!``" {
				exitVim()
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Escape" {
				counter := 0
				StateBulb[4].Destroy()
				global normalMode := true
				infcounter.Destroy()
				Exit
			} else if check2 == "Backspace" {
				counter += 2
				trimed := SubStr(var, 1, StrLen(var) - 1)
				var := trimed
			} else if check2 == "Space" {
				Continue
			} else {
				var .= ih.EndKey
			}
			infcounter.Destroy()
			infcounter := Infos(var, , true)
			counter -= 1
		}
		counter := 0
	}
	else {
		ih := InputHook("C")
		ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
		ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
		ih.Start()
		ih.Wait()
		var := ih.EndKey
		check := ih.EndMods
		check .= ih.EndKey
		check2 := ih.EndKey
		if check == "<!``" {
			exitVim()
			infcounter.Destroy()
			Exit
		} else if check2 == "Escape" {
			StateBulb[4].Destroy()
			global normalMode := true
			infcounter.Destroy()
			Exit
		}
	}
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var, false, -1)
	Send "{Home}"
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}

f:: {
	StateBulb[4].Create()
	global normalMode := false
	global counter
	global infcounter
	cvar := "" counter
	cvar .= "f"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	if counter != 0 {
		while counter > 0 {
			ih := InputHook("C")
			ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
			ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
			ih.Start()
			ih.Wait()
			check := ih.EndMods
			check .= ih.EndKey
			check2 := ih.EndKey
			if check == "<!``" {
				exitVim()
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Escape" {
				StateBulb[4].Destroy()
				global normalMode := true
				infcounter.Destroy()
				counter := 0
				Exit
			} else if check2 == "Backspace" {
				counter += 2
				trimed := SubStr(var, 1, StrLen(var) - 1)
				var := trimed
			} else if check2 == "Space" {
				Continue
			} else {
				var .= ih.EndKey
			}
			infcounter.Destroy()
			infcounter := Infos(var, , true)
			counter -= 1
		}
		counter := 0
	}
	else {
		ih := InputHook("C")
		ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
		ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
		ih.Start()
		ih.Wait()
		var := ih.EndKey
		check := ih.EndMods
		check .= ih.EndKey
		check2 := ih.EndKey
		if check == "<!``" {
			exitVim()
			infcounter.Destroy()
			Exit
		} else if check2 == "Escape" {
			StateBulb[4].Destroy()
			global normalMode := true
			infcounter.Destroy()
			Exit
		}
	}
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Right}"
	Send "+{End}"
	Send "^c"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var)
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	infcounter.Destroy()
	StateBulb[4].Destroy()
}


g:: {
	gotoGMode()
	Exit
}

+g:: {
	if visualMode == true {
		Send "+^{End}"
	}
	else {
		Send "^{End}"
	}
	Exit
}

$^w:: {
	if visualMode == true {
		Exit
	}
	else {
		wasInNormalMode := true
		gotoWindowMode()
	}
	Exit
}

#t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "#t"
		}
		counter := 0
		infcounter.Destroy()
		Exit
	}
	Send "#t"
}

e:: {
	global counter
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Right}"
				Send "+{Left}"
			}
			else
			{
				Send "+{Right}"
				Send "^{Right}"
				Send "{Left 2}"
				Send "+{Right}"
			}
		}
		counter := 0
		infcounter.Destroy()
		Exit
	}
	Send "+{Right}"
	Send "^{Right}"
	Send "{Left 2}"
	Send "+{Right}"
}

!`:: {
	exitVim()
}

+c:: {
	Send "+{End}"
	Send "^x"
	gotoInsert()
	Exit
}

+d:: {
	Send "+{End}"
	Send "^x"
	Exit
}

d::
{
	global counter
	global infcounter
	if visualMode == true {
		Send "^x"
		gotoNormal()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "d"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoDMode()
}

!^y::
{
	Send "^{WheelUp}"
	Exit
}

!^e::
{
	Send "^{WheelDown}"
	Exit
}
+^y::
{
	Send "+{WheelUp}"
	Exit
}
+^e::
{
	Send "+{WheelDown}"
	Exit
}

^e:: {
	Send "{WheelDown}"
}

^y:: {
	Send "{WheelUp}"
}

Esc:: {
	global infcounter
	global counter
	if visualMode == true
	{
		gotoNormal()
	}
	else
	{
		if counter == 0
			Send "{Esc}"
		infcounter.Destroy()
		counter := 0
		Exit
	}
}

v:: {
	global visualMode
	Global visualLineMode
	if visualMode == true {
		gotoNormal()
		Exit
	}
	Global visualMode := true
	Send "{Left}"
	StateBulb[3].Create()
	Exit
}

+v:: {
	Send "{Home}"
	Send "+{End}"
	Global visualMode := true
	Global visualLineMode := true
	StateBulb[3].Create()
	Exit
}

*i:: {
	if visualMode == true
	{
		Send "^{Left}"
		Send "^+{Right}"
	}
	else
	{
		Send "{Left}"
		gotoInsert()
		Exit
	}
}

$h:: {
	h_motion()
}

$j:: {
	j_motion()
}

$k:: {
	k_motion()
}

$l:: {
	l_motion()
}

Space:: {
	if visualMode == true
	{
		Send "+{Right}"
	}
	else
	{
		Send "{Left}"
		Send "{Right}"
		Send "+{Right}"
		Exit
	}
}

+a:: {
	Send "{end}"
	gotoInsert()
	Exit
}

+i:: {
	Send "{home}"
	gotoInsert()
	Exit
}

+j:: {
	Send "{end}{Delete}"
	Exit
}

c:: {
	global counter
	global infcounter
	if visualMode == true {
		Send "^x"
		gotoInsert()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "c"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoCMode()
}

x:: {
	Send "{Delete}"
	Send "+{Right}"
	Exit
}
+x:: {
	Send "{bs}"
	Send "{Left}"
	Send "+{Right}"
	Exit
}

$b:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				if visualMode == true
				{
					Send "^+{Right}"
				}
				else
				{
					Send "{Right}"
					Send "^{Right}"
					Send "+{Left}"
				}
			}
			counter := 0
			infcounter.Destroy()
			Exit
		}
		if visualMode == true
		{
			Send "^+{Right}"
		}
		else
		{
			Send "{Right}"
			Send "^{Right}"
			Send "+{Left}"
			Exit
		}
		Exit
	}
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Left}"
			}
			else
			{
				Send "{Left}"
				Send "^{Left}"
				Send "+{Right}"
			}
		}
		counter := 0
		Exit
	}
	if visualMode == true
	{
		Send "^+{Left}"
	}
	else
	{
		Send "{Left}"
		Send "^{Left}"
		Send "+{Right}"
		Exit
	}
	Exit
}

$w:: {
	global counter
	global infcounter
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		if counter != 0 {
			Loop counter {
				if visualMode == true
				{
					Send "^+{Left}"
				}
				else
				{
					Send "^{Left}"
					Send "+{Left}"
				}
			}
			counter := 0
			infcounter.Destroy()
			Exit
		}
		if visualMode == true
		{
			Send "^+{Left}"
			Exit
		}
		else
		{
			Send "^{Left}"
			Send "+{Left}"
			Exit
		}
		Exit
	}
	if counter != 0 {
		Loop counter {
			if visualMode == true
			{
				Send "^+{Right}"
			}
			else
			{
				Send "^{Right}"
				Send "+{Right}"
			}
		}
		counter := 0
		Exit
	}
	if visualMode == true
	{
		Send "^+{Right}"
	}
	else
	{
		Send "^{Right}"
		Send "+{Right}"
		Exit
	}
	Exit
}

O:: {
	Send "{End}"
	Sleep 10
	Send "+{Enter}"
	gotoInsert()
	Exit
}

+O:: {
	Send "{Home}"
	Sleep 10
	Send "+{Enter}{Up}"
	gotoInsert()
	Exit
}

u:: {
	Send "^z"
	Exit
}

^r:: {
	Send "^y"
	Exit
}

+y:: {
	Send "+{End}"
	Send "^c"
	Send "{Left}"
	Send "+{Right}"
	Exit
}

y:: {
	global counter
	global infcounter
	if visualMode == true {
		Send "^c"
		Send "{Left}"
		gotoNormal()
		Exit
	}
	if counter != 0
		cvar := "" counter
	cvar .= "y"
	infcounter.Destroy()
	infcounter := Infos(cvar, , true)
	gotoYMode()
}

+p:: {
	Send "{Left}"
	sleep 10
	Send "^v"
	Exit
}

p:: {
	if visualMode == true {
		Send "^v"
		Exit
	}
	Send "{Right}"
	Send "^v"
	Exit
}

0::
{
	global counter
	global infcounter
	if counter != 0 {
		counter *= 10
		infcounter.Destroy()
		infcounter := Infos(counter, , true)
		exit
	}
	if visualMode == true
	{
		Send "+{home}"
	}
	else
	{
		Send "{home}"
		Send "+{Right}"
		Exit
	}
}

+4::
{
	if visualMode == true
	{
		Send "+{End}"
	}
	else
	{
		Send "{End}"
		Send "{Left}"
		Send "+{Right}"
		Exit
	}
}

a:: {
	Send "{Left}"
	Send "{Right}"
	gotoInsert()
	Exit
}
#HotIf