#Include ClipSend.ahk
#Include Info.ahk
#Include CleanInputBox.ahk
#Include Registers.ahk
#Include GetInput.ahk

#SingleInstance Force

^+;:: {
	if !input := CleanInputBox().WaitForInput() {
		return false
	}

	static runner_commands := Map(
		"regn", () => Registers(GetInput("L1", "{Esc}").Input).WriteOrAppend(CleanInputBox().WaitForInput().Replace("``n", "`n")),
		"reg", () => Registers.PeekNonEmpty(),
	)

	static runner_regex := Map(
		"cp", (input) => (A_Clipboard := input, Info('"' input '" copied')),
	)

	if runner_commands.Has(input) {
		runner_commands[input].Call()
		return
	}

	regex := "^("
	for key, _ in runner_regex {
		regex .= key "|"
	}
	regex .= ") (.+)"
	result := input.RegexMatch(regex)
	if runner_regex.Has(result[1])
		runner_regex[result[1]].Call(result[2])

}