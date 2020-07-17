#!/bin/bash

cd `dirname $0`

rpm -ivh selinux-policy/*.rpm --force
rpm -ivh docker18.9/*.rpm --force

systemctl enable docker.service
systemctl start docker.service