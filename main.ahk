; main.ahk

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
        MsgBox, 64, Global Shortcut Help,
(
Caps + q → Run previous command (pwsh)
Caps + h → Show this help
Caps + æ → å
Caps + ø → ø
Caps + å → æ
)
    }
}
return
