
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strcat(char * restrict s1, const char * restrict s2)
;
; Append string s2 to the end of string s1, return s1.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strcat

EXTERN __str_locate_nul

asm_strcat:
   
   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = ptr in s1 to terminating 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save dst

   ex de,hl
   call __str_locate_nul       ; a = 0
   ex de,hl
      
loop:                          ; append s2 to s1
IF __CPU_INTEL__ || __CPU_GBZ80__
  IF __CPU_GBZ80__
   ld a,(hl+)
  ELSE
   ld a,(hl)
   inc hl
  ENDIF
   ld (de),a
   inc de
   and a
   jr nz,loop
ELSE
   cp (hl)
   ldi
   jr nz, loop
ENDIF
   
   pop hl                      ; hl = dst
   
   dec de
   ret
