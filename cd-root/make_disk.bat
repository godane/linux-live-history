@ECHO OFF
REM  ----------------------------------------------------
REM  Batch file to create bootable SLAX disk in Windows
REM  usage: make_disk.bat e:\
REM  author: Tomas M. <http://www.linux-live.org>
REM  ----------------------------------------------------

if "%1"=="" goto error1

echo Copying files to %1 ...

xcopy * "%1\" /I /R /E /Y >NUL
if not "%errorlevel%"=="0" goto error2
move /Y "%1\base\vmlinuz" "%1\vmlinuz"
if not "%errorlevel%"=="0" goto error2
move /Y "%1\base\initrd.gz" "%1\initrd.gz"
if not "%errorlevel%"=="0" goto error2
copy /Y tools\WIN\syslinux.cfg "%1\" >NUL
if not "%errorlevel%"=="0" goto error2

echo Setting up boot sector in %1
tools\WIN\syslinux.exe -ma "%1"
if not "%errorlevel%"=="0" goto error3

echo.
echo Successfully installed into %1
goto theend

:error1
echo A parameter is required - target disk name.
echo Example: %0 D:\
goto theend

:error2
echo Error while copying files. Out of disk space? Don't know
goto theend

:error3
echo Error setting up boot sector. The OS won't boot
goto theend

:theend
pause
