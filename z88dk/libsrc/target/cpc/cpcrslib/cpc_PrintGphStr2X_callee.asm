;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStr2X(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStr2X_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStr2X_callee
        PUBLIC    _cpc_PrintGphStr2X_callee
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0
		

.cpc_PrintGphStr2X_callee
._cpc_PrintGphStr2X_callee


	pop bc
	pop hl		; address
	pop de		; text
	push bc	; ret addr
	ld a,1
    
 JP cpc_PrintGphStr0
