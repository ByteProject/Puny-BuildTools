;       Z88 Small C+ Run Time Library 
;       Long functions
;

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_glonghlp

EXTERN l_long_load_mhl

; Fetch long dehl from *(hl)

l_glonghlp:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

   jp l_long_load_mhl
