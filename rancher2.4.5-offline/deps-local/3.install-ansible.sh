#!/bin/bash

cd `dirname $0`

rpm -ivh ansible/*.rpm --force

# disable ssh check
sed -i 's/^#host_key_checking\ =\ False/host_key_checking = False/g' /etc/ansible/ansible.cfg
sed -i 's/^#host_key_checking\ =\ True/host_key_checking = False/g' /etc/ansible/ansible.cfg
sed -i 's/^host_key_checking\ =\ True/host_key_checking = False/g' /etc/ansible/ansible.cfg