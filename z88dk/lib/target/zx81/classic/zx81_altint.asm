;       CRT0 for the ZX81 - SLOW MODE
;
;
; ----------------------------------------------------------------------------------------
;       Modified display handler to preserve IY
;	Note: a swap between IX and IY happens "on the fly" during assembly !
; ----------------------------------------------------------------------------------------
;
;       Stefano Bodrato Sept. 2007
;       Sync fixed by Siegfried Engel - Dec. 2007
;
; - - - - - - -
;
;       $Id: zx81_altint.def,v 1.18 2015-01-23 07:30:50 stefano Exp $
;
; - - - - - - -


;--------------------------------------------------------------
;--------------------------------------------------------------

PUBLIC	altint_on
PUBLIC	_altint_on
PUBLIC	altint_off
PUBLIC	_altint_off
PUBLIC	zx_fast
PUBLIC	_zx_fast
PUBLIC	zx_slow
PUBLIC	_zx_slow

;----------------------------------------------------------------
;
; Enter in FAST mode 
;
;----------------------------------------------------------------
zx_fast:
_zx_fast:
	call restore81
	jp	$F23		; FAST !

;--------------------------------------------------------------
;========
; Not HRG really, but switches the new interrupt handler with no sighs
;========

zx_slow:
_zx_slow:
altint_on:
_altint_on:
		call    restore81
		call    $F2B	; SLOW
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
_altint_off:
		call	altint_on     ; restore registers and make sure we are in SLOW mode
        ld      hl,$281
        jr      HRG_Sync


;--------------------------------------------------------------
;--------------------------------------------------------------

        INCLUDE "target/zx81/classic/zx81_altint_core.asm"

