REM #########################################################################
REM  DOS batch file to boot Linux.

REM  First, ensure any unwritten disk buffers are flushed:
@smartdrv /C

REM  Start the LOADLIN process:
cls
loadlin \vmlinuz initrd=\initrd.gz livecd_subdir=/ root=/dev/ram0 load_ramdisk=1 ramdisk_size=7777 rw %1 %2 %3

REM #########################################################################