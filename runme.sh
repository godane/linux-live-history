#!/bin/bash
#
# run this script to create a LiveCD in /tmp/livecd.iso
# Your kernel image has to be in /boot/vmlinuz or /vmlinuz
#

. ./initrd/functions
. ./config

VMLINUZ=/boot/vmlinuz
if [ -L "$VMLINUZ" ]; then VMLINUZ=`dirname $VMLINUZ`/`readlink $VMLINUZ`; fi
if [ "`ls $VMLINUZ 2>/dev/null`" = "" ]; then echo "cannot find vmlinuz, exiting."; exit; fi

header "Creating LiveCD from your Linux"

echo "creating initrd image..."
cd initrd
./initrd_create
cd ..

mkdir -p $CDDATA/base

echo "copying boot files to $CDDATA..."
cp initrd/$INITRDIMG.gz $CDDATA/initrd.gz
rm initrd/$INITRDIMG.gz
cp -R bootfiles/* $CDDATA
cp -R {info,tools} $CDDATA
touch $CDDATA/livecd.flag # just to be sure it's there

echo "creating compressed images (.img)..."
if [ -d "/bin" ]; then mkciso /bin $CDDATA/base/bin.img /bin; fi
if [ -d "/lib" ]; then mkciso /lib $CDDATA/base/lib.img /lib; fi
if [ -d "/opt" ]; then mkciso /opt $CDDATA/base/opt.img /opt; fi
if [ -d "/usr" ]; then mkciso /usr $CDDATA/base/usr.img /usr; fi
if [ -d "/sbin" ]; then mkciso /sbin $CDDATA/base/sbin.img /sbin; fi

echo "copying kernel from $VMLINUZ..."
cp $VMLINUZ $CDDATA/vmlinuz

mkdir -p $CDDATA/modules
mkdir -p $CDDATA/packs
mkdir -p $CDDATA/lang
tar -C / -c root | gzip -f --best >$CDDATA/packs/root.tar.gz
tar -C / -c etc | gzip -f --best >$CDDATA/packs/etc.tar.gz
tar -C / -c var | gzip -f --best >$CDDATA/packs/var.tar.gz

echo "creating LiveCD ISO image..."
cd $CDDATA
./create_bootiso /tmp/livecd.iso

cd /tmp
header "Your ISO is created in /tmp/livecd.iso"
