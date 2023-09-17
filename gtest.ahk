; Author DevX
; Mastering by DarkVamprism
;Tiniest tweak by Franklin_Pierce

#NoEnv
#SingleInstance, force
#Include, Gdip.ahk
CoordMode, Mouse
; SetBatchLines - 1
SetMouseDelay - 1


; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error !, Gdiplus failed to start.
	Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit
return

NumpadEnter::
KeyMouseToggle := !KeyMouseToggle
if KeyMouseToggle
{
	Gui, 1: -Caption + E0x80000 + LastFound + AlwaysOnTop + ToolWindow + OwnDialogs
	Gui, 1: Show, NA
	hwnd1 := WinExist()
	hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateSolid(0xffff0000)
	pPen := Gdip_CreatePen(0xff00ff00, 1)
	Gdip_DrawLine(G, pPen, Floor(A_ScreenWidth / 3), 0, Floor(A_ScreenWidth / 3), A_ScreenHeight)
	Gdip_DrawLine(G, pPen, Floor(A_ScreenWidth / 3 * 2), 0, Floor(A_ScreenWidth / 3 * 2), A_ScreenHeight)
	Gdip_DrawLine(G, pPen, 0, Floor(A_ScreenHeight / 3), A_ScreenWidth, Floor(A_ScreenHeight / 3))
	Gdip_DrawLine(G, pPen, 0, Floor(A_ScreenHeight / 3 * 2), A_ScreenWidth, Floor(A_ScreenHeight / 3 * 2))
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)

	init()
}
else
{
	Gui, 1: Destroy
}
return

#if KeyMouseToggle
NumPad1:: SelectWindow(1)
NumPad2:: SelectWindow(2)
NumPad3:: SelectWindow(3)
NumPad4:: SelectWindow(4)
NumPad5:: SelectWindow(5)
NumPad6:: SelectWindow(6)
NumPad7:: SelectWindow(7)
NumPad8:: SelectWindow(8)
NumPad9:: SelectWindow(9)
NumPad0:: ClickTheButtonNow()

#if

Init()
{
	global
	currX := 0
	currY := 0
	currW := A_ScreenWidth
	currH := A_ScreenHeight
}

SelectWindow(Win)
{
	global
	currW := currW / 3
	currH := currH / 3

	if (Win >= 1 and Win <= 3)
	{
		currY := currY + (currH * 2)
	}
	else if (Win >= 4 and Win <= 6)
	{
		currY := currY + currH
	}
	else if (Win >= 7 and Win <= 9)
	{
		currY := currY
	}

	if (Win == 1 || Win == 4 || Win == 7)
	{
		currX := currX
	}
	else if (Win == 2 or Win == 5 or Win == 8)
	{
		currX := currX + currW
	}
	else if (Win == 3 or Win == 6 or Win == 9)
	{
		currX := currX + (currW * 2)
	}

	if (CurStep == 5)
	{
		CurStep := 0
		KeyMouseToggle := false
		Gui, 1: Destroy
		ClickTheButton()
		return
	}

	CurStep++
	DrawNewBox()
}

DrawNewBox()
{
	global
	Gui, 1: Destroy
	Gui, 1: -Caption + E0x80000 + LastFound + AlwaysOnTop + ToolWindow + OwnDialogs
	Gui, 1: Show, NA
	hwnd1 := WinExist()
	hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetSmoothingMode(G, 4)

	if (currY > 0)
		Gdip_DrawLine(G, pPen, currX, currY, currX + currW, currY)
	if (currX > 0)
		Gdip_DrawLine(G, pPen, currX, currY, currX, currY + currH)
	if ((currY + currH) <= A_ScreenHeight)
		Gdip_DrawLine(G, pPen, currX, currY + currH, currX + currW, currY + currH)
	if ((currX + currW) <= A_ScreenWidth)
		Gdip_DrawLine(G, pPen, currX + currW, currY, currX + currW, currY + currH)

	Gdip_DrawLine(G, pPen, currX, currY + (currH / 3), currX + currW, currY + (currH / 3))
	Gdip_DrawLine(G, pPen, currX, currY + ((currH / 3) * 2), currX + currW, currY + ((currH / 3) * 2))

	Gdip_DrawLine(G, pPen, currX + (currW / 3), currY, currX + (currW / 3), currY + currH)
	Gdip_DrawLine(G, pPen, currX + ((currW / 3) * 2), currY, currX + ((currW / 3) * 2), currY + currH)


	UpdateLayeredWindow(hwnd1, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)

	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)
	Gui, 1: Show, NA
}

ClickTheButton()
{
	global
	MouseClick, Left, (currx + currW / 2), (curry + currH / 2), 1, 0
}

ClickTheButtonNow()
{
	global
	MouseClick, Left, (currx + currW / 2), (curry + currH / 2), 1, 0
	CurStep := 0
	KeyMouseToggle := false
	Gui, 1: Destroy
	;sgBox, %currw%  %currh% %curry%5 %curry%
}


Exit:
	Gdip_Shutdown(pToken)
ExitApp