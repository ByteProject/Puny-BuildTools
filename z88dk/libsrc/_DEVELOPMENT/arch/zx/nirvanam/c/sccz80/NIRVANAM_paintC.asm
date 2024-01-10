; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_paintC(unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_paintC

EXTERN asm_NIRVANAM_paintC

NIRVANAM_paintC:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld c,(hl)
   	inc hl
   	ld b,(hl)       ; attrs

   	jp asm_NIRVANAM_paintC
