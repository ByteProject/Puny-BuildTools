
!ifndef ACORN {
!ifdef ALLRAM {
vmem_cache_cnt !byte 0         ; current execution cache
vmem_cache_index !fill cache_pages + 1, 0
}
}

!ifndef VMEM {
; Non-virtual memory

!ifndef ALLRAM {
read_byte_at_z_address
read_byte_at_z_address_for_z_pc
    ; Subroutine: Read the contents of a byte address in the Z-machine
    ; x,y (high, low) contains address.
    ; Returns: value in a
    sty mempointer ; low byte unchanged
    ; same page as before?
    cpx zp_pc_l
    bne .read_new_byte
    ; same 256 byte segment, just return
-	ldy #0
	lda (mempointer),y
	rts
.read_new_byte
	txa
    sta zp_pc_l
	clc
	adc #>story_start
	sta mempointer + 1
	jmp - ; Always branch
} else {
; No vmem, but ALLRAM 
!ifdef ACORN {
    !error "ALLRAM only supported/needed with VMEM on Acorn"
}

read_byte_at_z_address
read_byte_at_z_address_for_z_pc
    ; Subroutine: Read the contents of a byte address in the Z-machine
    ; a,x,y (high, mid, low) contains address.
    ; Returns: value in a
    sty mempointer ; low byte unchanged
    ; same page as before?
    cpx zp_pc_l
    bne .read_new_byte
    ; same 256 byte segment, just return
.return_result
	ldy #0
	lda (mempointer),y
	rts
.read_new_byte
	txa
    sta zp_pc_l
	clc
	adc #>story_start
	sta mempointer + 1
	cmp #first_banked_memory_page
	bcc .return_result ; Always branch
; swapped memory
	; ; Carry is already clear
	; adc #>story_start
	; sta vmap_c64_offset
	; cmp #first_banked_memory_page
    ; bcc .unswappable
    ; this is swappable memory
    ; update vmem_cache if needed
	; Check if this page is in cache
    ldx #vmem_cache_count - 1
-   cmp vmem_cache_index,x
    beq .cache_updated
    dex
    bpl -
	; The requested page was not found in the cache
    ; copy vmem to vmem_cache (banking as needed)
	ldx vmem_cache_cnt
	; Protect page held in z_pc_mempointer + 1
	pha
	txa
	clc
	adc #>vmem_cache_start
	cmp z_pc_mempointer + 1
	bne +
	inx
	cpx #vmem_cache_count
	bcc ++
	ldx #0
++	stx vmem_cache_cnt

+	pla
	sta vmem_cache_index,x
	pha
    lda #>vmem_cache_start ; start of cache
    clc
    adc vmem_cache_cnt
	tay
	pla
	jsr copy_page
    ; set next cache to use when needed
	inx
	txa
	dex
	cmp #vmem_cache_count
	bcc ++
	lda #0
++	sta vmem_cache_cnt
.cache_updated
    ; x is now vmem_cache (0-4) where we want to read
    txa
    clc
    adc #>vmem_cache_start
    sta mempointer + 1
	jmp .return_result 
} ; End of block for ALLRAM=1
	
} else {
; virtual memory

; virtual memory address space
; Z1-Z3: 128 kB (0 - $1ffff)
; Z4-Z5: 256 kB (0 - $3ffff)
; Z6-Z8: 512 kB (0 - $7ffff)
;
; map structure: one entry for each block (512 bytes) of available virtual memory
; each map entry is:
; 1 byte: ZMachine offset high byte (1-3 lowest bits used for ZMachine offset, the rest used to store ticks since block was last used)
; 1 byte: ZMachine offset low byte
;
; needs 102*2=204 bytes for $3400-$FFFF
; will store in datasette_buffer
;

!ifdef SMALLBLOCK {
	vmem_blocksize = 512
} else {
	vmem_blocksize = 1024 ; This hasn't been used in a long time, and probably doesn't work anymore.
!ifdef ACORN {
    ; Given the above comment I've not made any attempt to make this work on
    ; Acorn.
    !error "VMEM only supports SMALLBLOCK on Acorn"
}
}


vmem_blockmask = 255 - (>(vmem_blocksize - 1))
vmem_block_pagecount = vmem_blocksize / 256
; vmap_max_length  = (vmem_end-vmem_start) / vmem_blocksize
; vmap_max_size determines the memory allocated for the vmap; vmap_max_entries
; is the actual run-time limit, which may be less than vmap_max_size but
; obviously can't be larger.
; SFTODO: For a Z3 game 255 is actually likely (not guaranteed) to be slightly
; too large. Not necessarily a problem, but think about it - will there be a
; problem? Are we wasting (a few bytes only) of RAM for no good reason?
!ifndef ACORN {
vmap_max_size = 102
} else {
!ifndef ACORN_SWR {
!ifndef ACORN_TUBE_CACHE {
!ifdef ACORN_TURBO_SUPPORTED {
; A turbo second processor has enough RAM to hold 255 512-byte blocks.
vmap_max_size = 255
ACORN_LARGE_RUNTIME_VMAP = 1
} else {
; If a game had no dynamic memory we'd have room for about 100 512-byte VM
; blocks on the second processor. Let's say every game will have at least 6K of
; dynamic memory, so we've got room for about 88 512-byte VM blocks.
vmap_max_size = 88
}
} else {
; The host cache is initialised using "extra" entries in the vmap.
vmap_max_size = 255
!ifdef ACORN_TURBO_SUPPORTED {
; A turbo second processor has enough RAM to hold 255 512-byte blocks.
ACORN_LARGE_RUNTIME_VMAP = 1
} else {
; We *don't* set ACORN_LARGE_RUNTIME_VMAP; after the initial preload of the host
; cache, vmap_max_entries will be approximately 88 because the vmap is only
; concerned with the second processor's own 64K.
}
}
} else {
; We might have enough main+sideways RAM to hold 255 512-byte blocks.
vmap_max_size = 255
ACORN_LARGE_RUNTIME_VMAP = 1
}
}
; vmap_max_entries	!byte 0 ; Moved to ZP
; vmap_used_entries	!byte 0 ; Moved to ZP
!ifndef ACORN {
vmap_blocks_preloaded !byte 0
}
vmap_z_h = datasette_buffer_start
vmap_z_l = vmap_z_h + vmap_max_size

;SFTODODATA 1
vmap_clock_index !byte 0        ; index where we will attempt to load a block next time

!ifndef ACORN {
vmap_first_ram_page		!byte 0
vmap_c64_offset !byte 0
} else {
!ifndef ACORN_SWR {
vmap_first_ram_page		!byte ACORN_INITIAL_NONSTORED_BLOCKS + >story_start
vmap_c64_offset !byte 0
}
}
vmap_index !byte 0              ; current vmap index matching the z pointer
vmem_offset_in_block !byte 0         ; 256 byte offset in 512 byte block (0-1)
; vmem_temp !byte 0

vmem_tick 			!byte $e0
vmem_oldest_age		!byte 0
vmem_oldest_index	!byte 0

!ifdef Z8 {
	vmem_tick_increment = 8
	vmem_highbyte_mask = $07
} else {
!ifdef Z3 {
	vmem_tick_increment = 2
	vmem_highbyte_mask = $01
} else {
	vmem_tick_increment = 4
	vmem_highbyte_mask = $03
}
}

!ifdef COUNT_SWAPS {
vmem_swap_count !byte 0,0
}

!ifdef ACORN_TURBO_SUPPORTED {
!macro acorn_adc_vmap_first_ram_page_or_set_mempointer_turbo_bank_from_c {
    ; If we're running on a normal second processor, carry will be clear and we
    ; need to do "adc vmap_first_ram_page". Note that we can't treat this as a
    ; no-op on a turbo second processor simply by setting vmap_first_ram_page to
    ; 0, because on a turbo second processor carry may be set.
    ;
    ; If we're running on a turbo second processor, set mempointer_turbo_bank to
    ; select virtual memory cache bank C, i.e. bank 1+C (bank 0 is used for code
    ; and dynamic memory). This must preserve A, X and Y.
    bit is_turbo
    bpl .is_normal_second_processor
    stz mempointer_turbo_bank
    rol mempointer_turbo_bank
    inc mempointer_turbo_bank
    bra .done
.is_normal_second_processor
	; Carry is already clear
	adc vmap_first_ram_page
.done
}
}

+make_acorn_screen_hole
!ifdef DEBUG {
!ifdef PREOPT {
print_optimized_vm_map
	stx zp_temp ; Nonzero means premature exit
!ifdef ACORN {
.handle = zp_temp + 1
    lda #0
    sta .handle
    ldx #2
    ldy #error_print_s_printchar
    jsr setjmp
    beq .print_optimized_vm_map_no_error
    ldy .handle
    beq .not_open
    lda #osfind_close ; 0
    sta .handle
    jsr osfind
.not_open
    jsr error_print_following_string
    !text 13, "Press SPACE to retry...", 0
    jsr wait_for_space
.print_optimized_vm_map_no_error
    lda #osfind_open_output
    ldx #<.preopt_filename
    ldy #>.preopt_filename
    jsr osfind
    sta .handle
}
	jsr printchar_flush
	lda #0
	sta streams_output_selected + 2
	sta is_buffered_window
	jsr newline
	jsr dollar
	jsr dollar
	jsr dollar
	jsr print_following_string
	!pet "clock",13,0
	ldx #0
-	lda vmap_z_h,x
!ifdef ACORN {
    ldy .handle
    jsr osbput
}
	jsr print_byte_as_hex
	lda vmap_z_l,x
!ifdef ACORN {
    ldy .handle
    jsr osbput
}
	jsr print_byte_as_hex
	jsr colon
	inx
	cpx vmap_used_entries
	bcc -

	lda zp_temp
	bne +++
	; Print block that was just to be read
	lda zp_pc_h
!ifdef ACORN {
    ldy .handle
    jsr osbput
}
	jsr print_byte_as_hex
	lda zp_pc_l
	and #vmem_blockmask
!ifdef ACORN {
    ldy .handle
    jsr osbput
}
	jsr print_byte_as_hex
	jsr colon
	
+++	jsr newline
	jsr dollar
	jsr dollar
	jsr dollar
	jsr newline
!ifndef ACORN {
    jsr kernal_readchar   ; read keyboard
    jmp kernal_reset      ; reset
} else {
    lda #osfind_close
    ldy .handle
    jsr osfind
	jsr print_following_string
    !text "Saved PREOPT - press BREAK", 0
-   jmp -

.preopt_filename
    !text "PREOPT", 13
}
}

!ifdef TRACE_VM {
print_vm_map
!zone {
!ifndef ACORN {
    ; print caches
    jsr space
    lda #66
    jsr streams_print_output
    jsr space
    lda vmem_cache_cnt
    jsr printa
    jsr space
    jsr dollar
    lda vmem_cache_index
    jsr print_byte_as_hex
    jsr space
    jsr dollar
    lda vmem_cache_index + 1
    jsr print_byte_as_hex
    jsr space
    jsr dollar
    lda vmem_cache_index + 2
    jsr print_byte_as_hex
    jsr space
    jsr dollar
    lda vmem_cache_index + 3
    jsr print_byte_as_hex
}
    jsr newline
    ldy #0
-	; print
!ifdef ACORN_SWR {
    cpy #100
    bcs +
    jsr space ; alignment when <100
}
    cpy #10
    bcs +
    jsr space ; alignment when <10
+   jsr printy
    jsr space
    lda vmap_z_h,y ; zmachine mem offset ($0 - 
    ; SF: I changed the masks here, I think this is correct but it is a
    ; divergence from upstream.
    and #($ff xor vmem_highbyte_mask)
    jsr print_byte_as_hex
    jsr space
    jsr dollar
    lda vmap_z_h,y ; zmachine mem offset ($0 - 
    and #vmem_highbyte_mask
    jsr printa
    lda vmap_z_l,y ; zmachine mem offset ($0 - 
    jsr print_byte_as_hex
    lda #0 ; add 00
    jsr print_byte_as_hex
    ; SF: For ACORN_SWR we don't try to calculate the physical address of the
    ; VM block as it's moderately involved.
!ifndef ACORN_SWR {
    jsr space
	tya
	asl
!ifndef SMALLBLOCK {
	asl
}
!ifdef ACORN_TURBO_SUPPORTED {
    bit is_turbo
    bpl +
    pha
    lda #1
    adc #0
    jsr print_byte_as_hex
    pla
    bra .skip_adc_vmap_first_ram_page
+
}
	adc vmap_first_ram_page
.skip_adc_vmap_first_ram_page
    jsr print_byte_as_hex
    lda #$30
    jsr streams_print_output
    lda #$30
    jsr streams_print_output
}
    jsr newline
.next_entry
    iny 
    cpy vmap_used_entries
    bcc -
    rts
}
}
}

load_blocks_from_index
    ; vmap_index = index to load
    ; side effects: a,y,x,status destroyed
!ifdef TRACE_FLOPPY {
	jsr dollar
	jsr dollar
	lda vmap_index
	jsr print_byte_as_hex
	jsr comma
	tax
	lda vmap_z_h,x
	jsr print_byte_as_hex
	lda vmap_z_l,x
	jsr print_byte_as_hex
}

!ifndef ACORN_SWR {
	lda vmap_index
	tax
	asl
!ifndef SMALLBLOCK {
	asl
}
!ifndef ACORN_TURBO_SUPPORTED {
	; Carry is already clear
	adc vmap_first_ram_page
} else {
    +acorn_adc_vmap_first_ram_page_or_set_mempointer_turbo_bank_from_c
}

; SFTODO: Maybe add some tracing for this
!ifdef ACORN_TUBE_CACHE {
    ; Offer the cache on the host a chance to save the block we're about to
    ; evict from our cache, and ask it if it has the block we want before we
    ; go to disk for it.
    sta osword_cache_data_ptr + 1
!ifdef ACORN_TURBO_SUPPORTED {
    ; If we're on a normal second processor this is redundant but harmless, and
    ; it's only one cycle slower to just do it rather than check if we need to
    ; do it first.
    lda mempointer_turbo_bank
    sta osword_cache_data_ptr + 2
}
    ; Other bytes at osword_cache_data_ptr always stay 0 and don't need setting.
    lda vmap_z_l,x
    sta osword_cache_index_requested
    lda vmap_z_h,x
    and #vmem_highbyte_mask
    sta osword_cache_index_requested + 1
    lda #osword_cache_op
    ldx #<osword_cache_block
    ldy #>osword_cache_block
    jsr osword
    lda osword_cache_result
    beq load_blocks_from_index_done ; Host cache has provided the block
    ; The host cache didn't have the block we want. Restore A and X and fall
    ; through to the following code to get it from disk.
    lda osword_cache_data_ptr + 1
    ldx vmap_index
}
} else { ; ACORN_SWR
    ldx vmap_index
    jsr convert_index_x_to_ram_bank_and_address
}

!ifdef TRACE_FLOPPY {
	jsr comma
	jsr print_byte_as_hex
}
	tay ; Store in y so we can use it later.
;	cmp #$e0
;	bcs +
!ifndef ACORN {
    cmp #first_banked_memory_page
    bcs load_blocks_from_index_using_cache
}
+	lda #vmem_block_pagecount ; number of blocks
	sta readblocks_numblocks
    lda #0
    sta readblocks_mempos
	sty readblocks_mempos + 1
!ifdef ACORN_TURBO_SUPPORTED {
    ; If we're on a normal second processor this is redundant but harmless, and
    ; it's only one cycle slower to just do it rather than check if we need to
    ; do it first.
    lda mempointer_turbo_bank
    sta readblocks_mempos + 2
}
	lda vmap_z_l,x ; start block
	sta readblocks_currentblock
	lda vmap_z_h,x ; start block
	and #vmem_highbyte_mask
	sta readblocks_currentblock + 1
	jsr readblocks
load_blocks_from_index_done ; except for any tracing
!ifdef TRACE_VM {
    jsr print_following_string
!ifndef ACORN {
    !pet "load_blocks (normal) ",0
} else {
    !text "load_blocks (normal) ",0
}
    jsr print_vm_map
}
    rts

!ifdef ACORN_TUBE_CACHE {
osword_cache_block
    !byte 12 ; send block length
    !byte 12 ; receive block length
osword_cache_data_ptr
    !word 0  ; data address low
    !word 0  ; data address high
osword_cache_index_offered
    !word 0  ; block index offered
osword_cache_index_offered_timestamp_hint
    !byte 0  ; block offered timestamp hint
osword_cache_index_requested
    !word 0  ; block index requested
osword_cache_result
    !byte 0  ; result
}

!ifndef ACORN {
load_blocks_from_index_using_cache
    ; vmap_index = index to load
    ; vmem_cache_cnt = which 256 byte cache use as transfer buffer
	; y = first c64 memory page where it should be loaded
    ; side effects: a,y,x,status destroyed
    ; initialise block copy function (see below)

	; Protect buffer which z_pc points to
	lda vmem_cache_cnt
	tax
	clc
	adc #>vmem_cache_start
	cmp z_pc_mempointer + 1
	bne +
	inx
	cpx #vmem_cache_count
	bcc ++
	ldx #0
++	stx vmem_cache_cnt
+
    ldx vmap_index
    lda #>vmem_cache_start ; start of cache
    clc
    adc vmem_cache_cnt
	sta vmem_temp
	sty vmem_temp + 1
    ldx #0 ; Start with page 0 in this 1KB-block
    ; read next into vmem_cache
-   lda #>vmem_cache_start ; start of cache
    clc
    adc vmem_cache_cnt
    sta readblocks_mempos + 1
    txa
    pha
    ldx vmap_index
    ora vmap_z_l,x ; start block
    sta readblocks_currentblock
    lda vmap_z_h,x ; start block
    and #vmem_highbyte_mask
    sta readblocks_currentblock + 1
    jsr readblock
    ; copy vmem_cache to block (banking as needed)
	lda vmem_temp
	ldy vmem_temp + 1
	jsr copy_page
	inc vmem_temp + 1
    pla
    tax
    inx
	cpx #vmem_block_pagecount ; read 2 or 4 blocks (512 or 1024 bytes) in total
    bcc -

	ldx vmem_temp + 1
	dex
	txa
	ldx vmem_cache_cnt
    sta vmem_cache_index,x
    rts
}

+make_acorn_screen_hole
; SF: Note that this is allowed to corrupt X and Y.
read_byte_at_z_address
    ; Subroutine: Read the contents of a byte address in the Z-machine
    ; a,x,y (high, mid, low) contains address.
    ; Returns: value in a
    sty mempointer ; low byte unchanged
    ; same page as before?
    cpx zp_pc_l
    bne .read_new_byte
    cmp zp_pc_h
    bne .read_new_byte
    ; same 256 byte segment, just return
!ifdef ACORN_SWR {
    +acorn_page_in_bank_using_a mempointer_ram_bank
}
-   ldy #0
	lda (mempointer),y
!ifdef ACORN_SWR {
    +acorn_swr_page_in_default_bank_using_y
}
!if 1 { ; SFTODO: JUST TO PROVE IT'S OK
    ldx #42
    ldy #86
}
	rts
.read_new_byte
	cmp #0
	bne .non_dynmem
	cpx nonstored_blocks
	bcs .non_dynmem
	; Dynmem access
	sta zp_pc_h
	txa
    sta zp_pc_l
	adc #>story_start
	sta mempointer + 1
!ifdef ACORN_TURBO_SUPPORTED {
    ; We need to ensure bank 0 is accessed for dynamic memory on a turbo second
    ; processor. This isn't necessary on an ordinary second processor, but it's
    ; harmless and it's faster to just do it rather than check if it's
    ; necessary.
    stz mempointer_turbo_bank
    bra -
} else {
!ifndef ACORN_SWR_BIG_DYNMEM {
    ; SF: On an ACORN_SWR_SMALL_DYNMEM build, all dynamic memory is in main
    ; RAM so it doesn't matter what the value of mempointer_ram_bank is or which
    ; bank is currently paged in.
	bne - ; Always branch
} else {
    ; We have to set mempointer_ram_bank correctly so subsequent calls to
    ; read_byte_at_z_address don't page in the wrong bank. We keep the first
    ; bank paged in by default, so we don't need to page it in now and therefore
    ; the '-' label can be after the page in code, to save a few cycles.
    lda ram_bank_list
    sta mempointer_ram_bank
    bpl - ; Always branch SFTODO THIS WON'T WORK IF WE START SUPPORT 12K PRIVATE RAM ON B+
}
}
.non_dynmem
	sta zp_pc_h
	sta vmem_temp + 1
	lda #0
	sta vmap_quick_index_match
    txa
    sta zp_pc_l
    and #255 - vmem_blockmask ; keep index into kB chunk
    sta vmem_offset_in_block
	txa
	and #vmem_blockmask
    ; SFTODO: The fact vmem_temp will always be even means it may be possible
    ; to block out unusable areas of memory above vmem_start by giving them
    ; vmap_z_[hl] entries with odd addresses which could never be matched. This
    ; just might be helpful on an Electron port where dynamic memory starts at
    ; $8000 to avoid contiguous-dynmem problems with the 8K screen at the top of
    ; main RAM; we could use the ~4K of main RAM below the screen as virtual
    ; memory cache by putting vmem_start down there and blocking out the screen
    ; and the actual dynamic memory with unmatchable vmap_z_[h] entries. I
    ; suppose it's not actually quite that good, as we'd need to prevent those
    ; unmatched entries aging out, but it might not be too hard/inefficient to
    ; tweak the code to leave them alone.
	sta vmem_temp
	; Check quick index first
	ldx #vmap_quick_index_length - 1
-	ldy vmap_quick_index,x
    cmp vmap_z_l,y ; zmachine mem offset ($0 -
	beq .quick_index_candidate
--	dex
	bpl -
	bmi .no_quick_index_match ; Always branch
.quick_index_candidate
	lda vmap_z_h,y
	and #vmem_highbyte_mask
	cmp vmem_temp + 1
	beq .quick_index_match
	lda vmem_temp
	jmp --
.quick_index_match
	inc vmap_quick_index_match
	tya
	tax
	jmp .correct_vmap_index_found ; Always branch
	
.no_quick_index_match
    +make_acorn_screen_hole_jmp
	lda vmem_temp

    ; is there a block with this address in map?
    ldx vmap_used_entries
	dex
-   ; compare with low byte
    cmp vmap_z_l,x ; zmachine mem offset ($0 - 
    beq +
.check_next_block
	dex
!ifndef ACORN_LARGE_RUNTIME_VMAP {
	bpl -
	bmi .no_such_block ; Always branch
} else {
    ; SFTODO: This next cpx # is a pretty heavily executed instruction; if we
    ; can avoid having to do it somehow that would be a small but worthwhile
    ; saving. Maybe it's essential, but I put it in because it was an "obviously"
    ; correct way to do the right thing, without too much analysis.
    cpx #255
	bne -
	beq .no_such_block ; Always branch
}
	; is the highbyte correct?
+   lda vmap_z_h,x
	and #vmem_highbyte_mask
	cmp vmem_temp + 1
	beq .correct_vmap_index_found
    lda vmem_temp
    jmp .check_next_block
.correct_vmap_index_found
    ; vm index for this block found
    stx vmap_index

	ldy vmap_quick_index_match
	bne ++ ; This is already in the quick index, don't store it again
	txa
	ldx vmap_next_quick_index
	sta vmap_quick_index,x
	inx
	cpx #vmap_quick_index_length
	bcc +
	ldx #0
+	stx vmap_next_quick_index
++	jmp .index_found

; no index found, add last
.no_such_block

	; Load 512 byte block into RAM
!ifndef ACORN {
	; First, check if this is initial REU loading
	ldx use_reu
	cpx #$80
	bne +
	ldx #0
	ldy vmap_z_l ; ,x is not needed here, since x is always 0
	cpy z_pc + 1
	bne .block_chosen
	inx ; Set x to 1
	bne .block_chosen ; Always branch
}

; SFTODO: I am not sure the bcs case can ever occur on Acorn, since we always
; pre-populate vmap. If this is true we can probably ifdef this out for both SWR
; and 2P builds. (But it's only one instruction, so hardly worth it?) (OK, it
; *can* occur with PREOPT, but it still can't occur "normally" on Acorn. But it
; is still just one byte and I should probably just get rid of this comment...)
    +make_acorn_screen_hole_jmp
+	ldx vmap_clock_index
-	cpx vmap_used_entries
	bcs .block_chosen
!ifdef DEBUG {
!ifdef PREOPT {
	ldx #0
	jmp print_optimized_vm_map
}	
}
        ; Store very recent oldest_age so the first valid index in the following
        ; loop will be picked as the first candidate.
        lda #$ff
!ifdef DEBUG {
        sta vmem_oldest_index
}
	sta vmem_oldest_age
        bne ++ ; Always branch
	
	; Check all other indexes to find something older
-	lda vmap_z_h,x
	cmp vmem_oldest_age
	bcs +
++
	; Found older
	; Skip if z_pc points here; it could be in either page of the block.
!ifndef SMALLBLOCK {
	!error "Only SMALLBLOCK supported"
}
	ldy vmap_z_l,x
	cpy z_pc + 1
	beq +++
        iny
        cpy z_pc + 1
        bne ++
+++	tay
	and #vmem_highbyte_mask
	cmp z_pc
	beq +
	tya
++	sta vmem_oldest_age
	stx vmem_oldest_index
+	inx
	cpx vmap_used_entries
	bcc +
	ldx #0
+	cpx vmap_clock_index
	bne -

	; Load chosen index
	ldx vmem_oldest_index
	
.block_chosen
!ifdef COUNT_SWAPS {
	inc vmem_swap_count + 1
	bne ++
	inc vmem_swap_count
++
}
	
	cpx vmap_used_entries
	bcc +
	inc vmap_used_entries
+	txa
	tay
!ifndef ACORN_SWR {
	asl
!ifndef SMALLBLOCK {
	asl
}
!ifndef ACORN_TURBO_SUPPORTED {
	; Carry is already clear
	adc vmap_first_ram_page
} else {
    +acorn_adc_vmap_first_ram_page_or_set_mempointer_turbo_bank_from_c
}
	sta vmap_c64_offset
}
	; Pick next index to use
	iny
	cpy vmap_max_entries
	bcc .not_max_index
	ldy #0
.not_max_index
	sty vmap_clock_index

!ifdef DEBUG {
        lda vmem_oldest_index
        cmp #$ff
        bne +
        lda #ERROR_NO_VMEM_INDEX
        jsr fatalerror
+
}

	; We have now decided on a map position where we will store the requested block. Position is held in x.
!ifdef DEBUG {
!ifdef PRINT_SWAPS {
	lda streams_output_selected + 2
	beq +
	lda #20
	jsr s_printchar
	lda #64
	jsr s_printchar
	lda #20
	jsr s_printchar
	jmp ++
+	jsr space
	jsr dollar
	txa
	jsr print_byte_as_hex
	jsr colon
    ; SF: For ACORN_SWR we don't try to calculate the physical address of the
    ; VM block as it's moderately involved.
!ifndef ACORN_SWR {
	jsr dollar
!ifdef ACORN_TURBO_SUPPORTED {
    bit is_turbo
    bpl +
    lda mempointer_turbo_bank
    jsr print_byte_as_hex
+
}
	lda vmap_c64_offset
	jsr print_byte_as_hex
	jsr colon
}
	cpx vmap_used_entries
	bcs .printswaps_part_2
    lda vmap_z_h,x
    ; SF: I altered the mask here, I think it's correct but it's a divergence
    ; from upstream.
	and #vmem_highbyte_mask
	jsr dollar
	jsr print_byte_as_hex
    lda vmap_z_l,x
	jsr print_byte_as_hex
.printswaps_part_2
	jsr arrow
	jsr dollar
	lda zp_pc_h
	jsr print_byte_as_hex
    lda zp_pc_l
	and #vmem_blockmask
	jsr print_byte_as_hex
	jsr space
++	
}
}
	
!ifndef ACORN {
	; Forget any cache pages belonging to the old block at this position.
	lda vmap_c64_offset
	cmp #first_banked_memory_page
	bcc .cant_be_in_cache
	ldy #vmem_cache_count - 1
-	lda vmem_cache_index,y
	and #vmem_blockmask
	cmp vmap_c64_offset
	bne +
	lda #0
	sta vmem_cache_index,y
+	dey
	bpl -
.cant_be_in_cache	
}

	; Update tick
	lda vmem_tick
	clc
	adc #vmem_tick_increment
	bcc +

	; Tick counter has passed max value. Decrease tick value for all pages. Set tick counter back.
	txa
	pha
	
	ldx vmap_used_entries
	dex
-	lda vmap_z_h,x
	sec
	sbc #$80
	bpl ++
	and #vmem_highbyte_mask
++	sta vmap_z_h,x
	dex
!ifndef ACORN_LARGE_RUNTIME_VMAP {
	bpl -
} else {
    cpx #255
    bne -
}
	
	pla
	tax
	lda #$80
+	sta vmem_tick

!ifdef ACORN_TUBE_CACHE {
    ; Save the Z-address of the block we're about to evict before we overwrite it.
    lda vmap_z_l,x
    sta osword_cache_index_offered
    lda vmap_z_h,x
    and #vmem_highbyte_mask
    sta osword_cache_index_offered + 1
}

	; Store address of 512 byte block to load, then load it
	lda zp_pc_h
    sta vmap_z_h,x
    lda zp_pc_l
    and #vmem_blockmask ; skip bit 0 since 512 byte blocks
    sta vmap_z_l,x
    stx vmap_index
    ; SF: Be aware that if tracing is on here, the newly loaded block will
    ; show with its pre-adjustment tick.
    jsr load_blocks_from_index
.index_found
    ; index found
	; Update tick for last access 
    ldx vmap_index
	lda vmap_z_h,x
	and #vmem_highbyte_mask
	ora vmem_tick
	sta vmap_z_h,x
!ifndef ACORN_SWR {
	txa
	
	asl
!ifndef SMALLBLOCK {
	asl
}
!ifndef ACORN_TURBO_SUPPORTED {
	; Carry is already clear
	adc vmap_first_ram_page
} else {
    +acorn_adc_vmap_first_ram_page_or_set_mempointer_turbo_bank_from_c
}
	sta vmap_c64_offset
!ifndef ACORN {
	cmp #first_banked_memory_page
    bcc .unswappable
    ; this is swappable memory
    ; update vmem_cache if needed
    clc
    adc vmem_offset_in_block
	; Check if this page is in cache
    ldx #vmem_cache_count - 1
-   cmp vmem_cache_index,x
    beq .cache_updated
    dex
    bpl -
	; The requested page was not found in the cache
    ; copy vmem to vmem_cache (banking as needed)
	sta vmem_temp
	ldx vmem_cache_cnt
	; Protect page held in z_pc_mempointer + 1
	pha
	txa
	clc
	adc #>vmem_cache_start
	cmp z_pc_mempointer + 1
	bne +
	inx
	cpx #vmem_cache_count
	bcc ++
	ldx #0
++	stx vmem_cache_cnt

+	pla
	sta vmem_cache_index,x
    lda #>vmem_cache_start ; start of cache
    clc
    adc vmem_cache_cnt
	tay
	lda vmem_temp
	jsr copy_page
    ; set next cache to use when needed
	inx
	txa
	dex
	cmp #vmem_cache_count
	bcc ++
	lda #0
++	sta vmem_cache_cnt
.cache_updated
    ; x is now vmem_cache (0-3) where current z_pc is
    txa
    clc
    adc #>vmem_cache_start
    sta mempointer + 1
    ldx vmap_index
    bne .return_result ; always true
.unswappable
}
    ; update memory pointer
    lda vmem_offset_in_block
    clc
    adc vmap_c64_offset
} else {
    jsr convert_index_x_to_ram_bank_and_address
    clc
    adc vmem_offset_in_block
}
    sta mempointer + 1
.return_result
    ldy #0
    lda (mempointer),y
!ifdef ACORN_SWR {
    +acorn_swr_page_in_default_bank_using_y
}
    rts

!ifdef ACORN_SWR {
; SFTODO: Not sure I will want this as a subroutine, but let's write it here
; like this to help me think about it. For the moment it returns page of physical
; memory in A and ram bank is selected and stored at mempointer_ram_bank.
; adjust_dynamic_memory_inline also relies on the RAM bank index being returned
; in Y.
convert_index_x_to_ram_bank_and_address
    ; 0<=X<=254 is the index of the 512-byte virtual memory block we want to
    ; access. Index 0 may be in main RAM or sideways RAM, depending on the size
    ; of dynamic memory.
    txa
    sec
    sbc vmem_blocks_in_main_ram
    bcc .in_main_ram
    clc
    adc vmem_blocks_stolen_in_first_bank
    ; CA is now the 9-bit block offset of the required data from the start of
    ; our first sideways RAM bank. Each 16K bank has 32 512-byte blocks, so
    ; we need to divide by 32=2^5 to get the bank index.
    pha
    ror
    lsr
    lsr
    lsr
    lsr
    tay
    +acorn_page_in_bank_using_a_comma_y ram_bank_list ; leaves bank in A
    sta mempointer_ram_bank
    ; Now get the low 5 bits of the block offset, multiply by two to convert to
    ; 256 byte pages and that gives us the page offset within the bank.
    pla
    and #31
    asl
    ; Carry is already clear
    adc #$80
    rts
.in_main_ram
    ; A contains a negative block offset from the top of main RAM (BBC sideways
    ; RAM version) or the bottom of screen RAM (Electron sideways RAM version).
    ; Multiply by two to get a page offset and add it to the base to get the
    ; actual start.
    asl
    ; Carry is set
!ifndef ACORN_ELECTRON_SWR {
    adc #(>flat_ramtop)-1
} else {
    adc screen_ram_start_minus_1
}
    rts
}
}

; SFTODO: Hack, let's just allocate a fake datasette buffer here
; SFTODO: For now I'm going to pre-fill this as part of the build
; SFTODODATA - THIS IS INITIALISED, BUT I AM HALF THINKING WE SHOULD JUST
; POPULATE IT IN THE DISCARDABLE INIT CODE - BUT MAYBE DON'T RUSH INTO THIS AS
; SWR AND 'SUGGESTED' PAGES AND PREOPT WILL AFFECT THIS DECISION
; SFTODO: Is there any value in page-aligning this? Although since the two halves
; are not exactly page-aligned we'd end up having to waste a couple of bytes so
; each half was page-aligned. Profile this before doing anything.
!ifdef ACORN {
!ifdef VMEM {
datasette_buffer_start
    !FILL vmap_max_size * 2, 'V'
datasette_buffer_end
}
}
