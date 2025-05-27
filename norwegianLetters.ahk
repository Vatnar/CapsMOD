; norwegianLetters.ahk

; CapsLock + ' (apostrophe) for æ / Æ
CapsLock & SC028::
    if GetKeyState("Shift", "P")
        Send, Æ
    else
        Send, æ
return

; CapsLock + ; for ø / Ø
CapsLock & `;::
    if GetKeyState("Shift", "P")
        Send, Ø
    else
        Send, ø
return

; CapsLock + [ for å / Å
CapsLock & [::
    if GetKeyState("Shift", "P")
        Send, Å
    else
        Send, å
return

; CapsLock + e for é / É
CapsLock & e::
    if GetKeyState("Shift", "P")
        Send, É
    else
        Send, é
return
