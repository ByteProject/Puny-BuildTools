;
;         ANSI Video handling for the MSX
;
;         Handles colors
;
;        Scrollup
;
;        Stefano Bodrato - Sept. 2017
;
;        $Id: f_ansi_scrollup_nobios.asm $
;

        SECTION code_clib
        PUBLIC  ansi_SCROLLUP
        PUBLIC  __tms9918_scroll_buffer
        EXTERN  __tms9918_attribute
        
        EXTERN  LDIRVM
        EXTERN  LDIRMV
        EXTERN  FILVRM
        
.ansi_SCROLLUP
        push    ix
        ld      b,23
        ld      hl,256
.scloop
        push    bc
        push    hl
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        call    LDIRMV
        pop     hl
        push    hl
        
        ld      de,-256
        add     hl,de
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ex      de,hl
        call    LDIRVM
        pop     hl
        push    hl
        ld      de,8192
        add     hl,de
        push    hl
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        call    LDIRMV
        pop     hl
        ld      de,-256
        add     hl,de
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ex      de,hl
        call    LDIRVM
        pop     hl
        inc     h
        pop     bc
        djnz    scloop
        dec     h
        xor     a
        ld      bc,256
        call    FILVRM
        pop     ix
        ret
 

        SECTION bss_clib        
        
.__tms9918_scroll_buffer                        defs 256
