#!/bin/bash
# Create bootable ISO from files in curent directory.
# usage: create_bootiso /mnt/disk/freespace/resultFilename.iso
# Author: Tomas Matejicek <http://www.linux-live.org>
#

CDLABEL="SLAX"

if [ "$1" = "" -o "$1" = "--help" -o "$1" = "-h" ]; then
  echo "This script will create bootable ISO from files in curent directory."
  echo "example: $0 /mnt/hda5/slax.iso"
  exit
fi

# isolinux.bin is changed during the ISO creation,
# so we need to restore it from backup.
gunzip -c isolinux.bin.gz >isolinux.bin

mkisofs -o "$1" -v -J -R -D -A "$CDLABEL" -V "$CDLABEL" \
-no-emul-boot -boot-info-table -boot-load-size 4 \
-b isolinux.bin -c isolinux.boot .
