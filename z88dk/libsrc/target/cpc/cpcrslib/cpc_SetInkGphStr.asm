;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
;
;       void __LIB__ cpc_SetInkGphStr(char *color, char *valor);
;
;       $Id: cpc_SetInkGphStr.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetInkGphStr
        PUBLIC    _cpc_SetInkGphStr
        EXTERN     cpc_SetInkGphStr_callee
        EXTERN    ASMDISP_CPC_SET_INKGPHSTR_CALLEE

.cpc_SetInkGphStr
._cpc_SetInkGphStr
		ld ix,2
		add ix,sp
		

		ld a,(ix+2) ;valor
		ld c,(ix+0)	;color

        jp cpc_SetInkGphStr_callee + ASMDISP_CPC_SET_INKGPHSTR_CALLEE
