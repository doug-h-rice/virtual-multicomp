;
; File: min.asm tests RCASM Assembler generating Z80 code
;
; 08/11/2022 Doug Rice
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

Mem:		equ 08000h


	org	0h
	jp init
		
	org	100h
	
init:
	ld  sp, 0ffffh        
	
	
	
    ld    a,'>'
    out	  (081h),a
	
loop:	


	
getchar:      
	; test and block if no key available.
    in	a,(080h)    ; the control register is addressed on port 80H
	and 01h
	jr	z,getchar
    
getchar2:    
	in a,(081h)
	push af


putchar:	
	; test and block if still sending last char
	in	a,(080h)  ; the control register is addressed on port 80H   
	;test TX_empty bit.		  	
	and 02h	
	jr  z,putchar
    
    pop af
    out	  (081h),a
    
    jp getchar
	 
	ret

