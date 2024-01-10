; unsigned char glob_fat(const char *s, const char *pattern)

SECTION code_string

PUBLIC glob_fat_callee
PUBLIC l0_glob_fat_callee

EXTERN asm_glob_fat

glob_fat_callee:

   pop hl
   pop de
   ex (sp),hl

l0_glob_fat_callee:

   call asm_glob_fat
   
   ld hl,1
   ret nc                      ; return 1 for match
   
   dec l                       ; return 0 for no match
   ret
