; void *tshc_pxy2aaddr(uchar x, uchar y)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_pxy2aaddr

EXTERN asm_tshc_pxy2aaddr

tshc_pxy2aaddr:

   pop af
   pop hl

   push hl
   push af

   jp asm_tshc_pxy2aaddr
