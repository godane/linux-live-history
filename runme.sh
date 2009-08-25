#!/bin/bash
#
# run this script to create a LiveCD in /tmp/livecd.iso
# Your kernel image has to be in $ROOT/boot/vmlinuz or $ROOT/vmlinuz
# 

export PATH=.:./tools:../tools:/usr/sbin:/usr/bin:/sbin:/bin:/

CHANGEDIR="`dirname \`readlink -f $0\``"
echo "Changing current directory to $CHANGEDIR"
cd $CHANGEDIR

. liblinuxlive || exit 1
. config || exit 1

./install $ROOT

VMLINUZ=$ROOT/boot/vmlinuz
if [ -L "$VMLINUZ" ]; then VMLINUZ=`dirname $VMLINUZ`/`readlink $VMLINUZ`; fi
if [ "`ls $VMLINUZ 2>/dev/null`" = "" ]; then echo "cannot find $VMLINUZ"; exit 1; fi

header "Creating LiveCD from your Linux"

echo "Using kernel from $VMLINUZ"
echo "Using kernel modules from /lib/modules/$KERNEL"
echo "creating initrd image..."
cd initrd
./initrd_create
if [ "$?" -ne 0 ]; then exit; fi
cd ..

mkdir -p $CDDATA/base
mkdir -p $CDDATA/modules
mkdir -p $CDDATA/optional
mkdir -p $CDDATA/devel

echo "copying boot files to $CDDATA..."
cp initrd/$INITRDIMG.gz $CDDATA/initrd.gz
rm initrd/$INITRDIMG.gz
cp -R bootfiles/* $CDDATA
cp -R {info,tools} $CDDATA

echo "creating compressed image base.mo..."
mksquashfs $ROOT/bin $ROOT/etc $ROOT/home $ROOT/lib $ROOT/opt \
           $ROOT/root $ROOT/usr $ROOT/sbin $ROOT/var \
           $CDDATA/base/base.mo
if [ $? -ne 0 ]; then exit; fi

chmod oga-x $CDDATA/base/base.mo

echo "copying kernel from $VMLINUZ..."
cp $VMLINUZ $CDDATA/vmlinuz

echo "creating LiveCD ISO image..."
cd $CDDATA
./create_bootiso.sh /tmp/livecd.iso

cd /tmp
header "Your ISO is created in /tmp/livecd.iso"
