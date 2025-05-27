; rustShortcuts.ahk

#If IsRustRoverActive()

CapsLock & r:: RunCargoCommand("cargo run")
CapsLock & t:: RunCargoCommand("cargo test")
CapsLock & c:: RunCargoCommand("cargo clippy")
CapsLock & d:: RunCargoCommand("cargo doc --open")
CapsLock & b:: RunCargoCommand("cargo build")
CapsLock & m:: RunCargoCommand("cargo check")
CapsLock & x:: RunCargoCommand("cargo clean")
CapsLock & u:: RunCargoCommand("cargo update")
CapsLock & f:: RunCargoCommand("cargo clippy --fix --allow-dirty --allow-staged")
CapsLock & l:: RunCargoCommand("cargo fmt")

#If  ; End context

; === Rust-specific helpers ===

ShowRustHelp() {
    MsgBox, 64, RustRover Shortcuts,
(
RustRover AHK Shortcuts:

Caps + r -> cargo run
Caps + t -> cargo test
Caps + c -> cargo clippy
Caps + d -> cargo doc --open
Caps + b -> cargo build
Caps + m -> cargo check
Caps + x -> cargo clean
Caps + u -> cargo update
Caps + f -> cargo clippy --fix --allow-dirty --allow-staged
Caps + l -> cargo fmt
Caps + h -> show this help
)
}

RunCargoCommand(command) {
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

IsRustRoverActive() {
    WinGet, pid, PID, A
    Process, Exist, rustrover64.exe
    return pid == ErrorLevel
}
