#!/bin/bash

SUB_VER=1.3
ISO_PROJ="infonix-6.4-x86_64"
ISO_NAME="infonix-6.4.$SUB_VER-x86_64.iso"

#rm -f /opt/$ISO_PROJ/images/install.img
#mksquashfs /opt/infomaterial/squashfs-root /opt/$ISO_PROJ/images/install.img

mv -f /opt/$ISO_PROJ/repodata/*comps.xml /opt/$ISO_PROJ/repodata/comps.xml
createrepo -g /opt/$ISO_PROJ/repodata/comps.xml /opt/$ISO_PROJ/
mkisofs -o /opt/public/$ISO_NAME -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -joliet-long -R -J -v -T /opt/$ISO_PROJ/

