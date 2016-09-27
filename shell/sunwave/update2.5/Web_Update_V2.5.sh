#!/bin/sh

backup_dir="/home/work/backup/backup_V2.4_web"
update_dir="/home/work/update/update_V2.5_web"

function file_backup()
{
	if [ ! -d "$backup_dir" ];then
		echo "[$backup_dir not found,the script will make it!]"
		mkdir -p $backup_dir;
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
	mv -f Web_V2.4.tar.gz $backup_dir
	echo "[files backup finished]"
	echo "[Web_V2.4.tar.gz should be in $backup_dir]"
	ls -l $backup_dir/Web_V2.4.tar.gz 2>&1
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
		echo "[folder $update_dir not found,please do the preparation first"
		return
	fi
	ls -l $update_dir
	echo " "
	quantity=`find $update_dir -type f| wc -l`
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
	cd $update_dir/  >/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "[ERROR:folder $update_dir/ not exist,please do [2.update file check] first!]"
		return
	fi
	chown -R omcweb:omcweb $update_dir/
	chmod 775 $update_dir/*
	ls -l $update_dir/
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
	echo "[file update......]"
	cd $update_dir >/dev/null 2>&1
	if [ $? != 0 ];then
		echo "[folder $update_dir not exist,please do [2.update file check] first!]"	
		return
	fi
	echo "[stop web server]"
	su - omcweb -c "/home/omcweb/tomcat/bin/shutdown.sh"
	sleep 10
	ps -ef |grep java|grep -v grep | grep -v PID | awk '{print $2}'|xargs kill -9 >/dev/null 2>&1

	echo "web server stop success? press 'y' or 'n' to continue"
	while true; do
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
	cd $update_dir
	
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
	
	cp -rf $update_dir/ElementOperatorAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/UpgradeFilesAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/upgrade/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/web/pollTaskListVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/upgrade/batchUpgrade/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/AlmCurrentalarmlogviewServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/AlmCurrentalarmlogviewService.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/AlmCurrentalarmlogviewDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/DynamicSQL.hbm.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/elementDetail_resource_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/ProjectProcessDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/projectProject/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/pollTaskListVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
  cp -rf $update_dir/AfficheAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/platform/affiche/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/AfficheVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/platform/affiche/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/DatchTaskSelectDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/DatchTaskSetDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/pollTaskSet.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	   let m++
	fi
		
  cp -rf $update_dir/alarmFrequentReport_en_US_total.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/alarmInfoList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/alarmInfoListHis.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/alarmInfoListMask.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/alarmInfoReport_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/AlmAlarmlogHistory.hbm.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/hbm/mysql/omc/AlmAlarmlogHistory.hbm.xml
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/almCurrentalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/AlmCurrentalarmlogviewAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/AlmCurrentalarmlogviewDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/almHistoryalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/almMaskalarmList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/AlmMaskalarmlogviewDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/alarm/alarmInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/applicationContext-base.mysql.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/bhtIE6.css /home/omcweb/tomcat/webapps/ROOT/css/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/bhtIE7.css /home/omcweb/tomcat/webapps/ROOT/css/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/deviceLog.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/deviceLog_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/DeviceLogAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/DeviceLogDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/DeviceLogDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/deviceLogDetails_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/DeviceLogService.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/iface/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/DeviceLogServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/log/loginfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/DialectForInkfish.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/util/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/edCommon.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/elementDetail.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementDetail/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/ElementDetailAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/elementList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/elementList.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/elementList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/elementList_en_US.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/ElementListAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementListDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementListDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementListServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	  cp -rf $update_dir/ElementOperatorDao.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/iface/omc/element/elementManage/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/ElementOperatorDaoHibImpl$1.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementOperatorDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementOperatorServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/ElementTopoDisplayAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/elementTopoDisplay/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/fastjson-1.2.2.jar /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/
  if [ $? == 0  ];then
	   let m++
	fi
	
	cp -rf $update_dir/fastjson-1.2.2-sources.jar /home/omcweb/tomcat/webapps/ROOT/WEB-INF/lib/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/idleList.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/idleList_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/IdleListDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/LoginAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/login/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/logInfo_re_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/log/logInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/mainpage.html /home/omcweb/tomcat/webapps/ROOT/html/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/mapTopoLogicGraph.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/mapTopoManager.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/map/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/NavBar.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/winxp/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/neEffectsWin.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/elementManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/pollTaskList_en_US.xml /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/element/pollManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/PollTaskListAction.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/action/omc/element/pollManage/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/protal_resource_en_US.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/protal_resource_zh_CN.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/viewport/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/QueryUserDefined.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/extendsBean/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/resource_en_US.properties /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	cp -rf $update_dir/struts-omc.xml /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/systemLog_en_US.ftl /home/omcweb/tomcat/webapps/ROOT/WEB-INF/template/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/TtGetqryparamreport.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/domain/pojo/omc/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/userDefinedReport.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/UserDefinedReportDaoHibImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/dao/impl/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/UserDefinedReportServiceImpl.class /home/omcweb/tomcat/webapps/ROOT/WEB-INF/classes/com/sunwave/service/impl/omc/report/deviceInfo/
  if [ $? == 0  ];then
	let m++
	fi
	
	cp -rf $update_dir/userDefinedReportVOp.js /home/omcweb/tomcat/webapps/ROOT/js/com/sunwave/view/business/omc/report/deviceInfo/
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
	while true; do
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
	while true; do
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

##
# main
##
echo " "	
echo " "
while true; do
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
		echo "[***file backup*** confirm,please input 'y' or 'n' to continue]"
		while true; do
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
		echo "[***file update*** confirm,please input 'y' or 'n' to continue]"
		while true; do
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
