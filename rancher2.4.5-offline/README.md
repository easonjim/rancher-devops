# 系统版本要求
CentOS：7.4/7.5/7.6/7.7  
Docker：18.09/19.03  
Rancher：2.4.5  
k8s：1.17/1.18  
磁盘空间：50G
内存：4G（master 2G）
CPU：2核
# 初始化设置
## 设置hostname
```shell
hostnamectl set-hostname rancher-node{n}
```
## 关闭防火墙
```shell
systemctl stop firewalld
systemctl disable firewalld
```
## 关闭SELINUX
```shell
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```
## 配置静态IP（可选）
```shell
# 可选，eth0根据实际情况替换
vi /etc/sysconfig/network-scripts/ifcfg-eth0
# 可选，修改BOOTPROTO为static
sed -i 's/^BOOTPROTO=dhcp/BOOTPROTO=static/g' /etc/sysconfig/network-scripts/ifcfg-eth0
# 可选，增加固定IP项
cat << EOF > /etc/docker/daemon.json
IPADDR=192.168.57.193
NETMASK=255.255.255.0
GATEWAY=192.168.57.1
EOF
# 可选，重启网卡
service network restart
# 可选，增加DNS
echo "nameserver 223.5.5.5" > /etc/resolv.conf
```
## 时间对齐
```shell
systemctl status chronyd 
systemctl enable chronyd
systemctl restart chronyd
timedatectl set-timezone Asia/Shanghai
chronyc -a makestep
```
## 重启
```shell
reboot
```
# 自动化安装
## 外网
```shell
# 修改配置
ansible-files/rancher-hosts修改主机IP信息
ansible-files/install-rancher-aliyun-master.yml修改挂载路径
ansible-files/install-rancher-aliyun-worker.yml修改挂载路径，修改master ip及master token；注意：token需要安装好master之后新增集群才可看到

# 首次安装
# 安装依赖
bash auto-install-aliyun-deps.sh
# 安装master
bash auto-install-aliyun-rancher-master.sh
# 安装worker
bash auto-install-aliyun-rancher-worker.sh

# 增加节点
ansible-files/install-rancher-aliyun-worker.yml屏蔽[rancher-worker]已经安装过的主机，增加需要新增的主机，安装好后把屏蔽的主机接触屏蔽
# 安装worker
bash auto-install-aliyun-rancher-worker.sh
```
## 内网
```shell
# 修改配置
ansible-files/rancher-hosts修改主机IP信息
ansible-files/install-rancher-local-master.yml修改挂载路径
ansible-files/install-rancher-local-worker.yml修改挂载路径，修改master ip及master token；注意：token需要安装好master之后新增集群才可看到

# 首次安装
# 安装依赖
bash auto-install-local-deps.sh
# 安装master
bash auto-install-local-rancher-master.sh
# 安装worker
bash auto-install-local-rancher-worker.sh

# 增加节点
ansible-files/install-rancher-local-worker.yml屏蔽[rancher-worker]已经安装过的主机，增加需要新增的主机，安装好后把屏蔽的主机接触屏蔽
# 安装worker
bash auto-install-local-rancher-worker.sh
```
# 其它操作
参考：[官方教程](https://rancher2.docs.rancher.cn/docs/installation/other-installation-methods/air-gap/populate-private-registry/_index)  
文件：[下载链接](https://github.com/rancher/rancher/releases)
## 同步离线镜像到私有仓库
```shell
cd rancher-files
docker login <REGISTRY.YOURDOMAIN.COM:PORT>
bash ./rancher-load-images.sh --image-list ./rancher-images.txt --registry <REGISTRY.YOURDOMAIN.COM:PORT>
```
## 下载离线镜像
```shell
cd rancher-files
sort -u rancher-images.txt -o rancher-images.txt
bash ./rancher-save-images.sh --image-list ./rancher-images.txt
```