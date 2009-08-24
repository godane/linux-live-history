#!/bin/bash
# convert directory tree into IMG compressed file
# which can be used as a LiveCD module
#
# Author: Tomas Matejicek <http://www.linux-live.org>
#

if [ ! -d "$1" -o "$2" = "" ]; then
   echo "usage: $0 source_directory output_file.img"
   exit 1
fi

. ../initrd/functions

mkciso "$1" "$2"
if [ $? != 0 ]; then echo "error building compressed image"; exit; fi
