; void sp1_PutTiles(struct sp1_Rect *r, struct sp1_tp *src)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PutTiles_callee, l0_sp1_PutTiles_callee

EXTERN asm_sp1_PutTiles

_sp1_PutTiles_callee:

   pop af
   pop hl
   pop de
   push af

l0_sp1_PutTiles_callee:

   push de

   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)

   pop hl
   
   jp asm_sp1_PutTiles
