#SingleInstance Force
#UseHook true

global counter := 5

h:: {
	loop counter {
		Send "{Left}"
	}
}