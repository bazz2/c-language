#!/bin/sh

function rollback()
{
	echo "[Omcstop]"
	su - das_uq -c omcstop
	echo "[Omcstop check: press 'y' or 'n' to continue]"
	while true; do
		read ea;
		if [ -z $ea ];then
			echo "[Please input 'y' or 'n']";
		elif [ $ea == 'n' ];then
			echo "[ERROR: program teminated, please omcstop by hand!]"
			exit 0;
		elif [ $ea == 'y' ];then
			echo "[Omcstop successfully!]";
			break
		else
			echo "[Please input 'y' or 'n']";
		fi
	done
	echo "[Rollback to V2.4_db]..."
	cp -rf /home/work/backup/backup_V2.4_db/DB_V2.4.tar.gz /home/das_uq/
	cd /home/das_uq/
	tar xvfz DB_V2.4.tar.gz >/dev/null 2>&1
	ls -l /home/das_uq/bin/systemalarm
	ls -l /home/das_uq/bin/snmpTrapd
	ls -l /home/das_uq/lib/libomcpublic.so
	ls -l /home/das_uq/lib/libebdgdlmysql.so
	echo "[Rollback check OK? (y or n)]"
	while true; do
		read eb;
		if [ -z $eb ];then
			echo "[Please input 'y' or 'n'] "
		elif [ $eb == 'n' ];then
			echo "[ERROR: rollback check failed, exit!]"
			exit 0
		elif [ $eb == 'y' ];then
			echo "[Rollback check finished]"
			break
		else
			echo "[Please input 'y' or 'n'] "
		fi
	done

	echo "[snmpTrapd start]"
	su - das_uq -c omcstart
	echo "[snmpTrapd check: press 'y' or 'n' to continue]"
	while true; do
		read ec;
		if [ -z $ec ];then
			echo "[Please input 'y' or 'n' "
		elif [ $ec == 'n' ];then
			echo "[ERROR: program teminated, please execute 'snmpTrapd start' by hand!]"
			exit 0;
		elif [ $ec == 'y' ];then
			echo "[snmpTrapd start successfully!]"
			break
		else
			echo "[Please input 'y' or 'n']"
		fi
	done
	echo "[Rollback to V2.4_db finished!]"
}

echo " "	
echo " "
echo "		[UQ NMS rollback to DB V2.4 script]"
echo " "
echo " "
echo "[[Rollback] confirm, please input 'y' or 'n' to continue]"
while true; do
    read  ed;
    if [ -z $ed ]; then
        echo "[Please input 'y' or 'n'] ";
    elif [ $ed == 'n' ]; then
        echo "[***** Exit ******]"
        exit;
    elif [ $ed == 'y' ]; then
        echo "[Rollback]"
        rollback;
        exit
    else
        echo "[Please input 'y' or 'n'] ";
    fi
done
