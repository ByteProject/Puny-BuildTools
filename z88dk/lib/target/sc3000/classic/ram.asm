;       CRT0 (RAM) stub for the SEGA SC-3000
;
;       Stefano Bodrato - Jun 2010
;

	IF      !CRT_ORG_CODE
		defc    CRT_ORG_CODE  = $9817
	ENDIF
        defc    TAR__register_sp = -1

        defc    TAR__clib_exit_stack_size = 32
	defc	__CPU_CLOCK = 3580000
	INCLUDE	"crt/classic/crt_rules.inc"
        org     CRT_ORG_CODE

;  ******************** ********************
;           B A S I C    M O D E
;  ******************** ********************

start:
        ld      hl,0
        add     hl,sp
        ld      (start1+1),sp
	INCLUDE	"crt/classic/crt_init_sp.asm"
	INCLUDE	"crt/classic/crt_init_atexit.asm"

;  ******************** ********************
;    BACK TO COMMON CODE FOR ROM AND BASIC
;  ******************** ********************

	call	crt0_init_bss
	ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
    call    crt0_exit


start1:
        ld      sp,0
	ret
