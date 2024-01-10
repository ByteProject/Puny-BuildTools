
; uint sp1_AddColSpr(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC asm_sp1_AddColSpr

EXTERN _sp1_struct_cs_prototype
EXTERN asm_malloc, asm_free

asm_sp1_AddColSpr:

; Adds another column to an existing sprite.
;
; enter : ix = struct sp1_ss *
;          h = plane
;          l = type (index into table), bit 7 = 1 for occluding, bit 4 = 1 clear pixelbuffer
;         bc = graphic definition for column
;         de = address of sprite draw function
; uses  : af, bc, de, hl, bc', de', hl', iy
; exit  : carry flag for success and hl=1, else memory allocation failed and hl=0

   exx
   ld hl,0                    ; first try to get all the memory we need
   push hl                    ; push a 0 on stack to indicate end of allocated memory blocks
   ld b,(ix+3)                ; b = height
   
csalloc:

   push bc
   ld hl,24                   ; sizeof(struct sp1_cs)
   push hl
   call asm_malloc
   pop bc
   jp c, fail
   pop bc
   push hl                    ; stack allocated block
   djnz csalloc
   
   exx
   ex (sp),hl                 ; hl = new struct sp1_cs, stack: l = type h = plane
   push de                    ; save draw function

   ; have all necessary memory blocks on stack, hl = new struct sp1_cs
   
   ld de,_sp1_struct_cs_prototype
   ex de,hl                   ; hl = & struct sp1_cs prototype, de = & new struct sp1_cs
   push de
   pop iy                     ; iy = & struct sp1_cs
   push bc                    ; save bc = graphic def
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; copy prototype into new struct
   pop bc                     ; bc = graphic def
   
   ; have copied prototype struct sp1_cs, now fill in the rest of the details
   
   pop de                     ; de = draw function
   pop hl                     ; h = plane, l = type
   push bc                    ; stack graphic def
   ld c,e
   ld b,d                     ; bc = draw function
   
   ld (iy+4),h                ; store plane
   ld a,l
   and $90
   or $40
   ld (iy+5),a                ; store type

   push iy
   pop de
   ld hl,10
   add hl,de
   ex de,hl                   ; de = & struct sp1_cs.draw_code (& embedded code in struct sp1_cs)
   ld hl,-10
   add hl,bc                  ; hl = & draw function data
   ld bc,10                   ; length of draw code
   ldir                       ; copy draw code into struct sp1_cs

   ld a,ixl
   add a,8
   ld (iy+8),a                ; store & struct sp1_ss + 8 (& embedded code in struct sp1_ss)
   ld a,ixh
   adc a,0
   ld (iy+9),a
   
   pop bc
   ld (iy+11),c               ; store graphics ptr
   ld (iy+12),b

   ld h,(ix+15)               ; hl = first struct sp1_cs in sprite
   ld l,(ix+16)

loop:

   ; ix = struct sp1_ss, iy = next struct sp1_cs to be added to sprite, hl = & next struct sp1_cs in sprite being iterated
   
   ld bc,4
   
search:

   ld d,(hl)
   inc hl
   ld e,(hl)                  ; de = next struct sp1_cs within sprite in iteration
   add hl,bc                  ; hl = & struct sp1_cs.type
   bit 6,(hl)                 ; is this struct sp1_cs in last column?
   ex de,hl
   jr z, search
   
   ex de,hl                   ; hl = & struct sp1_cs.type in last column, de = next struct sp1_cs at start of next row
   res 6,(hl)                 ; no longer last in column
   ld bc,-5
   add hl,bc                  ; hl = & struct sp1_cs formerly in last column

   ld a,iyh                   ; store ptr to new struct sp1_cs as following this one
   ld (hl),a
   inc hl
   ld a,iyl
   ld (hl),a

   ld (iy+0),d                ; and store next struct sp1_cs at start of next row as following the new one
   ld (iy+1),e
   
   ld bc,10
   add hl,bc                  ; hl = & struct sp1_cs.def formerly in last column
   ld a,(hl)
   ld (iy+15),a               ; copy left struct's graphic pointer into new struct's left graphic ptr
   inc hl
   ld a,(hl)
   ld (iy+16),a
   
   pop hl                     ; get next allocated memory block

   ld a,h
   or l
   jr z, done
   
   push de                    ; save & first struct sp1_cs in next row of sprite
   push hl                    ; stack new memory block
   push iy
   pop de
   ex de,hl                   ; hl = & new struct sp1_cs just added, de = memory block for new struct sp1_cs
   ld bc,24                   ; sizeof(struct sp1_cs)
   ldir                       ; copy struct sp1_cs just added into new one
   
   ld e,(iy+11)
   ld d,(iy+12)               ; de = graphics ptr from last struct sp1_cs
   
   pop iy                     ; iy = new struct sp1_cs
   
   ld hl,8                    ; offset to next character in sprite graphic def
   bit 7,(ix+4)
   jr z, onebyte2
   ld l,16                    ; if 2-byte def, offset is 16 bytes
   
onebyte2:

   add hl,de
   ld (iy+11),l               ; store correct graphics ptr for this struct sp1_cs
   ld (iy+12),h

   pop hl                     ; hl = & first struct sp1_cs in next row of sprite
   jr loop

done:

   set 5,(iy+5)               ; indicate last struct sp1_cs added is in the last row of sprite
   inc (ix+2)                 ; increase width of sprite
   inc l
   scf                        ; indicate success
   ret

fail:

   pop bc
   
faillp:

   pop hl                     ; hl = allocated memory block
   
   ld a,h
   or l
   ret z                      ; if 0 done freeing, ret with nc for failure
   
   push hl
   call asm_free              ; free the block
   pop hl
   jr faillp
