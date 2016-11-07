#!/bin/sh

#
# if all processes are executed correctly, exit 0, else exit 1
#

HOME_PACKAGES="/home/packages/"

homepage="
  1) deploy web;
  2) deploy app;
  3) deploy db;
"

function select_item()
{
    while true; do
        read input; 
    if [ -z $input ] || [ $input -gt 7 ] || [ $input -lt 1 ]; then
            echo "[please input from 1 to 7]";
        else
            return $input
        fi
    done 
}

function confirm()
{
    while true; do
        read input; 
        if [ -z $input ];then
            echo "[please input 'y' or 'n'] ";
        elif [ $input == 'n' ];then
            exit 1;
        elif [ $input == 'y' ];then
            break
        else 
            echo "[please input 'y' or 'n' ]";
        fi
    done 
}

function check_files()
{
    all_files=(
        MySQL-client-5.6.21-1.linux_glibc2.5.x86_64.rpm
        MySQL-devel-5.6.21-1.linux_glibc2.5.x86_64.rpm
        MySQL-server-5.6.21-1.linux_glibc2.5.x86_64.rpm
        MySQL-shared-5.6.22-1.el6.x86_64.rpm
        pcre-devel-7.8-3.1.el6.x86_64.rpm
        apache-tomcat-6.0.32.tar
        omcweb/
        das_uq/
        jdk-6u27-linux-x64/
        server
        udp_check
        my.cnf
        mysqlcheck)

    cd $HOME_PACKAGES
    ret=0
    for i in ${all_files[@]}; do
        ls $i
        if [ $? != 0 ]; then
            ret=1
        fi
    done

    echo "Lack some files, exit."
    exit 1
}

function pre_process()
{
    echo "stoping firewall..."
    service iptables stop
    chkconfig iptables off

    echo "disabling selinux..."
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
    /usr/sbin/setenforce 0

    echo "changing the mode bits of $HOME_PACKAGES..."
    chmod -R 755 $HOME_PACKAGES/*

}

function setup_mysql_server_client()
{
    echo "clear mysql"
    service mysql stop

    mysql_num=0
    ret=`rpm -qa|grep MySQL-client-5.6.21-1.linux_glibc2.5.x86_64 |wc -l`
    mysql_num+=$ret
    ret=`rpm -qa|grep MySQL-devel-5.6.21-1.linux_glibc2.5.x86_64 |wc -l`
    mysql_num+=$ret
    ret=`rpm -qa|grep MySQL-server-5.6.21-1.linux_glibc2.5.x86_64 |wc -l`
    mysql_num+=$ret
    ret=`rpm -qa|grep MySQL-shared-5.6.22-1.el6.x86_64.rpm |wc -l`
    mysql_num+=$ret

    if [ $mysql_num -eq 4 ]; then
        return
    fi

    rpm -e MySQL-server --nodeps
    rpm -e MySQL-client --nodeps
    rpm -e MySQL-devel --nodeps
    rpm -e MySQL-share --nodeps

    rm -rf /root/.mysql_secret
    rm -rf /var/lib/mysql/*
    cd $HOME_PACKAGES
    echo "Installing MySQL-server..."
    rpm -ivh MySQL-server-* >/dev/null
    echo "Installing MySQL-client..."
    rpm -ivh MySQL-client-* >/dev/null
    echo "Installing MySQL-devel..."
    rpm -ivh MySQL-devel-* >/dev/null
    echo "Installing MySQL-shared..."
    rpm -ivh MySQL-shared-* >/dev/null

    chown -R mysql /var/lib/mysql/
    chmod -R 777 /var/lib/mysql/
    service mysql start

    cd /root/
    a=`sed -n 's/.*: \(\S\)/\1/p' .mysql_secret`
    echo "mysql initial password is $a"
    echo "modify mysql password"
    echo "please input the following command:set password=password('root123');quit"
    mysql -uroot -p$a
    cp $HOME_PACKAGES/my.cnf /etc/
    chkconfig --add mysql
    chkconfig mysql on
    chkconfig --list|grep mysql
    mysql -uroot -proot123 <<EOF
        create database das_uq default character set gbk;
        grant all on das_uq.* to das_uq@'%' identified by 'das_uq' WITH GRANT OPTION;
        grant all on das_uq.* to das_uq@'localhost' identified by 'das_uq';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root123' WITH GRANT OPTION;
        set global log_bin_trust_function_creators=1;
        GRANT SELECT ON mysql.proc TO das_uq@'%';
        FLUSH PRIVILEGES;
EOF
}

function setup_mysql_client()
{
    mysql_num=0
    ret=`rpm -qa|grep MySQL-client-5.6.21-1.linux_glibc2.5.x86_64 |wc -l`
    mysql_num+=$ret
    ret=`rpm -qa|grep MySQL-devel-5.6.21-1.linux_glibc2.5.x86_64 |wc -l`
    mysql_num+=$ret
    ret=`rpm -qa|grep MySQL-shared-5.6.22-1.el6.x86_64.rpm |wc -l`
    mysql_num+=$ret

    if [ $mysql_num -eq 3 ]; then
        return
    fi

    echo "clear mysql"
    rpm -e MySQL-client --nodeps
    rpm -e MySQL-devel --nodeps
    rpm -e MySQL-share --nodeps
    cd $HOME_PACKAGES
    echo "Installing MySQL-client..."
    rpm -ivh MySQL-client-* >/dev/null
    echo "Installing MySQL-devel..."
    rpm -ivh MySQL-devel-* >/dev/null
    echo "Installing MySQL-shared..."
    rpm -ivh MySQL-shared-* >/dev/null
}

function setup_ftp_server_client()
{
    echo "Deploying ftp server..."

    echo "creating user 'dasftp'..."
    useradd dasftp
    if [ $? == 0 ]; then
        echo dasftp |passwd --stdin dasftp
    fi

    service vsftpd restart
    chkconfig vsftpd on
    chkconfig --list|grep ftp

    echo "Deploying ftp client..."
    cd $HOME_PACKAGES
    rpm -ivh ftp-0.17-51.1.el6.x86_64.rpm
    #setsebool -P ftp_home_dir on
}

function setup_systemalarm()
{
    echo "Deploying systemalarm..."
    cd $HOME_PACKAGTES
    cp -rf das_uq.tar.gz /home/das_uq
    cd /home/das_uq
    tar xvfz das_uq.tar.gz >/dev/null
    cd /home/
    chown -R das_uq:das_uq das_uq/
    chmod -R 775 das_uq

    sudoers_num=`cat /etc/sudoers |grep das_uq |wc -l`
    if [ $sudoers_num == 0 ]; then
        sed -i 's/^Defaults.*requiretty$/\#Defaults requiretty/g' sudoers
        sudoers_conf="
            das_uq    ALL=(ALL)    ALL
            %das_uq ALL=(ALL) NOPASSWD: ALL))
        "
        echo "$sudoers_conf" >>/etc/sudoers
    fi
}

function create_user_das_uq()
{
    echo "creating user 'das_uq'..."
    useradd das_uq
    if [ $? == 0 ]; then
        echo das_uq |passwd --stdin das_uq
    fi

    env_num=`cat /home/das_uq/.bash_profile |grep DATABASE=mysql |wc -l`
    if [ env_num == 0 ]; then
        das_uq_env="
            export PATH=\$PATH:\$HOME/bin:\$HOME/tools:
            export DATABASE=mysql
            export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/lib:/usr/local/mysql/lib
        "
        echo "$das_uq_env" >>/home/das_uq/.bash_profile
    fi
}

function setup_omcweb()
{
    echo "creating user 'omcweb'..."
    useradd omcweb
    if [ $? == 0 ]; then
        echo omcweb |passwd --stdin omcweb
    fi

    env_num=`cat /etc/profile |grep JAVA_HOME |grep omcweb |wc -l`
    if [ env_num == 0 ]; then
        web_env="
            export JAVA_HOME=/home/omcweb/jdk1.6.0_27
            export PATH=\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin:\$PATH
            export CLASSPATH=\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib
            export TOMCAT_HOME=/home/omcweb/tomcat
            export CATALINA_OPTS="-Djava.awt.headless=true"
        "
        echo "$web_env" >>/etc/profile
    fi

    echo "Installing jdk..."
    cd $HOME_PACKAGES
    cp -rf apache-tomcat-6.0.32.tar.gz /home/omcweb/
    cp -rf jdk-6u27-linux-x64.bin /home/omcweb/
    cd /home/omcweb
    tar xvfz apache-tomcat-6.0.32.tar.gz >/dev/null
    mv apache-tomcat-6.0.32 tomcat
    chmod +x jdk-6u27-linux-x64.bin
    echo -e "\n" |./jdk-6u27-linux-x64.bin >/dev/null

    echo ""
    cd $HOME_PACKAGES
    cp -rf das_uq-web.tar.gz /home/omcweb/tomcat/webapps/ROOT/
    cd /home/omcweb/tomcat/webapps/
    rm -rf docs examples host-manager manager
    cd /home/omcweb/tomcat/webapps/ROOT/
    tar xvfz das_uq-web.tar.gz >/dev/null
    cd $HOME_PACKAGES
    chmod 777 mysql-connector-java-5.1.15-bin.jar 
    cp mysql-connector-java-5.1.15-bin.jar /home/omcweb/jdk1.6.0_27/jre/lib/ext
    cp omcweb /etc/init.d/
    chmod +x /etc/init.d/omcweb
    chkconfig --add omcweb
    chkconfig omcweb on
    chkconfig --list|grep omcweb
    cd $HOME_PACKAGES
    cp catalina.sh /home/omcweb/tomcat/bin
    chmod +x /home/omcweb/tomcat/bin/catalina.sh 
    cp server.xml /home/omcweb/tomcat/conf
    chmod +x /home/omcweb/tomcat/conf/server.xml
    cd /home/
    chown -R omcweb:omcweb omcweb/
    chmod -R 775 omcweb
    echo "omcweb installed"
}

function setup_das_uq()
{
    echo "Installing das_uq..."
    cd $HOME_PACKAGES
    cp -rf das_uq.tar.gz /home/das_uq
    cd /home/das_uq
    tar xvfz das_uq.tar.gz >/dev/null
    cd $HOME_PACKAGES
    cp das_uq /etc/init.d/
    chmod +x /etc/init.d/das_uq
    chkconfig --add das_uq
    chkconfig das_uq on
    chkconfig --list|grep das_uq
    cd /home/
    chown -R das_uq:das_uq das_uq/
    chmod -R 775 das_uq
    echo "das_uq installed"
}

function deploy_web()
{
    setup_mysql_client
    setup_systemalarm
    setup_omcweb
}

function deploy_app()
{
    setup_mysql_client
    setup_ftp_server_client
    setup_das_uq
}

function deploy_db()
{
    setup_mysql_server_client
    setup_systemalarm
}

echo "  ===== N M S s e t u p . s h ====="
check_files
pre_process
create_user_das_uq

echo "$homepage"
select_item
selected=$?
case $selected in
1)
    deploy_web
;;
2)
    deploy_app
;;
3)
    deploy_db
;;


esac
