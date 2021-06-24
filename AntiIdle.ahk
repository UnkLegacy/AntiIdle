#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

AntiSleepDelay := 5 * 60 * 1000	; First number in minutes, keep monitor awake
AntiIdleDelay := 2 * 1000		; First number in seconds, wiggle mouse every # seconds
AntiAFKDelay := 5 * 1000		; First number in seconds, press buttons every # seconds

Gui, +Resize
Gui, Add, Checkbox, y10 vAntiSleepVal, Keep display active
Gui, Add, Checkbox, vAntiIdleVal, Move mouse
Gui, Add, Checkbox, vAntiAFKVal, Press modifier keys
Gui, Add, Edit, vStopDelayVal w30, 60
Gui, Add, Text, xp+35 yp+5, Stop Idle after `# minutes
Gui, Add, Button, x10 y+10 w50, Start
Gui, Add, Button, x+10 w50, Stop
Gui, Add, Text, x+10 yp+5 Hidden vStatus, Anti Idle ON
Gui, Show, w300 h130, Anti Idle
Return

ButtonStart:
    Gui, Submit, NoHide
	
	StopDelay := StopDelayVal * 60 * 1000		; First number in minutes, disable idle after # minutes

    if (AntiSleepVal)
        SetTimer, AntiSleep, %AntiSleepDelay%    
    if (AntiIdleVal)
        SetTimer, AntiIdle, %AntiIdleDelay%
    if (AntiAFKVal)
        SetTimer, AntiAFK, %AntiAFKDelay%
	if (StopDelayVal)
		SetTimer, ButtonStop, %StopDelay%
    
    if (AntiSleepVal or AntiIdleVal or AntiAFKVal)
        GuiControl, Show, Status
Return

ButtonStop:
    GuiControl, Hide, Status
    SetTimer, AntiIdle, off
    SetTimer, AntiSleep, off
    SetTimer, AntiAFK, off
Return

AntiSleep:
    DllCall("SetThreadExecutionState", UInt, 0x80000003)
Return

AntiIdle:
    MouseMove, 0, 1, 0, R
    Sleep AntiIdleDelay / 2
    MouseMove, 0, -1, 0, R
Return

AntiAFK:
    Send, {Shift}
    Send, {Ctrl}
Return

GuiClose:
ExitApp

Esc::ExitApp