; unsigned char zx_tape_verify_block(void *dst, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC zx_tape_verify_block

EXTERN asm_zx_tape_verify_block

zx_tape_verify_block:

   pop af
   pop bc
   pop de
   pop ix
   
   push de
   push de
   push bc
   push af
   
   ld a,c
   jp asm_zx_tape_verify_block
