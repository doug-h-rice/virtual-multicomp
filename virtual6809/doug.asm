**************************************************
*                                                *
* doug.asm
*
*
* Try out of 6809 assembler
*
* The cpu resets $FFFF
*
*
* Objectives
* 
*
*	set up vectors
*	run start up code
*	run simple code
*
* usage:
*   ./as9 doug.asm -l s19
*   6809/a.out doug.s19
*	
*
*************************************************
* PC
* U
* S
* Y
* X
* D { A,B
* DP
* CC
*************************************************




*************************************************
* sec 1.0 JUMP vectors for Processor reset and interupts. 
*************************************************	
**
*	SWI2
*	SWI3
*	FIRQ
*	IRQ
*	SWI
*	NMI
*	RESET
**	
 	ORG	$FFF2
 	FDB	SWI2rtn
 	FDB	SWI3rtn
 	FDB	FIRQrtn
 	FDB	IRQrtn
	FDB	SWIrtn
	FDB	NMIrtn
	FDB	RESETrtn



 	ORG   $0200
CAT:	FDB 0
DOUG:	FDB 0 	
	

*************************************************
* sec 1.0 Start of real code
*************************************************	
 	ORG   $F800




INIT
	NOP

*	*** load Stack pointer	
	LDS	#$0100		
	NOP
	NOP


*	*** load Stack pointer	

	LDX	#$D200		
	
	
*************************************************
* sec 1.0 Main Loop
*************************************************	
	
LOOP	
		
	JSR	SUB1
	JSR	SUB2

	NOP
	JMP LOOP
	


*************************************************
* sec 1.0 Interupt routines
*************************************************	

	
SWI2rtn
	NOP
	RTI
	
SWI3rtn
	NOP
	RTI

FIRQrtn
	NOP
	RTI
		
IRQrtn
	NOP
	RTI
	
SWIrtn
	NOP
	RTI

NMIrtn
	NOP
	RTI

RESETrtn
	JMP INIT
	RTI



*************************************************
* sec 1.0 subroutines
*************************************************	


SUB1
	nop
	
*	*** Software interupt	
	SWI
	nop
	rts
	
	
	
SUB2
	nop
	LDA #$20
	LDX #$f000
	ldy #CAT

	leax	10,x	; add 10 to X
	leax	500,x	; add 500 to x
	leay	a,y		; add a to y
	leay	d,y		; add D to y
	leau	-10,u	; add -10 to u
	leas	-10,s
	leas	10,s
	leax	5,s

	lda	#$20

	; try some auto increment
	; ?? x seems to remain the same 
	lda		0,x+
	lda		0,x++

	lda		0,x+
	lda		0,x++

	lda		0,x+
	lda		0,x++
	
	; try some auto increment
	; ?? x seems to remain the same 
	leax	0,x+
	leax	0,x+

	leay	0,y+
	leay	0,y+

	; ?? x->y, then x=x+2
	leay	0,x++
	leay	0,x++

	; ?? y->x, then y=y+2
	leax	0,y++
	leax	0,y++



	; disassebled as leax ,x
	leax	0,x-	; disassebled as leax ,x
	leax	0,x-	; disassebled as leax ,x

	leay	0,y-	; disassebled as leay ,y
	leay	0,y-	; disassebled as leay ,y

	nop
	nop
	

	; disassebled as leax ,x
	leax	0,x--	; disassebled as leax ,x
	leax	0,x--	; disassebled as leax ,x

	leay	0,y--	; disassebled as leay ,y
	leay	0,y--	; disassebled as leay ,y



	; ?? x seems to remain the same 

	leay	0,x--
	leay	0,x--

	leax	0,y--
	leax	0,y--




	leay	0,x++
	leay	0,x++
	leay	0,x++
	leay	0,x++


	; these do not seem to do anything	
	leax	0,x++
	leax	0,x++
	leax	0,x++
	leax	0,x++
	
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	


	nop
	rts



*************************************************
* sec 1.0 subroutines
*************************************************	

