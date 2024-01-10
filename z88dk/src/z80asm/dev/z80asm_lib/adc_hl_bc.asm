; Substitute for the z80 adc hl,bc instruction
; CPU   Min T Max T
; 8080  47    52
; 8085  48    51
; gbz80 36    44
; r2k    4     4
; z180  10    10
; z80   15    15
; z80n  15    15

      SECTION  code_crt0_sccz80
      PUBLIC   __z80asm__adc_hl_bc

__z80asm__adc_hl_bc:
      jr    nc, carry0
      inc   hl
carry0:
      add   hl, bc
      ret   
