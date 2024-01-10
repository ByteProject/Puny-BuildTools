; uint in_Inkey(void)
; 02.2008 aralbrec

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey

   ld de,0
   ld bc,$fefe
   in a,(c)
   or $e1
   cp $ff
   jr nz, keyhitA

   ld e,5
   ld b,$fd
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,10
   ld b,$fb
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,15
   ld b,$f7
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,20
   ld b,$ef
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,25
   ld b,$df
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,30
   ld b,$bf
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,35
   ld b,$7f
   in a,(c)
   or $e0
   cp $ff
   ld c,a
   jr nz, keyhitB

.nokey

   ld hl,0
   scf
   ret

.keyhitA

   ld c,a

   ld a,b
   cpl
   or $01
   in a,($fe)
   or $e0
   cp $ff
   jr nz, nokey

.keyhitB

   ld b,0
   ld hl,rowtbl-$e0
   add hl,bc
   ld a,(hl)
   cp 5
   jr nc, nokey
   add a,e
   ld e,a

   ld hl,in_keytranstbl
   add hl,de

   ld a,$fe
   in a,($fe)
   and $01
   jr nz, noshift
   ld e,40
   add hl,de

.noshift

   ld l,(hl)
   ld h,0
   ret

	SECTION	rodata_clib
.rowtbl
   defb 255,255,255,255,255,255,255
   defb 255,255,255,255,255,255,255,255
   defb 4,255,255,255,255,255,255
   defb 255,3,255,255,255,2,255,1
   defb 0,255
