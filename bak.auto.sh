#!/bin/bash

build()
{
  if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ] || [ -z $5 ] || [ -z $6 ]; then echo "$0: invalid parameter" && exit; fi

  name=$1
  version=$2
  build=$3
  dest_ip=$4
  os_ver=$5
  os_arch=$6

  rpm_dir=/root/rpmbuild
  if [ $os_ver == "6" ]; then
    dest_rpm_dir=/root/rpmbuild
  elif [ $os_ver == "5" ]; then
    dest_rpm_dir=/usr/src/redhat
  fi
  if [ $name == "osnstm_client" ]; then
    git_dir=/root/git/osnstreamer
    rm -rf $rpm_dir/SOURCES/$name-$version
    rm -rf $rpm_dir/SPECS/$name-*
    rm -rf $rpm_dir/RPMS/$os_arch/$name-* # delete debuginfo.rpm
    rm -rf $rpm_dir/RPMS/$os_arch/Streamer_LClient*
    rm -rf $rpm_dir/SRPMS/$name-*
    mkdir $rpm_dir/SOURCES/$name-$version
    cp -r $git_dir/LClient/ $git_dir/Server/ $rpm_dir/SOURCES/$name-$version >/dev/null 2>&1
    cp $git_dir/LClient/spec/* $rpm_dir/SPECS/
    cd $rpm_dir/SOURCES/
    tar -zcvf $name-$version.tar.gz $name-$version

  elif [ $name == "osnstm" ]; then
    git_dir=/root/git/osnstreamer
    rpm_dir=/root/rpmbuild
    rm -rf $rpm_dir/SOURCES/Server
    rm -rf $rpm_dir/SPECS/$name-*
    rm -rf $rpm_dir/RPMS/$os_arch/$name-*
    rm -rf $rpm_dir/SRPMS/$name-*
    cp -r $git_dir/Server/ $rpm_dir/SOURCES/
    cp $git_dir/Server/spec/* $rpm_dir/SPECS/
    cd $rpm_dir/SOURCES/
    tar -zcvf $name-$version.tar.gz Server

  elif [ $name == "osn-linux-hostmirror"]; then
    git_dir=/root/git/hostmirror
    rm -rf $rpm_dir/SOURCES/$name/*
    rm -rf $rpm_dir/SPECS/$name-*
    rm -rf $rpm_dir/RPMS/$os_arch/$name-*
    rm -rf $rpm_dir/SRPMS/$name-*
    cp -r $git_dir/* $rpm_dir/SOURCES/$name
    cp $git_dir/SPEC/* $rpm_dir/SPECS/
    cd $rpm_dir/SOURCES/
    tar -zcvf $name-$version.tar.gz $name-$version
  fi # end of prebuild #

  rpmbuild -bs $rpm_dir/SPECS/$name-$os_ver.spec
  scp $rpm_dir/SRPMS/$name-$version-$cli_release.el$os_ver.src.rpm root@$dest_ip:/opt

  if [ $collect ]; then 
    ssh $dest_ip "rpm -ivh /opt/$name-$version-$release.el$os_ver.src.rpm && rpmbuild -ba $dst_rpm_dir/SPECS/$name-$os_ver.spec && scp $dest_rpm_dir/RPMS/$os_arch/$name-$version-$release* $local_addr:$REPO_DIR"
  fi
}

if [ -z $1 ]; then 
  echo "Fatal: need an arg"
  exit
elif [ "$1" == "--help" -o $1 == "-h" ]; then
  echo "$0 <project-name> [--collect]"
  echo "if input --collect, all archs of <project-name> will be collected into /opt"
  exit
fi

collect=0
if [ ! -z $2 ] && [ $2 == "--collect" ]; then
  collect=1
fi

if [ "$1" == "osncdpagt/" ]; then
  # you need edit 'Release' line in 'osncdpagt_ora11g.spec' firstly
  NAME=osncdpagt-ora11g-6.0.0_11.2.0.3
  BUILD=5
  DESTIP=192.168.3.30
  scp -r /root/git/osncdpagt/* $DESTIP:/usr/src/redhat/SOURCES/$NAME/

elif [ "$1" == "hostmirror/" ]; then
  hm_5_x86_64=y
  hm_5_i386=n
  hm_6_x86_64=n
  hm_6_i386=n
  hm_5_i386_PAE=n
  # you need edit 'Release' line in 'osn-linux-hostmirror.spec' firstly
  NAME=osn-linux-hostmirror
  NAME_PAE=osn-linux-hostmirror-PAE
  VERSION=1.3.0
  BUILD=134
  REPO_DIR=/opt/hostmirror

  if [ $collect ]; then 
    rm -rf $REPO_DIR.bak >/dev/null 2>&1
    mv $REPO_DIR $REPO_DIR.bak >/dev/null 2>&1
    mkdir $REPO_DIR >/dev/null 2>&1
  fi

  if [ $hm_5_x86_64 = "y" ]; then
    DESTIP=192.168.3.30
    DESTVER=5
    DESTARCH=x86_64
    build $NAME $VERSION $BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $hm_5_i386 = "y" ]; then
    DESTIP=192.168.3.31
    DESTVER=5
    DESTARCH=i386
    build $NAME $VERSION $BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $hm_6_x86_64 = "y" ]; then
    DESTIP=192.168.3.32
    DESTVER=6
    DESTARCH=x86_64
    build $NAME $VERSION $BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $hm_6_i386 = "y" ]; then
    DESTIP=192.168.3.33
    DESTVER=6
    DESTARCH=i386
    build $NAME $VERSION $BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $hm_5_i386_PAE = "y" ]; then # build() cannot process this situation
    DESTIP=192.168.3.34
    rpmbuild -bs /root/rpmbuild/SPECS/$NAME_PAE-5.spec
    rm -rf /opt/hostmirror.rpm/el5_i386_PAE
    mkdir /opt/hostmirror.rpm/el5_i386_PAE
    scp /root/rpmbuild/SRPMS/$NAME-$VERSION-$RELEASE.PAE.el5.src.rpm $DESTIP:/opt
    if [ $collect ]; then 
      mkdir /opt/hm_5_i386_PAE >/dev/null 2>&1
      ssh $DESTIP "rpm -ivh /opt/$NAME-$VERSION-$RELEASE.PAE.el5.src.rpm && rpmbuild -ba /usr/src/redhat/SPECS/osn-linux-hostmirror-PAE-5.spec && scp /usr/src/redhat/RPMS/i386/$NAME-$VERSION-$RELEASE* $LOCAL_ADDR:/opt/hm_5_i386_PAE"
    fi
  fi

elif [ "$1" == "osnstreamer/" ]; then
  st_srv=y
  st_cli_5_x86_64=n
  st_cli_5_i386=n
  st_cli_6_x86_64=n
  st_cli_6_i386=n
  # you need edit 'Release' line in 'osnstm.spec' firstly
  VERSION=6.0.0
  CLI_NAME=osnstm_client
  CLI_BUILD=69
  SRV_NAME=osnstm
  SRV_BUILD=74
  REPO_DIR=/opt/osnstreamer

  if [ $collect ]; then 
    rm -rf $REPO_DIR.bak >/dev/null 2>&1
    mv $REPO_DIR $REPO_DIR.bak >/dev/null 2>&1
    mkdir $REPO_DIR >/dev/null 2>&1
  fi

  if [ $st_cli_5_x86_64 = "y" ]; then
    DESTIP=192.168.3.30
    DESTVER=5
    DESTARCH=x86_64
    build $CLI_NAME $VERSION $CLI_BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $st_cli_5_i386 = "y" ]; then
    DESTIP=192.168.3.31
    DESTVER=5
    DESTARCH=i386
    build $CLI_NAME $VERSION $CLI_BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $st_cli_6_x86_64 = "y" ]; then
    DESTIP=192.168.3.32
    DESTVER=6
    DESTARCH=x86_64
    build $CLI_NAME $VERSION $CLI_BUILD $DESTIP $DESTVER $DESTARCH
  fi
  if [ $st_cli_6_i386 = "y" ]; then
    DESTIP=192.168.3.33
    DESTVER=6
    DESTARCH=i386
    build $CLI_NAME $VERSION $CLI_BUILD $DESTIP $DESTVER $DESTARCH
  fi

  if [ $st_srv = "y" ]; then
    DESTIP=192.168.3.98
    DESTVER=6
    DESTARCH=x86_64
    build $SRV_NAME $VERSION $SRV_BUILD $DESTIP $DESTVER $DESTARCH
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

