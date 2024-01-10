
; ===============================================================
; Apr 2004
; ===============================================================
;
; void im2_prepend_generic_callback(uint8_t vector, void *callback)
;
; Insert the callback function into the front of the generic isr's
; callback array.  The generic isr is assumed to be installed on
; the vector given.
;
; ===============================================================

SECTION code_clib
SECTION code_im2

PUBLIC asm_im2_prepend_generic_callback

EXTERN __generic_isr_locate_callbacks

asm_im2_prepend_generic_callback:

   ; enter :  l = interrupt vector
   ;         de = void *callback
   ;
   ; uses  : af, bc, de, hl
   
   call __generic_isr_locate_callbacks
   
loop:

   ld a,(hl)
   ld (hl),e
   ld e,a
   inc hl
   ld a,(hl)
   ld (hl),d
   ld d,a
   
   or e
   ret z

   inc hl
   jr loop
