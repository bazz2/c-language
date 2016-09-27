#!/bin/sh

homepage="
  1) create users;
  2) mysql setup;
  3) 
  4) 
  5) 
  6) 
"

echo "setup and configuration"
echo "
please confirm the following packages are in /home/packages/:
    MySQL-client-5.6.21-1.linux_glibc2.5.x86_64.rpm
    MySQL-devel-5.6.21-1.linux_glibc2.5.x86_64.rpm
    MySQL-devel-5.6.21-1.linux_glibc2.5.x86_64.rpm
    MySQL-server-5.6.21-1.linux_glibc2.5.x86_64.rpm
    MySQL-shared-5.6.22-1.el6.x86_64.rpm
    pcre-devel-7.8-3.1.el6.x86_64.rpm
    apache-tomcat-6.0.32.tar
    omcweb/
    das_uq/
    jdk-6u27-linux-x64/
    configuration files:
        server
        udp_check
        my.cnf
        mysqlcheck"
service iptables stop
chkconfig iptables off
echo "cd /home/packages/"
cd /home/packages/
chmod -R 755 *
ls *
echo "please select the item：1、create user；2、mysql setup;3、omcweb setup;4、app setup;5、mysql client setup;6、systemalarm setup;7、ftp setup"
read selected
case $selected in
1)
echo "create user，ctrl+c"
useradd das_uq
echo das_uq|passwd --stdin das_uq
echo "das_uq is created successfully "
useradd omcweb
echo omcweb|passwd --stdin omcweb
echo "omcweb is created successfully "
useradd dasftp
echo dasftp|passwd --stdin dasftp
echo "dasftp is created successfully "
;;
2)
echo "mysql setup"
rpm -qa | grep -i 'mysql-' |xargs rpm -e --nodeps
cd /root/
rm -rf .mysql_secret
cd /var/lib/mysql/
rm -rf *
cd /home/packages/
rpm -ivh MySQL-server-*>/dev/null
echo "Mysql-server installed"
rpm -ivh MySQL-client-*>/dev/null
echo "Mysql-client  installed"
rpm -ivh MySQL-devel-*>/dev/null
echo "Mysql-devel  installed"
rpm -ivh  MySQL-shared-*>/dev/null
echo " MySQL-shared installed"
chown -R mysql /var/lib/mysql/
chmod -R 777 /var/lib/mysql/
service mysql start
cd /root/
a=`sed -n 's/.*: \(\S\)/\1/p' .mysql_secret`
echo "mysql initial password is $a"
echo "modify mysql password"
echo "please input the following command:set password=password('root123');quit"
mysql -uroot -p$a
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 
/usr/sbin/setenforce 0
cd /home/packages
cp my.cnf /etc/
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
echo "Mysql installed"
;;
3)
echo "omcweb setup"
cd /home/packages/
cp -rf apache-tomcat-6.0.32.tar.gz /home/omcweb/
cp -rf jdk-6u27-linux-x64.bin /home/omcweb/
cd /home/omcweb
tar xvfz apache-tomcat-6.0.32.tar.gz >>/dev/null
mv apache-tomcat-6.0.32 tomcat
chmod +x jdk-6u27-linux-x64.bin
echo -e "\n"|./jdk-6u27-linux-x64.bin >>/dev/null
echo "jdk installed"
cat >>/etc/profile<<EOF
export JAVA_HOME=/home/omcweb/jdk1.6.0_27
export PATH=\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin:\$PATH
export CLASSPATH=\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib
export TOMCAT_HOME=/home/omcweb/tomcat
export  CATALINA_OPTS="-Djava.awt.headless=true"
EOF
cd /home/packages/
cp -rf das_uq-web.tar.gz /home/omcweb/tomcat/webapps/ROOT/
cd /home/omcweb/tomcat/webapps/
rm -rf docs
rm -rf examples
rm -rf host-manager
rm -rf manager
cd /home/omcweb/tomcat/webapps/ROOT/
tar xvfz das_uq-web.tar.gz >/dev/null
cd /home/packages/
chmod 777 mysql-connector-java-5.1.15-bin.jar 
cp mysql-connector-java-5.1.15-bin.jar  /home/omcweb/jdk1.6.0_27/jre/lib/ext
cp omcweb /etc/init.d/
cd /etc/init.d/
chmod +x omcweb
chkconfig --add omcweb
chkconfig omcweb on
chkconfig --list|grep omcweb
cd /home/packages/
cp catalina.sh /home/omcweb/tomcat/bin
chmod +x /home/omcweb/tomcat/bin/catalina.sh 
cp server.xml /home/omcweb/tomcat/conf
chmod +x /home/omcweb/tomcat/conf/server.xml
cd /home/
chown -R omcweb:omcweb omcweb/
chmod -R 775 omcweb
echo "omcweb installed"
;;
4)
echo "das_uq setup"
cd /home/packages/
cp -rf das_uq.tar.gz /home/das_uq
cd /home/das_uq
tar xvfz das_uq.tar.gz>/dev/null
cd /home/packages/
cp das_uq /etc/init.d/
cd /etc/init.d/
chmod +x das_uq
chkconfig --add das_uq
chkconfig das_uq on
chkconfig --list|grep das_uq
cd /home/
chown -R das_uq:das_uq das_uq/
chmod -R 775 das_uq
cat >>/home/das_uq/.bash_profile<<EOF
PATH=\$PATH:\$HOME/bin:\$HOME/tools:
export PATH
export DATABASE=mysql
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/10.2
export PATH=\$ORACLE_HOME/bin:\$PATH
export ORACLE_SID=omcl
export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
export ORA_NLS33=\$ORACLE_HOME/ocommon/nls/admin/data
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib:\$HOME/lib:/usr/local/mysql/lib
export PS1="["'\$PWD'"]"
#unset LANG
alias l='ls -l'
alias rm="rm -i"
alias ls="ls -CF"
export SVN_EDITOR=vi
export UDPTEST=0
EOF
echo "das_uq installed"
;;
5)
echo "mysql client setup"
rpm -qa | grep -i 'mysql-' |xargs rpm -e --nodeps
cd /root/
rm -rf .mysql_secret
cd /var/lib/mysql/
rm -rf *
cd /home/packages/
rpm -ivh MySQL-client-*>/dev/null
echo "Mysql-client  installed"
rpm -ivh MySQL-devel-*>/dev/null
echo "Mysql-devel  installed"
rpm -ivh  MySQL-shared-*>/dev/null
echo " MySQL-shared installed"
echo "Mysql client installed"
;;
6)
echo "systemalarm setup"
cd /home/packages/
cp -rf das_uq.tar.gz /home/das_uq
cd /home/das_uq
tar xvfz das_uq.tar.gz>/dev/null
cd /home/
chown -R das_uq:das_uq das_uq/
chmod -R 775 das_uq
cat >>/home/das_uq/.bash_profile<<EOF
PATH=\$PATH:\$HOME/bin:\$HOME/tools:
export PATH
export DATABASE=mysql
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/10.2
export PATH=\$ORACLE_HOME/bin:\$PATH
export ORACLE_SID=omcl
export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
export ORA_NLS33=\$ORACLE_HOME/ocommon/nls/admin/data
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME/lib:\$HOME/lib:/usr/local/mysql/lib
export PS1="["'\$PWD'"]"
#unset LANG
alias l='ls -l'
alias rm="rm -i"
alias ls="ls -CF"
export SVN_EDITOR=vi
export UDPTEST=0
EOF
echo "systemalarm installed"
;;
7)
echo "ftp client setup"
service vsftpd restart
chkconfig vsftpd on
chkconfig --list|grep ftp
cd /home/packages
rpm -ivh ftp-0.17-51.1.el6.x86_64.rpm
setsebool -P ftp_home_dir on
echo "ftp client installed"
;;

esac
