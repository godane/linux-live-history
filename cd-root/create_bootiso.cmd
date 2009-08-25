@ECHO OFF
REM  ----------------------------------------------------
REM  Batch file For MS Windows
REM  Create bootable ISO from files in curent directory.
REM  usage: create_bootiso \slax.iso
REM  Author: Tomas M. <http://www.linux-live.org>
REM  ----------------------------------------------------

if "%1"=="" goto error1

set CDLABEL=SLAX

REM  isolinux.bin is changed during the ISO creation,
REM  so we need to restore it from backup.
copy isolinux.bi_ isolinux.bin
if not "%errorlevel%"=="0" goto error2

WIN\mkisofs.exe -o "%1" -v -J -R -D -A "%CDLABEL%" -V "%CDLABEL%" -no-emul-boot -boot-info-table -boot-load-size 4 -b isolinux.bin -c isolinux.boot .

:error1
echo A parameter is required - target ISO file.
echo Example: %0 c:\target.iso
goto theend

:error2
echo Can't recreate isolinux.bin, make sure your current directory is writable!
goto theend

:theend
echo.
pause
