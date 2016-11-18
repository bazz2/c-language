#!/bin/bash

all_group="
failover-APP ....: Online           
current        : APP02
--
failover-DB .....: Online           
current        : DB02
--
failover-WEB ....: Online           
current        : WEB03
"
#all_group=`clpstat |grep failover -A1`

group="failover-DB"
hosts=("DB01" "DB02")
dst_host=`echo "$all_group" |grep $group -A1 |grep current |awk '{print $3}'`
if [[ ! "${hosts[@]}" =~ "$dst_host" ]]; then
    exit
fi

group="failover-APP"
hosts=("APP01" "APP02")
dst_host=`echo "$all_group" |grep $group -A1 |grep current |awk '{print $3}'`
if [[ "${hosts[@]}" =~ "$dst_host" ]]; then
    clpgrp -t $group
    clpgrp -s $group -h $dst_host
fi

group="failover-WEB"
hosts=("WEB01" "WEB02")
dst_host=`echo "$all_group" |grep $group -A1 |grep current |awk '{print $3}'`
if [[ "${hosts[@]}" =~ "$dst_host" ]]; then
    clpgrp -t $group
    clpgrp -s $group -h $dst_host
fi

clpstat |grep failover -A1
