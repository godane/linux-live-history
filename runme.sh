#!/bin/bash
#
# run this script to create a LiveCD in /tmp/livecd.iso
# Your kernel image has to be in $ROOT/boot/vmlinuz or $ROOT/vmlinuz
#

export PATH=.:./tools:../tools:/usr/sbin:/usr/bin:/sbin:/bin:/

CHANGEDIR="`dirname \`readlink -f $0\``"
echo "Changing current directory to $CHANGEDIR"
cd $CHANGEDIR

. ./config || exit 1
./install $ROOT

. liblinuxlive || exit 1

# only root can continue, because only root can read all files from your system
allow_only_root


# search for kernel
VMLINUZ=$ROOT/boot/vmlinuz
if [ -L "$VMLINUZ" ]; then VMLINUZ=`readlink -f $VMLINUZ`; fi
echo -ne "Enter path for the kernel you wanna use [hit enter for $VMLINUZ]: "
read NEWKERNEL
if [ "$NEWKERNEL" != "" ]; then VMLINUZ="$NEWKERNEL"; fi
if [ "`ls $VMLINUZ 2>>$DEBUG`" = "" ]; then echo "cannot find $VMLINUZ"; exit 1; fi

header "Creating LiveCD from your Linux"
echo "some debug information can be found in $DEBUG"

mkdir -p $CDDATA/base
mkdir -p $CDDATA/modules
mkdir -p $CDDATA/optional
mkdir -p $CDDATA/rootcopy
mkdir -p $CDDATA/tools

echo "copying cd-root to $CDDATA, using kernel from $VMLINUZ"
echo "Using kernel modules from /lib/modules/$KERNEL"
cp -R cd-root/* $CDDATA
cp tools/* $CDDATA/tools
cp -R DOC/* $CDDATA
cp $VMLINUZ $CDDATA/boot/vmlinuz

echo "creating initrd image..."
cd initrd
./initrd_create
if [ "$?" -ne 0 ]; then exit; fi
cd ..

cp initrd/$INITRDIMG.gz $CDDATA/boot/initrd.gz
rm initrd/$INITRDIMG.gz

echo "creating compressed images..."

for dir in $MKMOD; do
    if [ -d $ROOT/$dir ]; then
      echo "base/$dir.mo"
      create_module $ROOT/$dir $CDDATA/base/$dir.mo -keep-as-directory
      if [ $? -ne 0 ]; then exit; fi
    fi
done



echo "creating LiveCD ISO image..."
cd $CDDATA
./make_iso.sh /tmp/livecd.iso

cd /tmp
header "Your ISO is created in /tmp/livecd.iso"
