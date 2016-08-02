#!/bin/bash

nowtime=`date +"%Y-%m-%d %H:%M" -d "1 minute"`

task_id=283
host=127.0.0.1
if [ -z $1 ]; then
    echo checkout
elif [ $1 == 'new' ]; then
    mysql -udas_uq -pdas_uq das_uq -h $host -e "
    update man_task set tsk_nexttime='$nowtime' where tsk_taskid=$task_id;
    "
fi

while true; do
    clear
    mysql -udas_uq -pdas_uq das_uq -h $host -e "
    select TSK_TASKID as id,TSK_TASKNAME as name,TSK_PERIOD,TSK_LASTTIME,TSK_NEXTTIME,TSK_ISUSE as used from man_task where tsk_taskid=$task_id;
    select tkl_taskid as id,TKL_BEGINTIME,TKL_ENDTIME,TKL_TXPACKCOUNT as send,TKL_RXPACKCOUNT as recv,TKL_ELESUCCESSCOUNT as intime from man_tasklog order by tkl_tasklogid desc limit 10;
    "
    sleep 10
done
