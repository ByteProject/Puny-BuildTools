;       CRT0 for the LAMBDA 8300 - SLOW MODE
;
;
; ----------------------------------------------------------------------------------------
;       Modified display handler to preserve IY
;	Note: a swap between IX and IY happens "on the fly" during assembly !
; ----------------------------------------------------------------------------------------
;
;       Stefano Bodrato August 2015
;
; - - - - - - -
;
;       $Id: lambda_altint.def,v 1.1 2015-08-04 06:48:23 stefano Exp $
;
; - - - - - - -


;--------------------------------------------------------------
;--------------------------------------------------------------

PUBLIC	altint_on
PUBLIC	altint_off
PUBLIC	zx_fast
PUBLIC	zx_slow

;----------------------------------------------------------------
;
; Enter in FAST mode 
;
;----------------------------------------------------------------
zx_fast:
	call restore81
	jp	$D5E		; FAST !

;--------------------------------------------------------------
;========
; Not HRG really, but switches the new interrupt handler with no sighs
;========

zx_slow:
altint_on:
		call    restore81
		call    $12A5	; SLOW
        ld      hl,L0281
HRG_Sync:
        push    hl
		ld      a,(16443)	; test CDFLAG
		and     128			; is in FAST mode ?
		jr      z,nosync
        ld      hl,$4034        ; FRAMES counter
        ld      a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp      (hl)            ; compare to new FRAMES
        jr      z,HRG_Sync1     ; exit after a change is detected
nosync:
        pop	iy              ; switch to new display handler
        ret

;--------------------------------------------------------------

altint_off:
		call	altint_on     ; restore registers and make sure we are in SLOW mode
        ld      hl,$1323      ; on the ZX81 this was $0281
        jr      HRG_Sync


;--------------------------------------------------------------
;--------------------------------------------------------------

        INCLUDE "target/lambda/classic/lambda_altint_core.asm"

