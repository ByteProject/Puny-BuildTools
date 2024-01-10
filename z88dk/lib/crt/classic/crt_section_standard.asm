; Classic Memory map and section setup
;
; This layout suits all the classic machines. Memory placement is 
; affected by:
;
; CRT_MODEL: RAM/ROM configuration
; CRT_ORG_CODE: Where code starts executing from
; CRT_ORG_BSS:  Where uninitialised global variables are placed
; CRT_ORG_GRAPHICS: Where graphics routines + variables are stored (certain ports only)

;
; Contains the generic variables + features

;
; crt_model = 0		; everything in RAM
; crt_model = 1		; ROM model, data section copied
; crt_model = 2		; ROM model, data section compressed

		SECTION CODE

		SECTION code_crt_init
		SECTION code_crt_init_exit
		SECTION code_crt_exit
		SECTION code_crt_exit_exit
		SECTION code_driver
		SECTION rodata_driver		;Keep it in low memoey
		SECTION code_compiler
		SECTION code_clib
		SECTION code_crt0_sccz80
		SECTION code_l
		SECTION code_l_sdcc
		SECTION code_l_sccz80
		SECTION code_compress_zx7
		SECTION code_ctype
		SECTION code_esxdos
		SECTION code_fp
		SECTION code_fp_math48
		SECTION code_fp_math32
		SECTION code_fp_mbf32
		SECTION code_fp_mbf64
		SECTION code_math
		SECTION code_error
		SECTION code_stdlib
		SECTION code_string
		SECTION	code_adt_b_array
		SECTION	code_adt_b_vector
		SECTION	code_adt_ba_priority_queue
		SECTION	code_adt_ba_stack
		SECTION	code_adt_bv_priority_queue
		SECTION	code_adt_bv_stack
		SECTION	code_adt_p_forward_list
		SECTION	code_adt_p_forward_list_alt
		SECTION	code_adt_p_list
		SECTION	code_adt_p_queue
		SECTION	code_adt_p_stack
		SECTION	code_adt_w_array
		SECTION	code_adt_w_vector
		SECTION	code_adt_wa_priority_queue
		SECTION	code_adt_wa_stack
		SECTION	code_adt_wv_priority_queue
		SECTION	code_adt_wv_stack
		SECTION code_alloc_balloc
		SECTION code_alloc_obstack
		SECTION	code_arch
		SECTION	code_font
		SECTION	code_font_fzx
		SECTION	code_z80
IF !__crt_org_graphics
		SECTION code_graphics
ENDIF
		SECTION code_user
		SECTION rodata_fp
		SECTION rodata_fp_math32
		SECTION rodata_fp_mbf32
		SECTION rodata_fp_mbf64
		SECTION rodata_compiler
		SECTION rodata_clib
IF !__crt_org_graphics
		SECTION rodata_graphics
ENDIF
		SECTION rodata_user
		SECTION rodata_font
		SECTION rodata_font_fzx
		SECTION rodata_font_4x8
		SECTION rodata_font_8x8
		SECTION ROMABLE_END
IF !__crt_model
		SECTION DATA
		SECTION smc_clib
		SECTION smc_user
		SECTION data_clib
		SECTION data_stdlib
IF !__crt_org_graphics
		SECTION data_graphics
ENDIF
		SECTION data_crt
		SECTION data_compiler
		SECTION data_user
		SECTION data_alloc_balloc
		SECTION DATA_END
ENDIF

		SECTION BSS
IF __crt_org_bss
		org	__crt_org_bss
		defb 0   ; control name of bss binary
ENDIF
		SECTION bss_fp
		SECTION bss_fp_math32
		SECTION bss_fp_mbf32
		SECTION bss_fp_mbf64
		SECTION bss_error
		SECTION bss_crt
		SECTION bss_fardata
IF __crt_org_bss_fardata_start
		org	__crt_org_bss_fardata_start
ENDIF
		SECTION bss_compiler
IF __crt_org_bss_compiler_start
		org	__crt_org_bss_compiler_start
ENDIF
		SECTION bss_driver
		SECTION bss_clib
		SECTION bss_string
		SECTION bss_alloc_balloc
IF !__crt_org_graphics
		SECTION bss_graphics
ENDIF
		SECTION bss_user
IF __crt_model > 0
        	SECTION DATA
		org	-1
		defb	0		; control name of data binary
		SECTION smc_clib
		SECTION smc_fp
		SECTION smc_user
		SECTION data_clib
		SECTION data_crt
		SECTION data_stdlib
IF !__crt_org_graphics
		SECTION data_graphics
ENDIF
		SECTION data_compiler
		SECTION data_user
		SECTION data_alloc_balloc
		SECTION DATA_END
ENDIF
		SECTION BSS_END

IF __crt_org_graphics
		SECTION	HIMEM
		org	__crt_org_graphics
		SECTION code_graphics
		SECTION code_himem
		SECTION rodata_graphics
		SECTION rodata_himem
		SECTION data_himem
		SECTION data_graphics
		SECTION bss_graphics
		SECTION bss_himem
		SECTION HIMEM_END
ENDIF

IF CRT_APPEND_MMAP
		INCLUDE "./mmap.inc"
ENDIF
