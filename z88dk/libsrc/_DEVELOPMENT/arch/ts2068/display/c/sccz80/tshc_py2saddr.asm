; void *tshc_py2saddr(uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_py2saddr

EXTERN zx_py2saddr

defc tshc_py2saddr = zx_py2saddr
