; void tshc_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc_pix_callee

EXTERN asm_tshc_cls_wc_pix

tshc_cls_wc_pix_callee:

   pop af
	pop hl
	pop ix
	push af

   jp asm_tshc_cls_wc_pix
