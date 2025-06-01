; rustShortcuts.ahk

#If IsRustRoverActive()

CapsLock & r:: RunCargoCommand("cargo run")
CapsLock & t:: RunCargoCommand("cargo test")
CapsLock & c:: RunCargoCommand("cargo clippy")
CapsLock & d:: RunCargoCommand("cargo doc --open", true)
CapsLock & p:: RunCargoCommand("cargo doc --document-private-items --open", true)
CapsLock & b:: RunCargoCommand("cargo build")
CapsLock & x:: RunCargoCommand("cargo clean")
CapsLock & u:: RunCargoCommand("cargo update")
CapsLock & f:: RunCargoCommand("cargo clippy --fix --allow-dirty --allow-staged", true)
CapsLock & l:: RunCargoCommand("cargo fmt", true)
CapsLock & m:: RunCargoCommand("cargo `+nightly miri run")
CapsLock & n:: RunCargoCommand("cargo `+nightly miri test")

#If  ; End context

; === Rust-specific helpers ===

ShowRustHelp() {
    Gui, RustHelp:New, +AlwaysOnTop +ToolWindow -Caption +Border
    Gui, RustHelp:Margin, 20, 20
    Gui, RustHelp:Font, s10, Segoe UI

    Gui, RustHelp:Add, Text,, 🦀 RustRover Shortcuts:

    ; Build & Check
    Gui, RustHelp:Add, Text, y+10,
        (Join`n
        🧱 Build & Check:
        • Caps + b → cargo build
        • Caps + x → cargo clean
        • Caps + c → cargo clippy
        • Caps + f → cargo clippy --fix --allow-dirty --allow-staged
        )

    ; Run
    Gui, RustHelp:Add, Text, y+10,
        (Join`n
        🚀 Run:
        • Caps + r → cargo run
        • Caps + m → Run miri (analyze unsafe code at runtime)
        )

    ; Test
    Gui, RustHelp:Add, Text, y+10,
        (Join`n
        🧪 Test:
        • Caps + t → cargo test
        • Caps + n → Run miri test
        )

    ; Docs
    Gui, RustHelp:Add, Text, y+10,
        (Join`n
        📚 Docs:
        • Caps + d → cargo doc --open
        • Caps + p → cargo doc --document-private-items --open
        )

    ; Misc
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

    ; Listen for left mouse clicks inside this window
    OnMessage(0x201, "RustHelp_WM_LBUTTONDOWN") ; WM_LBUTTONDOWN = 0x201
}

RustHelp_WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global hRustHelpGui
    if (hwnd = hRustHelpGui) {
        Gui, RustHelp:Destroy
        ; Unregister message handler so it doesn't keep firing
        OnMessage(0x201, "")
    }
}

RustHelpGuiEscape:
Gui, RustHelp:Destroy
return




global terminalWarned := false

RunCargoCommand(command, returnFocus := false) {
    WinGetTitle, activeTitle, A
    if WinExist("pwsh")
    {
        WinActivate
        WinWaitActive, pwsh,, 1
        if (ErrorLevel)
            return
        
        ; Clear the current line: Home + Shift+End + Del
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




IsRustRoverActive() {
    WinGet, pid, PID, A
    Process, Exist, rustrover64.exe
    return pid == ErrorLevel
}
