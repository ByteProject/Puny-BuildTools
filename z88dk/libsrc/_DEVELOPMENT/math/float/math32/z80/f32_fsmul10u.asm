;
;  feilipu, 2019 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul10 - z80, z180, z80n floating point multiply by 10 positive
;-------------------------------------------------------------------------
;

SECTION code_fp_math32

PUBLIC m32_fsmul10u_fastcall
PUBLIC _m32_mul10uf


._m32_mul10uf
.m32_fsmul10u_fastcall
    sla e                       ; get exponent into d
    rl d
    jr Z,zero_legal             ; return IEEE zero
    
    scf                         ; set hidden bit
    rr e                        ; return mantissa to ehl

                                ; 10*a = 2*(4*a + a)     
    push de                     ; dehl *= 10
    push hl

    srl e
    rr h
    rr l
    srl e
    rr h
    rr l

    ex de,hl
    ex (sp),hl
    add hl,de
    pop de
    ex (sp),hl
    ld a,l
    adc a,e
    ld e,a
    pop hl

    ld a,3                      ; exponent increase
    jr NC,no_carry
    
    rr e                        ; shift if a carry
    rr h
    rr l
    inc a                       ; and increment exponent

.no_carry
    add a,d                     ; resulting exponent
    jr C,infinity

    ld d,a
    sla e
    srl d
    rr e
    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld h,d
    ld l,d        
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.infinity
    ld de,0
    ld h,d
    ld l,d
    dec d                       ; 0xff
    rr d                        ; restore the sign
    rr e
    scf
    ret                         ; return IEEE signed INFINITY in DEHL
