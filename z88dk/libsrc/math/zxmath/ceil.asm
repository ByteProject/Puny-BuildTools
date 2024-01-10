;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ceil.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double ceil(double)  
;Number in FA..
;
;This is implemented as  -(floor(-x))


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
                PUBLIC    ceil

                EXTERN	fsetup1
                EXTERN	stkequ

.ceil
        call    fsetup1
	defb	ZXFP_NEGATE
	defb	ZXFP_INT
IF FORlambda
	defb	ZXFP_NEGATE + 128
ELSE
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
