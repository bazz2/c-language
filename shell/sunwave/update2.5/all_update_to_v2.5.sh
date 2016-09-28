#!/bin/bash

if [ -z $1 ] || ([ $1 != "osaka" ] && [ $1 != "tama" ]); then
    echo "usage: $0 [osaka|tama]"
    exit
fi

if [ $1 == "osaka" ]; then
    all_servers=("10.158.69.197" "10.158.69.196" "10.158.69.198")
else
    all_servers=("10.152.69.199" "10.152.69.200" "10.152.69.196" "10.152.69.197" "10.152.69.202" "10.152.69.203")
fi


for ip in ${all_servers[@]}; do
    echo "=========== processing $ip ============"
    ssh das_uq@$ip "
    "

    if [ $ip == "10.158.69.197" ]; then
        # APP03
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
            omcstop;
        "
        ssh root@$ip "
            chkconfig das_uq off;
            chkconfig --list das_uq;
        "
    elif [ $ip == "10.158.69.196" ]; then
        # WEB03
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh omcweb@$ip "
            tomcat/bin/shutdown.sh;
        "
        ssh root@$ip "
            chkconfig omcweb off;
            chkconfig --list omcweb;
        "
    elif [ $ip == "10.158.69.198" ]; then
        # DB03
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh root@$ip "
            chkconfig mysql off;
            chkconfig --list mysql;
        "
        echo "mysqldumping..."
        mkdir -p /home/work/backup/
        mysqldump -udas_uq -pdas_uq das_uq -h $ip --events --routines -e >/home/work/backup/rollback_v2.4.sql;
    elif [ $ip == "10.152.69.199" ]; then
        # APP01
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
            omcstop;
        "
        ssh root@$ip "
            sed -i /\/root\/arp.sh/d /var/spool/cron/root;
            service keepalived stop;
            service lvsreal stop;
            chkconfig das_uq off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list das_uq;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.200" ]; then
        # APP02
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
            sed -i /\/tools\/dascheck.sh/d /var/spool/cron/das_uq;
            omcstop;
        "
        ssh root@$ip "
            service keepalived stop;
            service lvsreal stop;
            chkconfig das_uq off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list das_uq;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.196" ]; then
        # WEB01
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh omcweb@$ip "
            tomcat/bin/shutdown.sh;
        "
        ssh root@$ip "
            sed -i /\/root\/netcheck.sh/d /var/spool/cron/root;
            sed -i /\/root\/arp.sh/d /var/spool/cron/root;
            service keepalived stop;
            service lvsreal stop;
            chkconfig omcweb off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list omcweb;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.197" ]; then
        # WEB02
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh omcweb@$ip "
            tomcat/bin/shutdown.sh;
        "
        ssh root@$ip "
            service keepalived stop;
            service lvsreal stop;
            chkconfig omcweb off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list omcweb;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.202" ]; then
        # DB01
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh root@$ip "
            sed -i /\/root\/arp.sh/d /var/spool/cron/root;
            service keepalived stop;
            service lvsreal stop;
            chkconfig mysql off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list mysql;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
        mkdir -p /home/work/backup/
        mysqldump -udas_uq -pdas_uq das_uq -h $ip --events --routines -e >/home/work/backup/rollback_v2.4.sql;
    elif [ $ip == "10.152.69.203" ]; then
        # DB02
        ssh das_uq@$ip "
            sed -i /systemalarm/d /var/spool/cron/das_uq;
            killall systemalarm;
        "
        ssh root@$ip "
            service keepalived stop;
            service lvsreal stop;
            chkconfig mysql off;
            chkconfig keepalived off;
            chkconfig lvsreal off;
            chkconfig --list mysql;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    fi
done
