; replacement for these C64 kernal routines and their variables:
; printchar $ffd2
; plot      $fff0
; zp_cursorswitch $cc
; zp_screenline $d1-$d2
; zp_screencolumn $d3
; zp_screenrow $d6
; zp_colourline $f3-$f4
;
; needed to be able to customize the text scrolling to
; not include status lines, especially big ones used in
; Border Zone, and Nord and Bert.
;
; usage: first call s_init, then replace
; $ffd2 with s_printchar and so on.
; s_scrollstart is set to the number of top lines to keep when scrolling
;
; Uncomment TESTSCREEN and call testscreen for a demo.

;TESTSCREEN = 1

; SF: s_printchar should be used for virtually all text output. This way it can
; update zp_screen{column,row} to match what it has sent to OSWRCH and they will
; agree with the OS text cursor position. If zp_screen{column,row} are modified
; without moving the OS text cursor or vice versa, setting
; s_cursors_inconsistent to a non-0 value will cause the OS cursor to be moved
; the next time it matters (when we try to print something via OSWRCH, or when
; the OS cursor becomes visible to the user).

!zone screenkernal {

; The Commodore 64 and one Acorn build have a fixed screen size while other
; Acorn builds have a variable screen size. We don't want to penalise the
; former so we use these macros which assemble using either immediate values
; or memory accesses as appropriate.

!ifndef ACORN {
    FIXED_SCREEN_SIZE = 1
} else {
    !ifdef ACORN_NO_SHADOW {
        FIXED_SCREEN_SIZE = 1
    }
}

!ifdef FIXED_SCREEN_SIZE {
!ifdef Z3 {
max_lines = 24
} else {
max_lines = 25
}
} else {
!ifdef Z3 {
max_lines = screen_height_minus_1
} else {
max_lines = screen_height
}
}

!macro cmp_screen_height {
    !ifdef FIXED_SCREEN_SIZE {
        cmp #25
    } else {
        cmp screen_height
    }
}
!macro cmp_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        cmp #40
    } else {
        cmp screen_width
    }
}
!macro cpx_screen_height {
    !ifdef FIXED_SCREEN_SIZE {
        cpx #25
    } else {
        cpx screen_height
    }
}
!macro cpx_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        cpx #40
    } else {
        cpx screen_width
    }
}
!macro cpx_max_lines {
    !ifdef FIXED_SCREEN_SIZE {
        cpx #max_lines
    } else {
        cpx max_lines
    }
}
!macro cpy_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        cpy #40
    } else {
        cpy screen_width
    }
}
!macro cpy_screen_width_plus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        cpy #41
    } else {
        cpy screen_width_plus_1
    }
}
!macro lda_screen_height_minus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        lda #24
    } else {
        lda screen_height_minus_1
    }
}
!macro lda_screen_height {
    !ifdef FIXED_SCREEN_SIZE {
        lda #25
    } else {
        lda screen_height
    }
}
!macro lda_screen_width_minus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        lda #39
    } else {
        lda screen_width_minus_1
    }
}
!macro ldx_screen_width_minus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        ldx #39
    } else {
        ldx screen_width_minus_1
    }
}
!macro lda_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        lda #40
    } else {
        lda screen_width
    }
}
!macro ldx_max_lines {
    !ifdef FIXED_SCREEN_SIZE {
        ldx #max_lines
    } else {
        ldx max_lines
    }
}
!macro ldx_screen_height_minus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        ldx #24
    } else {
        ldx screen_height_minus_1
    }
}
!macro ldx_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        ldx #40
    } else {
        ldx screen_width
    }
}
!macro ldy_screen_height_minus_1 {
    !ifdef FIXED_SCREEN_SIZE {
        ldy #24
    } else {
        ldy screen_height_minus_1
    }
}
!macro ldy_screen_height {
    !ifdef FIXED_SCREEN_SIZE {
        ldy #25
    } else {
        ldy screen_height
    }
}
!macro ldy_screen_width {
    !ifdef FIXED_SCREEN_SIZE {
        ldy #40
    } else {
        ldy screen_width
    }
}

!ifndef ACORN {
s_init
    ; init cursor
    lda #$ff
    sta s_current_screenpos_row ; force recalculation first time

    lda #0
    sta zp_screencolumn
    sta zp_screenrow
	; Set to 0: s_ignore_next_linebreak, s_reverse
    ldx #3
-	sta s_ignore_next_linebreak,x
	dex
	bpl -
    rts
} else {
!macro screenkernal_init_inline {
!ifndef ACORN_NO_SHADOW {
    ; story_start + header_screen_{width,height}* are only valid for certain
    ; Z-machine versions. We don't want to be querying the OS for these values all
    ; the time, so we keep them here.
    lda #osbyte_read_vdu_variable
    ldx #vdu_variable_text_window_bottom
    jsr osbyte
    stx screen_height_minus_1
    inx
    stx screen_height
    sty screen_width_minus_1
    iny
    sty screen_width
    iny
    sty screen_width_plus_1
}

    ; Pick up the current OS cursor position; this will improve readability if
    ; any errors occuring during initialization, and it doesn't affect the game
    ; because deletable_screen_init_2 calls set_cursor anyway.
    lda #osbyte_read_cursor_position
    sta s_cursors_inconsistent
    jsr osbyte
    stx zp_screencolumn
    sty zp_screenrow
	; Set to 0: s_ignore_next_linebreak, s_reverse, s_os_reverse
    lda #0
    ldx #4 ; also s_os_reverse
-	sta s_ignore_next_linebreak,x
	dex
	bpl -

    ; If we didn't change mode after a restart, we may have been left with the
    ; OS colours set to reverse video. Force the OS settings to normal video so
    ; they agree with s_os_reverse.
    jsr force_set_os_normal_video
}
}

s_plot
    ; y=column (0-39)
    ; x=row (0-24)
    bcc .set_cursor_pos
    ; get_cursor
    ldx zp_screenrow
    ldy zp_screencolumn
    rts
.set_cursor_pos
!ifndef ACORN {
+	cpx #25
	bcc +
	ldx #24
} else {
+	+cpx_screen_height
	bcc +
	+ldx_screen_height_minus_1
}
+	stx zp_screenrow
	sty zp_screencolumn
!ifndef ACORN {
	jmp .update_screenpos
} else {
    lda #1
    sta s_cursors_inconsistent
.return
    rts
}

!ifndef ACORN {
s_set_text_colour
	sta s_colour
	rts
}

!ifndef ACORN {
s_delete_cursor
	lda #$20 ; blank space
	ldy zp_screencolumn
	sta (zp_screenline),y
	rts
}

!ifdef ACORN {
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
; Return with Z clear iff the cursor is on a mode 7 status line
; Preserves A and X.
.check_if_mode_7_status
    ldy zp_screenrow
    bne .check_if_mode_7_status2_rts
.check_if_mode_7_status2
    ldy window_start_row + 1 ; how many top lines to protect
    dey
    bne .check_if_mode_7_status2_rts
    ldy screen_mode
    cpy #7
.check_if_mode_7_status2_rts
    rts

check_and_add_mode_7_colour_code
    jsr .check_if_mode_7_status2
    bne .check_if_mode_7_status2_rts
    ; fall through to .output_mode_7_colour_code
}

.output_mode_7_colour_code
    lda #vdu_home
    sta s_cursors_inconsistent
    jsr oswrch
    clc
    lda fg_colour
    adc #mode_7_text_colour_base
    jmp oswrch
}

s_cursor_to_screenrowcolumn
    lda s_cursors_inconsistent
!ifndef DEBUG_CURSOR {
    beq .return
} else {
    beq .check_cursor
}
    lda #0
    sta s_cursors_inconsistent
    ldx zp_screencolumn
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    jsr .check_if_mode_7_status
    bne +
    inx
+
}
}
    ldy zp_screenrow
    jmp do_oswrch_vdu_goto_xy
!ifdef DEBUG_CURSOR {
.check_cursor
    txa
    pha
    tya
    pha
    lda #osbyte_read_cursor_position
    jsr osbyte
    cpx zp_screencolumn
    beq +
-   jmp -
+   cpy zp_screenrow
    beq +
-   jmp -
+   pla
    tay
    pla
    tax
    rts
}

s_screenrowcolumn_from_cursor
    lda #osbyte_read_vdu_variable
    sta s_cursors_inconsistent
    ldx #vdu_variable_text_window_top
    jsr osbyte
    stx zp_screenrow
    lda #osbyte_read_cursor_position
    jsr osbyte
    stx zp_screencolumn
    tya
    clc
    adc zp_screenrow
    sta zp_screenrow
.rts
    rts

s_reverse_to_os_reverse
    lda s_reverse
    bne set_os_reverse_video
    ; fall through to set_os_normal_video

set_os_normal_video
    lda s_os_reverse
    beq .rts
force_set_os_normal_video
    lda #0
    sta s_os_reverse
    lda #7
    jsr .set_tcol
    lda #128
    jmp .set_tcol

set_os_reverse_video
    lda s_os_reverse
    bne .rts
    lda #$80
    sta s_os_reverse
    lda #0
    jsr .set_tcol
    lda #135
    ; jmp .set_tcol - just fall through

.set_tcol
    pha
    lda #vdu_set_text_colour
    jsr oswrch
    pla
    jmp oswrch
}

s_printchar
    ; replacement for CHROUT ($ffd2)
    ; input: A = byte to write (PETASCII) [SF: ASCII not PETASCII on Acorn]
    ; output: -
    ; used registers: -
    stx s_stored_x
    sty s_stored_y

	; Fastlane for the most common characters
	cmp #$20
	bcc +
!ifndef ACORN {
	cmp #$80
} else {
    cmp #$7f
}
	bcc .normal_char
	cmp #$a0
	bcs .normal_char
+	
	cmp #$0d
    bne +
	; newline
!ifndef ACORN {
	; but first, check if the current character is the cursor so that we may delete it
	lda cursor_character
	ldy zp_screencolumn
	cmp (zp_screenline),y
	bne +++
	jsr s_delete_cursor
}
+++	jmp .perform_newline
+   
    ; SF: Note that .readkey will call s_printchar with the native delete
    ; character.
!ifndef ACORN {
    cmp #20
} else {
    cmp #127
}
    bne +
    ; delete
!ifndef ACORN {
    jsr s_delete_cursor
    dec zp_screencolumn ; move back
    bpl ++
	inc zp_screencolumn ; Go back to 0 if < 0
	lda zp_screenrow
	ldy current_window
	cmp window_start_row + 1,y
	bcc ++
	dec zp_screenrow
	lda #39
	sta zp_screencolumn
++  jsr .update_screenpos
    lda #$20
    ldy zp_screencolumn
    sta (zp_screenline),y
    lda s_colour
    sta (zp_colourline),y
} else {
    jsr s_cursor_to_screenrowcolumn
    jsr s_reverse_to_os_reverse
    lda #127
    jsr oswrch
    dec zp_screencolumn ; move back
    bpl ++
	inc zp_screencolumn ; Go back to 0 if < 0
	lda zp_screenrow
	ldy current_window
	cmp window_start_row + 1,y
	bcc ++
	dec zp_screenrow
	+lda_screen_width_minus_1
	sta zp_screencolumn
++
}
!ifdef ACORN {
    ; We don't have any reverse video handling here on Acorn as noted below, so
    ; we move the + label forward so anything which hasn't matched yet is
    ; ignored.
+
}
    jmp .printchar_end
+
    ; SF: Reverse video isn't handled by sending control codes through
    ; s_printchar on the Acorn. (It could be, but it seems simplest just to
    ; update s_reverse directly. This is a bit gratuitously incompatible with
    ; the Commodore though.)
!ifndef ACORN {
    cmp #$93 
    bne +
    ; clr (clear screen)
    lda #0
    sta zp_screencolumn
    sta zp_screenrow
    jsr s_erase_window
    jmp .printchar_end
+   cmp #$12 ; 18
    bne +
    ; reverse on
    ldx #$80
    stx s_reverse
    jmp .printchar_end
+   cmp #$92 ; 146
    bne .printchar_end
    ; reverse off
    ldx #0
    stx s_reverse
    beq .printchar_end ; Always jump
}
; +
	; ; check if colour code
	; ldx #15
; -	cmp colours,x
	; beq ++
	; dex
	; bpl -
	; bmi .printchar_end ; Always branch
; ++	; colour <x> found
	; stx s_colour
	; beq .printchar_end ; Always jump
	
.normal_char
	ldx zp_screencolumn
	bpl +
	; Negative column. Increase column but don't print anything.
	inc zp_screencolumn
	jmp .printchar_end
+	; Skip if column > 39
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    jsr .check_if_mode_7_status
    bne +
    cpx #39
    bcs .printchar_end_bcs
+
}
}
    +cpx_screen_width
.printchar_end_bcs
	bcs .printchar_end
!ifdef ACORN_HW_SCROLL {
    ldy zp_screenrow
    bne +
    sta .top_line_buffer,x
    lda s_reverse
    sta .top_line_buffer_reverse,x
    lda .top_line_buffer,x
+
}
	; Reset ignore next linebreak setting
	ldx current_window
	ldy s_ignore_next_linebreak,x
	bpl +
	inc s_ignore_next_linebreak,x
	; Check if statusline is overflowing TODO: Do we really need to check any more?
+	pha
	lda zp_screenrow
	ldy current_window 
	cmp window_start_row,y
	pla ; Doesn't affect C
	bcs .outside_current_window
.resume_printing_normal_char	
!ifndef ACORN {
   ; convert from pet ascii to screen code
	cmp #$40
	bcc ++    ; no change if numbers or special chars
	cmp #$60
	bcs +
	and #%00111111
	bcc ++ ; always jump
+   cmp #$80
    bcs +
	and #%11011111
    bcc ++ ; always jump
+	cmp #$c0
	bcs +
	eor #%11000000
+	and #%01111111
++  ; print the char
    clc
    adc s_reverse
    pha
    jsr .update_screenpos
    pla
    ldy zp_screencolumn
    sta (zp_screenline),y
    lda s_colour
    sta (zp_colourline),y
    iny
    sty zp_screencolumn
	ldx current_window
	bne .printchar_end ; For upper window and statusline (in z3), don't advance to next line.
    cpy #40
    bcc .printchar_end
	dec s_ignore_next_linebreak,x ; Goes from 0 to $ff
    lda #0
    sta zp_screencolumn
    inc zp_screenrow
	lda zp_screenrow
	cmp #25
	bcs +
	jsr .update_screenpos
	jmp .printchar_end
+	jsr .s_scroll
} else { ; ACORN
    ; OSWRCH may cause the screen to scroll if we're at the bottom right
    ; character. We therefore don't use .s_scroll to do the scroll, we just
    ; define a text window to tell the OS what to scroll.

    pha
    jsr s_cursor_to_screenrowcolumn
    jsr s_reverse_to_os_reverse
    ldy zp_screencolumn
    iny
    sty zp_screencolumn
	ldx current_window
	bne .printchar_nowrap ; For upper window and statusline (in z3), don't advance to next line.
    +cpy_screen_width
    bcc .printchar_nowrap
	dec s_ignore_next_linebreak,x ; Goes from 0 to $ff
    lda #0
    sta zp_screencolumn
    inc zp_screenrow
	lda zp_screenrow
	+cmp_screen_height
	bcc .printchar_nowrap
!ifdef ACORN_HW_SCROLL {
    lda use_hw_scroll
    beq .no_hw_scroll0
    +lda_screen_height_minus_1
    sta zp_screenrow ; s_pre_scroll normally does this but we may not call it
    ldx window_start_row + 1 ; how many top lines to protect
    dex
    beq .no_pre_scroll
.no_hw_scroll0
}
    ; C is already set
    jsr s_pre_scroll
.no_pre_scroll
    pla
    jsr oswrch
    lda s_reverse
    beq .not_reverse
    ; Reverse video is on and the character we just output has caused the text
    ; window to scroll, so the OS will have added a blank line in reverse video.
    ; The Z-machine spec requires the blank line to be in normal video, so we
    ; need to fix this up.
    jsr s_erase_line_from_cursor
.not_reverse
!ifdef ACORN_HW_SCROLL {
    ldx window_start_row + 1 ; how many top lines to protect
    dex
    bne .no_hw_scroll1
    lda use_hw_scroll
    beq .no_hw_scroll1
    jsr .redraw_top_line
    jmp .printchar_oswrch_done
.no_hw_scroll1
}
    lda #vdu_reset_text_window
    sta s_cursors_inconsistent ; vdu_reset_text_window moves cursor to home
    pha
.printchar_nowrap
    pla
    ; This OSWRCH call is the one which actually prints most of the text on the
    ; screen.
    jsr oswrch
.printchar_oswrch_done
    ; Force the OS text cursor to move if necessary; normally it would be
    ; invisible at this point, but TerpEtude's "Timed full-line input" test can
    ; leave the OS text cursor visible at the top left if you type a character
    ; in the rightmost column and then wait for the timed mwessage to appear.
    jsr s_cursor_to_screenrowcolumn
}
.printchar_end
    ldx s_stored_x
    ldy s_stored_y
    rts

.outside_current_window
!ifdef Z4 {
	jmp .printchar_end
} else {
	cpy #1
	bne .printchar_end
	; This is window 1. Expand it if possible.
	ldy zp_screenrow
	cpy window_start_row ; Compare to end of screen (window 0)
	bcs .printchar_end
	iny
	sty window_start_row + 1
	; Move lower window cursor if it gets hidden by upper window
	cpy cursor_row
	bcc .resume_printing_normal_char
	sty cursor_row
	bcs .resume_printing_normal_char ; Always branch
}

.perform_newline
    ; newline/enter/return
	; Check ignore next linebreak setting
	ldx current_window
	ldy s_ignore_next_linebreak,x
	bpl +
	inc s_ignore_next_linebreak,x
	jmp .printchar_end
+   lda #0
    sta zp_screencolumn
    inc zp_screenrow
    jsr .s_scroll
!ifndef ACORN {
    jsr .update_screenpos
} else {
    lda #1
    sta s_cursors_inconsistent
}
    jmp .printchar_end

!ifndef ACORN {
s_erase_window
    lda #0
    sta zp_screenrow
-   jsr s_erase_line
    inc zp_screenrow
    lda zp_screenrow
    cmp #25
    bne -
    lda #0
    sta zp_screenrow
    sta zp_screencolumn
    rts
}

!ifndef ACORN {
.update_screenpos
    ; set screenpos (current line) using row
    ldx zp_screenrow
    cpx s_current_screenpos_row
    beq +
    ; need to recalculate zp_screenline
    stx s_current_screenpos_row
    ; use the fact that zp_screenrow * 40 = zp_screenrow * (32+8)
    lda #0
    sta zp_screenline + 1
	txa
    asl; *2 no need to rol zp_screenline + 1 since 0 < zp_screenrow < 24
    asl; *4
    asl; *8
    sta zp_colourline ; store *8 for later
    asl; *16
    rol zp_screenline + 1
    asl; *32
    rol zp_screenline + 1  ; *32
    clc
    adc zp_colourline ; add *8
    sta zp_screenline
    sta zp_colourline
    lda zp_screenline + 1
    adc #$04 ; add screen start ($0400)
    sta zp_screenline +1
    adc #$d4 ; add colour start ($d800)
    sta zp_colourline + 1
+   rts
}

.s_scroll
    lda zp_screenrow
    +cmp_screen_height
    bpl +
    rts
+
!ifndef ACORN {
    ldx window_start_row + 1 ; how many top lines to protect
    stx zp_screenrow
-   jsr .update_screenpos
    lda zp_screenline
    pha
    lda zp_screenline + 1
    pha
    inc zp_screenrow
    jsr .update_screenpos
    pla
    sta zp_colourline + 1
    pla
    sta zp_colourline
    ; move characters
    ldy #39
--  lda (zp_screenline),y ; zp_screenrow
    sta (zp_colourline),y ; zp_screenrow - 1
    dey
    bpl --
    ; move colour info
    lda zp_screenline + 1
    pha
    clc
    adc #$d4
    sta zp_screenline + 1
    lda zp_colourline + 1
    clc
    adc #$d4
    sta zp_colourline + 1
    ldy #39
--  lda (zp_screenline),y ; zp_screenrow
    sta (zp_colourline),y ; zp_screenrow - 1
    dey
    bpl --
    pla
    sta zp_screenline + 1
    lda zp_screenrow
    cmp #24
    bne -
    lda #$ff
    sta s_current_screenpos_row ; force recalculation
s_erase_line
	; registers: a,x,y
	lda #0
	sta zp_screencolumn
	jsr .update_screenpos
	ldy #0
.erase_line_from_any_col	
	lda #$20
-	cpy #40
	bcs .done_erasing
	sta (zp_screenline),y
	iny
	bne -
.done_erasing	
 	rts
s_erase_line_from_cursor
	jsr .update_screenpos
	ldy zp_screencolumn
	jmp .erase_line_from_any_col
} else { ; ACORN
!ifdef ACORN_HW_SCROLL {
    ldx window_start_row + 1 ; how many top lines to protect
    dex
    bne .no_hw_scroll2
    lda use_hw_scroll
    beq .no_hw_scroll2
    ldx #0
    +ldy_screen_height_minus_1
    sty zp_screenrow
    jsr do_oswrch_vdu_goto_xy
    jsr set_os_normal_video ; new line must not be reverse video
    lda #vdu_down
    jsr oswrch
    jmp .redraw_top_line
.no_hw_scroll2
}
    sec
    jsr s_pre_scroll
    ; Move the cursor down one line to force a scroll
    jsr set_os_normal_video ; new line must not be reverse video
    lda #vdu_down
    jsr oswrch
    ; Remove the text window
    lda #vdu_reset_text_window
    sta s_cursors_inconsistent ; vdu_reset_text_window moves cursor to home
    jmp oswrch

s_erase_line
	; registers: a,x,y
	lda #0
	sta zp_screencolumn
s_erase_line_from_cursor
!ifdef ACORN_HW_SCROLL {
    ldx zp_screenrow
    bne +
    ldx zp_screencolumn
-   lda #' '
    sta .top_line_buffer,x
    lda #0
    sta .top_line_buffer_reverse,x
    inx
    +cpx_screen_width
    bne -
+
}
    ; Define a text window covering the region to clear
    lda #vdu_define_text_window
    jsr oswrch
    lda zp_screencolumn
    jsr oswrch
    lda zp_screenrow
    pha
    jsr oswrch
    +lda_screen_width_minus_1
    jsr oswrch
    pla
    jsr oswrch
    ; Clear it and reset the text window.
    jsr set_os_normal_video ; clear must not be to reverse video
    lda #vdu_cls
    jsr oswrch
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    lda zp_screenrow
    bne +
    jsr check_and_add_mode_7_colour_code
+
}
}
    lda #vdu_reset_text_window
    sta s_cursors_inconsistent ; vdu_reset_text_window moves cursor to home
    jmp oswrch

s_pre_scroll
    ; Define a text window covering the region to scroll.
    ; If C is set on entry, leave the OS text cursor at the bottom right of the
    ; text window.
    ; If C is clear on entry, leave the OS text cursor where it was on the
    ; physical screen (its co-ordinates will be different because of the text
    ; window).
    ; SF: ENHANCEMENT: If window_start_row+1 is 0 we are scrolling the whole
    ; screen, so defining the text window has no visible effect and will slow
    ; things down by preventing the OS doing a hardware scroll. It wouldn't be
    ; hard to avoid defining the text window in this case, but in reality I
    ; suspect there's nearly always a status bar or similar on the screen and
    ; this case won't occur. If a game where this would be useful turns up I
    ; can consider it. (Don't forget ACORN_NO_SHADOW must always use a text
    ; window though.)
    bcs .s_pre_scroll_leave_bottom_right
    lda #osbyte_read_cursor_position
    jsr osbyte
    tya
    pha
    txa
    pha
    jsr .s_pre_scroll_leave_bottom_right
    pla
    tax
    pla
    sec
    sbc window_start_row + 1
    tay
    jmp do_oswrch_vdu_goto_xy
.s_pre_scroll_leave_bottom_right
    lda #vdu_define_text_window
    jsr oswrch
    lda #0
    ; We don't need to update zp_screencolumn, our caller will have done it.
    ; sta zp_screencolumn ; leave the ozmoo cursor at the start of the line
    jsr oswrch
    +lda_screen_height_minus_1
    sta zp_screenrow ; leave the ozmoo cursor on the last line
    jsr oswrch
    +lda_screen_width_minus_1
    jsr oswrch
    lda window_start_row + 1 ; how many top lines to protect
    jsr oswrch
    ; Move the cursor to the bottom right of the text window
    +ldx_screen_width_minus_1
    +lda_screen_height_minus_1
    sec
    sbc window_start_row + 1
    tay
    jmp do_oswrch_vdu_goto_xy

!ifdef ACORN_HW_SCROLL {
.redraw_top_line
    jsr turn_off_cursor
    lda #vdu_home
    jsr oswrch
    +ldy_screen_width
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    lda screen_mode
    cmp #7
    bne +
    jsr .output_mode_7_colour_code
    ldy #39
+
}
}
    ldx #0
-   lda .top_line_buffer_reverse,x
    beq +
    jsr set_os_reverse_video
    jmp ++
+   jsr set_os_normal_video
++  lda .top_line_buffer,x
    jsr oswrch
    inx
    dey
    bne -
    stx s_cursors_inconsistent
    jmp turn_on_cursor
}
}


!ifndef ACORN {
; colours		!byte 144,5,28,159,156,30,31,158,129,149,150,151,152,153,154,155
zcolours	!byte $ff,$ff ; current/default colour
			!byte COL2,COL3,COL4,COL5  ; black, red, green, yellow
			!byte COL6,COL7,COL8,COL9  ; blue, magenta, cyan, white
darkmode	!byte 0
bgcol		!byte BGCOL, BGCOLDM
fgcol		!byte FGCOL, FGCOLDM
bordercol	!byte BORDERCOL_FINAL, BORDERCOLDM_FINAL
!ifdef Z3 {
statuslinecol !byte STATCOL, STATCOLDM
}
cursorcol !byte CURSORCOL, CURSORCOLDM
current_cursor_colour !byte CURSORCOL
cursor_character !byte CURSORCHAR
}

!ifndef ACORN {
!ifndef NODARKMODE {
toggle_darkmode
!ifdef Z5PLUS {
	; We will need the old fg colour later, to check which characters have the default colour
	ldx darkmode ; previous darkmode value (0 or 1)
	ldy fgcol,x
	lda zcolours,y
	sta z_temp + 9 ; old fg colour
}
; Toggle darkmode
	lda darkmode
	eor #1
	sta darkmode
	tax
; Set cursor colour
	ldy cursorcol,x
	lda zcolours,y
	sta current_cursor_colour
; Set bgcolor
	ldy bgcol,x
	lda zcolours,y
	sta reg_backgroundcolour
!ifdef Z5PLUS {
	; We will need the new bg colour later, to check which characters would become invisible if left unchanged
	sta z_temp + 8 ; new background colour
}
; Set border colour 
	ldy bordercol,x
!ifdef BORDER_MAY_FOLLOW_BG {
	beq .store_bordercol
}
!ifdef BORDER_MAY_FOLLOW_FG {
	cpy #1
	bne +
	ldy fgcol,x
+	
}
	lda zcolours,y
.store_bordercol
	sta reg_bordercolour
!ifdef Z3 {
; Set statusline colour
	ldy statuslinecol,x
	lda zcolours,y
	ldy #39
-	sta $d800,y
	dey
	bpl -
}
; Set fgcolour
	ldy fgcol,x
	lda zcolours,y
	jsr s_set_text_colour
	ldx #4
	ldy #$d8
	sty z_temp + 11
	ldy #0
	sty z_temp + 10
!ifdef Z3 {
	ldy #40
}
!ifdef Z5PLUS {
	sta z_temp + 7
}
.compare
!ifdef Z5PLUS {
	lda (z_temp + 10),y
	and #$0f
	cmp z_temp + 9
	beq .change
	cmp z_temp + 8
	bne .dont_change
.change	
	lda z_temp + 7
}
	sta (z_temp + 10),y
.dont_change
	iny
	bne .compare
	inc z_temp + 11
	dex
	bne .compare
	jsr update_cursor
	rts 
} ; ifndef NODARKMODE
} else { ; ACORN
update_colours
!ifdef MODE_7_STATUS {
!ifdef Z4PLUS {
    jsr turn_off_cursor
    jsr check_and_add_mode_7_colour_code
    jsr turn_on_cursor
}
!ifdef Z3 {
    lda screen_mode
    cmp #7
    bne +
    jsr turn_off_cursor
    jsr .output_mode_7_colour_code
    jsr turn_on_cursor
+
}
}
    ldx #0
    ldy bg_colour
    jsr .redefine_colour
    ldx #7
    ldy fg_colour
    ; fall through to .redefine_colour
.redefine_colour
    lda #vdu_redefine_colour
    jsr oswrch
    txa
    jsr oswrch
    tya
    jsr oswrch
    lda #0
    jsr oswrch
    jsr oswrch
    jmp oswrch

check_user_interface_controls
!ifdef ACORN_HW_SCROLL {
    cmp #'S' - ctrl_key_adjust
    bne +
    lda use_hw_scroll
    eor #1
    sta use_hw_scroll
    ; We make a sound here because this has no immediately visible effect, so
    ; it's nice to offer the user some sort of feedback.
    jsr sound_high_pitched_beep
    lda #0
    rts
}
+   ldx screen_mode
    ldy #0
    cpx #7
    bne +
    ldy #1
+   ldx #0
    cmp #'F' - ctrl_key_adjust
    beq +
    inx
    cmp #'B' - ctrl_key_adjust
    bne .done
+   inc fg_colour,x
    lda fg_colour,x
    cmp #8
    bne +
    tya
+   sta fg_colour,x
    jsr update_colours
    lda #0
.done
    rts
}


!ifdef Z5PLUS {
z_ins_set_colour
!ifndef ACORN {
    ; set_colour foreground background [window]
    ; (window is not used in Ozmoo)
	jsr printchar_flush

; Load y with bordercol (needed later)
	ldx darkmode
	ldy bordercol,x

; Set background colour
    ldx z_operand_value_low_arr + 1
	beq .current_background
    lda zcolours,x
    bpl +
    ldx story_start + header_default_bg_colour ; default colour
    lda zcolours,x
+   sta reg_backgroundcolour
; Also set bordercolour to same as background colour, if bordercolour is set to the magic value 0
	cpy #0
	bne .current_background
	sta reg_bordercolour
.current_background

; Set foreground colour
    ldx z_operand_value_low_arr
	beq .current_foreground
    lda zcolours,x
    bpl + ; Branch unless it's the special value $ff, which means "default colour"
    ldx story_start + header_default_fg_colour ; default colour
    lda zcolours,x
+
; Also set bordercolour to same as foreground colour, if bordercolour is set to the magic value 1
	cpy #1
	bne +
	sta reg_bordercolour
+
    jsr s_set_text_colour ; change foreground colour
.current_foreground
    rts
} else {
    jmp printchar_flush
}
}

; SFTODODATA 160 (BUT NOT IN ALL BUILDS)
!ifdef ACORN_HW_SCROLL {
.top_line_buffer
    !fill max_screen_width
.top_line_buffer_reverse
    !fill max_screen_width
}

!ifdef TESTSCREEN {
!ifdef ACORN {
    !error "TESTSCREEN not supported on Acorn"
}

.testtext !pet 5,147,18,"Status Line 123         ",146,13
          !pet 28,"tesx",20,"t aA@! ",18,"Test aA@!",146,13
          !pet 155,"third",20,13
          !pet "fourth line",13
          !pet 13,13,13,13,13,13
          !pet 13,13,13,13,13,13,13
          !pet 13,13,13,13,13,13,13
          !pet "last line",1
          !pet "aaaaaaaaabbbbbbbbbbbcccccccccc",1
          !pet "d",1 ; last char on screen
          !pet "efg",1 ; should scroll here and put efg on new line
          !pet 13,"h",1; should scroll again and f is on new line
          !pet 0

testscreen
    lda #23 ; 23 upper/lower, 21 = upper/special (22/20 also ok)
    sta $d018 ; reg_screen_char_mode
    jsr s_init
    lda #1
    sta s_scrollstart
    ldx #0
-   lda .testtext,x
    bne +
    rts
+   cmp #1
    bne +
    txa
    pha
--  jsr kernal_getchar
    beq --
    pla
    tax
    bne ++
+   jsr s_printchar
++  inx
    bne -
}
}

