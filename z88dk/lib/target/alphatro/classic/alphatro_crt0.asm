;       Triumph Adler Alphatronic PC crt0
;


        MODULE  alphatro_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

	defc	CRT_ORG_CODE = 0xa000
	defc	CRT_ORG_BSS = 0x6000

	defc	CONSOLE_ROWS = 24
	defc	CONSOLE_COLUMNS = 40

	defc	CRT_KEY_DEL = 12

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000 
        INCLUDE "crt/classic/crt_rules.inc"

        org     CRT_ORG_CODE
	jp	start

start:

        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"

        ld      (start1+1),sp   ; Save entry stack
	call	crt0_init_bss
        ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


        call    _main           ; Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl				; return code
        call    crt0_exit

cleanup_exit:

        pop     bc				; return code (still not sure it is teh right one !)

start1: ld      sp,0            ;Restore stack to entry value
endloop:
	jr	endloop


l_dcal: jp      (hl)            ;Used for function pointer calls



        INCLUDE "crt/classic/crt_runtime_selection.asm"

        defc    __crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
        INCLUDE "crt/classic/crt_section.asm"
