; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_IterateUpdateRect_callee, l0_sp1_IterateUpdateRect_callee

EXTERN asm_sp1_IterateUpdateRect

_sp1_IterateUpdateRect_callee:

   pop af
   pop hl
   pop ix
   push af

l0_sp1_IterateUpdateRect_callee:

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   jp asm_sp1_IterateUpdateRect
