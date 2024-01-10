;       CRT0 stub for the Camputers Lynx
;
;       Stefano Bodrato - 2014
;
;	$Id: lynx_crt0.asm,v 1.11 2016-07-15 21:03:25 dom Exp $
;


                MODULE  lynx_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

        	defc    crt0 = 1
                INCLUDE "zcc_opt.def"

		defc	CONSOLE_COLUMNS = 32
		defc	CONSOLE_ROWS = 32

; No matter what set up we have, main is always, always external to
; this file

        EXTERN    _main

;
; Some variables which are needed for both app and basic startup
;

        PUBLIC    cleanup
        PUBLIC    l_dcal




;--------
; Set an origin for the application (-zorg=) default to $7000
;--------

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $7000
        ENDIF

        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"
        org     CRT_ORG_CODE

start:

        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF

        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
    call    crt0_exit

	pop	bc
start1:
        ld      sp,0
		ret

		
l_dcal:
        jp      (hl)



        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"

