;
;       Z88 Small C+ Run Time Library 
;       Long support functions
;
;
;       aralbrec 01/2007
;       sped up some more
;
;       djm 25/2/99
;       Rewritten for size and speed (untested, but should be OK)
;
;       djm 22/3/99 Unsigned version

                SECTION   code_crt0_sccz80
PUBLIC    l_long_asr_u

; Shift primary (on stack) right by secondary, 
; We can only shift a maximum of 32 bits (or so), so the counter can
; go in c

.l_long_asr_u

        pop ix
        ld      a,l     ;temporary store for counter
        pop     hl
        pop     de
        and	31
        jr z, done
        
        ld b,a
.loop
	and	a
	rr	de
	rr	hl
        djnz loop
.done
        jp (ix)
     
