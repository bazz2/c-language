#!/bin/sh

backup_dir="/home/work/V2.3.1/backup_V2.3_app"
update_dir="/home/work/V2.3.1/update_V2.3.1_app"

function file_backup()
{
    if [ ! -d $backup_dir ];then
        echo "[Creating $backup_dir]"
        mkdir -p $backup_dir
    fi
    cd /home/das_uq/
    rm -rf das_uq.*
    echo "Creating tarball..."
    tar czvf App_das_uq.tar.gz --exclude=*.dbg* --exclude=*.err* * >/dev/null 2>&1
    mv -f App_das_uq.tar.gz $backup_dir
    echo "[Files backup finished]"
    ls -l $backup_dir/App_das_uq.tar.gz
    echo "[Files backup check OK? (y or n)]"
    while true; do
        read  aa; 
        if [ -z $aa ];then
            echo "[Please input 'y' or 'n'] ";
        elif [ $aa == 'n' ];then
            echo "[Program teminated]"
            exit 0;
        elif [ $aa == 'y' ];then
            echo "[Files backup finished,you can do 2.[update file check]!]"
            break
        else 
            echo "[please input 'y' or 'n'] "
        fi
    done
}

function update_file_check()
{
    if [ ! -d $update_dir ];then
        echo "[ERROR: $update_idr doesn't exist]"
        return
    fi
    echo "[---update files check,including quantity and size---]"
    ls -l $update_dir
    echo " "
    quantity=`find $update_dir -type f |wc -l`
    size=`du -cb $update_dir/* |grep total |awk '{print$1}'`
    echo "[There are $quantity files to be updated ($size Byte)]"
    echo "[Update files check OK? (y or n)]"
    while true; do
        read  ba
        if [ -z $ba ];then
            echo "[Please input 'y' or 'n']"
        elif [ $ba == 'n' ];then
            echo "[Program teminated]"
            exit 0 ;
        elif [ $ba == 'y' ];then
            echo "[Update files check finished,you can do 3.[owner change] next!]"
            break
        else 
            echo "[Please input 'y' or 'n' to continue]"
        fi
    done 
}

function owner_change()
{
    cd $update_dir >/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "[ERROR: $update_dir not exist]"
        return
    fi
    chown -R das_uq:das_uq $update_dir
    chmod -R 755 $update_dir
    ls -l $update_dir
    echo " "
    echo "[Owner change check OK? (y or n)]"
    while true; do
        read  ca;
        if [ -z $ca ];then
            echo " ";
        elif [ $ca == 'n' ];then
            echo "[ERROR: program teminated, please change owner again]"
            exit 0 ;
        elif [ $ca == 'y' ];then
            echo "[Owner change check finished, you can do [4. file update] next!]";
            break
        else
            echo "[Please input 'y' or 'n'] ";
        fi
    done
}

function file_update()
{
	cd $update_dir >/dev/null 2>&1
	if [ $? != 0 ];then
        echo "[ERROR: $update_dir not exist]"
        return
	fi
	echo "[Omcstop]"
	su - das_uq -c omcstop
	echo "[Omcstop check: press 'y' or 'n' to continue]"
	read da;
	if [ -z $da ];then
		echo "[Please input 'y' or 'n' ";
	elif [ $da == 'n' ];then
		echo "[ERROR: program teminated,please omcstop handly!]"
		exit 0;
	elif [ $da == 'y' ];then
		echo "[Omcstop successfully!]";
	else
		echo "[Please input 'y' or 'n']";
	fi

	echo "[Copy update files......]"
	
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
	
	rm -rf /home/das_uq/bin/systemalarm
	cp -rf $update_dir/systemalarm /home/das_uq/bin
	if [ $? == 0  ];then
		let m++
	fi
	
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
	
	ls -l /home/das_uq/bin/systemalarm
	if [ $? == 0  ];then
		let n++
	fi
	
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
            echo "[ERROR: files update check failed, please redo [4.file update]!]"
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
	echo "		[UQ NMS V2.3.1 update_app script]"
	echo "	"
	echo " "
	echo "		1.[file backup]"
	echo "		2.[update file check]"
	echo "		3.[owner change]"
	echo "		4.[file update]"
	echo "		5.[quit]"
	echo " "
	echo -n "Please choose the number:"
	read selected
	case $selected in
    1)
        while true
        do
            read  ab;
            if [ -z $ab ];then
                echo "[Please input 'y' or 'n'] ";
            elif [ $ab == 'n' ];then
                echo "[*****Back to main menu******]"
                break;
            elif [ $ab == 'y' ];then
                echo "[Backup files]"
                file_backup;
                break;
            else
                echo "[Please input 'y' or 'n'] ";
            fi
        done
        ;;
    2)
        while true
        do
            read  bb;
            if [ -z $bb ];then
                echo "[Please input 'y' or 'n'] "
            elif [ $bb == 'n' ];then
                echo "[*****Back to main menu******]"
                break
            elif [ $bb == 'y' ];then
                echo "[Update file check]"
                update_file_check
                break
            else
                echo "[Please input 'y' or 'n'] "
            fi
        done	
    ;;
    3)
        while true
        do
            read  cb;
            if [ -z $cb ];then
                echo "[Please input 'y' or 'n'] ";
            elif [ $cb == 'n' ];then
                echo "[*****Back to main menu******]"
                break;
            elif [ $cb == 'y' ];then
                echo "[Owner change]";
                owner_change;
                break;
            else
                echo "[Please input 'y' or 'n'] ";
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
        exit 0;
    ;;
    *)
        echo "[Error input,please input 1-5!]"
    esac
done
