; void *tshc_aaddrpleft(void *aaddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_aaddrpleft_callee

EXTERN zx_saddrpleft_callee

defc tshc_aaddrpleft_callee = zx_saddrpleft_callee
