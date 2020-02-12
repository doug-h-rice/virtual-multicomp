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
		
Grant has modified 8kbasic.asm (found on Tommy Thorn's website) so that basic.asm and intmini.asm => BASIC.HEX

I would like a software version that would allow checking of ROM images.

3/1/2020 - BASIC.HEX - The TCC compiled version works, but the LINUX/GCC compiled version does not get past the "Memory?" prompt - see later.  ( BASIC.HEX waits for 0x0D, but LINUX returns 0x0A when you press ENTER. )

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
 
NOTE: --data-loc 0 needs moving but works for now. The CPU resets to 0x0000.

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

3/1/2020 - BASIC.HEX - The TCC compiled version works, but the LINUX/GCC compiled version does not get past the "Memory?" prompt.  

Please download BASIC.HEX from Grants's Website. 

I uploaded BASIC.HEX as basic_gs47b.hex to my github and the code can be modified to load it.  

Initially, it to runs up to the "Memory?" prompt, but no further.

On LINUX, the BASIC.HEX runs up to the Memory? and does not get to the next prompt as it waits for 0x0D.

The Linux version maps CR LF or <cntrl>-L and <cntrl>-M to 0x0A, and it is not possible to type 0x0D. 

If you map  0x0A to 0x0D, it is possible to get past the Memory? question, however there is a bug that delays outputting the last pressed key, until the next key is pressed.

links:
	
	TCC		
		Tiny C used to rebuild rcasm to allow for address inc feature of SC/MP
		http://bellard.org/tcc/

	RCASM
	I found an assembler that I could get to understand SC/MP machine code.
	http://www.elf-emulation.com/rcasm.html

	SCM
	    this super monitor came with the RC2014 and works on multicomp.				
		https://smallcomputercentral.wordpress.com/small-computer-monitor/small-computer-monitor-v1-0/

	Virtual Multi comp
		https://github.com/doug-h-rice/virtual-multicomp
	
	
Small Computer Monitor - RC2014
	
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

