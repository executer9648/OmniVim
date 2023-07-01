#Include Info.ahk
class vimInfo {
	static text := ""
	static infoText := Infos("")

	__New(text) {
		this.text := text
		this.infoText := Infos(this.text, , true)
		this.infoText.Destroy()
	}

	static changeText(text) {
		this.text := text
		this.infoText.Destroy()
		this.infoText := Infos(this.text, , true)
		; this.infoText.ReplaceText(this.text, true)
	}

	static addText(text) {
		this.text .= text
		this.infoText.Destroy()
		this.infoText := Infos(this.text, , true)
		; this.infoText.ReplaceText(this.text, true)
	}

	static destroy() {
		this.infoText.Destroy()
		this.text := ""
	}
}