/*   Virtual Multicomp.
 * 
 *   inspired by http://searle.hostei.com/grant/#MyZ80 
  Grant Searle has a new Website http://searle.wales/ to replace http://searle.hostei.com/grant/

  http://searle.wales/

  https://searle.x10host.com/z80/SimpleZ80.html

  https://searle.x10host.com/Multicomp/index.html

     Copyright (C) 

     Z80 emulator portition Copyright (C) 1995,1998 Frank D. Cringle.

     ???? is free software; you can redistribute it and/or modify it
     under the terms of the GNU General Public License as published by
     the Free Software Foundation; either version 2 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
     General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
     02111-1307, USA.

   

   Inspired by http://searle.hostei.com/grant/#MyZ80
    
   A Multicomp consists of:

    - a Z80 CPU,
    - an UART,
    
    - memory:
        0000 - 07ff  8 KB ROM monitor,
        0800 - 0bff  1 KB screen memory,

	- IO 
	*   0x80, 0x81 68B50 UART
	
 * Multicomp uses 68B50 UART - emulate just enough.
 * the control register is addressed on port 80H 
 * the    data register is addressed on port 81H.
 *
   
*/



/********************************************
* Sec 1.0 Includes and #defines for TCC and or linux
********************************************/

#ifdef __TINYC__
#define tcc 1
#endif


#ifdef linux
// gets rid of annoying "deprecated conversion from string constant blah blah" warning
#pragma GCC diagnostic ignored "-Wwrite-strings"
#pragma GCC diagnostic pop

// gets rid of annoying "deprecated conversion from string constant blah blah" warning
#pragma GCC diagnostic ignored "-Wwrite-strings"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <fcntl.h>

#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <termios.h>
#include <errno.h>
#include <time.h>
#include <pthread.h>

#define DELAY  ;
#define DELAYL usleep( 500000 );


/* sleep() in tcc is in milliseconds, in linux sleep is seconds */
#define sleep dhr_sleep

int dhr_sleep( int milliseconds ){
       usleep( milliseconds*1000 );
       return 0; 
}
#endif



/*
*
* TCC 
* 
*/
#ifdef tcc
#include <conio.h>
#include <stdio.h>
#include <windows.h>
#include <time.h>

#define RS232_STRLEN_DEVICE 11
#define DELAY 	;

#define DELAYM delay_ms( 1 );
#define DELAYL delay_ms( 100 );

// delay_routines
void delay_ms(clock_t millis);

HANDLE hCom;           //handle for serial port I/O

void delay_ms(clock_t millis)
{
   //  This uses a lot of cpu time to run. find out hoe to use system timer.
   clock_t endtime;
   endtime = millis + clock();
   while( endtime > clock() )         ;
}
#endif


#include "simz80.h"
#include "cpu_regs.h"
#include "ihex.h"

#define SLOW_DELAY  25000
#define FAST_DELAY 900000

static int t_sim_delay = FAST_DELAY;

/*
 * emulate enough of the Motorola 68B50 UART 
 */
 
static int uartStatus;
static int uartControl;
static int uartRx;
static int uartTx;
static int uartTxCount;

// for z80
typedef enum { CONT = 0, RESET = 1, DONE = -1 } sim_action_t;
static sim_action_t action = CONT;

/********************************************
* Sec 3.0 Protoypes - linux
********************************************/
/* prototypes */
#ifdef linux
void initThread ( pthread_t threadP , void * message1 );
#endif
int repeat;


/********************************************
* Sec 5.0 Threads 
********************************************/

#ifdef	__MSVCRT__
#endif

int repeat;



// CheckKey - Thread to wait for a keystroke, then clear repeat flag.
// 

#ifdef comment
void * CheckKey( void * ignored )
{
   while ( 1 != 0 ){
     //repeat++;    // _endthread implied
     /* block waiting for a key */
     //printf("=======================================");
     
     uartRx = getchar() & 0xff;
	 uartStatus |= 0x81; // Set RX avail and INT
	 //printf("k: %x %x ", uartStatus, uartRx );
   }
}
#endif


#ifdef tcc
void CheckKey( void * ignored )
{
   int fd;
   while ( 1 != 0 ){
     uartRx = _getch() & 0xff;
	 uartStatus |= 0x81; // Set RX avail and INT
//	 uartStatus |= 0x81; // Set RX avail and INT
	 // this makes it work. not sure why;
	 //printf("k: %x %x \n", uartStatus, uartRx );
   }
}
#endif

#ifdef linux
void * CheckKey( void * ignored )
{
   while ( 1 != 0 ){
     uartRx = getchar() & 0xff;
	 uartStatus |= 0x81; // Set RX avail and INT
	 // this makes it work. not sure why;
	 // printf("");
	 // printf("k: %x %x \n", uartStatus, uartRx );
   }
}
#endif



#ifdef linux
void initThread ( pthread_t threadP ,  void *  message1  ) {
    int  iret1;
    static struct termios oldt, newt;

    /*tcgetattr gets the parameters of the current terminal
    STDIN_FILENO will tell tcgetattr that it should write the settings
    of stdin to oldt*/
    tcgetattr( STDIN_FILENO, &oldt);

    /*now the settings will be copied*/
    newt = oldt;

    /*ICANON normally takes care that one line at a time will be processed
    that means it will return if it sees a "\n" or an EOF or an EOL*/
    //newt.c_lflag &= ~(ICANON);          

    newt.c_lflag &= ~(ICANON | ECHO);

    /*Those new settings will be set to STDIN
    TCSANOW tells tcsetattr to change attributes immediately. */
    tcsetattr( STDIN_FILENO, TCSANOW, &newt);

    /* Create independent threads each of which will execute function */
    iret1 = pthread_create( &threadP, NULL, CheckKey,   message1 );

    /* Wait till threads are complete before main continues. Unless we  */
    /* wait we run the risk of executing an exit which will terminate   */
    /* the process and all threads before the threads have completed.   */

//     pthread_join( thread1, NULL);
//     pthread_join( thread2, NULL);   
}
// options.c_lflag |= (ICANON | ECHO | ECHOE);
#endif


int sim_delay(void)
{ 
    return action;
}


int main(int argc, char **argv)
{
    int c;
	
	
#ifdef	__MSVCRT__
//if windows start some threads.
//https://msdn.microsoft.com/en-us/library/kdzttdcb.aspx
/*
unsigned long	_beginthreadex	(void *, unsigned, unsigned (__stdcall *) (void *), void*, unsigned, unsigned*);
void	_endthreadex	(unsigned);
*/
	printf("	__MSVCRT__");
    // Launch CheckKey thread to check for terminating keystrok
    _beginthread( CheckKey, 0, NULL );
#endif

#ifdef linux
    pthread_t thread1;
    initThread ( thread1, ( void *) NULL ); 
#endif


    //progname = argv[0];
    printf("Loading Z80 code...\n");
//    load_ihex("BASIC.HEX", ram);
//    load_ihex("ROM.HEX", ram);
    load_ihex("test.ihx", ram);

    for( c = 0; c < 0x0D80; c++ ){
      if ( (c % 24 ) == 0 ) {
		  printf("\n :%04X: ",c);
	  }
      if ( (c % 8) == 0 ) {
		  printf(" ");
	  }

      printf("%02X ",ram[c]);
	}
	uartStatus = 0x02;
    ram[0x10000] = ram[0]; // Make GetWord[0xFFFF) work correctly
    simz80(pc, t_sim_delay, sim_delay);
    exit(0);
}

/*
 * 1.7 Input/output port addressing
 *
 *     Output Bit
 */

/*
 * Multicomp uses 68B50 UART - emulate just enough
 * the control register is addressed on port 80H 
 * the    data register is addressed on port 81H.
 *
 */

void out(unsigned int port, unsigned char value)
{
    switch (port) {

    case 0x80: //status
    case 0x90: //status
    case 0xA0: //status
    case 0xB0: //status
    //    putchar(value);
        fprintf(stdout, "\nO_%x ",  value);        
        uartControl = value ;
        uartStatus  = 0x02;
        break;

    case 0x81: // data
    case 0x91: // data
    case 0xA1: // data
    case 0xB1: // data
        // putchar(value);
        // uartStatus &= ~0x82;
        uartTx = value & 0xff;
        
        // put byte into TxReg or print it out
        //fprintf(stdout, "%c",  uartTx );
        printf( "%c",  uartTx );

        // put byte in Transmit data register.
        // Transmit data empty bit is set to 0 for a few polls and then set to 1.

        uartTxCount = 60;
        uartStatus |= 0x00 ; // don't set intr
        uartStatus &= ~ 2 ;  // clear TxEmpty Flag;
        
        // put byte into TxReg or print it out
        // fprintf(stdout, "%c %02x, \n",  uartTx, uartStatus );
        
        // put byte in Transmit data register.
        // Transmit data empty bit is set to 0 for a few polls and then set to 1.
                
        break;

    default:
        if (verbose)
            fprintf(stdout, "OUT [%02x] <- %02x\n", port, value);
    }
}

int in(unsigned int port)
{
    switch ( port) {

      case 0x80:
      case 0x90:
      case 0xA0:
      case 0xB0:
        /* Status port on the UART */
        if ( uartTxCount > 0 ){
			uartTxCount += -1 ;			
		}; 
		
        if ( uartTxCount == 1 ){
			uartStatus  |=  0x82 ; //set tx as empty
		}; 
        return uartStatus ;

      case 0x81: // data
      case 0x91: // data
      case 0xA1: // data
      case 0xB1: // data
      // reset status and clear interrupt    
      // fprintf(stdout, "%c",  uartRx );
      uartStatus &= ~0x81;

	  
      return uartRx & 0xff ;         

      default:
        if (verbose)
            fprintf(stdout, "IN <- [%02x]\n", port);
        return 0;
    }
}
