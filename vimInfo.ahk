#Include Info.ahk
class vimInfo {
	static text := ""
	static counter := 0
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

	static changeCounter(counter) {
		this.counter := counter
		this.infoText.Destroy()
		output := this.text this.counter
		this.infoText := Infos(output, , true)
		; this.infoText.ReplaceText(this.text, true)
	}

	static addText(text) {
		this.text .= text
		output := this.text this.counter
		this.infoText.Destroy()
		this.infoText := Infos(this.text, , true)
		; this.infoText.ReplaceText(this.text, true)
	}

	static destroy() {
		this.text := ""
		this.counter := 0
		this.infoText.Destroy()
	}
}