;;
;;
;;
;; Basically with this we say that our program runs in the address 0x0100 (we can modify it to another address, of course). To use it, we have to compile, as follows:
;; sdasz80 -o crt0_cpc.s
;; With this, it generates a file crt0_cpc.rel, which we'll use to compile our code in c. As already mentioned, SDCC does not know about Amstrad, so the compiller not know how to paint a character on screen, if you want to use printf for example, you need to tell the compiler how to make a putchar (printf calls it internally). With any text or code editor (with notepad in Windows) generate a file called putchar_cpc.s with the following contents (at the end of the tutorial can be downloaded all in one zip):


;; FILE: crt0.s
;; Generic crt0.s for a Z80
;; From SDCC..
;; Modified to suit execution on the Amstrad CPC!
;; by H. Hansen 2003
;; Original lines has been marked out!

  .module crt0
  .globl  _main

  .area _HEADER (ABS)
;; Reset vector
  .org  0x100 ;; Start from address &100
  jp  init
  
  .org  0x110

init:

;; Stack at the top of memory.
;;  ld  sp,#0xffff        
;;  I will use the Basic stack, so the program can return to basic!

;; Initialise global variables
  call    gsinit
  call  _main
  jp  _exit

  ;; Ordering of segments for the linker.
  .area _HOME
  .area _CODE
  .area   _GSINIT
  .area   _GSFINAL
        
  .area _DATA
  .area   _BSS
  .area   _HEAP

  .area   _CODE
__clock::
  ret
  
_exit::
  ret
  
  .area   _GSINIT
gsinit::  

.area   _GSFINAL
  ret

