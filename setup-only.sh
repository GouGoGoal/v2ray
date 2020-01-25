#!/bin/bash

#安装工具，克隆代码
apt update
apt install git -y
cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
chmod 755 /root/v2ray/*

#更改对接nodeid
sed -i "s/id_value/$1/g" config.json

#添加开机脚本，屏蔽域名
echo '#!/bin/sh -e
bash /root/v2ray/ban.sh
exit 0' >/etc/rc.local
chmod 755 /etc/rc.local
systemctl restart rc.local


#开机自启服务
mv v2ray.service /etc/systemd/system/
systemctl enable v2ray
systemctl restart v2ray
#删除多余文件
rm -rf  README.md setup*.sh 常用配置 .git* 
#安装caddy
bash /root/v2ray/Caddy/caddy.sh


read -s -n1 -p "是否添加计划任务"
echo "
#每晚三点重启
0 3 * * * root init 6
#每隔10分钟检查内存，高则自动释放
*/10 * * * * root /root/ssr/freeram.sh
#每周一删除日志
29 2 * * 1 root rm -rf /var/log/*.gz ">>/etc/crontab

read -s -n1 -p "是否优化系统参数"
#优化最大文件打开
echo "
root soft nofile 512000
root hard nofile 512000
">>/etc/security/limits.conf
#BBR以及内核优化
echo "
#关闭IPV6
net.ipv6.conf.all.disable_ipv6 = 1
#开启BBR
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
#开启内核转发
net.ipv4.ip_forward=1
#优先使用ram
vm.swappiness=0
#TCP优化
fs.file-max = 512000
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
">/etc/sysctl.conf
sysctl -p

read -s -n1 -p "更改开机等待时间，OVZ禁用"
#更改开机启动时间1S
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

