#!/bin/bash
DEBUG=0
DVD_CD=/CentOS6/Packages
ALL_RPMS_DIR=/mnt/Packages
DVD_RPMS_DIR=$DVD_CD
packages_list=/opt/packages.list
number_of_packages=`cat $packages_list | wc -l`
i=1
while [ $i -le $number_of_packages ] ; do
        line=`head -n $i $packages_list | tail -n -1`
        name=`echo $line | awk '{print $1}'`
        version=`echo $line | awk '{print $3}' | cut  -f  2  -d  :`
        if [ $DEBUG -eq "1" ] ; then
                echo $i: $line
                echo $name
                echo $version
        fi

        if [ $DEBUG -eq "1" ] ; then
                ls $ALL_RPMS_DIR/$name-$version*
                if [ $? -ne 0 ] ; then
                        echo "cp $ALL_RPMS_DIR/$name$version* "
                fi
        else
                echo "cp $ALL_RPMS_DIR/$name-$version* $DVD_RPMS_DIR/"
                cp $ALL_RPMS_DIR/$name$version* $DVD_RPMS_DIR/
                # in case the copy failed
                if [ $? -ne 0 ] ; then
                        echo "cp $ALL_RPMS_DIR/$name$version* "
                        cp $ALL_RPMS_DIR/$name* $DVD_RPMS_DIR/
                fi
        fi
        i=`expr $i + 1`
done

