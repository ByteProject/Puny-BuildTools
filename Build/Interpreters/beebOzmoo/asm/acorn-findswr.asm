; Acorn-specific code; this is a standalone utility to detect sideways RAM, not
; part of the Ozmoo binary itself. This is derived from Wouter Scholten's public
; domain swrtype-0.7. (http://wouter.bbcmicro.net/bbc/software-whs.html)

!source "acorn-constants.asm"

copyright_offset = $8007
test_location    = $8008 ; binary version number of ROM
max_ram_bank_count = 9 ; 255*0.5K for VM plus 16K for dynamic memory

; We arrange for the output to be near the start of this binary so the loader
; can access it at fixed addresses.

    jmp start

; Output for Ozmoo
swr_type        !byte 0
ram_bank_count2 !byte 0
ram_bank_list2  !fill max_ram_bank_count

+assert ram_bank_count = ram_bank_count2
+assert ram_bank_list = ram_bank_list2

; Storage used by this routine which the loader doesn't care about
swr_test   = $100 ; !fill $10
swr_backup = $110 ; !fill $10
swr_banks       !byte 0
swr_byte_value1 !byte 0
swr_byte_value2 !byte 0
dummy           !byte 0
tmp             !byte 0
bbc             !byte 0

start
    LDA #osbyte_read_host
    LDX #1
    JSR osbyte
    TXA
    BEQ +
    LDX #$FF
+   STX bbc ; $FF for BBC, 0 for Electron
    
    SEI
    ; save original contents
    LDY #0
lp
    JSR page_in_y_corrupt_a
    LDA test_location
    STA swr_backup,Y
    INY
    CPY #16
    BCC lp

    LDA #0
    STA swr_banks
    LDA #255
    STA swr_type

    ; now test which type

    LDY #0
    LDA #0
lp0
    STA swr_test,Y
    INY
    CPY #16
    BCC lp0

    LDA #$80
    STA swr_byte_value1
    LDA #$E3
    STA swr_byte_value2

    LDY #0
bank_lp_y
    JSR set_all
    ; Skip banks with a valid ROM header; we check this instead of using the table
    ; at $2A1 so we don't use banks which contain valid ROM images temporarily
    ; disabled by a ROM manager.
    LDX copyright_offset
    LDA $8000,X
    BNE invalid_header
    LDA $8001,X
    CMP #'('
    BNE invalid_header
    LDA $8002,X
    CMP #'C'
    BNE invalid_header
    LDA $8003,X
    CMP #')'
    BEQ cmp_next_y
invalid_header
    TYA
    EOR swr_byte_value1
    STA tmp
    STA test_location
    LDX #15
bank_lp_x
    LDA #0
    STA dummy
    JSR page_in_x_corrupt_a
    LDA test_location
    CMP tmp
    BNE cmp_next_x
    ; equality could be accidental (ROM or RAM bank had tested value
    ; already), so try a 2nd value.
    ; First restore romsel for write
    JSR set_romsel
    TYA
    EOR swr_byte_value2
    STA tmp
    STA test_location
    ; write 0 to a dummy location. Goal is to change the databus value.
    ; Otherwise, in a fully decoded bank system, locations that do not
    ; have ROM or RAM, will not change the value on the address bus,
    ; at least for several cycles, so the old one stays...
    ; On my main BBC, this works with at least 2 NOPs
    ;     LDA #value STA test_location NOP NOP CMP test_location
    ; but here we need at least 3
    ;     LDA #value STA test_location NOP NOP NOP LDA test_location CMP #value
    ; Better explicity change the value to something else, as this may
    ; vary between CPUs/systems? (e.g. depending on load on the bus).
    LDA #0
    STA dummy

    JSR page_in_x_corrupt_a
    LDA test_location
    CMP tmp
    BNE cmp_next_x
    INC swr_banks
    INC swr_test,X
    ; we don't know which method it is yet...
    JMP cmp_next_y
cmp_next_x
    ; restore the corrupted byte in swr (from the 2nd write!)
    JSR set_romsel
    TYA
    EOR swr_byte_value1
    STA tmp
    STA test_location
    DEX
    BPL bank_lp_x
cmp_next_y
    INY
    CPY #16
    BCC bank_lp_y
    LDA swr_banks
    BNE continue
    STA swr_type ; no SWR found
    JMP end2

found_type_1
    LDA #1
    STA swr_type
    STA swr_banks
    ; restore swr bank byte
    LDA swr_backup,Y
    STA test_location
    JMP end2

continue ; type 1-6
    LDY #16
find_type_lp
    DEY
    ;BMI find_type_end ; no need, we only get here if there is RAM.
    LDA swr_test,Y
    BEQ find_type_lp
    CMP #8
    BCS found_type_1 ;XXX CHANGE THIS
    JSR set_only_solidisk
    ; N.B. STY $FE30 should take care of the databus problem, as long as the
    ; value written to RAM is not in the set {0,...,15}.
    TYA
    EOR swr_byte_value1
    EOR #$22
    STA test_location
    JSR page_in_y_preserve_a
    CMP test_location
    BEQ found_soli
    JSR set_only_ramsel
    TYA
    EOR swr_byte_value2
    EOR #$23
    STA test_location
    JSR page_in_y_preserve_a
    CMP test_location
    BEQ found_ram_sel
    JSR set_only_romsel
    TYA
    EOR swr_byte_value2
    EOR #$34
    STA test_location
    JSR page_in_y_preserve_a
    CMP test_location
    BEQ found_rom_sel
    ; which leaves the watford rom/ram method

found_watford_romram
    LDA #6
    STA swr_type
    JMP end

found_rom_sel
    LDA #2
    STA swr_type
    JMP end

found_ram_sel
    LDA #3
    STA swr_type
    JMP end

found_soli
    LDA #4
    STA swr_type
    LDA swr_test,Y
    CMP #1
    BNE soli_3bits
    INC swr_type
    JMP end
soli_3bits
    ; remove factor 2 from solidisk's incomplete address decoding
    LSR swr_banks
    JMP end

end
    ; restore swr, using method found
    LDY #0
    ; note that we must write in low to high order for swr_type=4, or only

    ;   copy for Y=8-15 in that case.
restore_lp
    JSR set_all
    LDA swr_backup,Y
    STA test_location
    INY
    CPY #16
    BCC restore_lp
end2
    LDA $F4
    JSR page_in_a
    CLI
    ; Now derive a list of banks which have usable sideways RAM.
    ; We don't trust swr_banks because ROM write through can make it misleading.
    LDX #0
    LDY #0
derive_loop
    LDA swr_test,Y
    BEQ not_usable
    TYA
    STA ram_bank_list,X
    INX
    CPX #max_ram_bank_count
    BEQ derive_done
not_usable
    INY
    CPY #16
    BNE derive_loop
derive_done
    STX ram_bank_count
    RTS

; Utilities

set_only_solidisk
    JSR set_all_to_wrong_bank
set_solidisk ; for old solidisk swr
    LDX #$0F
    STX $FE62 ; user port -> output
    STY $FE60 ; user port output=A
    RTS

set_only_romsel
    JSR set_all_to_wrong_bank
set_romsel
    JSR page_in_y_preserve_a
    RTS

; RAMSEL may not exist, in which case it is equivalent to ROMSEL
; (incomplete address decoding), therefore this code

set_only_ramsel
    JSR set_all_to_wrong_bank
    JSR set_ramsel
    ; now set ROMSEL to the wrong bank, if ROMSEL=RAMSEL, RAMSEL will be deselected too.
    TYA
    EOR #1
    TAY
    JSR set_romsel
    TYA
    EOR #1
    TAY
    RTS
set_ramsel
    STY $FE32
    RTS

set_only_watford_romram
    JSR set_all_to_wrong_bank
set_watford_romram
    STA $FF30,Y
    RTS ; write latch set by writing anything to location (FF30+n)

set_all
    JSR set_solidisk
    JSR set_romsel
    JSR set_ramsel
    JMP set_watford_romram

set_all_to_wrong_bank
    TYA
    EOR #1
    TAY ; this is fine with solidisks incomplete address decoding (bit 3 not used)
    JSR set_all
    TYA
    EOR #1
    TAY
    RTS

; This paging is inefficient, but performance isn't really significant here;
; code readability and size are more important.
page_in_y_preserve_a
    PHA
    JSR page_in_y_corrupt_a
    PLA
    RTS
page_in_x_corrupt_a
    TXA
    JMP page_in_a
page_in_y_corrupt_a
    TYA
page_in_a
    BIT bbc
    BPL page_in_a_electron
    STA $FE30
    RTS
page_in_a_electron
    PHA
    LDA #12
    STA $FE05
    PLA
    STA $FE05
    RTS

!if * >= $b00 {
    !error "findswr has overflowed available memory"
}
