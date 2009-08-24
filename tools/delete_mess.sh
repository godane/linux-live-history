#!/bin/bash
#
# delete_mess:  remove all files from installed slackware distribution
#               which are useless for me
#               (docs, localization, includes, ...)
#
# Author:       Tomas Matejicek <http://www.linux-live.org>
#
# This script is unsafe; run it only if you know what you are doing!
# It will delete files from your disk which may be useful for you!
# You have to chmod 0744 it to let it be executable
#
ROOT=
rm -Rf $ROOT/usr/doc/*
rm -Rf $ROOT/etc/X11/app-defaults/*
rm -Rf $ROOT/usr/include/*
rm -Rf $ROOT/usr/man/{??,??_??}
rm -Rf $ROOT/usr/share/gtk-doc/*
rm -Rf $ROOT/usr/share/i18n/*
rm -Rf $ROOT/usr/share/locale/*
rm -Rf $ROOT/usr/share/gnome/html/gdk-pixbuf/*
rm -Rf $ROOT/usr/share/mc/mc.hlp.??
rm -Rf $ROOT/usr/share/mc/mc.hint.??
rm -Rf $ROOT/usr/X11R6/share/ImageMagick*/*
rm -Rf $ROOT/usr/X11R6/LessTif/*
rm -Rf $ROOT/usr/X11R6/include/*
rm -Rf $ROOT/usr/X11R6/lib/X11/icons/*
rm -Rf $ROOT/usr/X11R6/lib/X11/xedit/*
rm -Rf $ROOT/usr/X11R6/lib/X11/doc/*
rm -Rf $ROOT/usr/X11R6/lib/X11/locale/*
rm -Rf $ROOT/usr/lib/perl5/*/{pod,Pod}/*
rm -Rf $ROOT/usr/lib/qt/examples/*
rm -Rf $ROOT/usr/lib/qt/extensions/*
rm -Rf $ROOT/usr/lib/qt/include/*
rm -Rf $ROOT/usr/lib/qt/pics/*
rm -Rf $ROOT/usr/lib/qt/plugins/{src,designer}/*
rm -Rf $ROOT/usr/lib/qt/doc/*
rm -Rf $ROOT/usr/lib/qt/mkspecs/*
rm -Rf $ROOT/usr/lib/qt/tutorial/*
rm -Rf $ROOT/usr/lib/qt/bin/*
rm -Rf $ROOT/usr/lib/locale/locale-archive
rm -Rf $ROOT/usr/lib/bx/help/*
rm -Rf $ROOT/usr/share/ghostscript/*/{doc,examples}/*
rm -Rf $ROOT/usr/bin/gs-no-x11
rm -Rf $ROOT/opt/kde/share/doc/*
rm -Rf $ROOT/opt/kde/share/apps/kthememgr/Themes/*
rm -Rf $ROOT/opt/kde/bin/*.kss
rm -Rf $ROOT/opt/kde/share/wallpapers/*
rm -Rf $ROOT/opt/kde/include/*
rm -Rf $ROOT/opt/kde/share/locale/*/*/*.desktop
rm -Rf $ROOT/opt/kde/share/locale/all_languages
rm -Rf $ROOT/opt/kde/share/sounds/KDE_*
rm -Rf $ROOT/opt/kde/share/apps/kworldclock/*
rm -Rf $ROOT/opt/kde/share/apps/ksgmltools2/customization/*
rm -Rf $ROOT/opt/kde/share/apps/ksgmltools2/docbook/*
rm -Rf $ROOT/opt/kde/share/icons/{Locolor,Technical,ikons,kdeclassic,locolor,slick}
rm -Rf $ROOT/var/mail/*
rm -Rf $ROOT/usr/info/*
rm -Rf $ROOT/usr/man/man{2,3,4,6,9}/*
rm -Rf $ROOT/usr/X11R6/man/man{2,3,4,6,9}/*
rm -Rf $ROOT/usr/man/man1/perl?*
rm -Rf $ROOT/etc/cron.daily/*
rm -Rf $ROOT/etc/termcap-BSD
rm -Rf $ROOT/var/log/*
rm -Rf `find $ROOT/ -name *.h`
rm -Rf `find $ROOT/ -name *.c`
rm -Rf `ls $ROOT/usr/X11R6/lib/X11/fonts/75dpi/* 2>/dev/null | grep "-"`

if [ -a $ROOT/usr/man/whatis ]; then
  cat $ROOT/usr/man/whatis | egrep -v "\\(2.?\\)|\\(3.?\\)|\\(4.?\\)|\\(6.?\\)|\\(9.?\\)" >$ROOT/usr/man/whatis.2
  mv -f $ROOT/usr/man/whatis.2 $ROOT/usr/man/whatis
fi

mkfontdir $ROOT/usr/X11R6/lib/X11/fonts/*/ 2>/dev/null
