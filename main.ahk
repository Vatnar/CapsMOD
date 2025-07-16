#SingleInstance Force
#Persistent
#NoEnv
#UseHook
SetKeyDelay, -1, 0
SetCapsLockState, AlwaysOff

; === Config file path and initialization ===
global g_configFile := A_AppData . "\CapsMod\config.ini"

if !FileExist(A_AppData "\CapsMod")
    FileCreateDir, % A_AppData "\CapsMod"

global g_paths := []
global g_editorPath := ""
global g_debuggerPath := ""
global g_enableHandmade := true
global g_buildPath := ""


; --- Load config ---
LoadConfig() {
    global g_configFile, g_paths, g_editorPath, g_debuggerPath, g_enableHandmade

    IniRead, enableRaw, %g_configFile%, Shortcuts, EnableHandmade, 1
    g_enableHandmade := (enableRaw = 1)

    Loop, 5 {
        IniRead, val, %g_configFile%, Paths, Path%A_Index%
        if (val != "ERROR")
            g_paths[A_Index] := val
        else
            g_paths[A_Index] := ""
    }

    IniRead, val, %g_configFile%, Tools, EditorPath
    if (val != "ERROR")
        g_editorPath := val
    else
        g_editorPath := "clion64.exe"

    IniRead, val, %g_configFile%, Tools, DebuggerPath
    if (val != "ERROR")
        g_debuggerPath := val
    else
        g_debuggerPath := "raddbg.exe"

    IniRead, val, %g_configFile%, Tools, BuildPath
if (val != "ERROR")
    g_buildPath := val
else
    g_buildPath := "" ; default empty or set some default like "build.bat"

}
LoadConfig()

; --- Save config ---
SaveConfig() {
    global g_configFile, g_paths, g_editorPath, g_debuggerPath, g_enableHandmade

    IniWrite, % (g_enableHandmade ? 1 : 0), %g_configFile%, Shortcuts, EnableHandmade

    Loop, 5 {
        IniWrite, % g_paths[A_Index], %g_configFile%, Paths, Path%A_Index%
    }

    IniWrite, % g_editorPath, %g_configFile%, Tools, EditorPath
    IniWrite, % g_debuggerPath, %g_configFile%, Tools, DebuggerPath
    IniWrite, % g_buildPath, %g_configFile%, Tools, BuildPath

}

; === CapsLock + e: Show path chooser and run selected ===
CapsLock & e::
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
    }
return

; === CapsLock + s: Update selected path from active Explorer folder ===
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
    }
}
return

; === Show path chooser GUI ===
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

; === Get Active Explorer Folder Path ===
GetExplorerPath() {
    for window in ComObjCreate("Shell.Application").Windows {
        if (window.hwnd = WinExist("A")) {
            try {
                return window.Document.Folder.Self.Path
            } catch e {
                return ""
            }
        }
    }
    return ""
}

; === CapsLock + /: Show shortcut config GUI ===
CapsLock & /::
    ShowShortcutConfig()
return

ShowShortcutConfig() {
    global g_enableHandmade, g_paths, g_editorPath, g_debuggerPath

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

    Gui, ShortcutConfig:Add, Text, y+15, Editor Path (e.g., clion64.exe or full path):
    Gui, ShortcutConfig:Add, Edit, vEditorPathEdit w400, % g_editorPath
    Gui, ShortcutConfig:Add, Text, y+15, Build Command/Path (e.g., build.bat or build.exe):
Gui, ShortcutConfig:Add, Edit, vBuildPathEdit w400, % g_buildPath
    Gui, ShortcutConfig:Add, Text, y+15, Debugger Path (e.g., raddbg.exe or full path):
    Gui, ShortcutConfig:Add, Edit, vDebuggerPathEdit w400, % g_debuggerPath

    Gui, ShortcutConfig:Add, Button, gApplyShortcutConfig Default, Apply
    Gui, ShortcutConfig:Add, Button, gCancelShortcutConfig, Cancel

    Gui, ShortcutConfig:Show, AutoSize Center, ⚙️ Shortcut Config
}

ApplyShortcutConfig:
{
    global g_enableHandmade, g_paths, g_configFile, g_editorPath, g_debuggerPath
    global EnableHandmadeChecked
    global PathEdit1, PathEdit2, PathEdit3, PathEdit4, PathEdit5
    global EditorPathEdit, DebuggerPathEdit
    global BuildPathEdit

    Gui, ShortcutConfig:Submit

    g_enableHandmade := EnableHandmadeChecked

    Loop, 5 {
        thisVal := PathEdit%A_Index%
        g_paths[A_Index] := thisVal
    }

    g_editorPath := EditorPathEdit
    g_debuggerPath := DebuggerPathEdit
    g_buildPath := BuildPathEdit

    SaveConfig()

    Gui, ShortcutConfig:Destroy
}
return

CancelShortcutConfig:
    Gui, ShortcutConfig:Destroy
return

; === CapsLock + Alt: Switch to Windows Terminal or launch it ===
~*Alt::
    if GetKeyState("CapsLock", "P")
    {
        if WinExist("ahk_exe WindowsTerminal.exe")
            WinActivate, ahk_exe WindowsTerminal.exe
        else
            Run, wt.exe

        KeyWait, Alt
        KeyWait, CapsLock
    }
return

; === Tray Menu Setup ===
Menu, Tray, NoStandard
Menu, Tray, Add, Edit Config in VSCode, EditConfig
Menu, Tray, Add, Suspend Hotkeys, SuspendHotkeys
Menu, Tray, Add, Pause Script, PauseScript
Menu, Tray, Add, Exit, ExitScript
return

EditConfig:
    Run, code "%g_configFile%"
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

; === CapsLock + h: Show global shortcuts help ===
CapsLock & h:: ShowGlobalHelp()

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
    • Caps + Alt → Switch to Windows Terminal

    🌐 Window Management:
    • Caps + Space → Cycle Firefox windows
    • Caps + c → switch to configured Editor
    • Caps + d → switch to configured Debugger

    ⌨️ Letters:
    • Caps + æ → æ
    • Caps + ø → ø
    • Caps + å → å

    📌 General:
    • Caps + e → Open configured file
    • Caps + h → Show this help
    • Caps + / → Configure shortcuts and paths

    Build:
    • Caps + b → run build.bat
    )

    Gui, GlobalHelp:Show, AutoSize Center, 🌟 Global Shortcut Help
    Gui, GlobalHelp:+LastFound
    global hHelpGui := WinExist("A")

    OnMessage(0x201, "GlobalHelp_WM_LBUTTONDOWN")
}


GlobalHelp_WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hHelpGui
    if (hwnd = hHelpGui) {
        Gui, GlobalHelp:Destroy
        OnMessage(0x201, "")
    }
}

GlobalHelpClose:
GlobalHelpGuiEscape:
    Gui, GlobalHelp:Destroy
return

#Include shortcuts/globalShortcuts.ahk
#Include shortcuts/handmade.ahk
#Include shortcuts/norwegianLetters.ahk
#Include shortcuts/rustShortcuts.ahk
