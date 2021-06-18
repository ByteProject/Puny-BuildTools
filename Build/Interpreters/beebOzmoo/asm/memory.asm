; Routines to handle memory

; !ifndef VMEM {
; !zone {
; read_byte_at_z_address
	; ; Subroutine: Read the contents of a byte address in the Z-machine
	; ; a,x,y (high, mid, low) contains address.
	; ; Returns: value in a
	; sty mempointer
	; txa
	; clc
	; adc #>story_start
	; sta mempointer + 1
	; ldy #0
	; lda (mempointer),y
	; rts
; .too_high
    ; lda #ERROR_MEMORY_OVER_64KB
	; jsr fatalerror

; }
; }

!ifdef ACORN_SWR_BIG_DYNMEM {
inc_z_pc_page_acorn_unsafe
    jsr inc_z_pc_page
    +acorn_page_in_bank_using_y z_pc_mempointer_ram_bank
    rts
}

; SF: On Acorn non-VMEM (and, I believe, C64 non-ALLMEM) this just needs to do
; the two inc statements and rts, no need for anything else. Conditionally
; assembling this is a real faff so we just accept the small inefficiency.
inc_z_pc_page
!zone {
	pha
	inc z_pc_mempointer + 1
	inc z_pc + 1
!ifdef VMEM {
	bne +
	inc z_pc
+	lda z_pc + 1
	and #255-vmem_blockmask
	beq get_page_at_z_pc_did_pha
	lda z_pc_mempointer + 1
!ifndef ACORN {
	cmp #>story_start
	bcc get_page_at_z_pc_did_pha
}
} else {
; No vmem
!ifndef ACORN {
	lda z_pc + 1
	cmp #(first_banked_memory_page - (>story_start))
	bcs get_page_at_z_pc_did_pha
}
}
; safe
	pla
inc_z_pc_page_rts
	rts

}


set_z_pc
; Sets new value of z_pc, and makes sure z_pc_mempointer points to the right memory
; Parameters: New value of z_pc in a,x,y
!zone {
	sty z_pc + 2
!ifdef VMEM {
	cmp z_pc
	bne .unsafe_1
}
	cpx z_pc + 1
	beq .same_page 
	; Different page.
!ifdef VMEM {	
	; Let's find out if it's the same vmem block.
	txa
	eor z_pc + 1
	and #vmem_blockmask
	bne .unsafe_2
!ifndef ACORN {
	; z_pc is in same vmem_block unless it's in vmem_cache
	lda z_pc_mempointer + 1
	cmp #>story_start
	bcc .unsafe_2
}
	; z_pc is in same vmem_block, but different page.
	stx z_pc + 1
!ifdef SMALLBLOCK {
	lda z_pc_mempointer + 1
	eor #1
	sta z_pc_mempointer + 1
} else {
	txa
	and #255-vmem_blockmask
	sta mem_temp
	lda z_pc_mempointer + 1
	and #vmem_blockmask
	clc
	adc mem_temp
	sta z_pc_mempointer + 1
}
} else {
; No vmem 
!ifndef ACORN {
	cpx #(first_banked_memory_page - (>story_start))
	bcs .unsafe_2
}
	stx z_pc + 1
	txa
	clc
	adc #>story_start
	sta z_pc_mempointer + 1
}
.same_page
	rts
.unsafe_1
	sta z_pc
.unsafe_2
	stx z_pc + 1
	; jsr get_page_at_z_pc
	; rts
}

; Must follow set_z_pc
get_page_at_z_pc
!zone {
	pha
get_page_at_z_pc_did_pha
	stx mem_temp
!ifdef ALLRAM {
	lda z_pc
}
	ldx z_pc + 1
	ldy z_pc + 2
	jsr read_byte_at_z_address
!ifdef ACORN_SWR {
!ifdef ACORN_SWR_SMALL_DYNMEM {
    ; read_byte_at_z_address_for_z_pc will have left the then-current value of
    ; z_pc_mempointer_ram_bank paged in, so we need to explicitly page in the
    ; newly set z_pc_mempointer_ram_bank. This is mildly inefficient, but it
    ; only happens when the Z-machine PC crosses a page boundary and the
    ; contortions required to avoid it are not worth it.
    +acorn_page_in_bank_using_y mempointer_ram_bank ; leaves bank in Y
} else {
    ldy mempointer_ram_bank
}
    sty z_pc_mempointer_ram_bank
} else {
!ifdef ACORN_TURBO_SUPPORTED {
	; This isn't necessary on a normal second processor, but it's harmless and
	; it's only one cycle slower to just do it instead of checking the second
	; processor type before doing it.
	ldy mempointer_turbo_bank
	sty z_pc_mempointer_turbo_bank
}
}
	ldy mempointer + 1
	sty z_pc_mempointer + 1
    ; SFTODO: I am struggling to see why it matters that Y is 0 on exit
	ldy #201 ; SFTODO TO SEE IF IT IS NECESSARY ldy #0 ; Important: y should always be 0 when exiting this routine! SF: I have analysed the code and I don't think this is true (maybe it was at one point) - SFTODO: HMM, I'M A BIT LESS SURE NOW - FWIW THIS IS *NOT* A HOT INSTRUCTION AT LEAST IN THE BENCHMARK - SEE ALSO THE LATEST ANALYSIS IN sf-notes.txt
	ldx mem_temp
	pla
	rts
}

!zone {
; !ifdef VMEM {
; .reu_copy
	; ; a = source C64 page
	; ; y = destination C64 page
	; stx mem_temp
	; sty mem_temp + 1
	; ; Copy to REU
	; tay
	; lda #0
	; tax
	; jsr store_reu_transfer_params
	; lda #%10000000;  c64 -> REU with delayed execution
	; sta reu_command
    ; sei
    ; +set_memory_all_ram_unsafe
	; lda $ff00
	; sta $ff00
	; +set_memory_no_basic_unsafe
	; cli
	; ; Copy to C64
	; txa ; X is already 0, set a to 0 too
	; ldy mem_temp + 1
	; jsr store_reu_transfer_params
	; lda #%10000001;  REU -> c64 with delayed execution
	; sta reu_command
	; sei
    ; +set_memory_all_ram_unsafe
	; lda $ff00
	; sta $ff00
	; +set_memory_no_basic_unsafe
	; cli
	; ldx mem_temp
	; ldy #0
	; rts
; }	

!ifndef ACORN {
copy_page
; a = source
; y = destination

; !ifdef VMEM {
	; bit use_reu
	; bmi .reu_copy
; }
	sta .copy + 2
	sty .copy + 5
    sei
    +set_memory_all_ram_unsafe
-   ldy #0
.copy
    lda $8000,y
    sta $8000,y
    iny
    bne .copy
    +set_memory_no_basic_unsafe
    cli
	rts
}
}
