!source "acorn-constants.asm"

data_start
    !binary "../temp/binary.lzsa2"
data_end

lzsa_cmdbuf     =       $70                     ; 1 byte.
lzsa_nibflg     =       $71                     ; 1 byte.
lzsa_nibble     =       $72                     ; 1 byte.
lzsa_offset     =       $73                     ; 1 word.
lzsa_winptr     =       $75                     ; 1 word.
lzsa_srcptr     =       $77                     ; 1 word.
lzsa_dstptr     =       $79                     ; 1 word.

lzsa_length     =       lzsa_winptr             ; 1 word.

LZSA_SRC_LO     =       lzsa_srcptr
LZSA_SRC_HI     =       lzsa_srcptr + 1
LZSA_DST_LO     =       lzsa_dstptr
LZSA_DST_HI     =       lzsa_dstptr + 1

decompress
    lda #<data_start
    sta LZSA_SRC_LO
    lda #>data_start
    sta LZSA_SRC_HI
    lda #<DECOMPRESS_TO
    sta LZSA_DST_LO
    lda #>DECOMPRESS_TO
    sta LZSA_DST_HI
!source "acorn-lzsa-faster.asm"
