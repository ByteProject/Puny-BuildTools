; void *tshc_cxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cxy2saddr_callee

EXTERN zx_cxy2saddr_callee

defc tshc_cxy2saddr_callee = zx_cxy2saddr_callee
