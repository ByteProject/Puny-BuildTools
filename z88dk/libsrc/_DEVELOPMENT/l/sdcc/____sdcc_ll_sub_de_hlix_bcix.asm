
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_de_hlix_bcix

EXTERN ____sdcc_ll_sub_de_bc_hl

____sdcc_ll_sub_de_hlix_bcix:

   push bc
   
IFDEF __SDCC_IX

   push ix
   pop bc

ELSE

   push iy
   pop bc
   
ENDIF
   
   add hl,bc
   ex (sp),hl
   
   add hl,bc
   
   pop bc
   
   jp ____sdcc_ll_sub_de_bc_hl
