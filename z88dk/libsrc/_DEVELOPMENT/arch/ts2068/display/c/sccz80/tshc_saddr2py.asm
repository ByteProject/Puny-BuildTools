; uchar tshc_saddr2py(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddr2py

EXTERN zx_saddr2py

defc tshc_saddr2py = zx_saddr2py
