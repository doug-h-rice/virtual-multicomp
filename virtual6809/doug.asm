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
* dv	:
*	./as9 doug.asm -l s19
*	6809_multicomp/a.out doug.s19
*	stty sane
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
 	ORG   $E000

* send character to screen
SUBWAITTX
	STA	$FFD1
	
WAITTX
	LDA $FFD0
	LDA	#$01
	ANDA	#$02
*	BEQ	WAITTX
	
	NOP

	RTS


INIT
*	NOP

*	*** load Stack pointer	
	LDS	#$0100		
*	NOP
*	NOP
*	LDX	#$D200		

	
*************************************************
* sec 1.0 Main Loop
*************************************************	
	
LOOP	
*	LDA	#$0D
*	JSR SUBWAITTX

	LDA	$FFD1
	JSR SUBWAITTX
	JSR	SUB0
	
	JSR	SUB4
	JMP LOOP
	
	LDA	$FFD0
	ANDA #$01
	
	BEQ	LOOP	
	
	LDA	$FFD1
	ADDA #$1
	STA	$FFD1

	JMP LOOP


*	LDA	#$41
*	STA	$FFD1

	LDA	$FFD2
	STA	$FFD1

	LDA	$FFD3
	STA	$FFD1

	
*	JSR	SUBWAITTX

*	JMP LOOP
		
*	JSR	SUB1
*	JSR	SUB2
	JSR	SUB3

	JMP LOOP


* Look up char and print out string
	LDX	#0
	LDA	#'B'
	JSR	SUB4
	LDA	#'A'
	JSR	SUB4
	LDA	#'C'
	JSR	SUB4
	LDA	#'E'
	JSR	SUB4
	nop
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

* 	Get key from UART and print it.
SUB0
	LDA	$FFD0
	ANDA #$01

	BEQ	SUB0	

* Character Available, write it
	
	LDA	$FFD1
	ADDA #$0
	STA	$FFD1

* Leave character in Accumulator
	rts



SUB1
	nop
	
*	*** Software interupt	
	SWI
	nop
	rts
	
	

SUB2


	
	ldx	MSG1 	; load X with 2 bytes from string
*	; load X as pointer to string and load A with each char from string
	ldx	#MSG1 	
	lda	,x+
	lda	,x+
	lda	,x+
	lda	,x+
	lda	,x+
	lda	,x+

	lda	,-x
	lda	,-x
	lda	,-x
	lda	,-x
	lda	,-x
	lda	,-x



	nop
* 	;IMMEDIATE ADDRESSING, load register with value
	LDA #$20
	LDX #$f000
	ldy #CAT

* 	;load efective address 
	leax	10,x	; add 10 to X
	leax	500,x	; add 500 to x
	
* 	;Add A reg to Y and store in Y
	leay	A,Y
	
* 	;Add D reg to Y and store in Y	
	leay	D,Y	


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

	
	; LOAD Efective Address Instructions
	; try some auto increment
	; ?? x seems to remain the same

	; Data Sheet explains: 	
	; LEAa, b+
	; b    -> temp
	; b+1  -> b
	; temp -> a
	;
	
	; LEAa, -b
	; b-1	-> temp
	; b-1 	-> b
	; temp 	-> a
	;
	
	
	
	
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


	
	; LEAa, -b
	; b-1	-> temp
	; b-1 	-> b
	; temp 	-> a
	;

	; disassebled as leax ,x
	; x- is illegal, only x+ allowed
	leax	0,x+	; disassebled as leax ,x
	leax	0,-x	; disassebled as leax ,x

	leay	0,y+	; disassebled as leay ,y
	leay	0,-y	; disassebled as leay ,y

	nop
	nop
	
	
	; LEAa, -b
	; b-1	-> temp
	; b-1 	-> b
	; temp 	-> a
	;

	; disassebled as leax ,x
	; x-- illegal
	
	leax	0,--x	; x decrememted
	leax	0,--x	; 

	leay	0,--y	; 
	leay	0,--y	; 

	
	; LOAD Efective Address Instructions
	; try some auto increment
	; ?? x seems to remain the same

	; Data Sheet explains: 	
	; LEAa, b+
	; b    -> temp
	; b+1  -> b
	; temp -> a
	;
	
	; LEAa, -b
	; b-1	-> temp
	; b-1 	-> b
	; temp 	-> a
	;


	; 

	leay	0,--x
	leay	0,--x

	leax	0,-y
	leax	0,-y




	leay	0,x++
	leay	0,x++
	leay	0,x++
	leay	0,x++


	; these do not seem to do anything	
	leax	0,x++
	leax	0,x++
	leax	0,x++
	leax	0,x++
*	;Load D which is A B as 16 bit

	ldx	MSG1 	
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	
	ldd	[,--x]
	ldd	[,--x]
	ldd	[,--x]
	ldd	[,--x]


	nop
	rts

*************************************************
* sec 1.0 strings
*************************************************	

MSG1	FCC 'hello doug'

*************************************************
* sec 1.0 subroutines
*************************************************	

SUB3

* TST - sets flag based
  
	lda	#$0ff
	tsta

	lda	#$00
	tsta

	lda	#$01
	tsta

	lda	#$080
	tsta

* compare
	
	lda	  #$0ff
	cmpa  #$00	

	cmpa  #$80	

	cmpa  #$01	

	cmpa  #$ff	

* compare
	
	lda	  #$0ff
	cmpa  #$00	

	cmpa  #$80	

	cmpa  #$01	

	cmpa  #$ff	

* compare
	
	lda	  #$0ff
	cmpa  #$00	

	cmpa  #$80	

	cmpa  #$01	

	cmpa  #$ff	

	
	rts


*************************************************
* sec 1.0 subroutines
*************************************************	

MSG4table
	FCB	#'A'
	FDB MSG4str1
	FCB	#'B'
	FDB MSG4str2
	FCB	#'a'
	FDB MSG4str3
	FCB	#0
	FDB 0
	
	
MSG4str1	

	FCC ":1-hello doug"
	FCB	#0
		
MSG4str2
	FCC ":2-hello henry"
	FCB	#0
	
MSG4str3
	FCC ":3-hello frank"
	FCB	#0

	FCB	#0

* ************************************
* SUB4 look up A in table and return address of NULL terminated string
*
* 'a'
* ADDRESSS
* 'b'
* ADDRESSS
* 'c'
* ADDRESSS
* 'd'
* ADDRESSS
* 0
* 0
*
* ************************************

SUB4
* 	lookup character intable and find address
*	LDA	#'A'

*
* Load x with a recognisable number
* 
	LDX	#$0004
	LDX	#MSG4table

SUB4loop
*
*	LDB		,x
* is next
 
	TST		,x		
	beq		SUB4notFound
	CMPA	,x+
	beq		SUB4found
	
SUB4a
* increment past address 
	CMPA	,x++
	jmp		SUB4loop
	
SUB4found
* load X with wanted address
	LEAX	[,x]
	
SUB4foundAndShow	
	LDA		,x+
	beq		SUB4notFound
	nop
	STA		$FFD1
	nop
	nop
	JMP		SUB4foundAndShow	
	

SUB4notFound
	nop
	nop
	
	
	rts
