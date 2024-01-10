; Which Z-machine to generate binary for
; (usually defined on the acme command line instead)
; Z1, Z2, Z6 and Z7 will (probably) never be supported
;Z3 = 1
;Z4 = 1
;Z5 = 1
;Z8 = 1

; Which machine to generate code for
; C64 is default and currently the only supported target, but
; future versions may include new targets such as Mega65, Plus/4 etc.
!ifndef ACORN {
!ifndef TARGET_C64 {
    TARGET_C64 = 1 ; C64 is the default target
}
}

!ifdef VMEM {
!ifndef ALLRAM {
	ALLRAM = 1
}
}

!ifndef ACORN {
!ifdef ALLRAM {
!ifdef CACHE_PAGES {
	cache_pages = CACHE_PAGES ; Note, this is not final. One page may be added. vmem_cache_count will hold final # of pages.
} else {
	cache_pages = 4 ; Note, this is not final. One page may be added. vmem_cache_count will hold final # of pages.
}
}
}

!ifndef TERPNO {
	TERPNO = 8
}

!ifdef Z3 {
	ZMACHINEVERSION = 3
}
!ifdef Z4 {
	ZMACHINEVERSION = 4
	Z4PLUS = 1
}
!ifdef Z5 {
	ZMACHINEVERSION = 5
	Z4PLUS = 1
	Z5PLUS = 1
}
!ifdef Z8 {
	ZMACHINEVERSION = 8
	Z4PLUS = 1
	Z5PLUS = 1
}

!source "constants.asm"
!ifdef ACORN {
!source "acorn-constants.asm"
}

!ifdef TRACE {
	z_trace_size = 256
} else {
	z_trace_size = 0
}

!ifdef STACK_PAGES {
	stack_size = STACK_PAGES * $100;
} else {
	stack_size = $0400;
}


!ifndef COL2 {
	COL2 = 0
}
!ifndef COL3 {
	COL3 = 2
}
!ifndef COL4 {
	COL4 = 5
}
!ifndef COL5 {
	COL5 = 7
}
!ifndef COL6 {
	COL6 = 6
}
!ifndef COL7 {
	COL7 = 4
}
!ifndef COL8 {
	COL8 = 3
}
!ifndef COL9 {
	COL9 = 1
}

!ifndef BGCOL {
	BGCOL = 9
}
!ifndef FGCOL {
	FGCOL = 2
}

!ifndef BGCOLDM {
	BGCOLDM = 2
}
!ifndef FGCOLDM {
	FGCOLDM = 4
}

; Border color: 0 = as background, 1 = as foreground, 2-9: specified Z-code colour. Default: as background

!ifndef BORDERCOL {
	!ifdef Z5PLUS {
		BORDERCOL = 0
	} else {
		BORDERCOL = BGCOL
	}
}
!ifndef BORDERCOLDM {
	!ifdef Z5PLUS {
		BORDERCOLDM = 0
	} else {
		BORDERCOLDM = BGCOLDM
	}
}
; For z3 and z4, change border colour magic values 0 and 1 to actual bgcol or fgcol, for shorter code
!ifndef Z5PLUS {
	!if BORDERCOL = 0 {
		BORDERCOL_FINAL = BGCOL
	}
	!if BORDERCOL = 1 {
		BORDERCOL_FINAL = FGCOL
	}
	!if BORDERCOLDM = 0 {
		BORDERCOLDM_FINAL = BGCOLDM
	}
	!if BORDERCOLDM = 1 {
		BORDERCOLDM_FINAL = FGCOLDM
	}
}
!ifndef BORDERCOL_FINAL {
	BORDERCOL_FINAL = BORDERCOL
}
!ifndef BORDERCOLDM_FINAL {
	BORDERCOLDM_FINAL = BORDERCOLDM
}
!if BORDERCOL_FINAL = 0 {
	BORDER_MAY_FOLLOW_BG = 1
} else {
	!if BORDERCOLDM_FINAL = 0 {
		BORDER_MAY_FOLLOW_BG = 1
	}
}
!if BORDERCOL_FINAL = 1 {
	BORDER_MAY_FOLLOW_FG = 1
} else {
!if BORDERCOLDM_FINAL = 1 {
	BORDER_MAY_FOLLOW_FG = 1
}
}

!ifndef STATCOL {
	STATCOL = FGCOL
}
!ifndef STATCOLDM {
	STATCOLDM = FGCOLDM
}

!ifndef CURSORCOL {
	CURSORCOL = FGCOL
}
!ifndef CURSORCOLDM {
	CURSORCOLDM = FGCOLDM
}

!ifndef CURSORCHAR {
	CURSORCHAR = 224
}

!ifndef SPLASHWAIT {
	SPLASHWAIT = 3
}



;  * = $0801 ; This must now be set on command line: --setpc $0801

program_start

initial_jmp
!ifndef ACORN_RELOCATABLE {
    jmp .initialize
} else {
    jmp relocate
}

; global variables
; filelength !byte 0, 0, 0
; fileblocks !byte 0, 0
; c64_model !byte 0 ; 1=NTSC/6567R56A, 2=NTSC/6567R8, 3=PAL/6569
!ifndef ACORN {
!ifdef VMEM {
game_id		!byte 0,0,0,0
}
}

; include other assembly files
; SF: We move text.asm near the beginning for Acorn because it can contain a
; big "un-breakable" chunk of text, so we don't want it to come anywhere near
; the screen hole.
!ifdef ACORN {
!source "text.asm"
!source "acorn.asm"
}
!source "utilities.asm"
!source "screenkernal.asm"
!source "streams.asm"
!ifndef ACORN {
!source "disk.asm"
} else {
!source "acorn-disk.asm"
}
!ifdef VMEM {
!ifndef ACORN {
!source "reu.asm"
}
}
!ifdef ACORN {
!source "zmachine.asm"
}
!source "screen.asm"
!source "memory.asm"
!source "stack.asm"
;##!ifdef VMEM {
!source "vmem.asm"
;##}
!ifndef ACORN {
!source "zmachine.asm"
}
!source "zaddress.asm"
!ifndef ACORN {
!source "text.asm"
}
!source "dictionary.asm"
!source "objecttable.asm"

.initialize
!ifdef ACORN_RELOCATABLE {
initialize
}
!ifdef ACORN {
    ; Reset the stack pointer; setjmp relies on this.
    ldx #$ff
    txs
}
!ifdef TESTSCREEN {
    jmp testscreen
}

	jsr deletable_init_start
;	jsr init_screen_colours
	jsr deletable_screen_init_1
!ifndef ACORN {
!if SPLASHWAIT > 0 {
	jsr splash_screen
}

!ifdef VMEM {
!ifdef TARGET_C64 {
    ; set up C64 SuperCPU if any
    ; see: http://www.elysium.filety.pl/tools/supercpu/superprog.html
    lda $d0bc ; SuperCPU control register (read only)
    and #$80  ; DOS extension mode? 0 if SuperCPU, 1 if standard C64
    beq .supercpu
    ;bne .nosupercpu 
    ; it doesn't matter what you store in the SuperCPU control registers
    ; it is just the access itself that counts
    ;sta $d07e ; enable hardware registers
    ;sta $d076 ; basic optimization
    ;sta $d077 ; no memory optimization
    ;sta $d07f ; disable hardware registers
    ;sta $d07a ; normal speed (1 MHz)
}
    ; SuperCPU and REU doesn't work well together
    ; https://www.lemon64.com/forum/viewtopic.php?t=68824&sid=330a8c62e22ebd2cf654c14ae8073fb9
    ;
	jsr reu_start
.supercpu
}
}
	jsr deletable_init
    jsr parse_object_table
!ifndef Z5PLUS {
    ; Setup default dictionary
	jsr parse_default_dictionary
}

!ifdef Z5PLUS {
    ; set up terminating characters
    jsr parse_terminating_characters
}
	
	jsr streams_init
	jsr stack_init

	jsr deletable_screen_init_2
	ldx #$ff
	jsr erase_window

	jsr z_init
	jsr z_execute

!ifndef ACORN {
	; Back to normal memory banks
	+set_memory_normal

	jsr $fda3 ; init I/O
	;jsr $fd50 ; init memory
	jsr $fd15 ; set I/O vectors
	jsr $ff5b ; more init
    jmp ($a000)
} else {
clean_up_and_quit
    +clean_up_and_quit_inline
}
	
program_end

; SF: It can be helpful for testing paged RAM builds to burn some non-paged RAM.
!ifdef WASTE_BYTES {
    !fill WASTE_BYTES
}

	!align 255, 0, 0
z_trace_page
	!fill z_trace_size, 0

!ifndef ACORN {
vmem_cache_start

!ifdef ALLRAM {
	!if SPLASHWAIT > 0 {
		!source "splashscreen.asm"
	}
}

end_of_routines_in_vmem_cache

	!fill cache_pages * 256 - (* - vmem_cache_start),0 ; Typically 4 pages

!ifdef VMEM {
	!if (stack_size + *) & 256 {
		!fill 256,0 ; Add one page to avoid vmem alignment issues
	}
} 

vmem_cache_size = * - vmem_cache_start
vmem_cache_count = vmem_cache_size / 256
}

!align 255, 0, 0 ; To make sure stack is page-aligned even if not using vmem.
!ifdef ACORN {
!ifdef VMEM {
    ; The stack needs to be page-aligned. If we're using vmem, story_start needs
    ; to be at a 512-byte boundary. We don't want a gap between the stack and
    ; story_start because it will increase the size of saved games and mean
    ; they're only compatible with builds of Ozmoo with the same alignment
    ; padding, so we put the gap here.
    ; SFTODODATA-ISH MAYBE SORT OF USABLE TO SQUEEZE SOMETHING IN
    !if (stack_size & $100) = 0 {
        ; Stack is an even number of pages, so this must be a 512-byte boundary.
        !align 511, 0, 0
    } else {
        ; Stack is an odd number of pages, so this must not be a 512-byte boundary.
        !align 511, 256, 0
    }
}
}

+make_acorn_screen_hole_before_stack
stack_start

deletable_screen_init_1
	; start text output from bottom of the screen
	
!ifndef ACORN {
    lda #147 ; clear screen
    jsr s_printchar
}
	ldy #0
	sty current_window
	sty window_start_row + 3
!ifdef Z3 {
	iny
}
	sty window_start_row + 2
	sty window_start_row + 1
	+ldy_screen_height
	sty window_start_row
!ifndef ACORN {
	ldy #0
	sty is_buffered_window
	ldx #$ff
	jmp erase_window
} else {
    ; Don't clear the screen; on Acorn we are going to spend several seconds
    ; doing the preload in deletable_init so we want to leave whatever the
    ; loader left on screen up while we do that. deletable_screen_init_2 will
    ; set is_buffered_window and call erase_window so everything will still be
    ; set up properly when we start executing the game's code.
    rts
}

deletable_screen_init_2
	; start text output from bottom of the screen
	
!ifndef ACORN {
    lda #147 ; clear screen
    jsr s_printchar
} else {
    +acorn_deletable_screen_init_2_inline
}
	ldy #1
	sty is_buffered_window
	ldx #$ff
	jsr erase_window
	ldy #0
	ldx #1
	jsr set_cursor
	jmp start_buffering

z_init
!zone z_init {

!ifdef DEBUG {
!ifdef PREOPT {
	jsr print_following_string
!ifndef ACORN {
	!pet "*** vmem optimization mode ***",13,13,0
} else {
	!text "*** vmem optimization mode ***",13,13,0
}
}	
}


	ldy #0
	sty z_exe_mode ; 0 = Normal
	
!ifdef TRACE {
	; Setup trace
	lda #0
	sta z_trace_index
	tay
-	sta z_trace_page,y
	iny
	bne -
}
	
!ifdef Z3 {
	lda story_start + header_flags_1
	and #(255 - 16 - 64) ; Statusline IS available, variable-pitch font is not default
	ora #32 ; Split screen available
	sta story_start + header_flags_1
} else {
!ifdef Z4 {
	lda story_start + header_flags_1
	and #(255 - 4 - 8) ; bold font, italic font not available
	ora #(16 + 128) ; Fixed-space style, timed input available
	sta story_start + header_flags_1
} else { ; Z5PLUS
	lda story_start + header_flags_1
    !ifndef ACORN {
        COLOUR = 1
    } else {
        COLOUR = 0
    }
	and #(255 - 4 - 8 - (1 - COLOUR)) ; bold font, italic font not available
	ora #(COLOUR + 16 + 128) ; Colours, Fixed-space style, timed input available
	sta story_start + header_flags_1
	lda story_start + header_flags_2 + 1
	and #(255 - 8 - 16 - 32 - 128) ; pictures, undo, mouse, sound effect not available
	sta story_start + header_flags_2 + 1
}
}
!ifdef Z4PLUS {
	lda #TERPNO
	sta story_start + header_interpreter_number ; Interpreter number (8 = C64)
	lda #68 ; "D" = release 4
	sta story_start + header_interpreter_version ; Interpreter version. Usually ASCII code for a capital letter
	+lda_screen_height
	sta story_start + header_screen_height_lines
!ifdef Z5PLUS {
	sta story_start + header_screen_height_units + 1
}
    +lda_screen_width
	sta story_start + header_screen_width_chars
!ifdef Z5PLUS {
	sta story_start + header_screen_width_units + 1
}
}
	lda #0
	sta story_start + header_standard_revision_number ; major standard revision number which this terp complies to
	sta story_start + header_standard_revision_number + 1 ; minor standard revision number which this terp complies to

!ifdef Z5PLUS {
	; a is already 0
	sta story_start + header_screen_width_units
	sta story_start + header_screen_height_units
	lda #1
	sta story_start + header_font_width_units
	sta story_start + header_font_height_units
	; TODO: Store default background and foreground colour in 2c, 2d (or comply to game's wish?)
}
	
	; Copy alphabet pointer from header, or default
	ldx #<default_alphabet
	ldy #>default_alphabet
!ifdef Z5PLUS {
	lda story_start + header_alphabet_table
	ora story_start + header_alphabet_table + 1
	beq .no_custom_alphabet
	ldx story_start + header_alphabet_table + 1
	lda story_start + header_alphabet_table
	clc
	adc #>story_start
	tay
.no_custom_alphabet
}
	stx alphabet_table
	sty alphabet_table + 1
	
	; Copy z_pc from header
	lda #0
	ldx story_start + header_initial_pc
	ldy story_start + header_initial_pc + 1
!ifndef VMEM {
	sta z_pc
}
	jsr set_z_pc
	jsr get_page_at_z_pc

	; Setup globals pointer
	lda story_start + header_globals + 1
	clc
	adc #<(story_start - 32)
	sta z_low_global_vars_ptr
	sta z_high_global_vars_ptr
	lda story_start + header_globals
	adc #>(story_start - 32)
	sta z_low_global_vars_ptr + 1
	adc #1
	sta z_high_global_vars_ptr + 1 

!ifndef ACORN {
	; Init sound
	lda #0
	ldx #$18
-	sta $d400,x
	dex
	bpl -
	lda #$f
	sta $d418
	lda #$00
	sta $d405
	lda #$f2
	sta $d406
	
	; Init randomization
	lda #$ff
	sta $d40e
	sta $d40f
	ldx #$80
	stx $d412
}
!ifdef BENCHMARK {
!ifdef ACORN {
    ; Populate A and X with the values they would have had if we'd done the
    ; C64 init randomization above.
	lda #$ff
	ldx #$80
}
	ldy #1
	jmp z_rnd_init
} else {
	jmp z_rnd_init_random
}
}

!zone deletable_init {
!ifndef ACORN {
deletable_init_start
!ifdef CUSTOM_FONT {
    lda #18
} else {
	lda #23
}
    sta reg_screen_char_mode
	lda #$80
	sta charset_switchable
	jmp init_screen_colours ; _invisible
}

deletable_init
	cld
!ifndef ACORN {
    ; ; check if PAL or NTSC (needed for read_line timer)
; w0  lda $d012
; w1  cmp $d012
    ; beq w1
    ; bmi w0
    ; and #$03
    ; sta c64_model
    ; enable lower case mode

; Read and parse config from boot disk
	; $BA holds last used device#
	ldy $ba
	cpy #8
	bcc .pick_default_boot_device
	cpy #12
	bcc .store_boot_device
.pick_default_boot_device
	ldy #8
.store_boot_device
	sty boot_device ; Boot device# stored

!ifdef VMEM {
	lda #<config_load_address
	sta readblocks_mempos
	lda #>config_load_address
	sta readblocks_mempos + 1
	lda #CONF_TRK
	ldx #0
; No need to load y with boot device#, already in place
	jsr read_track_sector
	inc readblocks_mempos + 1
	lda #CONF_TRK
	ldx #1
	ldy boot_device
	jsr read_track_sector
;    jsr kernal_readchar   ; read keyboard
; Copy game id
	ldx #3
-	lda config_load_address,x
	sta game_id,x
	dex
	bpl -
; Copy disk info
	ldx config_load_address + 4
	dex
-	lda config_load_address + 4,x
	sta disk_info - 1,x
	dex
	bne -
	
	jsr auto_disk_config
;	jsr init_screen_colours
} else { ; End of !ifdef VMEM
	sty disk_info + 4
	ldx #$30 ; First unavailable slot
	lda story_start + header_static_mem
	clc
	adc #(>stack_size) + 4
	sta zp_temp
	lda #>664
	sta zp_temp + 1
	lda #<664
.one_more_slot
	sec
	sbc zp_temp
	tay
	lda zp_temp + 1
	sbc #0
	sta zp_temp + 1
	bmi .no_more_slots
	inx
	cpx #$3a
	bcs .no_more_slots
	tya
	bcc .one_more_slot ; Always branch
.no_more_slots
	stx first_unavailable_save_slot_charcode
	txa
	and #$0f
	sta disk_info + 1 ; # of save slots
}

	; ldy #0
	; ldx #0
	; jsr set_cursor
	
	; Default banks during execution: Like standard except Basic ROM is replaced by RAM.
	+set_memory_no_basic
} else {
    +acorn_deletable_init_inline
}

; parse_header section

!ifndef UNSAFE {
    ; check z machine version
    lda story_start + header_version
	cmp #ZMACHINEVERSION
	beq .supported_version
    lda #ERROR_UNSUPPORTED_STORY_VERSION
    jsr fatalerror
.supported_version
}

	; Check how many z-machine memory blocks (256 bytes each) are not stored in raw disk sectors
!ifdef VMEM {
!ifndef ACORN {
	ldy story_start + header_static_mem
	lda story_start + header_static_mem + 1
	beq .maybe_inc_nonstored_blocks
	iny ; Add one page if statmem doesn't start on a new page ($xx00)
.maybe_inc_nonstored_blocks
	tya
    and #255 - vmem_blockmask ; keep index into kB chunk
	beq .store_nonstored_blocks
	iny
!ifndef SMALLBLOCK {
	bne .maybe_inc_nonstored_blocks ; Always branch
}
.store_nonstored_blocks
	sty nonstored_blocks
	tya
	clc
	adc #>story_start
	sta vmap_first_ram_page
	lda #0
	sec
	sbc vmap_first_ram_page
	lsr
!ifndef SMALLBLOCK {
	lsr
} else {
	; This space constraint can not be a problem with big (1KB) vmem blocks.
	cmp #vmap_max_size ; Maximum space available
	bcc ++
	lda #vmap_max_size
++	sta vmap_max_entries
}
}

!ifdef VMEM_STRESS {
    lda #2 ; one block for PC, one block for data
	sta vmap_max_entries
}

	jsr prepare_static_high_memory

!ifndef ACORN {
	jsr insert_disks_at_boot

	lda use_reu
	bne .dont_preload
	jsr load_suggested_pages
.dont_preload
}

} ; End of !ifdef VMEM

   ; ; check file length
    ; ; Start by multiplying file length by 2
	; lda #0
	; sta filelength
    ; lda story_start + header_filelength
	; sta filelength + 1
    ; lda story_start + header_filelength + 1
	; asl
	; rol filelength + 1
	; rol filelength
; !ifdef Z4PLUS {
    ; ; Multiply file length by 2 again (for Z4, Z5 and Z8)
	; asl
	; rol filelength + 1
	; rol filelength
; !ifdef Z8 {
    ; ; Multiply file length by 2 again (for Z8)
	; asl
	; rol filelength + 1
	; rol filelength
; }
; }
	; sta filelength + 2
	; ldy filelength
	; ldx filelength + 1
	; beq +
	; inx
	; bne +
	; iny
; +	sty fileblocks
	; stx fileblocks + 1
	rts
}

!ifdef VMEM {
!ifndef ACORN {
!zone disk_config {
auto_disk_config
; Limit # of save slots to no more than 10
	lda disk_info + 1
	cmp #11
	bcc +
	lda #10
	sta disk_info + 1
	clc
+	adc #$30
	sta first_unavailable_save_slot_charcode 

; Figure out best device# for all disks set to auto device# (value = 0)
	lda #0
	tay ; Disk#
.next_disk
	tax ; Memory index
	lda disk_info + 4,x
	bne .device_selected
	cpy #2
	bcs .not_save_or_boot_disk
	; This is the save or boot disk
	lda boot_device
	bne .select_device ; Always branch
.not_save_or_boot_disk
	stx zp_temp ; Store current value of x (memory pointer)
	ldx boot_device
	bit use_reu
	bmi .use_this_device
	ldx #8
-	lda device_map - 8,x
	beq .use_this_device
	inx
	bne - ; Always branch
.use_this_device
	txa
	ldx zp_temp ; Retrieve current value of x (memory pointer)
.select_device
	sta disk_info + 4,x
.device_selected
	sta zp_temp + 1 ; Store currently selected device#
	lda disk_info + 7,x
	beq +
	; This is a story disk
	txa ; Save value of x
	ldx zp_temp + 1 ; Load currently selected device#
	inc device_map - 8,x ; Mark device as in use by a story disk
	tax
+	iny
	cpy disk_info + 2 ; # of disks
	bcs .done
	txa
	adc disk_info + 3,x
	bne .next_disk ; Always branch
.done
	rts
}
!zone insert_disks_at_boot {
insert_disks_at_boot
;	jsr dollar
;	jsr kernal_readchar
	jsr prepare_for_disk_msgs
	lda #0
	tay ; Disk#
.next_disk
	tax ; Memory index
	cpy #1
	bcc .dont_need_to_insert_this
	; Store in current_disks
	lda disk_info + 4,x
	stx zp_temp
	tax
	lda zp_temp
	sta current_disks - 8,x
	tax
	cpy #2
	bcc .copy_data_from_disk_1_to_reu
	stx zp_temp
	sty zp_temp + 1
	ldy zp_temp
	jsr print_insert_disk_msg
	ldx use_reu
	beq .restore_xy_disk_done
	jsr copy_data_from_disk_at_zp_temp_to_reu
.restore_xy_disk_done
	ldx zp_temp
	ldy zp_temp + 1
.dont_need_to_insert_this
+	iny
	cpy disk_info + 2 ; # of disks
	bcs .done
	txa
	adc disk_info + 3,x
	bne .next_disk ; Always branch
.done
	lda use_reu
	beq +
	lda #$ff ; Use REU
	sta use_reu
+	rts
	
.copy_data_from_disk_1_to_reu
	lda use_reu
	bpl .dont_need_to_insert_this

	sty zp_temp + 1

	; Prepare for copying data to REU
	lda #0
	ldx nonstored_blocks
	stx z_temp ; Lowbyte of current page in Z-machine memory
	sta z_temp + 1 ; Highbyte of current page in Z-machine memory
	ldx #1
	stx z_temp + 2 ; Lowbyte of current page in REU memory
	sta z_temp + 3 ; Highbyte of current page in REU memory
	sta z_temp + 6 ; Sector# to read next, lowbyte
	sta z_temp + 7 ; Sector# to read next, highbyte
	
	jsr copy_data_from_disk_at_zp_temp_to_reu
	jmp .restore_xy_disk_done

copy_data_from_disk_at_zp_temp_to_reu
; zp_temp holds memory index into disk_info where info on this disk begins
; Perform initial copy of data to REU	
	ldx zp_temp
	lda disk_info + 6,x
	sta z_temp + 4 ; Last sector# on this disk. Store low-endian
	lda disk_info + 5,x
	sta z_temp + 5 ; Last sector# on this disk. Store low-endian

.initial_copy_loop
	lda z_temp + 6
	cmp z_temp + 4
	lda z_temp + 7
	sbc z_temp + 5
	bcs .done_copying

	lda z_temp + 1
	ldx z_temp ; (Not) Already loaded
	sta $7fd
	stx $7fe
	ldy #0 ; Value is unimportant except for the last block, where anything > 0 may be after file end
	jsr read_byte_at_z_address
	; Current Z-machine page is now in C64 page held in mempointer + 1
	lda z_temp + 3
	ldx z_temp + 2
	ldy mempointer + 1
	jsr copy_page_to_reu
	bcs .reu_error

	ldx z_temp ; (Not) Already loaded
	stx $7ff

	; Inc Z-machine page
	inc z_temp
	bne +
	inc z_temp + 1

	; Inc REU page
+	inc z_temp + 2
	bne +
	inc z_temp + 3

	; Inc disk block#
+	inc z_temp + 6
	bne +
	inc z_temp + 7
+	bne .initial_copy_loop ; Always branch

.done_copying
	rts

.reu_error
	lda #0
	sta use_reu
	lda #>.reu_error_msg
	ldx #<.reu_error_msg
	jsr printstring_raw
-	jsr kernal_getchar
    beq -
	rts

.reu_error_msg
    !pet "REU error. [SPACE]",0

copy_page_to_reu
	; a,x = REU page
	; y = C64 page
	jsr store_reu_transfer_params
	lda #%10010000;  c64 -> REU with immediate execution
	sta reu_command
	rts

.no_reu
	lda #78 + 128
.print_reply_and_return
	jsr s_printchar
	lda #13
	jsr s_printchar
.no_reu_present	
	rts

reu_start
	lda #0
	sta use_reu
	sta $c6 ; Empty keyboard buffer
	ldx reu_c64base
	inc reu_c64base
	inx
	cpx reu_c64base
	bne .no_reu_present
; REU detected
	lda #>.use_reu_question
	ldx #<.use_reu_question
	jsr printstring_raw
-	jsr kernal_getchar
    beq -
	cmp #89
	bne .no_reu
	ldx #$80 ; Use REU, set vmem to reu loading mode
	stx use_reu
	ora #$80
	bne .print_reply_and_return ; Always branch
.use_reu_question
    !pet 13,"Use REU? (Y/N) ",0

}
}

prepare_static_high_memory
    lda #$ff
    sta zp_pc_h
    sta zp_pc_l

; ; Clear vmap_z_h
	; ldy vmap_max_entries
	lda #0
; -	sta vmap_z_h - 1,y
	; dey
	; bne -

; Clear quick index
	ldx #vmap_quick_index_length
-	sta vmap_next_quick_index,x ; Sets next quick index AND all entries in quick index to 0
	dex
	bpl -
	
!ifndef ACORN {
	lda #5
	clc
	adc config_load_address + 4
	sta zp_temp
	lda #>config_load_address
;	adc #0 ; Not needed if disk info is always <= 249 bytes
	sta zp_temp + 1
	ldy #0
	lda (zp_temp),y ; # of blocks in the list
	tax
	cpx vmap_max_entries
	bcc +
	beq +
	ldx vmap_max_entries
+	stx vmap_used_entries  ; Number of bytes to copy
	iny
	lda (zp_temp),y
	sta vmap_blocks_preloaded ; # of blocks already loaded

	; If using REU, suggested blocks will just be ignored
	bit use_reu
	bpl +
	sta vmap_used_entries
+
;	sta zp_temp + 3 ; # of blocks already loaded

; Copy to vmap_z_h
-	iny
	lda (zp_temp),y
	sta vmap_z_h - 2,y
	dex
	bne -
	
	; ldy #vmap_max_length - 1
; -	lda vmap_z_h,y
	; and #%01000000 ; Check if non-swappable memory
	; bne .dont_set
	; sty vmap_first_swappable_index
	; dey
	; bpl -
; .dont_set
	
; Point to lowbyte array	
	ldy #0
	lda (zp_temp),y
	clc
	adc zp_temp
	adc #2
	sta zp_temp
	ldy vmap_used_entries
	beq .no_entries
	dey
-	lda (zp_temp),y
	sta vmap_z_l,y
	dey
	bpl -
.no_entries
} else { ; ACORN
!ifdef PREOPT {
    ; vmap_used_entries can't be 0. SFTODO: I think?
    lda #1
    sta vmap_used_entries
    sta vmap_clock_index
} else {
    ; +acorn_deletable_init_inline will initialise vmap_used_entries and we can
    ; just leave vmap_clock_index at its default value of 0.
}
}
!ifdef TRACE_VM {
    jsr print_vm_map
}
	rts
	
!ifndef ACORN {
load_suggested_pages
; Load all suggested pages which have not been pre-loaded
-	lda vmap_blocks_preloaded ; First index which has not been loaded
	beq ++ ; First block was loaded with header
	cmp vmap_used_entries ; Total # of indexes in the list
	bcs +
	; jsr dollar
	sta vmap_index
	tax ; SF: I think this is redundant
	jsr load_blocks_from_index
++	inc vmap_blocks_preloaded
	bne - ; Always branch
+
	ldx vmap_used_entries
	cpx vmap_max_entries
	bcc +
	dex
+	stx vmap_clock_index

!ifdef TRACE_VM {
    jsr print_vm_map
}
    rts
}
} 

!ifndef ACORN {
!ifndef ALLRAM {
	!if SPLASHWAIT > 0 {
		!source "splashscreen.asm"
	}
}
}

!ifdef ACORN {
    +acorn_init_code_in_stack
}

end_of_routines_in_stack_space
!ifdef ACORN {
    ; It's fine for code to spill over past story_start *as long as it's going
    ; to be executed before it gets overwritten*. We don't have any preload data
    ; attached, unlike the C64, so this doesn't cause problems.
    +acorn_init_code_overlapping_game_data
!ifdef ACORN_RELOCATABLE {
    ; This must be the last thing in the executable.
	ACORN_RELOCATE_WITH_DOUBLE_PAGE_ALIGNMENT = 1
    !source "acorn-relocate.asm"
}
end_of_routines
}

!ifndef ACORN {
	!fill stack_size - (* - stack_start),0 ; 4 pages
story_start
} else {
!if (end_of_routines_in_stack_space - stack_start) > stack_size {
    !error "Routines in stack space have overflowed stack"
}
!ifndef ACORN_ELECTRON_SWR {
story_start = stack_start + stack_size
} else {
extra_vmem_start = stack_start + stack_size
story_start = $8000
}
}
!if (story_start & 0xff) != 0 {
    !error "story_start must be page-aligned"
}
!ifdef VMEM {
vmem_start = story_start
!if (vmem_start & 0x1ff) != 0 {
    !error "vmem_start must be at a 512-byte boundary"
}

!ifndef ACORN {
!ifdef ALLRAM {

!if $10000 - vmem_start > $cc00 {
	vmem_end = vmem_start + $cc00
} else {
	vmem_end = $10000
}

} else {
	vmem_end = $d000
}	
}

}

!ifndef ACORN {
!ifdef vmem_cache_size {
!if vmem_cache_size >= $200 {
	config_load_address = vmem_cache_start
}
}
!ifndef config_load_address {
	config_load_address = $0400
}
}

!ifdef ACORN_NO_SHADOW {
    +check_acorn_screen_hole
}

; SFTODO: It might be possible to use the 12K private RAM in the B+ as sideways
; RAM. If we put it last in the list of RAM banks, it probably wouldn't require
; too much special casing - we'd just make sure not to count it as a full 16K
; during the initial load, then I suspect it would mostly "just work". (Though
; this would clash with e.g. my "private RAM MMFS"; it might be prudent to ask
; the user if we can use the 12K private RAM, since unlike normal SWR we can't
; reasonably detect if it's in use or not. And we can't check for PAGE=&E00
; because they could be using the more common SWMMFS in a regular sideways RAM
; bank and have the 12K private RAM free.) - actually, would need to check, but
; I think in practice "do any extended vectors point into a bank with top bit
; set?" might be a reliable way to detect private 12K use, I *think* the MMFS+
; variant will do that too.
