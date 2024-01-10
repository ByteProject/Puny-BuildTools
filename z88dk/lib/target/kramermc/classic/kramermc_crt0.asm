;
;	Startup for Kramer-MC
;
;	https://hc-ddr.hucki.net/wiki/doku.php/homecomputer/kramermc

	module kramermc_crt0

	INCLUDE	"target/kramermc/def/kramermc.def"

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code
        EXTERN    asm_im1_handler

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        defc    TAR__clib_exit_stack_size = 4
        defc    TAR__register_sp = -1
	defc	CRT_KEY_DEL = 8
	defc	__CPU_CLOCK = 1500000
        defc    CONSOLE_COLUMNS = 64
        defc    CONSOLE_ROWS = 16
        defc    GRAPHICS_CHAR_SET = 96
        defc    GRAPHICS_CHAR_UNSET = 32
        PUBLIC  GRAPHICS_CHAR_SET
        PUBLIC  GRAPHICS_CHAR_UNSET
        INCLUDE "crt/classic/crt_rules.inc"

        defc CRT_ORG_CODE = 0x1000

	org	  CRT_ORG_CODE

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	hl,0
	add	hl,sp
	ld	(exitsp),hl
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	ld	hl,0
	push	hl	;argv
	push	hl	;argc
	call	_main
	pop	bc
	pop	bc
cleanup:
	jp	RESTART

l_dcal: jp      (hl)            ;Used for function pointer calls



	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"
