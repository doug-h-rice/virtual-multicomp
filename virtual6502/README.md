# virtual-multicomp 6502

I did not have a computer with a 6502.

An Arduino based 6502 running enhanced Basic was on the forum.

* Ported from zip file found on by miker001z for Arduino 
* https://forum.arduino.cc/t/arduino-6502-emulator-basic-interpreter/188328 

So this has a port for the Arduino 6502 and a 6502 that loads ROM.HEX from Grant's SBC project.

* cpu6502arduino.c - ported from Arduino sketch runs Enhanced BASIC
* cpu6502rom.c - Loads ROM.HEX that expects a 68B50 ASCI/ UART at $A000 & $A001

For information on Enhanced BASIC see:-
* http://retro.hansotten.nl/6502-sbc/lee-davison-web-site/enhanced-6502-basic/
* https://github.com/Klaus2m5/6502_EhBASIC_V2.22 - Enhanced basic.

Most of the fun here is getting code for different microprocessor to build and run using various tools and tool chains.

## Grant Searl's SBC 

See: http://searle.wales/

He provides designs for a Small Board computer, SBC, for Z80, 6809, 6505, that runs BASIC. He also has a version for an FPGA board.

The 6502 version has tools to build the ROM.HEX file and osi_bas.lst

This allows a hex file to be tested in a simulator, before building into the FPGA or EPROM

Doug Rice 
02/03/2024

However it would be useful to build and emulate the 6502 code before programming an EPROM or adding to the FPGA build.

The 6502 board has a:

	PCB - providing wiring and glue logic for address decode.
	CPU - running 6502 code 
	RAM - 
	ROM - programmed with code to boot 6502 and demo board. e.g. BASIC & serialPort
	UART - serial interface 68B50

It is possible to use the BASIC, but why not try assembler and C code. 

## SDCC compiler and assembler

The SDCC compiler can Compile C code to 6502 and many other processors. It can also be used as the assembler.

I would like a software version that would allow checking of ROM images from the SDCC compiler.

```
#include <stdio.h>
void main( void ){
  puts("bare.c does:-  while (1){ putchar( getchar() ); } \n");
  while(1){
    putchar( getchar() );
  }
}
``` 

The putchar( getchar() ); code is different between the Arduino and UART based boards.
* The arduino.ino code uses the Serial object.
* The UART based code simulates the 68B50 ASCI/UART chip

Arduino Leonardo has USB and hardware serial.

The ATmega16U4/ATmega32U4 used in the Arduino Leonardo has a UART based Serial and USB based Serial. 
It is worth looking at the arduino code, which I found at:

C:\Users\Redtop\AppData\Local\Arduino15\packages\arduino\hardware\avr\1.8.5\cores\arduino

This README.md was copied from the Z80, but useful for 6502 and 6809
 
So here is a simple test program to run z80 loaded from test.ihx

The software version consists of:

On a PC with Tiny C from https://bellard.org/tcc/
  	
  	do6502.bat

For the Z80 code this was useful to explain the .s and .c files:-

http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm

Also see the SDCC documentation.

To build z80 code loaded from test.ihx to run on the multicomp board I installed SDCC from 

http://sdcc.sourceforge.net/

```
 /* UART */

// for 6502 using 68B50
char  __at 0xA001 uartData;   
char  __at 0xA000 uartStatus; 

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

## UARTS

The Nascom2 used the 6402 UART, the Multicomp uses the 68B05 uart.

/*
 * Multicomp uses 68B50 UART - emulate just enough
 * the control register is addressed on port 80H 
 * the    data register is addressed on port 81H.
 *
 */
 ```
 ```
 ==========================
 bit 	UARTS - 6402 also 68B50 similar. 
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

For the 6502 This is an ongoing  to be done project.


To build virtual-multicomp on linux use make

To build virtual-multicomp.exe  on Windows PC use do_both.bat and Fabrice Bellards Tiny C

Copy the virtual-multicomp folder to the TinyC folder where tcc.exe is

`  	..\tcc virtual-multicomp.c ihex.c simz80.c   `
  		
Run emulator using

` 	./virtual-multicomp` 
or

` 	virtual-multicomp.exe` 


## LINUX CRLF issues - work around

3/1/2020 - BASIC.HEX - The TCC compiled version works, but the LINUX/GCC compiled version did not get past the "Memory?" prompt.  

Please download BASIC.HEX from Grants's Website. 

I uploaded BASIC.HEX as basic_gs47b.hex to my github and the code can be modified to load it.  

On LINUX, my first tries gots the BASIC.HEX to run up to the Memory? It did not get to the next prompt as it waits for 0x0D.

The Linux version maps CR LF or <cntrl>-L and <cntrl>-M to 0x0A, and it is not possible to type 0x0D. 

If you map  0x0A to 0x0D, it is possible to get past the Memory? question.

A bug that delays outputting the last pressed key, until the next key is pressed was sorted by using stderr instead of stdout.

23/05/2020 - You can paste BASIC code to upload it. CheckKey() now waits for UART Rx to empty before calling GetChar(). 


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
	
	Also see the SDCC documentation.
		http://sdcc.sourceforge.net/
	
## bare.c

For the 6502, Support for the  68B50 uart putchar() and getchar(); was added. 

```
rem 
sdcc -help
rem sdcc -mmos6502 --code-loc0x1000 --no-std-crt0 bare.c
sdcc -mmos6502 --code-loc0x200 -v bare.c
pause
```

bare.c was supposed to be the minimum code which. 

bare.c does:-  while (1){ putchar( getchar() ); } 

It has UART code examples.

bare.c is built for Z80, linux, and AT89C5131 , 8051 or 6502

cpu6502rom.c may need to load bare.ihx

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
	
## Conclusions
	
It allows some exprimenting with z80 code in C and assembler using the SDCC tools and the rcasm assembler.

![waves ](http://www.dougrice.plus.com/images/imgWiki_AT049.jpg)
