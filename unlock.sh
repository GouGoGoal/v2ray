#! /bin/sh

apt update
apt install -y dnsmasq 
systemctl enable dnsmasq
#wget -N --no-check-certificate "https://raw.githubusercontent.com/gougogoal/ssr/manyuser/dnsmasq.sh"
chmod 755 /root/ssr/dnsmasq.sh
bash /root/ssr/dnsmasq.sh
#添加定时脚本
echo "* * * * * root /root/ssr/dnsmasq.sh">>/etc/crontab
#更改DNS，并设置为只读
echo "nameserver 127.0.0.1">/etc/resolv.conf
chattr +i /etc/resolv.conf

systemctl restart ssr

