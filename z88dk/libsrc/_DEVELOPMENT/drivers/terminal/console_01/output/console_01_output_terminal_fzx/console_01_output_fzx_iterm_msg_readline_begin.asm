
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_readline_begin

EXTERN OTERM_MSG_FZX_GET_XOR_DRAW

EXTERN l_offset_ix_de, l_jpix
EXTERN console_01_output_char_iterm_msg_readline_begin

console_01_output_fzx_iterm_msg_readline_begin:

   ; input terminal is starting a new edit line
   ; can use: af, bc, de, hl, ix
   
   ld a,OTERM_MSG_FZX_GET_XOR_DRAW
   call l_jpix                 ; bc = & fzx xor draw function
   
   ; save fzx variables during editing
   
   ld hl,23
   call l_offset_ix_de
   
   ex de,hl                    ; de = & FDSTRUCT.temp_fzx_draw_mode
   
   ld hl,8
   add hl,de                   ; hl = & FDSTRUCT.fzx_draw
   
   ld a,(hl)                   ; save current fzx_draw_mode
   ld (de),a                   ; set new draw mode = __fzx_draw_xor
   ld (hl),c
   inc de
   inc hl
   ld a,(hl)
   ld (de),a
   ld (hl),b
   inc de
   inc hl
   
   inc hl
   inc hl
   
   ldi                         ; edit line x coord = current x coord
   ldi
   
   ldi                         ; edit line y coord = current y coord
   ldi
   
   ld a,(ix+49)
   ld (de),a                   ; save current space_expand
   
   ld (ix+49),0                ; no space expand during editing
   
   jp console_01_output_char_iterm_msg_readline_begin
