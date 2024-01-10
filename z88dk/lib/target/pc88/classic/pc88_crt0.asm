;       NEC PC-8801 stub
;
;       Stefano Bodrato - 2018
;
;	$Id: pc88_crt0.asm $
;

; 	There are a couple of #pragma commands which affect
;	this file:
;
;	#pragma output nostreams      - No stdio disc files
;	#pragma output nofileio       - No fileio at all, use in conjunction to "-lndos"
;	#pragma output noprotectmsdos - strip the MS-DOS protection header
;	#pragma output noredir        - do not insert the file redirection option while parsing the
;	                                command line arguments (useless if "nostreams" is set)
;
;	These can cut down the size of the resultant executable

                MODULE  pc88_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

		defc    crt0 = 1
                INCLUDE "zcc_opt.def"


	EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal
		
        PUBLIC    pc88bios

;--------
; Some scope definitions
;--------



; PC8801 platform specific stuff
;


; Now, getting to the real stuff now!

IF (!DEFINED_startup || (startup=1))
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE  = $8A00
        ENDIF
ELSE
        IFNDEF CRT_ORG_CODE
                defc CRT_ORG_CODE = $100   ; CP/M, IDOS, etc..
        ENDIF
ENDIF
	defc	CONSOLE_COLUMNS = 80
	defc    CONSOLE_ROWS = 20
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 4000000
        INCLUDE "crt/classic/crt_rules.inc"

	org CRT_ORG_CODE

;----------------------
; Execution starts here
;----------------------
start:

IF (!DEFINED_startup || (startup=1))
		ld	a,$FF				; back to main ROM
		out ($71),a				; bank switching
		
		
		ld	hl,($f302)
		ld	(timer_retaddr+1),hl
		
		ld	hl,pc88_timer
		ld ($f302),hl			; JP location for timer interrupt
		
ENDIF

        ld      (start1+1),sp
		
		; Last minute hack to keep the stack in a safe place and permit the hirez graphics to page
		; the GVRAM banks in and out
		ld	sp,$BFFF
		
	; Increase to cover ROM banking (useless at the moment, we're wasting 18 bytes!!)
	defc	__clib_exit_stack_size_t  = __clib_exit_stack_size + 18
	UNDEFINE __clib_exit_stack_size
	defc	__clib_exit_stack_size = __clib_exit_stack_size_t
	
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

	ld	a,(defltdsk)
	ld	($EC85),a
	
IF (startup=2)
;

ELSE

;** If NOT IDOS mode, just get rid of BASIC screen behaviour **
	;call ERAFNK	; Hide function key strings
	call    _main
ENDIF
	;call TOTEXT ;- force text mode on exit
;**
	
cleanup:
;
;       Deallocate memory which has been allocated here!
;

        call    crt0_exit


start1:
        ld      sp,0
		
		ld		a,$FF		; restore Main ROM
		out     ($71),a
		
		ld      hl,(timer_retaddr+1)	; restore interrupt pointers
		ld      ($f302),hl

		ld	a,($EC85)
		ld	(defltdsk),a

        ret

l_dcal:
        jp      (hl)



; Timer interrupt handler extension, usual jiffy driven interrupt (1/60 sec.)

pc88_timer:
		push hl
		push af
		
		ld		a,1			; set interrupt levels to disable also the "VRTC interrupt"
		out     ($E4),a
		
		ld	hl,(FRAMES)
		inc	hl
		ld	(FRAMES),hl
		ld	a,h
		or	l
		jr	nz,skip_msw
		ld	hl,(FRAMES+2)
		inc	hl
		ld	(FRAMES+2),hl
skip_msw:

		pop	af
		pop	hl

timer_retaddr:
		jp	0


; ROM interposer. This could be, sooner or later, moved to a convenient position in RAM
; (e.g.  just before $C000) to be able to bounce between different RAM/ROM pages
pc88bios:
	push	af
	ld		a,$FF		; MAIN ROM
	out     ($71),a
	pop		af
	jp	(ix)
	


	INCLUDE "crt/classic/crt_runtime_selection.asm"
	INCLUDE "crt/classic/crt_section.asm"

; ---------------------
; PC8801 specific stuff
; ---------------------


	SECTION		bss_crt


	PUBLIC	FRAMES
	PUBLIC	brksave
	PUBLIC	defltdsk

FRAMES:
		defw	0
		defw	0

brksave:	defb	1		; Keeping the BREAK enable flag, used by pc88_break, etc..



; This last part at the moment is useless, but doesn't harm

defltdsk:       defb    0	; Default disc


IF (startup=2)
IF !DEFINED_nofileio
	PUBLIC	__fcb
__fcb:		defs	420,0	;file control block (10 files) (MAXFILE)
ENDIF
ENDIF

        SECTION rodata_clib
IF (startup=2)
IF !DEFINED_noredir
IF CRT_ENABLE_STDIO = 1
redir_fopen_flag:	defb	'w',0
redir_fopen_flagr:	defb	'r',0
ENDIF
ENDIF
ENDIF 
