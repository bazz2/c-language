#!/bin/sh
echo " "	
echo " "
while true
do
	echo "		[UQ NMS V2.5 Update_Web Script]"
	echo "	"
	echo "		1.[file backup]"
	echo "		2.[update file check]"
	echo "		3.[owner change]"
	echo "		4.[file update]"
	echo "		5.[quit]"
	echo " "
	echo -n "please choose the number: "
	read selected
	case $selected in
1)
	function file_backup()
{
	if [ ! -d "/home/work/backup/backup_V2.4_web" ];then
		echo "[/home/work/backup/backup_V2.4_web not found,the script will make it!]"
		mkdir -p /home/work/backup/backup_V2.4_web;
	fi
	echo "[backup files]"
	if [ ! -d "/home/omcweb/tomcat/webapps/ROOT" ];then
		echo "[ERROR: /home/omcweb/tomcat/webapps/ROOT not found!]"
        exit
	fi
	cd /home/omcweb/tomcat/webapps/ROOT
	if [ -f "Web_V2.4.tar.gz" ];then
		echo "[ERROR: Web_V2.4.tar.gz already exists!]"
		return
	fi
	tar czvf Web_V2.4.tar.gz *  >/dev/null 2>&1
	mv -f Web_V2.4.tar.gz /home/work/backup/backup_V2.4_web
	echo "[files backup finished]"
	echo "[files backup check:including quantity and size]"
	echo "[Web_V2.4.tar.gz should be in /home/work/backup/backup_V2.4_web]"
	ls -l /home/work/backup/backup_V2.4_web/Web_V2.4.tar.gz 2>&1
	echo "[files back check OK?,press 'y' or 'n' to continue!]"
	while true
do
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
	echo "[***file backup*** confirm,please input 'y' or 'n' to continue]"
	while true
do
	read  ab;
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
	function update_file_check()
{ 
	echo "[update files check......]"
	echo "[including quantity and size---]"
	echo "[1 files should be in /home/work/update/update_V2.5_web;]"
	cd /home/work/update/update_V2.5_web >/dev/null 2>&1
	if [ $? != 0 ];then
	echo "[folder '/home/work/update/update_V2.5_web' not found,please do the preparation first"
	break
	fi
	ls -l /home/work/update/update_V2.5_web
	echo " "
	quantity=`find /home/work/update/update_V2.5_web -type f| wc -l`
	size=`du -cb /home/work/update/update_V2.5_web/*|grep total|awk -F " " '{print$1}'`
	echo "[tolal quantity:$quantity]"
	echo "[total size:$size]"
	echo "[update files check OK?  press 'y' or 'n' to continue]"
	while true
do
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
echo "[***update file check*** confirm,please input 'y' or 'n' to continue]"
	while true
do
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
	function owner_change()
{
	echo "[owner change......]"
	cd /home/work/update/update_V2.5_web/  >/dev/null 2>&1
	if [ $? != 0 ]; then
	echo "[ERROR:folder /home/work/update/update_V2.5_web/ not exist,please do [2.update file check] first!]"
	continue
	fi
	chown -R omcweb:omcweb /home/work/update/update_V2.5_web/
	chmod 775 /home/work/update/update_V2.5_web/*
	ls -l /home/work/update/update_V2.5_web/
	echo " "
	quantity=`find /home/work/update/update_V2.5_web -type f| wc -l`
	size=`du -cb /home/work/update/update_V2.5_web/*|grep total|awk -F " " '{print$1}'`
	echo "[tolal quantity:$quantity]"
	echo "[total size:$size]"
	echo "[owner change check OK?  press 'y' or 'n' to continue]"
	while true
do
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
echo "[***owner change*** confirm,please input 'y' or 'n' to continue]"
	while true
do
	read  cb;
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
	function file_update()
{	
	echo "[file update......]"
	cd /home/work/update/update_V2.5_web >/dev/null 2>&1
	if [ $? != 0 ];then
		echo "[folder /home/work/update/update_V2.5_web not exist,please do [2.update file check] first!]"	
	continue
	fi
	echo "[stop web server]"
	su - omcweb -c "/home/omcweb/tomcat/bin/shutdown.sh"
	sleep 10
	ps -ef |grep java|grep -v grep | grep -v PID | awk '{print $2}'|xargs kill -9 >/dev/null 2>&1

	echo "web server stop success? press 'y' or 'n' to continue"
	while true
do
	read da;
	if [ -z $da ];then
		echo "[please input 'y' or 'n'] ";
	elif [ $da == 'n' ];then
		echo "[ERROR:web server stop failed,please stop it handly!]"
		exit 0;
	elif [ $da == 'y' ];then
		echo "[web server stop successfully!]";
	break
	else
		echo "[please input 'y' or 'n'] ";
	fi
done
	echo "[copy update files......]"
	cd /home/work/update/update_V2.5_web
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/alarmFrequentReport_en_US_total.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoList.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoListHis.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoListMask.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/alarmInfoReport_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/AlmAlarmlogHistory.hbm.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almCurrentalarmList_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/alarm/alarmInfo/AlmCurrentalarmlogviewAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/AlmCurrentalarmlogviewDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almHistoryalarmList_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almMaskalarmList_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/AlmMaskalarmlogviewDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-base.mysql.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/css/bhtIE6.css
	rm -rf /home/omcweb/tomcat/webapps/ROOT/css/bhtIE7.css
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/deviceLog.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/deviceLog_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/log/loginfo/DeviceLogAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/log/loginfo/DeviceLogDao.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/log/loginfo/DeviceLogDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/deviceLogDetails_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/log/loginfo/DeviceLogService.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/log/loginfo/DeviceLogServiceImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/util/DialectForInkfish.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/edCommon.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/elementDetail.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementDetailAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/elementList_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList_en_US.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementListAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/ElementListDao.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementListDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/ElementListServiceImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/ElementOperatorDao.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementOperatorDaoHibImpl$1.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementOperatorDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/ElementOperatorServiceImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementTopoDisplay/ElementTopoDisplayAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/fastjson-1.2.2.jar
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/fastjson-1.2.2-sources.jar
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/idleList.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/idleList_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/IdleListDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/login/LoginAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/logInfo_re_en_US.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/html/mainpage.html
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/mapTopoLogicGraph.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/mapTopoManager.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/winxp/NavBar.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/neEffectsWin.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskList_en_US.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/pollManage/PollTaskListAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/protal_resource_en_US.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/protal_resource_zh_CN.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/extendsBean/QueryUserDefined.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/resource_en_US.properties
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/struts-omc.xml
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/systemLog_en_US.ftl
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/TtGetqryparamreport.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/userDefinedReport.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/report/deviceInfo/UserDefinedReportDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/report/deviceInfo/UserDefinedReportServiceImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/userDefinedReportVOp.js
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/platform/affiche/AfficheAction.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/platform/affiche/AfficheVOp.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/DatchTaskSelectDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/DatchTaskSetDaoHibImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskSet.js
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskListVOp.js
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/projectProject/ProjectProcessDaoHibImpl.class
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/elementDetail_resource_en_US.js
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/DynamicSQL.hbm.xml
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/alarm/alarmInfo/AlmCurrentalarmlogviewDao.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/alarm/alarmInfo/AlmCurrentalarmlogviewService.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/alarm/alarmInfo/AlmCurrentalarmlogviewServiceImpl.class
	rm -rf /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/upgrade/batchUpgrade/pollTaskListVOp.js
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/upgrade/UpgradeFilesAction.class
	
	rm -rf /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementOperatorAction.class
	
	cp -rf /home/work/update/update_V2.5_web/ElementOperatorAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/UpgradeFilesAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/upgrade/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/web/pollTaskListVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/upgrade/batchUpgrade/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AlmCurrentalarmlogviewServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AlmCurrentalarmlogviewService.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/AlmCurrentalarmlogviewDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/DynamicSQL.hbm.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/elementDetail_resource_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/ProjectProcessDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/projectProject/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/pollTaskListVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf /home/work/update/update_V2.5_web/AfficheAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/platform/affiche/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AfficheVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/platform/affiche/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DatchTaskSelectDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DatchTaskSetDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/pollTaskSet.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
		
  cp -rf /home/work/update/update_V2.5_web/alarmFrequentReport_en_US_total.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/alarmInfoList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/alarmInfoListHis.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/alarmInfoListMask.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/alarmInfoReport_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/AlmAlarmlogHistory.hbm.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/AlmAlarmlogHistory.hbm.xml
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/almCurrentalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AlmCurrentalarmlogviewAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AlmCurrentalarmlogviewDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/almHistoryalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/almMaskalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/AlmMaskalarmlogviewDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/applicationContext-base.mysql.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/bhtIE6.css /home/omcweb/tomcat/webapps/ROOT/css/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/bhtIE7.css /home/omcweb/tomcat/webapps/ROOT/css/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/deviceLog.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/deviceLog_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DeviceLogAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DeviceLogDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DeviceLogDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/deviceLogDetails_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DeviceLogService.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DeviceLogServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/DialectForInkfish.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/util/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/edCommon.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/elementDetail.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementDetailAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/elementList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/elementList.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/elementList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/elementList_en_US.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementListAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementListDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementListDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementListServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf /home/work/update/update_V2.5_web/ElementOperatorDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementOperatorDaoHibImpl$1.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementOperatorDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementOperatorServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/ElementTopoDisplayAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementTopoDisplay/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/fastjson-1.2.2.jar /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/fastjson-1.2.2-sources.jar /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/idleList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/idleList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/IdleListDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/LoginAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/login/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/logInfo_re_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/mainpage.html /home/omcweb/tomcat/webapps/ROOT/html/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/mapTopoLogicGraph.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/mapTopoManager.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/NavBar.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/winxp/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/neEffectsWin.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/pollTaskList_en_US.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/PollTaskListAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/pollManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/protal_resource_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/protal_resource_zh_CN.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/QueryUserDefined.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/extendsBean/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/resource_en_US.properties /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	cp -rf /home/work/update/update_V2.5_web/struts-omc.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/systemLog_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/TtGetqryparamreport.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/userDefinedReport.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/UserDefinedReportDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/UserDefinedReportServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf /home/work/update/update_V2.5_web/userDefinedReportVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi

	
	chown -R omcweb:omcweb /home/omcweb/
	echo "[$m files copied!]"
	sleep 5
	echo "[files update check]"
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/projectProject/ProjectProcessDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskListVOp.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/platform/affiche/AfficheAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/platform/affiche/AfficheVOp.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/DatchTaskSelectDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/DatchTaskSetDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskSet.js
	if [ $? == 0  ];then
	let n++
	fi
	 
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/alarmFrequentReport_en_US_total.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoList.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoListHis.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/alarmInfoListMask.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/alarmInfoReport_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/AlmAlarmlogHistory.hbm.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almCurrentalarmList_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/alarm/alarmInfo/AlmCurrentalarmlogviewAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/AlmCurrentalarmlogviewDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almHistoryalarmList_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/almMaskalarmList_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/AlmMaskalarmlogviewDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-base.mysql.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/css/bhtIE6.css
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/css/bhtIE7.css
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/deviceLog.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/deviceLog_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/log/loginfo/DeviceLogAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/log/loginfo/DeviceLogDao.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/log/loginfo/DeviceLogDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/deviceLogDetails_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/log/loginfo/DeviceLogService.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/log/loginfo/DeviceLogServiceImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/util/DialectForInkfish.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/edCommon.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/elementDetail.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementDetailAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/elementList_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/elementList_en_US.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementListAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/ElementListDao.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementListDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/ElementListServiceImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/ElementOperatorDao.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementOperatorDaoHibImpl$1.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/ElementOperatorDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/ElementOperatorServiceImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementTopoDisplay/ElementTopoDisplayAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/fastjson-1.2.2.jar
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/fastjson-1.2.2-sources.jar
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/idleList.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/idleList_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/IdleListDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/login/LoginAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/logInfo_re_en_US.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/html/mainpage.html
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/mapTopoLogicGraph.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/mapTopoManager.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/winxp/NavBar.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/neEffectsWin.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/pollTaskList_en_US.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/pollManage/PollTaskListAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/protal_resource_en_US.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/protal_resource_zh_CN.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/extendsBean/QueryUserDefined.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/resource_en_US.properties
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/struts-omc.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/systemLog_en_US.ftl
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/TtGetqryparamreport.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/userDefinedReport.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/report/deviceInfo/UserDefinedReportDaoHibImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/report/deviceInfo/UserDefinedReportServiceImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/userDefinedReportVOp.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/elementDetail_resource_en_US.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/DynamicSQL.hbm.xml
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/alarm/alarmInfo/AlmCurrentalarmlogviewDao.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/alarm/alarmInfo/AlmCurrentalarmlogviewService.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/alarm/alarmInfo/AlmCurrentalarmlogviewServiceImpl.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/upgrade/batchUpgrade/pollTaskListVOp.js
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/upgrade/UpgradeFilesAction.class
	if [ $? == 0  ];then
	let n++
	fi
	
	ls -l /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/ElementOperatorAction.class
	if [ $? == 0  ];then
	let n++
	fi
		
  echo "[$n files listed!]"
	echo "[files update check OK?press 'y' or 'n' to continue]"
	while true
do
	read db;
	if [ -z $db ];then
		echo "[please input 'y' or 'n'] ";
	elif [ $db == 'n' ];then
		echo "[ERROR:files update check failed,please redo [4.file update]!]"
		exit 0;
	elif [ $db == 'y' ];then
		echo "[file update check finished]";
	break;
	else
		echo "[please input 'y' or 'n'] ";
	fi
done
	echo "[web server start]"
	su - omcweb -c "/home/omcweb/tomcat/bin/startup.sh"
	sleep 2
	echo "[web server start check?,press 'y' or 'n' to continue!]"
	while true
do
	read dc;
	if [ -z $dc ];then
		echo "[please input 'y' or 'n' ]";
	elif [ $dc == 'n' ];then
		echo "[ERROR:web server start failed,please start it handly,and redo [4.file update]!]"
		continue;
	elif [ $dc == 'y' ];then
		echo "[web server start finished]";
	break
	else
		echo "[please input 'y' or 'n'] ";
	fi
done
}
	echo "[***file update*** confirm,please input 'y' or 'n' to continue]"
	while true
do
	read  dd;
	if [ -z $dd ];then
		echo "[please input 'y' or 'n'] ";
	elif [ $dd == 'n' ];then
		echo "[*****Back to main menu******]"
		break;
	elif [ $dd == 'y' ];then
	echo "[file update]";
	file_update;
	break;
	else
	echo "[please input 'y' or 'n'] ";
	fi
done	
;;
5)
	echo " "
	echo "[script quit,GoodBye!]"
	exit 0;
;;
*)
	echo "[error input,please input 1-5!]"
;;
esac
done
