#!/bin/bash

cd `dirname $0`

yum -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  containerd.io \
                  docker-ce-cli

rpm -ivh selinux-policy/*.rpm --force
rpm -ivh docker18.9/*.rpm --force

systemctl enable docker.service
systemctl start docker.service