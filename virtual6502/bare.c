/*
* Program: bare.c - C program to compile to run on multicomp simulator
* 
* http://searle.hostei.com/grant/z80/SimpleZ80.html
*
* usage: sdcc -mz80 --code-loc0x1000 --no-std-crt0 bare.c
* usage: sdcc -V -mz80 --code-loc0x1000 --no-std-crt0 bare.c
* 
* to get the .rst with hex and assembler
* sdldz80 -u -nf test_a.lk
* 
* http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm
* sdasz80 -l -o putchar_cpc.s
* sdasz80 -l -o crt0_cpc.s
* sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_cpc.rel putchar_cpc.rel test.c
* #	sdcc -V -mz80 --no-std-crt0 crt0_cpc.rel putchar_cpc.rel test.c
* /usr/bin/sdldz80 -u -nf test.lk
* #	./virtual-multicomp 
* 
* or comment out UART code and build using gcc
* gcc -o bare bare.c
* 
* Makefile
* 
* 
bare0:
	# build a z80 version - UART in putchar_mc.S
	sdasz80 -l -o crt0_mc.s
	sdasz80 -l -o putchar_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel putchar_mc.rel bare.c   
	/usr/bin/sdldz80 -u -nf bare.lk
	./virtual-multicomp bare.ihx

bare1:
    # build a z80 version - UART in bare.c
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel -DwantUART bare.c   
	/usr/bin/sdldz80 -u -nf bare.lk
	./virtual-multicomp bare.ihx

bare2:
	# build linux version - 
	gcc -o bare bare.c
	./bare
	

bare3:

	rem 
	sdcc -help
	rem sdcc -mmos6502 --code-loc0x1000 --no-std-crt0 bare.c
	sdas6500 -plosgffw   crt0.lst  crt0.s 
	pause
	sdcc -V -mmos6502   --model-large bare.c
	pause
	sdld6808 -nfiu bare.lk
	pause
	..\..\tcc.exe    cpu6502rom.c ihex.c
	pause
	cpu6502rom
	pause
	exit
	

* 
* 
* 
*/

#define wantUART_6502

#ifdef wantUART_6502
/*
 * UART - 
 * 
 */
char  __at 0xA001 uartData;   
char  __at 0xA000 uartStatus; 

/*
Writing 0x01 to this variable generates the assembly code:
3E 01 ld a,#0x01
D3 78 out (_IoPort),a
*/



int putchar( int c ){
  while( !(uartStatus & 0x02) );
  uartData = ( char ) c;
  return c;
}

int getchar( void ){
  // wait 
  while( !( uartStatus & 0x01 ) );
  return ( int )uartData;
}

#endif



#define _wantUART

#include <stdio.h>
void main( void ){
  puts("bare.c does:-  while (1){ putchar( getchar() ); } \n");
  while(1){
    putchar( getchar() );
  }
}



#ifdef wantUART
/*
 * UART - 
 * 
 */
__sfr __at 0x81 uartData;   
__sfr __at 0x80 uartStatus; 

/*
Writing 0x01 to this variable generates the assembly code:
3E 01 ld a,#0x01
D3 78 out (_IoPort),a
*/



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

#endif

#ifdef wantUART_8051
#include <AT89C513xA.h>
#include <stdio.h>

// http://www.dougrice.plus.com/dev/AT89C5131/doug_at.c
/*
getchar(), putchar() 

As usual on embedded systems you have to provide your own getchar() and
putchar() routines. 

SDCC does not know whether the system connects to a serial line with or without
handshake, LCD, keyboard or other device. 

And whether a lf to crlf conversion within putchar() is intended. 

You’ll find examples for serial routines f.e. in sdcc/device/lib. 

For the mcs51 this minimalistic polling putchar() routine might be a start:
*/

/*
putchar is called by printf();
*/
/*
void putchar( char  c)
{
	while(!(SCON & 0x02));
	SCON &= ~0x02;
	SBUF = c & 0xff;
	//return (c);
}
*/

int putchar (int c) {
  while (!TI) /* assumes UART is initialized */
  ;
  TI = 0;
  SBUF = c;
  return c;
}

int getchar(){
  // wait for character
  while( !RI );
  RI =0;
  return ( int )SBUF;
}

// see http://www.dougrice.plus.com/dev/AT89C5131/doug_at.c

#endif
