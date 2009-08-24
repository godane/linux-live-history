#!/bin/bash
# convert Slackware's TGZ package into IMG compressed file
# which can be used as a LiveCD module
#
# Author: Tomas Matejicek <http://www.linux-live.org>
#

if [ "$1" = "" -o "$2" = "" ]; then
   echo "usage: $0 source_filename.tgz output_file.img"
   exit 1
fi

. ../initrd/functions

TMPDIR=/tmp/tgz2img$$

mkdir -p $TMPDIR/{bin,etc/rc.d,lib,sbin,var,usr/bin,usr/sbin,usr/lib}
installpkg -root $TMPDIR $1
if [ $? != 0 ]; then echo "error installing package"; exit; fi
rm -Rf $TMPDIR/var/log/{packages,removed_packages,removed_scripts,scripts}
rm -Rf $TMPDIR/usr/doc
rmdir --ignore-fail-on-non-empty $TMPDIR/{bin,etc/rc.d,lib,sbin,var,usr/bin,usr/sbin,usr/lib}

mkciso $TMPDIR "$2"
if [ $? != 0 ]; then echo "error building compressed image"; exit; fi

rm -Rf $TMPDIR
