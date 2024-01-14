;       Generic Small C+ Floating point library
;       Converts integer in hl to fp number


                SECTION  code_fp
                PUBLIC    ufloat

                EXTERN    stkequ


;
;       convert the integer in hl to    (unsigned routine)
;       a floating point number in FA
;

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


		
.ufloat
IF TINYMODE

	ld	b,h
	ld	c,l
	
	call	ZXFP_STACK_BC 

ELSE

	ld	b,h
	ld	c,l

	push	de
	call	ZXFP_STACK_BC	; LSW
	pop		bc
	call	ZXFP_STACK_BC	; MSW
	ld		bc,256
	push	bc
	call	ZXFP_STACK_BC
	pop		bc
	call	ZXFP_STACK_BC

	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_MULTIPLY
	defb	ZXFP_MULTIPLY
IF FORlambda
	defb	ZXFP_ADDITION + 128
ELSE
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC
ENDIF


ENDIF

	jp	stkequ
