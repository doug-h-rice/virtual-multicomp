;;
;;
;; FILE: crt0_mc.s
;;
;; Generic crt0.s for a Z80
;; From SDCC..
;; Original lines has been marked out!
;; see: http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm

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

