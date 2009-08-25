#!/usr/bin/php
# re-run this script as often as possible (e.g. daily)
# It will update pci.ids to recognize USB controllers
<?
   $url='http://pciids.sourceforge.net/pci.ids';
   
   $ids="# Hacked list of PCI ID's for 'lspci' command for linux live scripts.\n";
   $ids.="# This list only contains [EUO]HCI controllers from $url\n";
   $ids.="# It's used only in Linux Live scripts during system startup\n";
   $ids.="# to recognize which USB controllers should be loaded (EHCI | OHCI | UHCI).\n";
   $ids.="#\n";

   $pci=file($url);
   foreach($pci as $line)
   {
      if (!ereg("^\t",$line)) $h0=$line;
      if (ereg("^\t[^\t]",$line)) $h1=$line;
      if (eregi("[euo]hci",$line))
      {
          if ($lasth0!=$h0) { $ids.=$h0; $lasth0=$h0; }
          if ($lasth1!=$h1) { $ids.=$h1; $lasth1=$h1; }
          if ($line!=$lasth0 && $line!=$lasth1) $ids.=$line;
      }
   }

   file_put_contents('pci.ids',$ids);
?>