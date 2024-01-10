;       CRT0 for the Mattel Aquarius
;
;       Stefano Bodrato Dec. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: aquarius_crt0.asm,v 1.21 2016-07-15 21:03:25 dom Exp $
;

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 14712
        ENDIF


	defc	TAR__clib_exit_stack_size = 32
	defc	TAR__register_sp = -1
	INCLUDE	"crt/classic/crt_rules.inc"

	org	CRT_ORG_CODE

start:
        ld      (start1+1),sp	;Save entry stack
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


        call    _main		;Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
    call    crt0_exit


start1:	ld	sp,0		;Restore stack to entry value
        ret

