SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_and_src_debc_hlix_dst_debc

____sdcc_4_and_src_debc_hlix_dst_debc:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex de,hl
   ex (sp),hl
   
   add hl,de
   
   pop de
   
   ld a,(hl)
   and c
   ld c,a
   inc hl
   ld a,(hl)
   and b
   ld b,a
   inc hl
   ld a,(hl)
   and e
   ld e,a
   inc hl
   ld a,(hl)
   and d
   ld d,a
   
   ret
