; void tshc_scroll_up_pix(uchar prows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_up_pix_callee

EXTERN asm0_tshc_scroll_up_pix

tshc_scroll_up_pix_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm0_tshc_scroll_up_pix
