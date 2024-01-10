; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memset_vram

EXTERN asm_sms_memset_vram

_sms_memset_vram:

   pop hl
   pop de
   dec sp
   pop af
   pop bc
   
   push bc
   push af
   inc sp
   push de
   push hl
   
   jp asm_sms_memset_vram
