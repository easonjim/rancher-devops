#!/bin/bash

yum install -y wget

cd /etc/yum.repos.d
mkdir bak
mv *.repo bak/

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo  
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum clean all
yum makecache

yum install -y container-selinux