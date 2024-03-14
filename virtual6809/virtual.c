/*
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

//stty sane
struct termios oldt;
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

#endif

#include "6809.h"

/* MulitComp has ACAI UART at 0xFFD0 & 0xFFD1 
 * Added this to 6809 code in 6809v.c

 * http://www.searle.wales/ Grant's 6-chip 6809 computer
 * In SBC  version UART @ 0xA000 and 0xA001 and uses STDIN and STDOUT
 * In FPGA version UART @ 0xFFD0 and 0xFFD1 and uses STDIN and STDOUT
*/
extern  int uartStatus;
extern  int uartControl;
extern  int uartRx;
extern  int uartTx;
extern  int uartTxCount;

/*
 * emulate enough of the Motorola 68B50 UART 
 */

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
     /* block waiting for a key */
     uartRx = getchar() & 0xff;
	 uartStatus |= 0x81; // Set RX avail and INT
	 printf("k: %x %x \n", uartStatus, uartRx );
   }
}
#endif

/*
[ CPU ] --- [ UART ] -- [ STDIN,STDOUT ]
*/		



#ifdef tcc
void CheckKey( void * ignored )
{
   int fd;
   while ( 1 != 0 ){
	 /* test if UART has been read by 6809*/
	 while ( uartStatus & 1 > 0) {
	   sleep(20);
	 }	 
	 
	 /*Buffer empty get character */
     uartRx = _getch() & 0xff;
	 uartStatus |= 0x81; // Set RX avail and INT
	 //printf("k: %x %x \n", uartStatus, uartRx );
   }
}
#endif

#ifdef linux
void * CheckKey( void * ignored )
{
   while ( 1 != 0 ){
	   
	 /* test if UART has been read by 6809*/
	 while ( uartStatus & 1 > 0) {
	   usleep(100);
	 }	 
	  
	 /*Buffer empty get character */
     uartRx = getchar() & 0xff;
	 if ( uartRx == EOF  ) {
		printf("========= end of file ============ \n "); 
	 }
	 if ( uartRx == 'q' ) {
	   /* restore keyboard STDIN & keyboard*/	 
	   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
	   cpu_quit = 0;
	   //exit(0);
	 }
	 uartStatus |= 0x81; // Set RX avail and INT
   }
}
#endif


#ifdef linux
void initThread ( pthread_t threadP ,  void *  message1  ) {
    int  iret1;
    static struct termios newt;
    tcgetattr( STDIN_FILENO, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr( STDIN_FILENO, TCSANOW, &newt);
    iret1 = pthread_create( &threadP, NULL, CheckKey,   message1 );
}
#endif


/********************************************
* Sec 1.0 Functions monitor.c stub functions
********************************************/
/* monitor.c */
int monitor_on;
int check_break (unsigned);
void monitor_init (void); 
int monitor6809 (void);
int dasm (char *, int);

int check_break (unsigned break_pc)
{
  return 0;
}

void monitor_init (void)
{
  /* cut down */
  monitor_on = 1;
}


int monitor6809 (void)
{
  /* cut down */
  monitor_on = 0;
  return 0;
}



/********************************************
* Sec 1.0 Functions to load HEX files
********************************************/


enum { HEX, S19, BIN };

static char *Options[]=
{
 "hex","s19","bin","s",NULL
};

int total = 0;

char *exename;

int load_hex (char *);
int load_s19 (char *);
int load_bin (char *,int);


static void usage (void)
{
  printf("Usage: %s <options> filename\n",exename);
  printf("Options are:\n");
  printf("-hex	- load intel hex file\n");
  printf("-s19	- load motorola s record file\n");
  printf("-bin	- load binary file\n");
  printf("-s addr - specify binary load address hexadecimal (default 0)\n");
  printf("default format is motorola s record\n");

  if(memory != NULL) free(memory);
  exit (1);
}

int sizeof_file (FILE *file)
{
  int size;

  fseek(file,0,SEEK_END);
  size = ftell(file);
  rewind(file);

  return size;
}

int load_hex (char *name)
{
  FILE *fp;
  unsigned int count, addr, type, data, checksum;
  int done = 1;
  int line = 0;
  char cr;

  fp = fopen(name, "r");

  if (fp == NULL)
  {
    printf ("failed to open hex record file %s.\n",name);
    return 1;
  }

  while (done != 0)
  {
    line++;

    if (fscanf(fp, ":%2x%4x%2x",&count,&addr,&type) != 3)
    {
	  	  	
      printf ("line %d: invalid hex record information.\n",line);
      break;
    }


    checksum = count + (addr >> 8) + (addr & 0xff) + type;

    switch (type)
    {
      case 0:  for (; count != 0; count--,addr++,checksum += data)
               {
                 fscanf(fp, "%2x",&data);
                 memory[addr &= 0xffff] = (UINT8)data;
               }

               checksum = (-checksum) & 0xff;
               fscanf(fp, "%2x",&data);
               if(data != checksum)
               {
                 printf ("line %d: invalid hex record checksum.\n",line);
                 done = 0;
				 break;
               }
               
               //(void)fgetc(fp); /* skip CR/LF/NULL */
               //(void)fgetc(fp); /* skip CR/LF/NULL */
               /* fp is only updated if match, gobble up CR and LF */
               fscanf(fp, "\n" );
               fscanf(fp, "\r" );
               fscanf(fp, "\n" );

               break;

      case 1:  checksum = (-checksum) & 0xff;
               fscanf(fp, "%2x",&data);
               if(data != checksum) printf ("line %d: invalid hex record checksum \n",line);
               done = 0;
               break;

      case 2:
      default: printf("line %d: not supported hex type %d.\n",line,type);
               done = 0;
               break;
     }
  }

  fclose(fp);
  return 0;
}


int load_s19 (char *name)
{
  FILE *fp;
  unsigned int count, addr, type, data, checksum;
  int done = 1;
  int line = 0;

  fp = fopen(name, "r");

  if (fp == NULL)
  {
    printf ("failed to open S record file %s.\n",name);
    return 1;
  }

  while (done != 0)
  {
    line++;

    if (fscanf(fp, "S%1x%2x%4x",&type,&count,&addr) != 3)
    {
      printf ("line %d: invalid S record information.\n",line);
      break;
    }

    checksum = count + (addr >> 8) + (addr & 0xff);

    switch (type)
    {
      case 1:  for (count -= 3; count != 0; count--,addr++,checksum += data)
               {
                 fscanf(fp, "%2x",&data);
                 memory[addr &= 0xffff] = (UINT8)data;
               }

               checksum = (~checksum) & 0xff;
               fscanf(fp, "%2x",&data);
               if(data != checksum)
               {
                 printf ("line %d: invalid S record checksum.\n",line);
                 done = 0;
		     break;
               }
               (void)fgetc(fp); /* skip CR/LF/NULL */
               break;

      case 9:  checksum = (~checksum) & 0xff;
               fscanf(fp, "%2x",&data);
               if(data != checksum) printf ("line %d: invalid S record checksum.\n",line);
               done = 0;
               break;

      default: printf ("line %d: S%d not supported.\n",line,type);
               done = 0;
               break;
     }
  }

  fclose(fp);
  return 0;
}

int load_bin (char *name,int addr)
{
  FILE *fp;
  int size;

  fp = fopen(name, "rb");

  if (fp == NULL)
  {
    printf("failed to open binary file %s.\n",name);
    return 1;
  }

  size = sizeof_file(fp);

  if ((addr + size) > 0x10000)
  {
     printf("file %s size problems\n",name);
     fclose(fp);
     return 1;
  }

  fread(memory + addr, size, 1, fp);
 
  fclose(fp);
  return 0;
}


/********************************************
* Sec 1.0 MAIN Function
********************************************/


int monitor_on;

int main(int argc, char **argv)
{

	char *name;
	int type = S19;
	int off  = 0;
	int i, j, n;


	int c;
	
	
	monitor_on = 0 ;
    printf("Loading code...\n");

	exename = argv[0];

	if (argc == 1) usage();
 
	for (i=1,n=0;i<argc;++i)
	{
		if (argv[i][0]!='-')
		{
		switch (++n)
		{
			case 1:  name=argv[i]; break;
			default: usage();
		}
    }
    else
    {
		for (j=0;Options[j];j++) if (!strcmp(argv[i]+1,Options[j])) break;
		switch (j)
		{
        case 0:  type = HEX;  break;
        case 1:  type = S19;  break;
        case 2:  type = BIN;  break;
        case 3:  i++; if (i>argc) usage();
                 off  = strtoul(argv[i],NULL,16);
                 type = BIN;
                 break;

        default: usage();
      }
    }
  }




  memory = (UINT8 *)malloc(0x10000);

  if (memory == NULL) usage();
  memset (memory, 0, 0x10000);

  cpu_quit = 1;

  switch (type)
  {
    case HEX: if(load_hex(name)) usage(); break;
    case S19: if(load_s19(name)) usage(); break;
    case BIN: if(load_bin(name,off&0xffff)) usage(); break;
  }  



	
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

  cpu_reset();
  printf ("AS,JF, 1.2, file %s     ,press q to quit \n",name);
  do
  {
    total += cpu_execute (60);
  } while (cpu_quit != 0);

    printf("6809 stopped after %d cycles\n",total);

    free(memory);
#ifdef linux
	tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
#endif
    return 0;
    exit(0);
}


