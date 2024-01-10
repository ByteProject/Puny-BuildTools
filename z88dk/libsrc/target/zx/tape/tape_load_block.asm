; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block
PUBLIC _tape_load_block

EXTERN tape_load_block_callee
EXTERN ASMDISP_TAPE_LOAD_BLOCK_CALLEE

.tape_load_block
._tape_load_block

   pop hl
   pop bc
   ld a,c
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp tape_load_block_callee + ASMDISP_TAPE_LOAD_BLOCK_CALLEE
