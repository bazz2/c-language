#!/bin/bash

all_host=(172.25.6.90 172.25.6.91 173.25.6.92)

for host in ${all_host[@]}; do
    ssh das_uq@$host "chmod 700 /home/das_uq"
    ssh-copy-id -i ~/.ssh/id_rsa.pub das_uq@$host
done
