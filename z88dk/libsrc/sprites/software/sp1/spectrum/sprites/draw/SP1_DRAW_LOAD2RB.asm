
; DRAW LOAD SPRITE 2 BYTE DEFINITION ROTATED, ON RIGHT BORDER
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_LOAD2RB
EXTERN SP1_DRAW_LOAD2LB
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld de,0
   nop
   ld hl,0
   call SP1_DRAW_LOAD2RB

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; de = graphic def ptr
; hl = left graphic def ptr (mask,graph) pairs
;
; 46 + 39*8 - 6 + 10 = 362 cycles

.SP1_DRAW_LOAD2RB

   cp SP1V_ROTTBL/256
   jp z, SP1RETSPRDRAW

   add hl,bc
   ld d,a
   inc d

   ;  d = shift table
   ; hl = left sprite def (graph only)

.SP1Load2RBRotate

   jp SP1_DRAW_LOAD2LB + 7
