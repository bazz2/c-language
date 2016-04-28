#!/bin/bash
############################################
#
# = = N O T E = =
# this script used with grrusend-2.0.5
#
############################################


logfile="grrusend-20160502.dbg"
logfile2="gprsserv-20160502.dbg*"
logfile3="gprsserv-20160502.err"
#nowtime="-"`date +%y%m%d%H`
nowtime=""

if [ 1 == 0 ]; then
##
# statistics into csv
##
cat $logfile | grep -B 1 "发送.*报文" |grep -v '^--$'|sed 'N;s/\n//' |awk -F '[' '{print $3, $11}' |sed 's/]//g;s/~//g' >.tmp.GRRUSENDtoDAS$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GRRUSENDtoDAS$nowtie.csv
cat .tmp.GRRUSENDtoDAS$nowtime.csv |awk 'BEGIN{OFS=",";}{print $1,substr($2,5,10)substr($2,15,4),substr($2,23,2),"GRRUSENDtoDAS"}' >GRRUSENDtoDAS$nowtime.csv

cat $logfile | grep -B 1 "接收应答报文" |grep -v '^--$' |sed 'N;s/\n//'|awk -F '[' '{print $3, $9}' |sed 's/]//g;s/~//g' >.tmp.DAStoGRRUSEND$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.DAStoGRRUSEND$nowtie.csv 
cat .tmp.DAStoGRRUSEND$nowtie.csv |awk 'BEGIN{OFS=",";}{print $1,substr($2,5,10)substr($2,15,4),substr($2,23,2),"DAStoGRRUSEND"}' >DAStoGRRUSEND$nowtime.csv

cat $logfile | grep -B 1 "发送数据到 GPRSSERV \[" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $3, $8}' |sed 's/]//g;s/~//g' >.tmp.GRRUSENDtoGPRSSERV$nowtime.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GRRUSENDtoGPRSSERV$nowtie.csv 
cat .tmp.GRRUSENDtoGPRSSERV$nowtie.csv |awk 'BEGIN{OFS=",";}{print $1,substr($2,5,10)substr($2,15,4),substr($2,23,2),"GRRUSENDtoGPRSSERV"}' >GRRUSENDtoGPRSSERV$nowtime.csv

cat $logfile2 | grep -B 1 "Receive msg" |grep -v '^--$' |sed 'N;s/\n//' |awk -F '[' '{print $3, $7}' |sed 's/]//g;s/~//g' >.tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
sed -i 's/5E5D/5E/g;s/5E7D/7E/g' .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv
cat .tmp.GPRSSERVrecvfromGRRUSEND$nowtie.csv|awk 'BEGIN{OFS=",";}{print $1,substr($2,5,10)substr($2,15,4),substr($2,23,2),"GRRUSENDrecvfromGPRSSERV"}' >GPRSSERVrecvfromGRRUSEND$nowtime.csv


cat GRRUSENDtoDAS$nowtime.csv DAStoGRRUSEND$nowtime.csv GRRUSENDtoGPRSSERV$nowtime.csv |sort >allqueue

cat GRRUSENDtoDAS$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq >.uniq


echo "Id,Cmd,grrusend2das,das2grrusend,grrusend2gprsserv,gprsservRecvfromgrrusend">compare.csv
i=0
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
fi

##
# get package number of all steps, pointer out which package is lost
##
if [ 0 == 0 ]; then
echo ""
echo 'Grrusend to das package num:'
cat GRRUSENDtoDAS$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GRRUSENDtoDAS$nowtime.csv
cat .diff.GRRUSENDtoDAS$nowtime.csv | wc -l 
echo 'Das to grrusend package num:'
cat DAStoGRRUSEND$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.DAStoGRRUSEND$nowtime.csv
cat .diff.DAStoGRRUSEND$nowtime.csv |wc -l
echo 'Grrusend to gprsserv package num:'
cat GRRUSENDtoGPRSSERV$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GRRUSENDtoGPRSSERV$nowtime.csv
cat .diff.GRRUSENDtoGPRSSERV$nowtime.csv |wc -l
echo 'Gprsserv recv package num:'
cat GPRSSERVrecvfromGRRUSEND$nowtime.csv | awk -F ',' '{print $2}' |sort|uniq -c >.diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv
cat .diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv |wc -l

echo "You can check out *.patch files to ensure which package is lost in which step"
diff -Nura .diff.GRRUSENDtoDAS$nowtime.csv .diff.DAStoGRRUSEND$nowtime.csv >GRRUSEND_DAS$nowtime.patch
diff -Nura .diff.DAStoGRRUSEND$nowtime.csv .diff.GRRUSENDtoGPRSSERV$nowtime.csv >GRRUSEND_GPRSSERV$nowtime.patch
diff -Nura .diff.GRRUSENDtoGPRSSERV$nowtime.csv .diff.GPRSSERVrecvfromGRRUSEND$nowtime.csv >GPRSSERV_GRRUSEND$nowtime.patch
fi

