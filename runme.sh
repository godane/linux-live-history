#!/bin/bash
#
# run this script to create a LiveCD in /tmp/livecd.iso
# Your kernel image has to be in /boot/vmlinuz or /vmlinuz
#

export PATH=.:..:./tools:../tools:/usr/sbin:/usr/bin:/sbin:/bin:/

CHANGEDIR="`dirname \`readlink -f $0\``"
echo "Changing current directory to $CHANGEDIR"
cd $CHANGEDIR
./install

. liblinuxlive || exit 1
. config || exit 1

mkmod()
{  echo "processing $1..."; 
   if [ -d "$1" ]; then mkciso $1 $CDDATA/base/$1.img data/$1; fi
}


VMLINUZ=/boot/vmlinuz
if [ -L "$VMLINUZ" ]; then VMLINUZ=`dirname $VMLINUZ`/`readlink $VMLINUZ`; fi
if [ "`ls $VMLINUZ 2>/dev/null`" = "" ]; then echo "cannot find /boot/vmlinuz"; exit 1; fi

header "Creating LiveCD from your Linux"

echo "creating initrd image..."
cd initrd
./initrd_create
cd ..

mkdir -p $CDDATA/base
mkdir -p $CDDATA/modules
mkdir -p $CDDATA/packs
mkdir -p $CDDATA/optional
mkdir -p $CDDATA/devel

echo "copying boot files to $CDDATA..."
cp initrd/$INITRDIMG.gz $CDDATA/initrd.gz
rm initrd/$INITRDIMG.gz
cp -R bootfiles/* $CDDATA
cp -R {info,tools} $CDDATA
touch $CDDATA/livecd.sgn # just to be sure it's there

echo "creating compressed images (.img)..."
mkmod /bin
mkmod /lib
mkmod /opt
mkmod /usr
mkmod /sbin

echo "copying kernel from $VMLINUZ..."
cp $VMLINUZ $CDDATA/vmlinuz

# these directories have to be packed (tar.gz) because
# it's not possible to overmount them by ovlfs 
# (ovlfs has some problems with file locking)
echo "compressing /etc /home /root /var..."
tar -C / -c root | gzip -f --best >$CDDATA/packs/root.tar.gz
tar -C / -c etc | gzip -f --best >$CDDATA/packs/etc.tar.gz
tar -C / -c home | gzip -f --best >$CDDATA/packs/home.tar.gz
tar -C / -c var | gzip -f --best >$CDDATA/packs/var.tar.gz

echo "creating LiveCD ISO image..."
cd $CDDATA
./create_bootiso.sh /tmp/livecd.iso

cd /tmp
header "Your ISO is created in /tmp/livecd.iso"
