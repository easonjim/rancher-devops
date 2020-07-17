# 安装顺序
container-selinux-2.107-3.el7.noarch.rpm
containerd.io-1.2.6-3.3.el7.x86_64.rpm
docker-ce-cli-18.09.5-3.el7.x86_64.rpm
docker-ce-18.09.5-3.el7.x86_64.rpm

# 出现问题：
安装selinux时出现如下问题时
selinux-policy >= 3.13.1-216.el7 is needed by ...
通过升级selinux-policy来解决
yum -y update selinux-policy

# 配置服务
systemctl enable docker.service
systemctl start docker.service
