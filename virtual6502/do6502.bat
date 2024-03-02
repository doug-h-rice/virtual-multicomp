rem
rem
rem


rem C:\Users\dough\Documents\Desktop\tcc-0.9.26-win64-bin\tcc
rem C:\Users\dough\Documents\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6502
..\..\tcc.exe    cpu6502rom.c ihex.c
pause
cpu6502rom
pause
exit

rem 
sdcc -help
rem sdcc -mmos6502 --code-loc0x1000 --no-std-crt0 bare.c
sdcc -mmos6502 --code-loc0x200 -v bare.c
pause

rem Port of 6502 that ran on an Arduino
..\..\tcc.exe    cpu6502arduino.c
pause
