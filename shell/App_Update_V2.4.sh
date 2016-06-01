#!/bin/sh

backup_dir="/home/work/backup/backup_V2.3_app"
update_dir="/home/work/update/update_V2.4_app"

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
    rm -rf App*
    tar czvf $backup_dir/App_V2.3.tar.gz bin/ lib/ etc/ tools/
    ls -l $backup_dir/App_V2.3.tar.gz
    echo "[Files backup finished, if there's no problem, do 2.[Check files]!]"
}

function update_file_check()
{
    if [ ! -d $update_dir ];then
        echo "[ERROR: $update_dir doesn't exist]"
        return
    fi
    chown -R das_uq:das_uq $update_dir
    chmod -R 775 $update_dir
    echo "[---update files check,including quantity and size---]"
    ls -l $update_dir
    echo " "
    quantity=`find $update_dir -type f |wc -l`
    size=`du -cb $update_dir/* |grep total |awk '{print$1}'`
    echo "[There are $quantity files to be updated ($size Byte)]"
    echo "[Files checkup is finished, if there's no problem, do 3.[Update]]"
}

function file_update()
{
	cd $update_dir
	if [ $? != 0 ];then
        return
	fi
	#echo "[Omcstop]"
	#su - das_uq -c omcstop
	#echo "[Omcstop check: press 'y' or 'n' to continue]"
	#read da;
	#if [ -z $da ];then
	#	echo "[Please input 'y' or 'n']";
	#elif [ $da == 'n' ];then
	#	echo "[ERROR: Program teminated, please omcstop by hand]"
	#	exit 0;
	#elif [ $da == 'y' ];then
	#	echo "[Omcstop successfully!]";
	#else
	#	echo "[Please input 'y' or 'n']";
	#fi

	echo "[Updating...]"
	rm -rf /home/das_uq/bin/applserv
	cp -rf $update_dir/applserv /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
	rm -rf /home/das_uq/bin/gprsserv
	cp -rf $update_dir/gprsserv /home/das_uq/bin
	if [ $? == 0  ];then
        let m++
	fi
	
	rm -rf /home/das_uq/bin/grrusend
	cp -rf $update_dir/grrusend /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
	rm -rf /home/das_uq/bin/grrurecv
	cp -rf $update_dir/grrurecv /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
	rm -rf /home/das_uq/bin/commserv
	cp -rf $update_dir/commserv /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
	#rm -rf /home/das_uq/bin/systemalarm
	#cp -rf $update_dir/systemalarm /home/das_uq/bin
	#if [ $? == 0  ];then
	#	let m++
	#fi
	
	rm -rf /home/das_uq/bin/timeserv
	cp -rf $update_dir/timeserv /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
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
	
	ls -l /home/das_uq/bin/applserv
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/bin/gprsserv
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/bin/grrusend
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/bin/grrurecv
	if [ $? == 0  ];then
		let n++
	fi
	
	ls -l /home/das_uq/bin/commserv
	if [ $? == 0  ];then
		let n++
	fi
	
	#ls -l /home/das_uq/bin/systemalarm
	#if [ $? == 0  ];then
	#	let n++
	#fi
	
	ls -l /home/das_uq/bin/timeserv
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
	echo "[Omcstart]"
	su - das_uq -c omcstart
	echo "[Is omcstart successful? (y or n)]"      	
	while true
    do
        read dc;
        if [ -z $dc ];then
            echo "[Please input 'y' or 'n']";
        elif [ $dc == 'n' ];then
            echo "[ERROR: program teminated, please omcstart by hand!]"
            exit 0;
        elif [ $dc == 'y' ];then
            echo "[Omcstart successfully!]";
            break
        else
            echo "[Please input 'y' or 'n']";
        fi
    done	
}

while true; do
	echo "		[UQ NMS V2.4 update_app script]"
	echo " "
	echo "		1.[Backup]"
	echo "		2.[Check files]"
	echo "		3.[Update]"
	echo "		4.[Quit]"
	echo " "
	echo -n "Please choose the number: "
	read selected
	case $selected in
    1)
        echo "[***File backup*** confirm,please input 'y' or 'n' to continue]"
        while true
        do
            read  dd;
            if [ -z $dd ];then
                echo "[Please input 'y' or 'n'] ";
            elif [ $dd == 'n' ];then
                echo "[*****Back to main menu******]"
                break;
            elif [ $dd == 'y' ];then
            echo "[File backup]";
            file_backup;
            break;
            else
            echo "[Please input 'y' or 'n'] ";
            fi
        done	
        ;;
    2)
        update_file_check
        ;;
    3)
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
    4)
        echo " "
        exit 0;
    ;;
    *)
        echo "[Error input,please input 1-4!]"
    esac
done
