
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strspn(const char *s1, const char *s2)
;
; Return length of prefix of s1 containing chars from s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strspn

EXTERN asm_strchr

asm_strspn:

   ; enter : de = char *s2 = prefix chars
   ;         hl = char *s1 = string
   ;
   ; exit  : hl = max prefix length
   ;         bc = char *s1 = string
   ;         de = char *s2 = prefix chars
   ;
   ;         z flag set if prefix length == 0
   ;         carry set if all of s1 contains chars only from s2
   ;
   ; uses  : af, bc, hl

   push hl                     ; save string
   
loop:

   ld a,(hl)
   or a
   jr z, end_string
     
   ; see if this char from string is in prefix
   
   push hl                     ; save current string
   
   ld c,a                      ; c = char
   ld l,e
   ld h,d                      ; hl = prefix
   call asm_strchr             ; is c in prefix?
   
   pop hl                      ; current string

   jr c, done                  ; char not found
   
   inc hl
   jr loop

end_string:

   pop bc
IF __CPU_INTEL__ | __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELSE
   sbc hl,bc
ENDIF
   
   scf
   ret

done:
   
   pop bc
   
IF __CPU_INTEL__ | __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELSE
   or  a
   sbc hl,bc
ENDIF
   ret
