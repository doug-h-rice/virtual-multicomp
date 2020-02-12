;
; File: test_RC2014_8400.asm tests RCASM Assembler generating Z80 code
;
; 07/02/2020 Doug Rice
;
; Description: This generates some code at 0x8400
; 
; this file tests the RCASM Z80.def
;
; build rcasm using Tiny C 
; ..\tcc rcasm.c asmcmds.c mstrings.c support.c
; 
; 07/02/2020 Doug Rice
;
; Set putty to 115200 baud
; to upload to RC2104 using the SCM pipe hex file to serial port
;
; stty -F /dev/ttyUSB0 -a
;
; ./rcasm -dz80 -l -h test_RC2014_8400.asm
;
; to upload the code to the RC2014  
;  cat test_RC2014_8400.hex > /dev/ttyUSB0
;
; Check SCM has displayed
; Set putty to 115200 baud
;
; * READY
; *d8400
;
;  echo -e "g8400\n\r" > /dev/ttyUSB0
;
; links:	
;	TCC		
;		Tiny C used to rebuild rcasm to allow for address inc feature of SC/MP
; 		http://bellard.org/tcc/
;
;	RCASM
;		I found an assembler that I could get to understand SC/MP machine code.
;		http://www.elf-emulation.com/rcasm.html
;
;	SCM
;	    this super monitor came with the RC2014 and works on multicomp.				
;		https://smallcomputercentral.wordpress.com/small-computer-monitor/small-computer-monitor-v1-0/
;
;	Virtual Multi comp
;		https://github.com/doug-h-rice/virtual-multicomp
;
;Small Computer Monitor - RC2014
;*
;*help
;Small Computer Monitor by Stephen C Cousins (www.scc.me.uk)
;Version 1.0.0 configuration R1 for Z80 based RC2014 systems
;
;Monitor commands:
;A [<address>]  = Assemble        |  D [<address>]   = Disassemble
;M [<address>]  = Memory display  |  E [<address>]   = Edit memory
;R [<name>]     = Registers/edit  |  F [<name>]      = Flags/edit
;B [<address>]  = Breakpoint      |  S [<address>]   = Single step
;I <port>       = Input from port |  O <port> <data> = Output to port
;G [<address>]  = Go to program
;BAUD <device> <rate>             |  CONSOLE <device>
;FILL <start> <end> <byte>        |  API <function> [<A>] [<DE>]
;DEVICES, DIR, HELP, RESET
;*
;
;Small Computer Monitor - RC2014
;*g8400
;!>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklm
;
;*d8400
;8400: 3E 21        >!    LD A,$21
;8402: 0E 02        ..    LD C,$02
;8404: CD 30 00     .0.   CALL $0030
;8407: 06 30        .0    LD B,$30
;8409: 3E 3D        >=    LD A,$3D

Mem:		equ 08000h
;	
;
	org	08400h	
	ld	a,021H
	; output char in A using API 2 command.
	ld	c,2
	call	030H

	ld	B,048
	ld	A,'='
	ld 	c,2
	
loop:	
	inc	A
	
	; output char in A using API 2 command.
	push	AF
	push 	bc
	
	; output char in A using API 2 command.
	ld 	c,2
	call	030H
	pop 	bc
	pop	af
	
	DJNZ	loop

	ld	a,0dh
	ld 	c,2
	call	030H
	
	ld	a,0Ah
	ld 	c,2
	call	030H

	; Try reading Key using SCM's API
	ld	B,016
	 
CHloop:
	push	BC
	ld 	c,1
	call	030H
	ld 	c,2
	call	030H
	pop	BC
	DJNZ	CHloop

	;output CRLF
	ld	a,0dh
	ld 	c,2
	call	030H
	
	ld	a,0Ah
	ld 	c,2
	call	030H

		
		
	ret
	
