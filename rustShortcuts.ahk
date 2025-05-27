; rustShortcuts.ahk

#If IsRustRoverActive()

; CapsLock + r: run `cargo run`
CapsLock & r::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo run{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + t: run `cargo test`
CapsLock & t::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo test{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + c: run `cargo clippy`
CapsLock & c::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo clippy{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + d: run `cargo doc --open`
CapsLock & d::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo doc --open{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + b: run `cargo build`
CapsLock & b::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo build{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + m: run `cargo check`
CapsLock & m::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo check{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + x: run `cargo clean`
CapsLock & x::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo clean{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

; CapsLock + u: run `cargo update`
CapsLock & u::
{
    IfWinExist, pwsh
    {
        WinActivate
        Sleep 100
        Send, cargo update{Enter}
    }
    else
    {
        MsgBox, Terminal window (pwsh) not found!
    }
}
return

#If  ; end context


; Helper function to detect if RustRover is active window
IsRustRoverActive() {
    WinGet, pid, PID, A
    Process, Exist, rustrover64.exe
    return pid == ErrorLevel
}
