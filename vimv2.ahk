#SingleInstance
#MaxThreadsBuffer True
#MaxThreadsPerHotkey 5
#UseHook
#Include StateBulb.ahk
#Include Info.ahk
#Include Mouse.ahk
#Include WindowManager.ahk

SetKeyDelay -1
CoordMode "Mouse", "Screen"

; Set initial state to normal (disabled)
global normalMode := false
global dMode := false
global yMode := false
global fMode := false
global cMode := false
global windowMode := false
global visualMode := false
global visualLineMode := false
global insertMode := false
global WindowManagerMode := false
global mouseManagerMode := false

exitVim() {
	Infos.DestroyAll()
	Infos("Exit Vim", 1500)
	Global normalMode := false
	Global insertMode := false
	global dMode := false
	global yMode := false
	global cMode := false
	global fMode := false
	global windowMode := false
	Global visualMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	Global visualLineMode := false
	StateBulb[1].Destroy() ; Vim
	StateBulb[2].Destroy() ; Insert
	StateBulb[3].Destroy() ; Visual
	StateBulb[4].Destroy() ; Special
	StateBulb[5].Destroy() ; Move windows
	StateBulb[6].Destroy() ; Mouse Movement
	 ; StateBulb[4].Destroy() ; Delete
	 ; StateBulb[5].Destroy() ; Change
	 ; StateBulb[6].Destroy() ; Yank
	 ; StateBulb[7].Destroy() ; Window
	 ; StateBulb[8].Destroy() ; Fmode
	Exit
}

gotoWindowMode() {
	global normalMode := false
	global windowMode := true
	StateBulb[4].Create()
}

gotoMwMode() {
	global normalMode := false
	global WindowManagerMode := true
	StateBulb[5].Create()
}

gotoMouseMode() {
	global normalMode := false
	global mouseManagerMode := true
	StateBulb[6].Create()
}

gotoFMode() {
	global normalMode := false
	global fMode := true
	StateBulb[4].Create()
}

gotoDMode() {
	global normalMode := false
	global dMode := true
	StateBulb[4].Create()
	Send "{Right}"
}

gotoYMode() {
	global normalMode := false
	global yMode := true
	StateBulb[4].Create()
	Send "{Right}"
}

gotoCMode() {
	global normalMode := false
	global cMode := true
	StateBulb[4].Create()
	Send "{Right}"
}

gotoNormal() {
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	if insertMode == true {
		StateBulb[2].Destroy()
	}
	global normalMode := true
	global visualMode := false
	global insertMode := false
	global visualLineMode := false
	global dMode := false
	global cMode := false
	global fMode := false
	global yMode := false
	global windowMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[1].Create()
	Infos.DestroyAll()
	Infos("Normal Mode", 1500)
	Send "{Left}"
	Send "+{Right}"
}
gotoVisual() {
	global normalMode := true
	global visualMode := true
	global insertMode := false
	global visualLineMode := false
	global dMode := false
	global yMode := false
	global fMode := false
	global cMode := false
	global windowMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[3].Create()
	Infos.DestroyAll()
	Infos("Visual Mode", 1500)
}
gotoInsert() {
	StateBulb[6].Destroy() ; Mouse Movement
	StateBulb[5].Destroy() ; Move windows
	StateBulb[4].Destroy()
	if visualMode == true {
		StateBulb[3].Destroy()
	}
	global normalMode := false
	global visualMode := false
	global insertMode := true
	global visualLineMode := false
	global dMode := false
	global fMode := false
	global yMode := false
	global windowMode := false
	global cMode := false
	global WindowManagerMode := false
	global mouseManagerMode := false
	StateBulb[2].Create()
	Infos.DestroyAll()
	Infos("Insert Mode", 1500)
}

fMotion(){
	StateBulb[4].Create()
	global normalMode := false
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var )
	Send "{Home}"
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
}

delChanYanfMotion(){
	StateBulb[4].Create()
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var )
	Send "{Home}"
	loop FoundPos {
		Send "+{Right}"
	}
}
delChanYantMotion(){
	StateBulb[4].Create()
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var )
	Send "{Home}"
	loop FoundPos {
		Send "+{Right}"
	}
	Send "{Left}"
}

$CapsLock::Control
+!Control::CapsLock
+#r::Reload
+#e::Edit


; Define the hotkey to enable the keybindings
^[:: {
	gotoNormal()
	Exit
}

^]:: {
	gotoNormal()
	gotoMouseMode()
	Mouse.SmallMove  := 20
	Mouse.MediumMove := 70
	Mouse.BigMove    := 200
	exit
}

; f mode
#HotIf fMode = 1
HotIf "fMode = 1"

#HotIf

; window mode
#HotIf windowMode = 1
HotIf "windowMode = 1"

-::Return
`;::Return
=::Return
,::Return
.::Return
/::Return
'::Return
[::Return
]::Return
\::Return
a::Return
b::Return
c::Return
d::Return
e::Return
f::Return
g::Return
h::Return
i::Return
j::Return
k::Return
l::Return
m::Return
n::Return
o::Return
p::Return
r::Return
s::Return
u::Return
v::Return
w::Return
x::Return
y::Return
z::Return
0::Return
1::Return
2::Return
3::Return
4::Return
5::Return
6::Return
7::Return
8::Return
9::Return


^w::Return
^e::Return

!Esc:: {
	exitVim()
	Exit
}
Esc:: {
	gotoNormal()
	Exit
}

*q::{
	Send "^w"
	gotoNormal()
	Exit
}

t::{
	Send "^t"
	gotoNormal()
	Exit
}

+t::{
	Send "^+t"
	gotoNormal()
	Exit
}

#HotIf 

; yank mode
#HotIf yMode = 1
HotIf "yMode = 1"

!Esc:: {
	exitVim()
	Exit
}

Esc:: {
	gotoNormal()
	Exit
}

-::Return
`;::Return
=::Return
,::Return
.::Return
/::Return
'::Return
[::Return
]::Return
\::Return
a::Return
c::Return
d::Return
g::Return
h::Return
j::Return
k::Return
l::Return
m::Return
n::Return
o::Return
p::Return
q::Return
r::Return
s::Return
u::Return
v::Return
x::Return
z::Return
1::Return
2::Return
3::Return
4::Return
5::Return
6::Return
7::Return
8::Return
9::Return

f:: {
	delChanYanfMotion()
	Send "^c"
	gotoNormal()
	Exit
}

t:: {
	delChanYantMotion()
	Send "^c"
	gotoNormal()
	Exit
}

i:: {
	Send "^{Left}"
	Send "^+{Right}"
	Send "+{Left}"
	Send "^c"
	gotoNormal()
	Exit
}

y:: {
	Send "{Home}+{End}"
	Send "^c"
	gotoNormal()
	Exit
}

b:: {
	Send "^+{Left}"
	Send "^c"
	gotoNormal()
	Exit
}

w:: {
	Send "^+{Right}"
	Send "^c"
	gotoNormal()
	Exit
}

0::
{
	Send "+{home}"
	Send "^c"
	gotoNormal()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^c"
	gotoNormal()
	Exit
}

; Change mode
#HotIf cMode = 1
HotIf "cMode = 1"
Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
	Exit
}

-::Return
`;::Return
=::Return
,::Return
.::Return
/::Return
'::Return
[::Return
]::Return
\::Return
a::Return
d::Return
g::Return
h::Return
j::Return
k::Return
l::Return
m::Return
n::Return
o::Return
p::Return
q::Return
r::Return
s::Return
u::Return
v::Return
x::Return
y::Return
z::Return
1::Return
2::Return
3::Return
4::Return
5::Return
6::Return
7::Return
8::Return
9::Return

f:: {
	delChanYanfMotion()
	Send "^x"
	gotoInsert()
	Exit
}
t:: {
	delChanYantMotion()
	Send "^x"
	gotoInsert()
	Exit
}

i:: {
	Send "^{Left}"
	Send "^+{Right}"
	Send "+{Left}"
	Send "^x"
	gotoInsert()
	Exit
}

c:: {
	Send "{Home}+{End}"
	Send "^x"
	Send "{Delete}"
	gotoInsert()
	Exit
}

b:: {
	Send "{Left}"
	Send "^+{Left}"
	Send "^x"
	gotoInsert()
	Exit
}

w:: {
	Send "{Left}"
	Send "^+{Right}"
	Send "^x"
	gotoInsert()
	Exit
}

0::
{
	Send "+{home}"
	Send "^x"
	gotoInsert()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoInsert()
	Exit
}

#HotIf
; Delete mode
#HotIf dMode = 1
HotIf "dMode = 1"


-::Return
=::Return
,::Return
`;::Return
.::Return
/::Return
'::Return
[::Return
]::Return
\::Return
a::Return
c::Return
g::Return
h::Return
j::Return
k::Return
l::Return
m::Return
n::Return
o::Return
p::Return
q::Return
r::Return
s::Return
u::Return
v::Return
x::Return
y::Return
z::Return
1::Return
2::Return
3::Return
4::Return
5::Return
6::Return
7::Return
8::Return
9::Return

f:: {
	delChanYanfMotion()
	Send "^x"
	gotoNormal()
	Exit
}
t:: {
	delChanYantMotion()
	Send "^x"
	gotoNormal()
	Exit
}

i:: {
	Send "^{Left}"
	Send "^+{Right}"
	Send "+{Left}"
	Send "^x"
	gotoNormal()
	Exit
}

Esc:: {
	gotoNormal()
	Exit
}
!Esc:: {
	exitVim()
	Exit
}

d:: {
	Send "{Home}+{End}"
	Send "^x"
	Send "{Delete}"
	gotoNormal()
	Exit
}

b:: {
	Send "{Left}"
	Send "^+{Left}"
	Send "^x"
	gotoNormal()
	Exit
}

w:: {
	Send "{Left}"
	Send "^+{Right}"
	Send "^x"
	gotoNormal()
	Exit
}

0::
{
	Send "+{home}"
	Send "^x"
	gotoNormal()
	Exit
}

+4::
{
	Send "+{End}"
	Send "^x"
	gotoNormal()
	Exit
}

#HotIf

; insert Mode
#HotIf insertMode = 1
HotIf "insertMode = 1"

!Esc:: {
	exitVim()
	Exit
}

Esc:: {
	gotoNormal()
	Exit
}

^u::{
	Send "{Home}+{End}"
	Send "{BS}"
	Exit
}

^x::{
	Send "+{Home}"
	Send "{BS}"
	Exit
}

^k:: Send "+{end}{Delete}"

^w:: {
	Send "^{bs}"
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

$!j:: {
	Send "{Down}"
	Exit
}

$!k:: {
	Send "{Up}"
	Exit
}

^f:: {
	Send "{Right}"
	Exit
}

$!l:: {
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


; normal Mode
#HotIf normalMode = 1
HotIf "normalMode = 1"

-::Return
`;::Return
`::Return
+`:: {
	if visualMode == true {
		oldclip := A_Clipboard
		Send "^c"
		ClipWait 1
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
		gotoNormal()
		A_Clipboard := oldclip
	}
	else {
		oldclip := A_Clipboard
		Send "^c"
		ClipWait 1
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
=::Return
,::Return
.::Return
/::Return
'::Return
[::Return
\::Return
m:: { 
	gotoMwMode()
	Exit
}
n::Return
q::Return
r::Return
s::{
	Send "{BS}"
	gotoInsert()
	Exit
}
t::Return
z::Return
1::Return
2::Return
3::Return
4::Return
5::Return
6::Return
7::Return
8::Return
9::Return



+f::{
	StateBulb[4].Create()
	global normalMode := false
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Left}"
	Send "+{Home}"
	Send "^c"
	Send "{Right}"
	ClipWait 1
	Haystack := A_Clipboard
	A_Clipboard := oldclip
	FoundPos := InStr(Haystack, var, false, -1)
	Send "{Home}"
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	StateBulb[4].Destroy()
}

f::{
	StateBulb[4].Create()
	global normalMode := false
	ih := InputHook("C")
	ih.KeyOpt("{All}", "ESI") ;End Keys & Suppress
	ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-ES") ;Exclude the modifiers
	ih.Start()
	ih.Wait()
	var := ih.EndKey
	oldclip := A_Clipboard
	A_Clipboard := ""
	Send "{Right}"
	Send "+{End}"
	Send "^c"
	Send "{Left}"
	ClipWait 1
	Haystack := A_Clipboard
	FoundPos := InStr(Haystack, var )
	loop FoundPos {
		Send "{Right}"
	}
	Send "{Left}"
	Send "+{Right}"
	global normalMode := true
	StateBulb[4].Destroy()
}

g::{
	Send "^{Home}"
	Exit
}

+g::{
	Send "^{End}"
	Exit
}


$^w:: {
	if visualMode == true {
		Exit
	}
	else {
		gotoWindowMode()
	}
	Exit
}

e:: {
	Send "^{Right}"
	Send "{Left 2}"
	Send "+{Right}"
}

!Esc:: {
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
	if visualMode == true {
		Send "^x"
		gotoNormal()
		Exit
	}
	gotoDMode()
}

^e::
{
	Send "{WheelDown}"
}

^y::
{
	Send "{WheelUp}"
}

Esc:: {
	if visualMode == true
	{
		gotoNormal()
	}
	else
	{
		Send "{Esc}"
		Exit
	}
}

v:: {
	Global visualMode := true
	Send "{Left}"
	StateBulb[3].Create()
	Infos.DestroyAll()
	Infos("Visual Mode", 1500)
	Exit
}

+v:: {
	Send "{Home}"
	Send "+{End}"
	Global visualMode := true
	Global visualLineMode := true
	StateBulb[3].Create()
	Infos.DestroyAll()
	Infos("Visual Mode", 1500)
	Exit
}

i:: {
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
	if visualMode == true
	{
		Send "+{left}"
	}
	else
	{
		Send "{Left}"
		Send "{Left}"
		Send "+{Right}"
		Exit
	}
}

$j:: {
	if visualLineMode == true
	{
		Send "+{Down}"
		Send "+{End}"
	}
	else if visualMode == true
	{
		Send "+{Down}"
	}
	else
	{
		Send "{Left}"
		Send "{Down}"
		Send "+{Right}"
		Exit
	}
}

$k:: {
	if visualLineMode == true
	{
		Send "+{Up}"
		Send "+{Home}"
	}
	else if visualMode == true
	{
		Send "+{Up}"
	}
	else
	{
		Send "{Left}"
		Send "{Up}"
		Send "+{Right}"
		Exit
	}
}

$l:: {
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

^h:: {
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

^l:: {
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
	if visualMode == true {
		Send "^x"
		gotoInsert()
		Exit
	}
	else {
		gotoCMode()
	}
}

x:: {
	Send "{Delete}"
	Send "+{Right}"
	Exit
}

b:: {
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

w:: {
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
	Send "{End}{Enter}"
	gotoInsert()
	Exit
}

+O:: {
	Send "{Home}{Enter}{Up}"
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
	if visualMode == true {
		Send "^c"
		Exit
	}
	else {
		gotoYMode()
	}
}

+p:: {
	Send "{Left}"
	Send "^v"
	Exit
}

p:: {
	Send "{Right}"
	Send "^v"
	Exit
}

0::
{
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

!j:: {
	if visualLineMode == true
	{
		Send "+{Down}"
		Send "+{End}"
	}
	else if visualMode == true
	{
		Send "+{Down}"
	}
	else
	{
		Send "{Left}"
		Send "{Down}"
		Send "+{Right}"
		Exit
	}
}

!k:: {
	if visualLineMode == true
	{
		Send "+{Up}"
		Send "+{Home}"
	}
	else if visualMode == true
	{
		Send "+{Up}"
	}
	else
	{
		Send "{Left}"
		Send "{Up}"
		Send "+{Right}"
		Exit
	}
}
#HotIf




#HotIf WindowManagerMode = 1
HotIf "WindowManagerMode = 1"

h::WindowManager().MoveLeft(Mouse.MediumMove)
k::WindowManager().MoveUp(Mouse.MediumMove)
j::WindowManager().MoveDown(Mouse.MediumMove)
l::WindowManager().MoveRight(Mouse.MediumMove)

+h::WindowManager().MoveLeft(Mouse.SmallMove)
+k::WindowManager().MoveUp(Mouse.SmallMove)
+j::WindowManager().MoveDown(Mouse.SmallMove)
+l::WindowManager().MoveRight(Mouse.SmallMove)

^h::WindowManager().MoveLeft(Mouse.BigMove)
^k::WindowManager().MoveUp(Mouse.BigMove)
^j::WindowManager().MoveDown(Mouse.BigMove)
^l::WindowManager().MoveRight(Mouse.BigMove)


s::WindowManager().DecreaseWidth(Mouse.MediumMove)
f::WindowManager().IncreaseHeight(Mouse.MediumMove)
d::WindowManager().DecreaseHeight(Mouse.MediumMove)
g::WindowManager().IncreaseWidth(Mouse.MediumMove)

+s::WindowManager().DecreaseWidth(Mouse.SmallMove)
+f::WindowManager().IncreaseHeight(Mouse.SmallMove)
+d::WindowManager().DecreaseHeight(Mouse.SmallMove)
+g::WindowManager().IncreaseWidth(Mouse.SmallMove)

^s::WindowManager().DecreaseWidth(Mouse.BigMove)
^f::WindowManager().IncreaseHeight(Mouse.BigMove)
^d::WindowManager().DecreaseHeight(Mouse.BigMove)
^g::WindowManager().IncreaseWidth(Mouse.BigMove)

1::WinMove(0,                     0,,, "A")
2::WinMove(Mouse.FarLeftX,        0,,, "A")
3::WinMove(Mouse.HighLeftX,       0,,, "A")
4::WinMove(Mouse.MiddleLeftX,     0,,, "A")
5::WinMove(Mouse.LowLeftX,        0,,, "A")
6::WinMove(Mouse.LessThanMiddleX, 0,,, "A")
7::WinMove(Mouse.MiddleX,         0,,, "A")
8::WinMove(Mouse.MoreThanMiddleX, 0,,, "A")
9::WinMove(Mouse.LowRightX,       0,,, "A")
0::WinMove(Mouse.MiddleRightX,    0,,, "A")

+1::WinMove(0,                     Mouse.MiddleY,,, "A")
+2::WinMove(Mouse.FarLeftX,        Mouse.MiddleY,,, "A")
+3::WinMove(Mouse.HighLeftX,       Mouse.MiddleY,,, "A")
+4::WinMove(Mouse.MiddleLeftX,     Mouse.MiddleY,,, "A")
+5::WinMove(Mouse.LowLeftX,        Mouse.MiddleY,,, "A")
+6::WinMove(Mouse.LessThanMiddleX, Mouse.MiddleY,,, "A")
+7::WinMove(Mouse.MiddleX,         Mouse.MiddleY,,, "A")
+8::WinMove(Mouse.MoreThanMiddleX, Mouse.MiddleY,,, "A")
+9::WinMove(Mouse.LowRightX,       Mouse.MiddleY,,, "A")
+0::WinMove(Mouse.MiddleRightX,    Mouse.MiddleY,,, "A")

^1::WinMove(0,                     Mouse.LowY,,, "A")
^2::WinMove(Mouse.FarLeftX,        Mouse.LowY,,, "A")
^3::WinMove(Mouse.HighLeftX,       Mouse.LowY,,, "A")
^4::WinMove(Mouse.MiddleLeftX,     Mouse.LowY,,, "A")
^5::WinMove(Mouse.LowLeftX,        Mouse.LowY,,, "A")
^6::WinMove(Mouse.LessThanMiddleX, Mouse.LowY,,, "A")
^7::WinMove(Mouse.MiddleX,         Mouse.LowY,,, "A")
^8::WinMove(Mouse.MoreThanMiddleX, Mouse.LowY,,, "A")
^9::WinMove(Mouse.LowRightX,       Mouse.LowY,,, "A")
^0::WinMove(Mouse.MiddleRightX,    Mouse.LowY,,, "A")

a::WindowManager().SetFullHeight()
q::WindowManager().SetHalfHeight()
w::WindowManager().SetHalfWidth()
e::WindowManager().SetFullWidth()

Esc:: {
	gotoNormal()
	Exit
}

!Esc:: {
	exitVim()
}


#HotIf 

#HotIf mouseManagerMode = 1
HotIf "mouseManagerMode = 1"


i:: {
	gotoInsert()
	Exit
}

!h:: Send "!{Left}"

!l:: Send "!{Right}"

+h::Mouse.MoveLeft(Mouse.MediumMove)
+k::Mouse.MoveUp(Mouse.MediumMove)
+j::Mouse.MoveDown(Mouse.MediumMove)
+l::Mouse.MoveRight(Mouse.MediumMove)

h::Mouse.MoveLeft(Mouse.SmallMove)
k::Mouse.MoveUp(Mouse.SmallMove)
j::Mouse.MoveDown(Mouse.SmallMove)
l::Mouse.MoveRight(Mouse.SmallMove)

^h::Mouse.MoveLeft(Mouse.BigMove)
^k::Mouse.MoveUp(Mouse.BigMove)
^j::Mouse.MoveDown(Mouse.BigMove)
^l::Mouse.MoveRight(Mouse.BigMove)

*y::Click()
*u::Click("Right")
*n::Click("Middle")
#y::Mouse.HoldIfUp("L")
#u::Mouse.HoldIfUp("R")
#n::Mouse.HoldIfUp("M")

1::MouseMove(Mouse.FarLeftX,        Mouse.MiddleY)
2::MouseMove(Mouse.HighLeftX,       Mouse.MiddleY)
3::MouseMove(Mouse.MiddleLeftX,     Mouse.MiddleY)
4::MouseMove(Mouse.LowLeftX,        Mouse.MiddleY)
5::MouseMove(Mouse.LessThanMiddleX, Mouse.MiddleY)
6::MouseMove(Mouse.MoreThanMiddleX, Mouse.MiddleY)
7::MouseMove(Mouse.LowRightX,       Mouse.MiddleY)
8::MouseMove(Mouse.MiddleRightX,    Mouse.MiddleY)
9::MouseMove(Mouse.HighRightX,      Mouse.MiddleY)
0::MouseMove(Mouse.FarRightX,       Mouse.MiddleY)

^1::MouseMove(Mouse.FarLeftX,        Mouse.TopY)
^2::MouseMove(Mouse.HighLeftX,       Mouse.TopY)
^3::MouseMove(Mouse.MiddleLeftX,     Mouse.TopY)
^4::MouseMove(Mouse.LowLeftX,        Mouse.TopY)
^5::MouseMove(Mouse.LessThanMiddleX, Mouse.TopY)
^6::MouseMove(Mouse.MoreThanMiddleX, Mouse.TopY)
^7::MouseMove(Mouse.LowRightX,       Mouse.TopY)
^8::MouseMove(Mouse.MiddleRightX,    Mouse.TopY)
^9::MouseMove(Mouse.HighRightX,      Mouse.TopY)
^0::MouseMove(Mouse.FarRightX,       Mouse.TopY)

+1::MouseMove(Mouse.FarLeftX,        Mouse.BottomY)
+2::MouseMove(Mouse.HighLeftX,       Mouse.BottomY)
+3::MouseMove(Mouse.MiddleLeftX,     Mouse.BottomY)
+4::MouseMove(Mouse.LowLeftX,        Mouse.BottomY)
+5::MouseMove(Mouse.LessThanMiddleX, Mouse.BottomY)
+6::MouseMove(Mouse.MoreThanMiddleX, Mouse.BottomY)
+7::MouseMove(Mouse.LowRightX,       Mouse.BottomY)
+8::MouseMove(Mouse.MiddleRightX,    Mouse.BottomY)
+9::MouseMove(Mouse.HighRightX,      Mouse.BottomY)
+0::MouseMove(Mouse.FarRightX,       Mouse.BottomY)

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
