#!/bin/bash

if [ -z $1 ] || ([ $1 != "osaka" ] && [ $1 != "tama" ] && [ $1 != "shibaura" ]); then
    echo "usage: $0 [osaka|tama|shibaura]"
    exit
fi

if [ $1 == "osaka" ]; then
    all_servers=("10.158.69.197" "10.158.69.196" "10.158.69.198")
elif [ $1 == "tama" ]; then
    all_servers=("10.152.69.199" "10.152.69.200" "10.152.69.196" "10.152.69.197" "10.152.69.202" "10.152.69.203")
elif [ $1 == "shibaura" ]; then
    all_servers=("172.29.108.66" "172.29.108.67" "172.29.108.68" )
fi


for ip in ${all_servers[@]}; do
    echo "=========== processing $ip ============"

    if [ $ip == "10.158.69.197" ]; then
        # APP03 osaka
        scp database.cfg.app03_osaka das_uq@$ip:~/etc/database.cfg
        scp grrusend.cfg.app03_osaka das_uq@$ip:~/etc/grrusend.cfg
        scp systemalarm.cfg.app03_osaka das_uq@$ip:~/etc/systemalarm.cfg
    elif [ $ip == "10.158.69.196" ]; then
        # WEB03 osaka
        scp web.xml.web03_osaka omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/web.xml
        scp proxool.mysql.xml.web03_osaka omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/classes/proxool.mysql.xml
        scp das.license.web03_osaka omcweb@$ip:~/tomcat/webapps/ROOT/license/das.license
        scp pub_key.web03_osaka omcweb@$ip:~/tomcat/webapps/ROOT/license/pub_key
    elif [ $ip == "10.158.69.198" ]; then
        # DB03 osaka
        scp database.cfg.db03_osaka das_uq@$ip:~/etc/database.cfg
        scp systemalarm.cfg.db03_osaka das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    elif [ $ip == "172.29.108.67" ]; then
        # APP03 shibaura
        scp database.cfg.app03_shibaura das_uq@$ip:~/etc/database.cfg
        scp grrusend.cfg.app03_shibaura das_uq@$ip:~/etc/grrusend.cfg
        scp systemalarm.cfg.app03_shibaura das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    elif [ $ip == "172.29.108.66" ]; then
        # WEB03 shibaura
        scp web.xml.web03_shibaura omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/web.xml
        scp proxool.mysql.xml.web03_shibaura omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/classes/proxool.mysql.xml
        scp das.license.web03_shibaura omcweb@$ip:~/tomcat/webapps/ROOT/license/das.license
        scp pub_key.web03_shibaura omcweb@$ip:~/tomcat/webapps/ROOT/license/pub_key
        scp database.cfg.web03_shibaura das_uq@$ip:~/etc/database.cfg
        scp systemalarm.cfg.web03_shibaura das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    elif [ $ip == "172.29.108.68" ]; then
        # DB03 shibaura
        scp database.cfg.db03_shibaura das_uq@$ip:~/etc/database.cfg
        scp systemalarm.cfg.db03_shibaura das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    elif [ $ip == "10.152.69.199" ]; then
        # APP01 tama
        scp database.cfg.app01_tama das_uq@$ip:~/etc/database.cfg
        scp grrusend.cfg.app01_tama das_uq@$ip:~/etc/grrusend.cfg
        scp systemalarm.cfg.app01_tama das_uq@$ip:~/etc/systemalarm.cfg
    elif [ $ip == "10.152.69.200" ]; then
        # APP02 tama
        scp database.cfg.app02_tama das_uq@$ip:~/etc/database.cfg
        scp grrusend.cfg.app02_tama das_uq@$ip:~/etc/grrusend.cfg
        scp systemalarm.cfg.app02_tama das_uq@$ip:~/etc/systemalarm.cfg
    elif [ $ip == "10.152.69.196" ]; then
        # WEB01 tama
        scp web.xml.web01_tama omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/web.xml
        scp proxool.mysql.xml.web01_tama omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/classes/proxool.mysql.xml
        scp das.license.web01_tama omcweb@$ip:~/tomcat/webapps/ROOT/license/das.license
        scp pub_key.web01_tama omcweb@$ip:~/tomcat/webapps/ROOT/license/pub_key
    elif [ $ip == "10.152.69.197" ]; then
        # WEB02 tama
        scp web.xml.web02_tama omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/web.xml
        scp proxool.mysql.xml.web02_tama omcweb@$ip:~/tomcat/webapps/ROOT/WEB-INF/classes/proxool.mysql.xml
        scp das.license.web02_tama omcweb@$ip:~/tomcat/webapps/ROOT/license/das.license
        scp pub_key.web02_tama omcweb@$ip:~/tomcat/webapps/ROOT/license/pub_key
    elif [ $ip == "10.152.69.202" ]; then
        # DB01 tama
        scp database.cfg.db01_tama das_uq@$ip:~/etc/database.cfg
        scp systemalarm.cfg.db01_tama das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    elif [ $ip == "10.152.69.203" ]; then
        # DB02 tama
        scp database.cfg.db02_tama das_uq@$ip:~/etc/database.cfg
        scp systemalarm.cfg.db02_tama das_uq@$ip:~/etc/systemalarm.cfg
        ssh das_uq@$ip "
            echo \"* * * * * . \$HOME/.bash_profile; systemalarm>>/tmp/systemalarm.log 2>&1\" >> /var/spool/cron/das_uq;
        "
    fi
done
