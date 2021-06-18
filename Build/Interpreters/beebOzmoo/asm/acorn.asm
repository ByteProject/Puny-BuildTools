; Acorn-specific code factored out into its own file for readability.

; Note that the code macros defined in here have the suffix "_inline" if control
; flows straight through them or "_subroutine" if they end by executing rts (or
; equivalent).

; A note on Acorn memory models - this affects code in many places, but I have
; to write this somewhere.
;
; The second processor build (ifndef ACORN_SWR) has a simple flat memory model
; with user RAM from $0400-$f7ff inclusive. It's rather like the C64 but without
; even the complication of paging the kernal ROM in and out, so it doesn't need
; the cache which the C64 code uses when ALLMEM is defined. SFTODO: SAY SOMETHING ABOUT ACORN_TURBO_SUPPORTED
;
; The sideways RAM build (ifdef ACORN_SWR) is a bit more involved. The hardware
; situation here is that we have main RAM (not paged) from $0000-$7fff
; inclusive, with user RAM starting at OSHWM/PAGE, which varies between machines
; but will typically be in the range $e00-$1f00. Some builds hard-code a certain
; address, others use acorn-relocate.asm to accommodate this variation. We also
; have up to 16 different 16K banks of "sideways" RAM paged in at $8000-$bfff
; inclusive. (The BBC series and Electron have different ways to control paging;
; see the acorn_page_in_bank_* macros.) The OS is not paged and lives
; permanently at $c000-$ffff inclusive. The loader will have located any
; available sideways RAM banks, verified there's at least one and put the count
; and a list of bank numbers at ram_bank_{count,list} for us. SFTODO: MINOR QUIBBLE - LOADER WILL HAVE VERIFIED WE HAVE ENOUGH SWR BANKS, THERE MAY BE NONE IF WE CAN GET BY WITHOUT ANY
;
; Acorn Ozmoo uses two slightly different sideways RAM models. Both of them
; allow static/high memory to be spread over approximately 9 sideways RAM banks
; (indexed in 512-byte chunks with indexes from 0-254, with chunk 0 starting
; at story_start+nonstored_blocks). The standard Ozmoo mempointer (data) and 
; z_pc_mempointer (Z-machine PC) pointers are extended to each have an associated
; RAM bank (mempointer_ram_bank and z_pc_mempointer_ram_bank respectively). (If
; the relevant byte of Z-machine memory lives in main RAM, the bank number is
; irrelevant as main RAM is not affected by paging.)
;
; The "big dynamic RAM" model (ifndef ACORN_SWR_SMALL_DYNMEM) allows the game's
; dynamic memory (which starts in main RAM at story_start, as on any Ozmoo build)
; to be larger than main RAM and overflow into the first 16K sideways RAM bank.
; The first 16K sideways RAM bank therefore has to be paged in by default, so
; that miscellaneous Ozmoo code which might try to access dynamic memory can do
; so without any trouble. In this model, accesses to memory via read_next_byte
; and read_next_byte_at_z_pc temporarily page in the relevant bank to read the
; byte and then page the first 16K sideways RAM bank back in. (As an
; optimisation, read_next_byte_at_z_pc_unsafe* and friends are used during
; instruction decoding to avoid flipping back and forth excessively while
; reading a multi-byte instruction. This is possible because only a very limited
; set of cases can cause accesses to dynamic memory during instruction decoding.)
;
; The "small dynamic RAM" model (ifdef ACORN_SWR_SMALL_DYNMEM) requires the game's
; dynamic memory to fit in main RAM. Since dynamic memory can then be accessed
; regardless of the currently paged in bank, Ozmoo instead keeps the bank
; containing the Z-machine's PC paged in by default, temporarily paging it out
; only when reading a data byte.
;
; On a second processor or BBC series machine with shadow RAM, screen RAM is
; separate from user RAM and doesn't get in the way. On a BBC B with no shadow
; RAM, we use a trick (see ACORN_NO_SHADOW) to relocate the 1K screen RAM to
; $3c00, leave a gap in the Ozmoo binary to accommodate that and we can then
; mostly forget about screen RAM. Dynamic memory starts at story_start just
; after the Ozmoo stack (as on the C64) and is followed (with suitable paging
; for ACORN_SWR) directly by the virtual memory cache.
;
; On the Electron shadow RAM is rare and we can't use the ACORN_NO_SHADOW trick
; to get the screen memory (8K, from $6000-$8000) out of the way. Ozmoo really
; wants dynamic memory to be contiguous, and there isn't really enough RAM free
; between the Ozmoo stack and the screen memory to run all the games we'd like
; to. We therefore compromise by forcing the use of the big dynamic RAM model
; and making dynamic RAM start at $8000 instead of following the Ozmoo stack.
; This limits us to 16K of dynamic memory, which isn't too bad (and is more than
; we'd have free below screen RAM). We use the main RAM between the Ozmoo stack
; and the screen RAM as additional virtual memory cache so it isn't wasted. An
; Electron is therefore about 7K worse off than a BBC B with the same amount of
; sideways RAM as a result of its larger screen memory, in addition to not
; supporting games needing more than 16K of dynamic memory. The Electron save/
; restore code has to be slightly different because the data we need to save/
; restore is no longer contiguous in memory.

; To improve readability of code and avoid double-nesting so we can test for
; ACORN_SWR and !ACORN_SWR_SMALL_DYNMEM in a single !ifdef, we define
; ACORN_SWR_BIG_DYNMEM internally - the build script should never set this.
!ifdef ACORN_SWR {
!ifndef ACORN_SWR_SMALL_DYNMEM {
ACORN_SWR_BIG_DYNMEM = 1
} else { ; ACORN_SWR_SMALL_DYNMEM
!ifdef ACORN_ELECTRON_SWR {
!error "ACORN_ELECTRON_SWR is not compatible with ACORN_SWR_SMALL_DYNMEM"
}
}
}

!zone {

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sideways RAM paging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!ifdef ACORN_SWR {

; SF: ENHANCEMENT: It would probably be possible (even easy) to use an AQR
; cartridge for all sideways RAM on a Master or Electron; it has its own special
; paging register though, so we'd need a separate build to support it, and auto-
; detecting it in a way that doesn't interfere with the user's other use of it
; may be tricky. There's also some sort of unlock stuff to contend with, I think.

; These macros must leave the selected bank number in A or Y as appropriate.

!ifndef ACORN_ELECTRON_SWR {

!macro acorn_page_in_bank_using_a .operand {
    lda .operand
    sta romsel_copy
    sta bbc_romsel
}

!macro acorn_page_in_bank_using_a_comma_x .operand {
    lda .operand,x
    sta romsel_copy
    sta bbc_romsel
}

!macro acorn_page_in_bank_using_a_comma_y .operand {
    lda .operand,y
    sta romsel_copy
    sta bbc_romsel
}

!macro acorn_page_in_bank_using_y .operand {
    ldy .operand
    sty romsel_copy
    sty bbc_romsel
}
} else { ; ACORN_ELECTRON_SWR

!macro acorn_page_in_bank_using_a .operand {
    lda #12
    sta romsel_copy
    sta electron_romsel
    lda .operand
    sta romsel_copy
    sta electron_romsel
}

!macro acorn_page_in_bank_using_a_comma_x .operand {
    lda #12
    sta romsel_copy
    sta electron_romsel
    lda .operand,x
    sta romsel_copy
    sta electron_romsel
}

!macro acorn_page_in_bank_using_a_comma_y .operand {
    lda #12
    sta romsel_copy
    sta electron_romsel
    lda .operand,y
    sta romsel_copy
    sta electron_romsel
}

!macro acorn_page_in_bank_using_y .operand {
    ldy #12
    sty romsel_copy
    sty electron_romsel
    ldy .operand
    sty romsel_copy
    sty electron_romsel
}
}
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialization and finalization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Initialization code which may be placed after the end of the Z-machine stack;
; this means it will be overwritten as soon as anything is loaded at
; story_start.
!macro acorn_init_code_overlapping_game_data {
; Initialization performed very early during startup.
deletable_init_start
    ldx #1
    jsr do_osbyte_rw_escape_key

!ifdef ACORN_NO_SHADOW {
    +set_up_mode_7_3c00_inline
}

    jsr screenkernal_init

    ; Now screenkernal_init has been executed, it's safe to call s_printchar, so
    ; install our own error handler which will use s_printchar by default. No
    ; error should be able to occur before this point. If an error occurs during
    ; a restart, which will re-run the executable, there's not much we can do
    ; but it's probably OK because the load will just replace the code with an
    ; identical copy.
    lda #<error_handler
    sta brkv
    lda #>error_handler
    sta brkv + 1

!ifdef ACORN_CURSOR_PASS_THROUGH {
    ldx #1
    jsr do_osbyte_set_cursor_editing
}

!ifdef ACORN_FUNCTION_KEY_PASS_THROUGH {
    ; We're going to generate ZSCII codes for the unshifted function keys. We
    ; choose a base of 133 (=ZSCII f1) for f0 because if we set a base of 132 so
    ; Acorn f1=ZSCII f1, Acorn f0 would act like cursor right. If we want Acorn
    ; f1=ZSCII f1 we'll fix that up in the translation table. SFTODO: I HAVEN'T ADDED THIS OPTION TO THE TRANSLATION TABLE YET
    lda #osbyte_rw_function_key_status
    ldx #133
    jsr do_osbyte_y_0

    ; In order to allow the use of *KEY expansions, we'll make the shifted
    ; function keys generate those.
    lda #osbyte_rw_shift_function_key_status
    ldx #1 ; expand as normal soft key
    jsr do_osbyte_y_0
}

    ; Patch re_enter_language to enter the current language; reading it here
    ; saves a few bytes of non-deletable code.
    lda #osbyte_read_language
    ldx #0
    ldy #$ff
    jsr osbyte
    stx re_enter_language_ldx_imm + 1

!ifndef ACORN_SWR {
    ; On a second processor, a soft break will transfer control back to our
    ; execution address. We will have thrown away our initialization code by
    ; that point and can't restart properly. In order to avoid random behaviour
    ; and probably a crash, we patch the jmp at the start of the executable to
    ; transfer control to re_enter_language. This means that although the
    ; language name gets printed twice, a soft break otherwise gives a clean
    ; result similar to that on a non-second processor. This code is harmless
    ; if we're not running on a second processor, but it's not necessary either.
    lda #<re_enter_language
    sta initial_jmp + 1
    lda #>re_enter_language
    sta initial_jmp + 2
}

!ifdef ACORN_TURBO_SUPPORTED {
    ; This executable doesn't have a ROM header indicating we want the turbo
    ; mode enabled, so it will have been disabled when were were executed. Turn
    ; it back on if we do want it.
    bit is_turbo
    bpl .dont_enable_turbo
    lda #$80
    sta turbo_control
.dont_enable_turbo
}

    +init_readtime_inline
    jmp init_cursor_control

; SFTODO: Don't forget more code can go here if it can be executed before we
; start to put data at story_start.
} ; End of acorn_init_code_overlapping_game_data_inline

; Initialization subroutines which will be placed inside the Z-machine stack.
!macro acorn_init_code_in_stack {
screenkernal_init
    +screenkernal_init_inline
    rts
}

; Initialization performed shortly after startup, just after
; acorn_deletable_init_start. (The distinction is not that important on Acorn
; as the Ozmoo executable itself doesn't generate a splash screen.)
!macro acorn_deletable_init_inline {
!ifdef TRACE_FLOPPY {
    ; Call streams_init so the tracing is able to show the readblocks calls
    ; performed here.
	jsr streams_init
}

.dir_ptr = zp_temp ; 2 bytes
.game_blocks = zp_temp + 2 ; 2 bytes
; We can't always use story_start to store the catalogue sectors because on an
; ACORN_ELECTRON_SWR build that's in sideways RAM, and we can't always use
; scratch_double_page because second processor builds don't have it.
!ifdef scratch_double_page {
.catalogue = scratch_double_page
} else {
.catalogue = story_start
}
!ifndef ACORN_ADFS {
    ; Examine the disc catalogue and determine the first sector occupied by the
    ; DATA file containing the game.
    ; Because this is initialisation code, we know the following variables are
    ; already set to predictable values. This optimisation was useful at one
    ; point but it's not really important right now; it isn't too confusing so
    ; let's keep it anyway now it's been tested.
!if 0 {
    lda #2
    sta readblocks_numblocks
    lda #0
    sta readblocks_currentblock
    sta readblocks_currentblock + 1
    sta readblocks_mempos ; .catalogue is page-aligned
!ifdef ACORN_TURBO_SUPPORTED {
    ; In reality this is redundant but let's play it safe.
    sta readblocks_mempos + 2
}
}
    lda #>.catalogue
    sta .dir_ptr + 1
    sta readblocks_mempos + 1
    lda #0
    sta readblocks_base
!ifndef ACORN_DSD {
    sta readblocks_base + 1
}
    ; Note that because we're reading the first few sectors, this works
    ; correctly whether this is an ACORN_DSD build or not.
    jsr readblocks
    lda #8
    sta .dir_ptr
.find_file_loop
    ldy #0
    ldx #(-8 & $ff)
.name_compare_loop
    lda (.dir_ptr),y
    ; The directory name will have the top bit set iff the file is locked; we
    ; don't care about that here, so we need to strip it off. It's harmless to
    ; just do this for all characters.
    and #$7f
    cmp .data_filename-(-8 & $ff),x
    bne .file_not_found
    iny
    inx
    beq .file_found
    bne .name_compare_loop
.data_filename
    !text "DATA   $"
.file_not_found
    clc
    lda .dir_ptr
    adc #8
    sta .dir_ptr
    bne .find_file_loop
    brk
    !byte 0
    !text "DATA not found"
    !byte 0
.file_found
    ; We found the file's name using sector 0, we now want to look at the
    ; corresponding part of sector 1. Adjust .dir_ptr for convenience.
    inc .dir_ptr + 1
    ; Determine the start sector of the DATA file and set readblocks_base.
    ldy #6
    lda (.dir_ptr),y
    and #$3
!ifndef ACORN_DSD {
    sta readblocks_base + 1
    iny
    lda (.dir_ptr),y
    sta readblocks_base
} else {
    sta dividend + 1
    iny
    lda (.dir_ptr),y
    sta dividend
    lda #0
    sta divisor + 1
    lda #10
    sta divisor
    jsr divide16
    lda division_result
    sta readblocks_base
}
    ; Determine the length of the DATA file in blocks.
    ldy #6
    lda (.dir_ptr),y
    and #%110000
    lsr
    lsr
    lsr
    lsr
    sta .game_blocks + 1 ; high byte of length in blocks
    dey
    lda (.dir_ptr),y
    sta .game_blocks ; low byte of length in blocks
    dey
    lda (.dir_ptr),y ; low byte of length in bytes
    beq +
    inc .game_blocks
    bne +
    inc .game_blocks + 1
+
!ifdef ACORN_DSD {
    ; If this is a double-sided game, there will be *approximately* (definitely
    ; no more, possibly a track's worth of data less) the same amount of data
    ; on the second side. We don't look up :2.$.DATA and determine its length,
    ; we just double .game_blocks. The absolute worst case here is we read a
    ; track's worth of junk which won't be accessed because it's past the end
    ; of the game.
    asl .game_blocks
    rol .game_blocks + 1
!ifndef VMEM {
    ; If we don't have virtual memory, the logic below to cap .game_blocks at
    ; .ram_blocks won't kick in. Since we don't have virtual memory, we know the
    ; game will fit in RAM - but due to the doubling of .game_blocks we just did,
    ; it might be larger than RAM, causing us to read too much and corrupt
    ; things. TODO: If we simply passed in the game size as a build parameter
    ; this sort of thing would go away.
    lda #0
    sta .game_blocks + 1
    lda #>(flat_ramtop - story_start)
    cmp .game_blocks
    bcs +
    sta .game_blocks
+
}
}
} else { ; ACORN_ADFS
    lda #<game_data_filename
    sta scratch_page
    lda #>game_data_filename
    sta scratch_page + 1
    lda #osfile_read_catalogue_information
    ldx #<scratch_page
    ldy #>scratch_page
    jsr osfile
    bne +
    ; The wording of this error is technically incorrect - we're trying to read
    ; information about the file, not open it - but I don't think it's a big
    ; deal. It shouldn't be happening at all, of course.
    jmp cant_open_data_error
+   lda scratch_page + $a
    beq +
    inc scratch_page + $b
    bne +
    inc scratch_page + $c
+   lda scratch_page + $b
    sta .game_blocks
    lda scratch_page + $c
    sta .game_blocks + 1
}

    ; If .game_blocks is odd, increment it by one so the game data is always
    ; considered to be a multiple of 512 bytes. This avoids having to worry
    ; about some corner cases and doesn't cause any problems; on DFS we're doing
    ; raw sector reads and the extra sector will always exist, on ADFS we may try
    ; to do a 512-byte read when only 256 bytes are available but that's fine.
    lda .game_blocks
    and #1
    beq +
    inc .game_blocks
    bne +
    inc .game_blocks + 1
+

!ifdef VMEM {
.ram_blocks = .dir_ptr ; 2 bytes

    ; How much RAM do we have available for game data?
    ; We have 64 (2^6) 256-byte blocks per sideways RAM bank, if we have any.
    lda #0
    sta .ram_blocks + 1
!ifdef ACORN_SWR {
    lda ram_bank_count
    ldx #6
-   asl
    rol .ram_blocks + 1
    dex
    bne -
}
    sta .ram_blocks

!ifdef ACORN_TUBE_CACHE {
    ; We have some blocks of cache in the host, which aren't directly accessible
    ; but are almost as good as our own RAM and which will benefit from
    ; preloading if we're on a normal second processor. We count them for now so
    ; we process more of the initial vmap and fix up the inflated value of
    ; vmap_max_entries later.
.host_cache_size = memory_buffer
    lda screen_mode
    ora #128 ; force shadow mode on
    tax
    lda #osbyte_initialise_cache
    jsr osbyte
    stx .host_cache_size
!ifdef ACORN_TURBO_SUPPORTED {
    ; A turbo second processor has enough RAM to preload everything in vmap
    ; without touching the host cache. The host cache will still work, but we
    ; don't have anything to preload into it, so having initialised it there's
    ; nothing else to do.
    bit is_turbo
    bmi .host_cache_initialised
}
    ; X is cache size in 512-byte blocks, but we want to count 256-byte blocks here.
    txa
    asl
    rol .ram_blocks + 1
    sta .ram_blocks
.host_cache_initialised
SFTODOLABELX1
}

!ifdef ACORN_TURBO_SUPPORTED {
    ; On a turbo second processor, we will use all 128K in banks 1 and 2 as
    ; virtual memory cache.
    bit is_turbo
    bpl .dont_count_turbo_ram
    inc .ram_blocks + 1
    inc .ram_blocks + 1
.dont_count_turbo_ram
}

    ; We also have some blocks between flat_ramtop and story_start.
    ; SF: We're doing a constant subtraction in code here, but a) this is
    ; deletable init code so it doesn't really cost anything b) if we don't,
    ; the relocation code fails because we have a variation which doesn't follow
    ; the simple fixed relationship we expect.
    lda #>flat_ramtop
    sec
    sbc #>story_start
    clc
    adc .ram_blocks
    sta .ram_blocks
    bcc +
    inc .ram_blocks + 1
+

!ifdef ACORN_ELECTRON_SWR {
    ; We also have some blocks free between extra_vmem_start and the screen RAM.
    lda #osbyte_read_screen_address
    jsr osbyte
    tya
    dey
    sty screen_ram_start_minus_1
    sec
    sbc #>extra_vmem_start
    tax
    clc
    adc .ram_blocks
    sta .ram_blocks
    bcc +
    inc .ram_blocks + 1
+   txa
    lsr
    sta vmem_blocks_in_main_ram
} else {
!ifdef ACORN_SWR {
    ; This value might be changed below.
    lda #0
    sta vmem_blocks_in_main_ram
}
}

    ; .ram_blocks now contains the number of 256-byte blocks of RAM we have
    ; available, including RAM which will be used for dynamic memory. The build
    ; system and the loader will have worked together to guarantee that:
    ; - .ram_blocks >= ACORN_INITIAL_NONSTORED_BLOCKS + 2*vmem_block_pagecount,
    ;   i.e. that we have enough RAM for the game's dynamic memory and two
    ;   512-byte blocks of virtual memory cache.
    ; - the game always has at least one block of non-dynamic memory.

    ; In order to avoid accessing nonexistent game data in an attempt to use all
    ; that RAM, set .ram_blocks = min(.ram_blocks, .game_blocks).
    ldx .game_blocks + 1
    lda .game_blocks
    cpx .ram_blocks + 1
    bne +
    cmp .ram_blocks
+   bcs +
    stx .ram_blocks + 1
    sta .ram_blocks
+

    ; Set nonstored_blocks to the number of 256-byte blocks of RAM we are going
    ; to treat as dynamic memory. This is normally the game's actual dynamic
    ; memory rounded up to a 512-byte boundary, i.e.
    ; ACORN_INITIAL_NONSTORED_BLOCKS.
    lda #ACORN_INITIAL_NONSTORED_BLOCKS
    sta nonstored_blocks
!ifdef VMEM {
!ifndef ACORN_NO_DYNMEM_ADJUST {
!ifdef ACORN_TURBO_SUPPORTED {
    ; SFTODO: REVIEW THIS FRESH
    ; On a turbo second processor, we can increase nonstored_blocks to promote
    ; some additional data into dynamic memory and make full use of bank 0. We
    ; don't need to keep any of bank 0 free for virtual memory cache because we
    ; have banks 1 and 2 for that. So we set nonstored_blocks = min(game_blocks
    ; - vmem_block_pagecount, available blocks in bank 0); see below for why we
    ; subtract vmem_block_pagecount. This subtraction can't cause
    ; nonstored_blocks < ACORN_INITIAL_NONSTORED_BLOCKS because the build system
    ; guarantees the game has at least one block of non-dynamic memory. The
    ; subtraction is otherwise harmless; it just means that for small games one
    ; 512-byte block of RAM will have to be accessed via the slower virtual
    ; memory code when it could maybe have been promoted to be dynamic memory.
    ;
    ; This adjustment will make it faster to access the part of the game which
    ; has been promoted into dynamic memory, so we do it even if this is a small
    ; game and we could address enough RAM for the entire game without it.
    bit is_turbo
    bpl .no_turbo_dynmem_adjust
SFTODOLABEL1
    lda .game_blocks
    sec
    sbc #vmem_block_pagecount
    tax
    lda .game_blocks + 1
    sbc #0
    bne .available_blocks_is_smaller
    cpx #>(flat_ramtop - story_start)
    bcc .game_blocks_is_smaller
.available_blocks_is_smaller
    ldx #>(flat_ramtop - story_start)
.game_blocks_is_smaller
    stx nonstored_blocks
.no_turbo_dynmem_adjust
}
!ifdef ACORN_SWR {
    ; It may be useful to increase nonstored_blocks to promote some additional
    ; data into dynamic memory, either for performance or to make use of more
    ; sideways RAM. We must not make it too large for the memory model we're
    ; using. (This optimisation has relatively limited scope in the small model,
    ; but it's trivial to support it anyway. It's just conceivable some games
    ; and/or machines might benefit from --force-big-dynmem to give this
    ; optimisation more headroom, but of course the big model has its own
    ; performance drawbacks so it's probably best not using it unless we're
    ; forced to.)
.max_dynmem = zp_temp + 4 ; 1 byte
!ifdef ACORN_SWR_BIG_DYNMEM {
    lda #>swr_ramtop
} else {
    lda #>flat_ramtop
}
    sec
    sbc #>story_start
    sta .max_dynmem

    ; If .game_blocks == .ram_blocks, we want to set nonstored_blocks as high as
    ; possible; there's no downside as we have enough RAM for the entire game
    ; and this will allow as much of the game as possible to be accessed via the
    ; faster dynamic memory code path. Set nonstored_blocks = min(.game_blocks -
    ; vmem_block_pagecount, .max_dynmem).
    ldy .ram_blocks + 1
    lda .ram_blocks
    cpy .game_blocks + 1
    bne .game_blocks_ne_ram_blocks
    cmp .game_blocks
    bne .game_blocks_ne_ram_blocks
    sec
    sbc #vmem_block_pagecount
    tax
    tya
    sbc #0
    bne .max_dynmem_is_smaller
    cpx .max_dynmem
    bcc .game_blocks_is_smaller
.max_dynmem_is_smaller
    ldx .max_dynmem
.game_blocks_is_smaller
    bne .dynmem_adjust_done ; Always branch

.game_blocks_ne_ram_blocks
    ; Note that we can't have .game_blocks < .ram_blocks because we reduced
    ; .ram_blocks to match earlier, so .game_blocks > .ram_blocks. We don't want
    ; to reduce flexibility by locking parts of the game into RAM instead of
    ; allowing the virtual memory system to choose what lives in RAM. It's only
    ; a clear win to increase nonstored_blocks if it brings otherwise unusable
    ; RAM into play. Set nonstored_blocks =
    ; max(min(.ram_blocks - vmap_max_size * vmem_block_pagecount, .max_dynmem),
    ;     ACORN_INITIAL_NONSTORED_BLOCKS)
.min_lhs_sub = vmap_max_size * vmem_block_pagecount
    sec
    sbc #<.min_lhs_sub
    tax
    tya
    sbc #>.min_lhs_sub
    bmi .use_acorn_initial_nonstored_blocks
    bne .use_min_rhs
    cpx .max_dynmem
    bcc .use_min_lhs
.use_min_rhs
    ldx .max_dynmem
.use_min_lhs
    cpx #ACORN_INITIAL_NONSTORED_BLOCKS
    bcs .use_max_lhs
.use_acorn_initial_nonstored_blocks
    ldx #ACORN_INITIAL_NONSTORED_BLOCKS
.use_max_lhs
.dynmem_adjust_done
    stx nonstored_blocks
}
}

    ; Set .ram_blocks -= nonstored_blocks, i.e. set .ram_blocks to the number of
    ; RAM blocks we have available as virtual memory cache.
    lda .ram_blocks
    sec
    sbc nonstored_blocks
    sta .ram_blocks
    bcs +
    dec .ram_blocks + 1
+
    ; SFTODO: REVIEW ALL THE FOLLOWING FRESH, ESP "NEW" SWR CASE
    ; It's important .ram_blocks >= vmem_block_pagecount now so that we will set
    ; vmap_max_entries >= 1 below. Conceptually it makes sense for
    ; vmap_max_entries to be 0 but in practice lots of code assumes it isn't.
    ;
    ; The build system and loader work together to guarantee (initial)
    ; .ram_blocks >= ACORN_INITIAL_NONSTORED_BLOCKS + 2 * vmem_block_pagecount.
    ; If nonstored_blocks has not been adjusted, there are two cases:
    ; a) If we didn't set .ram_blocks = .game_blocks above, the build system and
    ;    loader guarantee means we now have .ram_blocks >= 2 *
    ;    vmem_block_pagecount. QED.
    ; b) If we did set .ram_blocks = .game_blocks above, we know that the
    ;    game has at least one block of non-dynamic memory, so before the
    ;    subtraction we had .ram_blocks = .game_blocks >=
    ;    ACORN_INITIAL_NONSTORED_BLOCKS + vmem_block_pagecount. QED.
    ;
    ; On a turbo second processor, we may have adjusted nonstored_blocks. There are
    ; two cases:
    ; a) If we didn't set .ram_blocks = .game_blocks above, as nonstored_blocks
    ;    lives in bank 0 and we also have banks 1 and 2 for virtual memory
    ;    cache, after the subtraction we have .ram_blocks ~= 128K >=
    ;    vmem_block_pagecount. QED.
    ; b) If we did set .ram_blocks = .game_blocks above, combine that with the
    ;    fact the adjustment to nonstored_blocks left nonstored_blocks <=
    ;    .game_blocks - vmem_block_pagecount. QED.
    ;
    ; On a sideways RAM build, we may have adjusted nonstored_blocks. There are
    ; two cases:
    ; a) If we didn't set .ram_blocks = .game_blocks above, we either:
    ;    1) set nonstored_blocks = ACORN_INITIAL_NONSTORED_BLOCKS; see the "not
    ;       been adjusted" case above.
    ;    2) set nonstored_blocks <= .ram_blocks - vmap_max_size *
    ;       vmem_block_pagecount, so after the subtraction we have .ram_blocks
    ;       >= vmap_max_size * vmem_block_pagecount. QED
    ; b) exactly the same as for the turbo second processor
}

!ifndef ACORN_SWR {
    ; vmap_first_ram_page is set at build time to suit a normal second processor
    ; and it's not used on a turbo second processor, so we don't need any code
    ; to initialise it.
}

    ; Now set vmap_max_entries = min(.ram_blocks / vmem_block_pagecount,
    ; vmap_max_size), i.e. the number of vmap entries we have RAM to support.
    ; (If we're in the ACORN_TUBE_CACHE case on a normal second processor, we
    ; have that much RAM in total but the number of vmap entries we can support
    ; is lower. It's convenient to work with this larger value while we do the
    ; initial load, then vmap_max_entries is fixed up later.)
    ldx #vmap_max_size
    lda .ram_blocks
    lsr .ram_blocks + 1
    bne .cap_at_vmap_max_size
    ror
    cmp #vmap_max_size
    bcs .cap_at_vmap_max_size
    tax
.cap_at_vmap_max_size
    stx vmap_max_entries

    ; SFTODO: Probably not, but can the existence of vmap_sort_entries help simplify the normal tube+cache case?
vmap_sort_entries = vmem_temp ; 1 byte
SFTODOLABEL5
!ifndef ACORN_NO_DYNMEM_ADJUST {
    ; If we've adjusted nonstored_blocks, we may need to sort more than
    ; vmap_max_entries elements of vmap and it's definitely safe to sort all
    ; vmap_max_size entries, because we either have enough RAM for vmap_max_size
    ; blocks of virtual memory cache or we have enough RAM for the entire game.
    lda nonstored_blocks
    cmp #ACORN_INITIAL_NONSTORED_BLOCKS
    beq +
    ldx #vmap_max_size
+
}
    stx vmap_sort_entries
}

    ; Load the nonstored blocks, or all the blocks if we're not using virtual
    ; memory. We don't need to worry about reading past the end of the game data
    ; here, because at worst we will read a final 512-byte block when we don't
    ; have a full block and that's fine.
.blocks_to_read = zp_temp + 4 ; 1 byte
    ; Because this is initialisation code, we know the following variables are
    ; already set to predictable values. This optimisation was useful at one
    ; point but it's not really important right now; it isn't too confusing so
    ; let's keep it anyway now it's been tested.
!if 0 {
    lda #2
    sta readblocks_numblocks
    lda #0
    sta readblocks_currentblock
    sta readblocks_currentblock + 1
    sta readblocks_mempos ; story_start is page-aligned
!ifdef ACORN_TURBO_SUPPORTED {
    ; On a turbo second processor readblocks_mempos + 2 is significant and will
    ; vary; it's probably still zero at this point but play it safe. On a normal
    ; second processor readblocks_mempos + 2 will always be 0 so this is
    ; redundant but harmless.
    sta readblocks_mempos + 2
}
} else {
    ; If we're on DFS the earlier read of the catalogue will have bumped
    ; readblocks_currentblock and readblocks_mempos, so they have to be set
    ; explicitly.
    lda #0
    sta readblocks_currentblock
}
    lda #>story_start
    sta readblocks_mempos + 1
!ifdef VMEM {
    lda nonstored_blocks
} else {
    lda .game_blocks
}
    sta .blocks_to_read

!ifdef ACORN_SWR_BIG_DYNMEM {
    ; Page in the first bank as dynamic memory may overflow into it.
    +acorn_page_in_bank_using_a ram_bank_list
}

.dynmem_load_loop
    jsr readblocks
    lda .blocks_to_read
    sec
    sbc readblocks_numblocks
    sta .blocks_to_read
    bne .dynmem_load_loop

!ifdef ACORN_SWR {
    ; Calculate vmem_blocks_in_main_ram and vmem_blocks_stolen_in_first_bank.
    lda nonstored_blocks
    clc
    adc #>story_start
    ldx #0
    stx vmem_blocks_stolen_in_first_bank
    sec
    sbc #>flat_ramtop
    bcc .some_vmem_in_main_ram
    lsr
    sta vmem_blocks_stolen_in_first_bank
    bpl + ; Always branch
.some_vmem_in_main_ram
    ; Carry is clear; negate A
    eor #$ff
    adc #1
    lsr
    sta vmem_blocks_in_main_ram
+
}

!ifdef VMEM {
!ifndef PREOPT {
    ; Sort vmap into ascending order, preserving the timestamps but using just the
    ; addresses as keys. This avoids the drive head jumping around during the
    ; initial load. The build system can't do this sort, because we're sorting
    ; the truncated list with just vmap_sort_entries not the full list of
    ; vmap_max_size entries.
    ;
    ; This only happens once and it's not a huge list so while we don't want it
    ; to be really slow, compactness and simplicity of code are also important.
    ; This is an insertion sort, implemented based on the pseudocode from
    ; https://en.m.wikipedia.org/wiki/Insertion_sort, which I've relabelled here
    ; to match the register use in the following code:
    ;
    ;     x = 1
    ;     while x < length(vmap_z)
    ;         temp = vmap_z[x]
    ;         y = x - 1
    ;         while y >= 0 and vmap_z[y] > temp 
    ;             vmap_z[y+1] = vmap_z[y]
    ;             y = y - 1
    ;         end while
    ;         vmap_z[y+1] = temp
    ;         x = x + 1
    ;     end while
    ;
    ; Invariants:
    ;       1 <= x <= length(vmap_z) <= vmap_max_size <= 255
    ;      -1 <= y < x, so -1 <= y <= 254
    ;
    ; This takes about 0.42 seconds to sort 255 shuffled entries at 2MHz; that's
    ; not great but it's not terrible. It takes about 0.1 seconds to sort 122
    ; shuffled entries, which is probably a more typical case. Given a sorted
    ; list - as will happen if the preopt mode has not been used - it takes
    ; about 0.02 seconds to "sort" 255 entries, so there's no significant
    ; performance penalty when this is not doing anything useful.
    ; (We could simply not include this code if we don't have any preopt data,
    ; but it's discardable init code so it's not really harmful and it seems
    ; best for support purposes to keep the code identical whether or not preopt
    ; data is supplied or not.)
    ldx #1
.outer_loop
    lda vmap_z_l,x
    sta zp_temp
    lda vmap_z_h,x
    sta zp_temp + 1
    and #vmem_highbyte_mask
    sta zp_temp + 4
    txa
    tay
.inner_loop
    dey
    lda vmap_z_h,y
    and #vmem_highbyte_mask
    cmp zp_temp + 4
    bne +
    lda vmap_z_l,y
    cmp zp_temp
    beq .exit_inner_loop
+   bcc .exit_inner_loop
    lda vmap_z_l,y
    sta vmap_z_l + 1,y
    lda vmap_z_h,y
    sta vmap_z_h + 1,y
    tya
    bne .inner_loop
    dey
.exit_inner_loop    
    ; We can't omit this iny and use vmap_z_[lh] + 1,y below to compensate
    ; because Y may be -1 (255) and so they're not equivalent.
    iny
    lda zp_temp
    sta vmap_z_l,y
    lda zp_temp + 1
    sta vmap_z_h,y
    inx
    cpx vmap_sort_entries
    bne .outer_loop

!ifndef ACORN_NO_DYNMEM_ADJUST {
    ; The initial vmap created by the build system assumes nonstored_blocks ==
    ; ACORN_INITIAL_NONSTORED_BLOCKS, so if we changed nonstored_blocks earlier
    ; we need to adjust the vmap to compensate. If we didn't adjust it, this
    ; code is a no-op. As the vmap is now sorted by address we just need to find
    ; the first entry which doesn't correspond to dynamic memory and move
    ; everything down so that entry becomes the first entry in the vmap. The
    ; space freed up at the end of the vmap by this move is filled with dummy
    ; entries so those entries will be used first when the game needs to load
    ; more blocks from disc.
SFTODOLABEL2
    ldx #255
.find_first_non_promoted_entry_loop
    inx
    lda vmap_z_h,x
    and #vmem_highbyte_mask
    bne .found_first_non_promoted_entry
    lda vmap_z_l,x
    cmp nonstored_blocks
    bcc .find_first_non_promoted_entry_loop
.found_first_non_promoted_entry
    txa
    beq .no_dynmem_promotion
    ldy #0
.vmap_move_down_loop
    cpx #vmap_max_size
    beq .use_dummy_entry
    lda vmap_z_h,x
    sta vmap_z_h,y
    lda vmap_z_l,x
    inx
    bne + ; Always branch
.use_dummy_entry
    ; We use $0101 as a dummy entry; this has the oldest possible timestamp so
    ; the entry will be re-used ASAP and because it has the low bit of the
    ; address set it can never accidentally match a lookup. (We could use 0 in
    ; practice; that would never match a lookup because address 0 is guaranteed
    ; to be dynamic memory so we will never search the vmap for it. But it seems
    ; a little clearer to use $0101, and this needs to execute on all machines
    ; so we can't micro-optimise by using stz.)
    lda #1
    sta vmap_z_h,y
+   sta vmap_z_l,y
    iny
    cpy vmap_max_entries
    bne .vmap_move_down_loop
.no_dynmem_promotion
}

    ; Debugging code - use this in conjunction with --print-vm.
!if 0 {
    jsr streams_init
    ; vmap_used_entries is set later in normal use, but set it early here so
    ; print_vm shows the entire vmap.
    lda vmap_max_entries
    sta vmap_used_entries
    lda #'X'
    jsr s_printchar
    lda #>story_start
    jsr print_byte_as_hex
    lda nonstored_blocks
    jsr print_byte_as_hex
    jsr newline
    jsr osrdch
}

    ; Now we've got vmap how we want it, load the corresponding blocks into
    ; memory and initialise vmap_used_entries. (This roughly corresponds to the
    ; C64 load_suggested_pages subroutine.)

!ifdef ACORN_TURBO_SUPPORTED {
    bit is_turbo
    bpl .normal_tube_load
    ; On a turbo second processor we don't do any preloading of the host cache
    ; so we just use a straightforward load loop like the non-tube-cache case
    ; below.
    stz vmap_index
!ifdef ACORN_TUBE_CACHE {
    lda #$ff
    sta osword_cache_index_offered
    sta osword_cache_index_offered + 1
}
.turbo_load_loop
    jsr load_blocks_from_index
    inc vmap_index
    lda vmap_index
    cmp vmap_max_entries
    bne .turbo_load_loop
    sta vmap_used_entries
    jmp .all_loading_done

.normal_tube_load
}

!ifdef ACORN_TUBE_CACHE {
; SFTODO: These labels should probably start with a "."
inflated_vmap_max_entries = zp_temp
from_index = zp_temp + 1
to_index = vmap_index
load_scratch_space = flat_ramtop - vmem_blocksize
SFTODOLABELX2

    ; vmap_max_entries was deliberately artificially high up to this point so
    ; we'd retain and sort more of the initial vmap; set it to the correct value
    ; reflecting the size of the vmap Ozmoo's virtual memory has to work with.
    ; SFTODO: Worth noting that here - and might be useful in some other code
    ; too - we are calculating using known-at-build-time values. I could
    ; potentially simplify/shorten the code in a few places by not treating this
    ; dynamically, e.g. we wouldn't need the code to populate .game_blocks in
    ; the first place. (on SWR builds the dynmem growth optimisation means
    ; nonstored_blocks is not precisely known at build time, but that's not an
    ; issue for a tube build) This might also simplify some corner cases in the
    ; "grow nonstored_blocks" logic, because the game size is no longer a
    ; runtime variable. I just worry a little bit about this breaking
    ; already-not-supposed-to-work-but-sort-of-does-just-about things where a
    ; game developer wants to switch in an updated data file without going
    ; through the Ozmoo build process.
    lda vmap_max_entries
    sta inflated_vmap_max_entries
    lda #>(flat_ramtop - story_start)
    ldx .game_blocks + 1
    bne +
    cmp .game_blocks
    bcc +
    lda .game_blocks
+   sec
    sbc nonstored_blocks
    lsr
    sta vmap_max_entries
    sta vmap_used_entries
    ; Adjust .host_cache_size so the following load loop won't try to put "too
    ; much" into the host cache; if this happens we might not have enough blocks
    ; to load into the local virtual memory cache and so some vmap entries would
    ; be present but not have actually been loaded. (This can happen because the
    ; cutover timestamp isn't that precise due to limited timestamp resolution,
    ; especially for Z4+ games.) Note that this doesn't actually stop us using
    ; more of the host cache; we will offer it blocks willy-nilly during play
    ; and if it has space it will hold onto them.
SFTODOLABELX3
    lda inflated_vmap_max_entries
    sec
    sbc vmap_max_entries
    sta .host_cache_size

    ; We now need to load the inflated_vmap_max_entries blocks in the vmap from
    ; disk; vmap_max_entries blocks will go into our local memory as normal, the
    ; remainder need to be handed over to the host cache. We want the newer
    ; (higher timestamp) blocks in local memory, but remember vmap is sorted by
    ; block address to avoid the disk head jumping around. We use knowledge of
    ; how the build system generates the timestamps on vmap to identify a
    ; timestamp cutover point which will (except for the fact that the same
    ; timestamp can occur on multiple entries) separate the vmap into two chunks
    ; of the required sizes. (If the cutover timestamp is calculated
    ; incorrectly, we will still load everything we should, but newer blocks
    ; will tend to be in the host cache when we'd prefer them to be in local
    ; memory.)
.vmem_blocks = ((>(flat_ramtop - story_start)) - ACORN_INITIAL_NONSTORED_BLOCKS) / vmem_block_pagecount
.cutover_timestamp = int(ACORN_TUBE_CACHE_MAX_TIMESTAMP + ((float(.vmem_blocks) / vmap_max_size) * (ACORN_TUBE_CACHE_MIN_TIMESTAMP - ACORN_TUBE_CACHE_MAX_TIMESTAMP))) and ($ff xor vmem_highbyte_mask)

    ; Work through the blocks in vmap, loading each in turn and offering it to
    ; the host cache if it's old and there's room, and keeping it loaded into
    ; local memory otherwise. We keep doing this until we've loaded
    ; vmap_max_entries blocks into local memory (blocks offered to the host
    ; cache don't count) or until we've loaded all the blocks in vmap.
    lda #0
    sta from_index
    sta to_index
    lda #$ff
    sta osword_cache_index_offered
    sta osword_cache_index_offered + 1
.first_load_loop
    ldx from_index
    ldy to_index
    lda vmap_z_l,x
    sta vmap_z_l,y
    lda vmap_z_h,x
    sta vmap_z_h,y
    jsr load_blocks_from_index
    ldy to_index
    lda vmap_z_h,y
    ; and #$ff xor vmem_highbyte_mask ; not necessary as we're doing a >= test
    cmp #.cutover_timestamp + 1
    bcs .dont_put_in_cache
+   ldx .host_cache_size
    beq .dont_put_in_cache
    dec .host_cache_size
    and #$ff xor vmem_highbyte_mask
    sta osword_cache_index_offered_timestamp_hint
    ; load_blocks_from_index will have set osword_cache_index_requested
    lda osword_cache_index_requested
    sta osword_cache_index_offered
    lda osword_cache_index_requested + 1
    sta osword_cache_index_offered + 1
    jmp .continue
.dont_put_in_cache
    lda #$ff
    sta osword_cache_index_offered
    sta osword_cache_index_offered + 1
    inc to_index
.continue
    inc from_index
    lda to_index
    cmp vmap_max_entries
    bne .first_load_loop

    ; We may have already loaded all the blocks, but if we haven't we now need
    ; to start re-using vmap[vmap_max_entries - 1] to load the rest. (We can
    ; only load into local memory and we've used it all.) We no longer have the
    ; luxury of (easily) putting the blocks with older timestamps into the host
    ; cache and keeping the younger ones in local memory, but if we chose the
    ; cutover timestamp correctly we should end up with at most one misplaced
    ; block in each cache. SFTODO: I'M NOT SURE IT'S AS PRECISE AS ONE MISPLACED BLOCK, DUE TO LACK OF TIMESTAMP RESOLUTION - IT MAY BE ONE MISPLACED *TIMESTAMP*. IT ISN'T THAT BIG A DEAL, BUT THINK ABOUT THIS AND UPDATE THIS COMMENT. The misplaced block in the host cache will be the
    ; newest block in the host cache so it will spend a long time in there
    ; before being discarded, which should give plenty of opportunity for it to
    ; be requested during gameplay and moved into local memory before it's lost.
    ; SFTODO: vmap_index is an alias for to_index, maybe use to_index in the follow loop to match the previous loop? This (double check) is just a labelling change, the code would be identical.
    dec vmap_index ; set vmap_index = vmap_max_entries - 1
.second_load_loop
    ldx from_index
    cpx inflated_vmap_max_entries
    beq .second_load_loop_done
    ldy vmap_index
    lda vmap_z_l,y
    sta osword_cache_index_offered
    lda vmap_z_h,y
    and #vmem_highbyte_mask
    sta osword_cache_index_offered + 1
    lda vmap_z_h,y
    and #$ff xor vmem_highbyte_mask
    sta osword_cache_index_offered_timestamp_hint
    lda vmap_z_l,x
    sta vmap_z_l,y
    lda vmap_z_h,x
    sta vmap_z_h,y
    jsr load_blocks_from_index
    inc from_index
    jmp .second_load_loop
.second_load_loop_done
    ; Now we've finished the initial load, specify no timestamp hint for cache
    ; operations; this setting will remain untouched for the rest of the game.
    lda #osword_cache_no_timestamp_hint
    sta osword_cache_index_offered_timestamp_hint
} else { ; not ACORN_TUBE_CACHE
    ; Load the blocks in vmap.
    lda #0
    sta vmap_index
-   jsr load_blocks_from_index
    inc vmap_index
    lda vmap_index
    cmp vmap_max_entries
    bne -
SFTODOLABEL4
    sta vmap_used_entries
}
.all_loading_done

!ifdef ACORN_SWR {
    ; The load loop may have left the last bank of sideways RAM paged in; we
    ; need to page the default bank back in.
    +acorn_swr_page_in_default_bank_using_y
}
} ; End of !ifndef PREOPT
} ; End of !ifdef VMEM

    ; Calculate CRC of block 0 before it gets modified, so we can use it later
    ; to identify the game disc after a save or restore.
    lda #0
    ldx #<story_start
    ldy #>story_start
    jsr calculate_crc ; corrupts some zp_temp locations
    stx game_disc_crc
    sty game_disc_crc + 1
} ; End of acorn_deletable_init_inline

!ifdef ACORN_SWR {
!macro acorn_swr_page_in_default_bank_using_y {
!ifdef ACORN_SWR_BIG_DYNMEM {
    +acorn_page_in_bank_using_y ram_bank_list
} else {
    +acorn_page_in_bank_using_y z_pc_mempointer_ram_bank
}
}
}

; Acorn-specific initialization to carry out in deletable_screen_init_2. This is
; quite late in the initialization process - in particular it happens after the
; lengthy loading process in acorn_deletable_init_inline.
!macro acorn_deletable_screen_init_2_inline {
!ifdef ACORN_NO_SHADOW {
    ; It's not safe to do vdu_cls without having a text window in effect.
    ; Normally the one set up when we first entered this version of mode 7 is
    ; in effect, but if there's been any output (e.g. due to disc errors) via
    ; s_printchar between then and now we may no longer have one in effect.
    ; s_printchar normally takes care of creating one as needed, but since we're
    ; going to do vdu_cls directly we need to take care of this.
    +define_mode_7_3c00_text_window_inline
    lda #vdu_cls
    jsr oswrch
} else {
    ; Set the desired mode. If we're already in the right mode we don't reselect
    ; it, to avoid the screen flashing briefly to black. This is deletable init
    ; code so we can afford minor luxuries like this.
    lda #osbyte_read_screen_mode
    jsr osbyte
    cpy screen_mode
    beq .already_in_right_mode
    lda #vdu_set_mode
    jsr oswrch
    lda screen_mode
    ora #128 ; force shadow mode on
    jsr oswrch
    jmp .mode_set
.already_in_right_mode
    ; Clear the screen; this is mostly unnecessary, but for Z3 games which are
    ; loading from the loader in mode 7 it clears any leftover text on the top
    ; line of the screen.
    lda #vdu_cls
    jsr oswrch
.mode_set
    ; Setting the mode will have turned the cursor back on, so fix that.
    jsr init_cursor_control
    ; We must re-initialise screenkernal to pick up the details of the new mode.
    jsr screenkernal_init
    ; We must also reset the window sizes; we do this by re-executing
    ; deletable_screen_init_1.
    jsr deletable_screen_init_1
}

!ifdef ACORN_HW_SCROLL {
    ldx #1
    ldy screen_mode
    cpy #7
    bne +
    dex
+   stx use_hw_scroll
}
    jsr update_colours
} ; End of acorn_deletable_screen_init_2_inline

!macro clean_up_and_quit_inline {
    ; TODO: Should this print something like "[Press SPACE]", flush keyboard
    ; buffer and wait for SPACE before continuing? Maybe also adding a blank
    ; line of output before we call osbyte_enter_language for neatness. Apart
    ; from looking nicer, this might have a useful gameplay function as entering
    ; BASIC could cause text to scroll which the user hasn't read yet, whereas
    ; our "[Press SPACE]" prompt would be done under control of Ozmoo's paging.
!ifdef ACORN_NO_SHADOW {
    jsr undo_mode_7_3c00
}
    jsr set_os_normal_video
    jsr turn_on_cursor
    ldx #0
    jsr do_osbyte_rw_escape_key
!ifdef ACORN_CURSOR_PASS_THROUGH {
    jsr do_osbyte_set_cursor_editing_x_0
}
!ifdef ACORN_FUNCTION_KEY_PASS_THROUGH {
    lda #osbyte_rw_function_key_status
    ldx #1 ; default - expand as normal soft key
    jsr do_osbyte_y_0
    lda #osbyte_rw_shift_function_key_status
    ldx #$80 ; default - generate $80+n
    jsr do_osbyte_y_0
}
    ; Re-enter the current language.
re_enter_language
    lda #osbyte_enter_language
re_enter_language_ldx_imm
    ldx #$ff
    jsr osbyte
    ; never returns
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OS error handling and associated routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

error_handler
    ldy .error_handler_newlines
    beq +
-   lda #13
    jsr .error_handler_print_char
    dey
    bne -
+   ldy #1
-   lda (error_ptr), y
    beq +
    jsr .error_handler_print_char
    iny
    bne - ; Always branch
    ; The following jmp will be patched by code which wants to gain control
    ; after an error.
.error_handler_jmp
+   jmp .press_break

default_error_handler_newlines = 2
.error_handler_newlines !byte default_error_handler_newlines

.press_break
    ; We don't use print_following_string here because we don't want to assume
    ; Ozmoo's own printing mechanisms are properly initialized.
    jsr error_print_following_string
    !text " - press BREAK",0
-   jmp -

; Depending on what's happening when an error occurs, we need to output using
; different primitives. We therefore always use this subroutine and it gets
; patched at runtime.
.error_handler_print_char
    jmp s_printchar

; Like print_following_string, but using .error_handler_print_char.
error_print_following_string
    pla
    sta .error_print_following_string_lda + 1
    pla
    sta .error_print_following_string_lda + 2
-   inc .error_print_following_string_lda + 1
    bne +
    inc .error_print_following_string_lda + 2
+
.error_print_following_string_lda
    lda $ffff
    beq +
    jsr .error_handler_print_char
    jmp -
+   lda .error_print_following_string_lda + 2
    pha
    lda .error_print_following_string_lda + 1
    pha
    rts

error_print_s_printchar = 0
error_print_osasci = 1
.error_print_table_l
    !byte <s_printchar
    !byte <osasci
.error_print_table_h
    !byte >s_printchar
    !byte >osasci

; Allow trapping of errors signalled by the OS via BRKV. Used like this:
;   ldx #2 ; number of newlines to print before any error
;   ldy #n ; type of printing to use if an error occurs (0 s_printchar, 1 osasci)
;   jsr setjmp
;   beq ok
;   ; error occurred, do something
;   jsr set_default_error_handler ; before returning
;   rts
; ok
;   ; do something that might cause an error
;   jsr set_default_error_handler ; errors after this point aren't our problem
setjmp
    stx .error_handler_newlines
    lda .error_print_table_l,y
    sta .error_handler_print_char + 1
    lda .error_print_table_h,y
    sta .error_handler_print_char + 2
    lda #<.setjmp_error_handler
    sta .error_handler_jmp + 1
    lda #>.setjmp_error_handler
    sta .error_handler_jmp + 2
!ifdef ACORN_SWR {
    ; The OS will page the current language back in on BRK, so we need to save
    ; the current bank and restore it in .setjmp_error_handler.
    lda romsel_copy
    sta jmp_buf_ram_bank
}
    ; We need to save the contents of the stack, because they may be corrupted
    ; when an error message is generated. (They probably won't be, but we can't
    ; rely on it.) As a nice side effect of this, the return address for our
    ; caller is saved so .setjmp_error_handler can simply rts after restoring
    ; the stack.
    ; SFTODO: If jmp_buf is made smaller, we could probably fairly easily
    ; detect overflow - initialize y with -buffer_size, do sta jmp_buf+1+buffer_size,y
    ; and if the bne after the iny isn't taken we've overflowed. There might be
    ; an off by one error in that, I'm just sketching the idea out. This is
    ; tempting, *but* at the moment jmp_buf is going to live in $400-800 and
    ; (except for the possibility of starting code at say $600 on 2P) we have
    ; loads of free space down there, so adding a few bytes of code to the VM
    ; to detect overflow and cause a fatal error will eat into valuable memory
    ; for the sake of optimising use of a currently not-scare resource. Think
    ; about it, maybe convert this to an SF: comment.
    tsx
    stx jmp_buf
    ldy #0
-   inx
    beq +
    lda stack,x
    sta jmp_buf+1,y
    iny
    bne -
+   ; Z flag is set
    rts

.setjmp_error_handler
    ldx jmp_buf
    txs
    ldy #0
-   inx
    beq +
    lda jmp_buf+1,y
    sta stack,x
    iny
    bne -
+   
!ifdef ACORN_SWR {
    +acorn_page_in_bank_using_a jmp_buf_ram_bank
}
    lda #1 ; Z flag is clear
    rts

set_default_error_handler
    lda #default_error_handler_newlines
    sta .error_handler_newlines
    lda #<s_printchar
    sta .error_handler_print_char + 1
    lda #>s_printchar
    sta .error_handler_print_char + 2
    lda #<.press_break
    sta .error_handler_jmp + 1
    lda #>.press_break
    sta .error_handler_jmp + 2
.set_default_error_handler_rts
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; C64 kernal_readtime emulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; The Acorn OS time counter is a 5 byte value, whereas (ignoring the
    ; difference in resolution) the Commodore one is 3 bytes. Because the Acorn
    ; OS time counter may have an arbitrarily large value (perhaps some kind of
    ; soft RTC solution) when we start up and we don't want to zero it, we read
    ; the initial value and subtract that from any subsequent reads.
!macro init_readtime_inline {
    lda #osword_read_clock
    ldx #<initial_clock
    ldy #>initial_clock
    jsr osword
}

kernal_readtime
.current_clock = scratch_page
    lda #osword_read_clock
    ldx #<.current_clock
    ldy #>.current_clock
    jsr osword
    ldx #(256-5)
    sec
-   lda .current_clock-(256-5),x
    sbc initial_clock-(256-5),x
    sta .current_clock-(256-5),x
    inx
    bne -
    ; The Acorn clock is in centiseconds; a PAL C64 would use fiftieths of a
    ; second, so halve the value before we return it.
    ldx #4
    clc
-   ror .current_clock,x
    dex
    bpl -
    ; All the above means we're at no more or less risk than a C64 of having the
    ; time roll over during a game. It would take >3.8 days for this to happen.
    ldy .current_clock+2
    ldx .current_clock+1
    lda .current_clock+0
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ACORN_NO_SHADOW support (mode 7 screen at $3c00 instead of $7c00)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; If we have no shadow RAM, we need to relocate the mode 7 screen to $3c00 to
; create a contiguous area of RAM from $4000-$c000. See
; https://stardot.org.uk/forums/viewtopic.php?f=54&t=20149 for more discussion
; on this.
!ifdef ACORN_NO_SHADOW {

!ifndef ACORN_SWR {
    !error "ACORN_NO_SHADOW only makes sense with ACORN_SWR"
}

!ifdef ACORN_HW_SCROLL {
    ; The OS can't hardware scroll the mode 7 screen at this non-standard
    ; location.
    !error "ACORN_HW_SCROLL is not compatible with ACORN_NO_SHADOW"
}

!macro make_acorn_screen_hole {
.tolerance = 256
    !if * <= $3c00 {
        !if ($3c00 - *) <= .tolerance {
acorn_screen_hole_start = *
            !fill $4000 - *, 'X'
acorn_screen_hole_end
        }
    }
}

!macro make_acorn_screen_hole_jmp {
.jmp_size = 3
.tolerance = 256
    !if * <= ($3c00 - .jmp_size) {
        !if ($3c00 - *) <= .tolerance {
            jmp acorn_screen_hole_end
acorn_screen_hole_start = *
            !fill $4000 - *, 'X'
acorn_screen_hole_end
        }
    }
}

; On $e00 builds the binary is likely to fit entirely below the screen at $3c00.
; We need the stack and story to be contiguous, so we must insert a large enough
; hole at this point even if we're not close to $3c00.
;
; .swap_pointers_for_save will temporarily corrupt the last few bytes of the
; screen memory just below the start of the stack (i.e. just below $4000), but
; this shouldn't actually be visible because we're using software scrolling and
; the mode 7 screen data actually only occupies the first 40*25 bytes at $3c00,
; so it's not necessary to include some extra padding at $4000 to avoid this.
; SFTODO: BE GOOD TO TEST THIS!
!macro make_acorn_screen_hole_before_stack {
    !if * <= $3c00 {
acorn_screen_hole_start = *
        !fill $4000 - *, 'X'
acorn_screen_hole_end
    }
}

!macro check_acorn_screen_hole {
    ; This check is important to ensure the no shadow RAM build doesn't crash,
    ; but when the check fails, we need to be able to disable it in order to
    ; allow assembly to complete so we can look at the acme report output and
    ; decide where to add a +make_acorn_screen_hole invocation.
    !ifndef ACORN_DISABLE_SCREEN_HOLE_CHECK {
        !ifndef acorn_screen_hole_start {
            !error "Acorn screen hole has not been added"
        } else {
            !if acorn_screen_hole_start > $3c00 {
                !error "Acorn screen hole starts too late"
            }
            !if acorn_screen_hole_end < $4000 {
                !error "Acorn screen hole ends too soon"
            }
        }
    }
}

; This macro is like an initialization subroutine, but by using a macro we
; can place it in the discardable init code while still having it in this file
; where it logically belongs.
!macro set_up_mode_7_3c00_inline {
    ; In reality we don't expect to be called with our handlers already
    ; installed, but be paranoid - this is deletable init code so it's mostly
    ; free.
    lda wrchv
    cmp #<our_wrchv
    bne +
    lda wrchv + 1
    cmp #>our_wrchv
    beq .set_up_mode_7_3c00_done
+

    ; Copy the contents of the current screen for neatness.
    ldx #$7c
    ldy #$3c
    jsr screen_copy

    ; Reprogram the CRTC and poke the OS variables to mostly compensate.
    lda #crtc_screen_start_high
    sta crtc_register
    lda #$20
    sta crtc_data
    lda #$3c
    sta bottom_of_screen_memory_high
    sta display_start_address + 1

    ; Define a text window and reposition the cursor; doing this forces the OS
    ; to notice the changes we just made. The text window also prevents hardware
    ; scrolling; all the output from the main Ozmoo code will be protected using
    ; text windows anyway since ACORN_HW_SCROLL is not defined, but having one
    ; in place straight away is useful insurance.
    lda #osbyte_read_cursor_position
    jsr osbyte
    +define_mode_7_3c00_text_window_inline
    jsr do_oswrch_vdu_goto_xy

    ; Install our handlers to fix some problems with the OS's handling of this
    ; unofficial mode.
    lda wrchv
    sta call_old_wrchv + 1
    lda wrchv + 1
    sta call_old_wrchv + 2
    lda #<our_wrchv
    sta wrchv
    lda #>our_wrchv
    sta wrchv + 1
    lda keyv
    sta call_old_keyv + 1
    lda keyv + 1
    sta call_old_keyv + 2
    lda #<our_keyv
    sta keyv
    lda #>our_keyv
    sta keyv + 1

.set_up_mode_7_3c00_done
}

!macro define_mode_7_3c00_text_window_inline {
    lda #vdu_define_text_window
    jsr oswrch
    lda #0
    jsr oswrch
    lda #24
    jsr oswrch
    lda #39
    jsr oswrch
    lda #0
    jsr oswrch
}

!macro adjust_cursor_inline {
    lda #crtc_cursor_start_high
    sta crtc_register
    lda text_cursor_address + 1
    sec
    sbc #$1c
    sta crtc_data
}

our_wrchv
call_old_wrchv
    jsr $ffff ; patched during initialization
    pha
    +adjust_cursor_inline
    pla
    rts

our_keyv
    bcc call_old_keyv
    bvc call_old_keyv
    ; keyboard timer interrupt entry
    jsr call_old_keyv
    php
    pha
    bit vdu_status
    bvc .not_cursor_editing
    +adjust_cursor_inline
.not_cursor_editing
    pla
    plp
    rts
call_old_keyv
    jmp $ffff ; patched during initialization

undo_mode_7_3c00
    ; Reset the vectors we fiddled with.
    lda call_old_wrchv + 1
    sta wrchv
    lda call_old_wrchv + 2
    sta wrchv + 1
    lda call_old_keyv + 1
    sta keyv
    lda call_old_keyv + 2
    sta keyv + 1

    ; Switch to normal mode 7. This clears the screen, so we copy the contents
    ; back and restore the cursor position. This is maybe overkill, but it's
    ; important any final message shown when the game quits can be seen by the
    ; user.
    lda #osbyte_read_cursor_position
    jsr osbyte
    lda #vdu_set_mode
    jsr oswrch
    lda #7
    jsr oswrch
    jsr do_oswrch_vdu_goto_xy

    ldx #$3c
    ldy #$7c
    ; fall through to screen_copy

screen_copy
    stx .screen_copy_lda_abs_y + 2
    sty .screen_copy_sta_abs_y + 2
    ldx #4
.screen_copy_loop
    ldy #0
.screen_copy_loop2
.screen_copy_lda_abs_y
    lda $ff00,y ; patched
.screen_copy_sta_abs_y
    sta $ff00,y ; patched
    iny
    bne .screen_copy_loop2
    inc .screen_copy_lda_abs_y + 2
    inc .screen_copy_sta_abs_y + 2
    dex
    bne .screen_copy_loop
    rts
} ; End of !ifdef ACORN_NO_SHADOW

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Miscellaneous utility routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Like printstring_raw, but using OSASCI.
printstring_os
    stx .printstring_os_lda + 1
    sta .printstring_os_lda + 2
-
.printstring_os_lda
   lda $ffff
   beq .calculate_crc_rts
   jsr osasci
   inc .printstring_os_lda + 1
   bne -
   inc .printstring_os_lda + 2
   bne - ; Always branch

; Calculate a CRC over A bytes of data at YX (A=0 => 256 bytes), returning it in
; YX.
calculate_crc
; This must not use the same location as .result in acorn-disk.asm as otherwise
; when .get_game_disc_back calls calculate_crc it will be overwritten.
.crc = zp_temp + 2 ; 2 bytes 
    sta .cpy_imm + 1
    stx .eor_abs + 1
    sty .eor_abs + 2
    lda #0
    sta .crc + 1
    sta .crc
    tay
.nbyt
    lda .crc + 1
.eor_abs
    eor $ffff,y
    sta .crc + 1
    ldx #8
.loop
    lda .crc + 1
    rol
    bcc .b7z
    lda .crc + 1
    eor #8
    sta .crc + 1
    lda .crc
    eor #$10
    sta .crc
.b7z
    rol .crc
    rol .crc + 1
    dex
    bne .loop
    iny
.cpy_imm
    cpy #$ff
    bne .nbyt
    ldx .crc
    ldy .crc + 1
.calculate_crc_rts
    rts

; Two wrappers for calling osbyte_set_cursor_editing to reduce code size; we do
; this in several places.
do_osbyte_set_cursor_editing_x_0
    ldx #0
do_osbyte_set_cursor_editing
    lda #osbyte_set_cursor_editing
    bne do_osbyte_y_0 ; Always branch

; Two wrappers for calling osbyte_rw_escape_key to reduce code size; we do this
; in several places.
do_osbyte_rw_escape_key
    lda #osbyte_rw_escape_key
do_osbyte_y_0
    ldy #0
    jmp osbyte

; Move the OS cursor to (X, Y).
do_oswrch_vdu_goto_xy
    lda #vdu_goto_xy
    jsr oswrch
    txa
    jsr oswrch
    tya
    jmp oswrch

; SF: ENHANCEMENT: It would potentially be possible to support bold and
; underlined text in modes other than 7, although we'd either need to do it via
; OSWORD 10 and UDG redefinition (which is probably quite slow) or install
; some kind of custom driver around OSWRCH and have that run on the host even if
; we're using a second processor. As a "cheap" version, it would be possible to
; use colours in mode 1 for bold, but I'm not particularly keen to support this
; just for one mode which probably no one would use.
;
; SF: ENHANCEMENT: It would also with a bit more effort probably be possible
; to use a proportionally spaced font in modes other than 7, though this would
; be a more intrusive code change.
;
; SFTODO: Once the upstream dynamic memory access rework is completed and merged, it *may* be possible to do things like (on a turbo copro) use bank 0 free memory plus the whole of bank 1 for dynamic memory, and have banks 2 and 3 for virtual memory cache, or to promote the whole of a game <= ~210K to be pure dynamic memory. Or if we have more main+SWR than the game size, to promote the whole game to dynamic memory and do a simple absolute Z-machine to bank address conversion. I suspect it won't allow >64K dynamic memory, but just making this note so I can consider it when I see how upstream change works.

}
