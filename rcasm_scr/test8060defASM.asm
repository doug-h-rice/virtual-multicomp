;
; testASM.asm tests Assembler 
; this file tests the RCASM 8060.def file 
; each instruction and typical syntax is tested
;
; build rcasm 
; ..\tcc rcasm.c asmcmds.c mstrings.c support.c
;
; rcasm -l -h -r -d 8060 testASM.asm
; rcasm -l -h -r -d8060 testASM.asm
;
; rcasm -l -h -r -d8060 testASM.asm
; 
; 23/01/2020 Doug Rice
;
;
;
;



8060{

Disp:	.equ 0d00H
ChRom:	.equ 010bH
Duck:	.equ 061h

;	org	0f0fh
	org	0f50h
	ldi	0fh
	xpah	P1
	ldi	060h
	xpal	P1
	jmp +0(P1)

	org 0F5Dh
	xppc P3
	xppc P3
	xppc P3
	xppc P3	
	xppc P3
	xppc P3
	xppc P3
	xppc P3	
	xppc P3
	xppc P3
	xppc P3
	xppc P3	
	xppc P3
	xppc P3
	xppc P3
	xppc P3	

	; Test:- single byte instructions	
	org	0f70h	
	halt
	xae
	ccl
	scl
	dint
	ien
	csa
	cas
	nop
	
	sio
	
	sr
	srl
	rr
	rrl
	
	xpal 0
	xpal 1
	xpal 2
	xpal 3

	xpah 0
	xpah 1
	xpah 2
	xpah 3
	
	xppc 0
	xppc 1
	xppc 2
	xppc 3

	xppc P0
	xppc P1
	xppc P2
	xppc P3

	
	LDE
	
	ANE
	ORE
	XRE
	DAE
	ADE
	CAE

	; Test:- two byte instructions not using pointers	
	
	DLY 0
	DLY 255

	; Test:- Two byte instructions jmps
	;  
	; Test:- Two Byte PC Relative instructions	
	;	PC in incremented at start of instruction, PC+1+disp => PC
	;
	; 8060.def uses
	; JMP	\D
	; 90 \1
	;
here:
	jmp	here 	; 90 FE
	jp	here
	jz	here
	jnz here

	jmp	next	; 90 00
next:
	jmp	next	; 90 00

	jmp	here(1)
	jp	here(1)
	jz	here(1)
	jnz here(1)

	; Test:- Two byte instructions jmps
	;  
	; Test:- Two Byte PC Relative instructions	
	;	PC in incremented at start of instruction, PC+1+disp => PC
	;	RCASM treats +0(0) as absolute
	;   8060.def uses
	;
	;	JMP	\D\{rg}
	;	90|2 |1 works
	;
	
	jmp	+0(0) ; PC incremented at start of instruction.
	jmp	+0(1)
	jmp	+0(2)
	jmp	+0(3) ; expect 93 00

	jmp	+1(0) ; PC incremented at start of instruction.
	jmp	+1(1)
	jmp	+1(2)
	jmp	+1(3) ; expect 93 01

	jmp	-1(0) ; PC incremented at start of instruction.
	jmp	-1(1)
	jmp	-1(2)
	jmp	-1(3) ; expect 93 FF

	jp	+0(0) ; PC incremented at start of instruction.
	jp	+0(1)
	jp	+0(2)
	jp	+0(3) ; expect 93 00 

	jp	+1(0) ; PC incremented at start of instruction.
	jp	+1(1)
	jp	+1(2)
	jp	+1(3) ; expect 93 01 

	jp	-1(0) ; PC incremented at start of instruction.
	jp	-1(1)
	jp	-1(2)
	jp	-1(3) ; expect 93 FF 

	jz	+0(0) ; PC incremented at start of instruction.
	jz	+0(1)
	jz	+0(2)
	jz	+0(3) ; expect 93 00 

	jz	+1(0) ; PC incremented at start of instruction.
	jz	+1(1)
	jz	+1(2)
	jz	+1(3) ; expect 93 01 

	jz	-1(0) ; PC incremented at start of instruction.
	jz	-1(1)
	jz	-1(2)
	jz	-1(3) ; expect 93 FF 

	jnz	+0(0) ; PC incremented at start of instruction.
	jnz	+0(1)
	jnz	+0(2)
	jnz	+0(3) ; expect 93 00 

	jnz	+1(0) ; PC incremented at start of instruction.
	jnz	+1(1)
	jnz	+1(2)
	jnz	+1(3) ; expect 93 01 

	jnz	-1(0) ; PC incremented at start of instruction.
	jnz	-1(1)
	jnz	-1(2)
	jnz	-1(3) ; expect 93 FF 



	; Test:- Two byte instructions jmps
	;  
	; Test:- Two Byte JMP PC Relative instructions	
	;	PC in incremented at start of instruction, PC+1+disp => PC
	;	RCASM treats +0(0) as absolute
	;   8060.def uses
	;
	;   JMP	\E\{rg}
	;   90|2 lo(1)
	;
	;	NOTE RCASM seems to generate   disp with 1 added.
	;	
	jp	here(1) ; here is a PC relative value
	jz	here(1)
	jnz here(1)




	ildr data
	ild data
	
	ild +1(0) ; pc is incremented before offset added.
	ild +1(1)
	ild -1(2)
	ild +1(3)
	
	ild @+1(1) ; @ not supported
	ild @-1(2) ; @ not supported 
	ild @+1(3) ; @ not supported
	
	
	dldr data 
	dld data 
	dld +1(1)
	dld -1(2)
	dld +1(3)
	dld @+1(1) ; @ not supported
	dld @-1(2) ; @ not supported
	dld @+1(3) ; @ not supported

disp: .equ 0d00h
data: .db 0AAh 
dec: .equ 10

	LDI	0Dh
	LDI	Disp.1 ; to get hi byte .1
	LDI	Disp.0 ; to get lo byte .0
    ; to get hi byte .2
	
	;LDI H(Disp)
	;LDI L(Disp)
	LDR data
	LD data
	
	;
	;
	; 
	;
	ld +1(0) ; PC in incremented before disp added.
	ld +1(1) 
	ld +1(2) 
	ld +1(3) 
	ld +dec(3) 

	ld @+1(0) 
	ld @+1(1) 
	ld @+1(2) 
	ld @+1(3) 
	ld -dec(3) 
	
	; load using absolute address but relative to PC
	str data
	st data
	; Offset rel Pointer
	st +1(0) 
	st +1(1) 
	st +1(2) 
	st +1(3) 
	st +dec(3) 

	st @+1(0) ; 
	st @+1(1) 
	st @+1(2) 
	st @+1(3) 
	ld -dec(3) 
	

	
	ldr	here
	ld	here
	ld	+0(1)
	ld	@+0(1)
	
	st	+0(1)
	andr here
	and here
	and +0(1)
	and @+0(1)
	ani	0
	
	orr here
	or here
	or	+0(1)
	or	@+0(1)
	ori 0
	
	xorr here
	xor here
	xor	+0(1)
	xor	@+0(1)
	xri	0
	
	dadr here
	dad here
	dad +0(1)
	dad @+0(1)
	dai 0
	
	addr here
	add here
	add +0(1)
	add @+0(1)
	adi 0
	
	cadr here	
	cad here	
	cad +0(1)
	cad @+0(1)
	cai 0
	
	; simple example
loop:	
	ldi	0AAh
	xri 055h
	st +1(0) ; relative to (0) is a problem
	st +1(1) ; 
	str op 
	st  op 
	xppc P3
op:	db 0
	jmp loop
	
	jmp	-129(0)
	jmp	+126(0)
	
	
	
;tmp:	db 0
Row:	.db 0
Count:	.db 0
Sum:	.db 0
;tmp1:	db 0	

Shoot:
	; reload display pointer.
	LDI	Disp.1
	XPAH	1
	LDI	Disp.0
	XPAL	1
	LDI	1
	ST	Row
React:
	LDI 	01	; speed of flight
	ST	Count
	LDI	0
	ST	Sum

	;LDI 	0AAh	; speed of flight
	;STR	Count
	;LDI	055h
	;STR	Sum



	; xppc	3

Shift:	LDI	40	;Move ducks this time
Ndig:	XAE
	LD	Row
	RR
	ST	Row
	JP	No

	LDI	Duck
	JMP	Go

No:
	LDI 	0	;No duck
Go:
	ST	-128(1)
	DLY	01

	LD	Sum

	JNZ	Nok	;No Key

	LD	-128(1)
	XRI	0FFh
	JZ	Nok
	ST	Sum
	LD	Row
	XRI	080h
	ST	Row	;Change top bit

Nok:	
	LDE
	SCL
	CAI	1	; Subtract 1
	JP	Ndig	;Do next digit

	DLD	Count
	JZ	React	;Start new position

	LDI	7
	JMP	Ndig 	;Another sweep
}	

