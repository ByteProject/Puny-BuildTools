; unsigned int zxn_addr_in_mmu(unsigned char mmu, unsigned int addr)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_addr_in_mmu_callee

EXTERN asm_zxn_addr_in_mmu

zxn_addr_in_mmu_callee:

   pop de
   pop hl
   dec sp
   pop af
   push de

   jp asm_zxn_addr_in_mmu
