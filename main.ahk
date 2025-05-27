; main.ahk
#SingleInstance Force
#Persistent
#NoEnv
SetKeyDelay, -1, 0  ; Send instantly with no delay

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
Global Shortcuts:

Terminal Commands:
  Caps + q -> Run previous command (pwsh)
  Caps + p -> Open terminal in pwd of file explorer

Typing & Letters:
  Append Shift for capitalization
  Caps + æ -> æ
  Caps + ø -> ø
  Caps + å -> å
  Caps + e -> é

General:
  Caps + h -> Show this help
)
    }
}
return
