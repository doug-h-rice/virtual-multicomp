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
#include <string.h>

char buff[10];
int buff2[10];
int buff3[10];
int end;


/*
3.5.2 Z80/Z180/eZ80 intrinsic named address spaces
3.5.2.1 __sfr (in/out to 8-bit addresses)
The Z80 family has separate address spaces for memory and input/output memory. I/O memory is accessed with
special instructions, e.g.:
*/

__sfr __at 0x78 IoPort; /* define a var in I/O space at 78h calledIoPort */


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



void main( void ){
  char key;
  int x;

  //char buffer[10];
  char * buffPtr; 
  //Init
  buff[0] = '\0';
  strcpy(buff,":");
  buffPtr = buff;
  x=0;	
  key =  ' ';
  printf("buff:  %p \n", buff   );
  printf("buff2: %p \n", buff2   );
  printf("buff3: %p \n", buff3   );
  printf("end:   %p \n", &end   );
  printf("x:    %p \n", &x   );
  printf("key:  %p \n", &key   );

  while( 1==1){  
  
    printf("\nWelcome - press a key\n");
   
    //main loop 
    //while( x < 10 ) {
    // SDCC : mcs51/z80/z180/r2k/r3ka/gbz80/tlcs90/ds390/TININative/ds400/hc08/s08/stm8 3.5.0 #9253 (Mar 19 2016) (Linux)
    // Latest version changed to int getchar( void ) from char getchar( void )
	  key = ( char ) getchar();
    //gets(buff);
        
    buffPtr[0] = key;
    buffPtr++;
    buffPtr[0] = '\0';
    
    if ( key == ' ' ){
      printf("Buff:%s:  %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello ") );
      printf("Buff:%s:  %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello ") );
      if ( strcmp(buff,"help ") == 0 ) { printf("\x1b[43m ..help.. ++++\x1b[m\n\r",0x1b ); };
      if ( strcmp(buff,"stop ") == 0 ) { printf("\x1b[41m ..stop.. ++++\x1b[m\n\r",0x1b ); };
      if ( strcmp(buff,"go "  ) == 0 ) { printf("\x1b[42m ..Run... ++++\x1b[m\n\r",0x1b ); };

      buffPtr    = buff;
      buffPtr[0] = '\0';
      
    } else {
    
	  // The code below has a problem with the stack.	
    printf("Hello World - SDCC compiled this! %04X :%02X:%c: \n\r", x, (int) key, (char) key );

    printf("Buff:%s:  %d %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello "), sizeof( buff )  );

    printf("%c[m\n\r",0x1b );


    printf("%c[31m ..Red...............................: \n\r",0x1b );
    printf("%c[32m ..Green.............................: \n\r",0x1b );
    printf("%c[33m ..Yellow............................: \n\r",0x1b );
    printf("%c[34m ..Blue..............................: \n\r",0x1b );
    printf("%c[35m ..Magenta...........................: \n\r",0x1b );
    printf("%c[36m ..Cyan..............................: \n\r",0x1b );
    printf("%c[37m ..White.............................: \n\r",0x1b );


    printf("%c[41m ..Red...............................: \r\n",0x1b );
    printf("%c[42m ..Green.............................: \r\n",0x1b );
    printf("%c[43m ..Yellow............................: \r\n",0x1b );
    printf("%c[44m ..Blue..............................: \r\n",0x1b );
    printf("%c[45m ..Magenta...........................: \r\n",0x1b );
    printf("%c[46m ..Cyan..............................: \r\n",0x1b );
    printf("%c[47m ..White.............................: \r\n",0x1b );
    printf("%c[40m ..Black.............................: \r\n",0x1b );
    printf("%c[30m  ..Black.............................: \n\r",0x1b );
    printf("%c[m ..Black.............................: \n\r",0x1b );

    x++;   
    }
  }  
  // return 1;
}
