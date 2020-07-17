#!/bin/bash

docker pull registry:latest
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
im=$(cat /etc/docker/daemon.json)

mkdir -p /etc/docker
echo ${ir} ${im} | jq -s add > /etc/docker/daemon.json

systemctl restart docker 