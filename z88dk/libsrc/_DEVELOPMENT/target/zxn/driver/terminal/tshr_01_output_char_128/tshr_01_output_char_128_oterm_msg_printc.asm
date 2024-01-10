SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_128_oterm_msg_printc

EXTERN asm_tshr_cxy2saddr

tshr_01_output_char_128_oterm_msg_printc:

   ;   enter  :  c = ascii code
   ;             b = parameter (currently unused)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl

   ;  djm 3/3/2000
   ;  adapted aralbrec 12/2014

   ld a,c
   cp 32
   jr nc, code_ok
   
   ld c,'?'

code_ok:

   srl l                       ; column /= 2
   
   ld b,$0f
   jr c, __screen_address
   ld b,$f0

__screen_address:

   call asm_tshr_cxy2saddr
   ex de,hl                    ; de = screen address
   
   ld l,c
   ld h,0
   
   add hl,hl
   add hl,hl
   add hl,hl                   ; hl = 8 * ascii code
   
   ld a,b                      ; a = character set mask
   
   ld c,(ix+21)
   ld b,(ix+22)                ; bc = font address
   
   add hl,bc                   ; hl = & character definition
   
   ; print character pixels
   
   ;  a = character set mask
   ; de = screen address
   ; hl = & character definition
   
   ld b,8
   ld c,a
   
   ex de,hl
   
__print_loop:

   ld a,c
   cpl                         ; screen mask

   and (hl)
   ld (hl),a

   ld a,(de)
   and c

   or (hl)
   ld (hl),a

   inc de
   inc h

   djnz __print_loop
   
   ret
