; void tshc_cls_attr(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_attr

EXTERN asm_tshc_cls_attr

defc tshc_cls_attr = asm_tshc_cls_attr
