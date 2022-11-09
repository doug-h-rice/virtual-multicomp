# Makefile for Virtual Multicomp

# CC must be an C99 compiler
##CC=gcc -std=c99 
CC=gcc 

# full speed or debugging to taste
OPTIMIZE=-O2
#OPTIMIZE=-g
#WARN=-Wmost -Werror
WARN=-Wall -Wno-parentheses
CFLAGS=$(OPTIMIZE) $(WARN) 

bare: 
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel bare.c   
	/usr/bin/sdldz80 -u -nf bare.lk

min: 
	./rcasm -dz80 -l -h min.asm
#	./virtual-multicomp min.hex
    
all:  test.rst test2.rst  virtual-multicomp 
	./virtual-multicomp 
	./virtual-multicomp SCM.hex test.ihx


test:  test.rst  virtual-multicomp 
	./virtual-multicomp test.ihx

test1:  test1.rst  virtual-multicomp 
	./virtual-multicomp test1.ihx


test2:  test2.rst  virtual-multicomp 
	./virtual-multicomp test2.ihx

basic:
	./virtual-multicomp  BASIC.HEX

monitor:
	./virtual-multicomp  SCM.hex

scm:
    # build assembler
	./rcasm -dz80 -l -h test_RC2014_8400.asm
	echo -e "*** Loads assembly code at 8400 ******************"
	echo -e "*** g8400 ******************"
	./virtual-multicomp SCM.hex test_RC2014_8400.hex


#basic:
#	sdasz80 -l -o nasmini.asm
#	sdasz80 -l -o basic.asm
#	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 basic.rel nasmini.rel 
#	/usr/bin/sdldz80 -u -nf test.lk


rc: test_RC2014_8400.hex
	./rcasm -dz80 -l -h test_RC2014_8400.asm

test.rst: test.c
	sdasz80 -l -o putchar_mc.s
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c  
	/usr/bin/sdldz80 -u -nf test.lk

test1.rst: test1.c
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel test1.c  
	/usr/bin/sdldz80 -u -nf test1.lk

test2.rst: test2.c
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80  --no-std-crt0 crt0_mc.rel test2.c  
	/usr/bin/sdldz80 -u -nf test2.lk
	

#
#
# Build test.c for the RC2014 
#
#	0000-1FFF ROM
#	8000-FFFF RAM
#
#	80	UART control
#	81	UART DATA
#
# The UART is at the same place, but this code controls the UART hardware, and does not use the SCM's routine.
#
#
#

test_RC2014_8400.hex:
	./rcasm -dz80 -l -h test_RC2014_8400.asm
	
rc2014: virtual-multicomp test_RC2014_8400.hex
	#sdasz80 -l -o putchar_mc.s
	#sdasz80 -l -o crt0_mc.s
	#sdcc -V -mz80 --code-loc 0x8200 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
	#/usr/bin/sdldz80 -u -nf test.lk

    # build assembler
	./rcasm -dz80 -l -h test_RC2014_8400.asm

	echo "*** Loads assembly code at 8400 ******************"
	echo "*** g8400 ******************"
	./virtual-multicomp SCM.hex test_RC2014_8400.hex

    
virtual-multicomp: virtual-multicomp.o  simz80.o ihex.o  
	$(CC) $(CWARN) $^ -o $@ -pthread

clean:
	rm -f *.o *~ core *.rel *.lk *.rst *.map *.noi *.lst *.sym

