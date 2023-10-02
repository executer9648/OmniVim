### Table of Contents 
- [Table of Contents](#table-of-contents)
  * [Global Functions:](#global-functions-)
    + [Emacs with \`(Tilde) Modifier](#emacs-with----tilde--modifier)
    + [Emacs with Tab or Capslock Modifier](#emacs-with-tab-or-capslock-modifier)
  * [Numlock Mode Functions:](#numlock-mode-functions-)
  * [Normal Mode Functions:](#normal-mode-functions-)
  * [Insert Mode Functions:](#insert-mode-functions-)
  * [Mouse Mode Functions:](#mouse-mode-functions-)
  * [Window Mover Mode Functions:](#window-mover-mode-functions-)
  * [Command Mode Functions:](#command-mode-functions-)
  * [Register Mode Functions:](#register-mode-functions-)

#### Global Functions:

| Shortcut                    | Functionality                            |
| --------------------------- |:---------------------------------------- |
| Ctrl +\[                    | start vim in Normal mode                 |
| Ctrl +\]                    | start Mouse mode                         |
| Alt + \`                    | Exit all Modes                           |
| Tab + \`                    | Exit all Modes                           |
| Ctrl + Alt + n              | Start/Exit Numlock Mode                  |
| Capslock                    | Left Ctrl                                |
| Ctrl + \`                   | Capslock                                 |
| Shift + Alt + WinKey + Ctrl | Capslock                                 |
| WinKey + Alt + h            | snap window to left(after key release)   |
| WinKey + Alt + j            | snap window to down(after key release)   |
| WinKey + Alt + k            | snap window to up(after key release)     |
| WinKey + Alt + l            | snap window to right(after key release)  |
| WinKey + Shift + a          | display last snapshot(Axelfublr created) |
| WinKey + Shift + Ctrl + r   | Reload script                            |
| WinKey + Shift + Ctrl + s   | Suspend/Resume script                    |
| Ctrl + WinKey + h           | switch to left desktop                   |
| Ctrl + WinKey + l           | switch to right desktop                  |
| Shift + WinKey + h          | move window to left screen               |
| Shift + WinKey + l          | move window to right screen              |
| Shift + WinKey + k          | snap window up keeping width             |
| Shift + WinKey + k          | snap window down                         |

##### Emacs with \`(Tilde) Modifier

| Shortcut | Functionality    |
|:-------- | ---------------- |
| \` + h   | Left arrow       |
| \` + b   | Left arrow       |
| \` + j   | Down arrow       |
| \` + n   | Down arrow       |
| \` + k   | Up arrow         |
| \` + p   | Up arrow         |
| \` + l   | Right arrow      |
| \` + f   | Right arrow      |
| \` + e   | Mouse wheel down |
| \` + y   | Mouse wheel up   |

##### Emacs with Tab or Capslock Modifier

In the following shortcuts Tab is interchangable with capslock space is interchangable with ctrl

| Shortcut        | Functionality                                                    |
| --------------- |:---------------------------------------------------------------- |
| Tab + \`        | Exit all Modes                                                   |
| Tab + n         | Down arrow                                                       |
| Tab + p         | Up arrow                                                         |
| Tab + f         | Right arrow                                                      |
| Tab + Space + f | Move 1 word right                                                |
| Tab + b         | Left arrow                                                       |
| Tab + Space + b | Move 1 word left                                                 |
| Tab + ,         | Go to first line                                                 |
| Tab + g         | Go to first line                                                 |
| Tab + .         | Go to last line                                                  |
| Tab + Space + g | Go to last line                                                  |
| Tab + h         | Backspace                                                        |
| Tab + w         | Delete 1 Word to the Left                                        |
| Tab + d         | Delete                                                           |
| Tab + Space +d  | Delete 1 Word to the right                                       |
| Tab + k         | Delete to end to line                                            |
| Tab + u         | Delete to start of line                                          |
| Tab + a         | Go to start to line                                              |
| Tab + e         | Go to end to line                                                |
| Tab + r         | Insert contents from register (next key pressed is the register) |
| Tab + x         | Close tab                                                        |
| Tab + Space + x | Reopen last closed tab                                           |
| Tab + s         | start search(like ctrl + f)                                      |
| Tab + =         | open context menu near mouse                                     |
#### Numlock Mode Functions:

| Shortcut       | Functionality           |
| -------------- | ----------------------- |
| j              | 1                       |
| k              | 2                       |
| l              | 3                       |
| u              | 4                       |
| i              | 5                       |
| o              | 6                       |
| m              | 0                       |
| ,              | 0                       |
| Ctrl + Alt + n | Start/Exit Numlock Mode |
| Escape         | Exit Numlock Mode       |
| Alt + \`       | Exit Numlock Mode       |
#### Normal Mode Functions:

| Shortcut         | Functionality                                                               |
|:---------------- |:--------------------------------------------------------------------------- |
| (Hold)z + q      | alt + f4                                                                    |
| (Hold)z + h      | Scroll left                                                                 |
| (Hold)z + j      | Scroll down                                                                 |
| (Hold)z + k      | Scroll up                                                                   |
| (Hold)z + l      | Scroll right                                                                |
| (Hold)z + =      | open context menu near mouse                                                |
| Alt + Shift + a  | Go to insert mode                                                           |
| :                | Go to Command mode                                                          |
| “                | Go to Register mode (works like in vim)                                     |
| /                | Start search (like ctrl + f)                                                |
| n                | Next search entry                                                           |
| N                | Previouse search entry                                                      |
| ~                | Change case                                                                 |
| v                | Go to Visual mode                                                           |
| V                | Go to Line Visual mode                                                      |
| m                | Go to Window Mover mode                                                     |
| r                | Replace char with user input                                                |
| s                | Delete char and enter insert mode                                           |
| Ctrl + Alt + n   | Start/Exit Numlock Mode                                                     |
| 0-9 numbers      | allow counters for normal functions like in vim                             |
| f                | Put Cursor at next to the right occurance of typed char                     |
| F                | Put Cursor at next to the left occurance of typed char                      |
| [number] f       | Put Cursor at next to the right occurance of typed [number] amount of chars |
| [number] F       | Put Cursor at next to the left occurance of typed [number] amount of chars  |
| gg               | Go to start to line                                                         |
| gt               | Go to next tab                                                              |
| gT               | Go to previouse  tab                                                        |
| G                | Go to end to line                                                           |
| Ctrl + w,q       | Close tab                                                                   |
| Ctrl + w,Q       | Close Window (alt + f4)                                                     |
| Ctrl + w,T       | Reopen closed tab                                                           |
| Ctrl + w,w       | Show Alt + Tab menu - could be cycled with more presses of the same hotkey  |
| e                | Move to end of next work                                                    |
| Alt + \`         | Exit all Modes                                                              |
| C                | delete to end of line and enter insert mode                                 |
| D                | delete to end of line                                                       |
| c                | Delete mode like in vim                                                     |
| d                | Change mode like in vim                                                     |
| Ctrl + e         | Scroll down                                                                 |
| Ctrl + y         | Scroll up                                                                   |
| Ctrl + Shift + e | Zoom Out                                                                    |
| Ctrl + Shift + y | Zoom In                                                                     |
| i                | Go to Insert Mode before cursor                                             |
| I                | Go to Insert Mode before all line                                           |
| a                | Go to Insert Mode after cursor                                              |
| A                | Go to Insert Mode after all line                                            |
| h                | move left with selection                                                    |
| j                | move down with selection                                                    |
| k                | move up with selection                                                      |
| l                | move right with selection                                                   |
| spacebar         | move right with selection                                                   |
| j                | join bottom line to current line                                            |
| x                | delete                                                                      |
| X                | Backspace                                                                   |
| b                | Move 1 word back                                                            |
| w                | Move 1 word forward                                                         |
| o                | Create new line bellow and go into insert mode                              |
| O                | Create new line above and go into insert mode                               |
| u                | Undo                                                                        |
| cltr + r         | Redo                                                                        |
| y                | Yank mode like in vim                                                       |
| Y                | Yank until end of line                                                      |
| p                | Paste                                                                       |
| P                | Paste before cursor                                                         |
| 0                | Go to start of line                                                         |
| $                | Go to End of line                                                           |

#### Insert Mode Functions:

| Shortcut         | Functionality                                                    |
| ---------------- |:---------------------------------------------------------------- |
| Ctrl + n         | Down arrow                                                       |
| Ctrl + p         | Up arrow                                                         |
| Ctrl + f         | Right arrow                                                      |
| Alt + f          | Move 1 word right                                                |
| Ctrl + b         | Left arrow                                                       |
| Alt + b          | Move 1 word left                                                 |
| Ctrl + Alt + ,   | Go to first line                                                 |
| Ctrl + Alt + .   | Go to last line                                                  |
| Ctrl + h         | Backspace                                                        |
| Ctrl + w         | Delete 1 Word to the Left                                        |
| Ctrl + d         | Delete                                                           |
| Ctrl + Alt +d    | Delete 1 Word to the right                                       |
| Ctrl + k         | Delete to end to line                                            |
| Ctrl + u         | Delete to start of line                                          |
| Ctrl + a         | Go to start to line                                              |
| Ctrl + e         | Go to end to line                                                |
| Ctrl + r         | Insert contents from register (next key pressed is the register) |
| Ctrl + x         | Close tab                                                        |
| Ctrl + Shift + x | Reopen last closed tab                                           |
| Ctrl + s         | start search(like ctrl + f) and next occurance                   |
| Ctrl + Shift + s | start search(like ctrl + f) and previous occurance               |
| Ctrl + =         | open context menu near mouse                                     |
| Escape           | return to normal mode                                            |

#### Mouse Mode Functions:
 - Clicks work with ctrl or shift 
  
| Shortcut  | Functionality                      |
| --------- |:---------------------------------- |
| u         | move mouse up left normal speed    |
| n         | move mouse down left normal speed  |
| ,         | move mouse down right normal speed |
| o         | move mouse up right normal speed   |
| h         | move mouse left normal speed       |
| j         | move mouse down normal speed       |
| k         | move mouse up normal speed         |
| l         | move mouse right left normal speed |
| Ctrl + u  | move mouse up left high speed      |
| Ctrl + n  | move mouse down left high speed    |
| Ctrl + ,  | move mouse down right high speed   |
| Ctrl + o  | move mouse up right high speed     |
| Ctrl + h  | move mouse left high speed         |
| Ctrl + j  | move mouse down high speed         |
| Ctrl + k  | move mouse up high speed           |
| Ctrl + l  | move mouse right left high speed   |
| Space + u | move mouse up left low speed       |
| Space + n | move mouse down left low speed     |
| Space + , | move mouse down right low speed    |
| Space + o | move mouse up right low speed      |
| Space + h | move mouse left low speed          |
| Space + j | move mouse down low speed          |
| Space + k | move mouse up low speed            |
| Space + l | move mouse right left low speed    |
| i         | Go to insert mode                  |
| m         | Go to Window mover mode            |
| t         | Left click                         |
| Tab + t   | Right click                        |
| b         | Middle click                       |

#### Window Mover Mode Functions:
- Numbers move the window to related location on screen 
	- Ctrl moves them in Lower layer
	- Shift moves them in Middle layer
	- Default is in Upper layer

| Shortcut | Functionality                      |
| -------- |:---------------------------------- |
| h        | move window left normal speed       |
| j        | move window down normal speed       |
| k        | move window up normal speed         |
| l        | move window right left normal speed |
| Ctrl + h  | move window left high speed         |
| Ctrl + j  | move window down high speed         |
| Ctrl + k  | move window up high speed           |
| Ctrl + l  | move window right left high speed   |
| shift + h | move window left low speed          |
| shift + j | move window down low speed          |
| shift + k | move window up low speed            |
| shift + l | move window right left low speed    |

#### Command Mode Functions:
#### Register Mode Functions:
