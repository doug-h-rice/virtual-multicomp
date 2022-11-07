# virtual-multicomp

This is A Z80 simulator based on Grant Searle's Z80 MultiComp board. It includes a version for 6809 as well.

This allows a hex file to be tested in a simulator, before building into the FPGA or EPROM

Doug Rice 
24/09/2019, 
29/09/2019,
25/05/2020,
07/11/2022

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

I have found out how to upload new ROM contents without a full FPGA build using QuartusSTP.

Also ported to other FPGA boards.

  	https://github.com/douggilliland/MultiComp/tree/master/MultiComp_On_Cyclone%20IV%20VGA%20Card


## BASIC

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

Also see the SDCC documentation.

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

The crt.s file sets up the stack pointer and jumps to main.

putchar_mc.s has putchar() and getchar() which use the simulated UART between the Z80 and the PC.

```
 /*
 3.5.2 Z80/Z180/eZ80 intrinsic named address spaces
 3.5.2.1 __sfr (in/out to 8-bit addresses)
 The Z80 family has separate address spaces for memory and input/output memory. I/O memory is accessed with
 special instructions, e.g.:
 */
 __sfr __at 0x78 IoPort; /* define a var in I/O space at 78h calledIoPort */

 /* UART */
 __sfr __at 0x81 uartData;   
 __sfr __at 0x80 uartStatus; 
 
 int putchar( int c ){
  while( !(uartStatus & 0x02) );
  uartData = ( char ) c;
  return c;
 }

 int getchar(){
  // wait 
  while( !( uartStatus & 0x01 ) );
  return ( int )uartData;
 }
```
This is a picture of the simplified UART 
```
/*
 * Multicomp uses 68B50 UART - emulate just enough
 * the control register is addressed on port 80H 
 * the    data register is addressed on port 81H.
 *
 */
 ```
 ```
 ==========================
 Port 	UARTS - 6402
 ==========================
  1	Data received
  2	Transmit buffer empty
  3	NC
  4	NC
  5	Frame error
  6	Parity error
  7	Overrun error
  8 	NC 
 ==========================
 ```

![ z80 uses uart to communiate with virtual-multicomp host](http://www.dougrice.plus.com/dev/asm6809/img/img30thumb.png)

## Build on Linux and Windows using Tiny C

To build virtual-multicomp on linux use make

To build virtual-multicomp.exe  on Windows PC use do_both.bat and Fabrice Bellards Tiny C

Copy the virtual-multicomp folder to the TinyC folder where tcc.exe is

`  	..\tcc virtual-multicomp.c ihex.c simz80.c   `
  	
	
Run emulator using

` 	./virtual-multicomp` 
or

` 	virtual-multicomp.exe` 

SDCC verion used during testing:
pi@raspberrypi:~/Desktop/virtual_multicomp $ sdcc -v
SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
published under GNU General Public License (GPL)

This was before getchar() returned int.

## LINUX CRLF issues - work around

3/1/2020 - BASIC.HEX - The TCC compiled version works, but the LINUX/GCC compiled version did not get past the "Memory?" prompt.  

Please download BASIC.HEX from Grants's Website. 

I uploaded BASIC.HEX as basic_gs47b.hex to my github and the code can be modified to load it.  

On LINUX, my first tries gots the BASIC.HEX to run up to the Memory? It did not get to the next prompt as it waits for 0x0D.

The Linux version maps CR LF or <cntrl>-L and <cntrl>-M to 0x0A, and it is not possible to type 0x0D. 

If you map  0x0A to 0x0D, it is possible to get past the Memory? question.

A bug that delays outputting the last pressed key, until the next key is pressed was sorted by using stderr instead of stdout.

23/05/2020 - You can paste BASIC code to upload it. CheckKey() now waits for UART Rx to empty before calling GetChar(). 

## RC2014 also uses SBC and BASIC 

I brought one of Spencer Owen's RC2014 Z80 kits. 

The ROM labelled R0000009 has the Nascom Basic and Small Computer Monitor which also runs in this program.
Select the 8K page using the links on the ROM card.

It is possible to load the SCM instead of the BASIC. SCM is really good for a Z80 assembler dabble. 
It is possible to load hex files at say 0x8400 and use the monitor to run the code.

On LINUX using Putty you can pipe the hex file up onto the RC2014. Using putty run the code.

On the Virtual Multicomp, load hex files specified on the command line, to overwrite / add to the default files.

	./virtual-multicomp BASIC.HEX
	./virtual-multicomp test.ihx
	./virtual-multicomp SCMonitor-v100-R1-RC2014-08k-ROM.hex test_RC2014_8400.hex
	
## links:
	
	TCC		
		Tiny C used to rebuild rcasm to allow for address inc feature of SC/MP
		http://bellard.org/tcc/

	RCASM
	I found an assembler that I could get to understand SC/MP machine code.
	http://www.elf-emulation.com/rcasm.html is eturning 404 so I added the rcasm
	run make and copy rcasm, rclink and z80.def to parent folder. 

	SCM
	    this super monitor came with the RC2014 and works on multicomp.				
		https://smallcomputercentral.wordpress.com/small-computer-monitor/small-computer-monitor-v1-0/

	Virtual Multi comp
		https://github.com/doug-h-rice/virtual-multicomp
	
	
## Small Computer Monitor - RC2014
	
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

When using the real RC2104 with a real UART and using Putty on Linux, it is possible to cat the hex file to upload new code.

CAT test_RC2014_8400.hex > /dev/ttyUBS0

If you use cat to upload code, you cannot use the keyboard.

cat test_RC2014_8400.hex  | ./virtual-multicomp
type test_RC2014_8400.hex | ./virtual-multicomp


You can copy and past the intel hex to upload it as well.
e.g. open test_RC2014_8400.hex in a text editor, select all, copy and paste into window.

use d8400 to disassemble and g8400 to run it.


## 6809 virtual Multicomp

A version for 6809 is included. See comments in files.

These three files builds a virtualMulticomp for 6809. Download the ROMS from the suggested sites.

    virtual.c     
    6809v.c
    6809.h

This is based on 6809.zip which has a monitor to single step the 6809 code.

Download the ROMS from the suggested sites.

I used the assembler in as.zip as used by Grant Searle to build his BASIC for 6809.

## More Makefile targets
	
These allow the virtual-multicomp to be started in BASIC, SCM monitor or various test code compiled from test.c or test.asm. 
Or you can edit the source code to include the hex file of choice.

make basic  

make monitor

make scm

make test

make test2

make rc

rcasm is an assembler also used for my sc/mp projects. I added 8060.def and a new acmcmds.c modified for sc/mp 
It was found on the elfcosmac web site.
	
## Conclusions
	
It allows some exprimenting with z80 code in C and assembler using the SDCC tools and the rcasm assembler.

