#!/bin/bash
# Author: Tomas Matejicek <http://www.linux-live.org>

if [ "$1" = "" -o ! -b "$2"  -o ! -b "$3" ]; then
  echo "Copy all files from LiveCD to USB flashdisk."
  echo "usage:   $0 [ data_dir | livecd.iso ] [ partition ] [ mbr ]"
  echo "example: $0 . /dev/sda1 /dev/sda"
  exit
fi

DATADIR="$1"
MOUNTPOINT=/tmp/mountpoint$$
TMPLILOCONF=/tmp/lilo$$.conf

# mount iso if not already mounted
if [ ! -d "$DATADIR" ]; then
   DATADIR=/tmp/livecd_data$$
   mkdir -p "$DATADIR"
   mount -o loop "$1" "$DATADIR"
   if [ ! "$?" = "0" ]; then echo "error mounting $1 to $DATADIR"; exit; fi
fi

mkdir -p $MOUNTPOINT
mount $2 $MOUNTPOINT
if [ ! "$?" = "0" ]; then echo "error mounting $2"; exit; fi

cp -R "$DATADIR"/* "$MOUNTPOINT"
APPEND="`cat $DATADIR/isolinux.cfg | grep append | cut -b 7-`"

echo "
boot = $3
prompt
timeout = 30
vga = normal
message = $MOUNTPOINT/splash
map = $MOUNTPOINT/lilo.map
install = text

# Linux bootable partition config begins
image = $MOUNTPOINT/vmlinuz
root = /dev/ram0
label = slax
initrd = $MOUNTPOINT/initrd.gz
read-write
append=\" usbdisk $APPEND \" " >$TMPLILOCONF

lilo -v -C $TMPLILOCONF

umount $DATADIR 2>/dev/null >/dev/null
if [ "$?" = "0" ]; then rmdir $DATADIR; fi

umount $MOUNTPOINT
rmdir $MOUNTPOINT

echo "LiveCD is installed in $3"
