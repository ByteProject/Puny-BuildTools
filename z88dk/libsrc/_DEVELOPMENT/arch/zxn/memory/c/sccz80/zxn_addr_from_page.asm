; uint32_t zxn_addr_from_page(uint8_t page)

SECTION code_clib
SECTION code_arch

PUBLIC zxn_addr_from_page

EXTERN asm_zxn_addr_from_page

defc zxn_addr_from_page = asm_zxn_addr_from_page
