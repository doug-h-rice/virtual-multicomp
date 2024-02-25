**************************************************
*
*
* 6809 dabble to try 6809 assembler on Cyclone FPGA
*
* http://atjs.mbnet.fi/mc6809/#Emu - Sbc6809 - sbc09.tar.gz
* Assembled :-
* For Windows, I downloaded asm6809-2.12-w64 from http://www.6809.org.uk/
* For Linux I used as9
*
* I could single step the code using:
* http://atjs.mbnet.fi/mc6809/6809Emulators/6809.zip 
*
* This was easy to build using Fabrice Bellard's TCC and GCC on Linux. 
*
* Grand Searle's Multicomp for 6809 provides hardware to run my 6809 code.
* http://searle.wales/ FPGA -  Multicomp on Cyclone11 - 6809
*
* You need to install the Altera Quartus 13.0 free version.
*
* C:/altera/13.0sp1web/Multicomp/Microcomputer
*
* Grant's website havs spawned many projects
*
* This one is useful. Doug has ported Grants code to many FPGA boards.
* https://hackaday.io/LandBoards 
* https://github.com/land-boards - A vast 700MB download that provided a challenge.
* http://land-boards.com/blwiki/index.php?title=Main_Page
* https://www.youtube.com/channel/UCTemcBf9UzLwhLCaOMRJEqQ/videos
*
* Once the code was assembled, I found it was possible to load it into the FPGA.
*
* However the address needs ajusting as the ROM starts at $E000 to $FFFF.
* A simple C program was writeen to do this. hexROMadjust.c
*
******************************************************
* doug2.asm
*
* Try out of 6809 assembler
*
* The cpu resets $FFFF
*
* Objectives
*
*	set up vectors
*	run start up code
*	run simple code
*
* usage:
*   ./as9 doug2.asm -l s19
*   6809/virtual doug2.s19
*	
* asm6809 --hex -l doug.lst -o doug.hex  doug.asm
*
* I need a utility to move the hex file. 
* The hex file is abosulte but I need to split the file to load into the devices
* The ROM is at 0XE000 to 0XFFFF in the memory map but is at 0X0000 to 0X1FFF in the device.
* The RAM is at 0X0000 to 0X3FFF in the memory map but is at 0X0000 to 0X3FFF in the device.
*
* as9 does not recognise \r and \n in strings
* as9 does not recognise FCN 
*
******************************************************
*
*rem do_dougs6809dabble.asm.bat
*rem
*rem
*asm6809 --hex -l doug.lst -o doug.hex  doug.asm
*asm6809 --hex -l doug.lst -o doug.hex  dougs6809dabble.asm
*rem pause
*
*I wrote hexROMadjust to allow for ROM @0XE000 to 0XFFFF needs addesses from 0X0000 to 0X01FF 
*type doug.hex | hexROMadjust.exe 
*type doug.hex | hexROMadjust.exe > doug_2f.hex
*hexROMadjust doug.hex > doug_2f.hex
*
* Doug Gilliland's https://github.com/land-boards - A challenge to get working
*copy doug_1f.hex C:\altera\13.0sp1web\M6809_VGA_PS2_UART_IntRAM(16K)\output_files
*copy doug_2f.hex C:\altera\13.0sp1web\M6809_VGA_PS2_UART_IntRAM(16K)\output_files
*
*Grant Searle's
*copy doug_1f.hex C:\altera\13.0sp1web\Multicomp\Microcomputer\output_files
*copy doug_2f.hex C:\altera\13.0sp1web\Multicomp\Microcomputer\output_files
*
*pause
*
* With the altera\13.0sp1web installed it is possible to modify the ROM contents without rebuilding the .sof file.
*
* You can use the GUI, but it must be possible to automate this.
*
*Command line update ROM contents of Grants Multicomp
*rem cd C:\altera\13.0sp1web\Multicomp\Microcomputer>
*C:\altera\13.0sp1web\quartus\bin\quartus_stp -t C:\altera\13.0sp1web\Multicomp\Microcomputer\MicrocomputerCmd.qsf
*
*pause
*
*******************************************************
* modify ROM so it can be modified via the USB Blaster. 
* M6809_MY_ROM.vhd
*	GENERIC MAP (
*	..
*		init_file => "../../Microcomputer/output_files/doug_1f.hex",
*	..	
*		lpm_hint => "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=ROM1",
*	..	
*		operation_mode => "ROM",
*	)
*
* 
* With the altera\13.0sp1web installed it is possible to modify the ROM contents without rebuilding the .sof file.
*
* You can use the GUI, but it must be possible to automate this.
*
* #C:\altera\13.0sp1web\quartus\bin\quartus_stp -t C:\altera\13.0sp1web\Multicomp\MicrocomputerMicrocomputerCmd.qsf
* #end_memory_edit
*
* begin_memory_edit -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
* get_editable_mem_instances -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
* update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:/altera/13.0sp1web/Multicomp/Microcomputer/output_files/doug_1f.hex" -mem_file_type "HEX"
* end_memory_edit
*
*# C:\altera\13.0sp1web\quartus\bin\quartus_stp
*# Quartus II 32-bit SignalTap II
*# Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition
*# Copyright (C) 1991-2013 Altera Corporation
*# quartus_stp -s
*# quartus_stp --tcl_eval <tcl command>
*
*# C:\Users\doug>C:\altera\13.0sp1web\quartus\bin\quartus_stp -s
*
*C:\altera\13.0sp1web\quartus\bin\quartus_stp -t C:\altera\13.0sp1web\Multicomp\MicrocomputerMicrocomputerCmd.qsf

*Info (261000): get_editable_mem_instances -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
*Info (261000): begin_memory_edit -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
*Info (261000): get_editable_mem_instances -hardware_name "USB-Blaster \[USB-0\]" -device_name ""
*Info (261000): begin_memory_edit -hardware_name "USB-Blaster \[USB-0\]" -device_name ""
*Info (261000): get_editable_mem_instances -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
*Info (261000): begin_memory_edit -hardware_name "USB-Blaster \[USB-0\]" -device_name "@1: EP2C5 (0x020B10DD)"
*Info (261000): update_content_to_memory_from_file -instance_index 0 -mem_file_path "C:/altera/13.0sp1web/Multicomp/Microcomputer/output_files/doug_1f.hex" -mem_file_type ""
*Info (261000): write_content_to_memory -instance_index 0 -content "<value string is too long to be displayed>" -content_in_hex -start_address 0 -word_count 8192
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
* ../ROMS/6809/EXT_BASIC_NO_USING.hex
*

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
* 	ORG	$00F2
	
 	FDB	SWI2rtn
 	FDB	SWI3rtn
 	FDB	FIRQrtn
 	FDB	IRQrtn
	FDB	SWIrtn
	FDB	NMIrtn
	FDB	RESETrtn



* 	ORG   $0180
* CAT		FDB 0
* DOUG		FDB 0 	
	

*************************************************
* sec 1.0 Start of real code
*************************************************	
 	ORG   $E000

INIT
	NOP

*	*** load Stack pointer	
	LDS	#$0080		
	NOP
	NOP
	
	
*
*	http://atjs.mbnet.fi/mc6809/Information/6809.TXT
*   http://atjs.mbnet.fi/mc6809/Information/6809.htm

*	LDX	#$D200		
	LDX	#$0200		

* DEBUG code used to get 6809 on VGA card
* It was a struggle to get the FPGA to work
* Using the inbuilt logic analyser something was working
*
* It is possible to read and write the RAM and ROM using the USBBaster if enabled.
*
* write something to ram	
	nop
	LDA #$20
	LDX #$1300
	
	lda	#$20
	sta $0101

	lda	#$31
	sta $0102
	
	lda	#$32
	sta $0102
	
	lda	#$33
	sta $0103
	
	lda	#$34
	sta $0104
	
* copy ram to ram. Can we see if it has moved.
	
	LDA $0101
	sta $0111
	
	LDA $0102
	sta $0112

	LDA $0103
	sta $0113
	
	LDA $0104
	sta $0114

	LDA $0105
	sta $0115



LOOP_0A

	LDX		#MSG12
	JSR		SUB3a

* block for  key press returns charater in A
	JSR SUB_WAIT_RX

*	sta $FFD1
*	JSR SUBWAITTX

	
*	
* print out string selected by key pressed
	JSR	SUB3_pick
*	JSR SUB4

* tidy up.
	JSR	SUB3

	JMP LOOP_0A


**************************************************
* SEC 1.0 Early test code write characters to the UART
**************************************************

LOOPA

* write character to UART at $FFD1, and check if TX buffer
	LDA #'D'
*	STA $FFD1
	JSR SUBWAITTX
	
* try and wait for the TX buffer to empty
WAITTX1

	LDA $FFD0
	ANDA #$02
	BEQ	 WAITTX1

	LDA #'a'
	STA $FFD1


* try and wait for the TX buffer to empty
WAITTX2
	LDA $FFD0
	ANDA #$02
*	BNE	 WAITTX2



**************************************************
* SEC 1.0 Early test code write characters to the UART
**************************************************

*
* Subrouting was not returning.
* Memory did not work until another Int16K .vhd was used.
*
	LDA #'1'
	JSR SUBWAITTX

	LDA #'2'
	JSR SUBWAITTX

	LDA #'3'
	JSR SUBWAITTX

	LDA #'4'
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #'D'
	JSR SUBWAITTX

	LDA #'o'
	JSR SUBWAITTX

	LDA #'u'
	JSR SUBWAITTX

	LDA #'g'
	JSR SUBWAITTX

	LDA #$0D
	JSR SUBWAITTX

	LDA #$0A
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX


	LDX		#MSG12
	JSR		SUB3a

*
* send esc[31m to change colour of text on screen.
*
	LDA #27
	JSR SUBWAITTX

	LDA #'['
	JSR SUBWAITTX

	LDA #'3'
	JSR SUBWAITTX

	LDA #'1'
	JSR SUBWAITTX

	LDA #'m'
	JSR SUBWAITTX

	LDA #'H'
	JSR SUBWAITTX

	LDA #'e'
	JSR SUBWAITTX

	LDA #'l'
	JSR SUBWAITTX


	LDA #'l'
	JSR SUBWAITTX

	LDA #'o'
	JSR SUBWAITTX


	LDA #27
	JSR SUBWAITTX

	LDA #'['
	JSR SUBWAITTX

	LDA #'m'
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #' '
	JSR SUBWAITTX

	LDA #'H'
	JSR SUBWAITTX

	LDA #'e'
	JSR SUBWAITTX

	LDA #'l'
	JSR SUBWAITTX


	LDA #'l'
	JSR SUBWAITTX

	LDA #'o'
	JSR SUBWAITTX

	LDA #'#'
	JSR SUBWAITTX


	JSR	SUB3

	LDA #':'
	JSR SUBWAITTX


*	get  key
*
*	LDA $FFD0
*	anda #$0F
*	adda #$30
*	sta $FFD1
*

* block for  key press returns charater in A
	JSR SUB_WAIT_RX

	sta $FFD1
*	JSR SUBWAITTX

	
*	
* print out string selected by key pressed
	JSR	SUB3_pick
*	JSR SUB4

* tidy up.
	JSR	SUB3

	JMP LOOPA
	
LOOPA_1
	JMP LOOPA
	
	ldd	[,x++]
	
	lda	#$41
	sta [,x++]
	ldd	[,x++]

	lda	#$42
	sta [,x++]
	ldd	[,x++]
	
	lda	#$3
	sta [,x++]
	ldd	[,x++]
	
	JMP INIT


loop 


**************************************************
* SEC 1.0 subroutine to wit for character from UART
**************************************************
SUB_WAIT_RX

* block for  key press
SUB_WAIT_RX_LOOPA
	; check if key board had character
	LDA $FFD0
	anda #$01
	beq	SUB_WAIT_RX_LOOPA
	; read new character 
	LDA	$FFD1
	RTS



**************************************************
* SEC 1.0 subroutine to print A to UART
**************************************************

SUBWAITTX
*	store A to UART 
	STA $FFD1
*	rts
* try and wait for the TX buffer to empty
WAITTX
	LDA $FFD0
	ANDA #$02
	BEQ	 WAITTX

	nop
	RTS 

	
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
	
	
*************************************************
* sec 1.0 Learn about some commands
*************************************************	
	
SUB2

	nop
	LDA #$20
	LDX #$0300
	
	lda	#$20
	ldd	[,x++]
	
	lda	#$41
	ldd	[,x++]

	lda	#$42
	ldd	[,x++]
	
	lda	#$3
	ldd	[,x++]

	nop
	
	LDA #$20
	LDX #$f000
*	ldy #CAT

	leax	10,x	; add 10 to X
	leax	500,x	; add 500 to x
	leay	a,y		; add a to y
	leay	d,y		; add D to y
	leau	-10,u	; add -10 to u
	leas	-10,s
	leas	10,s
	leax	5,s

	lda	#$20
	
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	ldd	[,x++]
	
	nop
	rts


*************************************************
* sec 1.0 subroutines - 
*************************************************	
*
* use character in A to pick string to display.
*
*
SUB3_pick
* test A and jmp
	CMPA	#'1'
	BEQ		SUB3_set1	

	CMPA	#'2'
	BEQ		SUB3_set2	

	CMPA	#'3'
	BEQ		SUB3_set3

	CMPA	#'4'
	BEQ		SUB3_set4



* preload X then compare.
	LDX		#MSG5
	CMPA	#'5'
	BEQ		SUB3a

	LDX		#MSG6
	CMPA	#'6'
	BEQ		SUB3a

	LDX		#MSG7
	CMPA	#'7'
	BEQ		SUB3a

	LDX		#MSG8
	CMPA	#'8'
	BEQ		SUB3a


	LDX		#MSG9
	CMPA	#'9'
	BEQ		SUB3a



	LDX		#MSG10
	CMPA	#'0'
	BEQ		SUB3a



	LDX		#MSG11
	CMPA	#'-'
	BEQ		SUB3a


 
	jmp 	SUB3



SUB3_set1
	LDX		#MSG1
	jmp 	SUB3a

SUB3_set2
	LDX		#MSG2
	jmp 	SUB3a

SUB3_set3
	LDX		#MSG3
	jmp 	SUB3a

SUB3_set4
	LDX		#MSG4
	jmp 	SUB3a

SUB3
* test

*	; print out string
	LDX		#MSG0

*	get character pointed to by X and write to UART, end if \0 found
SUB3a	
	lda		,x+
	anda	#$FF
	beq		SUB3b
*	STA 	$FFD1
	JSR SUBWAITTX
	jmp		SUB3a
	
SUB3b
	RTS


*************************************************
* sec 1.0 subroutines - 
*************************************************	
*
* use character in A to pick string to display.
* does not work!
*

SUB4
* --- not working yet ---
* A holds choice,
* look up 
	LDX		#MSG_table
	LDB 	#' '
	STB $FFD1
	LDD		,X
	STB $FFD1
	STA $FFD1
	LDB 	#'}'
	STB $FFD1
	LDB 	#'a'
	STB $FFD1
	LDB 	#'|'
	STB $FFD1
	
SUB4_loop 	
	CMPA	[,x]
	BEQ		SUB4_found
	LEAY	[,x++]

*	LDA 	#'}'
	STA $FFD1

	RTS	
	JMP		SUB4_loop
	

SUB4_found
	
	LDA		#'>'
	JSR SUB3_pick

* FOUND and X points to address of message. 

	LEAX	,x 
	jmp		SUB3a
	
	
SUB4_notfound
	LDA '>'
	STA $FFD1	
	rts
	
	
MSG_table
	FCB	'A'
	FDB MSG1
	FCB	'B'
	FDB MSG2
	FCB	'C'
	FDB MSG3
	FCB	'D'
	FDB MSG4
	FCB 0
	FDB 0

*************************************************
* sec 1.0 some ANSII escapes for rs232 display - 
*************************************************	
*
* use character in A to pick string to display.
*
*
* ANSI
*
* 3x,4x,9x,10x
* 3x 	dim foreground colours
* 4x 	dim background colours
* 9x 	bright foreground colours 
* 10x 	Bright background colours
*
* 30    black
* 31	red
* 32	green
* 33	yellow
* 34	blue
* 35	magenta
* 36	cyan
* 37	white

*************************************************
* sec 1.0 some Strings 
*************************************************	

*
* as9 does not recognise \r and \n in strings
* as9 does not recognise FCN 
*


* esc [ m and string with Null terminated  
MSG0
	FCB	$1B	
*	FCC "[m            \r\n"
	FCC "[m            "
	FCB $0A
	FCB $0D

	FCB 0

MSG1	
	FCB	$1B
	FCC "[91m . -- stop -- "
	FCB 0

MSG2	
	FCB	$1B
	FCC "[92m * ==start==  "
	FCB 0

MSG3
	FCB	$1B
	FCC "[93m . -- warning -- "
	FCB 0
	
MSG4	
	FCB	$1B
	FCC "[103m ~ ~ Running ~ ~ "
	FCB 0

MSG5	
	FCB	$1B
	FCC "[41m ~ ~ 41m message ~ ~ "
	FCB 0

MSG6	
	FCB	$1B
	FCC "[42m ~ ~ 42m x x x x ~ ~ "
	FCB 0

MSG7	
	FCB	$1B
	FCC "[43m ~ ~ 43m x x x x ~ ~ "
	FCB 0

MSG8	
	FCB	$1B
	FCC "[44m ~ ~ 44m x x x x ~ ~ "
	FCB 0

MSG9	
	FCB	$1B
	FCC "[45m ~ ~ 45m x x x x ~ ~ "
	FCB 0

MSG10	
	FCB	$1B
	FCC "[46m ~ ~ 46m x x x x ~ ~ "
	FCB 0

MSG11	
	FCB	$1B
	FCC "[47m ~ ~ 47m x x x x ~ ~ "
	FCB 0

MSG12	
	FCB $0A
	FCB $0D
	FCB	$1B
	FCC "[104m  - - - 6809 - - - - "

	FCB	$1B
	FCC "[0m "

	FCB	$1B
	FCC "[100mPress: 1..0:"

	FCB	$1B
	FCC "[0m"
	FCB 0

*************************************************
* sec 1.0 subroutines
*************************************************	

