; === Norwegian Letters ===

; CapsLock + ' → æ / Æ
CapsLock & SC028:: SendNorwegianLetter("æ", "Æ")

; CapsLock + ; → ø / Ø
CapsLock & `;:: SendNorwegianLetter("ø", "Ø")

; CapsLock + [ → å / Å
CapsLock & [:: SendNorwegianLetter("å", "Å")


SendNorwegianLetter(lower, upper) {
    if GetKeyState("Shift", "P")
        Send, %upper%
    else
        Send, %lower%
}
