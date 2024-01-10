; Code to relocate the Ozmoo executable down in memory. This is used on some
; Acorn builds to allow the executable to load high and then move itself down
; to an optimal address for the machine it's running on.
;
; The relocation model is very simple and relies on building two versions of the
; code starting at different page-aligned addresses, then comparing them to see
; which bytes need to be offset to compensate for the relocation at runtime.
; This works pretty well in practice, but it means that code can't vary in
; "complex" ways depending on where it's being assembled - e.g. it's OK to do
; "lda #>.story_start" but "lda #($80->.story-start)" will cause an error when
; generating the relocations as the two versions will differ but in an unexpected
; way.

!zone {

reloc_start = program_start
!if <reloc_start != 0 {
    !error "reloc_start must be on a page boundary"
}
; When relocating acorn-cache.asm on the host we will use these zero page
; locations. I can't find any official documentation to say what zero page we
; can and can't use, but looking at the different versions of the tube host code
; on mdfs.net I can't see any problem with transient use of these in practice.
.delta = $70
.codep = $71 ; 2 bytes
.deltap = $73 ; 2 bytes
.count = $75 ; 2 bytes
.src = $77 ; 2 bytes
.dst = $79 ; 2 bytes

relocate
!ifdef ACORN_RELOCATE_WITH_DOUBLE_PAGE_ALIGNMENT {
    lda relocate_target
    eor #>reloc_start
    lsr
    bcc +
    ; relocate_target doesn't have the same double-page alignment as reloc_start,
    ; so bump it up by one. It's harmless to modify relocate_target, because
    ; it just means if we're restarted by re-running the executable it will
    ; already have the right alignment.
    inc relocate_target
+
}

    lda relocate_target
    cmp #(>reloc_start) + 1
    bcc +
    ; We don't support relocating upwards.
    brk
    !byte 0
    !text "PAGE too high"
    brk
+

    lda relocate_target
    sta .dst + 1
    sec
    sbc #>reloc_start
    sta .delta
    lda #>reloc_start
    sta .codep + 1
    sta .src + 1
    lda #0
    tay
    sta .dst
    sta .src
    sta .codep
    lda #<reloc_data
    sta .deltap
    lda #>reloc_data
    sta .deltap + 1
    lda reloc_count
    sta .count
    lda reloc_count + 1
    sta .count + 1
    ora .count
    bne +
    ; There are no relocations, so just carry on without relocating.
    jmp initialize
+

    ; Fix up the absolute addresses in the executable in place.
    ; None of the following code can contain absolute addresses, otherwise it
    ; will be modified while it's executing and may crash. This is why we copy
    ; reloc_count down into zero page. (If we didn't generate relocations for
    ; this last bit of the executable we wouldn't have this issue, but it's
    ; easier for the build system not to have to work out where the "real"
    ; executable ends and the relocation code begins.)
.patch_loop
    lda (.deltap),y
    beq .advance_255
    clc
    adc .codep
    sta .codep
    bcc +
    inc .codep + 1
+   lda (.codep),y
    clc
    adc .delta
    sta (.codep),y
.patch_next
    inc .deltap
    bne +
    inc .deltap + 1
+   lda .count
    bne +
    dec .count + 1
+   dec .count
    bne .patch_loop
    lda .count + 1
    bne .patch_loop

    ; Now copy the code down to relocate_target. We must not copy over the top of this
    ; code while it's executing, which is why it's right at the end and we're
    ; precise about how many bytes we copy. (We do round up to the nearest page,
    ; though.)
.bytes_to_copy = relocate - program_start
    !if <.bytes_to_copy = 0 {
        ldx #>.bytes_to_copy
    } else {
        ldx #(>.bytes_to_copy) + 1
    }
    ldy #0
.copy_loop
    lda (.src),y
    sta (.dst),y
    iny
    bne .copy_loop
    inc .src + 1
    inc .dst + 1
    dex
    bne .copy_loop

    ; Now execute the relocated code; this absolute address will have been
    ; fixed up.
    jmp initialize

.advance_255
    clc
    lda .codep
    adc #255
    sta .codep
    bcc +
    inc .codep + 1
+   bne .patch_next ; Always branch
    



; The following must be right at the very end of the executable. A bit of
; padding is tolerable, though.
reloc_count
    !word 0
reloc_data
}
