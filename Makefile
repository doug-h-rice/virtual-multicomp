# Makefile for Virtual Multicomp

# CC must be an C99 compiler
CC=gcc -std=c99 

# full speed or debugging to taste
OPTIMIZE=-O2
#OPTIMIZE=-g
#WARN=-Wmost -Werror
WARN=-Wall -Wno-parentheses
CFLAGS=$(OPTIMIZE) $(WARN) 


all: test.rst  virtual-multicomp 
	./virtual-multicomp 

test.rst:  test.ihx
	sdasz80 -l -o putchar_mc.s
	sdasz80 -l -o crt0_mc.s
	sdcc -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
	/usr/bin/sdldz80 -u -nf test.lk
    
virtual-multicomp: virtual-multicomp.o  simz80.o ihex.o  
	$(CC) $(CWARN) $^ -o $@ -pthread

clean:
	rm -f *.o *~ core *.rel *.lk *.rst *.map *.noi *.lst *.sym

