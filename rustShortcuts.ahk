; rustShortcuts.ahk

#If IsRustRoverActive()

CapsLock & r:: RunCargoCommand("cargo run")
CapsLock & t:: RunCargoCommand("cargo test")
CapsLock & c:: RunCargoCommand("cargo clippy")
CapsLock & d:: RunCargoCommand("cargo doc --open", true)
CapsLock & b:: RunCargoCommand("cargo build")
CapsLock & m:: RunCargoCommand("cargo check")
CapsLock & x:: RunCargoCommand("cargo clean")
CapsLock & u:: RunCargoCommand("cargo update")
CapsLock & f:: RunCargoCommand("cargo clippy --fix --allow-dirty --allow-staged", true)
CapsLock & l:: RunCargoCommand("cargo fmt", true)


#If  ; End context

; === Rust-specific helpers ===

ShowRustHelp() {
    MsgBox, 64, RustRover Shortcuts,
(
RustRover AHK Shortcuts:

Build & Check:
  Caps + b -> cargo build
  Caps + m -> cargo check
  Caps + x -> cargo clean

Run & Test:
  Caps + r -> cargo run
  Caps + t -> cargo test

Lint & Format:
  Caps + c -> cargo clippy
  Caps + f -> cargo clippy --fix --allow-dirty --allow-staged
  Caps + l -> cargo fmt

Documentation:
  Caps + d -> cargo doc --open

Misc:
  Caps + u -> cargo update
  Caps + h -> show this help
)
}


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
        Send, %command%{Enter}
        
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
