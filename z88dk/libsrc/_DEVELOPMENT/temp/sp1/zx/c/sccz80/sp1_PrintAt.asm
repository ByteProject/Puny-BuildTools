; void sp1_PrintAt(uchar row, uchar col, uchar colour, uint tile)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PrintAt

EXTERN asm_sp1_PrintAt

sp1_PrintAt:

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   
   jp asm_sp1_PrintAt
