
; djm 28/2/2000

; void l_longjmp(jmp_buf *env, int val)

SECTION code_clib
SECTION code_setjmp

PUBLIC l_longjmp

l_longjmp:

   pop de
   pop bc
   pop hl

   ; bc = val
   ; hl = jmp_buf *
   
   ld a,b
   or c
   jr nz, val_ok
   
   inc c                       ; not allowed to return 0

val_ok:

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = sp
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = pc
   
   ex de,hl
   ld sp,hl
   
   push de                     ; push return address
   
   ld l,c
   ld h,b                      ; hl = val
   
   ret
