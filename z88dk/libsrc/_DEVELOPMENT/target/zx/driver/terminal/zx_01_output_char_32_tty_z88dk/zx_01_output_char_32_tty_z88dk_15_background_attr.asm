
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_15_background_attr

zx_01_output_char_32_tty_z88dk_15_background_attr:

   ; change background colour
   
   ; de = parameters *
   
   ld a,(de)
   ld (ix+25),a
   
   ret
