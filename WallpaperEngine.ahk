SetWorkingDir C:\AHK\support_files

Menu, Tray, Icon, shell32.dll, 209 ; this changes the tray icon to a little check mark!
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

F4::wallpaperFix()

wallpaperFix(){

keywait, %A_PriorHotKey% ;keywait is quite important.
;Let's pretend that you called this function using the following line:
;F4::preset("crop 50")
;In that case, F4 is the prior hotkey, and the script will WAIT until F4 has been physically RELEASED (up) before it will continue. 
;https://www.autohotkey.com/docs/commands/KeyWait.htm
;Using keywait is probably WAY cleaner than allowing the physical key UP event to just happen WHENEVER during the following function, which can disrupt commands like sendinput, and cause cross-talk with modifier keys.


;;---------You do not need the stuff BELOW this line.--------------

sendinput, {blind}{SC0EC} ;for debugging. YOU DO NOT NEED THIS.
;Keyshower(item,"preset") ;YOU DO NOT NEED THIS. -- it simply displays keystrokes on the screen for the sake of tutorials...
; if IsFunc("Keyshower")
	; {
	; Func := Func("Keyshower")
	; RetVal := Func.Call(item,"preset") 
	; }
	
	run, "D:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\wallpaper32.exe"
	sleep 1500
ifWinNotActive ahk_exe ui32.exe ;the exe is more reliable than the class, since it will work even if you're not on the primary Premiere window.
	{
	goto theEnding ;and this line is here just in case the function is called while not inside premiere. In my case, this is because of my secondary keyboards, which aren't usually using #ifwinactive in addition to #if getKeyState(whatever). Don't worry about it.
	}
	
;;---------You do not need the stuff ABOVE this line.--------------


;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.
; https://www.autohotkey.com/docs/commands/CoordMode.htm
coordmode, pixel, Window
coordmode, mouse, Window
coordmode, Caret, Window

;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
BlockInput, SendAndMouse
BlockInput, MouseMove
BlockInput, On
;The mouse will be unfrozen at the end of this function. Note that if you do get stuck while debugging this or any other function, CTRL SHIFT ESC will allow you to regain control of the mouse. You can then end the AHK script from the Task Manager.

SetKeyDelay, 0 ;NO DELAY BETWEEN STUFF sent using the "send"command! I thought it might actually be best to put this at "1," but using "0" seems to work perfectly fine.


MouseGetPos, xposP, yposP ;------------------stores the cursor's current coordinates at X%xposP% Y%yposP%
;KEEP IN MIND that this function should only be called when your cursor is hovering over a clip, or a group of selected clips, on the timeline. That's because the cursor will be returned to that exact location, carrying the desired preset, which it will drop there. MEANING, that this function won't work if you select clips, but don't have the cursor hovering over them.


sendinput, {blind}{SC0EC} ;for debugging. YOU DO NOT NEED THIS LINE.

sleep 15 ;"sleep" means the script will wait for 15 milliseconds before the next command. This is done to give Premiere some time to load its own things.


MouseGetPos, , , Window, classNN
WinGetClass, class, ahk_id %Window%

;tooltip, 2 - ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%

;;;note to self, I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... IDK. https://autohotkey.com/docs/commands/ControlGetPos.htm


;CenterMouseOnActiveWindow

 CoordMode,Mouse,Screen
    WinGetPos, winTopL_x, winTopL_y, width, height, A
    winCenter_x := winTopL_x + width/2
    winCenter_y := winTopL_y + height/2
    ;MouseMove, X, Y, 0 ; does not work with multi-monitor
    DllCall("SetCursorPos", int, winTopL_x, int, winTopL_y)

;;Now we have found a lot of useful information about this find box. Turns out, we don't need most of it...
;;we just need the X and Y coordinates of the "upper left" corner...

;;Comment in the following line to get a message box of your current variable values. The script will not advance until you dismiss a message box. (Use the enter key.)
;mousemove,winTopL_x, winTopL_y, 0
;MsgBox, xx=%winTopL_x% yy=%winTopL_y%


;FIRST MENU

MouseMove, winTopL_x+200, winTopL_y+50, 0 
sleep 5

MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5

MouseMove, winTopL_x+200, winTopL_y+180, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass
sleep 300


MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5

;msgbox, firstmenu


MouseMove, winTopL_x+200, winTopL_y+210, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass
sleep 300

MouseClick, left, , , 1 ;-----------------------the actual click

sleep 5

;SECOND MENU
MouseMove, winTopL_x+200, winTopL_y+180, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass
sleep 5


MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5

MouseMove, winTopL_x+200, winTopL_y+260, 0 ;--------------------for 100% UI scaling, this moves the cursor onto the magnifying glass
sleep 5

;msgbox, secondmenu
MouseClick, left, , , 1 ;-----------------------the actual click
sleep 5



Sendinput, !{F4} ;close wallpaper engine

MouseMove, xposP, yposP, 0 ;back to original cursor position


blockinput, MouseMoveOff ;returning mouse movement ability
BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL ALT DELETE will still work if you get stuck!! Cool.


;The line below is where all those GOTOs are going to.
theEnding:
}
;END of preset(). The two lines above this one are super important.



#ifwinactive ahk_class Notepad++
^r::
send ^s
sleep 10
SoundBeep, 1000,500
Reload
Return

