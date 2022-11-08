/*
* Program: bare.c - C program to compile to run on multicomp simulator
* 
* http://searle.hostei.com/grant/z80/SimpleZ80.html
*
* usage: sdcc -mz80 --code-loc0x1000 --no-std-crt0 test_a.c
* usage: sdcc -V -mz80 --code-loc0x1000 --no-std-crt0 test_a.c
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
*/
#include <stdio.h>
main(){
  while(1){
    putchar( getchar() );
  }
}

/*
 * UART
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


