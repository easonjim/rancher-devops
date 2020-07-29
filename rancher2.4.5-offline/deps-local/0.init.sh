#!/bin/bash

# config system
# disable firewall
systemctl stop firewalld
systemctl disable firewalld
# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# set hostname
ip=`hostname -I`
a=`echo $ip | awk -F'.' '{print $1}' | awk '{printf("%03d\n",$0)}' `
b=`echo $ip | awk -F'.' '{print $2}' | awk '{printf("%03d\n",$0)}' `
c=`echo $ip | awk -F'.' '{print $3}' | awk '{printf("%03d\n",$0)}' `
d=`echo $ip | awk -F'.' '{print $4}' | awk '{printf("%03d\n",$0)}' `
new_ip=`echo $ip | awk -F' ' '{print $1}'`
hostname_new="node-${a}${b}${c}${d}"
hostnamectl set-hostname ${hostname_new}
if [ `grep -c "${hostname_new}" /etc/hosts` -eq '0' ]; then
    echo >> /etc/hosts
    echo ${new_ip} ${hostname_new} >> /etc/hosts
fi
# check network
gateway_count=`route | grep 'default' | wc -l`
if [ ${gateway_count} -eq 0 ]; then
    echo The network does not have a default gateway, please check!
    exit -1
fi