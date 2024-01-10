
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT CRT0 FROM -STARTUP=N COMMANDLINE OPTION ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include(`zcc_opt.def')

ifdef(`__STARTUP',,`define(`__STARTUP', 2)')
ifdef(`__STARTUP_OFFSET',`define(`__STARTUP', eval(__STARTUP + __STARTUP_OFFSET))')

IFNDEF startup

   ; startup undefined so select a default
	
   defc startup = __STARTUP

ENDIF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; user supplied crt ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, -1,
`
   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF
   
   include(`crt.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ram model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 0,
`
   ; generic embedded system
   ; no files, no fds

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 0
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/z180_crt_0.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rom model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 1,
`
   ; generic embedded system
   ; no files, no fds

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 1
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/z180_crt_0.asm.m4')
')

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compressed rom model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ifelse(__STARTUP, 2,
`
   ; generic embedded system
   ; no files, no fds

   IFNDEF __CRTCFG
   
      defc __CRTCFG = 2
   
   ENDIF
   
   IFNDEF __MMAP
   
      defc __MMAP = 0
   
   ENDIF

   include(`startup/z180_crt_0.asm.m4')
')
