
; int creat_callee(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC _creat_callee, l0_creat_callee

EXTERN asm_creat

_creat_callee:

   pop af
   pop de
   pop bc
   push af

l0_creat_callee:

   push ix
   
   call asm_creat
   
   pop ix
   ret
