
; char *fzx_string_partition_callee(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_string_partition_callee

EXTERN asm_fzx_string_partition

_fzx_string_partition_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   jp asm_fzx_string_partition
