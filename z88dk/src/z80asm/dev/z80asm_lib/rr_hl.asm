; Emulate 'rr hl' instruction, only carry is affected
; CPU   Min T Max T
; 8080  90    90
; 8085  88    88
; gbz80 16    16
; r2k    2     2
; z180  14    14
; z80   16    16
; z80n  16    16

      SECTION  code_crt0_sccz80
      PUBLIC   __z80asm__rr_hl

__z80asm__rr_hl:

IF __CPU_INTEL__
      push  af

      ld    a, h
      rra   
      ld    h, a

      ld    a, l
      rra   
      ld    l, a

      jr    nc, carry0
      pop   af
      scf   
      ret   
carry0:
      pop   af
      and   a
      ret   
ELSE  
      rr    h
      rr    l
      ret   
ENDIF 

