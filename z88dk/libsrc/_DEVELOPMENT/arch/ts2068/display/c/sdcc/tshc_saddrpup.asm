; void *tshc_saddrpup(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_saddrpup

EXTERN _zx_saddrpup

defc _tshc_saddrpup = _zx_saddrpup
