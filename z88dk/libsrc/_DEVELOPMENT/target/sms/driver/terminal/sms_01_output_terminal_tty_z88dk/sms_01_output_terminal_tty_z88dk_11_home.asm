
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_11_home

sms_01_output_terminal_tty_z88dk_11_home:

   ; move cursor to (0,0)
   
   xor a
   
   ld (ix+14),a                ; x = 0
   ld (ix+15),a                ; y = 0
   
   ret

