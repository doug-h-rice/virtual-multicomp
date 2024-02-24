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
 
rem build Virtual 6809
rem
rem C:\Users\Redtop\Desktop\tcc-0.9.26-win64-bin\tcc\virtual-multicomp-master\virtual6809
rem
rem 

..\..\tcc virtual.c 6809v.c
pause

rem run 6809
virtual doug.s19
pause 

rem
rem Build doug.asm and run it
rem
as9 doug.asm -l s19
pause
virtual doug.s19
pause 
