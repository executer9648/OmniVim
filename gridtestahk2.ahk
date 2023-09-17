CoordMode("Mouse", "Screen")

Hotkey("+z", label)

Hotkey("+x", label)

Hotkey("+c", label)

Hotkey("+a", label)

Hotkey("+s", label)

Hotkey("+d", label)

Hotkey("+q", label)

Hotkey("+w", label)

Hotkey("+e", label)

Hotkey("+Space", label)

Hotkey("^Space", label)


label(ThisHotkey)
{ ; V1toV2: Added bracket
   If (A_ThisHotkey = "^Space") {

      Var := ""

      Send("{Click right}")

      Return

   }

   If (A_ThisHotkey = "+Space") {

      Var := ""

      Send("{click}")

      Return

   }

   If (A_ThisHotkey = "+s") {

      Var := ""

      MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2) ;center the mouse

      Return

   }

   Var .= SubStr(A_ThisHotkey, -1) ;add the key to the variable

   x := A_ScreenWidth / (2 ** (StrLen(Var) * 2)) ;calculate the distances

   y := A_ScreenHeight / (2 ** (StrLen(Var) * 2))

   If InStr("qwe", SubStr(Var, -1)) ;if the key is in the up direction
      y *= -1 ;make move negative

   If InStr("zaq", SubStr(Var, -1)) ;key on right
      x *= -1

   If InStr("ad", SubStr(Var, -1)) ;if key is horizontal
      y := 0 ;cancel the up/down part

   If InStr("xw", SubStr(Var, -1)) ;if vertical
      x := 0 ;cancel the left/right

   MouseMove(x, y, 0, "r")


   Return
} ; V1toV2: Added bracket in the end
