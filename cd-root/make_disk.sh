#!/bin/bash
# Batch file to create bootable SLAX disk
# usage: make_disk.sh /dev/sda1 # (must be the partition)
# WARNING! boot sector of the device will be OVERWRITTEN!
# author: Tomas M. <http://www.linux-live.org>

if [ "$1" = "" ]; then
  echo "usage: $0 partition_device"
  echo "example: $0 /dev/sda1"
  exit 1
fi

PART="$1"
BOOT="`echo \"$PART\" | sed -r \"s/[0-9]+\\\$//\"`"

TMPDIR=/mnt/makedisk_mount$$
echo "Mounting $PART to $TMPDIR..."
mkdir -p $TMPDIR
mount "$PART" $TMPDIR
if [ $? -ne 0 ]; then exit 1; fi

echo "Copying files..."
cp -a ./* "$TMPDIR"
if [ $? -ne 0 ]; then exit 1; fi
sync

echo "Setting up boot sector in $BOOT..."
echo "boot=$BOOT
compact
lba32
vga=769
prompt
timeout=20
install=text

image=$TMPDIR/boot/vmlinuz
initrd=$TMPDIR/boot/initrd.gz
label=slax
root=/dev/ram0
append=\"max_loop=255 init=linuxrc load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=4444\"
read-write
" >$TMPDIR/lilo.conf
lilo -C $TMPDIR/lilo.conf -m $TMPDIR/lilo.map -s $TMPDIR/origmbr 2>&1 | grep -vi warning
if [ $? -ne 0 ]; then exit 1; fi

umount $TMPDIR
rmdir $TMPDIR
echo "Successfully installed in $1"
