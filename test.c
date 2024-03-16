/*
* Program: test.c - C program to compile to run on multicomp simulator
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


void main( void ){
  char key;
  int x;


  //Init
  x=0;	
  key =  ' ';
  printf("\nWelcome - press a key\n");

  //main loop 
  while( x < 10 ) {
    // SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
    // Latest version changed to int getchar( void ) from char getchar( void )
	key = getchar();  
	// The code below has a problem with the stack.	
    printf("Hello World - SDCC compiled this! %04X :%02X:%c: \n\r", x, key, key );
    x++;   
  }  
  // post main loop
  printf("\nExit from main loop\n");
  
  //while( 1  ); 
}
