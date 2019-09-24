;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 19 2016) (Linux)
; This file was generated Tue Sep 24 22:45:31 2019
;--------------------------------------------------------
	.module test
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _getchar
	.globl _printf
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;test.c:24: main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
;test.c:32: printf("\nWelcome - press a key\n");
	ld	hl,#___str_0
	push	hl
	call	_printf
	pop	af
;test.c:35: while( x < 10 ) {
	ld	de,#0x0000
00101$:
	ld	a,e
	sub	a, #0x0A
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00103$
;test.c:38: key = getchar();  
	push	de
	call	_getchar
	pop	de
;test.c:40: printf("Hello World - Doug here %04X :%c: \n\r", x, key );
	ld	a,l
	rla
	sbc	a, a
	ld	h,a
	ld	bc,#___str_1
	push	de
	push	hl
	push	de
	push	bc
	call	_printf
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	pop	de
;test.c:41: x++;   
	inc	de
	jr	00101$
00103$:
;test.c:44: printf("\nExit from main loop\n");
	ld	hl,#___str_2+0
	push	hl
	call	_printf
	pop	af
	ret
___str_0:
	.db 0x0A
	.ascii "Welcome - press a key"
	.db 0x0A
	.db 0x00
___str_1:
	.ascii "Hello World - Doug here %04X :%c: "
	.db 0x0A
	.db 0x0D
	.db 0x00
___str_2:
	.db 0x0A
	.ascii "Exit from main loop"
	.db 0x0A
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
