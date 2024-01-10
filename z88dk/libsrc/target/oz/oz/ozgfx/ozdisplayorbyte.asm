;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	gfx functions
;
;	put byte into the display at offset
;
;	void ozdisplayorbyte(int offset, char byte);
;
;
; ------
; $Id: ozdisplayorbyte.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozdisplayorbyte
	PUBLIC	_ozdisplayorbyte
	
	EXTERN	ozactivepage


ozdisplayorbyte:
_ozdisplayorbyte:
        ld      c,3
        in      e,(c)
        inc     c
        in      d,(c)
        ld      hl,(ozactivepage)
        out     (c),h
        dec     c
        out     (c),l

        pop     hl  ;; return address

        exx
        ;pop     hl  ;; offset
        ;pop     bc  ;; value

        pop     bc  ;; offset
        pop     hl  ;; value

        ld      a,h
        add     a,0a0h
        ld      h,a
        ld      a,(hl)
        or     c
        ld      (hl),a
        push    bc
        push    hl
        exx

        out     (c),e
        inc     c
        out     (c),d

        jp      (hl)

