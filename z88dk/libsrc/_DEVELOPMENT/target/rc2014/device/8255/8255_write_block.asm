
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC ide_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register
ide_write_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CONFIG  ;keep iterative count in b
    ld d, __IO_PIO_IDE_WR
    out (c), d              ;config 8255 chip, write mode
    ld c, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;drive address onto control lines

IF (__IO_PIO_IDE_CTL = __IO_PIO_IDE_MSB+1) & (__IO_PIO_IDE_MSB = __IO_PIO_IDE_LSB+1)
ide_wrblk2: 
    ld d, __IO_IDE_DATA|__IO_IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld c, __IO_PIO_IDE_LSB  ;drive lower lines with lsb
    outi                    ;write the lower byte (HL++)
    inc c                   ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    inc c                   ;drive control port
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert write pin
    djnz ide_wrblk2         ;keep iterative count in b

ELSE
ide_wrblk2: 
    ld d, __IO_IDE_DATA|__IO_IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld c, __IO_PIO_IDE_LSB  ;drive lower lines with lsb
    outi                    ;write the lower byte (HL++)
    ld c, __IO_PIO_IDE_MSB  ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    ld c, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert write pin
    djnz ide_wrblk2         ;keep iterative count in b

ENDIF
;   ld c, __IO_PIO_IDE_CTL  ;remembering what's in bc
;   ld b, $0
    out (c), b              ;deassert all control pins
    ld c, __IO_PIO_IDE_CONFIG
    ld d, __IO_PIO_IDE_RD
    out (c), d              ;config 8255 chip, read mode
    pop de
    pop bc
    ret
