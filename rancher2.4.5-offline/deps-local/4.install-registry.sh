#!/bin/bash

docker load < rancher-files/registry-latest.tar.gz
docker run --restart=unless-stopped --name registry -p 5000:5000 -v /data/registry:/var/lib/registry -d registry

ip=`hostname -i`

ir=$(cat << EOF
{
    "insecure-registries": [
        "${ip}:5000"
    ]
}
EOF
)

mkdir -p /etc/docker
echo ${ir} > /etc/docker/daemon.json

systemctl restart docker 