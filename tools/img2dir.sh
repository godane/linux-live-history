#!/bin/bash
# convert IMG compressed file back into directory tree
#
# Author: Tomas Matejicek <http://www.linux-live.org>
#

if [ ! -d "$2" ]; then
   echo "usage: $0 source_file.img output_directory"
   exit 1
fi

. ../initrd/functions

TMPFILE=`tempfile`
TMPDIR=`tempfile`
rm $TMPDIR
mkdir $TMPDIR

mkzftree -u -F "$1" $TMPFILE
mount -o loop $TMPFILE $TMPDIR
cp -R $TMPDIR/* "$2"
umount $TMPDIR
rm $TMPFILE
