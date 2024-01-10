; unsigned char glob(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_callee
PUBLIC l0_glob_callee

EXTERN asm_glob

glob_callee:

   pop hl
   pop de
   ex (sp),hl

l0_glob_callee:

   call asm_glob
   
   ld hl,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret
