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

    if [ $ip == "10.158.69.197" ]; then
        # APP03
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
            omcstart;
        "
        ssh root@$ip "
            chkconfig das_uq on;
            chkconfig --list das_uq;
        "
    elif [ $ip == "10.158.69.196" ]; then
        # WEB03
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh omcweb@$ip "
            tomcat/bin/startup.sh;
        "
        ssh root@$ip "
            chkconfig omcweb on;
            chkconfig --list omcweb;
        "
    elif [ $ip == "10.158.69.198" ]; then
        # DB03
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh root@$ip "
            chkconfig mysql on;
            chkconfig --list mysql;
        "
        echo "mysqldumping..."
#        mkdir -p /home/work/backup/
#        mysql -udas_uq -pdas_uq das_uq -h $ip </home/work/backup/rollback_v2.4.sql;
    elif [ $ip == "10.152.69.199" ]; then
        # APP01
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
            omcstart;
        "
        ssh root@$ip "
            echo \"* * * * * /root/arp.sh >>/tmp/arp.log\" >> /var/spool/cron/root;
            service keepalived start;
            service lvsreal start;
            chkconfig das_uq on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list das_uq;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.200" ]; then
        # APP02
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
            echo \"* * * * * \$HOME/tools/dascheck.sh >>/tmp/dascheck.log 2>&1\" >> /var/spool/cron/das_uq;
            omcstart;
        "
        ssh root@$ip "
            service keepalived start;
            service lvsreal start;
            chkconfig das_uq on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list das_uq;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.196" ]; then
        # WEB01
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh omcweb@$ip "
            tomcat/bin/startup.sh
        "
        ssh root@$ip "
            echo \"* * * * * /root/netcheck.sh >>/tmp/netcheck.log 2>&1\" >> /var/spool/cron/root;
            echo \"* * * * * /root/arp.sh >>/tmp/arp.log\" >> /var/spool/cron/root;
            service keepalived start;
            service lvsreal start;
            chkconfig omcweb on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list omcweb;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.197" ]; then
        # WEB02
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh omcweb@$ip "
            tomcat/bin/startup.sh;
        "
        ssh root@$ip "
            service keepalived start;
            service lvsreal start;
            chkconfig omcweb on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list omcweb;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    elif [ $ip == "10.152.69.202" ]; then
        # DB01
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh root@$ip "
            echo \"* * * * * /root/arp.sh >>/tmp/arp.log\" >> /var/spool/cron/root;
            service keepalived start;
            service lvsreal start;
            chkconfig mysql on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list mysql; 
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
        #mkdir -p /home/work/backup/
        #mysqldump -udas_uq -pdas_uq das_uq -h $ip --events --routines -e >/home/work/backup/rollback_v2.4.sql;
    elif [ $ip == "10.152.69.203" ]; then
        # DB02
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
        ssh root@$ip "
            service keepalived start;
            service lvsreal start;
            chkconfig mysql on;
            chkconfig keepalived on;
            chkconfig lvsreal on;
            chkconfig --list mysql;
            chkconfig --list keepalived;
            chkconfig --list lvsreal;
        "
    fi
done
