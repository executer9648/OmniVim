class MouseWindowH {
	_xPos := ""
	_yPos := ""
	_width := ""
	_height := ""
	_handler := ""

	__New() {
		_xPos := ""
		_yPos := ""
		_width := ""
		_height := ""
	}

	setxPos(xPos) {
		this._xPos := xPos
	}
	setyPos(yPos) {
		this._yPos := yPos
	}
	setWidth(width) {
		this._width := width
	}
	setHeight(height) {
		this._height := height
	}
	setHandler(handle) {
		this._handler := handle
	}
}