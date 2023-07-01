#SingleInstance
#MaxThreadsBuffer True
#MaxThreads 200
#MaxThreadsPerHotkey 100
#UseHook
#Include StateBulb.ahk
#Include Mouse.ahk
#Include WindowManager.ahk
#Include Runner.ahk
#Include Registers.ahk
#Include mousetest.ahk
#Include GetInput.ahk
#Include Language.ahk
#Include manager.ahk
#Include motion.ahk
#Include operator.ahk
#Include vimInfo.ahk

A_HotkeyInterval := 0
A_MenuMaskKey := "vkFF"

SetKeyDelay 10000
SetMouseDelay -1
CoordMode "Mouse", "Screen"

$CapsLock::Control
+!Control::CapsLock

~Alt:: Send "{Blind}{vkFF}"

+^#r:: Reload
#SuspendExempt
+^#s:: Suspend
#SuspendExempt False
+#e:: Edit
^#h:: Send "^#{Left}"
^#l:: Send "^#{Right}"

+#h:: Send "+#{Left}"
+#j:: Send "+#{Down}"
+#k:: Send "+#{Up}"
+#l:: Send "+#{Right}"

!#h:: Send "#{Left}"
!#j:: Send "#{Down}"
!#k:: Send "#{Up}"
!#l:: Send "#{Right}"

!h:: Send "{Left}"
!j:: Send "{Down}"
!k:: Send "{Up}"
!l:: Send "{Right}"

^[:: {
	gotoNormal()
}
^]:: {
	gotoNormal()
	gotoMouseMode()
	Mouse.SmallMove := 20
	Mouse.MediumMove := 70
	Mouse.BigMove := 200
}

global opr := operator()
global zeroPlaceHolder := operator()
global yPlaceHolder := yOpr()
global dPlaceHolder := dOpr()
global cPlaceHolder := cOpr()
global rPlaceHolder := rOpr()
global sPLaceHolder := sOpr()
global xPLaceHolder := xOpr()
global shiftxPLaceHolder := shiftxOpr()
global pPLaceHolder := pOpr()
global shiftpPLaceHolder := shiftpOpr()
global guPLaceHolder := guOpr()
global gshiftuPLaceHolder := gshiftuOpr()
global tildaPLaceHolder := tildaOpr()
Infos.DestroyAll()
turnOffAll()

turnoffBulbs() {
	StateBulb[1].Destroy() ; Vim
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[7].Destroy() ; reg Mode
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
turnOffAll() {
	global counter := 0
	global fMode := false
	global gMode := false
	global wMode := false
	global regActive := false
	global normalMode := false
	global insertMode := false
	global wasinCmdMode := false
	global mouseManagerMode := false
	global WindowManagerMode := false
	global WasInMouseManagerMode := false
	global WasInWindowManagerMode := false
	manager.reg := "1"
	manager.visualMode := false
	global zeroPlaceHolder
	global opr := zeroPlaceHolder
}
zeroize() {
	manager.reg := "1"
	global zeroPlaceHolder
	global counter := 0
	global opr := zeroPlaceHolder
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[7].Destroy() ; reg Mode
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
gotoNormal() {
	turnOffAll()
	turnoffBulbs()
	global normalMode := true
	StateBulb[1].Create()
}
gotoInsert() {
	turnOffAll()
	turnoffBulbs()
	global insertMode := true
	StateBulb[1].Create()
	StateBulb[2].Create()
}
gotoWindowMode() {
	turnOffAll()
	turnoffBulbs()
	StateBulb[1].Create()
	StateBulb[4].Create()
	StateBulb[6].Create()
	global wMode := true
}
gotoMwMode() {
	turnOffAll()
	turnoffBulbs()
	global WindowManagerMode := true
	StateBulb[1].Create()
	StateBulb[5].Create()
	StateBulb[6].Create()
}
gotoMouseMode() {
	turnOffAll()
	turnoffBulbs()
	global mouseManagerMode := true
	StateBulb[1].Create()
	StateBulb[6].Create()
}
gotoFMode() {
	turnOffAll()
	turnoffBulbs()
	global fMode := true
	StateBulb[1].Create()
	StateBulb[4].Create()
	StateBulb[6].Create()
}
gotoGMode() {
	turnOffAll()
	turnoffBulbs()
	global gMode := true
	StateBulb[1].Create()
	StateBulb[4].Create()
}
exitVim() {
	turnOffAll()
	Infos.DestroyAll()
	vimInfo.destroy()
	Infos("Exit Vim", 1500)
	StateBulb[1].Destroy() ; Vim
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[7].Destroy() ; reg Mode
	StateBulb[StateBulb.MaxBulbs - 1].Destroy()
}
counterFunc(number) {
	global counter
	if counter >= 0 {
		counter *= 10
		counter += number
	}
	vimInfo.changeCounter(counter)
}

; normal Mode
#HotIf normalMode = 1
HotIf "normalMode = 1"

!esc:: {
	exitVim()
}
Escape:: {
	zeroize()
	vimInfo.destroy()
}
BackSpace:: {
	global counter
	counter := counter / 10
	counter := Floor(counter)
	if counter == 0 {
		vimInfo.destroy()
	} else {
		vimInfo.changeCounter(counter)
	}
	try WinExist(vimInfo.infoText.gInfo)
	catch
		Send "{bs}"
}
-:: Return
=:: Return
,:: Return
`;:: Return
+;:: {
	gotoInsert()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoNormal()
}
+`:: {
	global opr
	opr := tildaPLaceHolder
	opr.action()
	zeroize()
}
.:: Return
/:: {
	Send "^f"
	gotoInsert()
}
':: Return
+':: { ;  "-register key
	vimInfo.changeText('"')
	turnOffAll()
	manager.reg := manager.getkey(1)
	if manager.reg == "exitVim"
		exitVim()
	else if manager.reg == "cancel"
		Exit
	else {
		vimInfo.addText(manager.reg)
		global regActive := true
	}
}
[:: Return
]:: Return
\:: Return
`:: Return
a:: {
	global regActive
	if regActive
		zeroize()
	else
		Send "{Right}"
	gotoInsert()
}
+a:: {
	global regActive
	if regActive
		zeroize()
	else
		Send "{End}"
	gotoInsert()
}
b:: {
	Send "{Left}"
	global regActive
	if regActive
		zeroize()
	else {
		global counter
		global opr
		motion.b_motion(counter, opr)
		zeroize()
		vimInfo.destroy()
	}
}
c:: {
	StateBulb[4].Create()
	vimInfo.addText("c")
	global opr
	global zeroPlaceHolder
	global cPlaceHolder
	if opr is cOpr {
		opr.action2()
		vimInfo.destroy()
		zeroize()
		StateBulb[4].Destroy()
	}
	else if opr.isSuper == true {
		opr := cPlaceHolder
	}
	else {
		zeroize()
		StateBulb[4].Destroy()
	}
}
d:: {
	StateBulb[4].Create()
	vimInfo.addText("d")
	global opr
	global zeroPlaceHolder
	global dPlaceHolder
	if opr is dOpr {
		opr.action2()
		vimInfo.destroy()
		zeroize()
		StateBulb[4].Destroy()
	}
	else if opr.isSuper == true {
		opr := dPlaceHolder
	}
	else {
		zeroize()
		vimInfo.destroy()
		StateBulb[4].Destroy()
	}
}
e:: {
	Global counter
	global opr
	motion.e_motion(counter, opr)
	zeroize()
	vimInfo.destroy()
}
f:: {
	global counter
	global normalMode := false
	StateBulb[4].Create()
	vimInfo.addText("f")
	var := motion.f_motion(counter, opr)
	if var := "exitVim" {
		exitVim()
	}
	zeroize()
	StateBulb[4].Destroy()
	vimInfo.destroy()
	global normalMode := true
}
+f:: {
	global counter
	global normalMode := false
	StateBulb[4].Create()
	vimInfo.addText("F")
	var := motion.shift_f_motion(counter, opr)
	if var := "exitVim" {
		exitVim()
	}
	zeroize()
	StateBulb[4].Destroy()
	vimInfo.destroy()
	global normalMode := true
}
g:: Return ; need to figure out how !todo
h:: {
	Send "{Left}"
	global counter
	global opr
	motion.h_motion(counter, opr)
	zeroize()
	vimInfo.destroy()
	StateBulb[3].Destroy()
}
i:: {
	if !opr.isSuper {
		motion.i_motion(opr)
		zeroize()
		vimInfo.destroy()
	}
	else {
		Send "{Left}"
		gotoInsert()
	}
}
j:: {
	Send "{Left}"
	Global counter
	global opr
	motion.j_motion(counter)
	zeroize()
	vimInfo.destroy()
	StateBulb[4].Destroy()
}
k:: {
	Send "{Left}"
	Global counter
	global opr
	motion.k_motion(counter)
	zeroize()
	vimInfo.destroy()
	StateBulb[4].Destroy()
}
l:: {
	Global counter
	global opr
	motion.l_motion(counter, opr)
	zeroize()
	vimInfo.destroy()
	StateBulb[4].Destroy()
}
m:: Return ; change to windows moving mode !todo
n:: {
	global counter
	motion.n_motion(counter)
	zeroize()
	vimInfo.destroy()
}
+n:: {
	global counter
	motion.shift_n_motion(counter)
	zeroize()
	vimInfo.destroy()
}
o:: {
	Send "{End}"
	Send "+{Enter}"
	gotoInsert()
}
+o:: {
	Send "{Home}"
	Send "+{Enter}"
	Send "{Up}"
	gotoInsert()
}
p:: {
	global opr
	global zeroPlaceHolder
	global pPlaceHolder
	if opr.isSuper == true {
		opr := pPlaceHolder
		opr.action()
		Send "{Left}"
		Send "+{Right}"
		zeroize()
	}
	else {
		zeroize()
	}
}
q:: Return
r:: {
	global opr
	global zeroPlaceHolder
	global rPlaceHolder
	if opr.isSuper == true {
		opr := rPlaceHolder
		opr.action()
		Send "+{Right}"
		zeroize()
	}
	else {
		zeroize()
	}
}
s:: {
	global opr
	global zeroPlaceHolder
	global sPlaceHolder
	if opr.isSuper == true {
		opr := sPlaceHolder
		opr.action()
		zeroize()
	}
	else {
		zeroize()
	}
}
t:: Return
u:: {
	Send "^z"
	zeroize()
}
v:: {
	manager.visualMode := true
}
w:: {
	Global counter
	global opr
	motion.w_motion(counter, opr)
	zeroize()
	vimInfo.destroy()
}
x:: {
	global opr
	global zeroPlaceHolder
	global xPlaceHolder
	if opr.isSuper == true {
		opr := xPlaceHolder
		opr.action()
		zeroize()
	}
	else {
		zeroize()
	}
}
y:: {
	global opr
	global zeroPlaceHolder
	global yPlaceHolder
	if opr.isSuper == true {
		opr := yPlaceHolder
		opr.action()
		zeroize()
	}
	else {
		zeroize()
	}
}
z:: Return
0:: {
	global opr
	motion.n0_motion(opr)
	zeroize()
	vimInfo.destroy()
}
1:: counterFunc(1)
2:: counterFunc(2)
3:: counterFunc(3)
4:: counterFunc(4)
+4:: {
	global opr
	motion.n4_motion(opr)
	zeroize()
	vimInfo.destroy()
}
5:: counterFunc(5)
6:: counterFunc(6)
7:: counterFunc(7)
8:: counterFunc(8)
9:: counterFunc(9)
#HotIf

; insert Mode
#HotIf insertMode = 1
HotIf "insertMode = 1"

^r:: {
	vimInfo.changeText('"')
	turnOffAll()
	manager.reg := manager.getkey(1)
	if manager.reg == "exitVim"
		exitVim()
	else if manager.reg == "cancel"
		Exit
	else {
		vimInfo.addText(manager.reg)
		global regActive := true
	}
	Registers(manager.reg).Paste()
	zeroize()
	gotoInsert()
}

!Esc:: {
	exitVim()
	gotoNormal()
	Exit
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else if (wasinCmdMode == true) {
		Send "{Esc}"
	}
	else {
		gotoNormal()
	}
	Exit
}

^u:: {
	Send "{Home}+{End}"
	Send "{BS}"
	Exit
}

^x:: {
	Send "+{Home}"
	Send "{BS}"
	Exit
}

^k:: Send "+{end}{bs}"

^w:: {
	langid := Language.GetKeyboardLanguage()
	if (LangID = 0x040D) {
		Send "^+{Right}"
		Send "{bs}"
		Exit
	}
	Send "^+{Left}"
	Send "{bs}"
	Exit
}

^a:: {
	Send "{Home}"
	Exit
}

^e:: {
	Send "{End}"
	Exit
}

^b:: {
	Send "{Left}"
	Exit
}

!h:: {
	Send "{Left}"
	Exit
}

^n:: {
	Send "{Down}"
	Exit
}

^h:: {
	Send "{BS}"
	Exit
}

^d:: {
	Send "{Delete}"
	Exit
}

^p:: {
	Send "{Up}"
	Exit
}

!j:: {
	Send "{Down}"
	Exit
}

!k:: {
	Send "{Up}"
	Exit
}

^f:: {
	Send "{Right}"
	Exit
}

!l:: {
	Send "{Right}"
	Exit
}

!d:: {
	Send "^+{Right}"
	Send "{Delete}"
	Exit
}

+!b:: {
	Send "^+{Left}"
	Exit
}

+!f:: {
	Send "^+{Right}"
	Exit
}

!b:: {
	Send "^{Left}"
	Exit
}

!f:: {
	Send "^{Right}"
	Exit
}

^!h:: {
	Send "^{Left}"
	Exit
}

^!l:: {
	Send "^{Right}"
	Exit
}
#HotIf

#HotIf mouseManagerMode = 1
HotIf "mouseManagerMode = 1"

c:: Return
r:: Return
z:: Return
.:: Return
/:: {
	Send "^f"
	gotoInsert()
	Exit
}
':: Return
[:: Return
]:: Return
\:: Return
+;:: {
	gotoInsert()
	global wasinCmdMode := true
	Runner.openRunner()
	gotoMouseMode()
}
x:: {
	Send "{BackSpace}"
}
d:: {
	Send "{Delete}"
}
y:: {
	Send "^c"
}
p:: {
	Send "^v"
}
^w:: {
	global WasInMouseManagerMode := true
	gotoWindowMode()
	Exit
}

f:: {
	gotoFMode()
}
g:: {
	global WasInMouseManagerMode := true
	gotoGMode()
	Exit
}
i:: {
	global WasInMouseManagerMode := true
	gotoInsert()
	Exit
}
m:: {
	global WasInMouseManagerMode := true
	gotoMwMode()
	Exit
}

!h:: Send "!{Left}"
!j:: Send "!{Down}"
!k:: Send "!{Up}"
!l:: Send "!{Right}"

+h:: Mouse.MoveLeft(Mouse.MediumMove)
+k:: Mouse.MoveUp(Mouse.MediumMove)
+j:: Mouse.MoveDown(Mouse.MediumMove)
+l:: Mouse.MoveRight(Mouse.MediumMove)


Hotkey "u", ButtonAcceleration
Hotkey "o", ButtonAcceleration
Hotkey "n", ButtonAcceleration
Hotkey ",", ButtonAcceleration
Hotkey "h", ButtonAcceleration
Hotkey "j", ButtonAcceleration
Hotkey "k", ButtonAcceleration
Hotkey "l", ButtonAcceleration

hotkey "q", ButtonSpeedUp
hotkey "a", ButtonSpeedDown
hotkey "w", ButtonAccelerationSpeedUp
hotkey "s", ButtonAccelerationSpeedDown
hotkey "+q", ButtonMaxSpeedUp
hotkey "+a", ButtonMaxSpeedDown

; h:: Mouse.MoveLeft(Mouse.SmallMove)
; k:: Mouse.MoveUp(Mouse.SmallMove)
; j:: Mouse.MoveDown(Mouse.SmallMove)
; l:: Mouse.MoveRight(Mouse.SmallMove)

^h:: Mouse.MoveLeft(Mouse.BigMove)
^k:: Mouse.MoveUp(Mouse.BigMove)
^j:: Mouse.MoveDown(Mouse.BigMove)
^l:: Mouse.MoveRight(Mouse.BigMove)

t:: Click()
+t:: Click("Right")
*b:: Click("Middle")

v:: Mouse.HoldIfUp("L")
+v:: Mouse.HoldIfUp("R")
#b:: Mouse.HoldIfUp("M")

1:: MouseMove(Mouse.FarLeftX, Mouse.MiddleY)
2:: MouseMove(Mouse.HighLeftX, Mouse.MiddleY)
3:: MouseMove(Mouse.MiddleLeftX, Mouse.MiddleY)
4:: MouseMove(Mouse.LowLeftX, Mouse.MiddleY)
5:: MouseMove(Mouse.LessThanMiddleX, Mouse.MiddleY)
6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.MiddleY)
7:: MouseMove(Mouse.LowRightX, Mouse.MiddleY)
8:: MouseMove(Mouse.MiddleRightX, Mouse.MiddleY)
9:: MouseMove(Mouse.HighRightX, Mouse.MiddleY)
0:: MouseMove(Mouse.FarRightX, Mouse.MiddleY)

^1:: MouseMove(Mouse.FarLeftX, Mouse.TopY)
^2:: MouseMove(Mouse.HighLeftX, Mouse.TopY)
^3:: MouseMove(Mouse.MiddleLeftX, Mouse.TopY)
^4:: MouseMove(Mouse.LowLeftX, Mouse.TopY)
^5:: MouseMove(Mouse.LessThanMiddleX, Mouse.TopY)
^6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.TopY)
^7:: MouseMove(Mouse.LowRightX, Mouse.TopY)
^8:: MouseMove(Mouse.MiddleRightX, Mouse.TopY)
^9:: MouseMove(Mouse.HighRightX, Mouse.TopY)
^0:: MouseMove(Mouse.FarRightX, Mouse.TopY)

+1:: MouseMove(Mouse.FarLeftX, Mouse.BottomY)
+2:: MouseMove(Mouse.HighLeftX, Mouse.BottomY)
+3:: MouseMove(Mouse.MiddleLeftX, Mouse.BottomY)
+4:: MouseMove(Mouse.LowLeftX, Mouse.BottomY)
+5:: MouseMove(Mouse.LessThanMiddleX, Mouse.BottomY)
+6:: MouseMove(Mouse.MoreThanMiddleX, Mouse.BottomY)
+7:: MouseMove(Mouse.LowRightX, Mouse.BottomY)
+8:: MouseMove(Mouse.MiddleRightX, Mouse.BottomY)
+9:: MouseMove(Mouse.HighRightX, Mouse.BottomY)
+0:: MouseMove(Mouse.FarRightX, Mouse.BottomY)

Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
}

$^e::
{
	Send "{WheelDown}"
}

$^y::
{
	Send "{WheelUp}"
}
#HotIf

; g mode
#HotIf gMode = 1
HotIf "gMode = 1"
t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^{tab}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	if WasInMouseManagerMode == true {
		Send "^{tab}"
		gotoMouseMode()
	}
	else {
		Send "^{tab}"
		gotoNormal()
	}
	Exit
}
+t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+{tab}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	if WasInMouseManagerMode == true {
		Send "^+{tab}"
		gotoMouseMode()
	}
	else {
		Send "^+{tab}"
		gotoNormal()
	}
	Exit
}
g:: {
	if WasInMouseManagerMode == true {
		Send "{Home}"
		gotoMouseMode()
	}
	else {
		Send "{Home}"
		gotoNormal()
	}
	Exit
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

#HotIf

; f mode
#HotIf fMode = 1
HotIf "fMode = 1"

`:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x1, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x1, Mouse.tildaCol)
		gotoNormal()
		gotoMouseMode()
	}
	Exit
}
1:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x2, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x2, Mouse.tildaCol)
		gotoMouseMode()
	}
	Exit
}
2:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x3, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x3, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
3:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x4, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
4:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x5, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x5, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
5:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x6, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x6, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
6:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x7, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x7, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
7:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x8, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x8, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
8:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x9, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x9, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
9:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x10, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x10, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
0:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x11, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x11, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
-:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x12, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x12, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
=:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x13, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x13, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}
BackSpace:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x14, Mouse.tildaCol, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x14, Mouse.tildaCol)
		gotoMouseMode()
		Exit
	}
}

tab:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x1, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
q:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x2, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
w:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x3, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
e:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x4, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
r:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x5, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
t:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x6, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
y:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x7, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
u:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x8, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
i:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x9, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
o:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x10, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
p:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x11, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
[:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x12, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
]:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x13, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
\:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.x14, Mouse.tabCol)
		gotoMouseMode()
		Exit
	}
}
LControl:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax1, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
a:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax2, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
s:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax3, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
d:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax4, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
f:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax5, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
g:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax6, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
h:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax7, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
j:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax8, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
k:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax9, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
l:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax10, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
`;:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax11, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
':: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax12, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}
Enter:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.ax13, Mouse.capsCol)
		gotoMouseMode()
		Exit
	}
}

LShift:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx1, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
z:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx2, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
x:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx3, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
c:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx4, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
v:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx5, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
b:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx6, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
n:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx7, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
m:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx8, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
,:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx9, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
.:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx10, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
/:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx11, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}
RShift:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.zx12, Mouse.shiftCol)
		gotoMouseMode()
		Exit
	}
}

LWin:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx1, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
LAlt:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx2, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Space:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx3, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
RAlt:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx4, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
; fn key
AppsKey:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx5, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}
Rctrl:: {
	if WasInWindowManagerMode == true {
		WinMove(Mouse.x4, 0, , , "A")
		gotoNormal()
		gotoMwMode()
	}
	else {
		MouseMove(Mouse.sx6, Mouse.spaceCol)
		gotoMouseMode()
		Exit
	}
}

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

#HotIf

; window mode
#HotIf wMode = 1
HotIf "wMode = 1"

-:: Return
`;:: Return
=:: Return
,:: Return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return
a:: Return
b:: Return
c:: Return
d:: Return
e:: Return
f:: Return
g:: Return
h:: Return
i:: Return
j:: Return
k:: Return
l:: Return
m:: Return
n:: Return
o:: Return
p:: Return
r:: Return
s:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
0:: Return
1:: Return
2:: Return
3:: Return
4:: Return
5:: Return
6:: Return
7:: Return
8:: Return
9:: Return
^w:: Return
^e:: Return

!Esc:: {
	exitVim()
	Exit
}
Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}
*q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^w"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^w"
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}
+q:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "!{f4}"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "!{f4}"
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^t"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^t"
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

+t:: {
	global counter
	if counter != 0 {
		Loop counter {
			Send "^+t"
		}
		counter := 0
		if WasInMouseManagerMode == true {
			gotoMouseMode()
		}
		else {
			gotoNormal()
		}
		Exit
	}
	Send "^+t"
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

w:: {
	Send "^!{Tab}"
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

#HotIf

#HotIf WindowManagerMode = 1
HotIf "WindowManagerMode = 1"

b:: Return
c:: Return
i:: Return
m:: Return
!f:: {
	global WasInWindowManagerMode := true
	gotoFMode()
	Exit
}
n:: Return
o:: Return
p:: Return
r:: Return
t:: Return
u:: Return
v:: Return
x:: Return
y:: Return
z:: Return
,:: Return
.:: Return
/:: Return
':: Return
[:: Return
]:: Return
\:: Return


h:: WindowManager().MoveLeft(Mouse.MediumMove)
k:: WindowManager().MoveUp(Mouse.MediumMove)
j:: WindowManager().MoveDown(Mouse.MediumMove)
l:: WindowManager().MoveRight(Mouse.MediumMove)

+h:: WindowManager().MoveLeft(Mouse.SmallMove)
+k:: WindowManager().MoveUp(Mouse.SmallMove)
+j:: WindowManager().MoveDown(Mouse.SmallMove)
+l:: WindowManager().MoveRight(Mouse.SmallMove)

^h:: WindowManager().MoveLeft(Mouse.BigMove)
^k:: WindowManager().MoveUp(Mouse.BigMove)
^j:: WindowManager().MoveDown(Mouse.BigMove)
^l:: WindowManager().MoveRight(Mouse.BigMove)


s:: WindowManager().DecreaseWidth(Mouse.MediumMove)
d:: WindowManager().IncreaseHeight(Mouse.MediumMove)
f:: WindowManager().DecreaseHeight(Mouse.MediumMove)
g:: WindowManager().IncreaseWidth(Mouse.MediumMove)

+s:: WindowManager().DecreaseWidth(Mouse.SmallMove)
+d:: WindowManager().IncreaseHeight(Mouse.SmallMove)
+f:: WindowManager().DecreaseHeight(Mouse.SmallMove)
+g:: WindowManager().IncreaseWidth(Mouse.SmallMove)

^s:: WindowManager().DecreaseWidth(Mouse.BigMove)
^d:: WindowManager().IncreaseHeight(Mouse.BigMove)
^f:: WindowManager().DecreaseHeight(Mouse.BigMove)
^g:: WindowManager().IncreaseWidth(Mouse.BigMove)

1:: WinMove(0, 0, , , "A")
2:: WinMove(Mouse.FarLeftX, 0, , , "A")
3:: WinMove(Mouse.HighLeftX, 0, , , "A")
4:: WinMove(Mouse.MiddleLeftX, 0, , , "A")
5:: WinMove(Mouse.LowLeftX, 0, , , "A")
6:: WinMove(Mouse.LessThanMiddleX, 0, , , "A")
7:: WinMove(Mouse.MiddleX, 0, , , "A")
8:: WinMove(Mouse.MoreThanMiddleX, 0, , , "A")
9:: WinMove(Mouse.LowRightX, 0, , , "A")
0:: WinMove(Mouse.MiddleRightX, 0, , , "A")

+1:: WinMove(0, Mouse.MiddleY, , , "A")
+2:: WinMove(Mouse.FarLeftX, Mouse.MiddleY, , , "A")
+3:: WinMove(Mouse.HighLeftX, Mouse.MiddleY, , , "A")
+4:: WinMove(Mouse.MiddleLeftX, Mouse.MiddleY, , , "A")
+5:: WinMove(Mouse.LowLeftX, Mouse.MiddleY, , , "A")
+6:: WinMove(Mouse.LessThanMiddleX, Mouse.MiddleY, , , "A")
+7:: WinMove(Mouse.MiddleX, Mouse.MiddleY, , , "A")
+8:: WinMove(Mouse.MoreThanMiddleX, Mouse.MiddleY, , , "A")
+9:: WinMove(Mouse.LowRightX, Mouse.MiddleY, , , "A")
+0:: WinMove(Mouse.MiddleRightX, Mouse.MiddleY, , , "A")

^1:: WinMove(0, Mouse.LowY, , , "A")
^2:: WinMove(Mouse.FarLeftX, Mouse.LowY, , , "A")
^3:: WinMove(Mouse.HighLeftX, Mouse.LowY, , , "A")
^4:: WinMove(Mouse.MiddleLeftX, Mouse.LowY, , , "A")
^5:: WinMove(Mouse.LowLeftX, Mouse.LowY, , , "A")
^6:: WinMove(Mouse.LessThanMiddleX, Mouse.LowY, , , "A")
^7:: WinMove(Mouse.MiddleX, Mouse.LowY, , , "A")
^8:: WinMove(Mouse.MoreThanMiddleX, Mouse.LowY, , , "A")
^9:: WinMove(Mouse.LowRightX, Mouse.LowY, , , "A")
^0:: WinMove(Mouse.MiddleRightX, Mouse.LowY, , , "A")

a:: WindowManager().SetFullHeight()
q:: WindowManager().SetHalfHeight()
w:: WindowManager().SetHalfWidth()
e:: WindowManager().SetFullWidth()

Esc:: {
	if (WasInMouseManagerMode == true) {
		gotoMouseMode()
	}
	else {
		gotoNormal()
	}
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

#HotIf