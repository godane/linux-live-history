#!/bin/bash
exit
# ---------------------------------------------------
# Script to create bootable SLAX disk in Linux
# usage: make_disk.sh /dev/partition
# author: Tomas M. <http://www.linux-live.org>
# ---------------------------------------------------

if [ "$1" = "--help" -o "$1" = "-h" -o ! -b "$1" ]; then
  echo "This script will create bootable SLAX disk from files in curent directory."
  echo "example: $0 /dev/hda1"
  exit 1
fi

MOUNT=/tmp/makedisk_$$
mkdir -p $MOUNT

mount "$1" $MOUNT
if [ $? -ne 0 ]; then exit 1; fi
echo "Copying files to $1"
cp -R . $MOUNT
if [ $? -ne 0 ]; then exit 1; fi
umount $MOUNT
if [ $? -ne 0 ]; then exit 1; fi
rmdir $MOUNT

echo "Setting up boot record for $1"
DISK=`echo $1 | cut -b 1-8`
echo "aaaaaaa" >$MOUNT.lilo.conf
lilo -C $MOUNT.lilo.conf -S /dev/null

echo "Successfully installed in $1"
