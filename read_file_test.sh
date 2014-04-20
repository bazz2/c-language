#!/bin/sh

cat /var/run/osncdpscd.pid |while read pid 
do
    `kill -9 $pid`
done
exit 0
