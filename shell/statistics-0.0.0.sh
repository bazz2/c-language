#!/bin/bash
############################################
#
# = = N O T E = =
# this script used with grrusend-0.0.0
#
############################################


logfile1="grrusend-20160309.dbg"
logfile2="gprsserv-20160309.dbg"
logfile3="gprsserv-20160309.err"
#nowtime="-"`date +%y%m%d%H`
nowtime=""

if [ 0 == 0 ]; then
##
# statistics into csv
##
cat $logfile1 | grep -B 1 "发送.*报文" |grep -v '^--$'|sed 'N;s/\n//' |awk -F '[' '{print $3, $9}' |sed 's/]//g;s/~//g' >.tmp.GRRUSENDtoDAS$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GRRUSENDtoDAS$nowtie.csv
cat .tmp.GRRUSENDtoDAS$nowtime.csv |awk 'BEGIN{OFS=",";}{print $1,substr($2,5,8),substr($2,13,2),substr($2,15,4),substr($2,23,2),"GRRUSENDtoDAS"}' >GRRUSENDtoDAS$nowtime.csv

cat $logfile1 | grep -B 1 "接收应答报文" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $3, $7}' |sed 's/]//g;s/~//g' >.tmp.DAStoGRRUSEND$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.DAStoGRRUSEND$nowtie.csv 
cat .tmp.DAStoGRRUSEND$nowtie.csv |awk 'BEGIN{OFS=",";}{print $1,substr($2,5,8),substr($2,13,2),substr($2,15,4),substr($2,23,2),"DAStoGRRUSEND"}' >DAStoGRRUSEND$nowtime.csv

cat $logfile2 | grep -B 1 "接收请求报文" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $3, $7}' |sed 's/]//g;s/~//g' >.tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
cat .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv|awk 'BEGIN{OFS=",";}{print $1,substr($2,5,8),substr($2,13,2),substr($2,15,4),substr($2,23,2),"GRRUSENDrecvfromGPRSSERV"}' >GPRSSERVrecvfromGRRUSEND$nowtime.csv


cat GRRUSENDtoDAS$nowtime.csv | awk -F ',' '{print $4}' |sort|uniq >.uniq


echo "RepeaterId,DeviceId,PackageFlag,Cmd,grrusend2das,das2grrusend,gprsservRecvfromgrrusend">compare.csv
i=0
while read line; do
	# get all tasks' send/recv/resend time
	times_grrusend2das=`cat GRRUSENDtoDAS$nowtime.csv |grep ",$line," |awk -F ',' '{print $1}' |tr -s '\n' '#'`
	if [ "$times_grrusend2das" == "" ]; then
		times_grrusend2das=" "
	fi
	times_das2grrusend=`cat DAStoGRRUSEND$nowtime.csv |grep ",$line," |awk -F ',' '{print $1}' |tr -s '\n' '#'`
	if [ "$times_das2grrusend" == "" ]; then
		times_das2grrusend=" "
	fi
	times_gprsservRecvfromgrrusend=`cat GPRSSERVrecvfromGRRUSEND$nowtime.csv |grep ",$line," |awk -F ',' '{print $1}' |tr -s '\n' '#'`
	if [ "$times_gprsservRecvfromgrrusend" == "" ]; then
		times_gprsservRecvfromgrrusend=" "
	fi
	((i++))
	echo -en '\r'$i
	cat GRRUSENDtoDAS$nowtime.csv |grep ",$line," |awk -vA=$times_grrusend2das -vB=$times_das2grrusend -vD=$times_gprsservRecvfromgrrusend 'BEGIN{FS=",";OFS=",";}{print $2,$3,$4,$5,A,B,D;}' >>compare.csv
done <.uniq


else



echo 'grusend -> das:'
cat $logfile1 |grep "发送.*报文" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c >/tmp/rubbish
cat /tmp/rubbish | awk '{ print $2}' >/tmp/grrusend_to_das

echo 'das -> grrusend:'
cat $logfile1 | grep "接收应答报文" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c >/tmp/rubbish
cat /tmp/rubbish | awk '{ print $2}' >/tmp/das_to_grrusend
diff -Nura /tmp/grrusend_to_das /tmp/das_to_grrusend

echo 'succeed:'
cat $logfile1 |grep "succeed" |wc -l

echo 'grrusend -> gprsserv:'
cat $logfile1 |grep "发送数据到 GPRSSERV \[" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c >/tmp/rubbish

echo 'grrusend -X-> gprsserv:'
cat $logfile1 |grep "发送数据到 GPRSSERV 服务错误:" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'

echo "gprsserv -> grrusend:"
cat $logfile1 |grep "从 GPRSSERV 接收数据" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $3}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'

echo "gprsserv -X-> grrusend:"
cat $logfile1 |grep "接收数据 GPRSSERV 服务的应答报文错误" >/tmp/trash
cat /tmp/trash |wc -l

echo "GPRSSERV recv:"
cat $logfile2|grep "接收请求报文" >/tmp/trash
cat /tmp/trash |awk -F [ '{print $2}'|sort|uniq -c | wc -l
cat /tmp/trash |awk -F [ '{print $2}'|sort|uniq -c | awk '{if($1>1) print $1,$2}'

echo "GPRSSERV CRC error:"
cat $logfile3 |grep "接入层C:CRC校验错" |wc -l

fi
