; void *tshc_cxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cxy2aaddr_callee

EXTERN asm_tshc_cxy2aaddr

tshc_cxy2aaddr_callee:

   pop hl
   ex (sp),hl

   jp asm_tshc_cxy2aaddr
