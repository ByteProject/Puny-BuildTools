


        MODULE  send_byte

        PUBLIC  send_byte
        PUBLIC  _send_byte

	EXTERN	__io_status
	EXTERN	__io_out

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

        ;; Send byte in __io_out to the serial port
send_byte:
_send_byte:
        LD      A,IO_SENDING
        LD      (__io_status),A ; Store status
        LD      A,0x01
        LDH     (SC),A         ; Use internal clock
        LD      A,(__io_out)
        LDH     (SB),A         ; Send data byte
        LD      A,0x81
        LDH     (SC),A         ; Use internal clock
        RET
