; void tshr_scroll_up_pix(uchar prows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_scroll_up_pix_callee

EXTERN asm0_tshr_scroll_up_pix

tshr_scroll_up_pix_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm0_tshr_scroll_up_pix
