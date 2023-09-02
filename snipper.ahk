; Snipper
; Fanatic Guru
;
; Version 2023 04 29
;
; #Requires AutoHotkey v2
;
; Copy Area of Screen
;
;{-----------------------------------------------
;
; AutoHotkey alternate to Windows Snipping Tool with additional features
; Creates Gui of Snip that can be manipulated onscreen
;
;	Credits:
;	The work of dozens of people inspired this script.
;	Many of them listed in the threads below:
;
;	Screen Clipping		https://www.autohotkey.com/boards/viewtopic.php?f=6&t=12088
;	Gdip				https://www.autohotkey.com/boards/viewtopic.php?t=72011
;
;}

;; INITIALIZATION - ENVIROMENT
;{-----------------------------------------------
;
#Requires AutoHotkey v2
#Warn All, Off
#SingleInstance force
DetectHiddenWindows true
SetWinDelay(0)
;}

;; INITIALIZATION - FUNCTIONS
;{-----------------------------------------------
;
ObjectAutoProperty()
ObjectAutoProperty() => Object.Prototype.DefineProp('__Get', { Call: (this, Name, Params) => this.%Name% := {} })
;}

;; DEFAULT SETTING - VARIABLES
;{-----------------------------------------------
;
Settings_SavePath_Image := GetFullPathName('.\Snipper - Images\')
Settings_SavePath_Image_Ext := 'PNG' ; BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG
;}

;; INITIALIZATION - VARIABLES
;{-----------------------------------------------
;
guiSnips := Map(), SnipVisible := true, Extensions := Array()
;}

;; #INCLUDE EXTENSION
;{-----------------------------------------------
;
; #Include Snipper - Extension - Acrobat.ahk
; #Include Snipper - Extension - Word.ahk
; #Include Snipper - Extension - Outlook.ahk
;}

;; INITIALIZATION - GUI
;{-----------------------------------------------
;
; Data for Context Menu Gui
ContextSnipMenuData := [], PrevApp := ''
ContextSnipMenuData.Push('SETTINGS  |  SNIP INFO', '', '', 'COPY:  Clipboard', '', 'SAVE:  ' Settings_SavePath_Image_Ext ' File',)
For Index, Item in Extensions
	For App, AppObj in Item.OwnProps()
	{
		If App != PrevApp
			ContextSnipMenuData.Push('')
		PrevApp := App
		ContextSnipMenuData.Push({ Text: AppObj.Text, Func: AppObj.Func })
	}
ContextSnipMenuData.Push('', '', 'CLOSE:      SNIP IMAGE')
; Create Context Menu Gui
ContextSnipMenu := Menu()
For Index, Item in ContextSnipMenuData
{
	IsObject(Item) ? MenuText := Item.Text : MenuText := Item
	MenuText ? ContextSnipMenu.Add(MenuText, ContextSnipMenu_Handler) : ContextSnipMenu.Add('')
}
ContextSnipMenu.SetIcon('1&', A_WinDir '\system32\shell32.dll', 260, 32)
ContextSnipMenu.SetIcon(ContextSnipMenuData.Length '&', A_WinDir '\system32\shell32.dll', 220)
; Settings Gui
guiSettings := Gui('+AlwaysOnTop -MinimizeBox'), guiSettings.Check := {}
guiSettings.SetFont('s10 bold underline')
guiSettings.Text.Heading := guiSettings.Add('Text', 'x40', 'Snip Settings')
guiSettings.SetFont()
guiSettings.Add('Text', 'x20 yp+10')
For ItemPos, Item in RangeArray(ContextSnipMenuData, 2, ContextSnipMenuData.Length - 1)
{
	IsObject(Item) ? ItemName := Item.Text : ItemName := Item
	(ItemName && guiSettings.Check.%ItemPos% := guiSettings.Add('CheckBox', ' yp+20', ' Border with ' ItemName))
}
(guiSettings.ButtonOK := guiSettings.Add('Button', 'yp+40 x50 w100 Default', 'Ok')).OnEvent('Click', guiSettings_Click)
(guiSettings.ButtonCancel := guiSettings.Add('Button', 'yp xp+125 w100', 'Cancel')).OnEvent('Click', guiSettings_Click)
guiSettings.ButtonOK.Focus
;}

;; AUTO-EXECUTE
;{-----------------------------------------------
;
Settings_Load
TraySetIcon(A_WinDir '\system32\shell32.dll', 260) ; Scissors
Try DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
;}

;; HOTKEYS
;{-----------------------------------------------
;
#Lbutton::		;	<-- Snip Image Only
{
	Global guiSnips
	Area := SelectScreenRegion('LButton')
	If (Area.W > 8 and Area.H > 8)
		SnipArea(Area, false, true, SnipVisible, &guiSnips)
}

#^Lbutton::	;	<-- Snip Image and Copy to Clipboard
{
	Global guiSnips
	Area := SelectScreenRegion('LButton')
	If (Area.W > 8 and Area.H > 8)
		SnipArea(Area, true, true, SnipVisible, &guiSnips)
}

#!Lbutton::	;	<-- Copy to Clipboard Only
{
	Area := SelectScreenRegion('LButton')
	SnipArea(Area, true, false)
}

+PrintScreen:: ;	<-- Toggle Show/Hide of Snips
{
	Global SnipVisible
	SnipVisible := !SnipVisible
	If SnipVisible
		For Hwnd, guiSnip in guiSnips
			guiSnip.GuiObj.Show('NA')
	If !SnipVisible
		For Hwnd, guiSnip in guiSnips
			guiSnip.GuiObj.Hide
}

~RButton::	;	<-- @@ Click for Context Menu
{
	MouseGetPos(, , &OutputVarWin)
	If WinGetTitle('ahk_id' OutputVarWin) = 'SnipperWindow'
	{
		WinActivate('ahk_id ' OutputVarWin)
		WinGetPos(&X, &Y, &W, &H, 'ahk_id ' OutputVarWin)
		ContextSnipMenu.Rename('1&', ContextSnipMenuData[1] ':    ' W - 6 ' Width by ' H - 6 ' Height')
		ContextSnipMenu.Parent.Hwnd := OutputVarWin
		ContextSnipMenu.Show()
	}
}

#HotIf WinActive('SnipperWindow ahk_class AutoHotkeyGUI')

Esc:: CloseSnip()	;	<-- @@ Close Active Snip

#HotIf

;}

;; CLASSES & FUNCTIONS - GUI
;{-----------------------------------------------
;
;{ ContextSnipMenu_Handler
ContextSnipMenu_Handler(ItemName, ItemPos, MyMenu)
{
	(GetKeyState('Shift', 'p') ? Inverse := true : Inverse := false)
	; User Defined ClipboardApps
	If ContextSnipMenuData[ItemPos].HasProp('Func')
		ContextSnipMenuData[ItemPos].Func.Call(Borders := Inverse ^ guiSettings.Check.%ItemPos%.Value)
	; Standard Actions
	Switch ItemPos
	{
		Case 1: WinGetPos(&X, &Y, &W, &H, 'A'), SettingsDialog({ X: X, Y: Y, W: W, H: H })										; Settings
		Case 4: Snip2Clipboard(Borders := Inverse ^ guiSettings.Check.4.Value)													; Clipboard
		Case 6: Snip2File(Borders := Inverse ^ guiSettings.Check.6.Value, Settings_SavePath_Image, , Settings_SavePath_Image_Ext)	; File
		Case ContextSnipMenuData.Length: CloseSnip																														; Snip Image
	}
}
;}

SettingsDialog(Area)
{
	guiSettings.Show('x' Area.X + (Area.W / 3) ' y' Area.Y + (Area.H / 3))
}

guiSettings_Click(GuiCtrlObj, Info)
{
	If GuiCtrlObj = guiSettings.ButtonOK
	{
		For ItemPos, GuiCtrlCheck in guiSettings.Check.OwnProps()
			If GuiCtrlCheck.Value
				ContextSnipMenu.Check(ItemPos '&')
			Else
				ContextSnipMenu.Uncheck(ItemPos '&')
		Settings_Save
	}
	guiSettings.GetPos(&X, &Y, &W, &H), X *= A_ScreenDPI / 96, Y *= A_ScreenDPI / 96
	guiSettings.Hide
	WinActivate(ContextSnipMenu.Parent)
	CoordMode('Menu', 'Screen'), ContextSnipMenu.Show(X, Y)
}

;{ CloseSnip
CloseSnip(Hwnd?)
{
	If !IsSet(Hwnd)
		Hwnd := WinGetID('A')
	guiSnips[Hwnd].GuiObj.Destroy()
	guiSnips.Delete(Hwnd)
}
;}
;}

;; CLASSES & FUNCTIONS
;{-----------------------------------------------
;
;{ SelectScreenRegion
SelectScreenRegion(Key, Color := 'Lime', Color_Inactive := 'Red', Transparent := 80)
{
	; Initialize
	Static guiSSR, guiInfoDialog, DisplayWH := true, X, Y, W, H
	If !IsSet(guiSSR)
	{
		guiSSR := Gui('+AlwaysOnTop -Caption +Border +ToolWindow +LastFound -DPIScale +Resize', 'SnipperSelect')
		guiSSR.MarginX := 0, guiSSR.MarginY := 0
		guiSSR.BackColor := 1, WinSetTransColor(1, guiSSR)
		guiSSR.OnEvent('Size', guiSSR_Size)
		guiSSR.Background := guiSSR.Add('Text', 'w' A_ScreenWidth ' h' A_ScreenHeight ' Background' Color)
		If InStr(A_OSVersion, '6.1') ; win 7
			WinSetTransparent(Transparent, guiSSR)
		Else
			WinSetTransparent(Transparent, guiSSR.Background)
		guiSSR.InfoWH := guiSSR.Add('Text', 'Background' Color ' w175 h75 Center', 'XXXX x YYYY')
		guiSSR.AspectRatio := false
		OnMessage(0x84, WM_NCHITTEST)
		OnMessage(0x83, WM_NCCALCSIZE)
		OnMessage(0x214, WM_SIZING)
		OnMessage(0x0232, WM_EXITSIZEMOVE)
		OnExit((*) => OnMessage(0x83, WM_NCCALCSIZE, 0)) ; WM_NCCALCSIZE will cause error if Gui exist while closing
	}
	If !IsSet(guiInfoDialog)
	{
		guiInfoDialog := Gui('+AlwaysOnTop -MinimizeBox')
		guiInfoDialog.TextW := guiInfoDialog.Add('Text', 'y20', 'Width')
		guiInfoDialog.EditW := guiInfoDialog.Add('Edit', 'r1 w40 x50 yp')
		guiInfoDialog.TextH := guiInfoDialog.Add('Text', 'xp+60 yp', 'Height')
		guiInfoDialog.EditH := guiInfoDialog.Add('Edit', 'r1 w40 xp+50 yp')
		(guiInfoDialog.CheckRatio := guiInfoDialog.Add('CheckBox', 'xp+60 yp-10', 'Lock Ratio')).OnEvent('Click', guiInfoDialog_CheckRatio)
		(guiInfoDialog.CheckWH := guiInfoDialog.Add('CheckBox', 'xp yp+20 Checked' DisplayWH, 'Display W x H')).OnEvent('Click', guiInfoDialog_CheckWH)
		(guiInfoDialog.ButtonApply := guiInfoDialog.Add('Button', 'Default xm yp+40 w80', 'Apply')).OnEvent('Click', guiInfoDialog_Click)
		(guiInfoDialog.ButtonOK := guiInfoDialog.Add('Button', 'yp xp+100 w80', 'Ok')).OnEvent('Click', guiInfoDialog_Click)
		(guiInfoDialog.ButtonCancel := guiInfoDialog.Add('Button', 'yp xp+100 w80', 'Cancel')).OnEvent('Click', guiInfoDialog_Click)
	}

	guiSSR.AdvanceSelectMode := false, guiSSR.AspectRatio := false
	ControlSetChecked(0, guiInfoDialog.CheckRatio)

	; Drag Selection
	CoordMode('Mouse', 'Screen')
	MouseGetPos(&sX, &sY)
	guiSSR.Show('x' sX ' y' sY ' w1 h1')
	Wprev := Hprev := 0
	Loop
	{
		MouseGetPos(&eX, &eY)
		W := Abs(sX - eX), H := Abs(sY - eY)
		X := Min(sX, eX), Y := Min(sY, eY)
		If A_Index < 50
			guiSSR.Background.Redraw()
		guiSSR.Move(X, Y, W, H)
		Display_WH(false)
		Sleep 10
	} Until !GetKeyState(Key, 'p')

	; Advanced Selection
	If GetKeyState("Shift")
	{
		guiSSR.AdvanceSelectMode := true, guiSSR_Active := true
		ControlFocus(A_ScriptHwnd)
		Loop
		{
			Display_WH()
			If GetKeyState('RButton', 'P')
				InfoWH_RButton
			If WinActive('A') = A_ScriptHwnd and !guiSSR_Active
			{
				guiSSR.InfoWH.Opt('Background' Color)
				guiSSR.InfoWH.Redraw()
				guiSSR_Active := true
			}
			Else If WinActive('A') != A_ScriptHwnd and guiSSR_Active
			{
				guiSSR.InfoWH.Opt('Background' Color_Inactive)
				guiSSR.InfoWH.Redraw()
				guiSSR_Active := false
			}
			Sleep 10
		} Until GetKeyState('Enter', 'P') and WinActive('A') = A_ScriptHwnd
	}

	guiSSR.GetPos(&X, &Y, &W, &H)
	guiSSR.Hide()
	Return { X: X, Y: Y, W: W, H: H, X2: X + W, Y2: Y + H }

	Display_WH(MarkAspectRatio := true)
	{
		If GetKeyState('Shift', 'P') or DisplayWH and (W > 60 and H > 35)
		{
			guiSSR.GetPos(&X, &Y, &W, &H)
			If W != Wprev or H != Hprev
			{
				FontSize := MinMax(Min(W // 25, H // 5), 8, 20)
				PosWHx := Max(1, (W - FontSize * 6) // 2), PosWHy := Max(1, (H - FontSize * 2) // 2)
				guiSSR.InfoWH.SetFont('s' FontSize)
				guiSSR.InfoWH.Text := (guiSSR.AspectRatio && MarkAspectRatio ? '[' W 'x' H ']' : W 'x' H)
				guiSSR.InfoWH.Move(PosWHx, PosWHy, FontSize ** 1.7 + 15, FontSize * 2)
				guiSSR.InfoWH.Visible := true
				Wprev := W, Hprev := H
			}
		}
		Else
		{
			guiSSR.InfoWH.Visible := false
			Wprev := Hprev := 0
			guiSSR.Background.Redraw
		}
	}

	InfoWH_RButton()
	{
		MouseGetPos(, , , &OutputVarControl, 2)
		If OutputVarControl = guiSSR.InfoWH.Hwnd
			guiInfoDialog.Show('AutoSize')
	}

	InfoWH_LButton()
	{
		MouseGetPos(, , , &OutputVarControl, 2)
		If OutputVarControl = guiSSR.InfoWH.Hwnd
			WinActivate('ahk_id' A_ScriptHwnd)
	}

	guiInfoDialog_Click(GuiCtrlObj, Info)
	{
		If GuiCtrlObj.Text = 'Apply'
		{
			If guiInfoDialog.EditW.Value and guiInfoDialog.EditH.Value
			{
				guiSSR.Move(X, Y, guiInfoDialog.EditW.Value, guiInfoDialog.EditH.Value)
				(guiInfoDialog.CheckRatio.Value && guiSSR.AspectRatio := guiInfoDialog.EditW.Value / guiInfoDialog.EditH.Value)
			}
			Else
				(!guiInfoDialog.EditW.Value ? guiInfoDialog.EditW.Focus() : guiInfoDialog.EditH.Focus())
			Return
		}
		If GuiCtrlObj.Text = 'Ok'
		{
			If guiInfoDialog.EditW.Value and guiInfoDialog.EditH.Value
			{
				guiSSR.Move(X, Y, guiInfoDialog.EditW.Value, guiInfoDialog.EditH.Value)
				(guiInfoDialog.CheckRatio.Value && guiSSR.AspectRatio := guiInfoDialog.EditW.Value / guiInfoDialog.EditH.Value)
			}
			Else
			{
				(!guiInfoDialog.EditW.Value ? guiInfoDialog.EditW.Focus() : guiInfoDialog.EditH.Focus())
				Return
			}
		}
		guiInfoDialog.Hide
	}

	guiInfoDialog_CheckWH(GuiCtrlObj, Info)
	{
		DisplayWH := GuiCtrlObj.Value
	}

	guiInfoDialog_CheckRatio(GuiCtrlObj, Info)
	{
		If GuiCtrlObj.Value
			guiSSR.AspectRatio := W / H, guiSSR.InfoWH.Text := '[' W 'x' H ']'
		Else
			guiSSR.AspectRatio := false, guiSSR.InfoWH.Text := W 'x' H
	}

	guiSSR_Size(guiSSR, WindowMinMax, Width, Height)
	{
		If guiSSR.AdvanceSelectMode
		{
			guiSSR.Background.Move(0, 0), guiSSR.Background.Redraw()
			Display_WH()
		}
	}

	;{ WM Event Functions - Selection
	WM_SIZING(wParam, lParam, msg, hwnd)
	{
		If guiSSR.AspectRatio
		{
			L := NumGet(lParam, 0, "Int"), T := NumGet(lParam, 4, "Int")
			r := NumGet(lParam, 8, "Int"), B := NumGet(lParam, 12, "Int")
			Switch wParam
			{
				Case 1, 2, 7, 8: NumPut('int', T + ((r - L) / guiSSR.AspectRatio), lParam, 12)	; L, R, BL, BR = adjust B
				Case 3, 6: NumPut('int', L + ((B - T) * guiSSR.AspectRatio), lParam, 8)			; T, B = adjust R
				Case 4, 5: NumPut('int', B - ((r - L) / guiSSR.AspectRatio), lParam, 4)			; T,TR = adjust T
			}
		}
	}

	WM_EXITSIZEMOVE(wParam, lParam, msg, hwnd)
	{
		If hwnd = guiSSR.Hwnd
		{
			ControlFocus(A_ScriptHwnd)
		}
	}

	WM_NCCALCSIZE(wParam, lParam, msg, hwnd)
	{
		If hwnd != guiSSR.Hwnd
			Return

		If guiSSR.AdvanceSelectMode
			Return 0x0300	; WVR_REDRAW
		Return 0
	}

	WM_NCHITTEST(wParam, lParam, msg, hwnd)
	{
		Static Border_Size := 10

		If hwnd != guiSSR.Hwnd or !guiSSR.AdvanceSelectMode
			Return

		X := lParam << 48 >> 48, Y := lParam << 32 >> 48
		WinGetPos(&gX, &gY, &gW, &gH)

		hit_Left := X < gX + Border_Size
		hit_Right := X >= gX + gW - Border_Size
		hit_Top := Y < gY + Border_Size
		hit_Bottom := Y >= gY + gH - Border_Size

		If hit_Top
		{
			If hit_Left
				Return 0xD
			Else If hit_Right
				Return 0xE
			Else
				Return 0xC
		}
		Else If hit_Bottom
		{
			If hit_Left
				Return 0x10
			Else If hit_Right
				Return 0x11
			Else
				Return 0xF
		}
		Else If hit_Left
			Return 0xA
		Else If hit_Right
			Return 0xB

		; else default hit-testing
	}
	;}
}
;}
;{ WM Event Functions - General
OnMessage(0x200, WM_MOUSEMOVE)
WM_MOUSEMOVE(wParam, lParam, msg, hwnd)
{
	If WinGetTitle('ahk_id' hwnd) = 'SnipperSelect'
		WinActivate('ahk_id ' A_ScriptHwnd)
}

OnMessage(0x201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
	PostMessage(0xA1, 2, , hwnd)
}

OnMessage(0x6, WM_ACTIVATE)
WM_ACTIVATE(wParam, lParam, msg, hwnd)
{
	Global guiSnips
	If WinGetTitle('ahk_id' hwnd) = 'SnipperWindow'
		If (Activated := wParam << 48 >> 48)
			SnipWinBorderColor(guiSnips[hwnd].GuiObj, 'Green')
		Else
			SnipWinBorderColor(guiSnips[hwnd].GuiObj, 'Blue')
}
;}
;{ SnipArea
SnipArea(Area, SetClipboard := false, CreateWindow := true, ShowWindow := true, &ObjMap?, BorderColorOut := 'Blue', BorderColorIn := 'White')
{
	GDIp.Startup()
	pBitmap := GDIp.BitmapFromScreen(Area)
	If SetClipboard
		GDIp.SetBitmapToClipboard(pBitmap)
	If CreateWindow and IsSet(ObjMap)
	{
		guiObj := Gui('-Caption +AlwaysOnTop +OwnDialogs -DPIScale +E0x80000 +E0x02000000', 'SnipperWindow')
		ObjMap[guiObj.hwnd] := { GuiObj: guiObj, Area: Area }
		guiObj.MarginX := 0, guiObj.MarginY := 0
		hBitmap := GDIp.CreateHBITMAPFromBitmap(pBitmap)
		guiObj.Pic := guiObj.Add('Picture', 'x3 y3', 'HBITMAP:' hBitmap)
		guiObj.Border1 := guiObj.Add('Text', 'x2 y2 w' Area.W + 2 ' h' Area.H + 2 ' Background' BorderColorOut)
		guiObj.Border2 := guiObj.Add('Text', 'x1 y1 w' Area.W + 4 ' h' Area.H + 4 ' Background' BorderColorIn)
		guiObj.Border3 := guiObj.Add('Text', 'x0 y0 w' Area.W + 6 ' h' Area.H + 6 ' Background' BorderColorOut)
		If ShowWindow
			guiObj.Show('NA x' Area.X - 3 ' y' Area.Y - 3)
		Else
			guiObj.Show('Hide x' Area.X - 3 ' y' Area.Y - 3)
		GDIp.DisposeImage(pBitmap)
		GDIp.DeleteObject(hBitmap)
		Return guiObj.hwnd
	}
	GDIp.DisposeImage(pBitmap)
	GDIp.Shutdown()
	Return false
}
;}
;{ SnipWinBorderColor
SnipWinBorderColor(guiObj, BorderColorOut := 'Blue', BorderColorIn := 'White')
{
	guiObj.Border1.Opt('Background' BorderColorOut), guiObj.Border1.Redraw()
	guiObj.Border2.Opt('Background' BorderColorIn), guiObj.Border2.Redraw()
	guiObj.Border3.Opt('Background' BorderColorOut), guiObj.Border3.Redraw()
}
;}
;{ Snip2Clipboard
Snip2Clipboard(Borders := false, Hwnd?)
{
	If !IsSet(Hwnd)
		Hwnd := WinGetID('A')
	If Borders
	{
		GDIp.Startup()
		If InStr(A_OSVersion, '6.1') ; win 7
		{
			guiSnips[Hwnd].GuiObj.GetPos(&X, &Y, &W, &H)
			pBitmap := GDIp.BitmapFromScreen({ X: X, Y: Y, W: W, H: H })
		}
		Else
			pBitmap := GDIp.BitmapFromHWND(Hwnd)
		GDIp.SetBitmapToClipboard(pBitmap)
		GDIp.DisposeImage(pBitmap)
		GDIp.Shutdown()
	}
	Else
	{
		hBitMap := SendMessage(0x173, 0, 0, guiSnips[Hwnd].GuiObj.Pic)
		GDIp.Startup()
		GDIp.SetHBITMAPToClipboard(hBitMap)
		GDIp.Shutdown()
	}
}
;}
;{ Snip2File
Snip2File(Borders := false, SavePath?, FileNameOnly?, FileExt?, Hwnd?)
{
	If !FileExist(SavePath)
		DirCreate(SavePath)
	If !IsSet(Hwnd)
		Hwnd := WinGetID('A')
	If Borders
	{
		GDIp.Startup()
		If InStr(A_OSVersion, '6.1') ; win 7
		{
			guiSnips[Hwnd].GuiObj.GetPos(&X, &Y, &W, &H)
			pBitmap := GDIp.BitmapFromScreen({ X: X, Y: Y, W: W, H: H })
		}
		Else
			pBitmap := GDIp.BitmapFromHWND(Hwnd)
		TimeStamp := FormatTime(, 'yyyy_MM_dd @ HH_mm_ss')
		If IsSet(FileNameOnly)
			FileName := FileNameOnly '.' FileExt
		else
			FileName := TimeStamp ' (' guiSnips[Hwnd].Area.W + 6 'x' guiSnips[Hwnd].Area.H + 6 ').' FileExt
		GDIp.SaveBitmapToFile(pBitmap, SavePath FileName)
		GDIp.DisposeImage(pBitmap)
		GDIp.Shutdown()
	}
	Else
	{
		TimeStamp := FormatTime(, 'yyyy_MM_dd @ HH_mm_ss')
		FileName := TimeStamp ' (' guiSnips[Hwnd].Area.W 'x' guiSnips[Hwnd].Area.H ').PNG'
		hBitMap := SendMessage(0x173, 0, 0, guiSnips[Hwnd].GuiObj.Pic)
		GDIp.Startup()
		pBitmap := GDIp.CreateBitmapFromHBITMAP(hBitMap)
		GDIp.SaveBitmapToFile(pBitmap, SavePath FileName)
		GDIp.DisposeImage(pBitmap)
		GDIp.Shutdown()
	}
	Return SavePath FileName
}
;}
;{ Settings Save / Load
Settings_Save(FileName := 'Snipper.ini')
{
	Try FileMove(FileName, FileName '.bak', true)
	For ItemPos, GuiCtrlCheck in guiSettings.Check.OwnProps()
		IniWrite GuiCtrlCheck.Value, FileName, 'Check', GuiCtrlCheck.Text
}
Settings_Load(FileName := 'Snipper.ini')
{
	For ItemPos, GuiCtrlCheck in guiSettings.Check.OwnProps()
		Try If GuiCtrlCheck.Value := IniRead(FileName, 'Check', GuiCtrlCheck.Text)
			ContextSnipMenu.Check(ItemPos '&')
		Else
			ContextSnipMenu.Uncheck(ItemPos '&')
}
;}
;}

;; LIBRARY
;{-----------------------------------------------
;
;{ MinMax
MinMax(Num, MinNum, MaxNum) => Min(Max(Num, MinNum), MaxNum)
;}
;{ ArrayRange
RangeArray(Arr, Start := 1, Stop := unset, Step := 1) {
	If !IsSet(Stop)
		Stop := Arr.Length
	If Start > Stop and Step = 1
		Step := -1
	Enumerate(&p1, &p2 := false) {
		If IsSet(p2) {
			p2 := Start, Start += Step
			Try p1 := Arr[p2]
			Return Step > 0 ? p2 <= Stop : p2 >= Stop
		}
		Else {
			p1 := Start, Start += Step
			Try p2 := Arr[p1]
			Return Step > 0 ? p1 <= Stop : p1 >= Stop
		}
	}
	Return Enumerate
}
;}
;{ GetFullPathName
GetFullPathName(path)
{
	cc := DllCall('GetFullPathNameW', 'str', path, 'uint', 0, 'ptr', 0, 'ptr', 0, 'uint')
	buf := Buffer(cc * 2)
	DllCall('GetFullPathNameW', 'str', path, 'uint', cc, 'ptr', buf, 'ptr', 0, 'uint')
	Return StrGet(buf)
}
;}
;{ GDIp Class - Select GDIp library functions converted to a class specifically for this script
#DllLoad 'GdiPlus'
Class GDIp
{
	;{ Startup
	Static Startup()
	{
		If (this.HasProp("Token"))
			Return
		input := Buffer((A_PtrSize = 8) ? 24 : 16, 0)
		NumPut("UInt", 1, input)
		DllCall("gdiplus\GdiplusStartup", "UPtr*", &pToken := 0, "UPtr", input.ptr, "UPtr", 0)
		this.Token := pToken
	}
	;}
	;{ Shutdown
	Static Shutdown()
	{
		If (this.HasProp("Token"))
			DllCall("Gdiplus\GdiplusShutdown", "UPtr", this.DeleteProp("Token"))
	}
	;}
	;{ BitmapFromHWND
	Static BitmapFromHWND(hwnd, clientOnly := 0)
	{
		If DllCall("IsIconic", "UPtr", hwnd)
			DllCall("ShowWindow", "UPtr", hwnd, "int", 4)

		thisFlag := 0
		If (clientOnly = 1)
		{
			rc := Buffer(16, 0)
			DllCall("GetClientRect", "UPtr", hwnd, "UPtr", rc.ptr)
			Width := NumGet(rc, 8, "int")
			Height := NumGet(rc, 12, "int")
			thisFlag := 1
		} Else this.GetWindowRect(hwnd, &Width, &Height)

		hbm := this.CreateDIBSection(Width, Height)
		hdc := this.CreateCompatibleDC(), obm := this.SelectObject(hdc, hbm)
		this.PrintWindow(hwnd, hdc, 2 + thisFlag)
		pBitmap := this.CreateBitmapFromHBITMAP(hbm)
		this.SelectObject(hdc, obm), this.DeleteObject(hbm), this.DeleteDC(hdc)
		Return pBitmap
	}
	;}
	;{ PrintWindow
	Static PrintWindow(hwnd, hdc, Flags := 2)
	{
		Return DllCall("PrintWindow", "UPtr", hwnd, "UPtr", hdc, "uint", Flags)
	}
	;}
	;{ GetWindowRect
	Static GetWindowRect(hwnd, &W, &H)
	{
		rect := Buffer(16, 0)
		er := DllCall("dwmapi\DwmGetWindowAttribute"
			, "UPtr", hwnd        ; HWND  hwnd
			, "UInt", 9           ; DWORD dwAttribute (DWMWA_EXTENDED_FRAME_BOUNDS)
			, "UPtr", rect.ptr    ; PVOID pvAttribute
			, "UInt", rect.size   ; DWORD cbAttribute
			, "UInt")             ; HRESULT

		If er
			DllCall("GetWindowRect", "UPtr", hwnd, "UPtr", rect.ptr, "UInt")

		r := {}
		r.x1 := NumGet(rect, 0, "Int"), r.y1 := NumGet(rect, 4, "Int")
		r.x2 := NumGet(rect, 8, "Int"), r.y2 := NumGet(rect, 12, "Int")
		r.w := Abs(Max(r.x1, r.x2) - Min(r.x1, r.x2))
		r.h := Abs(Max(r.y1, r.y2) - Min(r.y1, r.y2))
		W := r.w, H := r.h
		Return r
	}
	;}
	;{ BitmapFromScreen
	Static BitmapFromScreen(Area)
	{
		chdc := this.CreateCompatibleDC()
		hbm := this.CreateDIBSection(Area.W, Area.H, chdc)
		obm := this.SelectObject(chdc, hbm)
		hhdc := this.GetDC()
		this.BitBlt(chdc, 0, 0, Area.W, Area.H, hhdc, Area.X, Area.Y)
		this.ReleaseDC(hhdc)
		pBitmap := this.CreateBitmapFromHBITMAP(hbm)
		this.SelectObject(chdc, obm), this.DeleteObject(hbm), this.DeleteDC(hhdc), this.DeleteDC(chdc)
		Return pBitmap
	}
	;}
	;{ SetHBITMAPToClipboard
	Static SetHBITMAPToClipboard(hBitmap)
	{

		off1 := A_PtrSize = 8 ? 52 : 44
		off2 := A_PtrSize = 8 ? 32 : 24

		pid := DllCall("GetCurrentProcessId", "uint")
		hwnd := WinExist("ahk_pid " . pid)
		r1 := DllCall("OpenClipboard", "UPtr", hwnd)
		If !r1
			Return -1

		r2 := DllCall("EmptyClipboard")
		If !r2
		{
			this.DeleteObject(hBitmap)
			DllCall("CloseClipboard")
			Return -2
		}

		oi := Buffer((A_PtrSize = 8) ? 104 : 84, 0)
		DllCall("GetObject", "UPtr", hBitmap, "int", oi.size, "UPtr", oi.ptr)
		hdib := DllCall("GlobalAlloc", "uint", 2, "UPtr", 40 + NumGet(oi, off1, "UInt"), "UPtr")
		pdib := DllCall("GlobalLock", "UPtr", hdib, "UPtr")
		DllCall("RtlMoveMemory", "UPtr", pdib, "UPtr", oi.ptr + off2, "UPtr", 40)
		DllCall("RtlMoveMemory", "UPtr", pdib + 40, "UPtr", NumGet(oi, off2 - A_PtrSize, "UPtr"), "UPtr", NumGet(oi, off1, "UInt"))
		DllCall("GlobalUnlock", "UPtr", hdib)
		r3 := DllCall("SetClipboardData", "uint", 8, "UPtr", hdib) ; CF_DIB = 8
		DllCall("CloseClipboard")
		DllCall("GlobalFree", "UPtr", hdib)
		E := r3 ? 0 : -4    ; 0 - success
		Return E
	}
	;}
	;{ SetBitmapToClipboard
	Static SetBitmapToClipboard(pBitmap)
	{
		off1 := A_PtrSize = 8 ? 52 : 44
		off2 := A_PtrSize = 8 ? 32 : 24

		pid := DllCall("GetCurrentProcessId", "uint")
		hwnd := WinExist("ahk_pid " . pid)
		r1 := DllCall("OpenClipboard", "UPtr", hwnd)
		If !r1
			Return -1

		hBitmap := this.CreateHBITMAPFromBitmap(pBitmap, 0)
		If !hBitmap
		{
			DllCall("CloseClipboard")
			Return -3
		}

		r2 := DllCall("EmptyClipboard")
		If !r2
		{
			this.DeleteObject(hBitmap)
			DllCall("CloseClipboard")
			Return -2
		}

		oi := Buffer((A_PtrSize = 8) ? 104 : 84, 0)
		DllCall("GetObject", "UPtr", hBitmap, "int", oi.size, "UPtr", oi.ptr)
		hdib := DllCall("GlobalAlloc", "uint", 2, "UPtr", 40 + NumGet(oi, off1, "UInt"), "UPtr")
		pdib := DllCall("GlobalLock", "UPtr", hdib, "UPtr")
		DllCall("RtlMoveMemory", "UPtr", pdib, "UPtr", oi.ptr + off2, "UPtr", 40)
		DllCall("RtlMoveMemory", "UPtr", pdib + 40, "UPtr", NumGet(oi, off2 - A_PtrSize, "UPtr"), "UPtr", NumGet(oi, off1, "UInt"))
		DllCall("GlobalUnlock", "UPtr", hdib)
		this.DeleteObject(hBitmap)
		r3 := DllCall("SetClipboardData", "uint", 8, "UPtr", hdib) ; CF_DIB = 8
		DllCall("CloseClipboard")
		DllCall("GlobalFree", "UPtr", hdib)
		E := r3 ? 0 : -4    ; 0 - success
		Return E
	}
	;}
	;{ CreateCompatibleDC
	Static CreateCompatibleDC(hdc := 0)
	{
		Return DllCall("CreateCompatibleDC", "UPtr", hdc)
	}
	;}
	;{ CreateDIBSection
	Static CreateDIBSection(w, h, hdc := "", bpp := 32, &ppvBits := 0, Usage := 0, hSection := 0, Offset := 0)
	{
		hdc2 := hdc ? hdc : this.GetDC()
		bi := Buffer(40, 0)
		NumPut("UInt", 40, bi, 0)
		NumPut("UInt", w, bi, 4)
		NumPut("UInt", h, bi, 8)
		NumPut("UShort", 1, bi, 12)
		NumPut("UShort", bpp, bi, 14)
		NumPut("UInt", 0, bi, 16)

		hbm := DllCall("CreateDIBSection"
			, "UPtr", hdc2
			, "UPtr", bi.ptr    ; BITMAPINFO
			, "uint", Usage
			, "UPtr*", &ppvBits
			, "UPtr", hSection
			, "uint", Offset, "UPtr")

		If !hdc
			this.ReleaseDC(hdc2)
		Return hbm
	}
	;}
	;{ SelectObject
	Static SelectObject(hdc, hgdiobj)
	{
		Return DllCall("SelectObject", "UPtr", hdc, "UPtr", hgdiobj)
	}
	;}
	;{ BitBlt
	Static BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, raster := "")
	{
		Return DllCall("gdi32\BitBlt"
			, "UPtr", ddc
			, "int", dx, "int", dy
			, "int", dw, "int", dh
			, "UPtr", sdc
			, "int", sx, "int", sy
			, "uint", raster ? raster : 0x00CC0020)
	}
	;}
	;{ CreateBitmapFromHBITMAP
	Static CreateBitmapFromHBITMAP(hBitmap, hPalette := 0)
	{
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "UPtr", hBitmap, "UPtr", hPalette, "UPtr*", &pBitmap := 0)
		Return pBitmap
	}
	;}
	;{ CreateHBITMAPFromBitmap
	Static CreateHBITMAPFromBitmap(pBitmap, Background := 0xffffffff)
	{
		DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UPtr", pBitmap, "UPtr*", &hBitmap := 0, "int", Background)
		Return hBitmap
	}
	;}
	;{ DeleteObject
	Static DeleteObject(hObject)
	{
		Return DllCall("DeleteObject", "UPtr", hObject)
	}
	;}
	;{ ReleaseDC
	Static ReleaseDC(hdc, hwnd := 0)
	{
		Return DllCall("ReleaseDC", "UPtr", hwnd, "UPtr", hdc)
	}
	;}
	;{ DeleteDC
	Static DeleteDC(hdc)
	{
		Return DllCall("DeleteDC", "UPtr", hdc)
	}
	;}
	;{ DisposeImage
	Static DisposeImage(pBitmap, noErr := 0)
	{
		If (StrLen(pBitmap) <= 2 && noErr = 1)
			Return 0

		r := DllCall("gdiplus\GdipDisposeImage", "UPtr", pBitmap)
		If (r = 2 || r = 1) && (noErr = 1)
			r := 0
		Return r
	}
	;}
	;{ GetDC
	Static GetDC(hwnd := 0)
	{
		Return DllCall("GetDC", "UPtr", hwnd)
	}
	;}
	;{ SaveBitmapToFile
	Static SaveBitmapToFile(pBitmap, sOutput, Quality := 75, toBase64 := 0)
	{
		_p := 0

		SplitPath sOutput, , , &Extension
		If !RegExMatch(Extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG)$")
			Return -1

		Extension := "." Extension
		DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", &nCount := 0, "uint*", &nSize := 0)
		ci := Buffer(nSize)
		DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "UPtr", ci.ptr)
		If !(nCount && nSize)
			Return -2

		Static IsUnicode := StrLen(Chr(0xFFFF))
		If (IsUnicode)
		{
			StrGet_Name := "StrGet"
			Loop nCount
			{
				sString := %StrGet_Name%(NumGet(ci, (idx := (48 + 7 * A_PtrSize) * (A_Index - 1)) + 32 + 3 * A_PtrSize, "UPtr"), "UTF-16")
				If !InStr(sString, "*" Extension)
					Continue

				pCodec := ci.ptr + idx
				Break
			}
		} Else
		{
			Loop nCount
			{
				Location := NumGet(ci, 76 * (A_Index - 1) + 44, "UPtr")
				nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int", 0, "uint", 0, "uint", 0)
				sString := Buffer(nSize)
				DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
				If !InStr(sString, "*" Extension)
					Continue

				pCodec := ci.ptr + 76 * (A_Index - 1)
				Break
			}
		}

		If !pCodec
			Return -3

		If (Quality != 75)
		{
			Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
			If (Quality > 90 && toBase64 = 1)
				Quality := 90

			If RegExMatch(Extension, "^\.(?i:JPG|JPEG|JPE|JFIF)$")
			{
				DllCall("gdiplus\GdipGetEncoderParameterListSize", "UPtr", pBitmap, "UPtr", pCodec, "uint*", &nSize)
				EncoderParameters := Buffer(nSize, 0)
				DllCall("gdiplus\GdipGetEncoderParameterList", "UPtr", pBitmap, "UPtr", pCodec, "uint", nSize, "UPtr", EncoderParameters.ptr)
				nCount := NumGet(EncoderParameters, "UInt")
				Loop nCount
				{
					elem := (24 + A_PtrSize) * (A_Index - 1) + 4 + (pad := (A_PtrSize = 8) ? 4 : 0)
					If (NumGet(EncoderParameters, elem + 16, "UInt") = 1) && (NumGet(EncoderParameters, elem + 20, "UInt") = 6)
					{
						_p := elem + EncoderParameters.ptr - pad - 4
						NumPut(Quality, NumGet(NumPut(4, NumPut(1, _p + 0, "UPtr") + 20, "UInt"), "UPtr"), "UInt")
						Break
					}
				}
			}
		}

		If (toBase64 = 1)
		{
			DllCall("ole32\CreateStreamOnHGlobal", "UPtr", 0, "int", true, "UPtr*", &pStream := 0)
			_E := DllCall("gdiplus\GdipSaveImageToStream", "UPtr", pBitmap, "UPtr", pStream, "UPtr", pCodec, "uint", _p)
			If _E
				Return -6

			DllCall("ole32\GetHGlobalFromStream", "UPtr", pStream, "uint*", &hData)
			pData := DllCall("GlobalLock", "UPtr", hData, "UPtr")
			nSize := DllCall("GlobalSize", "uint", pData)

			bin := Buffer(nSize, 0)
			DllCall("RtlMoveMemory", "UPtr", bin.ptr, "UPtr", pData, "uptr", nSize)
			DllCall("GlobalUnlock", "UPtr", hData)
			ObjRelease(pStream)
			DllCall("GlobalFree", "UPtr", hData)

			DllCall("Crypt32.dll\CryptBinaryToStringA", "UPtr", bin.ptr, "uint", nSize, "uint", 0x40000001, "UPtr", 0, "uint*", &base64Length := 0)
			base64 := Buffer(base64Length, 0)
			_E := DllCall("Crypt32.dll\CryptBinaryToStringA", "UPtr", bin.ptr, "uint", nSize, "uint", 0x40000001, "UPtr", &base64, "uint*", base64Length)
			If !_E
				Return -7

			bin := Buffer(0)
			Return StrGet(base64, base64Length, "CP0")
		}

		_E := DllCall("gdiplus\GdipSaveImageToFile", "UPtr", pBitmap, "WStr", sOutput, "UPtr", pCodec, "uint", _p)
		Return _E ? -5 : 0
	}
	;}
}
;}
;}
