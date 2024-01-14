dnl############################################################
dnl##        TSHR_01_OUTPUT_FZX STATIC INSTANTIATOR          ##
dnl############################################################
dnl##                                                        ##
dnl## m4_tshr_01_output_fzx(...)                             ##
dnl##                                                        ##
dnl## $1 = label attached to FILE or 0 if fd only            ##
dnl## $2 = ioctl_flags (16 bits)                             ##
dnl## $3 = cursor.x coordinate (pixels in paper)             ##
dnl## $4 = cursor.y coordinate (pixels in paper)             ##
dnl## $5 = window.x coordinate                               ##
dnl## $6 = window.width                                      ##
dnl## $7 = window.y coordinate                               ##
dnl## $8 = window.height                                     ##
dnl## $9 = scroll limit (number of scrolls until pause)      ##
dnl## $10 = struct fzx_font *                                ##
dnl## $11 = paper.x coordinate (pixels)                      ##
dnl## $12 = paper.width (pixels)                             ##
dnl## $13 = paper.y coordinate (pixels)                      ##
dnl## $14 = paper.height (pixels)                            ##
dnl## $15 = fzx draw mode (0 = OR, 1 = XOR, 2 = CLR)         ##
dnl## $16 = line spacing (0 = single, 1 = 1.5, 2 = double)   ##
dnl## $17 = left margin (pixels, recommended is 3)           ##
dnl## $18 = space expand (pixels, normal is 0)               ##
dnl##                                                        ##
dnl############################################################

define(`m4_tshr_01_output_fzx',dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; FILE  : `ifelse($1,0,`(none)',$1)'
   ;
   ; driver: tshr_01_output_fzx
   ; fd    : __I_FCNTL_NUM_FD
   ; mode  : write only
   ; type  : 002 = output terminal
   ;
   ; ioctl_flags   : $2
   ; window        : `($5,$6,$7,$8)'
   ; scroll limit  : $9
   ; paper         : `($11,$12,$13,$14)'
   ; cursor coord  : `($3,$4)'
   ;
   ; font          : $10
   ; fzx draw mode : `ifelse($15,0,OR,$15,1,XOR,CLEAR)'
   ; left margin   : $17
   ; line spacing  : $16
   ; space expand  : $18
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   `ifelse($1,0,,dnl   
   
   SECTION data_clib
   SECTION data_stdio
   
   ; FILE *
      
   PUBLIC $1
      
   $1:  defw __i_stdio_file_`'__I_STDIO_NUM_FILE + 2
   
   ; FILE structure
   
   __i_stdio_file_`'__I_STDIO_NUM_FILE:
   
      ; open files link
      
      defw ifelse(__I_STDIO_NUM_FILE,0,0,__i_stdio_file_`'decr(__I_STDIO_NUM_FILE))
      
      ; jump to underlying fd
      
      defb 195
      defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

      ; state_flags_0
      ; state_flags_1
      ; conversion flags
      ; ungetc

      defb 0x80         ; write + normal file type
      defb 0            ; last operation was write
      defb 0
      defb 0
      
      ; mtx_recursive
      
      defb 0         ; thread owner = none
      defb 0x02      ; mtx_recursive
      defb 0         ; lock count = 0
      defb 0xfe      ; atomic spinlock
      defw 0         ; list of blocked threads
    
   `define(`__I_STDIO_NUM_FILE', incr(__I_STDIO_NUM_FILE))'dnl
   )'dnl
   
   ; fd table entry
   
   SECTION data_fcntl_fdtable_body
   defw __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD

   ; FDSTRUCT structure
   
   SECTION data_fcntl_stdio_heap_body
   
   EXTERN console_01_output_terminal_fdriver
   EXTERN tshr_01_output_fzx
   
   __i_fcntl_heap_`'__I_FCNTL_NUM_HEAP:
   
      ; heap header
      
      defw __i_fcntl_heap_`'incr(__I_FCNTL_NUM_HEAP)
      defw 60
      defw ifelse(__I_FCNTL_NUM_HEAP,0,0,__i_fcntl_heap_`'decr(__I_FCNTL_NUM_HEAP))

   __i_fcntl_fdstruct_`'__I_FCNTL_NUM_FD:
   
      ; FDSTRUCT structure
      
      ; call to first entry to driver
      
      defb 205
      defw console_01_output_terminal_fdriver
      
      ; jump to driver
      
      defb 195
      defw tshr_01_output_fzx
      
      ; flags
      ; reference_count
      ; mode_byte
      
      defb 0x02      ; type = output terminal
      defb `ifelse($1,0,1,2)'
      defb 0x02      ; write only
      
      ; ioctl_flags
      
      defw $2
      
      ; mtx_plain
      
      defb 0         ; thread owner = none
      defb 0x01      ; mtx_plain
      defb 0         ; lock count = 0
      defb 0xfe      ; atomic spinlock
      defw 0         ; list of blocked threads

      ; reserved
      ; window
      ; scroll limit
      ; line spacing
      
      defw 0
      defb `$5, $6, $7, $8'
      defb $9
      defb $16
      
      ; temporary storage while editing
      
      defs 8
      
      ; struct fzx_state   
   
      EXTERN `ifelse($15,0,__fzx_tshr_draw_or,$15,1,__fzx_tshr_draw_xor,__fzx_tshr_draw_reset)'
      
      defb 195
      defw `ifelse($15,0,__fzx_tshr_draw_or,$15,1,__fzx_tshr_draw_xor,__fzx_tshr_draw_reset)'

      ; font
      ; cursor (x,y)

      defw $10
      defw `$3, $4'
      
      ; paper dimensions
      
      defw `$11,$12,$13,$14'
      
      ; left margin
      ; space expand
      ; reserved
      
      defw $17
      defb $18
      defw 0

   `define(`__I_FCNTL_NUM_FD', incr(__I_FCNTL_NUM_FD))'dnl
   `define(`__I_FCNTL_HEAP_SIZE', eval(__I_FCNTL_HEAP_SIZE + 60))'dnl
   `define(`__I_FCNTL_NUM_HEAP', incr(__I_FCNTL_NUM_HEAP))'dnl

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
)dnl
