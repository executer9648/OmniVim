#Include ClipSend.ahk
#Include Info.ahk
#Include CleanInputBox.ahk
#Include Registers.ahk
#Include GetInput.ahk
#Include Marks.ahk

#SingleInstance Force

class Runner {
	static runner_commands := Map(
		"reg new", () => Registers(GetInput("L1", "{Esc}").Input).WriteOrAppend(CleanInputBox().WaitForInput().Replace("``n", "`n")),
		"reg", () => Registers.PeekNonEmpty(),
		"r", () => Registers.PeekNonEmpty(),
		"marks", () => Marks.showMarks(),
		"m", () => Marks.showMarks(),
		"delm", () => Marks.clearMarks(),
		"dm", () => Marks.clearMarks(),
		"w", () => Send("^s"),
		"sh", () => Marks.showSessionRecored(),
	)

	static runner_regex := Map(
		"cp", (input) => (A_Clipboard := input, Info('"' input '" copied')),
		"reg", (input) => Registers(input).Look(),
		"r", (input) => Registers(input).Look(),
		"mark", (input) => Marks.showMark(input),
		"m", (input) => Marks.showMark(input),
		"delm", (input) => Marks.clearMark(input),
		"dm", (input) => Marks.clearMark(input),
		"k", (input) => Marks.killMark(input),
		"kill", (input) => Marks.killMark(input),
		"ss", (input) => Marks.saveSession(input),
		"os", (input) => Marks.openSession(input),
		"mks", (input) => Marks.startRecording(input),
		"so", (input) => Marks.openRecoredSession(input),
		"source", (input) => Marks.openRecoredSession(input),
	)

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