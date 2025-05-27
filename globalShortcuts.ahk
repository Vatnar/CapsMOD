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
