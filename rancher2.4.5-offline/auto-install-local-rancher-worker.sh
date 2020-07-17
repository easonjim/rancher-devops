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

# run ansible command
[[ ! -f /root/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 2048 -P '' -f /root/.ssh/id_rsa
ansible-playbook -i ansible-files/rancher-hosts ansible-files/ssh-addkey.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/install-rsync-local.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/copy-docker-daemon-file-worker.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/copy-deps-file-worker.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/install-deps-local-worker.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/install-rancher-local-worker.yml

# disable log
printf "\015"
exec 1>&3
exec 2>&4
rm -f "$fifofile"
echo
echo "done."