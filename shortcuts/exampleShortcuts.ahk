; ================================================
; Template / Example AHK Shortcut File
; For application-specific shortcuts using CapsLock
; NOT included by default — for reference only.
; ================================================

#If IsExampleAppActive()

; CapsLock + e: Example command
CapsLock & e::RunExampleCommand("echo Hello from Example!")

; CapsLock + h: Show example help
CapsLock & h::ShowExampleHelp()

#If  ; End app-specific context


; === Helper Functions ===

RunExampleCommand(command) {
    ; This simulates sending a command to a terminal (e.g., pwsh)
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, %command%{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}

ShowExampleHelp() {
    MsgBox, 64, ExampleApp Shortcuts,
(
ExampleApp AHK Shortcuts:

Caps + e → Run example command
Caps + h → Show this help menu
)
}

IsExampleAppActive() {
    ; Replace "exampleapp.exe" with the actual executable name
    WinGet, pid, PID, A
    Process, Exist, exampleapp.exe
    return pid == ErrorLevel
}
