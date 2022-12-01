/*
* Program: test3.c - C program to compile to run on multicomp simulator - simple REPL
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

===============
do.bat
===============
:buildTest3
sdasz80.exe -l -o putchar_mc.s
sdasz80.exe -l -o crt0_mc.s
rem sdcc.exe -V -mz80 --code-loc 0x1000 --data-loc 0x1000 --no-std-crt0 crt0_mc.rel  test3.c
sdcc.exe -V -mz80  --no-std-crt0 crt0_mc.rel  test3.c
sdldz80.exe -u -nf test3.lk
pause  
virtual-multicomp test3.ihx
pause
===============

* 
*/

#include <stdio.h>
#include <string.h>

char buff[0x10];
int end;


  char key;
  int x;
  int address;
  int data;
  char index;


/*
3.5.2 Z80/Z180/eZ80 intrinsic named address spaces
3.5.2.1 __sfr (in/out to 8-bit addresses)
The Z80 family has separate address spaces for memory and input/output memory. I/O memory is accessed with
special instructions, e.g.:
*/

//__sfr __at 0x78 IoPort; /* define a var in I/O space at 78h calledIoPort */


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


/*
0..9 0x30..0x39
A..  0x41..
a..  0x61..
*/

short nibble( char digit ){
	int digit1 ; 
	
	digit1 = ( digit - '0' ) ;
		
	if  ( digit1 > 9 ){ 
	  // assume 0..9, A..F, a..f
	  return ( ( digit&~('A'^'a') ) - 'A' + 10 ); 
	} else { 
	  return digit1;
	}
}	

main(){
/*
  char key;
  int x;
  int address;
  int data;
  char index;
*/  
  char * mem;

  char * buffPtr; 
  //Init
  //buff[0] = '\0';
  strcpy(buff,":");
  buffPtr = buff;
  index = 0;
  x=0;	
  key =  ' ';
  address = 0;
  data = 0;

  printf("\nWelcome - press a key\n");
  while( 1==1 ){    
  
    // SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
    // Latest version changed to int getchar( void ) from char getchar( void )
	key = ( char ) getchar();
    buffPtr[index++] = key;
    buffPtr[index]   = '\0';

    index = index&0xf; 
    
	/* 
	* Simple REPL
	* There is a need for a simple command line.
	* write 
	* read
	* write
	* execute:
	* 
	* RAAAADD;
	* WAAAADD;
	* 
	*/

    printf("\rBuff:", buff  );
    puts( buff );

    if ( key == ';' ) {
	  if ( index==1  ){
	    address++;
	    mem = address;
	    printf( "read %04x %02x = %02x\n",address,data, mem[0] ) ; 
        index=0;
	  }
	  
	
      if (  index > 1 ) {
		
	    /* assume just typed cmdline */
	    //Caaaadd;
	  
	    //address = ( nibble( buff[1] )<< 12 )|( nibble( buff[2] ) << 8 )|( nibble( buff[3] ) << 4 ) |( nibble( buff[4] ) );
        address = 0;
        for( short x=1;x<5;x++){
		  address = address<<4  ;
          address += nibble( buff[x] );
        }		
	    data    = ( nibble( buff[5] )<<  4 )|( nibble( buff[6] ) );   

	    //printf( "\na: %04x, d: %02x\n",address,data );

        // read  
        if ( buff[0] == 'r' ){ 
	      mem = address;
	      printf( "read %04x %02x = %02x\n",address,data, mem[0] ) ; 
	    }
		
	    // write 
        if ( buff[0] == 'w' ){ 
	      mem = address;
	      mem[0] = data;
	    }
	    buff[0] = '\0';
        index=0;
	  }	


	}	
  }  
  return 1;
}
