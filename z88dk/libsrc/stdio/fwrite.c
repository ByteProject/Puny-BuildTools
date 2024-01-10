

#define ANSI_STDIO
#define STDIO_ASM
#include <stdio.h>

static int wrapper() __naked
{
#asm
; int fwrite(void *ptr, size_t size, size_t nmemb, FILE *fp) __naked
	GLOBAL _fwrite
fwrite:
_fwrite:
IF __CPU_INTEL__ | __CPU_GBZ80__
	ld	hl,-1
	ret
ELSE
	push	ix	;save callers
  IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(sp + 8)	; size
	ld	c,l
	ld	b,h
	ld	hl,(sp + 6)	; nmemb
	mul			; bc = nmemb * size
	ld	a,c
	or	b
	jp	z,fwrite_exit
	ld	ix,(sp + 4)	;fp
	ld	hl,(sp + 10)	;ptr
	ex	de,hl
  ELSE
	ld	ix,0
	add	ix,sp
	ld	l,(ix+6)	;nmemb
	ld	h,(ix+7)
	ld	e,(ix+8)	;size
	ld	d,(ix+9)
	call	l_mult		;hl = nmemb * size
	ld	a,h
	or	l
	jp	z,fwrite_exit
	ld	c,l
	ld	b,h
	ld	e,(ix+10)	;ptr
	ld	d,(ix+11)
	ld	l,(ix+4)	;fp
	ld	h,(ix+5)
	push	hl	
	pop	ix		;ix = fp
  ENDIF
	ld	hl,0		;bytes written
	; Check that we have a non-system reader thats in use
	ld	a,(ix + fp_flags)
	bit	4,a			; _IOSYSTEM
	jr	nz,fwrite_done
	and	_IOUSE | _IOWRITE
	cp	_IOUSE | _IOWRITE
	jr	nz,fwrite_done
	; ix = fp
	; bc = bytes to write
	; hl = buffer
	call	_fwrite1		; hl = bytes written
fwrite_done:
	; hl = bytes read
	; divide and return
	ex	de,hl
  IF __CPU_R2K__ | __CPU_R3K__
	ld	hl,(sp + 8)	;size
  ELSE
	ld	ix,0
	add	ix,sp
	ld	l,(ix+8)	;size
	ld	h,(ix+9)
  ENDIF
	call	l_div_u		;hl = de/hl = bytes_written/size
fwrite_exit:
	pop	ix		;restore callers
	ret


; (buf, size, fp)
_fwrite1:
	; ix = fp
	; bc = size
	; de = buf
        bit	5,(ix+fp_flags)		;_IOEXTRA
        jr      z,fwrite_direct
        ; Calling via the extra hook
  IF __CPU_R2K__ | __CPU_R3K__
        ld      hl,(ix+fp_extra)
  ELSE
        ld      l,(ix+fp_extra)
        ld      h,(ix+fp_extra+1)
  ENDIF
        ld      a,__STDIO_MSG_WRITE
        jp      l_jphl
fwrite_direct:
  IF __CPU_R2K__ | __CPU_R3K__
        ld      hl,(ix+fp_desc)
  ELSE
        ld      l,(ix+fp_desc)
        ld      h,(ix+fp_desc+1)
  ENDIF
        push    hl
        push    de
        push    bc
        call    write
        pop     bc
        pop     bc
        pop     bc
        ret
ENDIF
#endasm
}
