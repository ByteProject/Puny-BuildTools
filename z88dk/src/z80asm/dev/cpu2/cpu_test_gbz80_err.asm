 adc (ix)                       ; Error
 adc (ix+-128)                  ; Error
 adc (ix+127)                   ; Error
 adc (iy)                       ; Error
 adc (iy+-128)                  ; Error
 adc (iy+127)                   ; Error
 adc a, (ix)                    ; Error
 adc a, (ix+-128)               ; Error
 adc a, (ix+127)                ; Error
 adc a, (iy)                    ; Error
 adc a, (iy+-128)               ; Error
 adc a, (iy+127)                ; Error
 add (ix)                       ; Error
 add (ix+-128)                  ; Error
 add (ix+127)                   ; Error
 add (iy)                       ; Error
 add (iy+-128)                  ; Error
 add (iy+127)                   ; Error
 add a, (ix)                    ; Error
 add a, (ix+-128)               ; Error
 add a, (ix+127)                ; Error
 add a, (iy)                    ; Error
 add a, (iy+-128)               ; Error
 add a, (iy+127)                ; Error
 add ix, bc                     ; Error
 add ix, de                     ; Error
 add ix, ix                     ; Error
 add ix, sp                     ; Error
 add iy, bc                     ; Error
 add iy, de                     ; Error
 add iy, iy                     ; Error
 add iy, sp                     ; Error
 adi hl, -128                   ; Error
 adi hl, 127                    ; Error
 adi hl, 255                    ; Error
 adi sp, -128                   ; Error
 adi sp, 127                    ; Error
 adi sp, 255                    ; Error
 and (ix)                       ; Error
 and (ix+-128)                  ; Error
 and (ix+127)                   ; Error
 and (iy)                       ; Error
 and (iy+-128)                  ; Error
 and (iy+127)                   ; Error
 and a, (ix)                    ; Error
 and a, (ix+-128)               ; Error
 and a, (ix+127)                ; Error
 and a, (iy)                    ; Error
 and a, (iy+-128)               ; Error
 and a, (iy+127)                ; Error
 call m, -32768                 ; Error
 call m, 32767                  ; Error
 call m, 65535                  ; Error
 call nv, -32768                ; Error
 call nv, 32767                 ; Error
 call nv, 65535                 ; Error
 call p, -32768                 ; Error
 call p, 32767                  ; Error
 call p, 65535                  ; Error
 call pe, -32768                ; Error
 call pe, 32767                 ; Error
 call pe, 65535                 ; Error
 call po, -32768                ; Error
 call po, 32767                 ; Error
 call po, 65535                 ; Error
 call v, -32768                 ; Error
 call v, 32767                  ; Error
 call v, 65535                  ; Error
 cm -32768                      ; Error
 cm 32767                       ; Error
 cm 65535                       ; Error
 cmp (ix)                       ; Error
 cmp (ix+-128)                  ; Error
 cmp (ix+127)                   ; Error
 cmp (iy)                       ; Error
 cmp (iy+-128)                  ; Error
 cmp (iy+127)                   ; Error
 cmp a, (ix)                    ; Error
 cmp a, (ix+-128)               ; Error
 cmp a, (ix+127)                ; Error
 cmp a, (iy)                    ; Error
 cmp a, (iy+-128)               ; Error
 cmp a, (iy+127)                ; Error
 cnv -32768                     ; Error
 cnv 32767                      ; Error
 cnv 65535                      ; Error
 cp (ix)                        ; Error
 cp (ix+-128)                   ; Error
 cp (ix+127)                    ; Error
 cp (iy)                        ; Error
 cp (iy+-128)                   ; Error
 cp (iy+127)                    ; Error
 cp a, (ix)                     ; Error
 cp a, (ix+-128)                ; Error
 cp a, (ix+127)                 ; Error
 cp a, (iy)                     ; Error
 cp a, (iy+-128)                ; Error
 cp a, (iy+127)                 ; Error
 cpe -32768                     ; Error
 cpe 32767                      ; Error
 cpe 65535                      ; Error
 cpo -32768                     ; Error
 cpo 32767                      ; Error
 cpo 65535                      ; Error
 cv -32768                      ; Error
 cv 32767                       ; Error
 cv 65535                       ; Error
 dec (ix)                       ; Error
 dec (ix+-128)                  ; Error
 dec (ix+127)                   ; Error
 dec (iy)                       ; Error
 dec (iy+-128)                  ; Error
 dec (iy+127)                   ; Error
 dec ix                         ; Error
 dec iy                         ; Error
 djnz -32768                    ; Error
 djnz 32767                     ; Error
 djnz 65535                     ; Error
 djnz b, -32768                 ; Error
 djnz b, 32767                  ; Error
 djnz b, 65535                  ; Error
 ex (sp), ix                    ; Error
 ex (sp), iy                    ; Error
 ex af, af                      ; Error
 ex af, af'                     ; Error
 exx                            ; Error
 im %c                          ; Error
 in (c)                         ; Error
 in -128                        ; Error
 in 127                         ; Error
 in 255                         ; Error
 in a, (-128)                   ; Error
 in a, (127)                    ; Error
 in a, (255)                    ; Error
 in a, (c)                      ; Error
 in b, (c)                      ; Error
 in c, (c)                      ; Error
 in d, (c)                      ; Error
 in e, (c)                      ; Error
 in f, (c)                      ; Error
 in h, (c)                      ; Error
 in l, (c)                      ; Error
 inc (ix)                       ; Error
 inc (ix+-128)                  ; Error
 inc (ix+127)                   ; Error
 inc (iy)                       ; Error
 inc (iy+-128)                  ; Error
 inc (iy+127)                   ; Error
 inc ix                         ; Error
 inc iy                         ; Error
 ind                            ; Error
 indr                           ; Error
 ini                            ; Error
 inir                           ; Error
 jk -32768                      ; Error
 jk 32767                       ; Error
 jk 65535                       ; Error
 jm -32768                      ; Error
 jm 32767                       ; Error
 jm 65535                       ; Error
 jnk -32768                     ; Error
 jnk 32767                      ; Error
 jnk 65535                      ; Error
 jnv -32768                     ; Error
 jnv 32767                      ; Error
 jnv 65535                      ; Error
 jnx5 -32768                    ; Error
 jnx5 32767                     ; Error
 jnx5 65535                     ; Error
 jp (ix)                        ; Error
 jp (iy)                        ; Error
 jp m, -32768                   ; Error
 jp m, 32767                    ; Error
 jp m, 65535                    ; Error
 jp nv, -32768                  ; Error
 jp nv, 32767                   ; Error
 jp nv, 65535                   ; Error
 jp p, -32768                   ; Error
 jp p, 32767                    ; Error
 jp p, 65535                    ; Error
 jp pe, -32768                  ; Error
 jp pe, 32767                   ; Error
 jp pe, 65535                   ; Error
 jp po, -32768                  ; Error
 jp po, 32767                   ; Error
 jp po, 65535                   ; Error
 jp v, -32768                   ; Error
 jp v, 32767                    ; Error
 jp v, 65535                    ; Error
 jpe -32768                     ; Error
 jpe 32767                      ; Error
 jpe 65535                      ; Error
 jpo -32768                     ; Error
 jpo 32767                      ; Error
 jpo 65535                      ; Error
 jr -32768                      ; Error
 jr 32767                       ; Error
 jr 65535                       ; Error
 jr c, -32768                   ; Error
 jr c, 32767                    ; Error
 jr c, 65535                    ; Error
 jr nc, -32768                  ; Error
 jr nc, 32767                   ; Error
 jr nc, 65535                   ; Error
 jr nz, -32768                  ; Error
 jr nz, 32767                   ; Error
 jr nz, 65535                   ; Error
 jr z, -32768                   ; Error
 jr z, 32767                    ; Error
 jr z, 65535                    ; Error
 jv -32768                      ; Error
 jv 32767                       ; Error
 jv 65535                       ; Error
 jx5 -32768                     ; Error
 jx5 32767                      ; Error
 jx5 65535                      ; Error
 ld (-32768), bc                ; Error
 ld (-32768), de                ; Error
 ld (-32768), hl                ; Error
 ld (-32768), ix                ; Error
 ld (-32768), iy                ; Error
 ld (32767), bc                 ; Error
 ld (32767), de                 ; Error
 ld (32767), hl                 ; Error
 ld (32767), ix                 ; Error
 ld (32767), iy                 ; Error
 ld (65535), bc                 ; Error
 ld (65535), de                 ; Error
 ld (65535), hl                 ; Error
 ld (65535), ix                 ; Error
 ld (65535), iy                 ; Error
 ld (de), hl                    ; Error
 ld (ix), -128                  ; Error
 ld (ix), 127                   ; Error
 ld (ix), 255                   ; Error
 ld (ix), a                     ; Error
 ld (ix), b                     ; Error
 ld (ix), c                     ; Error
 ld (ix), d                     ; Error
 ld (ix), e                     ; Error
 ld (ix), h                     ; Error
 ld (ix), l                     ; Error
 ld (ix+-128), -128             ; Error
 ld (ix+-128), 127              ; Error
 ld (ix+-128), 255              ; Error
 ld (ix+-128), a                ; Error
 ld (ix+-128), b                ; Error
 ld (ix+-128), c                ; Error
 ld (ix+-128), d                ; Error
 ld (ix+-128), e                ; Error
 ld (ix+-128), h                ; Error
 ld (ix+-128), l                ; Error
 ld (ix+127), -128              ; Error
 ld (ix+127), 127               ; Error
 ld (ix+127), 255               ; Error
 ld (ix+127), a                 ; Error
 ld (ix+127), b                 ; Error
 ld (ix+127), c                 ; Error
 ld (ix+127), d                 ; Error
 ld (ix+127), e                 ; Error
 ld (ix+127), h                 ; Error
 ld (ix+127), l                 ; Error
 ld (iy), -128                  ; Error
 ld (iy), 127                   ; Error
 ld (iy), 255                   ; Error
 ld (iy), a                     ; Error
 ld (iy), b                     ; Error
 ld (iy), c                     ; Error
 ld (iy), d                     ; Error
 ld (iy), e                     ; Error
 ld (iy), h                     ; Error
 ld (iy), l                     ; Error
 ld (iy+-128), -128             ; Error
 ld (iy+-128), 127              ; Error
 ld (iy+-128), 255              ; Error
 ld (iy+-128), a                ; Error
 ld (iy+-128), b                ; Error
 ld (iy+-128), c                ; Error
 ld (iy+-128), d                ; Error
 ld (iy+-128), e                ; Error
 ld (iy+-128), h                ; Error
 ld (iy+-128), l                ; Error
 ld (iy+127), -128              ; Error
 ld (iy+127), 127               ; Error
 ld (iy+127), 255               ; Error
 ld (iy+127), a                 ; Error
 ld (iy+127), b                 ; Error
 ld (iy+127), c                 ; Error
 ld (iy+127), d                 ; Error
 ld (iy+127), e                 ; Error
 ld (iy+127), h                 ; Error
 ld (iy+127), l                 ; Error
 ld a, (ix)                     ; Error
 ld a, (ix+-128)                ; Error
 ld a, (ix+127)                 ; Error
 ld a, (iy)                     ; Error
 ld a, (iy+-128)                ; Error
 ld a, (iy+127)                 ; Error
 ld a, i                        ; Error
 ld a, ixh                      ; Error
 ld a, ixl                      ; Error
 ld a, iyh                      ; Error
 ld a, iyl                      ; Error
 ld a, r                        ; Error
 ld b, (ix)                     ; Error
 ld b, (ix+-128)                ; Error
 ld b, (ix+127)                 ; Error
 ld b, (iy)                     ; Error
 ld b, (iy+-128)                ; Error
 ld b, (iy+127)                 ; Error
 ld b, ixh                      ; Error
 ld b, ixl                      ; Error
 ld b, iyh                      ; Error
 ld b, iyl                      ; Error
 ld bc, (-32768)                ; Error
 ld bc, (32767)                 ; Error
 ld bc, (65535)                 ; Error
 ld bc, ix                      ; Error
 ld bc, iy                      ; Error
 ld c, (ix)                     ; Error
 ld c, (ix+-128)                ; Error
 ld c, (ix+127)                 ; Error
 ld c, (iy)                     ; Error
 ld c, (iy+-128)                ; Error
 ld c, (iy+127)                 ; Error
 ld c, ixh                      ; Error
 ld c, ixl                      ; Error
 ld c, iyh                      ; Error
 ld c, iyl                      ; Error
 ld d, (ix)                     ; Error
 ld d, (ix+-128)                ; Error
 ld d, (ix+127)                 ; Error
 ld d, (iy)                     ; Error
 ld d, (iy+-128)                ; Error
 ld d, (iy+127)                 ; Error
 ld d, ixh                      ; Error
 ld d, ixl                      ; Error
 ld d, iyh                      ; Error
 ld d, iyl                      ; Error
 ld de, (-32768)                ; Error
 ld de, (32767)                 ; Error
 ld de, (65535)                 ; Error
 ld de, hl+-128                 ; Error
 ld de, hl+127                  ; Error
 ld de, hl+255                  ; Error
 ld de, ix                      ; Error
 ld de, iy                      ; Error
 ld e, (ix)                     ; Error
 ld e, (ix+-128)                ; Error
 ld e, (ix+127)                 ; Error
 ld e, (iy)                     ; Error
 ld e, (iy+-128)                ; Error
 ld e, (iy+127)                 ; Error
 ld e, ixh                      ; Error
 ld e, ixl                      ; Error
 ld e, iyh                      ; Error
 ld e, iyl                      ; Error
 ld h, (ix)                     ; Error
 ld h, (ix+-128)                ; Error
 ld h, (ix+127)                 ; Error
 ld h, (iy)                     ; Error
 ld h, (iy+-128)                ; Error
 ld h, (iy+127)                 ; Error
 ld hl, (-32768)                ; Error
 ld hl, (32767)                 ; Error
 ld hl, (65535)                 ; Error
 ld hl, (de)                    ; Error
 ld hl, ix                      ; Error
 ld hl, iy                      ; Error
 ld i, a                        ; Error
 ld ix, (-32768)                ; Error
 ld ix, (32767)                 ; Error
 ld ix, (65535)                 ; Error
 ld ix, -32768                  ; Error
 ld ix, 32767                   ; Error
 ld ix, 65535                   ; Error
 ld ix, bc                      ; Error
 ld ix, de                      ; Error
 ld ix, hl                      ; Error
 ld ix, iy                      ; Error
 ld ixh, -128                   ; Error
 ld ixh, 127                    ; Error
 ld ixh, 255                    ; Error
 ld ixh, a                      ; Error
 ld ixh, b                      ; Error
 ld ixh, c                      ; Error
 ld ixh, d                      ; Error
 ld ixh, e                      ; Error
 ld ixh, ixh                    ; Error
 ld ixh, ixl                    ; Error
 ld ixl, -128                   ; Error
 ld ixl, 127                    ; Error
 ld ixl, 255                    ; Error
 ld ixl, a                      ; Error
 ld ixl, b                      ; Error
 ld ixl, c                      ; Error
 ld ixl, d                      ; Error
 ld ixl, e                      ; Error
 ld ixl, ixh                    ; Error
 ld ixl, ixl                    ; Error
 ld iy, (-32768)                ; Error
 ld iy, (32767)                 ; Error
 ld iy, (65535)                 ; Error
 ld iy, -32768                  ; Error
 ld iy, 32767                   ; Error
 ld iy, 65535                   ; Error
 ld iy, bc                      ; Error
 ld iy, de                      ; Error
 ld iy, hl                      ; Error
 ld iy, ix                      ; Error
 ld iyh, -128                   ; Error
 ld iyh, 127                    ; Error
 ld iyh, 255                    ; Error
 ld iyh, a                      ; Error
 ld iyh, b                      ; Error
 ld iyh, c                      ; Error
 ld iyh, d                      ; Error
 ld iyh, e                      ; Error
 ld iyh, iyh                    ; Error
 ld iyh, iyl                    ; Error
 ld iyl, -128                   ; Error
 ld iyl, 127                    ; Error
 ld iyl, 255                    ; Error
 ld iyl, a                      ; Error
 ld iyl, b                      ; Error
 ld iyl, c                      ; Error
 ld iyl, d                      ; Error
 ld iyl, e                      ; Error
 ld iyl, iyh                    ; Error
 ld iyl, iyl                    ; Error
 ld l, (ix)                     ; Error
 ld l, (ix+-128)                ; Error
 ld l, (ix+127)                 ; Error
 ld l, (iy)                     ; Error
 ld l, (iy+-128)                ; Error
 ld l, (iy+127)                 ; Error
 ld r, a                        ; Error
 ld sp, (-32768)                ; Error
 ld sp, (32767)                 ; Error
 ld sp, (65535)                 ; Error
 ld sp, ix                      ; Error
 ld sp, iy                      ; Error
 ldhi -128                      ; Error
 ldhi 127                       ; Error
 ldhi 255                       ; Error
 ldsi -128                      ; Error
 ldsi 127                       ; Error
 ldsi 255                       ; Error
 lhld -32768                    ; Error
 lhld 32767                     ; Error
 lhld 65535                     ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 or (ix)                        ; Error
 or (ix+-128)                   ; Error
 or (ix+127)                    ; Error
 or (iy)                        ; Error
 or (iy+-128)                   ; Error
 or (iy+127)                    ; Error
 or a, (ix)                     ; Error
 or a, (ix+-128)                ; Error
 or a, (ix+127)                 ; Error
 or a, (iy)                     ; Error
 or a, (iy+-128)                ; Error
 or a, (iy+127)                 ; Error
 otdr                           ; Error
 otir                           ; Error
 out (-128), a                  ; Error
 out (127), a                   ; Error
 out (255), a                   ; Error
 out (c), %c                    ; Error
 out (c), a                     ; Error
 out (c), b                     ; Error
 out (c), c                     ; Error
 out (c), d                     ; Error
 out (c), e                     ; Error
 out (c), h                     ; Error
 out (c), l                     ; Error
 out -128                       ; Error
 out 127                        ; Error
 out 255                        ; Error
 outd                           ; Error
 outi                           ; Error
 ovrst8                         ; Error
 pop ix                         ; Error
 pop iy                         ; Error
 push ix                        ; Error
 push iy                        ; Error
 ret m                          ; Error
 ret nv                         ; Error
 ret p                          ; Error
 ret pe                         ; Error
 ret po                         ; Error
 ret v                          ; Error
 retn                           ; Error
 rim                            ; Error
 rl (ix)                        ; Error
 rl (ix+-128)                   ; Error
 rl (ix+127)                    ; Error
 rl (iy)                        ; Error
 rl (iy+-128)                   ; Error
 rl (iy+127)                    ; Error
 rlc (ix)                       ; Error
 rlc (ix+-128)                  ; Error
 rlc (ix+127)                   ; Error
 rlc (iy)                       ; Error
 rlc (iy+-128)                  ; Error
 rlc (iy+127)                   ; Error
 rm                             ; Error
 rnv                            ; Error
 rp                             ; Error
 rpe                            ; Error
 rpo                            ; Error
 rr (ix)                        ; Error
 rr (ix+-128)                   ; Error
 rr (ix+127)                    ; Error
 rr (iy)                        ; Error
 rr (iy+-128)                   ; Error
 rr (iy+127)                    ; Error
 rrc (ix)                       ; Error
 rrc (ix+-128)                  ; Error
 rrc (ix+127)                   ; Error
 rrc (iy)                       ; Error
 rrc (iy+-128)                  ; Error
 rrc (iy+127)                   ; Error
 rstv                           ; Error
 rv                             ; Error
 sbc (ix)                       ; Error
 sbc (ix+-128)                  ; Error
 sbc (ix+127)                   ; Error
 sbc (iy)                       ; Error
 sbc (iy+-128)                  ; Error
 sbc (iy+127)                   ; Error
 sbc a, (ix)                    ; Error
 sbc a, (ix+-128)               ; Error
 sbc a, (ix+127)                ; Error
 sbc a, (iy)                    ; Error
 sbc a, (iy+-128)               ; Error
 sbc a, (iy+127)                ; Error
 shld -32768                    ; Error
 shld 32767                     ; Error
 shld 65535                     ; Error
 shlde                          ; Error
 shlx                           ; Error
 sim                            ; Error
 sla (ix)                       ; Error
 sla (ix+-128)                  ; Error
 sla (ix+127)                   ; Error
 sla (iy)                       ; Error
 sla (iy+-128)                  ; Error
 sla (iy+127)                   ; Error
 sli (hl)                       ; Error
 sli (ix)                       ; Error
 sli (ix+-128)                  ; Error
 sli (ix+127)                   ; Error
 sli (iy)                       ; Error
 sli (iy+-128)                  ; Error
 sli (iy+127)                   ; Error
 sli a                          ; Error
 sli b                          ; Error
 sli c                          ; Error
 sli d                          ; Error
 sli e                          ; Error
 sli h                          ; Error
 sli l                          ; Error
 sll (hl)                       ; Error
 sll (ix)                       ; Error
 sll (ix+-128)                  ; Error
 sll (ix+127)                   ; Error
 sll (iy)                       ; Error
 sll (iy+-128)                  ; Error
 sll (iy+127)                   ; Error
 sll a                          ; Error
 sll b                          ; Error
 sll c                          ; Error
 sll d                          ; Error
 sll e                          ; Error
 sll h                          ; Error
 sll l                          ; Error
 sra (ix)                       ; Error
 sra (ix+-128)                  ; Error
 sra (ix+127)                   ; Error
 sra (iy)                       ; Error
 sra (iy+-128)                  ; Error
 sra (iy+127)                   ; Error
 srl (ix)                       ; Error
 srl (ix+-128)                  ; Error
 srl (ix+127)                   ; Error
 srl (iy)                       ; Error
 srl (iy+-128)                  ; Error
 srl (iy+127)                   ; Error
 sub (ix)                       ; Error
 sub (ix+-128)                  ; Error
 sub (ix+127)                   ; Error
 sub (iy)                       ; Error
 sub (iy+-128)                  ; Error
 sub (iy+127)                   ; Error
 sub a, (ix)                    ; Error
 sub a, (ix+-128)               ; Error
 sub a, (ix+127)                ; Error
 sub a, (iy)                    ; Error
 sub a, (iy+-128)               ; Error
 sub a, (iy+127)                ; Error
 xor (ix)                       ; Error
 xor (ix+-128)                  ; Error
 xor (ix+127)                   ; Error
 xor (iy)                       ; Error
 xor (iy+-128)                  ; Error
 xor (iy+127)                   ; Error
 xor a, (ix)                    ; Error
 xor a, (ix+-128)               ; Error
 xor a, (ix+127)                ; Error
 xor a, (iy)                    ; Error
 xor a, (iy+-128)               ; Error
 xor a, (iy+127)                ; Error
 xthl                           ; Error
