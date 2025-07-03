; Handmade.ahk

; Global context: shortcuts active anytime Handmade is enabled and relevant apps are open
#If g_enableHandmade

CapsLock & b:: RunHandmadeCommand(".\build.bat")

CapsLock & d::
    if WinExist("ahk_exe devenv.exe")
        WinActivate
    else
        MsgBox, Visual Studio (devenv.exe) not found!
return

CapsLock & c::
    if WinExist("ahk_exe clion64.exe")
        WinActivate
    else
        MsgBox, CLion not found!
return

CapsLock & h:: ShowHandmadeHelp()

#If  ; End global context

; === Handmade Helpers ===

ShowHandmadeHelp() {
    Gui, HandmadeHelp:New, +AlwaysOnTop +ToolWindow -Caption +Border +Owner
    Gui, HandmadeHelp:Margin, 20, 20
    Gui, HandmadeHelp:Font, s10, Segoe UI

    Gui, HandmadeHelp:Add, Text,, Handmade C++ Shortcuts:
    Gui, HandmadeHelp:Add, Text, y+10,
    (Join`n
    Build:
    • Caps + b → run build.bat

    Misc:
    • Caps + c → switch to CLion
    • Caps + d → switch to Visual Studio
    • Caps + h → show this help
    )

    Gui, HandmadeHelp:Show, AutoSize Center, Handmade Shortcut Help
    Gui, HandmadeHelp:+LastFound
    global hHandmadeHelpGui := WinExist("A")
    OnMessage(0x201, "HandmadeHelp_WM_LBUTTONDOWN")
}

HandmadeHelp_WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hHandmadeHelpGui
    if (hwnd = hHandmadeHelpGui) {
        Gui, HandmadeHelp:Destroy
        OnMessage(0x201, "")
    }
}

HandmadeHelpGuiEscape:
    Gui, HandmadeHelp:Destroy
return

; === Command runner ===

RunHandmadeCommand(command, returnFocus := false) {
    static terminalWarned := false
    WinGetTitle, activeTitle, A

    if WinExist("ahk_exe windowsterminal.exe") {
        WinGet, idList, List, ahk_exe windowsterminal.exe
        found := false

        Loop, % idList {
            this_id := idList%A_Index%
            WinGetTitle, thisTitle, ahk_id %this_id%

            if InStr(thisTitle, "Developer PowerShell") {
                found := true
                WinActivate, ahk_id %this_id%
                WinWaitActive, ahk_id %this_id%,, 1
                if (ErrorLevel)
                    return

                Send, {Home}+{End}{Del}
                Send, clear{Enter}

                commandEscaped := StrReplace(command, "+", "{+}")
                Send, %commandEscaped%{Enter}

                if (returnFocus && activeTitle != thisTitle)
                    WinActivate, %activeTitle%

                break
            }
        }

        if (!found && !terminalWarned) {
            MsgBox, Developer PowerShell tab not found in Windows Terminal!
            terminalWarned := true
        }
    }
    else if (!terminalWarned) {
        MsgBox, Windows Terminal not found!
        terminalWarned := true
    }
}

; === Activation logic ===

IsHandmadeActive() {
    global g_enableHandmade
    if (!g_enableHandmade)
        return false

    ; Check if any relevant process is running regardless of focus
    Process, Exist, clion64.exe
    if (ErrorLevel)
        return true

    Process, Exist, devenv.exe
    if (ErrorLevel)
        return true

    Process, Exist, windowsterminal.exe
    if (ErrorLevel) {
        ; Check for developer powershell tab title of any window
        WinGet, idList, List, ahk_exe windowsterminal.exe
        Loop, % idList {
            this_id := idList%A_Index%
            WinGetTitle, thisTitle, ahk_id %this_id%
            if InStr(thisTitle, "Developer PowerShell")
                return true
        }
    }

    return false
}
