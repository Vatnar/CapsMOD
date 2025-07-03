#If IsRustRoverActive()

CapsLock & t:: ShowCargoNextestInput()

CapsLock & r:: RunCargoCommand("cargo run")
CapsLock & c:: RunCargoCommand("cargo clippy")
CapsLock & d:: RunCargoCommand("cargo doc --open", true)
CapsLock & p:: RunCargoCommand("cargo doc --document-private-items --open", true)
CapsLock & b:: RunCargoCommand("cargo build")
CapsLock & x:: RunCargoCommand("cargo clean")
CapsLock & u:: RunCargoCommand("cargo update")
CapsLock & f:: RunCargoCommand("cargo clippy --fix --allow-dirty --allow-staged", true)
CapsLock & l:: RunCargoCommand("cargo fmt", true)
CapsLock & m:: RunCargoCommand("cargo +nightly miri run")
CapsLock & n:: RunCargoCommand("cargo +nightly miri test")

#If  ; End context


; === GUI for cargo nextest test input ===
ShowCargoNextestInput() {
    Gui, NextestInput:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, NextestInput:Margin, 20, 20
    Gui, NextestInput:Font, s10, Segoe UI

    Gui, NextestInput:Add, Text,, Enter test pattern:
    Gui, NextestInput:Add, Edit, vUserInput w300

    Gui, NextestInput:Show, AutoSize Center, 🦀 Run Cargo Nextest
    GuiControl, Focus, UserInput
}

GuiNextestInputEscape:
GuiNextestInputClose:
    Gui, NextestInput:Destroy
return

GuiNextestInputSubmit:
{
    Gui, NextestInput:Submit
    Gui, NextestInput:Destroy

    if (UserInput = "")
        RunCargoCommand("cargo nextest run")
    else
        RunCargoCommand("cargo nextest run " . UserInput)
}
return

; Make Enter submit form when NextestInput GUI active
#IfWinActive ahk_class AutoHotkeyGUI
~Enter::
{
    WinGetTitle, activeTitle, A
    if (activeTitle = "🦀 Run Cargo Nextest")
        Gosub, GuiNextestInputSubmit
}
return
#IfWinActive

#IfWinActive, 🦀 Run Cargo Nextest
Esc::
{
    Gui, NextestInput:Destroy
}
return
#IfWinActive


; === Show Rust help GUI ===

ShowRustHelp() {
    Gui, RustHelp:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, RustHelp:Margin, 20, 20
    Gui, RustHelp:Font, s10, Segoe UI

    Gui, RustHelp:Add, Text,, 🦀 RustRover Shortcuts:

    Gui, RustHelp:Add, Text, y+10,
    (Join`n
    🧱 Build & Check:
    • Caps + b → cargo build
    • Caps + x → cargo clean
    • Caps + c → cargo clippy
    • Caps + f → cargo clippy --fix --allow-dirty --allow-staged
    )

    Gui, RustHelp:Add, Text, y+10,
    (Join`n
    🚀 Run:
    • Caps + r → cargo run
    • Caps + m → Run miri (analyze unsafe code at runtime)
    )

    Gui, RustHelp:Add, Text, y+10,
    (Join`n
    🧪 Test:
    • Caps + t → cargo nextest run
    • Caps + n → Run miri test
    )

    Gui, RustHelp:Add, Text, y+10,
    (Join`n
    📚 Docs:
    • Caps + d → cargo doc --open
    • Caps + p → cargo doc --document-private-items --open
    )

    Gui, RustHelp:Add, Text, y+10,
    (Join`n
    🛠️ Misc:
    • Caps + l → cargo fmt
    • Caps + u → cargo update
    • Caps + h → Show this help
    )

    Gui, RustHelp:Show, AutoSize Center, 🦀 Rust Shortcut Help
    Gui, RustHelp:+LastFound
    global hRustHelpGui := WinExist("A")
    OnMessage(0x201, "RustHelp_WM_LBUTTONDOWN")
}

RustHelp_WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hRustHelpGui
    if (hwnd = hRustHelpGui) {
        Gui, RustHelp:Destroy
        OnMessage(0x201, "")
    }
}

RustHelpGuiEscape:
    Gui, RustHelp:Destroy
return


; === Run commands in pwsh terminal ===

global terminalWarned := false

RunCargoCommand(command, returnFocus := false) {
    WinGetTitle, activeTitle, A
    if WinExist("pwsh") {
        WinActivate
        WinWaitActive, pwsh,, 1
        if (ErrorLevel)
            return

        ; Clear current line: Home + Shift+End + Del
        Send, {Home}+{End}{Del}
        Send, clear{Enter}
        commandEscaped := StrReplace(command, "+", "{+}")
        Send, %commandEscaped%{Enter}

        if (returnFocus && activeTitle != "pwsh")
            WinActivate, %activeTitle%
    }
    else if (!terminalWarned) {
        MsgBox, Terminal window (pwsh) not found!
        terminalWarned := true
    }
}


; === Active window detection ===

IsRustRoverActive() {
    WinGet, pid, PID, A
    Process, Exist, rustrover64.exe
    return pid == ErrorLevel
}
