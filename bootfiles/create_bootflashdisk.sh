#!/bin/bash
# Author: Tomas Matejicek <http://www.linux-live.org>

echo "this doesn't work yet"
exit

if [ "$1" = "" -o ! -b "$2" ]; then
  echo "This script will copy all files from current directory to USB flashdisk."
  echo "You should call it from the mounted CD directory."
  echo "example: $0 livecd.iso|data_dir /dev/sda1"
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
fi

mkdir -p $MOUNTPOINT
mount $2 $MOUNTPOINT
if [ ! "$?" = "0" ]; then
   echo "error mounting $2";
   exit
fi

cp -R "$DATADIR"/* "$MOUNTPOINT"


echo -n "
boot = $2
prompt
lba32
timeout = 300
install = text
message = $MOUNTPOINT/splash

image = $MOUNTPOINT/vmlinuz
label = slax

append=" >$TMPLILOCONF


#max_loop=255 initrd=initrd.gz init=linuxrc livecd_subdir=/ load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=7777 root=/dev/ram0 rw"


umount $DATADIR 2>/dev/null >/dev/null
if [ "$?" = "0" ]; then rmdir $DATADIR; fi

umount $MOUNTPOINT
rmdir $MOUNTPOINT