#!/bin/bash
# ---------------------------------------------------
# Script to create bootable ISO in Linux
# usage: make_iso.sh /tmp/slax.iso
# author: Tomas M. <http://www.linux-live.org>
# ---------------------------------------------------

CDLABEL="SLAX"

if [ "$1" = "" -o "$1" = "--help" -o "$1" = "-h" ]; then
  echo "This script will create bootable ISO from files in curent directory."
  echo "Current directory must be writable."
  echo "example: $0 /mnt/hda5/slax.iso"
  exit
fi

# isolinux.bin is changed during the ISO creation,
# so we need to restore it from backup.
cp -f boot/isolinux.bi_ boot/isolinux.bin
if [ $? -ne 0 ]; then
   echo "Can't recreate isolinux.bin, make sure your current directory is writable!"
   exit 1
fi

mkisofs -o "$1" -v -J -R -D -A "$CDLABEL" -V "$CDLABEL" \
-no-emul-boot -boot-info-table -boot-load-size 4 \
-b boot/isolinux.bin -c boot/isolinux.boot .
