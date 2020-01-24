#! /bin/sh

apt update
apt install -y dnsmasq 
systemctl enable dnsmasq
#wget -N --no-check-certificate "https://raw.githubusercontent.com/gougogoal/ssr/manyuser/dnsmasq.sh"
chmod 755 /root/v2ray/dnsmasq.sh

#添加定时脚本
echo "* * * * * root /root/v2ray/dnsmasq.sh">>/etc/crontab
#更改DNS，并设置为只读
echo "nameserver 127.0.0.1">/etc/resolv.conf
chattr +i /etc/resolv.conf

bash /root/v2ray/dnsmasq.sh

