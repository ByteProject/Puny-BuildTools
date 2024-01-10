;       Stub for the Philips P2000 family
;
;       Stefano Bodrato - 7/4/2014
;
;       $Id: p2000_crt0.asm,v 1.12 2016-07-15 21:03:25 dom Exp $
;


                MODULE  p2000_crt0

;--------
; Include zcc_opt.def to find out some info
;--------
        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

; Now, getting to the real stuff now!

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = $6547
        ENDIF

        defc    CONSOLE_COLUMNS = 40
        defc    CONSOLE_ROWS = 25


	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 2500000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE

basic_block:

	defw line_20
	defw 10
	defb $8E	; REM
	defm " Z88DK - Small C+ P2000 "
	defb 0
line_20:
	defw basic_end
	defw 20
	defb $A3	; DEF
	defb $B5	; USR
	defb $CA	; '='
	defm "&H6580"
	defb ':'
	defb 'A'
	defb $CA	; '='
	defb $B5	; USR
	defm "(0)"
	defb 0

basic_end:

; BASIC is abt 50 bytes long

	defs $6580 - CRT_ORG_CODE - (basic_end - basic_block)


start:
        ld      (start1+1),sp	;Save entry stack
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
        ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF


        call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;

    call    crt0_exit


start1:
        ld      sp,0
        ret



l_dcal:	jp	(hl)		;Used for function pointer calls



;	defm  "Small C+ P2000"
;	defb	0

        INCLUDE "crt/classic/crt_runtime_selection.asm"

        INCLUDE "crt/classic/crt_section.asm"

        SECTION code_crt_init
        ld      hl,$5000
        ld      (base_graphics),hl


