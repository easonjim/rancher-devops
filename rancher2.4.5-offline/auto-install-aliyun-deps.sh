#!/bin/bash

cd `dirname $0`

# enable log
logfile=$(pwd)/${BASH_SOURCE##*/}.`date '+%Y%m%d%H%M%S'`.log
fifofile=$(pwd)/${BASH_SOURCE##*/}.log.fifo
rm -f "$fifofile"
mkfifo $fifofile
cat $fifofile | tee -a $logfile &
exec 3>&1
exec 4>&2
exec 1>$fifofile
exec 2>&1

# init system config
bash deps-aliyun/0.init.sh
[[ $? -eq -1 ]] && exit -1

# install docker by aliyun
bash deps-aliyun/1.install-yum.sh
bash deps-aliyun/2.install-docker-18.09.sh
bash deps-aliyun/3.install-jq.sh
bash deps-aliyun/4.install-ansible.sh

# disable log
printf "\015"
exec 1>&3
exec 2>&4
rm -f "$fifofile"
echo
echo "done."