#!/bin/bash
# Author: Tomas Matejicek <http://www.linux-live.org>

if [ "$1" = "" -o ! -b "$2"  -o ! -b "$3" ]; then
  echo
  echo "Copies all files from LiveCD to your disk and setup lilo"
  echo "usage:   $0 [ data_dir | livecd.iso ] [ partition ] [ mbr ] [[ subdir ]]"
  echo "example: $0 . /dev/sda1 /dev/sda slax"
  exit
fi

DATADIR="$1"
MOUNTPOINT=/tmp/slax_to_disk_$$
TMPLILOCONF=/tmp/lilo$$.conf
SUBDIR="$4"
if [ "$SUBDIR" = "" ]; then SUBDIR="SLAX"; fi

# mount iso if not already mounted
if [ ! -d "$DATADIR" ]; then
   DATADIR=/tmp/livecd_data$$
   mkdir -p "$DATADIR"
   mount -o loop "$1" "$DATADIR"
   if [ ! "$?" = "0" ]; then echo "error mounting $1 to $DATADIR"; exit; fi
fi

# mount partition we wish to copy slax onto
mkdir -p $MOUNTPOINT
mount $2 $MOUNTPOINT
if [ ! "$?" = "0" ]; then echo "error mounting $2"; exit; fi

# copy all files there
mkdir -p $MOUNTPOINT/$SUBDIR
cp -R "$DATADIR"/* "$MOUNTPOINT/$SUBDIR"
gunzip "$MOUNTPOINT/$SUBDIR/splash.bmp.gz"
APPEND="`cat $DATADIR/isolinux.cfg | grep append | head -n 1 | cut -b 7-`"

echo "
boot = $3
prompt
timeout = 50
#install = text
#message = $MOUNTPOINT/$SUBDIR/splash
bitmap = $MOUNTPOINT/$SUBDIR/splash.bmp
map = $MOUNTPOINT/$SUBDIR/lilo.map

# Linux bootable partition config begins
image = $MOUNTPOINT/$SUBDIR/vmlinuz
root = /dev/ram0
label = slax
initrd = $MOUNTPOINT/$SUBDIR/initrd.gz
read-write
append=\" probeusb $APPEND livecd_subdir=$SUBDIR \" " >$TMPLILOCONF

lilo -v -C $TMPLILOCONF -S /dev/null
if [ "$?" = "0" ]; then echo "ERROR installing LILO ! Your drive won't boot" fi

umount $DATADIR 2>/dev/null >/dev/null
if [ "$?" = "0" ]; then rmdir $DATADIR; fi

umount $MOUNTPOINT
rmdir $MOUNTPOINT

echo "LiveCD is installed in $3"
