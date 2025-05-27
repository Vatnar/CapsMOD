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
