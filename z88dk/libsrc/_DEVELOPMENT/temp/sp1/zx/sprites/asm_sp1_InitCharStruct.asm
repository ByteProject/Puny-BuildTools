; void sp1_InitCharStruct(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_InitCharStruct

EXTERN _sp1_struct_cs_prototype
EXTERN SP1V_ROTTBL

asm_sp1_InitCharStruct:

; enter : a' = plane
;          a = type
;         hl = struct sp1_cs *
;         de = address of sprite draw function
;         bc = graphic
; uses  : af, bc, de, hl, af', bc', de', hl'

   push bc                     ; save graphic
   push de                     ; save draw function

   ex de,hl                    ; de = struct sp1_cs *
   ld hl,_sp1_struct_cs_prototype
   ld bc,24
   ldir                        ; copy prototype struct sp1_cs into sp1_cs

   ld hl,-5
   add hl,de                   ; hl = & sp1_cs.draw + 1b
   pop de
   dec de                      ; de = & last byte of draw function data
   ex de,hl
   
   ldd                         ; copy draw function data into struct sp1_cs
   ldd
   ldd
   dec hl
   dec hl
   dec de
   dec de
   ldd
   ldd
   pop bc                      ; bc = graphic
   ex de,hl
   ld (hl),b
   dec hl
   ld (hl),c
   dec hl
   dec de
   dec de
   ex de,hl
   ldd
   
   ex de,hl                    ; hl = & sp1_cs.ss_draw + 1b
   ld (hl),sp1_ss_embedded / 256
   dec hl
   ld (hl),sp1_ss_embedded % 256
   
   dec hl
   dec hl
   dec hl                      ; hl = & sp1_cs.type
   ld (hl),a                   ; store type
   dec hl
   ex af,af
   ld (hl),a                   ; store plane

   ret   

sp1_ss_embedded:

   ld a,SP1V_ROTTBL/256 + 8    ; use rotation of four pixels if user selects a non-NR draw function
   ld bc,0
   ex de,hl
   jp (hl)
