; void tshc_cls_pix(unsigned char pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_pix

EXTERN asm_tshc_cls_pix

defc tshc_cls_pix = asm_tshc_cls_pix
