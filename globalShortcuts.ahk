; globalShortcuts.ahk

; Global: CapsLock + q reruns last command in terminal (pwsh)
CapsLock & q::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, {Up}{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

CapsLock & p::
{
    explorer := ComObjCreate("Shell.Application")
    activeExplorerFolder := ""

    ; Get the HWND of the active window
    WinGet, activeHwnd, ID, A

    ; Loop through all explorer windows
    for window in explorer.Windows
    {
        if (InStr(window.FullName, "explorer.exe"))
        {
            ; Compare HWNDs (window.HWND is a COM property)
            if (window.HWND = activeHwnd)
            {
                activeExplorerFolder := window.Document.Folder.Self.Path
                break
            }
        }
    }

    if (activeExplorerFolder != "")
    {
        Run, wt -d "%activeExplorerFolder%"
    }
    else
    {
        MsgBox, Could not find an active Explorer window.
    }
}
return

