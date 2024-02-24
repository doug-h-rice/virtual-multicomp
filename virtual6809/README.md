## 6809 code try and add multicomp UART

I wanted to learn about the 6809 and get a program to load HEX code
and run it in a command line program so test new HEX files.

The 6809 interfaces to a 68B50 ACAI or UART chip.

Use Tiny C tcc-0.9.26-win64-bin 

if you use Tiny C tcc-0.9.27-win64-bin, the source code need some work.

doug.asm is a sampler file I wrote to learn 6809 assembler.

Assemble doug.asm using as9

Build the virtual 6809 and run it and load doug.s19 


## Build as9 assember
You need to build the as9 assembler using Tiny C tcc-0.9.27-win64-bin from https://bellard.org/tcc/

Use tcc-0.9.26-win64-bin

If you use tcc-0.9.27-win64-bin , the  source code need some work.  

```
rem
rem do.bat - build as9
rem
rem do not use Tiny C tcc-0.9.27-win64-bin as the source code need some work
rem
rem Use Tiny C tcc-0.9.26-win64-bin 
rem unzip as9.zip
cd as9
pause
rem C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6809\as9
rem unzip as9.zip
..\..\..\tcc as9.c
pause

copy as9.exe ..
cd .. 
pause

rem Build doug.asm into folder
as9 doug.asm -l s19
pause

rem build the virtual 6809
..\..\tcc virtual.c 6809v.c
pause

rem run it using my assembled 689 code

virtual doug.s19
pause
```

## Build and run virtual 6809  doug.s19

NOTE: virtual running doug.asm does not detect <CNTL-C> yet.

```
rem
rem doVirtual.bat builds Virtual
rem
rem C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6809
rem
rem 

..\..\tcc virtual.c 6809v.c
pause

rem run it using my assembled 689 code

virtual doug.s19
pause
```

## Virtual 6809 

This provides a way to simulate code for 6809 in a command line program.

A do.bat file can be edited to run the tool chain```
```
 rem do.bat
 rem
 rem
 rem
 rem building using Tiny C 
 rem .\tcc-0.9.27-win64-bin\virtual-multicomp-master\virtual6809
 ..\..\tcc\tcc.exe virtual.c 6809v.c
 pause
 virtual.exe -hex ExBasROM.hex
 pause
 virtual.exe -s19 doug.s19
 pause
```

 * VirtualMultiComp for 6809
 * 
 * emulate a 6809 minimal component board.
 * 
 * See:http://www.searle.wales/ Grant's 6-chip 6809 computer
 * 
 * This has a 6809 CPU, RAM, ROM, UART and wiring.
 * 
 * This program has 
 * 	CPU, based on:- Arto Salmi's 6809.
 * 	RAM, memory
 * 	ROM, using routines to upload HEX file before CPU reset.
 *  UART, routines to use STDIN and STDOUT and look like a UART to CPU.	
 *  wiring - decodes RAM and IO addresses in WRMEM() and RDMEM()
 *
 * based on:- Arto Salmi's 6809.
 * http://atjs.mbnet.fi/mc6809/		
 * http://atjs.mbnet.fi/mc6809/6809Emulators/6809.zip
 * 
 * http://www.searle.wales/ Grant's 6-chip 6809 computer
 * In SBC  version UART @ 0xA000 and 0xA001 and uses STDIN and STDOUT
 * In FPGA version UART @ 0xFFD0 and 0xFFD1 and uses STDIN and STDOUT
 * 
 * The UART uses a thread as getchar() blocks.
 * 
 * usage: 
 * gcc virtual.c 6809v.c -pthread -o virtual
 * gcc -o virtual virtual.c 6809v.c -pthread 
 *
 * Albert van der Horst - AS9 assembler
 * http://home.hccnet.nl/a.w.m.van.der.horst/m6809.html
 * 
 * usage:
 * ./virtual doug.s19
 * 
 * stty sane
 * 
 *usage: - loading Grant's modified BASIC for 6809 ( UART @ 0xA000)
 * ./virtual ExBasROM.hex -hex
 * stty sane
 * 
 * NOTE: Download ExBasROM.hex for 6809 6 chip SBC, not FPGA version.
 * 
 * backspace or delete do not seem to work yet! UPPER CASE needed.
 * 
 * To upload BASIC code, paste the code into the terminal session.
 * 
 * CheckKey() waits until UART RX buffer is read.
 * 
 * However if you use pipes, pressing the keyboard does not work.
 *
 * cat buff.txt | ./virtual ExBasROM.hex -hex 
 * or
 *  ./virtual ExBasROM.hex -hex < buff.txt
 * 
 * as pressing the keyboard does not seem work.
 *  
 * A command line parameter with a filename to be loaded could be added
 * to the code to pipe in via the UART.
 * 
 * 

## Running BASIC example

```
pi@raspberrypiwww:~/Desktop/m68/6809_multicomp $ ./virtual ExBasROM.hex -hex
Loading code...
AS,JF, 1.2, file ExBasROM.hex     press q to quit 
6809 EXTENDED BASIC
(C) 1982 BY MICROSOFT

OK

  * 
  * LIST
  * 
10 X=0
20 PRINT "hELLO"
30 PRINT "HEOOL"
40 PRINT "Hello world"
50 X=X+1
60 IF X < 100 THEN GOTO 20
 
RUN 

OK
* 
* 
*  
10 A$=CHR$(27)
15 PRINT A$
20 PRINT "[103m"
30 PRINT "HELLO"
* 
*/
```

```
6809 sees UART at 0xFFD0 & 0xFFD1 as used in FPGA
6809 sees UART at 0xA000 & 0xA001 as used in SBC

virtual.c emulated enough of UART and used STDIN and STDOUT

build:-
gcc virtual.c 6809v.c -pthread -o virtual

run 6809 code - use q to end. 
./virtual doug.s19
stty sane

Use SBC ExBasicROM.HEX 
The hex file  FPGA has addesses 0000 to 1FFF and used at E000 to FFFF 

It does not run basic as ROMS are not locaated from 0x0000
FPGA UART is at $FFD0 & $FFD1
Grant's 6-chip 6809 computer has UART is at A000-BFFF SERIAL INTERFACE (minimally decoded)

Memory Map

0000-7FFF 32K RAM
8000-9FFF FREE SPACE (8K)
A000-BFFF SERIAL INTERFACE (minimally decoded)
C000-FFFF 16K ROM (BASIC from DB00 TO FFFF, so a large amount of free space suitable for a monitor etc)

Grant has a comment about compiling the BASIC program.
as9 exbasrom.asm -now l s19
./as9 ExBasRom.asm -now l s19 hex


./virtual ExBasRom.s19 

"-now" suppresses warnings
"l" produces a lst file
"s19" produces an s19 hex file

```

## as9 assembler

unzip as9.zip and build a new .exe

I can build it using Tiny C tcc-0.9.27-win64-bin  

It gets a lot of warnings due to headers  
The .c files do not have #includes as as9.c includes the header and all the .c files

I tried copying all the source to a single file, but this still needs work 

rem copy  as.h + table9.h + as.c + do9.c + eval.c + ffwd.c + output.c + pseudo.c + symtab.c + util.c aas.c

rem ..\..\tcc.exe  aas.c 
rem ..\..\tcc.exe  as9.c 

pause
as9.exe doug.asm
as9 doug.asm -l s19
pause


rem adjust ..\..\tcc.exe to suit where the as9 folder is relative to the tcc-0.9.27-win64-bin is.
..\..\tcc.exe  as9.c 

pause
as9.exe doug.asm
as9 doug.asm -l s19
pause

