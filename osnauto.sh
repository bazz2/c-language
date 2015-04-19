#!/bin/bash


if [ -z $1 ]; then 
  echo "Fatal: need an arg"
  exit
fi


if [ "$1" == "osncdpagt/" ]; then
  # you need edit 'Release' line in 'osncdpagt_ora11g.spec' firstly
  NAME=osncdpagt-ora11g-6.0.0_11.2.0.3
  BUILD=5
  DESTIP=192.168.3.30
  
  scp -r /root/git/osncdpagt/* $DESTIP:/usr/src/redhat/SOURCES/$NAME/

elif [ "$1" == "hostmirror/" ]; then
  hm_5_x86_64=y
  hm_5_i386=y
  hm_6_x86_64=y
  hm_6_i386=y
  hm_5_i386_PAE=y
  # you need edit 'Release' line in 'osn-linux-hostmirror.spec' firstly
  NAME=osn-linux-hostmirror
  NAME_PAE=osn-linux-hostmirror-PAE
  VERSION=1.3.0
  RELEASE=134
  rm -rf /root/rpmbuild/SOURCES/$NAME/*
  cp -r /root/git/hostmirror/* /root/rpmbuild/SOURCES/$NAME/
  cd /root/rpmbuild/SOURCES/
  tar -zcvf $NAME.tar.gz $NAME
  rm -rf /root/rpmbuild/SPECS/$NAME-*
  cp /root/git/hostmirror/SPECS/$NAME-*.spec /root/rpmbuild/SPECS/
  rpmbuild -bs /root/rpmbuild/SPECS/$NAME-5.spec
  rpmbuild -bs /root/rpmbuild/SPECS/$NAME-6.spec
  if [ $hm_5_x86_64 = "y" ]; then
    #
    # hostmirror-5 x86_64
    DESTIP=192.168.3.30
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el5.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      rm -rf /opt/hostmirror.rpm/el5_x86_64
      mkdir -p /opt/hostmirror.rpm/el5_x86_64
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.el5.src.rpm && rpmbuild -ba /usr/src/redhat/SPECS/osn-linux-hostmirror-5.spec && scp /usr/src/redhat/RPMS/x86_64/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hostmirror.rpm/el5_x86_64"
	fi
  fi
  if [ $hm_5_i386 = "y" ]; then
    #
    # hostmirror-5 i386
    DESTIP=192.168.3.31
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el5.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      rm -rf /opt/hostmirror.rpm/el5_i386
      mkdir -p /opt/hostmirror.rpm/el5_i386
      mkdir /opt/hm_5_i386 >/dev/null 2>&1
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.el5.src.rpm && rpmbuild -ba /usr/src/redhat/SPECS/osn-linux-hostmirror-5.spec && scp /usr/src/redhat/RPMS/i386/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hostmirror.rpm/el5_i386"
    fi
  fi
  if [ $hm_5_i386_PAE = "y" ]; then
    #
    # hostmirror-PAE-5
    DESTIP=192.168.3.34
    rpmbuild -bs /root/rpmbuild/SPECS/$NAME_PAE-5.spec
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.PAE.el5.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      rm -rf /opt/hostmirror.rpm/el5_i386_PAE
      mkdir -p /opt/hostmirror.rpm/el5_i386_PAE
      mkdir /opt/hm_5_i386_PAE >/dev/null 2>&1
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.PAE.el5.src.rpm && rpmbuild -ba /usr/src/redhat/SPECS/osn-linux-hostmirror-PAE-5.spec && scp /usr/src/redhat/RPMS/i386/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hostmirror.rpm/el5_i386_PAE"
    fi
  fi
  if [ $hm_6_x86_64 = "y" ]; then
    #
    # hostmirror-6 x86_64
    DESTIP=192.168.3.32
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el6.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      rm -rf /opt/hostmirror.rpm/el6_x86_64
      mkdir -p /opt/hostmirror.rpm/el6_x86_64
      mkdir /opt/hm_6_x86_64 >/dev/null 2>&1
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.el6.src.rpm && rpmbuild -ba /root/rpmbuild/SPECS/osn-linux-hostmirror-6.spec && scp /root/rpmbuild/RPMS/x86_64/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hostmirror.rpm/el6_x86_64"
    fi
  fi
  if [ $hm_6_i386 = "y" ]; then
    #
    # hostmirror-6 i386
    DESTIP=192.168.3.33
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el6.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      rm -rf /opt/hostmirror.rpm/el6_i386
      mkdir -p /opt/hostmirror.rpm/el6_i386
      mkdir /opt/hm_6_i386 >/dev/null 2>&1
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.el6.src.rpm && rpmbuild -ba /root/rpmbuild/SPECS/osn-linux-hostmirror-6.spec && scp /root/rpmbuild/RPMS/i386/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hostmirror.rpm/el6_i386"
    fi
  fi

elif [ "$1" == "osnstreamer/" ]; then
  st_srv=y
  st_cli=y
  # you need edit 'Release' line in 'osnstm.spec' firstly
  VERSION=6.0.0
  CLI_NAME=osnstm_client
  CLI_RELEASE=69
  SRV_NAME=osnstm
  SRV_RELEASE=74
  REPO_DIR=/opt/osnstreamer

  if [ $st_cli = "y" ]; then
    rm -rf /root/rpmbuild/SOURCES/$CLI_NAME-$VERSION/*
    cp -r /root/git/osnstreamer/LClient/ /root/git/osnstreamer/Server/ /root/rpmbuild/SOURCES/$CLI_NAME-$VERSION >/dev/null 2>&1
    rm -rf /root/rpmbuild/SPECS/$CLI_NAME-*
    cp /root/git/osnstreamer/LClient/spec/* /root/rpmbuild/SPECS/
    cd /root/rpmbuild/SOURCES/
    tar -zcvf $CLI_NAME-$VERSION.tar.gz $CLI_NAME-$VERSION

    rpmbuild -bs /root/rpmbuild/SPECS/$CLI_NAME-5.spec
    scp /root/rpmbuild/SRPMS/$CLI_NAME-$VERSION-$CLI_RELEASE.el5.src.rpm root@192.168.3.30:/opt
    scp /root/rpmbuild/SRPMS/$CLI_NAME-$VERSION-$CLI_RELEASE.el5.src.rpm root@192.168.3.31:/opt
    rpmbuild -bs /root/rpmbuild/SPECS/$CLI_NAME-6.spec
    scp /root/rpmbuild/SRPMS/$CLI_NAME-$VERSION-$CLI_RELEASE.el6.src.rpm root@192.168.3.32:/opt
    scp /root/rpmbuild/SRPMS/$CLI_NAME-$VERSION-$CLI_RELEASE.el6.src.rpm root@192.168.3.33:/opt

    if [ $collect ]; then 
      ssh $DESTIP "rpm -ivh /opt/$CLI_NAME-$VERSION-$CLI_RELEASE.el6.src.rpm && rpmbuild -ba /root/rpmbuild/SPECS/$CLI_NAME-5.spec && scp /root/rpmbuild/RPMS/x86_64/$CLI_NAME-$VERSION-$CLI_RELEASE* $LOCAL_ADDR:$REPO_DIR"
    fi
  fi

  if [ $st_srv = "y" ]; then
    echo "$SRV_NAME-$VERSION-$SRV_RELEASE"
    rm -rf /root/rpmbuild/SOURCES/Server
    cp -r /root/git/osnstreamer/Server/ /root/rpmbuild/SOURCES/ >>/dev/null 2>&1
    rm -rf /root/rpmbuild/SPECS/$SRV_NAME.spec
    cp /root/git/osnstreamer/Server/spec/* /root/rpmbuild/SPECS/
    cd /root/rpmbuild/SOURCES/
    tar -zcvf $SRV_NAME.tar.gz Server

    rpmbuild -bs /root/rpmbuild/SPECS/$SRV_NAME.spec
    scp /root/rpmbuild/SRPMS/$SRV_NAME-$VERSION-$SRV_RELEASE.*.src.rpm root@192.168.3.98:/opt
  fi

elif [ "$1" == "osndisk/" ]; then
  # you need edit 'Release' line in 'osndisk.spec' firstly
  NAME=osndisk
  VERSION=1.1
  RELEASE=26
  rm -rf /root/rpmbuild/SOURCES/$NAME*
  mkdir /root/rpmbuild/SOURCES/$NAME-$VERSION
  cp -r /root/git/$NAME/* /root/rpmbuild/SOURCES/$NAME-$VERSION/
  cd /root/rpmbuild/SOURCES/
  tar -zcvf $NAME-$VERSION.tar.gz $NAME-$VERSION

  rm -f /root/rpmbuild/SPECS/$NAME*
  cp /root/git/$NAME/spec/$NAME* /root/rpmbuild/SPECS/

  rpmbuild -bs /root/rpmbuild/SPECS/$NAME-5.spec
#  scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el5.src.rpm root@192.168.3.30:/opt
  scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el5.src.rpm root@192.168.3.31:/opt
#  rpmbuild -ba /root/rpmbuild/SPECS/$NAME-6.spec
#  scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el6.src.rpm root@192.168.3.32:/opt
#  scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.el6.src.rpm root@192.168.3.33:/opt


else
  echo "Unknown parameter"
  exit
fi

