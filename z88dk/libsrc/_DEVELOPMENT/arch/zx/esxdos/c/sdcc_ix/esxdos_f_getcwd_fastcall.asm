; int esxdos_f_getcwd(void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_getcwd_fastcall

EXTERN asm_esxdos_f_getcwd

_esxdos_f_getcwd_fastcall:

   ld a,__ESXDOS_DRIVE_CURRENT

   push ix
   push iy
   
   call asm_esxdos_f_getcwd
   
   pop iy
   pop ix
   ret
