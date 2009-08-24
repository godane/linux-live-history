#!/bin/bash
# convert Slackware's TGZ language files into IMG compressed file
# which can be used as a LiveCD language module
#
# Author: Tomas Matejicek <http://www.linux-live.org>
#

LANGFILESPATH=/mnt/hd/share/slack91/kdei

if [ "$1" = "" ]; then
   echo "usage: $0 lang"
   exit 1
fi

. ./functions

TMPDIR=/tmp/tgz2img$$

installpkg -root $TMPDIR $LANGFILESPATH/*-$1-*.tgz
if [ $? != 0 ]; then echo "error installing package"; exit; fi
rm -Rf $TMPDIR/var
rm -Rf $TMPDIR/opt/kde/share/doc

mkciso $TMPDIR "$1.img"
if [ $? != 0 ]; then echo "error building compressed image"; exit; fi

rm -Rf $TMPDIR
