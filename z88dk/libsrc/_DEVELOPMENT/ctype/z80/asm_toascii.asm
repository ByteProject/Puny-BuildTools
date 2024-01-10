
SECTION code_clib
SECTION code_ctype

PUBLIC asm_toascii

asm_toascii:

   ; revert 8-bit char to 7-bit
   
   ; enter : a = 8-bit char
   ; exit  : a = 7-bit char
   ; uses  : a
IF __CPU_INTEL__
   and 127
ELSE 
   res 7,a                     ; let's not clobber flags
ENDIF
   ret
