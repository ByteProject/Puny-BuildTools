
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_sdcc

PUBLIC __mulschar

__mulschar:

   ; 8-bit signed multiply
   ;
   ; enter : stack = multiplicand (byte), multiplicand (byte), ret
   ;
   ; exit  : hl = 16-bit product
   
   ld hl,3
   add hl,sp
   
   ld e,(hl)
   dec hl
   ld l,(hl)
   
IF __CLIB_OPT_IMATH <= 50

   EXTERN l_mulu_16_16x16
   
   ld a,l
   add a,a
   sbc a,a
   ld h,a                      ; hl = multiplicand
   
   ld a,e
   add a,a
   sbc a,a
   ld d,a                      ; de = multiplicand
   
   jp l_mulu_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_muls_8_8x8
   
   jp l_fast_muls_8_8x8

ENDIF
