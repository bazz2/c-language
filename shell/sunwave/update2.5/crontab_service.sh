
#!/bin/bash

if [ -z $1 ]; then
	echo "usage: $0 [add|remove]"
	exit
fi

if [ $1 != "add" ] && [ $1 != "remove" ]; then
	echo "usage: $0 [add|remove]"
	exit
fi

if [ $1 == "add" ]; then
	service_exec="start"
else
	service_exec="stop"
fi


# 202/203 is mysql database, so they must start firstly
all_servers=("10.152.69.202" "10.152.69.203" "10.152.69.196" "10.152.69.197" "10.152.69.199" "10.152.69.200")


for ip in ${all_servers[@]}; do
	echo "=========== processing $ip ============"
	ssh $ip "service keepalived $service_exec; service lvsreal $service_exec; service nginx $service_exec; service omcweb $service_exec; service das_uq $service_exec; service mysql $service_exec;"
	if [ $1 == "add" ]; then
		ssh $ip "
			sed -i 's/sys_temalarm/systemalarm/' /var/spool/cron/das_uq;
			sed -i 's/clear_hislog/clearhislog/' /var/spool/cron/das_uq;
			sed -i 's/time_sql/timesql/' /var/spool/cron/das_uq;
			sed -i 's/das_check/dascheck/' /var/spool/cron/das_uq;
			sed -i 's/uni_son/unison/' /var/spool/cron/omcweb;
			sed -i 's/clear_weblog/clearweblog/' /var/spool/cron/omcweb;
			sed -i 's/net_check.sh/netcheck.sh/' /var/spool/cron/root;
			sed -i 's/a_rp.sh/arp.sh/' /var/spool/cron/root;
			"
	else
		ssh $ip "
			sed -i 's/systemalarm/sys_temalarm/' /var/spool/cron/das_uq;
			killall systemalarm;
			sed -i 's/clearhislog/clear_hislog/' /var/spool/cron/das_uq;
			sed -i 's/timesql/time_sql/' /var/spool/cron/das_uq;
			sed -i 's/dascheck/das_check/' /var/spool/cron/das_uq;
			sed -i 's/unison/uni_son/' /var/spool/cron/omcweb;
			sed -i 's/clearweblog/clear_weblog/' /var/spool/cron/omcweb;
			sed -i 's/netcheck.sh/net_check.sh/' /var/spool/cron/root;
			sed -i 's/arp.sh/a_rp.sh/' /var/spool/cron/root;
			"
	fi
	echo -e "\n\n"
done

for ip in ${all_servers[@]}; do
	echo "=========== checking $ip ============"
	ssh $ip "ps -u das_uq; ps -lef|grep java |grep -v grep; crontab -u root -l; crontab -u das_uq -l; crontab -u omcweb -l"
done
