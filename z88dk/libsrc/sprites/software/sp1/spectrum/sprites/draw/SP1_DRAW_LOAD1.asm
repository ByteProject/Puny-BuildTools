
; DRAW LOAD SPRITE 1 BYTE DEFINITION ROTATED
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC SP1_DRAW_LOAD1
EXTERN SP1_DRAW_LOAD1NR
EXTERN SP1RETSPRDRAW, SP1V_ROTTBL, SP1V_PIXELBUFFER

; following data segment copied into struct sp1_cs

   ld hl,0
   ld ix,0
   call SP1_DRAW_LOAD1

; following draw code called by way of SP1UpdateNow
;
;  a = hor rot table
; bc = graphic disp
; hl = graphic def ptr
; ix = left graphic def ptr
;
; 51 + 138*4 - 6 + 10 = 607 cycles

.SP1_DRAW_LOAD1

   cp SP1V_ROTTBL/256
   jp z, SP1_DRAW_LOAD1NR

   add hl,bc
   add ix,bc
   ex de,hl
   ld h,a

   ;  h = shift table
   ; de = sprite def (graph only)
   ; ix = left sprite def

.SP1Load1Rotate

   ; 0

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+0)
   or (hl)
   ld (SP1V_PIXELBUFFER+0),a
   ld l,(ix+1)
   ld b,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+1),a

   ; 1

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+2)
   or (hl)
   ld (SP1V_PIXELBUFFER+2),a
   ld l,(ix+3)
   ld b,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+3),a

   ; 2

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+4)
   or (hl)
   ld (SP1V_PIXELBUFFER+4),a
   ld l,(ix+5)
   ld b,(hl)
   dec h
   ld a,(de)
   inc de
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+5),a

   ; 3

   ld a,(de)
   inc de
   ld l,a
   ld a,(hl)
   inc h
   ld l,(ix+6)
   or (hl)
   ld (SP1V_PIXELBUFFER+6),a
   ld l,(ix+7)
   ld b,(hl)
   dec h
   ld a,(de)
   ld l,a
   ld a,b
   or (hl)
   ld (SP1V_PIXELBUFFER+7),a

   jp SP1RETSPRDRAW
