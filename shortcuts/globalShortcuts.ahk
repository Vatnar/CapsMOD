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

CapsLock & Space::
{
    ; Get all Firefox windows
    WinGet, idList, List, ahk_class MozillaWindowClass
    if (idList = 0)
    {
        MsgBox, No Firefox windows found.
        return
    }

    ; Get the active window's HWND
    WinGet, activeHwnd, ID, A

    ; Find active window index in the list
    idx := 0
    Loop, %idList%
    {
        this_id := idList%A_Index%
        if (this_id = activeHwnd)
        {
            idx := A_Index
            break
        }
    }

    ; Determine next window index to activate
    if (idx = 0 || idx = idList)
        nextIdx := 1
    else
        nextIdx := idx + 1

    nextId := idList%nextIdx%
    WinActivate, ahk_id %nextId%    
}
return


