#!/bin/bash


if [ "$1" == '' ];then
	echo "未赋值，退出脚本"
	exit 0
fi
#优先使用IPV6地址 
echo "precedence ::ffff:0:0/96  100" >>/etc/gai.conf

if [ ! -f "/etc/redhat-release" ]; then
	apt update
	#安装环境
	apt install -y python3 ntp git
else 
	yum update -y
	yum install -y python3 ntp git
	#关闭防火墙
	systemctl disable firewalld
	systemctl stop firewalld
	#关闭 selinux
	setenforce 0
	echo 'SELINUX=disabled' >/etc/selinux/config
fi

#自动同步时间
timedatectl set-ntp true
#修改时区
timedatectl set-timezone Asia/Shanghai

#赋予脚本可执行权限
chmod  +x /root/ssr/*.sh
#计划任务改成bash执行
sed -i 's|SHELL=/bin/sh|SHELL=/bin/bash|' /etc/crontab


cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
chmod +x v2ray v2ctl *.sh
rm -rf  README.md setup.sh .git*
#更改对接nodeid
sed -i "s/id_value/$1/g" config0.json
#开机自启服务
echo "[Unit]
Description=V2Ray@%i Service
After=rc-local.service
[Service]
Type=simple
ExecStart=/root/v2ray/v2ray -config /root/v2ray/config%i.json
Restart=always
LimitNOFILE=512000
LimitNPROC=512000
# 柔性限制
# MemoryHigh=90%
# 刚性限制
# MemoryMax=25%
[Install]
WantedBy=multi-user.target">/etc/systemd/system/v2ray@.service 
systemctl enable v2ray@0
systemctl restart v2ray@0

#添加计划任务
echo '
#每天05:55执行task
55 5 * * * root curl -k https://raw.githubusercontent.com/GouGoGoal/ssr/manyuser/task.sh|bash
#每天05:55清理日志日志
55 5 * * * root find /var/ -name "*.log.*" -exec rm -rf {} \;
#每天06:00点重启
0 6 * * * root init 6'>>/etc/crontab
# 修复BUG
echo "#修复V2ray断网后连接不上的BUG
* * * * * root if [ \"\`journalctl -u v2ray -n 20|grep TransientFailure\`\" != \"\" ];then for line in \`systemctl|grep v2ray|grep -v system|awk '{print \$1}'\`;do systemctl restart \$line;done;fi">>/etc/crontab
#添加常用工具
mv besttrace /usr/sbin
chmod +x /usr/sbin/besttrace
mv tcping /usr/sbin
chmod +x /usr/sbin/tcping

if [ "$2" != "0" -a "$2" != ""  ];then
	#添加探针服务
	echo '[Unit]
Description=state deamon
After=rc-local.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /root/v2ray/state.py
Restart=always
[Install]
WantedBy=multi-user.target'>/etc/systemd/system/state.service
	sed -i "s/node/$2/" state.py
	systemctl daemon-reload
	systemctl enable state
	systemctl start state
	echo "$2.lovegoogle.xyz已添加探针"
fi

if [ "$3" == "ovz" ];then
	echo '
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#开启内核转发
net.ipv4.ip_forward=1'>/etc/sysctl.conf
	sysctl -p
	echo "已针对OVZ优化参数"
else 
#优化最大文件打开
	echo '
root soft nofile 512000
root hard nofile 512000'>>/etc/security/limits.conf
	#优化TCP连接
	echo '
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#开启BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
#开启内核转发
net.ipv4.ip_forward=1
#优先使用ram
vm.swappiness=0
#可以分配所有物理内存
vm.overcommit_memory=1
#TCP优化
fs.file-max = 512000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864'>/etc/sysctl.conf
sysctl -p
fi

#安装nginx
bash /root/v2ray/nginx/nginx.sh

