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

# install docker hub registry 
bash deps-local/4.install-registry.sh

# load rancher offline images
echo loading images...
cd rancher-files
bash ./rancher-load-images.sh --image-list ./rancher-images.txt --registry `hostname -i`:5000
cd ..
echo loaded images...

# run ansible command
[[ ! -f /root/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 2048 -P '' -f /root/.ssh/id_rsa
ansible-playbook -i ansible-files/rancher-hosts ansible-files/ssh-addkey.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/install-rsync-local.yml
ansible-playbook -i ansible-files/rancher-hosts ansible-files/install-rancher-local-master.yml

# disable log
printf "\015"
exec 1>&3
exec 2>&4
rm -f "$fifofile"
echo
echo "done."