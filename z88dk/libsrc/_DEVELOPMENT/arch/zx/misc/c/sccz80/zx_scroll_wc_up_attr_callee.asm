; void zx_scroll_wc_up_callee(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_wc_up_attr_callee

EXTERN asm0_zx_scroll_wc_up_attr

zx_scroll_wc_up_attr_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af

   jp asm0_zx_scroll_wc_up_attr
