;
; File: min.asm tests RCASM Assembler generating Z80 code
;
; 08/11/2022 Doug Rice
;
; Description: This generates some code at 0x0
; 
; this file uses the RCASM Z80.def
;
; build rcasm using Tiny C 
; ..\tcc rcasm.c asmcmds.c mstrings.c support.c
; 
; 09/11/2022 Doug Rice
;
; ./rcasm -dz80 -l -h min.asm
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

	org	0h
	jp init
			
	org	100h
init:
; set stack pointer to top of RAM
	ld  sp, 0ffffh        
	
	ld    a,'>'
	out	  (081h),a

	
loop:	

;
; while( TRUE ){
;  putchar( getchar(); );
; }
	
getchar:      
	; test and block if no key available.
	in	a,(080h)    ; the control register is addressed on port 80H
	and 01h
	jr	z,getchar

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
    
    
	jp loop
	 
	ret

