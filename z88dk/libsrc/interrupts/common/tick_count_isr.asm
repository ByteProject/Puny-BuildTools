; Simple tick timer, designed to be called from the interrupt


		SECTION		code_clib
		PUBLIC		tick_count_isr	
		PUBLIC		_tick_count_isr
		PUBLIC		tick_count
		PUBLIC		_tick_count

; Increments a tick on each call
; Uses: hl, a
tick_count_isr:
_tick_count_isr:
	ld	hl, (tick_count)
	inc	hl
	ld	(tick_count),hl
	ld	a,h
	or	l
	ret	nz
	ld	hl,(tick_count + 2)
	inc	hl
	ld	(tick_count+2),hl
	ret

		SECTION		bss_clib

_tick_count:
tick_count:	defs	4
