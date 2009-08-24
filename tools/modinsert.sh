#!/bin/bash
# Insert module(s) into CD filesystem
# Author: Tomas Matejicek 2004 <http://www.linux-live.org>
#

if [ "$3" = "" ]; then
   echo
   echo "Insert module(s) into CD filesystem"
   echo "Usage: modinsert.sh original_livecd.iso|livecd_data_dir new_iso_file.iso"
   echo "                    modules=./file.mo [ | modules=/tmp/file.mo | lang=en.mo ]"
   echo
   echo "  \$1 = livecd data (mounted CD), or livecd iso image (will be mounted to /tmp/x)"
   echo "  \$2 = new iso file. Full path including filename.iso"
   echo "  \$3 = directory you wish to store your modules into, followed by filename"
   exit
fi

DATADIR="$1"
OUTPUT="$2"
CDNAME="OwnLiveCD"
ISOLINUXBIN=/tmp/isolinux$$.bin

# mount iso if not already mounted
if [ ! -d "$DATADIR" ]; then
   DATADIR=/tmp/livecd_data$$
   mkdir -p "$DATADIR"
   mount -o loop "$1" "$DATADIR"
fi

#remove first 2 parameters, we don't need them any more
shift; shift

# create graft points for new modules
# All of them will be placed in apropriate directories
while [ ! "$1" = "" ]; do
   DIR="`echo \"$1\" | cut -d \"=\" -f 1`"
   FULLPATH="`echo \"$1\" | cut -d \"=\" -f 2`"
   FILE="`basename $FULLPATH`"
   GRAFT="$GRAFT $DIR/$FILE=$FULLPATH"
   shift
done

# isolinux.bin is changed during the ISO creation,
# so we need to restore it from backup.
gunzip -c $DATADIR/isolinux.bin.gz >$ISOLINUXBIN

mkisofs -o "$OUTPUT" -v -J -R -D -A "$CDNAME" -V "$CDNAME" \
-no-emul-boot -boot-info-table -boot-load-size 4 \
-x "$DATADIR/isolinux.bin" -x "$DATADIR/isolinux.boot" \
-b isolinux.bin -c isolinux.boot -graft-points \
isolinux.bin=$ISOLINUXBIN $GRAFT "$DATADIR"

# cleanup all temporary files and directories
rm $ISOLINUXBIN
umount "$DATADIR" 2>/dev/null >/dev/null
if [ "$?" = "0" ]; then rmdir $DATADIR; fi
