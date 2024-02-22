== Virtual 6809 ==

This provides a way to simulate code for 6809


do.bat
rem
rem
rem

rem building ssing Tiny C 
rem .\tcc-0.9.27-win64-bin\virtual-multicomp-master\virtual6809

..\..\tcc\tcc.exe virtual.c 6809v.c

pause

virtual.exe -hex ExBasROM.hex
pause

virtual.exe -s19 doug.s19
pause



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
 * 
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
