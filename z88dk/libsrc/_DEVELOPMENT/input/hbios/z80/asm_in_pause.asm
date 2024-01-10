
; ===============================================================
; Oct 2015
; ===============================================================
; 
; uint16_t in_pause(uint16_t dur_ms)
;
; Busy wait until duration milliseconds have passed or until a
; key is pressed.  If dur_ms == 0, wait forever for a keypress.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_input

PUBLIC asm_in_pause

EXTERN asm_in_wait_key, asm_in_test_key, asm_cpu_delay_tstate

asm_in_pause:

   ; enter : hl = duration in milliseconds, 0 = forever
   ;
   ; exit  : keypress caused early exit
   ;
   ;            hl = time remaining in pause in milliseconds
   ;            carry set
   ;
   ;         time expired or dur_ms == 0
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses : potentially all (ix, iy saved for sdcc)
   
   ld a,h
   or l
   jp z, asm_in_wait_key

   ex de,hl
      
pause_loop:

   ; sample keyboard
   
   push de
   call asm_in_test_key
   pop de
   
   scf
   jr nz, exit                 ; if key is pressed

   ; wait for one millisecond
   
   ld hl,+(__CPU_CLOCK / 1000) - 95 - 500
   call asm_cpu_delay_tstate
   
   dec de
   
   ld a,d
   or e
   jr nz, pause_loop
   
   ; time is up

exit:

   ex de,hl                    ; hl = time remaining
   ret
