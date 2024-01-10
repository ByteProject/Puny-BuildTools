
; int vscanf_callee(const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf_callee, l0_vscanf_callee

EXTERN asm_vscanf

_vscanf_callee:

   pop af
   pop de
   pop bc
   push af

l0_vscanf_callee:

   push ix
   
   call asm_vscanf
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf_callee

EXTERN _vscanf_unlocked_callee

defc _vscanf_callee = _vscanf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
