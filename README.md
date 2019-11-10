# virtual-multicomp

This is A Z80 simulator based on Grant Searle's Z80 MultiComp board. 

This allows a hex file to be tested in an simulator, before building into the FPGA or EPROM

Doug Rice 
24/09/2019, 
29/09/2019

Tested on LINUX Raspberry Pi Strech PC version and Windows with TinyC from https://bellard.org/tcc/

Grant Searle's Multipcomp boards have been popular on the web. 

They provide a minimal component board to play with old processors.

Grant Searle has a new Website http://searle.wales/ to replace  http://searle.hostei.com/grant/

 http://searle.wales/

 https://searle.x10host.com/z80/SimpleZ80.html
 
 https://searle.x10host.com/Multicomp/index.html
 

However it would be useful to emulate the Z80 code before programming an EPROM or adding to the FPGA build.

They provide a minimal component board to play with old processors.

The Z80 board has a:

	PCB - providing wiring
	CPU - running z80 code
	RAM - 
	ROM - programmed with code to boot z80 and demo board. e.g. Basic
	UART - serial interface

There is a VHDL version which loads a hex file containing Z80 code.

Also ported to other FPGA boards.

  	https://github.com/douggilliland/MultiComp/tree/master/MultiComp_On_Cyclone%20IV%20VGA%20Card


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

At the moment it cannot run the code as the Z80 it does not support interrupts.


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

On a PC with Tiny C from https://bellard.org/tcc/
  	
  	do_both.bat


For the Z80 code this was useful to explain the .s and .c files:-

http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm

To build z80 code loaded from test.ihx to run on the multicomp board I installed SDCC from 

http://sdcc.sourceforge.net/

Files:

    do_both.bat	- for PC
    makefile 	- for linux
    crt0_mc.s
    putchar_mc.s  
    test.c
  
built z80 code using:
  
	sdasz80 -l -o putchar_mc.s
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
	/usr/bin/sdldz80 -u -nf test.lk
or


  	sdasz80.exe -l -o putchar_mc.s
  	sdasz80.exe -l -o crt0_mc.s
  	sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
  	sdldz80.exe -u -nf test.lk
 


To build virtual-multicomp on linux use make

To build virtual-multicomp.exe  on Windows PC use do_both.bat and Fabrice Bellards Tiny C

  	..\tcc virtual-multicomp.c ihex.c simz80.c   
  	
	
Run emulator using

 	./virtual-multicomp 
or

  	virtual-multicomp.exe 



SDCC verion used during testing:
pi@raspberrypi:~/Desktop/virtual_multicomp $ sdcc -v
SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
published under GNU General Public License (GPL)

This was before getchar() returned int.


