rem
rem do6502.bat 
rem



rem C:\Users\dough\Documents\Desktop\tcc-0.9.26-win64-bin\tcc
rem C:\Users\dough\Documents\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6502
..\..\tcc.exe    cpu6502rom.c ihex.c
pause
rem cpu6502rom

rem Port of 6502 that ran on an Arduino
..\..\tcc.exe    cpu6502arduino.c
pause

rem 
	sdcc -help
	rem sdcc -mmos6502 --code-loc0x1000 --no-std-crt0 bare.c
	sdas6500 -plosgffw   crt0.lst  crt0.s 
	pause
	sdcc -V -mmos6502   --model-large bare.c
	pause
	sdld6808 -nfiu bare.lk
	pause
	..\..\tcc.exe    cpu6502rom.c ihex.c
	pause
	cpu6502rom bare.ihx
	pause
	exit
	
