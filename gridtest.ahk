CoordMode, Mouse, Screen

Hotkey, +z, label

Hotkey, +x, label

Hotkey, +c, label

Hotkey, +a, label

Hotkey, +s, label

Hotkey, +d, label

Hotkey, +q, label

Hotkey, +w, label

Hotkey, +e, label

Hotkey, +Space, label

Hotkey, ^ Space, label


label:
   If (A_ThisHotkey = "^Space") {

      Var := ""

      send, {
         Click right}

      Return

   }

If (A_ThisHotkey = "+Space") {

   Var := ""

   send, {
      click}

   Return

}

If (A_ThisHotkey = "+s") {

   Var := ""

   MouseMove, A_ScreenWidth / 2, A_ScreenHeight / 2 ;center the mouse

   Return

}

Var .= SubStr(A_ThisHotkey, 0) ;add the key to the variable

x := A_ScreenWidth / (2 ** StrLen(Var) * 2) ;calculate the distances

y := A_ScreenHeight / (2 ** StrLen(Var) * 2)

If InStr("qwe", SubStr(Var, 0)) ;if the key is in the up direction
   y *= -1 ;make move negative

If InStr("zaq", SubStr(Var, 0)) ;key on right
   x *= -1

If InStr("ad", SubStr(Var, 0)) ;if key is horizontal
   y := 0 ;cancel the up/down part

If InStr("xw", SubStr(Var, 0)) ;if vertical
   x := 0 ;cancel the left/right

MouseMove, x, y, 0, r


Return