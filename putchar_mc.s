
;; FILE: putchar_mc.s
;; the control register is addressed on port 80H 
;; the data register is addressed on port 81H.

;;http://searle.hostei.com/grant/z80/SimpleZ80.html
;; see: http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm
;;
;; see nasmini.asm for another way.
;;
;; Usage example:-
;;
;;	sdasz80 -l -o putchar_mc.s
;;	sdasz80 -l -o crt0_mc.s
;;	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
;;	/usr/bin/sdldz80 -u -nf test.lk

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

;;Now that we are ready, with any text or code editor (with notepad in Windows) generate a file called sdcc01.c with the following contents (at the end of the tutorial can be downloaded all in one zip):
;;#include <stdio.h>
;;main()
;;{
;;  printf("Hello world");
;;  while(1) {};
;;}
