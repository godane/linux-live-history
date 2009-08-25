@ECHO OFF
REM  ----------------------------------------------------
REM  Batch file to create bootable ISO in Windows
REM  usage: make_iso.bat c:\new-slax.iso
REM  author: Tomas M. <http://www.linux-live.org>
REM  ----------------------------------------------------

if "%1"=="" goto error1

set CDLABEL=SLAX

REM  isolinux.bin is changed during the ISO creation,
REM  so we need to restore it from backup.
copy /Y boot\isolinux.bi_ boot\isolinux.bin
if not "%errorlevel%"=="0" goto error2

tools\WIN\mkisofs.exe @tools\WIN\config -o "%1" -A "%CDLABEL%" -V "%CDLABEL%" .
goto theend

:error1
echo A parameter is required - target ISO file.
echo Example: %0 c:\target.iso
goto theend

:error2
echo Can't recreate isolinux.bin, make sure your current directory is writable!
goto theend

:theend
echo.
echo New ISO should be created now.
pause
