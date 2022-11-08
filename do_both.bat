rem
rem do_both.bat
rem

rem virtual-multicomp test2.ihx
pause

:buildRCASM
cd  rcasm_scr
..\..\tcc rcasm.c asmcmds.c mstrings.c support.c 
copy rcasm.exe ..
cd ..
pause

:buildASM
rcasm -dz80 -l -h test_RC2014_8400.asm
pause 

:buildMin
rcasm -dz80 -l -h min.asm
pause 

:buildTest
sdasz80.exe -l -o putchar_mc.s
sdasz80.exe -l -o crt0_mc.s
sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel putchar_mc.rel test.c
sdldz80.exe -u -nf test.lk
pause

:buildTest1
sdasz80.exe -l -o putchar_mc.s
sdasz80.exe -l -o crt0_mc.s
sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel  test1.c
sdldz80.exe -u -nf test1.lk
pause
 
:buildTest2
sdasz80.exe -l -o putchar_mc.s
sdasz80.exe -l -o crt0_mc.s
sdcc.exe -V -mz80 --code-loc 0x0138 --data-loc 0 --no-std-crt0 crt0_mc.rel  test2.c
sdldz80.exe -u -nf test2.lk
pause  

:buildVirtualMulticomp 
..\tcc virtual-multicomp.c ihex.c simz80.c   
pause


rem 
:run
virtual-multicomp basic.hex
virtual-multicomp SCM.HEX test_RC2014_8400.hex
virtual-multicomp test.ihx
virtual-multicomp test1.ihx
virtual-multicomp test2.ihx

