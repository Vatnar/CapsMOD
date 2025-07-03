; main.ahk
#SingleInstance Force
#Persistent
#NoEnv
SetKeyDelay, -1, 0  ; Send instantly with no delay
SetCapsLockState, AlwaysOff  ; Disable CapsLock default behavior

; === Global state ===
global g_enableHandmade := true  ; default enabled

; === CapsLock tap = Esc ===
CapsLock::
    KeyWait, CapsLock, T0.3
    if !ErrorLevel
        Send, {Esc}
return

; === Shortcut config GUI ===
CapsLock & /:: ShowShortcutConfig()

ShowShortcutConfig() {
    Gui, ShortcutConfig:New, +AlwaysOnTop +ToolWindow +Border +Owner
    Gui, ShortcutConfig:Margin, 20, 20
    Gui, ShortcutConfig:Font, s10, Segoe UI
    Gui, ShortcutConfig:Add, Text,, 🔧 Shortcut Configuration:

    checked := g_enableHandmade ? "Checked" : ""
    Gui, ShortcutConfig:Add, Checkbox, vEnableHandmadeChecked %checked%, Enable Handmade shortcuts

    Gui, ShortcutConfig:Add, Button, gApplyShortcutConfig, Apply
    Gui, ShortcutConfig:Add, Button, gCancelShortcutConfig, Cancel
    Gui, ShortcutConfig:Show, AutoSize Center, ⚙️ Shortcut Config
}

ApplyShortcutConfig:
    Gui, ShortcutConfig:Submit
    g_enableHandmade := EnableHandmadeChecked
    Gui, ShortcutConfig:Destroy
return

CancelShortcutConfig:
    Gui, ShortcutConfig:Destroy
return

; === Help handler ===
CapsLock & h:: ShowContextHelp()

ShowContextHelp() {
    if (IsRustRoverActive()) {
        ShowRustHelp()
    } else if (IsHandmadeActive()) {
        ShowHandmadeHelp()
    } else {
        ShowGlobalHelp()
    }
}

ShowGlobalHelp() {
    Gui, GlobalHelp:New, +AlwaysOnTop +ToolWindow -Caption +Border +Owner
    Gui, GlobalHelp:Margin, 20, 20
    Gui, GlobalHelp:Font, s10, Segoe UI

    Gui, GlobalHelp:Add, Text,, 🧠 Global Shortcuts:
    Gui, GlobalHelp:Add, Text, y+10,
    (Join`n
    💻 Terminal Commands:
    • Caps + q → Run previous command (pwsh)
    • Caps + p → Open terminal in pwd of file explorer

    🌐 Window Management:
    • Caps + Space → Cycle Firefox windows

    ⌨️ Letters:
    • Caps + æ → æ
    • Caps + ø → ø
    • Caps + å → å
    • Caps + e → é

    📌 General:
    • Caps + h → Show this help
    • Caps + / → Configure shortcuts
    )

    Gui, GlobalHelp:Show, AutoSize Center, 🌟 Global Shortcut Help
    Gui, GlobalHelp:+LastFound
    global hHelpGui := WinExist("A")

    OnMessage(0x201, "WM_LBUTTONDOWN") ; click anywhere closes the help
}

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hHelpGui
    if (hwnd = hHelpGui) {
        Gui, GlobalHelp:Destroy
    }
}

GlobalHelpClose:
GlobalHelpGuiEscape:
    Gui, GlobalHelp:Destroy
return

; === External includes ===
#Include shortcuts\globalShortcuts.ahk
#Include shortcuts\norwegianLetters.ahk
#Include shortcuts\rustShortcuts.ahk
#Include shortcuts\handmade.ahk
