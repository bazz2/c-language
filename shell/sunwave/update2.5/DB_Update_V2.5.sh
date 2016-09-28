#!/bin/sh

backup_dir="/home/work/backup/backup_V2.4_db"
update_dir="/home/work/update/update_V2.5_db"

function file_backup()
{
	if [ ! -d $backup_dir ];then
		echo "[Creating $backup_dir]"
		mkdir -p $backup_dir
		if [ $? != 0 ]; then
			return
		fi
	fi
	cd /home/das_uq/
	if [ $? != 0 ]; then
		return
	fi
	echo "Creating tarball..."
	if [ -f $backup_dir/DB_V2.4.tar.gz ]; then
		echo "[ERROR: $backup_dir/DB_V2.4.tar.gz already exist!]"
		return
	fi
    cp /etc/sudoers .
	tar czvf $backup_dir/DB_V2.4.tar.gz bin/ lib/ etc/ tools/ sudoers
    rm sudoers
	ls -l $backup_dir/DB_V2.4.tar.gz
	echo "[files back check OK?,press 'y' or 'n' to continue!]"
	while true; do
		read  aa; 
		if [ -z $aa ];then
			echo "[please input 'y' or 'n'] ";
		elif [ $aa == 'n' ];then
			echo "[ERROR:program teminated,please check  again]"
			exit 0;
		elif [ $aa == 'y' ];then
			echo "[file backup check finished,you can do [2.file update check] next!]";
			break
		else 
			echo "[please input 'y' or 'n' ]";
		fi
	done 
}

function update_file_check()
{ 
	echo "[update files check......]"
	echo "[including quantity and size---]"
	echo "[1 files should be in $update_dir;]"
	cd $update_dir >/dev/null 2>&1
	if [ $? != 0 ];then
		echo "[folder '$update_dir' not found,please do the preparation first"
		return
	fi
	ls -l $update_dir
	echo " "
	quantity=`find $update_dir type f| wc -l`
	size=`du -cb $update_dir/*|grep total|awk -F " " '{print$1}'`
	echo "[tolal quantity:$quantity]"
	echo "[total size:$size]"
	echo "[update files check OK?  press 'y' or 'n' to continue]"
	while true; do
		read  ba;
		if [ -z $ba ];then
			echo "[please input 'y' or 'n'] ";
		elif [ $ba == 'n' ];then
			echo "[ERROR:program teminated,please check up files again]"
			break ;
		elif [ $ba == 'y' ];then
			echo "[update files check finished,you can do [owner change] next!]";
			echo " "
			echo " "
			break
		else
			echo "[please input 'y' or 'n' to continue] ";
		fi
	done 
}

function owner_change()
{
	echo "[owner change......]"
	cd $update_dir  >/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "[ERROR:folder $update_dir not exist,please do [2.update file check] first!]"
		return
	fi
	chown -R das_uq:das_uq $update_dir
	chmod 775 $update_dir/*
	ls -l $update_dir
	echo " "
	quantity=`find $update_dir -type f| wc -l`
	size=`du -cb $update_dir/*|grep total|awk -F " " '{print$1}'`
	echo "[tolal quantity:$quantity]"
	echo "[total size:$size]"
	echo "[owner change check OK?  press 'y' or 'n' to continue]"
	while true; do
		read  ca;
		if [ -z $ca ];then
			echo " ";
		elif [ $ca == 'n' ];then
			echo "[ERROR:program teminated,please change owner again]"
			exit 0 ;
		elif [ $ca == 'y' ];then
			echo "[owner change check finished,you can do [ file update ] next!]";
			break
		else
			echo "[please input 'y' or 'n'] ";
		fi
	done
}

function file_update()
{
	cd $update_dir
	if [ $? != 0 ];then
		return
	fi
	echo "[snmpTrapd stop]"
	su - das_uq -c "snmpTrapd stop"
	echo "[snmpTrapd check: press 'y' or 'n' to continue]"
	read da;
	if [ -z $da ];then
		echo "[Please input 'y' or 'n']";
	elif [ $da == 'n' ];then
		echo "[ERROR: Program teminated, please execute 'snmpTrapd stop' by hand]"
		exit 0;
	elif [ $da == 'y' ];then
		echo "[snmptrapd stop successfully!]";
	else
		echo "[Please input 'y' or 'n']";
	fi

	echo "[Updating...]"
	rm -rf /home/das_uq/bin/snmpTrapd
	cp -rf $update_dir/snmpTrapd /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
	rm -rf /home/das_uq/bin/systemalarm
	cp -rf $update_dir/systemalarm /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
    sudoers_num=`cat /etc/sudoers |grep das_uq |wc -l`
    if [ $sudoers_num == 0 ]; then
        sed -i 's/^Defaults.*requiretty$/\#Defaults requiretty/g' sudoers
        sudoers_conf="
            das_uq    ALL=(ALL)    ALL
            %das_uq ALL=(ALL) NOPASSWD: ALL))
        "
        echo "$sudoers_conf" >>/etc/sudoers
    fi
	
	rm -rf /home/das_uq/lib/libomcpublic.so
	cp -rf $update_dir/libomcpublic.so /home/das_uq/lib
	if [ $? == 0  ];then
		let m++
	fi
	
	rm -rf /home/das_uq/lib/libebdgdlmysql.so
	cp -rf $update_dir/libebdgdlmysql.so /home/das_uq/lib
	if [ $? == 0  ];then
		let m++
	fi

	echo "[$m files copied!]"
	echo "[Files update check...]"
	chmod +x /home/das_uq/bin
	chown -R das_uq:das_uq /home/das_uq/
	
	ls -l /home/das_uq/bin/snmpTrapd
	if [ $? == 0  ];then
		let n++
	fi
	ls -l /home/das_uq/bin/systemalarm
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/lib/libomcpublic.so
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/lib/libebdgdlmysql.so
	if [ $? == 0  ];then
		let n++
	fi
			
	echo "[$n files listed!]"
	echo "[Files update check OK? (y or n)]"
	while true; do
		read db;
		if [ -z $db ];then
			echo "[Please input 'y' or 'n'] "
		elif [ $db == 'n' ];then
			echo "[ERROR: files update check failed, exit]"
			exit 0;
		elif [ $db == 'y' ];then
			echo "[File update check finished]"
			break;
		else
			echo "[Please input 'y' or 'n'] "
		fi
	done
	echo "[snmpTrapd start]"
	su - das_uq -c omcstart
	echo "[Is snmpTrapd start successful? (y or n)]"
	while true
	do
		read dc;
		if [ -z $dc ];then
			echo "[Please input 'y' or 'n']";
		elif [ $dc == 'n' ];then
			echo "[ERROR: program teminated, please execute 'snmpTrapd start' by hand!]"
			exit 0;
		elif [ $dc == 'y' ];then
			echo "[snmpTrapd start successfully!]";
			break
		else
			echo "[Please input 'y' or 'n']";
		fi
	done	
}

while true; do
	echo "		[UQ NMS V2.5 update_db script]"
	echo " "
	echo "		1.[file backup]"
	echo "		2.[update file check]"
	echo "		3.[owner change]"
	echo "		4.[file update]"
	echo "		5.[quit]"
	echo " "
	echo -n "Please choose the number: "
	read selected
	case $selected in
	1)
		echo "[***file backup*** confirm,please input 'y' or 'n' to continue]"
		while true; do
			read ab;
			if [ -z $ab ];then
				echo "[please input 'y' or 'n'] ";
			elif [ $ab == 'n' ];then
				echo "[*****Back to main menu******]"
				break;
			elif [ $ab == 'y' ];then
				file_backup;
				break;
			else
				echo "[please input 'y' or 'n'] ";
			fi
		done
		;;
	2)
		echo "[***update file check*** confirm,please input 'y' or 'n' to continue]"
		while true; do
			read  bc;
			if [ -z $bc ];then
				echo "[please input 'y' or 'n'] ";
			elif [ $bc == 'n' ];then
				echo "[*****Back to main menu******]"
				break;
			elif [ $bc == 'y' ];then
				echo "[update file check]";
				update_file_check;
				break;
			else
				echo "[please input 'y' or 'n'] ";
			fi
		done
		;;
	3)
		echo "[***owner change*** confirm,please input 'y' or 'n' to continue]"
		while true; do
			read cb;
			if [ -z $cb ];then
				echo "[please input 'y' or 'n'] ";
			elif [ $cb == 'n' ];then
				echo "[*****Back to main menu******]"
				break;
			elif [ $cb == 'y' ];then
				echo "[owner change]";
				owner_change;
				break;
			else
				echo "[please input 'y' or 'n'] ";
			fi
		done
		;;
	4)
		echo "[***File update*** confirm,please input 'y' or 'n' to continue]"
		while true
		do
			read  dd;
			if [ -z $dd ];then
				echo "[Please input 'y' or 'n'] ";
			elif [ $dd == 'n' ];then
				echo "[*****Back to main menu******]"
				break;
			elif [ $dd == 'y' ];then
				echo "[File update]";
				file_update;
				break;
			else
				echo "[Please input 'y' or 'n'] ";
			fi
		done	
	;;
	5)
		echo " "
		echo "[script quit,GoodBye!]"
		exit 0;
	;;
	*)
		echo "[Error input,please input 1-5!]"
	esac
done
