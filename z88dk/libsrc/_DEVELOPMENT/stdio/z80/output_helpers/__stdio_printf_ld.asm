
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_ld

EXTERN __stdio_printf_number_tail_long

__stdio_printf_ld:

   ; %ld, %li converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ld bc,10                    ; base 10 conversion
   jp __stdio_printf_number_tail_long
