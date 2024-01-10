; z_address !byte 0,0,0
; z_address_temp !byte 0

set_z_address
    stx z_address + 2
    sta z_address + 1
    lda #$0
    sta z_address
    rts

+make_acorn_screen_hole
dec_z_address
    pha
    dec z_address + 2
    lda z_address + 2
    cmp #$ff
    bne +
    dec z_address + 1
    lda z_address + 1
    cmp #$ff
    bne +
    dec z_address
+   pla
    rts

+make_acorn_screen_hole
set_z_himem_address
    stx z_address + 2
    sta z_address + 1
    sty z_address
    rts

skip_bytes_z_address
    ; skip <a> bytes
    clc
    adc z_address + 2
    sta z_address + 2
    lda z_address + 1
    adc #0
    sta z_address + 1
    lda z_address
    adc #0
    sta z_address
    rts

!ifdef DEBUG {
print_z_address
    jsr dollar
    lda z_address + 1 ; low
    jsr print_byte_as_hex
    lda z_address + 2 ; high
    jsr print_byte_as_hex
    jmp newline
}

get_z_address
    ; input: 
    ; output: a,x
    ; side effects: 
    ; used registers: a,x
    ldx z_address + 2 ; low
    lda z_address + 1 ; high
    rts

get_z_himem_address
    ldx z_address + 2
    lda z_address + 1
    ldy z_address
    rts

read_next_byte
    ; input: 
    ; output: a
    ; side effects: z_address
    ; used registers: a,x
    sty z_address_temp
    lda z_address
    ldx z_address + 1
    ldy z_address + 2
    jsr read_byte_at_z_address
    inc z_address + 2
    bne +
    inc z_address + 1
    bne +
    inc z_address
+   ldy z_address_temp
    rts

set_z_paddress
    ; convert a/x to paddr in z_address
    ; input: a,x
    ; output: 
    ; side effects: z_address
    ; used registers: a,x
    ; example: $031b -> $00, $0c, $6c (Z5)
    sta z_address + 1
	txa
	asl
    sta z_address + 2
    rol z_address + 1
    lda #$0
    rol
!ifdef Z4PLUS {
    asl z_address + 2
    rol z_address + 1
    rol
}
!ifdef Z8 {
    asl z_address + 2
    rol z_address + 1
    rol
}
	sta z_address
    rts

