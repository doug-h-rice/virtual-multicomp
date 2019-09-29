rem
rem do_both.bat
rem


sdasz80.exe -l -o putchar_mc.s
sdasz80.exe -l -o crt0_mc.s
sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
sdldz80.exe -u -nf test.lk
 
..\tcc virtual-multicomp.c ihex.c simz80.c   

pause
virtual-multicomp

