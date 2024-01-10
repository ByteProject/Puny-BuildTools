
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC asm_asci1_interrupt
    
    EXTERN asci1RxBuffer, asci1RxCount, asci1RxIn
    EXTERN asci1TxBuffer, asci1TxCount, asci1TxOut

    asm_asci1_interrupt:
        push af
        push hl
                                    ; start doing the Rx stuff
        in0 a,(STAT1)               ; load the ASCI1 status register
        tst STAT1_RDRF              ; test whether we have received on ASCI1
        jr Z,ASCI1_TX_CHECK         ; if not, go check for bytes to transmit

ASCI1_RX_GET:
        in0 l,(RDR1)                ; move Rx byte from the ASCI1 RDR to l

        and STAT1_OVRN|STAT1_PE|STAT1_FE ; test whether we have error on ASCI1
        jr NZ,ASCI1_RX_ERROR        ; drop this byte, clear error, and get the next byte

        ld a,(asci1RxCount)         ; get the number of bytes in the Rx buffer      
        cp __ASCI1_RX_SIZE-1        ; check whether there is space in the buffer
        jr NC,ASCI1_RX_CHECK        ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l
        ld hl,(asci1RxIn)           ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the asci1RxIn target

        inc l                       ; move the Rx pointer low byte along
IF __ASCI1_RX_SIZE != 0x100
        ld a,__ASCI1_RX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci1RxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (asci1RxIn),hl           ; write where the next byte should be poked

        ld hl, asci1RxCount
        inc (hl)                    ; atomically increment Rx buffer count
        jr ASCI1_RX_CHECK           ; check for additional bytes

ASCI1_RX_ERROR:
        in0 a,(CNTLA1)              ; get the CNTRLA1 register
        and ~  CNTLA1_EFR           ; to clear the error flag, EFR, to 0 
        out0 (CNTLA1),a             ; and write it back

ASCI1_RX_CHECK:                     ; Z8S180 has 4 byte Rx H/W FIFO
        in0 a,(STAT1)               ; load the ASCI1 status register
        tst STAT1_RDRF              ; test whether we have received on ASCI1
        jr NZ,ASCI1_RX_GET          ; if still more bytes in H/W FIFO, get them

ASCI1_TX_CHECK:                     ; now start doing the Tx stuff
        and STAT1_TDRE              ; test whether we can transmit on ASCI1
        jr Z,ASCI1_TX_END           ; if not, then end

        ld a,(asci1TxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,ASCI1_TX_TIE1_CLEAR    ; if the count is zero, then disable the Tx Interrupt

        ld hl,(asci1TxOut)          ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out0 (TDR1),a               ; output the Tx byte to the ASCI1

        inc l                       ; move the Tx pointer low byte along
IF __ASCI1_TX_SIZE != 0x100
        ld a,__ASCI1_TX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci1TxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (asci1TxOut),hl          ; write where the next byte should be popped

        ld hl,asci1TxCount
        dec (hl)                    ; atomically decrement current Tx count
        jr NZ,ASCI1_TX_END          ; if we've more Tx bytes to send, we're done for now

ASCI1_TX_TIE1_CLEAR:
        in0 a,(STAT1)               ; get the ASCI1 status register
        and ~STAT1_TIE              ; mask out (disable) the Tx Interrupt
        out0 (STAT1),a              ; set the ASCI1 status register

ASCI1_TX_END:
        pop hl
        pop af
        ei
        ret

    EXTERN asm_asci1_need
    defc NEED = asm_asci1_need
