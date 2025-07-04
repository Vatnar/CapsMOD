#SingleInstance Force
#Persistent
#NoEnv
SetKeyDelay, -1, 0
SetCapsLockState, AlwaysOff

; === Global State and Initialization ===
global g_configFile := A_AppData . "\CapsMod\config.ini"
if !FileExist(A_AppData "\CapsMod")
    FileCreateDir, % A_AppData "\CapsMod"

IniRead, g_enableHandmade, %g_configFile%, Shortcuts, EnableHandmade, 1
g_enableHandmade := (g_enableHandmade = 1)

global g_paths := []

Loop, 5 {
    IniRead, val, %g_configFile%, Paths, Path%A_Index%,
    if (val = "ERROR")
        val := "C:\Default\Path" . A_Index . ".txt"
    g_paths[A_Index] := val
}

; === CapsLock Tap Behavior ===
CapsLock::
    KeyWait, CapsLock, T0.3
    if !ErrorLevel
        Send, {Esc}
return

; === CapsLock + e: Show Paths and Open Selected ===
CapsLock & e::
{
    ShowPathChooser()
    Input, key, L1
if (key = "Esc") {
    Gui, PathChooser:Destroy
    return
}
    Gui, PathChooser:Destroy
    if (key ~= "[1-5]") {
        idx := key + 0
        selectedPath := g_paths[idx]
        if FileExist(selectedPath)
            Run, %selectedPath%
        else
            MsgBox, 48, File Not Found, The file does not exist:`n%selectedPath%
    } else {
    }
return
}

; === CapsLock + /: Open Shortcut Configuration GUI ===
CapsLock & /::
{
    ShowShortcutConfig()
return
}

; === Shortcut Configuration GUI Functions ===
ShowShortcutConfig() {
    global g_enableHandmade, g_paths

    Gui, ShortcutConfig:Destroy
    Gui, ShortcutConfig:New, +AlwaysOnTop +ToolWindow +Border +Owner
    Gui, ShortcutConfig:Margin, 20, 20
    Gui, ShortcutConfig:Font, s10, Segoe UI
    Gui, ShortcutConfig:Add, Text,, 🔧 Shortcut Configuration:

    checked := g_enableHandmade ? "Checked" : ""
    Gui, ShortcutConfig:Add, Checkbox, vEnableHandmadeChecked %checked%, Enable Handmade shortcuts

    Gui, ShortcutConfig:Add, Text, y+15, Paths (Caps + e + [1..5]):

    Loop, 5 {
        Gui, ShortcutConfig:Add, Edit, vPathEdit%A_Index% w400, % g_paths[A_Index]
    }

    Gui, ShortcutConfig:Add, Button, gApplyShortcutConfig Default, Apply
    Gui, ShortcutConfig:Add, Button, gCancelShortcutConfig, Cancel

    Gui, ShortcutConfig:Show, AutoSize Center, ⚙️ Shortcut Config
}

ApplyShortcutConfig:
    global g_enableHandmade, g_paths, g_configFile
    global EnableHandmadeChecked
    global PathEdit1, PathEdit2, PathEdit3, PathEdit4, PathEdit5

    Gui, ShortcutConfig:Submit

    g_enableHandmade := EnableHandmadeChecked

    Loop, 5 {
        g_paths[A_Index] := PathEdit%A_Index%
        IniWrite, % g_paths[A_Index], %g_configFile%, Paths, Path%A_Index%
    }

    IniWrite, % (g_enableHandmade ? 1 : 0), %g_configFile%, Shortcuts, EnableHandmade

    Gui, ShortcutConfig:Destroy
return

CancelShortcutConfig:
    Gui, ShortcutConfig:Destroy
return

; === Path Chooser GUI ===
ShowPathChooser() {
    global g_paths
    Gui, PathChooser:Destroy
    Gui, PathChooser:New, +AlwaysOnTop +ToolWindow +Border +Owner
    Gui, PathChooser:Margin, 20, 20
    Gui, PathChooser:Font, s10, Segoe UI
    Gui, PathChooser:Add, Text,, Select a path (press 1-5):

    Loop, 5 {
        pathText := A_Index . " -> " . g_paths[A_Index]
        Gui, PathChooser:Add, Text,, %pathText%
    }

    Gui, PathChooser:Show, AutoSize Center, Choose Path
}

; === CapsLock + s: Update Path from Active Explorer Folder ===
CapsLock & s::
{
    WinGetClass, class, A
    if (class != "CabinetWClass" && class != "ExploreWClass") {
        MsgBox, 48, Not Explorer, This hotkey only works when Explorer is active.
        return
    }

    folderPath := GetExplorerPath()
    if (!folderPath) {
        MsgBox, 48, Error, Could not retrieve Explorer path.
        return
    }

    ShowPathChooser()
    Input, key, L1
if (key = "Esc") {
    Gui, PathChooser:Destroy
    return
}
    Gui, PathChooser:Destroy

    if (key ~= "[1-5]") {
        idx := key + 0
        global g_paths, g_configFile
        g_paths[idx] := folderPath
        IniWrite, % folderPath, %g_configFile%, Paths, Path%idx%
    } else {
    }
return
}

; === Helper function: Get Active Explorer Folder Path via COM ===
GetExplorerPath() {
    for window in ComObjCreate("Shell.Application").Windows {
        if (window.hwnd = WinExist("A")) {
            try {
                path := window.Document.Folder.Self.Path
                return path
            } catch e {
                return ""
            }
        }
    }
    return ""
}

; === Help GUI and Handlers ===
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
    • Caps + e → Open configured file
    • Caps + h → Show this help
    • Caps + / → Configure shortcuts
    )

    Gui, GlobalHelp:Show, AutoSize Center, 🌟 Global Shortcut Help
    Gui, GlobalHelp:+LastFound
    global hHelpGui := WinExist("A")

    OnMessage(0x201, "WM_LBUTTONDOWN")
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

; === Tray Menu Setup and Handlers ===
Menu, Tray, NoStandard
Menu, Tray, Add, Edit Config in VSCode, EditConfig
Menu, Tray, Add, Suspend Hotkeys, SuspendHotkeys
Menu, Tray, Add, Pause Script, PauseScript
Menu, Tray, Add, Exit, ExitScript

return  ; End of auto-execute section

EditConfig:
    Run, code "C:\Users\peter\Documents\AutoHotkey\CapsMOD"
return

SuspendHotkeys:
    Suspend
return

PauseScript:
    Pause
return

ExitScript:
    ExitApp
return

; === External Includes ===
#Include shortcuts\globalShortcuts.ahk
#Include shortcuts\norwegianLetters.ahk
#Include shortcuts\rustShortcuts.ahk
#Include shortcuts\handmade.ahk
