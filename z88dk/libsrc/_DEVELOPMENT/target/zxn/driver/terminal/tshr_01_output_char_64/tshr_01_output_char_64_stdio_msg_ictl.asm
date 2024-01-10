SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_64_stdio_msg_ictl
PUBLIC tshr_01_output_char_64_stdio_msg_ictl_0

EXTERN asm_vioctl_driver, error_einval_zc, l_offset_ix_de
EXTERN console_01_output_char_stdio_msg_ictl_0

tshr_01_output_char_64_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OTERM_FONT       = $0802
   ;
   ; in addition to flags managed by stdio
   ; and messages understood by base class
   ;
   ; enter : de = request
   ;         bc = first parameter
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl
   
   ; flag bits managed by stdio?
   
   ld a,h
   or l
   jp z, asm_vioctl_driver     ; accept all changes to stdio flags
   
   ; check that message is specifically for an output terminal
   
   ld a,e
   and $07
   cp $02                      ; output terminal messages are type $02
   jp nz, error_einval_zc
   
   ; interpret ioctl message

tshr_01_output_char_64_stdio_msg_ictl_0:

   ld a,d

   cp $08
   jr z, _ioctl_font
   
   sub $10
   jp c, console_01_output_char_stdio_msg_ictl_0
   
   jp error_einval_zc

_ioctl_font:

   ; bc = first parameter (font address)
   ; hl = void *arg
   
   ld hl,21
   call l_offset_ix_de
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old font address

   ld a,b
   and c
   inc a
   jr z, _ioctl_font_ret       ; if font == -1

   ld (hl),b
   dec hl
   ld (hl),c

_ioctl_font_ret:

   ex de,hl                    ; hl = old font address
   ret
