
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strnchr(const char *s, size_t n, int c)
;
; Return ptr to first occurrence of c in string s.
; Does not examine more than n chars.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strnchr

EXTERN error_zc

asm_strnchr:

   ; enter : hl = char *s
   ;          e = char c
   ;         bc = size_t n
   ;
   ; exit  : 
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to char c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, e, hl

   ld a,b                      ; if n == 0 not found
   or c
   jp z, error_zc


IF !__CPU_INTEL__ && !__CPU_GBZ80__
   ld a,e
ENDIF

loop:

IF __CPU_INTEL__ || __CPU_GBZ80__
 IF __CPU_GBZ80__
   ld a,(hl+)
 ELSE
   ld a,(hl)
   inc hl
 ENDIF
   ld e,a
   dec bc
   cp d 
   jr z,match
   and a		;Isn't current char NUL?
   jp z,error_zc
   ld a,b
   or c
   jr nz,loop
   jp error_zc
ELSE
   
   ld e,(hl)                   ; current char in s
   cpi
   jr z, match                 ; found char
   jp po, error_zc             ; n exceeded
   
   inc e                       ; is current char NUL?
   dec e
   jr nz, loop

   jp error_zc
ENDIF
match:

   dec hl
   ret
