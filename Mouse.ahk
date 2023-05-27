;No dependencies

CoordMode "Mouse", "Screen"

class Mouse {

	static g_MouseSpeed := 1
	static g_MouseAccelerationSpeed := 10
	static g_MouseMaxSpeed := 5
	static g_MouseCurrentAccelerationSpeed := 0
	static g_MouseCurrentSpeed := this.g_MouseSpeed
	static g_MouseCurrentSpeedToDirection := 1

	static Accel := 0
	static SmallMove := 10
	static MediumMove := 70
	static BigMove := 200

	static HorizontalSeparator := 20
	static numberRow := 28 ;14
	static aRow := 26 ;13
	static zRow := 24 ;12
	static spaceRow := 12 ;6
	static keyboardCol := 20 ;5
	; you take the number of total keys devide by the rows in this case its 5
	; then you find you jumping number starting from 1 onwards
	static tildaCol := A_ScreenHeight / Mouse.keyboardCol
	static tabCol := A_ScreenHeight / Mouse.keyboardCol * 6
	static capsCol := A_ScreenHeight / Mouse.keyboardCol * 10
	static shiftCol := A_ScreenHeight / Mouse.keyboardCol * 14
	static spaceCol := A_ScreenHeight / Mouse.keyboardCol * 19

	static sx1 := A_ScreenWidth / Mouse.spaceRow
	static sx2 := A_ScreenWidth / Mouse.spaceRow * 3
	static sx3 := A_ScreenWidth / Mouse.spaceRow * 5
	static sx4 := A_ScreenWidth / Mouse.spaceRow * 7
	static sx5 := A_ScreenWidth / Mouse.spaceRow * 9
	static sx6 := A_ScreenWidth / Mouse.spaceRow * 11
	static sx7 := A_ScreenWidth / Mouse.spaceRow * 13
	static sx8 := A_ScreenWidth / Mouse.spaceRow * 15

	static zx1 := A_ScreenWidth / Mouse.zRow
	static zx2 := A_ScreenWidth / Mouse.zRow * 3
	static zx3 := A_ScreenWidth / Mouse.zRow * 5
	static zx4 := A_ScreenWidth / Mouse.zRow * 7
	static zx5 := A_ScreenWidth / Mouse.zRow * 9
	static zx6 := A_ScreenWidth / Mouse.zRow * 11
	static zx7 := A_ScreenWidth / Mouse.zRow * 13
	static zx8 := A_ScreenWidth / Mouse.zRow * 15
	static zx9 := A_ScreenWidth / Mouse.zRow * 17
	static zx10 := A_ScreenWidth / Mouse.zRow * 19
	static zx11 := A_ScreenWidth / Mouse.zRow * 21
	static zx12 := A_ScreenWidth / Mouse.zRow * 23

	static ax1 := A_ScreenWidth / Mouse.aRow
	static ax2 := A_ScreenWidth / Mouse.aRow * 3
	static ax3 := A_ScreenWidth / Mouse.aRow * 5
	static ax4 := A_ScreenWidth / Mouse.aRow * 7
	static ax5 := A_ScreenWidth / Mouse.aRow * 9
	static ax6 := A_ScreenWidth / Mouse.aRow * 11
	static ax7 := A_ScreenWidth / Mouse.aRow * 13
	static ax8 := A_ScreenWidth / Mouse.aRow * 15
	static ax9 := A_ScreenWidth / Mouse.aRow * 17
	static ax10 := A_ScreenWidth / Mouse.aRow * 19
	static ax11 := A_ScreenWidth / Mouse.aRow * 21
	static ax12 := A_ScreenWidth / Mouse.aRow * 23
	static ax13 := A_ScreenWidth / Mouse.aRow * 25

	static x1 := A_ScreenWidth / Mouse.numberRow
	static x2 := A_ScreenWidth / Mouse.numberRow * 3
	static x3 := A_ScreenWidth / Mouse.numberRow * 5
	static x4 := A_ScreenWidth / Mouse.numberRow * 7
	static x5 := A_ScreenWidth / Mouse.numberRow * 9
	static x6 := A_ScreenWidth / Mouse.numberRow * 11
	static x7 := A_ScreenWidth / Mouse.numberRow * 13
	static x8 := A_ScreenWidth / Mouse.numberRow * 15
	static x9 := A_ScreenWidth / Mouse.numberRow * 17
	static x10 := A_ScreenWidth / Mouse.numberRow * 19
	static x11 := A_ScreenWidth / Mouse.numberRow * 21
	static x12 := A_ScreenWidth / Mouse.numberRow * 23
	static x13 := A_ScreenWidth / Mouse.numberRow * 25
	static x14 := A_ScreenWidth / Mouse.numberRow * 27

	static VerticalSeparator := 7

	static TopY := A_ScreenHeight // Mouse.VerticalSeparator
	static MiddleY := A_ScreenHeight // 2
	static LowY := Round(A_ScreenHeight / 1080 * 740)
	static BottomY := A_ScreenHeight // Mouse.VerticalSeparator * 6

	static FarLeftX := A_ScreenWidth / Mouse.HorizontalSeparator
	static HighLeftX := A_ScreenWidth / Mouse.HorizontalSeparator * 3
	static MiddleLeftX := A_ScreenWidth / Mouse.HorizontalSeparator * 5
	static LowLeftX := A_ScreenWidth / Mouse.HorizontalSeparator * 7
	static LessThanMiddleX := A_ScreenWidth / Mouse.HorizontalSeparator * 9
	static MiddleX := A_ScreenWidth // 2
	static MoreThanMiddleX := A_ScreenWidth / Mouse.HorizontalSeparator * 11
	static LowRightX := A_ScreenWidth / Mouse.HorizontalSeparator * 13
	static MiddleRightX := A_ScreenWidth / Mouse.HorizontalSeparator * 15
	static HighRightX := A_ScreenWidth / Mouse.HorizontalSeparator * 17
	static FarRightX := A_ScreenWidth / Mouse.HorizontalSeparator * 19

	/**
	 * Hold down a mouse button if it's not held down currently.
	 * If it's already held down, release it.
	 * @param {Char} which Which mouse button to hold down or release. Only supports "L", "R", "M"
	 */
	static HoldIfUp(which) {
		if GetKeyState(which "Button")
			Click(which " Up")
		else
			Click(which " Down")
	}

	static MoveLeft(howMuch) {
		MouseGetPos &x, &y
		X -= howMuch
		DllCall("SetCursorPos", "int", x, "int", y)
		; MouseMove(-howMuch, 0,, "R")
		Mouse.SmallMove += Mouse.Accel
		Mouse.MediumMove += Mouse.Accel
		Mouse.BigMove += Mouse.Accel
	}
	static MoveUp(howMuch) {
		MouseGetPos &x, &y
		y -= howMuch
		DllCall("SetCursorPos", "int", x, "int", y)
		Mouse.SmallMove += Mouse.Accel
		Mouse.MediumMove += Mouse.Accel
		Mouse.BigMove += Mouse.Accel
	}
	static MoveDown(howMuch) {
		MouseGetPos &x, &y
		y += howMuch
		DllCall("SetCursorPos", "int", x, "int", y)
		Mouse.SmallMove += Mouse.Accel
		Mouse.MediumMove += Mouse.Accel
		Mouse.BigMove += Mouse.Accel
	}
	static MoveRight(howMuch) {
		MouseGetPos &x, &y
		X += howMuch
		DllCall("SetCursorPos", "int", x, "int", y)
		Mouse.SmallMove += Mouse.Accel
		Mouse.MediumMove += Mouse.Accel
		Mouse.BigMove += Mouse.Accel
	}

	; static MoveUp(howMuch)    => MouseMove(0, -howMuch,, "R")
	; static MoveDown(howMuch)  => MouseMove(0, howMuch,, "R")
	; static MoveRight(howMuch) => MouseMove(howMuch+=100, 0,, "R")

	/**
	 * Clicks with "Click", then moves the mouse to its initial position
	 * @param coordinates *String* "123 123" format
	 */
	static ClickThenGoBack(coordinates) {
		MouseGetPos(&initX, &initY)
		Click(coordinates)
		MouseMove(initX, initY)
	}

	/**
	 * Clicks by SendEventing the click, then moves the mouse to its initial position
	 * @param coordinates *String* "123 123" format
	 */
	static ClickThenGoBack_Event(coordinates) {
		MouseGetPos(&initX, &initY)
		SendEvent("{Click " coordinates "}")
		MouseMove(initX, initY)
	}

	/**
	 * Controlclicks in the current mouse position, on the active window
	 * @param winTitle *String* Specify a winTitle if you don't want to use the active window
	 * @param whichButton *String* L for left mouse button, R for right mouse button
	 */
	static ControlClick_Here(winTitle := "A", whichButton := "L") => (
		MouseGetPos(&locX, &locY),
		ControlClick("X" locX " Y" locY, winTitle, , whichButton)
	)

	static ButtonAcceleration()
	{
		global

		this.g_MouseCurrentAccelerationSpeed := 0
		this.g_MouseCurrentSpeed := this.g_MouseSpeed

		this.ButtonAccelerationStart()
	}

	static ButtonAccelerationStart()
	{
		global

		if this.g_MouseAccelerationSpeed >= 1
		{
			if this.g_MouseMaxSpeed > this.g_MouseCurrentSpeed
			{
				this.g_Temp := 0.001
				this.g_Temp *= this.g_MouseAccelerationSpeed
				this.g_MouseCurrentAccelerationSpeed += this.g_Temp
				this.g_MouseCurrentSpeed += this.g_MouseCurrentAccelerationSpeed
			}
		}

		;g_MouseRotationAngle convertion to speed of button direction
		this.g_MouseCurrentSpeedToDirection := 0
		this.g_MouseCurrentSpeedToDirection /= 90.0
		this.g_Temp := this.g_MouseCurrentSpeedToDirection

		if this.g_Temp >= 0
		{
			if this.g_Temp < 1
			{
				this.g_MouseCurrentSpeedToDirection := 1
				this.g_MouseCurrentSpeedToDirection -= this.g_Temp
				this.EndMouseCurrentSpeedToDirectionCalculation()
				return
			}
		}
		if this.g_Temp >= 1
		{
			if this.g_Temp < 2
			{
				this.g_MouseCurrentSpeedToDirection := 0
				this.g_Temp -= 1
				this.g_MouseCurrentSpeedToDirection -= this.g_Temp
				this.EndMouseCurrentSpeedToDirectionCalculation()
				return
			}
		}
		if this.g_Temp >= 2
		{
			if this.g_Temp < 3
			{
				this.g_MouseCurrentSpeedToDirection := -1
				this.g_Temp -= 2
				this.g_MouseCurrentSpeedToDirection += this.g_Temp
				this.EndMouseCurrentSpeedToDirectionCalculation()
				return
			}
		}
		if this.g_Temp >= 3
		{
			if this.g_Temp < 4
			{
				this.g_MouseCurrentSpeedToDirection := 0
				this.g_Temp -= 3
				this.g_MouseCurrentSpeedToDirection += this.g_Temp
				this.EndMouseCurrentSpeedToDirectionCalculation()
				return
			}
		}
		this.EndMouseCurrentSpeedToDirectionCalculation()
	}

	static EndMouseCurrentSpeedToDirectionCalculation()
	{
		global

		;g_MouseRotationAngle convertion to speed of 90 degrees to right
		this.g_MouseCurrentSpeedToSide := 0
		this.g_MouseCurrentSpeedToSide /= 90.0
		this.g_Temp := Mod(this.g_MouseCurrentSpeedToSide, 4)

		if this.g_Temp >= 0
		{
			if this.g_Temp < 1
			{
				this.g_MouseCurrentSpeedToSide := 0
				this.g_MouseCurrentSpeedToSide += this.g_Temp
				this.EndMouseCurrentSpeedToSideCalculation()
				return
			}
		}
		if this.g_Temp >= 1
		{
			if this.g_Temp < 2
			{
				this.g_MouseCurrentSpeedToSide := 1
				this.g_Temp -= 1
				this.g_MouseCurrentSpeedToSide -= this.g_Temp
				this.EndMouseCurrentSpeedToSideCalculation()
				return
			}
		}
		if this.g_Temp >= 2
		{
			if this.g_Temp < 3
			{
				this.g_MouseCurrentSpeedToSide := 0
				this.g_Temp -= 2
				this.g_MouseCurrentSpeedToSide -= this.g_Temp
				this.EndMouseCurrentSpeedToSideCalculation()
				return
			}
		}
		if this.g_Temp >= 3
		{
			if this.g_Temp < 4
			{
				this.g_MouseCurrentSpeedToSide := -1
				this.g_Temp -= 3
				this.g_MouseCurrentSpeedToSide += this.g_Temp
				this.EndMouseCurrentSpeedToSideCalculation()
				return
			}
		}
		this.EndMouseCurrentSpeedToSideCalculation()
	}

	static EndMouseCurrentSpeedToSideCalculation()
	{
		global

		this.g_MouseCurrentSpeedToDirection *= this.g_MouseCurrentSpeed
		this.g_MouseCurrentSpeedToSide *= this.g_MouseCurrentSpeed

		this.g_Temp := Mod(0, 2)
		if this.g_Temp = 1
		{
			this.g_MouseCurrentSpeedToSide *= 2
			this.g_MouseCurrentSpeedToDirection *= 2
		}
	}

	static ButtonAccelerationEnd()
	{
		global

		if GetKeyState(g_Button, "P")
		{
			this.ButtonAccelerationStart()
			return
		}

		SetTimer , 0
		g_MouseCurrentAccelerationSpeed := 0
		g_MouseCurrentSpeed := this.g_MouseSpeed
		g_Button := 0
	}

	static MoveLeftnew(howMuch) {
		this.ButtonAcceleration() ; zeroizes the mouse speed and accel
		MouseGetPos &x, &y
		x -= this.g_MouseCurrentSpeedToDirection
		DllCall("SetCursorPos", "int", x, "int", y)
	}
}