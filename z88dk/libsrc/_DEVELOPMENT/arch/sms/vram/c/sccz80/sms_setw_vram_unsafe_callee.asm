; void sms_setw_vram_unsafe(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_setw_vram_unsafe_callee

EXTERN asm_sms_setw_vram_unsafe

sms_setw_vram_unsafe_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_sms_setw_vram_unsafe
