#!/bin/sh
function rollback()
{
	echo "[stop web server]"
	su - omcweb -c "/home/omcweb/tomcat/bin/shutdown.sh"
	sleep 10
	ps -ef |grep java|grep -v grep | grep -v PID | awk '{print $2}'|xargs kill -9 >/dev/null 2>&1
	echo "web server stop success? press 'y' or 'n' to continue"
    while true
    do
        read ea;
        if [ -z $ea ];then
            echo "[please input 'y' or 'n'] ";
        elif [ $ea == 'n' ];then
            echo "[ERROR:web server stop failed,please stop it handly!]"
            exit
        elif [ $ea == 'y' ];then
            echo "[web server stop successfully!]";
        else
            echo "[please input 'y' or 'n'] ";
        fi
    done

	echo "[rollback to V2.3_web]..."
	cp -rf /home/work/backup/backup_V2.3_web/Web_V2.3.tar.gz /home/omcweb/tomcat/webapps/ROOT/
	cd /home/omcweb/tomcat/webapps/ROOT/
	tar xvfz Web_V2.3.tar.gz >/dev/null 2>&1
	echo "[web server start]"
	su - omcweb -c "/home/omcweb/tomcat/bin/startup.sh"
	sleep 2
	echo "[web server start check?press 'y' or 'n' to continue]"
    while true
    do
        read eb;
        if [ -z $eb ];then
            echo "[please input 'y' or 'n' ]";
        elif [ $eb == 'n' ];then
            echo "[ERROR:web server start failed,please start it handly!]"
            continue;
        elif [ $eb == 'y' ];then
            echo "[web server start finished]";
        break;
        else
            echo "[please input 'y' or 'n'] ";
        fi
    done

	mv -f /home/omcweb/tomcat/webapps/ROOT/systemalarm /home/das_uq/bin
    chown das_uq:das_uq /home/das_uq/bin/systemalarm
    chmod u+x /home/das_uq/bin/systemalarm
	echo "[rollback to V2.3_web finished!]"
}

echo " "	
echo " "
echo "		[UQ NMS Rollback to V2.3 Script]"
echo " "
echo " "
echo "[[rollback] confirm,please input 'y' or 'n' to continue]"
while true
do
    read  ec;
    if [ -z $ec ];then
        echo "[please input 'y' or 'n'] ";
    elif [ $ec == 'n' ];then
        echo "[*****script quit******]"
        exit;
    elif [ $ec == 'y' ];then
        echo "[rollback]"
        rollback;
        exit
    else
        echo "[please input 'y' or 'n'] ";
    fi
done	
