; void dostm_from_tm(struct dos_tm *,struct tm *)

SECTION code_time

PUBLIC dostm_from_tm

EXTERN asm_dostm_from_tm

dostm_from_tm:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dostm_from_tm
