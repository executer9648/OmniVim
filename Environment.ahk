class Environment {

	static _windowManagerMode := false
	static WindowManagerMode {
		get => this._windowManagerMode
		set {
			this._windowManagerMode := value
			if value
				StateBulb[5].Create()
			else
				StateBulb[5].Destroy()
		}
	}

}
