
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_0

_bfx_0:

   ; Shot_1
   
   defb 1 ;tone
   defw 20,50,2000,65486,128
   defb 0
