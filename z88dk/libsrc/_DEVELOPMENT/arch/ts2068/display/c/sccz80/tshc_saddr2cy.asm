; uchar tshc_saddr2cy(void *saddr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_saddr2cy

EXTERN zx_saddr2cy

defc tshc_saddr2cy = zx_saddr2cy
