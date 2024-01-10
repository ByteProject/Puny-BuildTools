; Acorn constants shared by multiple Acorn executables; constants only relevant
; to the main Ozmoo executable are in constants.asm

osbyte = $fff4
osbyte_read_host = 0

romsel_copy = $f4
bbc_romsel = $fe30
electron_romsel = $fe05

ram_bank_count = $904
ram_bank_list = $905

; SFTODO: MOVE THIS?
!macro assert .b {
    !if .b = 0 {
        !error "assertion failed"
    }
}
