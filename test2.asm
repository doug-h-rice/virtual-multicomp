;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.8.0 #10562 (Linux)
;--------------------------------------------------------
	.module test2
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _strlen
	.globl _strcmp
	.globl _puts
	.globl _printf
	.globl _end
	.globl _buff3
	.globl _buff2
	.globl _buff
	.globl _putchar
	.globl _getchar
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_IoPort	=	0x0078
_uartData	=	0x0081
_uartStatus	=	0x0080
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_buff::
	.ds 10
_buff2::
	.ds 20
_buff3::
	.ds 20
_end::
	.ds 2
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
;test2.c:54: int putchar( int c ){
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
;test2.c:55: while( !(uartStatus & 0x02) );
00101$:
	in	a, (_uartStatus)
	bit	1, a
	jr	Z,00101$
;test2.c:56: uartData = ( char ) c;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_uartData), a
;test2.c:57: return c;
	pop	bc
	pop	hl
	push	hl
	push	bc
;test2.c:58: }
	ret
;test2.c:60: int getchar(){
;	---------------------------------
; Function getchar
; ---------------------------------
_getchar::
;test2.c:62: while( !( uartStatus & 0x01 ) );
00101$:
	in	a, (_uartStatus)
	rrca
	jr	NC,00101$
;test2.c:63: return ( int )uartData;
	in	a, (_uartData)
	ld	l, a
	ld	h, #0x00
;test2.c:64: }
	ret
;test2.c:68: main(){
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-17
	add	hl, sp
	ld	sp, hl
;test2.c:75: buff[0] = '\0';
	ld	hl, #_buff
	ld	(hl), #0x00
;test2.c:76: strcpy(buff,":");
	ld	de, #_buff
	ld	hl, #___str_0
	xor	a, a
00140$:
	cp	a, (hl)
	ldi
	jr	NZ, 00140$
;test2.c:77: buffPtr = buff;
	ld	-2 (ix), #<(_buff)
	ld	-1 (ix), #>(_buff)
;test2.c:78: x=0;	
	ld	-7 (ix), #0x00
	ld	-6 (ix), #0x00
;test2.c:79: key =  ' ';
	ld	-5 (ix), #0x20
;test2.c:80: printf("buff:  %p \n", buff   );
	ld	hl, #_buff
	push	hl
	ld	hl, #___str_1
	push	hl
	call	_printf
	pop	af
;test2.c:81: printf("buff2: %p \n", buff2   );
	ld	hl, #_buff2
	ex	(sp),hl
	ld	hl, #___str_2
	push	hl
	call	_printf
	pop	af
;test2.c:82: printf("buff3: %p \n", buff3   );
	ld	hl, #_buff3
	ex	(sp),hl
	ld	hl, #___str_3
	push	hl
	call	_printf
	pop	af
;test2.c:83: printf("end:   %p \n", &end   );
	ld	hl, #_end
	ex	(sp),hl
	ld	hl, #___str_4
	push	hl
	call	_printf
	pop	af
	pop	af
;test2.c:84: printf("x:    %p \n", &x   );
	ld	hl, #0x000a
	add	hl, sp
	ld	bc, #___str_5+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;test2.c:85: printf("key:  %p \n", &key   );
	ld	hl, #0x000c
	add	hl, sp
	ld	bc, #___str_6+0
	push	hl
	push	bc
	call	_printf
	pop	af
	pop	af
;test2.c:87: while( 1==1){  
	ld	a, -7 (ix)
	ld	-4 (ix), a
	ld	a, -6 (ix)
	ld	-3 (ix), a
00111$:
;test2.c:89: printf("\nWelcome - press a key\n");
	ld	hl, #___str_8
	push	hl
	call	_puts
	pop	af
;test2.c:95: key = ( char ) getchar();
	call	_getchar
	ld	a, l
	ld	-5 (ix), a
;test2.c:98: buffPtr[0] = key;
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), a
;test2.c:99: buffPtr++;
	inc	-2 (ix)
	jr	NZ,00141$
	inc	-1 (ix)
00141$:
;test2.c:100: buffPtr[0] = '\0';
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), #0x00
;test2.c:102: if ( key == ' ' ){
	ld	a, -5 (ix)
	sub	a, #0x20
	jp	NZ,00108$
;test2.c:103: printf("Buff:%s:  %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello ") );
	ld	hl, #___str_10
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ex	de,hl
	ld	hl, #_buff
	push	hl
	call	_strlen
	pop	af
	push	de
	push	hl
	ld	hl, #_buff
	push	hl
	ld	hl, #___str_9
	push	hl
	call	_printf
	ld	hl, #8
	add	hl, sp
	ld	sp, hl
;test2.c:104: printf("Buff:%s:  %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello ") );
	ld	hl, #___str_10
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ex	de,hl
	ld	hl, #_buff
	push	hl
	call	_strlen
	pop	af
	push	de
	push	hl
	ld	hl, #_buff
	push	hl
	ld	hl, #___str_9
	push	hl
	call	_printf
	ld	hl, #8
	add	hl, sp
	ld	sp, hl
;test2.c:105: if ( strcmp(buff,"help ") == 0 ) { printf("\x1b[43m ..help.. ++++\x1b[m\n\r",0x1b ); };
	ld	hl, #___str_11
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a, h
	or	a, l
	jr	NZ,00102$
	ld	hl, #0x001b
	push	hl
	ld	hl, #___str_12
	push	hl
	call	_printf
	pop	af
	pop	af
00102$:
;test2.c:106: if ( strcmp(buff,"stop ") == 0 ) { printf("\x1b[41m ..stop.. ++++\x1b[m\n\r",0x1b ); };
	ld	hl, #___str_13
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a, h
	or	a, l
	jr	NZ,00104$
	ld	hl, #0x001b
	push	hl
	ld	hl, #___str_14
	push	hl
	call	_printf
	pop	af
	pop	af
00104$:
;test2.c:107: if ( strcmp(buff,"go "  ) == 0 ) { printf("\x1b[42m ..Run... ++++\x1b[m\n\r",0x1b ); };
	ld	hl, #___str_15
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ld	a, h
	or	a, l
	jr	NZ,00106$
	ld	hl, #0x001b
	push	hl
	ld	hl, #___str_16
	push	hl
	call	_printf
	pop	af
	pop	af
00106$:
;test2.c:109: buffPtr    = buff;
;test2.c:110: buffPtr[0] = '\0';
	ld	-2 (ix), #<(_buff)
	ld	-1 (ix), #>(_buff)
	ld	l, #<(_buff)
	ld	h, #>(_buff)
	ld	(hl), #0x00
	jp	00111$
00108$:
;test2.c:115: printf("Hello World - SDCC compiled this! %04X :%02X:%c: \n\r", x, (int) key, (char) key );
	ld	c, -5 (ix)
	ld	b, #0x00
	ld	a, -5 (ix)
	push	af
	inc	sp
	push	bc
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	push	hl
	ld	hl, #___str_17
	push	hl
	call	_printf
	ld	hl, #7
	add	hl, sp
	ld	sp, hl
;test2.c:117: printf("Buff:%s:  %d %d %d \n\r", buff, strlen(buff), strcmp(buff,"hello "), sizeof( buff )  );
	ld	hl, #___str_10
	push	hl
	ld	hl, #_buff
	push	hl
	call	_strcmp
	pop	af
	pop	af
	ex	de,hl
	ld	hl, #_buff
	push	hl
	call	_strlen
	pop	af
	ld	c, l
	ld	b, h
	ld	hl, #0x000a
	push	hl
	push	de
	push	bc
	ld	hl, #_buff
	push	hl
	ld	hl, #___str_18
	push	hl
	call	_printf
	ld	hl, #10
	add	hl, sp
	ld	sp, hl
;test2.c:119: printf("%c[m\n\r",0x1b );
	ld	hl, #0x001b
	push	hl
	ld	hl, #___str_19
	push	hl
	call	_printf
	pop	af
;test2.c:122: printf("%c[31m ..Red...............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_20
	push	hl
	call	_printf
	pop	af
;test2.c:123: printf("%c[32m ..Green.............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_21
	push	hl
	call	_printf
	pop	af
;test2.c:124: printf("%c[33m ..Yellow............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_22
	push	hl
	call	_printf
	pop	af
;test2.c:125: printf("%c[34m ..Blue..............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_23
	push	hl
	call	_printf
	pop	af
;test2.c:126: printf("%c[35m ..Magenta...........................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_24
	push	hl
	call	_printf
	pop	af
;test2.c:127: printf("%c[36m ..Cyan..............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_25
	push	hl
	call	_printf
	pop	af
;test2.c:128: printf("%c[37m ..White.............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_26
	push	hl
	call	_printf
	pop	af
;test2.c:131: printf("%c[41m ..Red...............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_27
	push	hl
	call	_printf
	pop	af
;test2.c:132: printf("%c[42m ..Green.............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_28
	push	hl
	call	_printf
	pop	af
;test2.c:133: printf("%c[43m ..Yellow............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_29
	push	hl
	call	_printf
	pop	af
;test2.c:134: printf("%c[44m ..Blue..............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_30
	push	hl
	call	_printf
	pop	af
;test2.c:135: printf("%c[45m ..Magenta...........................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_31
	push	hl
	call	_printf
	pop	af
;test2.c:136: printf("%c[46m ..Cyan..............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_32
	push	hl
	call	_printf
	pop	af
;test2.c:137: printf("%c[47m ..White.............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_33
	push	hl
	call	_printf
	pop	af
;test2.c:138: printf("%c[40m ..Black.............................: \r\n",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_34
	push	hl
	call	_printf
	pop	af
;test2.c:139: printf("%c[30m  ..Black.............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_35
	push	hl
	call	_printf
	pop	af
;test2.c:140: printf("%c[m ..Black.............................: \n\r",0x1b );
	ld	hl, #0x001b
	ex	(sp),hl
	ld	hl, #___str_36
	push	hl
	call	_printf
	pop	af
	pop	af
;test2.c:142: x++;   
	inc	-4 (ix)
	jp	NZ,00111$
	inc	-3 (ix)
;test2.c:145: return 1;
;test2.c:146: }
	jp	00111$
___str_0:
	.ascii ":"
	.db 0x00
___str_1:
	.ascii "buff:  %p "
	.db 0x0a
	.db 0x00
___str_2:
	.ascii "buff2: %p "
	.db 0x0a
	.db 0x00
___str_3:
	.ascii "buff3: %p "
	.db 0x0a
	.db 0x00
___str_4:
	.ascii "end:   %p "
	.db 0x0a
	.db 0x00
___str_5:
	.ascii "x:    %p "
	.db 0x0a
	.db 0x00
___str_6:
	.ascii "key:  %p "
	.db 0x0a
	.db 0x00
___str_8:
	.db 0x0a
	.ascii "Welcome - press a key"
	.db 0x00
___str_9:
	.ascii "Buff:%s:  %d %d "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_10:
	.ascii "hello "
	.db 0x00
___str_11:
	.ascii "help "
	.db 0x00
___str_12:
	.db 0x1b
	.ascii "[43m ..help.. ++++"
	.db 0x1b
	.ascii "[m"
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_13:
	.ascii "stop "
	.db 0x00
___str_14:
	.db 0x1b
	.ascii "[41m ..stop.. ++++"
	.db 0x1b
	.ascii "[m"
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_15:
	.ascii "go "
	.db 0x00
___str_16:
	.db 0x1b
	.ascii "[42m ..Run... ++++"
	.db 0x1b
	.ascii "[m"
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_17:
	.ascii "Hello World - SDCC compiled this! %04X :%02X:%c: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_18:
	.ascii "Buff:%s:  %d %d %d "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_19:
	.ascii "%c[m"
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_20:
	.ascii "%c[31m ..Red...............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_21:
	.ascii "%c[32m ..Green.............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_22:
	.ascii "%c[33m ..Yellow............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_23:
	.ascii "%c[34m ..Blue..............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_24:
	.ascii "%c[35m ..Magenta...........................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_25:
	.ascii "%c[36m ..Cyan..............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_26:
	.ascii "%c[37m ..White.............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_27:
	.ascii "%c[41m ..Red...............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_28:
	.ascii "%c[42m ..Green.............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_29:
	.ascii "%c[43m ..Yellow............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_30:
	.ascii "%c[44m ..Blue..............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_31:
	.ascii "%c[45m ..Magenta...........................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_32:
	.ascii "%c[46m ..Cyan..............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_33:
	.ascii "%c[47m ..White.............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_34:
	.ascii "%c[40m ..Black.............................: "
	.db 0x0d
	.db 0x0a
	.db 0x00
___str_35:
	.ascii "%c[30m  ..Black.............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
___str_36:
	.ascii "%c[m ..Black.............................: "
	.db 0x0a
	.db 0x0d
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
