; Handmade.ahk

; Global context: shortcuts active anytime Handmade is enabled and relevant apps are open
#If g_enableHandmade

CapsLock & b:: RunHandmadeCommand(g_buildPath)

CapsLock & d:: ActivateOrRunApplication(g_debuggerPath, "Debugger")

CapsLock & c:: ActivateOrRunApplication(g_editorPath, "Editor")

#If ; End global context

; === Helper function to activate or run an application ===
ActivateOrRunApplication(appPath, appName) {
    ; Extract executable name from path for WinExist
    SplitPath, appPath, appExeName
    if (appExeName = "") {
        MsgBox, 48, Error, No %appName% path configured or invalid.
        return
    }

    if WinExist("ahk_exe " . appExeName) {
        WinActivate, ahk_exe %appExeName%
    } else {
        try {
            Run, %appPath%
        } catch e {
            MsgBox, 48, %appName% Not Found, Could not find or launch %appName% at "%appPath%".
        }
    }
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
        if (idList > 0) {
            first_id := idList1
            WinActivate, ahk_id %first_id%
            WinWaitActive, ahk_id %first_id%,, 1
            if (ErrorLevel)
                return

            Send, {Home}+{End}{Del}
            Send, clear{Enter}

            commandEscaped := StrReplace(command, "+", "{+}")
            Send, %commandEscaped%{Enter}

            if (returnFocus && activeTitle != "")
                WinActivate, %activeTitle%
        }
        else if (!terminalWarned) {
            MsgBox, No active Windows Terminal window found!
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