rem
rem do.bat - build as9
rem
rem do not use Tiny C tcc-0.9.27-win64-bin as the source code need some work
rem
rem Use Tiny C tcc-0.9.26-win64-bin 
rem unzip as9.zip
cd as9
pause
rem C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6809\as9
rem unzip as9.zip
..\..\..\tcc as9.c
pause

copy as9.exe ..
cd .. 
pause

rem Build doug.asm into folder
as9 doug.asm -l s19
pause
 rem copy as9.exe to 6809
 