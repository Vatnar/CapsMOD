#SingleInstance Force
#Persistent
#NoEnv
SetKeyDelay, -1, 0
SetCapsLockState, AlwaysOff

; === Global state ===
global g_configFile := A_AppData . "\CapsMod\config.ini"
if !FileExist(A_AppData "\CapsMod")
    FileCreateDir, % A_AppData "\CapsMod"
global g_explorerPath
global g_enableHandmade

; Load config or use defaults
IniRead, g_explorerPath, %g_configFile%, Shortcuts, ExplorerPath, C:\Users\peter\dev
IniRead, g_enableHandmade, %g_configFile%, Shortcuts, EnableHandmade, 1
g_enableHandmade := (g_enableHandmade = 1)  ; convert to boolean

; === CapsLock tap = Esc ===
CapsLock::
    KeyWait, CapsLock, T0.3
    if !ErrorLevel
        Send, {Esc}
return

; === CapsLock + e opens explorer in configured path ===
CapsLock & e::
    Run, explorer.exe %g_explorerPath%
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

    Gui, ShortcutConfig:Add, Text, y+10, Explorer Path (Caps + e):
    Gui, ShortcutConfig:Add, Edit, vExplorerPathEdit w300 gEditEnterHandler, %g_explorerPath%

    Gui, ShortcutConfig:Add, Button, gApplyShortcutConfig Default, Apply
    Gui, ShortcutConfig:Add, Button, gCancelShortcutConfig, Cancel

    ; Set up handlers for close & escape
    Gui, ShortcutConfig:+Owner
    Gui, ShortcutConfig:Show, AutoSize Center, ⚙️ Shortcut Config
}

; This label handles Enter pressed in the edit control
EditEnterHandler:
    if (A_GuiEvent = "Enter") {
        Gosub, ApplyShortcutConfig
    }
return

; Handle window close and ESC as cancel
GuiShortcutConfigClose:
GuiShortcutConfigEscape:
    Gosub, CancelShortcutConfig
return

ApplyShortcutConfig:
    Gui, ShortcutConfig:Submit
    g_enableHandmade := EnableHandmadeChecked
    g_explorerPath := ExplorerPathEdit

    ; Write to config file
    IniWrite, %g_explorerPath%, %g_configFile%, Shortcuts, ExplorerPath
    IniWrite, % (g_enableHandmade ? 1 : 0), %g_configFile%, Shortcuts, EnableHandmade

    Gui, ShortcutConfig:Destroy
return

CancelShortcutConfig:
    Gui, ShortcutConfig:Destroy
return

; === Help handler ===
CapsLock & h:: ShowContextHelp()

ShowContextHelp() {
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

    📌 General:
    • Caps + e → Open explorer in configured path
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
