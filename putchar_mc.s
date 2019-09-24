
;; FILE: putchar_mc.s
;; the control register is addressed on port 80H 
;; the data register is addressed on port 81H.



;;http://searle.hostei.com/grant/z80/SimpleZ80.html

;;sdasz80 -l -o crt0_cpc.s
;;With this, it generates a file crt0_cpc.rel, which we'll use to compile our code in c. As already mentioned, SDCC does not know about Amstrad, so the compiller not know how to paint a character on screen, if you want to use printf for example, you need to tell the compiler how to make a putchar (printf calls it internally). With any text or code editor (with notepad in Windows) generate a file called putchar_cpc.s with the following contents (at the end of the tutorial can be downloaded all in one zip):

  .area _CODE
_putchar::       
_putchar_rr_s:: 
          ld      hl,#2
          add     hl,sp
        
;          ld      a,(hl)

;; output to the UART at 0x81, 
;; It should really check if buffer is empty
		
_putchar1::
		  ; test and block if still sending last char
		  in	a,(0x80)  ; the control register is addressed on port 80H   
		  ;test TX_empty bit.		  	
		  and #0x02	
		  jr  z,_putchar1 
    
          ld      a,(hl)
          out	  (0x81),a
          ret
           
;;_putchar_rr_dbs::

;;          ld      a,e
;; output to the UART at 0x81, 
;; It should really check if buffer is empty
;;          out	  (0x81),a
;;          ret


;
; this blocks awaiting a character.
;
;
;
_getchar::       
	; test and block if no key available.
    in	a,(0x80)    ; the control register is addressed on port 80H
	and #0x01
	jr	z,_getchar
    
_getchar2::    
	in a,(0x81)
	ld l,a
	ret

;; Basically, we tell him to call the function 0xBB5A firmware to paint a character. To use it, we have to compile it as follows:
;; sdasz80 -o putchar_cpc.s
;;Now that we are ready, with any text or code editor (with notepad in Windows) generate a file called sdcc01.c with the following contents (at the end of the tutorial can be downloaded all in one zip):
;;#include <stdio.h>
;;main()
;;{
;;  printf("Hello world");
;;  while(1) {};
;;}
;;To compile from the command line (or better make a batch file) in the same directory where we have the three files (sdcc01.c, crt0_cpc.s and putchar_cpc.s) run:
;;sdcc -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_cpc.rel putchar_cpc.rel sdcc01.c
