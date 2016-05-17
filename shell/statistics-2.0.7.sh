#!/bin/bash
############################################
#
# = = N O T E = =
# this script used with grrusend-2.0.5
#
############################################

if [ -z $1 ] || [ $1 != "-v" ]; then
	mysqlcmd="
	select tkl_tasklogid as logid, 
	TKL_BEGINTIME,TKL_ENDTIME,TKL_TXPACKCOUNT as send,TKL_RXPACKCOUNT as recv, 
	TKL_ELESUCCESSCOUNT as InTime from man_tasklog a, man_task b where a.tkl_taskid=b.tsk_taskid order by tkl_tasklogid desc limit 10;
	"
else
	mysqlcmd="
	select tkl_tasklogid as logid,tkl_taskid as id,tsk_taskname as name, 
	TKL_BEGINTIME,TKL_ENDTIME,TKL_TXPACKCOUNT as send,TKL_RXPACKCOUNT as recv,
	TKL_ELESUCCESSCOUNT as InTime from man_tasklog a, man_task b where a.tkl_taskid=b.tsk_taskid order by tkl_tasklogid desc limit 10;
	"
fi

#host="-h 10.152.69.204"
host=""
clear
mysql -udas_uq -pdas_uq das_uq $host -e "$mysqlcmd"

echo -n "Input task log id: "
while true; do
	read id;
	if [ -z $id ]; then
		echo -n "Input task log id: "
	else
		break;
	fi
done

echo "Choosed task log id: $id"

orig=`mysql -udas_uq -pdas_uq das_uq -h $host -e "
select TKL_BEGINTIME,TKL_ENDTIME from man_tasklog where tkl_tasklogid=$id limit 1;
" 2>/dev/null`
starttime=`echo $orig |awk '{if($3)if($5!="NULL") print $3,$4}'`
endtime=`echo $orig |awk '{if($3)if($5!="NULL") print $5,$6}'`
echo "Starttime: $starttime"
echo "Endtime: $endtime"
if [ -z "$starttime" ] || [ -z "$endtime" ]; then
	echo "Error: invalid time"
	exit
fi


logfile="grrusend-*"
logfile2="gprsserv-*"
#nowtime="-"`date +%y%m%d%H`
nowtime=""

if [ 0 == 0 ]; then
##
# statistics into csv
##
cat $logfile | grep -B 1 "发送.*报文" |grep -v '^--$'|sed 'N;s/\n//' |awk -F '[' '{print $2,$3,$11}' |sed 's/]//g;s/~//g' |awk -vA="$starttime" -vB="$endtime" '{if($1" "$2>=A)if($1" "$2<=B) print}' >.tmp.GRRUSENDtoDAS$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GRRUSENDtoDAS$nowtie.csv
cat .tmp.GRRUSENDtoDAS$nowtime.csv |awk 'BEGIN{OFS=",";}{print $2,substr($3,5,10)substr($3,15,4),substr($3,23,2),"GRRUSENDtoDAS"}' >GRRUSENDtoDAS$nowtime.csv
echo -n "grrusend->das: "
wc -l GRRUSENDtoDAS$nowtime.csv

cat $logfile | grep -B 1 "接收应答报文" |grep -v '^--$' |sed 'N;s/\n//'|awk -F '[' '{print $2,$3,$9}' |sed 's/]//g;s/~//g' | awk -vA="$starttime" -vB="$endtime" '{if($1" "$2>=A)if($1" "$2<=B) print}' >.tmp.DAStoGRRUSEND$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.DAStoGRRUSEND$nowtie.csv 
cat .tmp.DAStoGRRUSEND$nowtie.csv |awk 'BEGIN{OFS=",";}{print $2,substr($3,5,10)substr($3,15,4),substr($3,23,2),"DAStoGRRUSEND"}' >DAStoGRRUSEND$nowtime.csv
echo -n "das->grrusend: "
wc -l DAStoGRRUSEND$nowtime.csv

cat $logfile | grep -B 1 "Send msg to GPRSSERV \[" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $2,$3,$8}' |sed 's/]//g;s/~//g' | awk -vA="$starttime" -vB="$endtime" '{if($1" "$2>=A)if($1" "$2<=B) print}' >.tmp.GRRUSENDtoGPRSSERV$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GRRUSENDtoGPRSSERV$nowtie.csv 
cat .tmp.GRRUSENDtoGPRSSERV$nowtie.csv |awk 'BEGIN{OFS=",";}{print $2,substr($3,5,10)substr($3,15,4),substr($3,23,2),"GRRUSENDtoGPRSSERV"}' >GRRUSENDtoGPRSSERV$nowtime.csv
echo -n "grrusend->gprsserv: "
wc -l GRRUSENDtoGPRSSERV$nowtime.csv

# grep -v '410107....~]' is ignore heartbeat
cat $logfile2 | grep -B 1 "Receive msg" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $2,$3,$7}' |grep -v '410107....~]' |sed 's/]//g;s/~//g' | awk -vA="$starttime" -vB="$endtime" '{if($1" "$2>=A)if($1" "$2<=B) print}' >.tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
cat .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv|awk 'BEGIN{OFS=",";}{print $2,substr($3,5,10)substr($3,15,4),substr($3,23,2),"GRRUSENDrecvfromGPRSSERV"}' >GPRSSERVrecvfromGRRUSEND$nowtime.csv
echo -n "gprsserv<-grrusend: "
wc -l GPRSSERVrecvfromGRRUSEND$nowtime.csv

cat GRRUSENDtoDAS$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq >.uniq
echo "Id,Cmd,grrusend2das,das2grrusend,grrusend2gprsserv,gprsservRecvfromgrrusend">compare.csv

i=0
echo -e "\n**********"
while read line; do
	# get all tasks' send/recv/resend time
	times_grrusend2das=`cat GRRUSENDtoDAS$nowtime.csv |grep ",$line," |awk -F . '{print $1}' |tr -s '\n' '#'`
	if [ "$times_grrusend2das" == "" ]; then
		times_grrusend2das=" "
	fi
	times_das2grrusend=`cat DAStoGRRUSEND$nowtime.csv |grep ",$line," |awk -F . '{print $1}' |tr -s '\n' '#'`
	if [ "$times_das2grrusend" == "" ]; then
		times_das2grrusend=" "
	fi
	times_grrusend2gprsserv=`cat GRRUSENDtoGPRSSERV$nowtime.csv |grep ",$line," |awk -F . '{print $1}' |tr -s '\n' '#'`
	if [ "$times_grrusend2gprsserv" == "" ]; then
		times_grrusend2gprsserv=" "
	fi
	times_gprsservRecvfromgrrusend=`cat GPRSSERVrecvfromGRRUSEND$nowtime.csv |grep ",$line," |awk -F . '{print $1}' |tr -s '\n' '#'`
	if [ "$times_gprsservRecvfromgrrusend" == "" ]; then
		times_gprsservRecvfromgrrusend=" "
	fi
	((i++))
	echo -en '\r'$i
	cat GRRUSENDtoDAS$nowtime.csv |grep -m 1 ",$line," |awk -vA=$times_grrusend2das -vB=$times_das2grrusend -vC=$times_grrusend2gprsserv -vD=$times_gprsservRecvfromgrrusend 'BEGIN{FS=",";OFS=",";}{print $2,$3,A,B,C,D;}' >>compare.csv
done <.uniq
echo -e "\n**********"
fi
tail -n +2 compare.csv |sort -t ',' -k 3 >compare_sort.csv

##
# get package number of all steps, pointer out which package is lost
##
if [ 0 == 0 ]; then
echo ""
echo -n 'Grrusend to das package num: '
cat GRRUSENDtoDAS$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GRRUSENDtoDAS$nowtime.csv
cat .diff.GRRUSENDtoDAS$nowtime.csv | wc -l 
echo -n 'Das to grrusend package num: '
cat DAStoGRRUSEND$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.DAStoGRRUSEND$nowtime.csv
cat .diff.DAStoGRRUSEND$nowtime.csv |wc -l
echo -n 'Grrusend to gprsserv package num: '
cat GRRUSENDtoGPRSSERV$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GRRUSENDtoGPRSSERV$nowtime.csv
cat .diff.GRRUSENDtoGPRSSERV$nowtime.csv |wc -l
echo -n 'Gprsserv recv package num: '
cat GPRSSERVrecvfromGRRUSEND$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv
cat .diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv |wc -l

echo "You can check out *.patch files to ensure which package is lost in which step"
diff -Nura .diff.GRRUSENDtoDAS$nowtime.csv .diff.DAStoGRRUSEND$nowtime.csv >GRRUSEND_DAS$nowtime.patch
diff -Nura .diff.DAStoGRRUSEND$nowtime.csv .diff.GRRUSENDtoGPRSSERV$nowtime.csv >GRRUSEND_GPRSSERV$nowtime.patch
diff -Nura .diff.GRRUSENDtoGPRSSERV$nowtime.csv .diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv >GPRSSERV_GRRUSEND$nowtime.patch
fi

