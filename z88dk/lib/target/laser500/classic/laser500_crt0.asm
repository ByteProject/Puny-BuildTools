;
;	Startup for V-Tech VZ-350/500/700?
;

	module	vz700_crt0 


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

	; 2 columns on left and 2 column on right are lost
	defc	CONSOLE_COLUMNS = 40
	defc	CONSOLE_ROWS = 24


        defc    TAR__no_ansifont = 1
	defc	CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 3694700

IF startup = 2
	INCLUDE	"target/laser500/classic/rom.asm"
ELSE
	INCLUDE	"target/laser500/def/maths_mbf.def"
	INCLUDE	"target/laser500/classic/ram.asm"
ENDIF

   ; The extra key rows aren't implemented by Mame, so disable
   ; scanning of them by default
   PUBLIC __CLIB_LASER500_SCAN_EXTRA_ROWS
   IFDEF CLIB_LASER500_SCAN_EXTRA_ROWS
     defc __CLIB_LASER500_SCAN_EXTRA_ROWS = CLIB_LASER500_SCAN_EXTRA_ROWS
   ELSE
     defc __CLIB_LASER500_SCAN_EXTRA_ROWS = 0
   ENDIF

	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"

