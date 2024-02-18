; Using Keyboard Numpad as a Mouse (based on the v1 script by deguix)
; https://www.autohotkey.com
; This script makes mousing with your keyboard almost as easy
; as using a real mouse (maybe even easier for some tasks).
; It supports up to five mouse buttons and the turning of the
; mouse wheel.  It also features customizable movement speed,
; acceleration, and "axis inversion".

/*
o------------------------------------------------------------o
|Using Keyboard Numpad as a Mouse                            |
(------------------------------------------------------------)
|                     / A Script file for AutoHotkey         |
|                    ----------------------------------------|
|                                                            |
|    This script is an example of use of AutoHotkey. It uses |
| the remapping of numpad keys of a keyboard to transform it |
| into a mouse. Some features are the acceleration which     |
| enables you to increase the mouse movement when holding    |
| a key for a long time, and the rotation which makes the    |
| numpad mouse to "turn". I.e. NumpadDown as NumpadUp        |
| and vice-versa. See the list of keys used below:           |
|                                                            |
|------------------------------------------------------------|
| Keys                  | Description                        |
|------------------------------------------------------------|
| ScrollLock (toggle on)| Activates numpad mouse mode.       |
|-----------------------|------------------------------------|
| Numpad0               | Left mouse button click.           |
| Numpad5               | Middle mouse button click.         |
| NumpadDot             | Right mouse button click.          |
| NumpadDiv/NumpadMult  | X1/X2 mouse button click.          |
| NumpadSub/NumpadAdd   | Moves up/down the mouse wheel.     |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled off) | Activates mouse movement mode.     |
|-----------------------|------------------------------------|
| NumpadEnd/Down/PgDn/  | Mouse movement.                    |
| /Left/Right/Home/Up/  |                                    |
| /PgUp                 |                                    |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (toggled on)  | Activates mouse speed adj. mode.   |
|-----------------------|------------------------------------|
| Numpad7/Numpad1       | Inc./dec. acceleration per         |
|                       | button press.                      |
| Numpad8/Numpad2       | Inc./dec. initial speed per        |
|                       | button press.                      |
| Numpad9/Numpad3       | Inc./dec. maximum speed per        |
|                       | button press.                      |
| !Numpad7/!Numpad1     | Inc./dec. wheel acceleration per   |
|                       | button press*.                     |
| !Numpad8/!Numpad2     | Inc./dec. wheel initial speed per  |
|                       | button press*.                     |
| !Numpad9/!Numpad3     | Inc./dec. wheel maximum speed per  |
|                       | button press*.                     |
| Numpad4/Numpad6       | Inc./dec. rotation angle to        |
|                       | right in degrees. (i.e. 180°=      |
|                       | = inversed controls).              |
|------------------------------------------------------------|
| * = These options are affected by the mouse wheel speed    |
| adjusted on Control Panel. If you don't have a mouse with  |
| wheel, the default is 3 +/- lines per option button press. |
o------------------------------------------------------------o
*/

;START OF CONFIG SECTION

#SingleInstance
A_MaxHotkeysPerInterval := 500

; Using the keyboard hook to implement the Numpad hotkeys prevents
; them from interfering with the generation of ANSI characters such
; as à.  This is because AutoHotkey generates such characters
; by holding down ALT and sending a series of Numpad keystrokes.
; Hook hotkeys are smart enough to ignore such keystrokes.
; #UseHook

g_MouseSpeed := 5
g_MouseAccelerationSpeed := 20
g_MouseMaxSpeed := 25

oldg_MouseSpeed := 0
oldg_MouseAccelerationSpeed := 0
oldg_MouseMaxSpeed := 0


shfitToggle := 0
ctrlToggle := 0

;Mouse wheel speed is also set on Control Panel. As that
;will affect the normal mouse behavior, the real speed of
;these three below are times the normal mouse wheel speed.
g_MouseWheelSpeed := 1
g_MouseWheelAccelerationSpeed := 10
g_MouseWheelMaxSpeed := 20

g_MouseRotationAngle := 0

;END OF CONFIG SECTION

;This is needed or key presses would faulty send their natural
;actions. Like NumpadDiv would send sometimes "/" to the
;screen.
InstallKeybdHook

g_Temp := 0
g_Temp2 := 0

;Divide by 45° because MouseMove only supports whole numbers,
;and changing the mouse rotation to a number lesser than 45°
;could make strange movements.
;
;For example: 22.5° when pressing NumpadUp:
;  First it would move upwards until the speed
;  to the side reaches 1.
g_MouseRotationAnglePart := g_MouseRotationAngle / 45

g_MouseCurrentAccelerationSpeed := 0
g_MouseCurrentSpeed := g_MouseSpeed
g_MouseCurrentSpeedToDirection := 0
g_MouseCurrentSpeedToSide := 0

g_MouseWheelCurrentAccelerationSpeed := 0
g_MouseWheelCurrentSpeed := g_MouseSpeed
g_MouseWheelAccelerationSpeedReal := 0
g_MouseWheelMaxSpeedReal := 0
g_MouseWheelSpeedReal := 0

g_Button := 0

SetKeyDelay -1
SetMouseDelay -1

; Hotkey "*Numpad0", ButtonLeftClick
; Hotkey "*NumpadIns", ButtonLeftClickIns
; Hotkey "*Numpad5", ButtonMiddleClick
; Hotkey "*NumpadClear", ButtonMiddleClickClear
; Hotkey "*NumpadDot", ButtonRightClick
; Hotkey "*NumpadDel", ButtonRightClickDel
; Hotkey "*NumpadDiv", ButtonX1Click
; Hotkey "*NumpadMult", ButtonX2Click

; Hotkey "*NumpadSub", ButtonWheelAcceleration
; Hotkey "*NumpadAdd", ButtonWheelAcceleration

; Hotkey "*NumpadUp", ButtonAcceleration
; Hotkey "*NumpadDown", ButtonAcceleration
; Hotkey "*NumpadLeft", ButtonAcceleration
; Hotkey "*NumpadRight", ButtonAcceleration
; Hotkey "*NumpadHome", ButtonAcceleration
; Hotkey "*NumpadEnd", ButtonAcceleration
; Hotkey "*NumpadPgUp", ButtonAcceleration
; Hotkey "*NumpadPgDn", ButtonAcceleration

; Hotkey "Numpad8", ButtonSpeedUp
; Hotkey "Numpad2", ButtonSpeedDown
; Hotkey "Numpad7", ButtonAccelerationSpeedUp
; Hotkey "Numpad1", ButtonAccelerationSpeedDown
; Hotkey "Numpad9", ButtonMaxSpeedUp
; Hotkey "Numpad3", ButtonMaxSpeedDown

; Hotkey "Numpad6", ButtonRotationAngleUp
; Hotkey "Numpad4", ButtonRotationAngleDown

; Hotkey "!Numpad8", ButtonWheelSpeedUp
; Hotkey "!Numpad2", ButtonWheelSpeedDown
; Hotkey "!Numpad7", ButtonWheelAccelerationSpeedUp
; Hotkey "!Numpad1", ButtonWheelAccelerationSpeedDown
; Hotkey "!Numpad9", ButtonWheelMaxSpeedUp
; Hotkey "!Numpad3", ButtonWheelMaxSpeedDown

; ToggleKeyActivationSupport  ; Initialize based on current ScrollLock state.

;Key activation support

;Mouse click support

ButtonLeftClick(*)
{
	if GetKeyState("LButton")
		return
	Button2 := "t"
	ButtonClick := "Left"
	ButtonClickStart Button2, ButtonClick
}

ButtonLeftClickIns(*)
{
	if GetKeyState("LButton")
		return
	Button2 := "NumpadIns"
	ButtonClick := "Left"
	ButtonClickStart Button2, ButtonClick
}

ButtonMiddleClick(*)
{
	if GetKeyState("MButton")
		return
	Button2 := "Numpad5"
	ButtonClick := "Middle"
	ButtonClickStart Button2, ButtonClick
}

ButtonMiddleClickClear(*)
{
	if GetKeyState("MButton")
		return
	Button2 := "NumpadClear"
	ButtonClick := "Middle"
	ButtonClickStart Button2, ButtonClick
}

ButtonRightClick(*)
{
	if GetKeyState("RButton")
		return
	Button2 := "NumpadDot"
	ButtonClick := "Right"
	ButtonClickStart Button2, ButtonClick
}

ButtonRightClickDel(*)
{
	if GetKeyState("RButton")
		return
	Button2 := "NumpadDel"
	ButtonClick := "Right"
	ButtonClickStart Button2, ButtonClick
}

ButtonX1Click(*)
{
	if GetKeyState("XButton1")
		return
	Button2 := "NumpadDiv"
	ButtonClick := "X1"
	ButtonClickStart Button2, ButtonClick
}

ButtonX2Click(*)
{
	if GetKeyState("XButton2")
		return
	Button2 := "NumpadMult"
	ButtonClick := "X2"
	ButtonClickStart Button2, ButtonClick
}

ButtonClickStart(Button2, ButtonClick)
{
	MouseClick ButtonClick, , , 1, 0, "D"
	SetTimer ButtonClickEnd.Bind(Button2, ButtonClick), 10
}

ButtonClickEnd(Button2, ButtonClick)
{
	if GetKeyState(Button2, "P")
		return

	SetTimer , 0
	MouseClick ButtonClick, , , 1, 0, "U"
}

;Mouse movement support

ButtonSpeedUp(*)
{
	global
	g_MouseSpeed++
	ToolTip "Mouse speed: " g_MouseSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseSpeed := g_MouseSpeed
}

ButtonSpeedDown(*)
{
	global
	if g_MouseSpeed > 1
		g_MouseSpeed--
	if g_MouseSpeed = 1
		ToolTip "Mouse speed: " g_MouseSpeed " pixel"
	else
		ToolTip "Mouse speed: " g_MouseSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseSpeed := g_MouseSpeed
}

ButtonAccelerationSpeedUp(*)
{
	global
	g_MouseAccelerationSpeed++
	ToolTip "Mouse acceleration speed: " g_MouseAccelerationSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseAccelerationSpeed := g_MouseAccelerationSpeed
}

ButtonAccelerationSpeedDown(*)
{
	global
	if g_MouseAccelerationSpeed > 1
		g_MouseAccelerationSpeed--
	if g_MouseAccelerationSpeed = 1
		ToolTip "Mouse acceleration speed: " g_MouseAccelerationSpeed " pixel"
	else
		ToolTip "Mouse acceleration speed: " g_MouseAccelerationSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseAccelerationSpeed := g_MouseAccelerationSpeed
}

ButtonMaxSpeedUp(*)
{
	global
	g_MouseMaxSpeed++
	ToolTip "Mouse maximum speed: " g_MouseMaxSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseMaxSpeed := g_MouseMaxSpeed
}

ButtonMaxSpeedDown(*)
{
	global
	if g_MouseMaxSpeed > 1
		g_MouseMaxSpeed--
	if g_MouseMaxSpeed = 1
		ToolTip "Mouse maximum speed: " g_MouseMaxSpeed " pixel"
	else
		ToolTip "Mouse maximum speed: " g_MouseMaxSpeed " pixels"
	SetTimer ToolTip, -1000
	oldg_MouseMaxSpeed := g_MouseMaxSpeed
}

ButtonRotationAngleUp(*)
{
	global
	g_MouseRotationAnglePart++
	if g_MouseRotationAnglePart >= 8
		g_MouseRotationAnglePart := 0
	g_MouseRotationAngle := g_MouseRotationAnglePart
	g_MouseRotationAngle *= 45
	ToolTip "Mouse rotation angle: " g_MouseRotationAngle "°"
	SetTimer ToolTip, -1000
}

ButtonRotationAngleDown(*)
{
	global
	g_MouseRotationAnglePart--
	if g_MouseRotationAnglePart < 0
		g_MouseRotationAnglePart := 7
	g_MouseRotationAngle := g_MouseRotationAnglePart
	g_MouseRotationAngle *= 45
	ToolTip "Mouse rotation angle: " g_MouseRotationAngle "°"
	SetTimer ToolTip, -1000
}

ButtonAcceleration(ThisHotkey)
{
	global
	if g_Button != 0
	{
		if !InStr(ThisHotkey, g_Button)
		{
			g_MouseCurrentAccelerationSpeed := 0
			g_MouseCurrentSpeed := g_MouseSpeed
		}
	}
	g_Button := StrReplace(ThisHotkey, "*")

	if g_Button = "+h" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+j" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+k" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+l" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+u" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+o" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+n" {
		mouseslowfastSpeed()
	}
	else if g_Button = "+," {
		mouseslowfastSpeed()
	}
	else if g_Button = "^h" {
		controlSpeed()
	}
	else if g_Button = "^j" {
		controlSpeed()
	}
	else if g_Button = "^k" {
		controlSpeed()
	}
	else if g_Button = "^l" {
		controlSpeed()
	}
	else if g_Button = "^u" {
		controlSpeed()
	}
	else if g_Button = "^o" {
		controlSpeed()
	}
	else if g_Button = "^n" {
		controlSpeed()
	}
	else if g_Button = "^," {
		controlSpeed()
	}
	; else if g_Button = "h" {
	; 	normalSpeed()
	; }
	; else if g_Button = "j" {
	; 	normalSpeed()
	; }
	; else if g_Button = "k" {
	; 	normalSpeed()
	; }
	; else if g_Button = "l" {
	; 	normalSpeed()
	; }
	; else if g_Button = "u" {
	; 	normalSpeed()
	; }
	; else if g_Button = "o" {
	; 	normalSpeed()
	; }
	; else if g_Button = "n" {
	; 	normalSpeed()
	; }
	; else if g_Button = "," {
	; 	normalSpeed()
	; }

	ButtonAccelerationStart
}

ButtonAccelerationStart()
{
	global

	if g_MouseAccelerationSpeed >= 1
	{
		if g_MouseMaxSpeed > g_MouseCurrentSpeed
		{
			g_Temp := 0.001
			g_Temp *= g_MouseAccelerationSpeed
			g_MouseCurrentAccelerationSpeed += g_Temp
			g_MouseCurrentSpeed += g_MouseCurrentAccelerationSpeed
		}
	}

	;g_MouseRotationAngle convertion to speed of button direction
	g_MouseCurrentSpeedToDirection := g_MouseRotationAngle
	g_MouseCurrentSpeedToDirection /= 90.0
	g_Temp := g_MouseCurrentSpeedToDirection

	if g_Temp >= 0
	{
		if g_Temp < 1
		{
			g_MouseCurrentSpeedToDirection := 1
			g_MouseCurrentSpeedToDirection -= g_Temp
			EndMouseCurrentSpeedToDirectionCalculation
			return
		}
	}
	if g_Temp >= 1
	{
		if g_Temp < 2
		{
			g_MouseCurrentSpeedToDirection := 0
			g_Temp -= 1
			g_MouseCurrentSpeedToDirection -= g_Temp
			EndMouseCurrentSpeedToDirectionCalculation
			return
		}
	}
	if g_Temp >= 2
	{
		if g_Temp < 3
		{
			g_MouseCurrentSpeedToDirection := -1
			g_Temp -= 2
			g_MouseCurrentSpeedToDirection += g_Temp
			EndMouseCurrentSpeedToDirectionCalculation
			return
		}
	}
	if g_Temp >= 3
	{
		if g_Temp < 4
		{
			g_MouseCurrentSpeedToDirection := 0
			g_Temp -= 3
			g_MouseCurrentSpeedToDirection += g_Temp
			EndMouseCurrentSpeedToDirectionCalculation
			return
		}
	}
	EndMouseCurrentSpeedToDirectionCalculation
}

EndMouseCurrentSpeedToDirectionCalculation()
{
	global

	;g_MouseRotationAngle convertion to speed of 90 degrees to right
	g_MouseCurrentSpeedToSide := g_MouseRotationAngle
	g_MouseCurrentSpeedToSide /= 90.0
	g_Temp := Mod(g_MouseCurrentSpeedToSide, 4)

	if g_Temp >= 0
	{
		if g_Temp < 1
		{
			g_MouseCurrentSpeedToSide := 0
			g_MouseCurrentSpeedToSide += g_Temp
			EndMouseCurrentSpeedToSideCalculation
			return
		}
	}
	if g_Temp >= 1
	{
		if g_Temp < 2
		{
			g_MouseCurrentSpeedToSide := 1
			g_Temp -= 1
			g_MouseCurrentSpeedToSide -= g_Temp
			EndMouseCurrentSpeedToSideCalculation
			return
		}
	}
	if g_Temp >= 2
	{
		if g_Temp < 3
		{
			g_MouseCurrentSpeedToSide := 0
			g_Temp -= 2
			g_MouseCurrentSpeedToSide -= g_Temp
			EndMouseCurrentSpeedToSideCalculation
			return
		}
	}
	if g_Temp >= 3
	{
		if g_Temp < 4
		{
			g_MouseCurrentSpeedToSide := -1
			g_Temp -= 3
			g_MouseCurrentSpeedToSide += g_Temp
			EndMouseCurrentSpeedToSideCalculation
			return
		}
	}
	EndMouseCurrentSpeedToSideCalculation
}

EndMouseCurrentSpeedToSideCalculation()
{
	global

	g_MouseCurrentSpeedToDirection *= g_MouseCurrentSpeed
	g_MouseCurrentSpeedToSide *= g_MouseCurrentSpeed

	g_Temp := Mod(g_MouseRotationAnglePart, 2)

	if g_Button = "k" or g_Button = "+k" or g_Button = "^k"
	{
		if g_Temp = 1
		{
			g_MouseCurrentSpeedToSide *= 2
			g_MouseCurrentSpeedToDirection *= 2
		}

		g_MouseCurrentSpeedToDirection *= -1

		MouseGetPos &x, &y
		x += g_MouseCurrentSpeedToSide
		y += g_MouseCurrentSpeedToDirection
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_MouseCurrentSpeedToSide, g_MouseCurrentSpeedToDirection, 0, "R"
	}
	else if g_Button = "j" or g_Button = "+j" or g_Button = "^j"
	{
		if g_Temp = 1
		{
			g_MouseCurrentSpeedToSide *= 2
			g_MouseCurrentSpeedToDirection *= 2
		}

		g_MouseCurrentSpeedToSide *= -1

		MouseGetPos &x, &y
		x += g_MouseCurrentSpeedToSide
		y += g_MouseCurrentSpeedToDirection
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_MouseCurrentSpeedToSide, g_MouseCurrentSpeedToDirection, 0, "R"
	}
	else if g_Button = "h" or g_Button = "+h" or g_Button = "^h"
	{
		if g_Temp = 1
		{
			g_MouseCurrentSpeedToSide *= 2
			g_MouseCurrentSpeedToDirection *= 2
		}

		g_MouseCurrentSpeedToSide *= -1
		g_MouseCurrentSpeedToDirection *= -1

		MouseGetPos &x, &y
		x += g_MouseCurrentSpeedToDirection
		y += g_MouseCurrentSpeedToSide
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_MouseCurrentSpeedToDirection, g_MouseCurrentSpeedToSide, 0, "R"
	}
	else if g_Button = "l" or g_Button = "+l" or g_Button = "^l"
	{
		if g_Temp = 1
		{
			g_MouseCurrentSpeedToSide *= 2
			g_MouseCurrentSpeedToDirection *= 2
		}

		MouseGetPos &x, &y
		x += g_MouseCurrentSpeedToDirection
		y += g_MouseCurrentSpeedToSide
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_MouseCurrentSpeedToDirection, g_MouseCurrentSpeedToSide, 0, "R"
	}
	else if g_Button = "u" or g_Button = "+u" or g_Button = "^u"
	{
		g_Temp := g_MouseCurrentSpeedToDirection
		g_Temp -= g_MouseCurrentSpeedToSide
		g_Temp *= -1
		g_Temp2 := g_MouseCurrentSpeedToDirection
		g_Temp2 += g_MouseCurrentSpeedToSide
		g_Temp2 *= -1

		MouseGetPos &x, &y
		x += g_Temp
		y += g_Temp2
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_Temp, g_Temp2, 0, "R"
	}
	else if g_Button = "o" or g_Button = "+o" or g_Button = "^o"
	{
		g_Temp := g_MouseCurrentSpeedToDirection
		g_Temp += g_MouseCurrentSpeedToSide
		g_Temp2 := g_MouseCurrentSpeedToDirection
		g_Temp2 -= g_MouseCurrentSpeedToSide
		g_Temp2 *= -1

		MouseGetPos &x, &y
		x += g_Temp
		y += g_Temp2
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_Temp, g_Temp2, 0, "R"
	}
	else if g_Button = "n" or g_Button = "+n" or g_Button = "^n"
	{
		g_Temp := g_MouseCurrentSpeedToDirection
		g_Temp += g_MouseCurrentSpeedToSide
		g_Temp *= -1
		g_Temp2 := g_MouseCurrentSpeedToDirection
		g_Temp2 -= g_MouseCurrentSpeedToSide
		MouseGetPos &x, &y
		x += g_Temp
		y += g_Temp2
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_Temp, g_Temp2, 0, "R"
	}
	else if g_Button = "," or g_Button = "+," or g_Button = "^,"
	{
		g_Temp := g_MouseCurrentSpeedToDirection
		g_Temp -= g_MouseCurrentSpeedToSide
		g_Temp2 *= -1
		g_Temp2 := g_MouseCurrentSpeedToDirection
		g_Temp2 += g_MouseCurrentSpeedToSide
		MouseGetPos &x, &y
		x += g_Temp
		y += g_Temp2
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove g_Temp, g_Temp2, 0, "R"
	}

	SetTimer ButtonAccelerationEnd, 10
}

ButtonAccelerationEnd()
{
	global
	ng_Button := g_Button
	if StrLen(g_Button) = 2 {
		ng_Button := SubStr(g_Button, -1)
	}

	if GetKeyState(ng_Button, "P")
	{
		ButtonAccelerationStart
		return
	}

	SetTimer , 0
	g_MouseCurrentAccelerationSpeed := 0
	g_MouseCurrentSpeed := g_MouseSpeed
	g_Button := 0
}

;Mouse wheel movement support

ButtonWheelSpeedUp(*)
{
	global
	g_MouseWheelSpeed++
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	g_MouseWheelSpeedReal := g_MouseWheelSpeed
	g_MouseWheelSpeedReal *= MouseWheelSpeedMultiplier
	ToolTip "Mouse wheel speed: " g_MouseWheelSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelSpeedDown(*)
{
	global
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	if g_MouseWheelSpeedReal > MouseWheelSpeedMultiplier
	{
		g_MouseWheelSpeed--
		g_MouseWheelSpeedReal := g_MouseWheelSpeed
		g_MouseWheelSpeedReal *= MouseWheelSpeedMultiplier
	}
	if g_MouseWheelSpeedReal = 1
		ToolTip "Mouse wheel speed: " g_MouseWheelSpeedReal " line"
	else
		ToolTip "Mouse wheel speed: " g_MouseWheelSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelAccelerationSpeedUp(*)
{
	global
	g_MouseWheelAccelerationSpeed++
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	g_MouseWheelAccelerationSpeedReal := g_MouseWheelAccelerationSpeed
	g_MouseWheelAccelerationSpeedReal *= MouseWheelSpeedMultiplier
	ToolTip "Mouse wheel acceleration speed: " g_MouseWheelAccelerationSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelAccelerationSpeedDown(*)
{
	global
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	if g_MouseWheelAccelerationSpeed > 1
	{
		g_MouseWheelAccelerationSpeed--
		g_MouseWheelAccelerationSpeedReal := g_MouseWheelAccelerationSpeed
		g_MouseWheelAccelerationSpeedReal *= MouseWheelSpeedMultiplier
	}
	if g_MouseWheelAccelerationSpeedReal = 1
		ToolTip "Mouse wheel acceleration speed: " g_MouseWheelAccelerationSpeedReal " line"
	else
		ToolTip "Mouse wheel acceleration speed: " g_MouseWheelAccelerationSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelMaxSpeedUp(*)
{
	global
	g_MouseWheelMaxSpeed++
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	g_MouseWheelMaxSpeedReal := g_MouseWheelMaxSpeed
	g_MouseWheelMaxSpeedReal *= MouseWheelSpeedMultiplier
	ToolTip "Mouse wheel maximum speed: " g_MouseWheelMaxSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelMaxSpeedDown(*)
{
	global
	local MouseWheelSpeedMultiplier := RegRead("HKCU\Control Panel\Desktop", "WheelScrollLines")
	if MouseWheelSpeedMultiplier <= 0
		MouseWheelSpeedMultiplier := 1
	if g_MouseWheelMaxSpeed > 1
	{
		g_MouseWheelMaxSpeed--
		g_MouseWheelMaxSpeedReal := g_MouseWheelMaxSpeed
		g_MouseWheelMaxSpeedReal *= MouseWheelSpeedMultiplier
	}
	if g_MouseWheelMaxSpeedReal = 1
		ToolTip "Mouse wheel maximum speed: " g_MouseWheelMaxSpeedReal " line"
	else
		ToolTip "Mouse wheel maximum speed: " g_MouseWheelMaxSpeedReal " lines"
	SetTimer ToolTip, -1000
}

ButtonWheelAcceleration(ThisHotkey)
{
	global
	if g_Button != 0
	{
		if g_Button != ThisHotkey
		{
			g_MouseWheelCurrentAccelerationSpeed := 0
			g_MouseWheelCurrentSpeed := g_MouseWheelSpeed
		}
	}
	g_Button := StrReplace(ThisHotkey, "*")
	ButtonWheelAccelerationStart
}

ButtonWheelAccelerationStart()
{
	global

	if g_MouseWheelAccelerationSpeed >= 1
	{
		if g_MouseWheelMaxSpeed > g_MouseWheelCurrentSpeed
		{
			g_Temp := 0.001
			g_Temp *= g_MouseWheelAccelerationSpeed
			g_MouseWheelCurrentAccelerationSpeed += g_Temp
			g_MouseWheelCurrentSpeed += g_MouseWheelCurrentAccelerationSpeed
		}
	}

	if g_Button = "^y"
		MouseClick "WheelUp", , , g_MouseWheelCurrentSpeed, 0, "D"
	else if g_Button = "^e"
		MouseClick "WheelDown", , , g_MouseWheelCurrentSpeed, 0, "D"

	SetTimer ButtonWheelAccelerationEnd, 100
}

ButtonWheelAccelerationEnd()
{
	global

	ng2_Button := SubStr(g_Button, -1)

	if GetKeyState(ng2_Button, "P")
	{
		ButtonWheelAccelerationStart
		return
	}

	g_MouseWheelCurrentAccelerationSpeed := 0
	g_MouseWheelCurrentSpeed := g_MouseWheelSpeed
	g_Button := 0
}

mouseslowfastSpeed() {
	global
	if g_MouseSpeed != 10 and g_MouseSpeed != 1 {
		oldg_MouseSpeed := g_MouseSpeed
	}
	if g_MouseAccelerationSpeed != 50 and g_MouseAccelerationSpeed != 10 {
		oldg_MouseAccelerationSpeed := g_MouseAccelerationSpeed
	}
	if g_MouseMaxSpeed != 90 and g_MouseMaxSpeed != 20 {
		oldg_MouseMaxSpeed := g_MouseMaxSpeed
	}

	g_MouseSpeed := 1
	g_MouseAccelerationSpeed := 50
	g_MouseMaxSpeed := 90
}

controlSpeed() {

	global
	if g_MouseSpeed != 10 and g_MouseSpeed != 1 {
		oldg_MouseSpeed := g_MouseSpeed
	}
	if g_MouseAccelerationSpeed != 50 and g_MouseAccelerationSpeed != 10 {
		oldg_MouseAccelerationSpeed := g_MouseAccelerationSpeed
	}
	if g_MouseMaxSpeed != 90 and g_MouseMaxSpeed != 20 {
		oldg_MouseMaxSpeed := g_MouseMaxSpeed
	}

	g_MouseSpeed := 10
	g_MouseAccelerationSpeed := 50
	g_MouseMaxSpeed := 90


}
shiftSpeed() {

	global
	if g_MouseSpeed != 10 and g_MouseSpeed != 1 {
		oldg_MouseSpeed := g_MouseSpeed
	}
	if g_MouseAccelerationSpeed != 50 and g_MouseAccelerationSpeed != 10 {
		oldg_MouseAccelerationSpeed := g_MouseAccelerationSpeed
	}
	if g_MouseMaxSpeed != 90 and g_MouseMaxSpeed != 20 {
		oldg_MouseMaxSpeed := g_MouseMaxSpeed
	}


	g_MouseSpeed := 1
	g_MouseAccelerationSpeed := 10
	g_MouseMaxSpeed := 20
}
normalSpeed() {

	global

	; if shfitToggle or ctrlToggle
	; 	return

	if oldg_MouseSpeed != 0 {
		g_MouseSpeed := oldg_MouseSpeed
	}
	if oldg_MouseAccelerationSpeed != 0 {
		g_MouseAccelerationSpeed := oldg_MouseAccelerationSpeed
	}
	if oldg_MouseMaxSpeed != 0 {
		g_MouseMaxSpeed := oldg_MouseMaxSpeed
	}
}