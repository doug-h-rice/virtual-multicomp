#include "ihex.h"
#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>

// return true if failed
static bool hexdigitValue(int ch, int *v)
{
    if ('0' <= ch && ch <= '9')
        *v = ch - '0';
    else if ('A' <= ch && ch <= 'F')
        *v = ch - 'A' + 10;
    else if ('a' <= ch && ch <= 'f')
        *v = ch - 'a' + 10;
    else
        return true;

    return false;
}

static bool read_hex(FILE *f, int n, int *v)
{
    *v = 0;


    if ( !f ){
		printf( "error:-file not open\n" );
		return false;	
	}
	
    while (n-- > 0) {
        int dv, ch = fgetc(f);

        if (hexdigitValue(ch, &dv)) {
            fprintf(stderr, "Expected hexdigit at pos %ld, got %d",
                    ftell(f) - 1, ch);
            return true;
        }

        *v = 16* *v + dv;
    }

    return false;
}

static bool read_ihex_line(FILE *f, unsigned char *memory, unsigned *start_addr)
{
    /*
     Expect lines like this:
     :10010000214601360121470136007EFE09D2190140
     That is (without spaces)
     CC AAAAA TT DD DD DD .. DD KK
     CC is the byte count (# of DD pairs)
     AA is the 16-bit address (offset) from base
     TT is the type
     KK checksum (twos compliment of sum of all bytes)
    */

    unsigned int ch, count, addr, type, v, chk;

    if ( !f ){
		printf( "error:-file not open\n" );
		return false;	
	}

    do {
        ch = fgetc(f);
        if (ch < 0)
            return false;
    } while (ch == '\n' || ch == '\r');

    if (ch != ':') {
        fprintf(stderr, "Expected ':' at pos %ld, got %d",
                ftell(f) - 1, ch);
        return true;
    }

    if (read_hex(f, 2, &count) ||
        read_hex(f, 4, &addr) ||
        read_hex(f, 2, &type))
        return true;

    if (type == 5)
        *start_addr = addr;

    while (count-- > 0) {
        if (read_hex(f, 2, &v))
            return true;

//        if (2048 <= addr && addr < 65536)
        if ( addr < 64*1024 )
	    // force ( unsigned int )  cast so memory[  0xE000 ] does not become memory[ -0x2000 ]      
            memory[ ( unsigned int ) addr++ & 0xFFFF ] = v;
    }

    if (read_hex(f, 2, &chk))
        return true;

    return false;
}

void load_ihex(const char *file, unsigned char *memory)
{
    FILE *f = fopen(file, "r");
    unsigned start_addr = -1;

    if ( f ){
      while (!feof(f)){
        if (read_ihex_line(f, memory, &start_addr)) {
            printf("Couldn't load %s as ihex\n", file);
            break;
        }
      }  
    }  else {
		printf(" failed to open :%s: \n",file);
	}
	printf(" Loaded file:%s: \n",file);
  
}


 
int load_both_formats(char *file, unsigned char *memory) {
   unsigned int hex_read, hex_len, hex_addr, hex_cmd ;
   unsigned int hex_count, hex_data, hex_check ;
   
   /*0F58 00 00 00 00 00 00 00 00 00*/
   unsigned int a, b1, b2, b3, b4, b5, b6, b7, b8, b9;
   char c10, c11;
   long last,now;

  
   FILE *stream = fopen( file,"rb");
   printf("\n === loading: %s ", file );

   if (!stream) {
	   stream=0;
       printf("error loading file: %s", file );
	   return (1==0);
   }


   /* use ftell() to check for read errors */
   last=0;
   now=0;
   while ( !feof( stream ) ) {
/*
 * 
 * .ihx format and .hex format
:180FDC00F6C40135C20031C100CA00C20131C100CA01C4FFCA0F925D84
:00000001FF
 * 
 *
:len addr 00 xx xx xx .. check                                        
:18  0FDC 00 F6C40135C20031C100CA00C20131C100CA01C4FFCA0F925D84
:18  0FDC 00 F6C40135C20031C100CA00C20131C100CA01C4FFCA0F925D84
:0E  100E 00 6C6C6F20646F75670A00DDE5DD21 F4 
 *  
 */
 	   	   
   /*:0E 100E 00 6C6C6F20646F75670A00DDE5DD21 F4 */
//     printf( "\nftell: %ld\n", ftell(stream) );
     
     hex_read = fscanf(stream,":%2x%4x%2x",&hex_len,&hex_addr,&hex_cmd);

     if ( hex_read ){
       // printf( "\n%x  %2d, %2X, %x  : ", hex_read, hex_len, hex_addr, hex_cmd );
       for( hex_count= 0 ; hex_count < hex_len ; hex_count++ ){
         /* limit address */ 
		 hex_addr = hex_addr & 0xFFFF;
		   
	     hex_read = fscanf(stream, "%2x",&hex_data ); 	  
         printf(" %02X", hex_data );
	 // force ( unsigned int )  cast so memory[  0xE000 ] does not become memory[ -0x2000 ]      
         memory[ ( unsigned int ) hex_addr & 0xFFFF ] = hex_data ;
         hex_addr ++;
       }    
       hex_read = fscanf(stream, "%2x\n",&hex_check);
     }     
   /* *.nas format   addr datax8 00 BS BS  e.g. */
   /*0F58 00 00 00 00 00 00 00 00 00*/
    hex_read = fscanf(stream, "%x %x %x %x %x %x %x %x %x %x%c%c\n",
	     &a , &b1, &b2, &b3, &b4, &b5, &b6, &b7, &b8, &b9, &c10, &c11 );
	// printf( " %d ", hex_read );       
	if ( hex_read == 12 ) {
	  // printf("\n%d  [%04x]   %02x %02x %02x %02x  %02x %02x %02x %02x  %02x {%d %d}",	
	  //   hex_read,         a,    b1,  b2, b3,    b4,   b5,  b6,  b7,  b8,   b9, (int)c10, (int)c11 );

//	  if ( a > 0 ){ 
	  if ( c10 == c11 ){ 
		a = ( unsigned int )( a & 0xFFFF );   
		memory[a]   = b1;
		memory[a+1] = b2;
		memory[a+2] = b3;
		memory[a+3] = b4;
		memory[a+4] = b5;
		memory[a+5] = b6;
		memory[a+6] = b7;
		memory[a+7] = b8;
      }
    }

	/* 
	 * 
	 * if the fscanf's have not matched,
	 * the position reported by ftell() does not change 
	 * 
	 */

	/* check for error reading data */
	 
    now=ftell( stream );
    if (last == now){
		printf("\n format error @ %ld\n",now);
		break;
	};
    last = now;
   }
   fclose(stream);
   stream=0;
   return (1==1)  ;
}




static void save_nascom(int start, int end, const char *name, unsigned char *ram)
{
    FILE *f = fopen(name, "w+");

    if (!f) {
        perror(name);
        return;
    }

    for (unsigned char *p = ram + start; start < end; p += 8, start += 8)
        fprintf(f, "%04X %02X %02X %02X %02X %02X %02X %02X %02X %02X%c%c\r\n",
                start, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], 0, 8, 8);

    fclose(f);
}

