;
;       Startup for Sorcerer Exidy
;
;       $Id: sorcerer_crt0.asm,v 1.15 2016-07-15 21:03:25 dom Exp $
;
; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma no-streams - No stdio disc files
;	#pragma no-fileio  - No fileio at all
;
;	These can cut down the size of the resultant executable

	MODULE  sorcerer_crt0

;-------------------------------------------------
; Include zcc_opt.def to find out some information
;-------------------------------------------------

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-----------------------
; Some scope definitions
;-----------------------

	EXTERN    _main		;main() is always external to crt0

	PUBLIC    cleanup		;jp'd to by exit()
	PUBLIC    l_dcal		;jp(hl)


;--------
; Set an origin for the application (-zorg=) default to 100h
;--------

        IF      !DEFINED_CRT_ORG_CODE
                defc    CRT_ORG_CODE  = 100h
        ENDIF

        defc    CONSOLE_COLUMNS = 64
        defc    CONSOLE_ROWS = 30

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 2106000
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:
	ld      (start1+1),sp	;Save entry stack
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld      (exitsp),sp

IF DEFINED_USING_amalloc
	INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF



        call    _main		;Call user code

cleanup:
	push	hl		;Save return value
    call    crt0_exit

	pop	bc		;Get exit() value into bc
start1:	ld      sp,0		;Pick up entry sp
        jp	$e003		; Monitor warm start

l_dcal:	jp	(hl)		;Used for call by function ptr



end:	defb	0		; null file name

        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE	"crt/classic/crt_section.asm"

	SECTION	code_crt_init
	ld	hl,$F080
	ld	(base_graphics),hl


