====================
readme.txt
====================
Doug Rice 24/09/2019

Tested on LINUX Raspberry Pi Strech PC version

Grant Searle's Multipcomp boards have been popular on the web.

http://searle.hostei.com/grant/
http://searle.hostei.com/grant/#MyZ80
http://searle.hostei.com/grant/Multicomp/index.html

http://searle.hostei.com/grant/z80/SimpleZ80.html

However it would be useful to emulate Z80 code before programming an EPROM

They provide a minimal component board to play with old processors.

The Z80 board has a:
	PCB - providing wiring
	CPU - running z80 code
	RAM - 
	ROM - programmed with code to boot z80 and demo board. e.g. Basic
	UART - serial interface

There is a VHDL version which loads a hex file containing Z80 code.

The hex file contains BASIC and CRT0 and code for the UART

	sbc_NascomBasic32.zip
		int32K.asm
		bas32.asm
		TASM80.TAB

	sbc_NascomBasic.zip
		_ASSEMBLE.BAT
		TASM.EXE
		TASM80.TAB
		intmini.asm
		basic.asm
		INTMINI.HEX
		BASIC.HEX
		ROM.HEX
		
I would like a software version that would allow checking of ROM images.

At the moment it cannot run the code as it does not supprt interrupts.

So here is a simple test program to run z80 loaded from test.ihx

The software version consists of:

  ./virtual_multicomp is built using
	makefile

	virtual-multicomp.c 
	simz80.c 	- z80
	ihex.c		- used to read intel hex file
	simz80.h 
	cpu_regs.h  - z80 registers and memory.
	ihex.h

	virtual-multicomp: virtual-multicomp.o  simz80.o ihex.o  
		$(CC) $(CWARN) $(shell sdl-config --libs) $^ -o $@ -pthread



For the Z80 code this was useful:-
* http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm

http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm

To build z80 code loaded from test.ihx to run on the multicomp board

http://sdcc.sourceforge.net/

  makefile
 	crt0_mc.s
	putchar_mc.s
	test.c
	
  built using:
	sdasz80 -l -o putchar_mc.s
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
	/usr/bin/sdldz80 -u -nf test.lk
 
Run emulator using 
 	./virtual-multicomp 


SDCC verion used during testing:
pi@raspberrypi:~/Desktop/virtual_multicomp $ sdcc -v
SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
published under GNU General Public License (GPL)

This was before getchar() returned int.
