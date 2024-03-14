# virtual-multicomp

This is A Z80 simulator based on Grant Searle's Z80 MultiComp board. It includes a version for 6809 as well. There is a 6502 version.

Most of the fun here is getting code for different microprocessor to build and run using various tools and tool chains.

He provides designs for a Small Board computer, SBC, for Z80, 6809, 6505, that runs BASIC. He also has a version for an FPGA board.

See:

http://searle.wales/ 

http://searle.x10host.com/z80/SimpleZ80.html

![grant's circuit](http://searle.x10host.com/z80/Z80SbcSchematic1.3.gif)

virtual_multicomp allows a hex file to be tested in a simulator, before building into the FPGA or EPROM

Doug Rice 
24/09/2019, 
29/09/2019,
25/05/2020,
07/11/2022,
22/12/2024
24/02/2024

It has been tested on LINUX Raspberry Pi Strech PC version and Windows with TinyC from https://bellard.org/tcc/

Grant Searle's Multipcomp boards have been popular on the web. 

They provide a minimal component board to play with old processors.

Grant Searle has a new Website http://searle.wales/ to replace  http://searle.hostei.com/grant/

 http://searle.wales/

 https://searle.x10host.com/z80/SimpleZ80.html
 
 https://searle.x10host.com/Multicomp/index.html
 
However it would be useful to build and emulate the Z80 code before programming an EPROM or adding to the FPGA build.

The Z80 board has a:
```
 PCB - providing wiring and glue logic for address decode.
 CPU - running z80 code 
 RAM - 
 ROM - programmed with code to boot z80 and demo board. e.g. BASIC & serialPort
 UART - serial interface
```

There is a VHDL version which loads a hex file containing Z80 code or  6809 code or 6502 code. 

I have found out how to upload new ROM contents without a full FPGA build using QuartusSTP.

see: 
http://ccgi.dougrice.plus.com/cgi-bin/wiki.pl?My_Notes_On_6809

It has been ported to other FPGA boards.

* https://github.com/douggilliland
* https://github.com/douggilliland/MultiComp/tree/master/MultiComp_On_Cyclone%20IV%20VGA%20Card
* https://github.com/douggilliland/MultiComp

* https://land-boards.com/blwiki/index.php?title=Main_Page

My notes: http://www.dougrice.plus.com/dev/asm6809/

## BASIC 

Grants boards run BASIC

See: https://github.com/feilipu/NASCOM_BASIC_4.7

See http://searle.x10host.com/cpm/index.html#ROMFiles

The hex file contains BASIC and CRT0 and code for the UART.

From [http://searle.x10host.com/z80/SimpleZ80_32K.html](http://searle.x10host.com/z80/SimpleZ80.html)
```
 sbc_NascomBasic32.zip
 int32K.asm
 bas32.asm
 TASM80.TAB
```

from http://searle.x10host.com/z80/SimpleZ80_32K.html
```
sbc_NascomBasic.zip
 _ASSEMBLE.BAT
 TASM.EXE
 TASM80.TAB
 intmini.asm
 basic.asm
 INTMINI.HEX
 BASIC.HEX
 ROM.HEX
```
		
Grant has modified 8kbasic.asm (found on Tommy Thorn's website) so that basic.asm and intmini.asm => BASIC.HEX

It is possible to use the BASIC, but why not try assembler and C code. 

## SDCC compiler and assembler

The SDCC compiler can Compile C code to Z80 and many other processors. It can also be used as the assembler.

I would like a software version that would allow checking of ROM images from the SDCC compiler.

So here is a simple test program to run z80 loaded from test.ihx

The software version consists of:

./virtual_multicomp is built using
  
```
	makefile
	virtual-multicomp.c 
	simz80.c 	- z80
	ihex.c		- used to read intel hex file
	simz80.h 
	cpu_regs.h  - z80 registers and memory.
	ihex.h

	virtual-multicomp: virtual-multicomp.o  simz80.o ihex.o  
		$(CC) $(CWARN) $(shell sdl-config --libs) $^ -o $@ -pthread
```

## On a PC with Tiny C from https://bellard.org/tcc/ and SDCC

You need these tools.

* download virtual-multicomp-master.zip for the github and extract all
* download and unzip tcc-0.9.26-win64-bin from https://bellard.org/tcc/
* Install SDCC https://sdcc.sourceforge.net/

## Using Tiny C to compile virtual-multicomp-master 

copy / move the folder virtual-multicomp-master with the files in into the tcc-0.9.26-win64-bin\tcc folder

In  C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master run:
```
  do_both.bat
```

## Using Tiny C to compile virtual6809

In C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6809 run:
```
  doBuildAS9.bat
```

## For the Z80 code this was useful to explain the .s and .c files:-

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

  ```
	sdasz80 -l -o putchar_mc.s
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
	/usr/bin/sdldz80 -u -nf test.lk
```
or
```
  	sdasz80.exe -l -o putchar_mc.s
  	sdasz80.exe -l -o crt0_mc.s
  	sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
  	sdldz80.exe -u -nf test.lk
```
 
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

## UARTS

The Nascom2 used the 6402 UART 

```

==========================
 bit 	UARTS - 6402
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

The Multicomp uses the 68B05 uart.

/*
 * Multicomp uses 68B50 UART - emulate just enough
 * the control register is addressed on port 80H 
 * the    data register is addressed on port 81H.
 *
 */



![ z80 uses uart to communiate with virtual-multicomp host](http://www.dougrice.plus.com/dev/asm6809/img/img30thumb.png)

## Build on Linux and Windows using Tiny C

To build virtual-multicomp on linux use make

To build virtual-multicomp.exe  on Windows PC use do_both.bat and Fabrice Bellards Tiny C

Copy the virtual-multicomp folder to the TinyC folder where tcc.exe is

  	..\tcc virtual-multicomp.c ihex.c simz80.c   `
  	
	
Run emulator using

 	./virtual-multicomp` 
or

 	virtual-multicomp.exe` 

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



![RC2014 backplane ](http://www.dougrice.plus.com/dev/asm6809/img/imgs_11_rc2014_z80.jpg)
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
	http://www.elf-emulation.com/rcasm.html is returning 404 so I added the rcasm. z80.def needs checking.
	see: https://github.com/doug-h-rice/RcAsm - forked to add SC/MP 8060.def and update z80.def file.
	run make and copy rcasm, rclink and z80.def to parent folder. 

	SCM
	    this super monitor came with the RC2014 and works on multicomp.				
		https://smallcomputercentral.wordpress.com/small-computer-monitor/small-computer-monitor-v1-0/

	Virtual Multi comp
		https://github.com/doug-h-rice/virtual-multicomp
	
	SDCC  documentation.
		http://sdcc.sourceforge.net/
	
	

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

A version for 6809 is included in the folder 6809. See comments in files.

These three files builds a virtualMulticomp for 6809. Download the ROMS from the suggested sites.

    virtual.c     
    6809v.c
    6809.h

This is based on 6809.zip which has a monitor to single step the 6809 code.

Download the ROMS from the suggested sites.

I used the assembler in as.zip as used by Grant Searle to build his BASIC for 6809.

## 6502 virtual Multicomp

I never owned a 6502 so this is to be done. The FPGA version has a 6502

See http://www.dougrice.plus.com/dev/6502/ for a port from an Arduino forum post

Run 6502 code in a C program.

http://www.dougrice.plus.com/dev/6502/cpu6502.c

Emulator for 6502 CPU running BASIC

Ported by Doug Rice 18/02/2024

Ported from emulator found on Arduino Forum. Modified to run in command box

https://forum.arduino.cc/t/arduino-6502-emulator-basic-interpreter/188328

Using Basic found at:- http://retro.hansotten.nl/6502-sbc/lee-davison-web-site/enhanced-6502-basic/

It does not seem to be using Grant Searle's port of BASIC

Modified to run in command box and compiled by Tiny C on Windows 10.

usage:
 rem
 ..\tcc.exe    cpu6502.c
 pause
usage:

 cpu6502.exe
 exit

## More Makefile targets
	
These allow the virtual-multicomp to be started in BASIC, SCM monitor or various test code compiled from test.c or test.asm. 
Or you can edit the source code to include the hex file of choice.

make basic  

make monitor

make scm

make test

make test2

make rc

## min.asm

min.asm is a minimal assembler program that is assembled using RCASM. I hand coded min.nas which can be loaded.  


make min

## bare.c

bare.c was supposed to be the minimum code which. 

bare.c does:-  while (1){ putchar( getchar() ); } 

It has UART code examples.

bare.c is built for Z80, linux, and AT89C5131 or 8051 

make bare0

make bare1

make bare2

make bare3

* bare0 z80 UART in .s file
* bare1 z80 UART in bare.c file
* bare2 gcc version - no UART
* bare3 AT89C5131 dable - needs more work.

rcasm is an assembler also used for my sc/mp projects. I added 8060.def and a new asmcmds.c modified for sc/mp 
It was found on the elfcosmac web site. see: https://www.elf-emulation.com/rcasm.html	

The site had gone so I added the source code to my git hub The Z80.def file had a bug for  jp label.
see: https://www.elf-emulation.com/rcasm.html	

## Windows Defender was reporting it as a Trojan Win32/Wacatac.B!ml

*  Warning:- Windows Defender was reporting it as a Trojan Win32/Wacatac.B!ml
*  Not sure why.

I had cases where I had two folders with what I though was the same source code. 

When I built the code I got a warning, in one folder while the other folder did not.
  
When developing the 6502 I got a warning. Making the RAM memory bigger stopped this
When developing the z80  I got a warning. Making the RAM memory bigger stopped this

    ram[0x10000] = ram[0]; // Make GetWord[0xFFFF) work correctly
   
    extern BYTE ram[MEMSIZE*1024+2];  // The +1 location is for the wraparound GetWord

Also ihex.c seemed to trigger warnings. Adding 0xFFFF to limit address to 64K also stopped warnings.

commenting out the code below stopped a trigger.

```
/*
    for (unsigned char * p = (ram + start) ; start < end; p += 8, start += 8)
        fprintf(f, "%04X %02X %02X %02X %02X %02X %02X %02X %02X %02X%c%c\r\n",
                start, *p, p[1], p[2], p[3], p[4], p[5], p[6], p[7], 0, 8, 8);
*/

```

```
 memory[ hex_addr & 0xFFFF ] = hex_data ;
```
This tight loop seemed to trigger a Trojan Alert.
```
void delay_ms(clock_t millis)
{
   //  This uses a lot of cpu time to run. find out hoe to use system timer.
   clock_t endtime;
   endtime = millis + clock();
   //while( endtime > clock() )  ; 
   while( endtime > clock() ) sleep( 10 ) ;
}
```

Also added unsigned in front  of int variabled, seems to stop triggers. 


Microprocessors like the Z80 were clocked at 4MHz. A tight loop was okay as a timing loop.

Modern CPU are clocked a lot faster.

The Raspberry PICO has the PIO that can be clocked much slower than the system clock

Microchip PIC have sleep that can be interupted so they do not spin

Microcontrollers have timers that can interupt to allow a slow clocked process to be ticked.

## Conclusions
	
It allows some exprimenting with z80 code in C and assembler using the SDCC tools and the rcasm assembler.

![waves ](http://www.dougrice.plus.com/images/imgWiki_AT049.jpg)
