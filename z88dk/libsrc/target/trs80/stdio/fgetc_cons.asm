;
;       TRS 80 C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
        call    $2b
	and	a
	jr	z,fgetc_cons

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

        ld      l,a
	ld	h,0
	ret

