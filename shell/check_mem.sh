#!/bin/bash

all_servers=(applserv grrusend grrurecv gprsserv timeserv hbserv)
for srv in ${all_servers[@]}; do
	date >> /tmp/$srv.top
	ps aux --sort -rss |grep $srv |grep -v 'grep' |awk '{print $6, $10}' >> /tmp/$srv.top
done

free >> /tmp/all_mem.log
