
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)
;
; Copy n chars from s2 to s1, return s1.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_string

PUBLIC asm_memcpy
PUBLIC asm0_memcpy, asm1_memcpy

asm_memcpy:

   ; enter : bc = size_t n
   ;         hl = void *s2 = src
   ;         de = void *s1 = dst
   ;
   ; exit  : hl = void *s1 = dst
   ;         de = ptr in s1 to one byte past last byte copied
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

IF (__CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_MEMCPY)

   ld a,b
   or a
   
   jr nz, big
   
   or c
   jr z, zero_n
   
   push de

   EXTERN l_ldi_loop_small
   call   l_ldi_loop_small

   pop hl
   
   or a
   ret

big:

   push de
   
   EXTERN l_ldi_loop_0
   call   l_ldi_loop_0
   
   pop hl
   
   or a
   ret

asm0_memcpy:

   push de
   
   call l_ldi_loop
   
   pop hl
   
   or a
   ret

ELSE

   ld a,b
   or c
   jr z, zero_n

asm0_memcpy:

   push de
IF __CPU_INTEL__ || __CPU_GBZ80__
loop:
 IF __CPU_GBZ80__
   ld a,(hl+)
 ELSE
   ld a,(hl)
   inc hl
 ENDIF
   ld (de),a
   inc de
   dec bc
   ld a,b
   or c
   jr nz,loop
ELSE
   ldir
ENDIF

   pop hl
   
   or a
   ret

ENDIF

asm1_memcpy:
zero_n:

   ld l,e
   ld h,d
   
   ret
