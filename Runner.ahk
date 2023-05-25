#Include ClipSend.ahk
#Include Info.ahk
#Include CleanInputBox.ahk
#Include Registers.ahk
#Include GetInput.ahk

#SingleInstance Force

class Runner {
	static runner_commands := Map(
		"regn", () => Registers(GetInput("L1", "{Esc}").Input).WriteOrAppend(CleanInputBox().WaitForInput().Replace("``n", "`n")),
		"reg", () => Registers.PeekNonEmpty(),
	)

	static runner_regex := Map(
		"cp", (input) => (A_Clipboard := input, Info('"' input '" copied')),
		"reg", (input) => Registers(input).Look(),
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