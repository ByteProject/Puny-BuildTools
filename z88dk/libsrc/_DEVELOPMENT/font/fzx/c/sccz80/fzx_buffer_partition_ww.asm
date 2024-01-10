
; char *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_buffer_partition_ww

EXTERN asm_fzx_buffer_partition_ww

fzx_buffer_partition_ww:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   
   push hl
   push de
   push bc
   push hl
   push af
   
   jp asm_fzx_buffer_partition_ww
