; main.ahk
#SingleInstance Force
#Persistent
#NoEnv
SetKeyDelay, -1, 0  ; Send instantly with no delay

; Disable CapsLock default behavior
SetCapsLockState, AlwaysOff

; Optional: CapsLock tap sends Escape (quick tap)
CapsLock::
    KeyWait, CapsLock, T0.3
    if !ErrorLevel
        Send, {Esc}
return

; Include global shortcuts
#Include globalShortcuts.ahk

; Include Norwegian letter mappings
#Include norwegianLetters.ahk

; Include RustRover-specific shortcuts
#Include rustShortcuts.ahk

; === Global Caps + h help handler ===
CapsLock & h::
{
    if (IsRustRoverActive()) {
        ShowRustHelp()
    } else {
        ShowGlobalHelp()
    }
}
return

ShowGlobalHelp() {
    Gui, GlobalHelp:New, +AlwaysOnTop +ToolWindow -Caption +Border +Owner
    Gui, GlobalHelp:Margin, 20, 20
    Gui, GlobalHelp:Font, s10, Segoe UI

    Gui, GlobalHelp:Add, Text,, 🧠  Global Shortcuts:
    Gui, GlobalHelp:Add, Text, y+10,
        (Join`n
        💻 Terminal Commands:
        • Caps + q → Run previous command (pwsh)
        • Caps + p → Open terminal in pwd of file explorer
        )
    Gui, GlobalHelp:Add, Text, y+10,
        (Join`n
        ⌨️ Letters:
        • Caps + æ → æ
        • Caps + ø → ø
        • Caps + å → å
        • Caps + e → é
        )
    Gui, GlobalHelp:Add, Text, y+10,
        (Join`n
        📌 General:
        • Caps + h → Show this help
        )

    Gui, GlobalHelp:Show, AutoSize Center, 🌟 Global Shortcut Help
    Gui, GlobalHelp:+LastFound
    global hHelpGui := WinExist("A")

    ; Listen for left mouse clicks inside this window
    OnMessage(0x201, "WM_LBUTTONDOWN") ; WM_LBUTTONDOWN = 0x201
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hHelpGui
    if (hwnd = hHelpGui) {
        ; Destroy the help GUI if clicked anywhere inside
        Gui, GlobalHelp:Destroy
    }
}

GlobalHelpClose:
GlobalHelpGuiEscape:
    Gui, GlobalHelp:Destroy
return
