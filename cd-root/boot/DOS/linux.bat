@ECHO OFF
REM #########################################################################
REM DOS batch file to boot Linux.

REM First, ensure any unwritten disk buffers are flushed:
@smartdrv /C

REM Start the LOADLIN process:
cls
loadlin @config %1 %2 %3 %4 %5 %6 %7 %8 %9

REM #########################################################################
