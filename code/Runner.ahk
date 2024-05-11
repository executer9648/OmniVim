#Include ClipSend.ahk
#Include Info.ahk
#Include CleanInputBox.ahk
#Include Registers.ahk
#Include GetInput.ahk
#Include Marks.ahk

#SingleInstance Force

class Runner {
	static runner_commands := Map(
		"reg", () => Registers.PeekNonEmpty(),
	"regs", () => Registers.PeekNonEmpty(),
	"r", () => Registers.PeekNonEmpty(),
	"marks", () => Marks.showMarks(),
	"mark", () => Marks.showMarks(),
	"mmark", () => Marks.showMouseMarks(),
	"mm", () => MouseMarks.showMouseMarks(),
	"ms", () => Marks.showMarks(),
	"m", () => Marks.showMarks(),
	"delm", () => Marks.clearMarks(),
	"dm", () => Marks.clearMarks(),
	"w", () => Send("^s"),
	"sh", () => Marks.showSessionRecored(),)

	static runner_regex := Map(
		"cp", (input) => (A_Clipboard := input, Info('"' input '" copied')),
	"regn", (input) => this.Regnew(input),
	"rnew", (input) => this.Regnew(input),
	"reg", (input) => this.reg(input),
	"r", (input) => Registers(input).Look(),
	"dr", (input) => Registers(input).Truncate(),
	"dreg", (input) => Registers(input).Truncate(),
	"delreg", (input) => Registers(input).Truncate(),
	"delreg", (input) => Registers(input).Truncate(),
	"regdel", (input) => Registers(input).Truncate(),
	"mark", (input) => Marks.showMark(input),
	"mmark", (input) => MouseMarks.showMark(input),
	"mm", (input) => MouseMarks.showMark(input),
	"m", (input) => Marks.showMark(input),
	"delm", (input) => Marks.clearMark(input),
	"dm", (input) => Marks.clearMark(input),
	"k", (input) => Marks.killMark(input),
	"kill", (input) => Marks.killMark(input),
	"ss", (input) => Marks.saveSession(input),
	"os", (input) => Marks.openSession(input),
	"mks", (input) => Marks.startRecording(input),
	"so", (input) => Marks.openRecoredSession(input),
	"source", (input) => Marks.openRecoredSession(input),)

	static Regnew(input) {
		Registers(input).Look()
		Registers(input).WriteOrAppend(CleanInputBox().WaitForInput().Replace("``n", "`n"))
		Registers(input).Look()
	}

	static reg(input) {
		if InStr(input, "new", true) {
			; if input == "new" {
			handle := Infos("press the register!")
			this.regnew(GetInput("L1", "{Esc}").Input)
			handle.Destroy
			; }
		}
		else {
			Registers(input).Look()
		}
	}

	static openRunner() {
		if !input := CleanInputBox().WaitForInput() {
			return false
		}

		if this.runner_commands.Has(input) {
			this.runner_commands[input].Call()
			return
		}

		regex := "^("
		for key, _ in this.runner_regex {
			regex .= key "|"
		}
		regex .= ") (.+)"
		result := input.RegexMatch(regex)
		if this.runner_regex.Has(result[1])
			this.runner_regex[result[1]].Call(result[2])

	}
}