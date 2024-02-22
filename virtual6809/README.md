== Virtual 6809
This provides a way to simulate code for 6809

do.bat
rem
rem
rem

rem building ssing Tiny C 
rem .\tcc-0.9.27-win64-bin\virtual-multicomp-master\virtual6809

..\..\tcc\tcc.exe virtual.c 6809v.c

pause

virtual.exe -hex ExBasROM.hex
pause

virtual.exe -s19 doug.s19
pause

