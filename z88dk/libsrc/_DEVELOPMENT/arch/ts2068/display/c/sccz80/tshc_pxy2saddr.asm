; void *tshc_pxy2saddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_pxy2saddr

EXTERN zx_pxy2saddr

defc tshc_pxy2saddr = zx_pxy2saddr
