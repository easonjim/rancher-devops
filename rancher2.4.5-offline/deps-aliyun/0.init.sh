#!/bin/bash

# config system
# disable firewall
systemctl stop firewalld
systemctl disable firewalld
# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# sync time
systemctl status chronyd 
systemctl enable chronyd
systemctl restart chronyd
timedatectl set-timezone Asia/Shanghai
chronyc -a makestep
# set hostname
ip=`hostname -I`
a=`echo $ip | awk -F'.' '{print $1}' | awk '{printf("%03d\n",$0)}' `
b=`echo $ip | awk -F'.' '{print $2}' | awk '{printf("%03d\n",$0)}' `
c=`echo $ip | awk -F'.' '{print $3}' | awk '{printf("%03d\n",$0)}' `
d=`echo $ip | awk -F'.' '{print $4}' | awk '{printf("%03d\n",$0)}' `
hostname_new="node-${a}${b}${c}${d}"
hostnamectl set-hostname ${hostname_new}
if [ `grep -c "${hostname_new}" /etc/hosts` -eq '0' ]; then
    echo ${ip} ${hostname_new} >> /etc/hosts
fi

# check network
ret_code=`curl -I -s --connect-timeout 60 www.baidu.com -w %{http_code} | tail -n1`
if [ "x$ret_code" != "*200*" ]; then
    echo The network is not working, please check!
    exit -1
fi
gateway_count=`route | grep 'default' | wc -l`
if [ ${gateway_count} -eq 0 ]; then
    echo The network does not have a default gateway, please check!
    exit -1
fi