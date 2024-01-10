
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_d

EXTERN __stdio_printf_number_tail_int

__stdio_printf_d:

   ; %d, %i converter called from vfprintf()
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
   jp __stdio_printf_number_tail_int
