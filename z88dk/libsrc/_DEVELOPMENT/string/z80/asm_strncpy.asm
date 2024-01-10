
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)
;
; Copy at most n chars from string s2 to string s1, return s1.
; If strlen(s2) < n, s1 is padded with 0 bytes such that n
; chars are always written to s1.
;
; Note that s1 will not be 0 terminated if strlen(s2) >= n.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strncpy

asm_strncpy:

   ; enter : de = char *s1 = dst
   ;         hl = char *s2 = src
   ;         bc = size_t n
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = & s1[n] = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save dst

   ld a,b
   or c
   jr z, done
      
   ; first copy src to dst

   xor a

loop:
IF __CPU_GBZ80__ || __CPU_INTEL__
   ld a,(hl)
   ld (de),a
   inc hl
   inc de
   dec bc
   and a
   jr z,copied
   ld a,c
   or c
   jr z,done	;max characters
   jr loop
copied:
   ; Now pad it out with zero
zeroloop:
   xor a
   ld (de),a
   inc de
   dec bc
   ld a,b
   or c
   jr nz,zeroloop
ELSE
   cp (hl)
   ldi
   jp po, done                 ; reached max number of chars
   jr nz, loop
   
   ; now pad with zeroes
   
   ld l,e
   ld h,d
   dec hl
   ldir
ENDIF

done:

   pop hl
   ret
