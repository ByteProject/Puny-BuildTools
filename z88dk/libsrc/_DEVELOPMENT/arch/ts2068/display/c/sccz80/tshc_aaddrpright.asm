; void *tshc_aaddrpright(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpright

EXTERN zx_saddrpright

defc tshc_aaddrpright = zx_saddrpright
