;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: fsetup1.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;



; Set up the registers for our operation
; Peeks the parameter from FA


IF FORts2068
		INCLUDE  "target/ts2068/def/ts2068fp.def"
ENDIF
IF FORzx
		INCLUDE  "target/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "target/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "target/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    fsetup1
		EXTERN	fa

.fsetup1

	ld	hl,fa+5

	ld	a,(hl)
	dec	hl
	ld	e,(hl)
	dec	hl
	ld	d,(hl)
	dec	hl
	ld	c,(hl)
	dec	hl
	ld	b,(hl)

	; load in the FP calculator stack	
	call	ZXFP_STK_STORE
        jp	ZXFP_BEGIN_CALC

