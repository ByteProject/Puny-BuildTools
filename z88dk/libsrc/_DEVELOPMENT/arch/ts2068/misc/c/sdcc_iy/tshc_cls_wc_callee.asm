; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_callee

EXTERN asm_tshc_cls_wc

_tshc_cls_wc_callee:

   pop hl
   pop ix
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_tshc_cls_wc
