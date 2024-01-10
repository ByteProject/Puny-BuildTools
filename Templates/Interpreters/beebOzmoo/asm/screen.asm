; screen update routines

!ifndef ACORN { ; SF
init_screen_colours_invisible
	lda zcolours + BGCOL
	bpl + ; Always branch
init_screen_colours
    jsr s_init
	lda zcolours + FGCOL
!if BORDERCOL_FINAL = 1 {
	sta reg_bordercolour
}
+	jsr s_set_text_colour
    lda zcolours + BGCOL
    sta reg_backgroundcolour
!if BORDERCOL_FINAL = 0 {
	sta reg_bordercolour
} else {
	!if BORDERCOL_FINAL != 1 {
		lda zcolours + BORDERCOL_FINAL
		sta reg_bordercolour
	}
}
    lda zcolours + CURSORCOL
    sta current_cursor_colour
!ifdef Z5PLUS {
    ; store default colours in header
    lda #BGCOL ; blue
    sta story_start + header_default_bg_colour
    lda #FGCOL ; white
    sta story_start + header_default_fg_colour
}
    lda #147 ; clear screen
    jmp s_printchar
}

!ifdef Z4PLUS {
z_ins_erase_window
    ; erase_window window
    ldx z_operand_value_low_arr
;    jmp erase_window ; Not needed, since erase_window follows
}
	
erase_window
    ; x = 0: clear lower window
    ;     1: clear upper window
    ;    -1: clear screen and unsplit
    ;    -2: clear screen and keep split
    lda zp_screenrow
    pha
;    lda z_operand_value_low_arr
    cpx #0
    beq .window_0
    cpx #1
    beq .window_1
	lda #0
	sta current_window
    cpx #$ff ; clear screen, then; -1 unsplit, -2 keep as is
    bne .keep_split
	jsr clear_num_rows
    ldx #0 ; unsplit
    jsr split_window
.keep_split
!ifdef Z3 {
    lda #1
	bne .clear_from_a ; Always branch
} else {
    lda #0
	beq .clear_from_a ; Always branch
}
    ; SF: ENHANCEMENT: This could be rewritten to clear the whole area in one go
    ; using a text window, but since it would introduce a divergence from
    ; upstream with potential for bugs I'd want a decent performance improvement
    ; in a real game to make it worthwhile.
.window_0
    lda window_start_row + 1
.clear_from_a
    sta zp_screenrow
-   jsr s_erase_line
    inc zp_screenrow
    lda zp_screenrow
    +cmp_screen_height
    bne -
	jsr clear_num_rows
    ; set cursor to top left (or, if Z4, bottom left)
    pla
	ldx #0
	stx cursor_column + 1
!ifdef Z3 {
	inx
}
!ifdef Z5PLUS {
    lda window_start_row + 1
} else {
    +lda_screen_height_minus_1
}
	stx cursor_row + 1
    pha
    jmp .end_erase
    ; SF: ENHANCEMENT: As above.
.window_1
	lda window_start_row + 1
	cmp window_start_row + 2
	beq .end_erase
    lda window_start_row + 2
    sta zp_screenrow
-   jsr s_erase_line
    inc zp_screenrow
    lda zp_screenrow
	cmp window_start_row + 1
    bne -
.end_erase
!ifdef ACORN {
    lda #1
    sta s_cursors_inconsistent
}
    pla
    sta zp_screenrow
.return	
    rts

!ifdef Z4PLUS {
z_ins_erase_line
    ; erase_line value
    ; clear current line (where the cursor is)
	lda z_operand_value_low_arr
	cmp #1
	bne .return
    jmp s_erase_line_from_cursor

!ifdef Z5PLUS {
.pt_cursor = z_temp;  !byte 0,0
.pt_width = z_temp + 2 ; !byte 0
.pt_height = z_temp + 3; !byte 0
.pt_skip = z_temp + 4; !byte 0,0
.current_col = z_temp + 6; !byte 0

z_ins_print_table
    ; print_table zscii-text width [height = 1] [skip]
    ; ; defaults
    lda #1
    sta .pt_height
    lda #0
    sta .pt_skip
    sta .pt_skip + 1
	; Read args
    lda z_operand_value_low_arr + 1
	beq .print_table_done
    sta .pt_width
    ldy z_operand_count
    cpy #3
    bcc ++
    lda z_operand_value_low_arr + 2
	beq .print_table_done
    sta .pt_height
+   cpy #4
    bcc ++
    lda z_operand_value_low_arr + 3
    sta .pt_skip
    lda z_operand_value_high_arr + 3
    sta .pt_skip + 1
++	lda .pt_height
	cmp #1
	beq .print_table_oneline
; start printing multi-line table
    jsr printchar_flush
    jsr get_cursor ; x=row, y=column
    stx .pt_cursor
    sty .pt_cursor + 1
	lda z_operand_value_high_arr ; Start address
	ldx z_operand_value_low_arr
--	jsr set_z_address
    ldx .pt_cursor + 1
	stx .current_col
	ldy .pt_width
-	jsr read_next_byte
	ldx .current_col
    +cpx_screen_width
	bcs +
	jsr streams_print_output
+	inc .current_col
	dey
	bne -
	dec .pt_height
	beq .print_table_done
; Move cursor to start of next line to print
	inc .pt_cursor
	ldx .pt_cursor
	ldy .pt_cursor + 1
	jsr set_cursor
; Skip the number of bytes requested
	jsr get_z_address
	pha
	txa
	clc
	adc .pt_skip
	tax
	pla
	adc .pt_skip + 1
	bcc -- ; Always jump
.print_table_done	
	rts
.print_table_oneline
	lda z_operand_value_high_arr ; Start address
	ldx z_operand_value_low_arr
	jsr set_z_address
	ldy .pt_width
-	jsr read_next_byte
	jsr translate_zscii_to_petscii
	bcs + ; Illegal char
	jsr printchar_buffered
+	dey
	bne -
	rts
}

z_ins_buffer_mode 
	; buffer_mode flag
	; If buffer mode goes from 0 to 1, remember the start column
	; If buffer mode goes from 1 to 0, flush the buffer 
	
	lda z_operand_value_low_arr
	beq +
	lda #1
+	cmp is_buffered_window
	beq .buffer_mode_done
; Buffer mode changes
	sta is_buffered_window ; set lower window to buffered or unbuffered mode
	cmp #0
	bne start_buffering
	jsr printchar_flush
.buffer_mode_done
	rts

}

start_buffering
	jsr get_cursor
	sty first_buffered_column
	sty buffer_index
	ldy #0
	sty last_break_char_buffer_pos
	rts

+make_acorn_screen_hole
z_ins_split_window
    ; split_window lines
    ldx z_operand_value_low_arr
;    jmp split_window ; Not needed since split_window follows

split_window
    ; split if <x> > 0, unsplit if <x> = 0
    cpx #0
    bne .split_window
    ; unsplit
    ldx window_start_row + 2
    stx window_start_row + 1
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    jsr check_and_add_mode_7_colour_code
}
}
    rts
.split_window
	+cpx_max_lines
	bcc +
	+ldx_max_lines
+	txa
	clc
	adc window_start_row + 2
	sta window_start_row + 1
!ifdef Z3 {
	ldx #1
	jsr erase_window
}	
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    jsr check_and_add_mode_7_colour_code
}
}
	lda current_window
	beq .ensure_cursor_in_window
	; Window 1 was already selected => Reset cursor if outside window
	jsr get_cursor
	cpx window_start_row + 1
	bcs .reset_cursor
.do_nothing
	rts
.ensure_cursor_in_window
	jsr get_cursor
	cpx window_start_row + 1
	bcs .do_nothing
	ldx window_start_row + 1
	jmp set_cursor

z_ins_set_window
    ;  set_window window
    lda z_operand_value_low_arr
	bne select_upper_window
	; Selecting lower window
select_lower_window
	ldx current_window
	beq .do_nothing
	jsr save_cursor
	lda #0
    sta current_window
    ; this is the main text screen, restore cursor position
    jmp restore_cursor
select_upper_window
	; this is the status line window
    ; store cursor position so it can be restored later
    ; when set_window 0 is called
	ldx current_window
	bne .reset_cursor ; Upper window was already selected
    jsr save_cursor
	ldx #1
	stx current_window
.reset_cursor
!ifdef Z3 { ; Since Z3 has a separate statusline 
	ldx #1
} else {
	ldx #0
}
	ldy #0
	jmp set_cursor

!ifdef Z4PLUS {
z_ins_set_text_style
    lda z_operand_value_low_arr
    bne .t0
    ; roman
!ifndef ACORN {
    lda #146 ; reverse off
    jmp s_printchar
} else {
    ; A is zero
    sta s_reverse
    rts
}
.t0 cmp #1
    bne .do_nothing
!ifndef ACORN {
    lda #18 ; reverse on
    jmp s_printchar
} else {
    lda #$80
    sta s_reverse
    rts
}


+make_acorn_screen_hole
z_ins_get_cursor
    ; get_cursor array
    ldx z_operand_value_low_arr
    stx string_array
    lda z_operand_value_high_arr
    clc
    adc #>story_start
    sta string_array + 1
    lda #0
    ldy #0
    sta (string_array),y
    ldy #2
    sta (string_array),y
	ldx current_window
	beq + ; We are in lower window, jump to read last cursor pos in upper window
    jsr get_cursor ; x=row, y=column	
-	inx ; In Z-machine, cursor has position 1+
	iny ; In Z-machine, cursor has position 1+
    tya
    pha
    ldy #1
    txa ; row
    sta (string_array),y
    pla ; column
    ldy #3
    sta (string_array),y
.do_nothing_2
    rts
+	ldx cursor_row + 1
	ldy cursor_column + 1
	jmp -	


z_ins_set_cursor
    ; set_cursor line column
    ldy current_window
    beq .do_nothing_2
    ldx z_operand_value_low_arr ; line 1..
    dex ; line 0..
    ldy z_operand_value_low_arr + 1 ; column
    dey
    jmp set_cursor
}

clear_num_rows
    lda #0
    sta num_rows
    rts

+make_acorn_screen_hole
increase_num_rows
	lda current_window
	bne .increase_num_rows_done ; Upper window is never buffered
	inc num_rows
	lda is_buffered_window
	beq .increase_num_rows_done
	lda window_start_row
	sec
	sbc window_start_row + 1
	sbc #1
	cmp num_rows
	bcs .increase_num_rows_done
show_more_prompt
	; time to show [More]
	jsr clear_num_rows
!ifndef ACORN {
	lda $07e7 
	sta .more_text_char
	lda #128 + $2a ; screen code for reversed "*"
	sta $07e7
	; wait for ENTER
.printchar_pressanykey
!ifndef BENCHMARK {
--	ldx s_colour
	iny
	tya
	and #1
	beq +
	ldx $d021
+	stx $d800 + 999	
	ldx #40
---	lda $a2
-	cmp $a2
	beq -
	jsr getchar_and_maybe_toggle_darkmode
	cmp #0
	bne +
	dex
	bne ---
    beq -- ; Always branch
+
}
	lda .more_text_char
	sta $07e7
} else {
!ifndef BENCHMARK {
    ; We mimic the OS paged mode behaviour here: we flicker the keyboard LEDs
    ; and wait until SHIFT is pressed. It would be difficult (impossible using
    ; portable OS routines?) to display a "more" prompt in the bottom right
    ; character without causing a scroll. We could maybe define a text window
    ; covering that single character and repeatedly print (say) "X" and " " over
    ; and over again but that might look a bit ugly, although I haven't tried
    ; it.
    ; SF: ENHANCEMENT: Just possibly we could enable OS paged mode, define a
    ; single cell text window at the bottom right, print a single-character
    ; "more" prompt and let the OS block until SHIFT is pressed. I haven't tried
    ; this and it strikes me as a corner-ish case that may behave differently on
    ; different OS versions so would need to test carefully. To be honest it
    ; feels more Acorn-y to not display a "more" prompt character anyway, but
    ; maybe users will disagree and by noting possibilities to implement this I
    ; can try to convince myself I'm not adopting a sour grapes attitude. :-)
    ; SF: ENHANCEMENT: I'm not sure it's a good idea, but I *could* turn the
    ; cursor on and fiddle with the CRTC registers to give it a flashing block
    ; appearance at the bottom right position as a kind of "more" prompt.
    ; SFTODO: Should we also allow RETURN to scroll? And/or SPACE? And/or any
    ; key?
    ; SFTODO: Would it save code if we actually used OS page mode (without trying
    ; the tricks described above to generate a single character "more" prompt)
    ; instead of emulating it ourselves? *Probably* not given how short this code
    ; is, but maybe worth thinking about it.
-   lda #osbyte_reflect_keyboard_status
    jsr osbyte
    lda #osbyte_read_key
    ldx #$ff
    ldy #$ff
    jsr osbyte
    tya
    beq -
}
}
.increase_num_rows_done
    rts

!ifndef ACORN {
.more_text_char !byte 0
}

printchar_flush
    ; flush the printchar buffer
	ldx current_window
	stx z_temp + 11
	jsr select_lower_window
    lda s_reverse
    pha
    ldx first_buffered_column
-   cpx buffer_index
    bcs +
    lda print_buffer2,x
    sta s_reverse
    lda print_buffer,x
    jsr s_printchar
    inx
    bne -
+	pla
        sta s_reverse
        jsr start_buffering
	ldx z_temp + 11
	beq .increase_num_rows_done
	jsr save_cursor
	lda #1
	sta current_window
	; We have re-selected the upper window, restore cursor position
	jmp restore_cursor

+make_acorn_screen_hole
printchar_buffered
    ; a is PETSCII character to print
    sta .buffer_char
    ; need to save x,y
    txa
    pha
    tya
    pha
    ; is this a buffered window?
    lda current_window
	bne .is_not_buffered
    lda is_buffered_window
    bne .buffered_window
.is_not_buffered
    lda .buffer_char
    jsr s_printchar
    jmp .printchar_done
    ; update the buffer
.buffered_window
    lda .buffer_char
    ; add this char to the buffer
    cmp #$0d
    bne .check_break_char
	jsr printchar_flush
    ; more on the same line
    jsr increase_num_rows
    lda #$0d
    jsr s_printchar
	jsr start_buffering
    jmp .printchar_done
.check_break_char
    ldy buffer_index
    +cpy_screen_width
	bcs .add_char ; Don't register break chars on last position of buffer.
    cmp #$20 ; Space
    beq .break_char
	cmp #$2d ; -
	bne .add_char
.break_char
    ; update index to last break character
    sty last_break_char_buffer_pos
.add_char
    ldy buffer_index
    sta print_buffer,y
    lda s_reverse
    sta print_buffer2,y
	iny
    sty buffer_index
    +cpy_screen_width_plus_1
    beq +
    jmp .printchar_done
+
    ; print the line until last space
	; First calculate max# of characters on line
!ifndef ACORN {
	ldx #40
} else {
    +ldx_screen_width
}
	lda window_start_row
	sec
	sbc window_start_row + 1
	sbc #2
	cmp num_rows
	bcs +
    ; SF: Note that we only allow 39 characters on the last line of the screen;
    ; this may be useful information if I ever want to implement a "more" prompt
    ; character. However, I note the C64 "more" code saves and restores the
    ; contents of the bottom right character and I suspect a game could output
    ; text in other ways which would use the rightmost column on the bottom
    ; line.
	dex ; Max 39 chars on last line on screen.
+	stx max_chars_on_line
	; Check if we have a "perfect space" - a space after 40 characters
	lda print_buffer,x
	cmp #$20
	beq .print_40_2 ; Print all in buffer, regardless of which column buffering started in
	; Now find the character to break on
	ldy last_break_char_buffer_pos
	beq .print_40 ; If there are no break characters on the line, print all 40 characters
	; Check if the break character is a space
	lda print_buffer,y
	cmp #$20
	beq .print_buffer
	iny
	bne .store_break_pos ; Always branch
.print_40
	; If we can't find a place to break, and buffered output started in column > 0, print a line break and move the text in the buffer to the next line.
	ldx first_buffered_column
	bne .move_remaining_chars_to_buffer_start
.print_40_2	
	ldy max_chars_on_line
.store_break_pos
	sty last_break_char_buffer_pos
.print_buffer
	ldx first_buffered_column
    lda s_reverse
    pha
-   cpx last_break_char_buffer_pos
    beq +
    txa ; kernal_printchar destroys x,y
    pha
    lda print_buffer2,x
    sta s_reverse
    lda print_buffer,x
    jsr s_printchar
    pla
    tax
    inx
    bne - ; Always branch
+   pla
    sta s_reverse

.move_remaining_chars_to_buffer_start
    ; Skip initial spaces, move the rest of the line back to the beginning and update indices
	ldy #0
	cpx buffer_index
	beq .after_copy_loop
    lda print_buffer,x
	cmp #$20
	bne .copy_loop
	inx
.copy_loop
	cpx buffer_index
    beq .after_copy_loop
    lda print_buffer,x
    sta print_buffer,y
    lda print_buffer2,x
    sta print_buffer2,y
    iny
    inx
    bne .copy_loop ; Always branch
.after_copy_loop
    +make_acorn_screen_hole_jmp
	sty buffer_index
	lda #0
	sta first_buffered_column
    ; more on the same line
    jsr increase_num_rows
	lda last_break_char_buffer_pos
    +cmp_screen_width
	bcs +
    lda #$0d
    jsr s_printchar
+   ldy #0
    sty last_break_char_buffer_pos
.printchar_done
    pla
    tay
    pla
    tax
    rts
.buffer_char       !byte 0
; print_buffer            !fill 41, 0
.save_x			   !byte 0
.save_y			   !byte 0
first_buffered_column !byte 0

!ifndef ACORN {
clear_screen_raw
	lda #147
	jsr s_printchar
	rts
}

printchar_raw
	php
	stx .save_x
	sty .save_y
	jsr s_printchar
	ldy .save_y
	ldx .save_x
	plp
	rts

printstring_raw
; Parameters: Address in a,x to 0-terminated string
	stx .read_byte + 1
	sta .read_byte + 2
	ldx #0
.read_byte
	lda $8000,x
	beq +
	jsr printchar_raw
	inx
	bne .read_byte
+	rts
	
set_cursor
    ; input: y=column (0-39)
    ;        x=row (0-24)
    clc
    jmp s_plot

get_cursor
    ; output: y=column (0-39)
    ;         x=row (0-24)
    sec
    jmp s_plot

save_cursor
    jsr get_cursor
	tya
	ldy current_window
    stx cursor_row,y
    sta cursor_column,y
    rts

restore_cursor
	ldy current_window
    ldx cursor_row,y
    lda cursor_column,y
	tay
    jmp set_cursor

!ifdef Z3 {

+make_acorn_screen_hole
z_ins_show_status
    ; show_status (hardcoded size)
;    jmp draw_status_line

draw_status_line
	lda current_window
	pha
    jsr save_cursor
	lda #2
	sta current_window
    ldx #0
    ldy #0
    jsr set_cursor
!ifndef ACORN {
    lda #18 ; reverse on
    jsr s_printchar
	ldx darkmode
	ldy statuslinecol,x 
	lda zcolours,y
	jsr s_set_text_colour
} else {
    lda #$80
    sta s_reverse
!ifdef MODE_7_STATUS {
    lda screen_mode
    cmp #7
    bne +
    ; SF: This used to output the colour code via s_printchar, but a recent
    ; change (to stop Beyond Zork - probably any other game using function keys
    ; as terminating characters as well - printing the function key codes)
    ; stopped that working. I can't help thinking the right fix would be to not
    ; send these valid-for-input-only codes to s_printchar at the end of
    ; .char_is_ok when they occur as terminating characters and then allow
    ; s_printchar to print these colour codes, but I may be missing something
    ; and I don't want to risk causing subtle breakage. As a not-too-bad
    ; workaround, output using oswrch instead.
    lda #vdu_home
    sta s_cursors_inconsistent
    jsr oswrch
    clc
    lda fg_colour
    adc #mode_7_text_colour_base
    jsr oswrch
    inc zp_screencolumn
+
}
}
    ;
    ; Room name
    ; 
    ; name of the object whose number is in the first global variable
    lda #16
    jsr z_get_low_global_variable_value
    jsr print_obj
    ;
    ; fill the rest of the line with spaces
    ;
-   lda zp_screencolumn
    +cmp_screen_width
	bcs +
    lda #$20
    jsr s_printchar
    jmp -
    ;
    ; score or time game?
    ;
+   lda story_start + header_flags_1
    and #$02
    bne .timegame
    ; score game
	lda z_operand_value_low_arr
	pha
	lda z_operand_value_high_arr
	pha
	lda z_operand_value_low_arr + 1
	pha
	lda z_operand_value_high_arr + 1
	pha
    ldx #0
!ifndef ACORN {
    ldy #25
} else {
    sec
    +lda_screen_width
    sbc #(40-25)
    tay
}
    jsr set_cursor
    ldy #0
-   lda .score_str,y
    beq +
    jsr s_printchar
    iny
    bne -
+   lda #17
    jsr z_get_low_global_variable_value
    stx z_operand_value_low_arr
    sta z_operand_value_high_arr
    jsr z_ins_print_num
    lda #47
    jsr s_printchar
    lda #18
    jsr z_get_low_global_variable_value
    stx z_operand_value_low_arr
    sta z_operand_value_high_arr
    jsr z_ins_print_num
	pla
	sta z_operand_value_high_arr + 1
	pla
	sta z_operand_value_low_arr + 1
	pla
	sta z_operand_value_high_arr
	pla
	sta z_operand_value_low_arr
    jmp .statusline_done
.timegame
    ; time game
    ldx #0
!ifndef ACORN {
    ldy #25
} else {
    sec
    +lda_screen_width
    sbc #(40-25)
    tay
}
    jsr set_cursor
	lda #>.time_str
	ldx #<.time_str
	jsr printstring_raw
; Print hours
	lda #65 + 32
	sta .ampm_str + 1
	lda #17 ; hour
    jsr z_get_low_global_variable_value
; Change AM to PM if hour >= 12
	cpx #12
	bcc +
	lda #80 + 32
	sta .ampm_str + 1
+	cpx #0
	bne +
	ldx #12
; Subtract 12 from hours if hours >= 13, so 15 becomes 3 etc
+	cpx #13
	bcc +
	txa
	sbc #12
	tax
+	ldy #$20 ; " " before if < 10
	jsr .print_clock_number
    lda #58 ; :
    jsr s_printchar
; Print minutes
    lda #18 ; minute
    jsr z_get_low_global_variable_value
	ldy #$30 ; "0" before if < 10
	jsr .print_clock_number
; Print AM/PM
	lda #>.ampm_str
	ldx #<.ampm_str
	jsr printstring_raw
.statusline_done
!ifndef ACORN {
	ldx darkmode
	ldy fgcol,x 
	lda zcolours,y
	jsr s_set_text_colour
    lda #146 ; reverse off
    jsr s_printchar
} else {
    lda #0
    sta s_reverse
}
	pla
	sta current_window
    jmp restore_cursor
.print_clock_number
	sty z_temp + 11
	txa
	ldy #0
-	cmp #10
	bcc .print_tens
	sbc #10 ; C is already set
	iny
	bne - ; Always branch
.print_tens
	tax
	tya
	bne +
	lda z_temp + 11
	bne ++
+	ora #$30
++	jsr s_printchar
	txa
	ora #$30
	jmp s_printchar

+make_acorn_screen_hole
!ifndef ACORN {
.score_str !pet "Score: ",0
.time_str !pet "Time: ",0
.ampm_str !pet " AM",0
} else {
.score_str !text "Score: ",0
.time_str !text "Time: ",0
.ampm_str !text " AM",0
}
}

!ifdef ACORN {
    ; We keep the hardware cursor off most of the time; this way the user can't
    ; see it flitting round the screen doing various updates. (The C64 doesn't
    ; have this issue, as it uses direct screen writes and in fact its cursor
    ; is a software creation.) We allow it to remain in "illogical" positions
    ; while it's invisible and only position it where it belongs when it's turned
    ; on, as it is during user input.
init_cursor_control
    lda #$ff
    sta cursor_status
    bne .cursor_control ; Always branch

    ; turn_off_cursor and turn_on_cursor adjust the value in cursor_status
    ; rather than setting a flag so they can be nested safely; the cursor should
    ; be turned on iff cursor_status is non-negative. Because we wait for VSYNC
    ; when telling the OS to turn the cursor on or off to try to avoid visual
    ; artefacts from doing so, we want to avoid this unless cursor_status has
    ; just transitioned from negative to non-negative or vice versa.
turn_on_cursor
    inc cursor_status
    beq .really_turn_on_cursor
.cursor_control_rts
    rts
turn_off_cursor
    lda cursor_status
    dec cursor_status
    tax
    bne .cursor_control_rts
    ; We're turning the OS cursor off.
    lda #osbyte_read_vdu_status
    jsr osbyte
    txa
    and #vdu_status_cursor_editing
    beq .cursor_control
    ; We're in cursor editing mode, so we need to output a carriage return to
    ; turn it off. This will turn the cursor back on, so we must output it
    ; before we turn the cursor off. (We could turn the cursor off before
    ; outputting the carriage return as well, in order to try to minimise the
    ; chances of the user seeing it flick briefly into the leftmost column, but
    ; in practice this doesn't seem to help much.)
    lda #vdu_cr
    sta s_cursors_inconsistent
    jsr oswrch
    jmp .cursor_control
.really_turn_on_cursor
    ; Just before we turn the OS cursor on, it's forced into the location
    ; corresponding to zp_screen{column,row}, which is where it "should" have
    ; been all along.
    jsr s_cursor_to_screenrowcolumn
.cursor_control
    lda #vdu_miscellaneous
    jsr oswrch
    lda #1
    jsr oswrch
    clc
    adc cursor_status ; we know A=1 and cursor_status=-1 for off or 0 for on
    jsr oswrch
    ldx #6
    lda #0
-   jsr oswrch
    dex
    bne -
    ; The VDU 23 command now lacks one byte to be complete, so let's wait for
    ; VSYNC now at the last possible minute before outputting that last byte
    ; and actioning the VDU 23 command.
    ; SFTODO: This VSYNC hits the benchmark quite hard but will be imperceptible
    ; normally, it might be worth conditionally omitting the next two lines in
    ; a benchmark build.
    lda #osbyte_wait_for_vsync
    jsr osbyte
    lda #0
    jmp oswrch
}
