#Include Text.ahk
#Include Info.ahk
#Include ClipSend.ahk

class RecordQ {
	/**
	 * Commands executed will note you of their completion.
	 * Set up how long they should stay.
	 * In milliseconds.
	 * @type {Integer}
	 */
	static InfoTimeout := 1000

	/**
	 * The directory where you keep all of your register files.
	 * Format: C:\Programming\registers
	 * @type {String}
	 */
	static RegistersDirectory := "C:\Recording"

	/**
	 * A string of characters that are accepted as register names.
	 * Every register is just a file that has the character in its name.
	 * Consider whether a character you want to add to this string would be allowed in a filename.
	 * Case sensitive.
	 * @type {String}
	 */
	static ValidRegisters := "1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"

	/**
	 * @returns {String} The path of the register of entered key
	 */
	static GetPath(key) => RecordQ.RegistersDirectory "\Rec_" key ".txt"

	/**
	 * @returns {String} Text inside of the register file
	 */
	Read() {
		path := RecordQ.GetPath(this.key)
		return this.__TryGetRegisterText(path)
	}

	/**
	 * Remove the contents of a register
	 */
	Truncate() {
		path := RecordQ.GetPath(this.key)
		WriteFile(path)
		Info(this.key " cleared", RecordQ.InfoTimeout)
	}

	/**
	 * Write the contents of your clipboard to a register
	 */
	static Write(text, key) {
		path := Marks.GetPath(key)
		WriteFile(path, text)
		Info(key " clipboard written", Registers.InfoTimeout)
	}

	/**
	 * Append the contents of your clipboard to a register
	 */
	Append(text?) {
		path := RecordQ.GetPath(this.key)
		text := text ?? A_Clipboard
		if !text {
			Info(this.key " empty append denied", RecordQ.InfoTimeout)
			return
		}
		AppendFile(path, "`n" text)
		Info(this.key " clipboard appended", RecordQ.InfoTimeout)
	}

	/**
	 * Write the contents of your clipboard to a register if you passed a lowercase key.
	 * *Append* the contents of your clipbaord to a register if you passed an upppercase key.
	 */
	WriteOrAppend(text?) => this.IsUpper ? this.Append(text?) : this.Write(text?)

}