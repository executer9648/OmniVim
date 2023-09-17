; Easy Window Dragging
; https://www.autohotkey.com
; Normally, a window can only be dragged by clicking on its title bar.
; This script extends that so that any point inside a window can be dragged.
; To activate this mode, hold down CapsLock or the middle mouse button while
; clicking, then drag the window to a new position.

; Note: You can optionally release CapsLock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.

~MButton & LButton::
CapsLock & LButton::
EWD_MoveWindow(*)
{
	CoordMode "Mouse"  ; Switch to screen/absolute coordinates.
	MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin
	WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY, , , EWD_MouseWin
	if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized
		SetTimer EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

	EWD_WatchMouse()
	{
		if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
		{
			SetTimer , 0
			return
		}
		if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
		{
			SetTimer , 0
			WinMove EWD_OriginalPosX, EWD_OriginalPosY, , , EWD_MouseWin
			return
		}
		; Otherwise, reposition the window to match the change in mouse coordinates
		; caused by the user having dragged the mouse:
		CoordMode "Mouse"
		MouseGetPos &EWD_MouseX, &EWD_MouseY
		WinGetPos &EWD_WinX, &EWD_WinY, , , EWD_MouseWin
		SetWinDelay -1   ; Makes the below move faster/smoother.
		WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY, , , EWD_MouseWin
		EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
		EWD_MouseStartY := EWD_MouseY
	}
}