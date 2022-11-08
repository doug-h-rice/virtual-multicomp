;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.8.0 #10562 (Linux)
;--------------------------------------------------------
	.module bare
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _putchar
	.globl _getchar
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_uartData	=	0x0081
_uartStatus	=	0x0080
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
;bare.c:22: main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
;bare.c:23: while(1){
00102$:
;bare.c:24: putchar( getchar() );
	call	_getchar
	push	hl
	call	_putchar
	pop	af
;bare.c:26: }
	jr	00102$
;bare.c:42: int putchar( int c ){
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
;bare.c:43: while( !(uartStatus & 0x02) );
00101$:
	in	a, (_uartStatus)
	bit	1, a
	jr	Z,00101$
;bare.c:44: uartData = ( char ) c;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_uartData), a
;bare.c:45: return c;
	pop	bc
	pop	hl
	push	hl
	push	bc
;bare.c:46: }
	ret
;bare.c:48: int getchar(){
;	---------------------------------
; Function getchar
; ---------------------------------
_getchar::
;bare.c:50: while( !( uartStatus & 0x01 ) );
00101$:
	in	a, (_uartStatus)
	rrca
	jr	NC,00101$
;bare.c:51: return ( int )uartData;
	in	a, (_uartData)
	ld	l, a
	ld	h, #0x00
;bare.c:52: }
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
