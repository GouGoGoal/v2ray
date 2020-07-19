#/bin/bash

#取消iptables屏蔽网址
echo "`cat /etc/rc.local|grep -v ban.sh|grep -v 127.0.0.1:53`" >/etc/rc.local
#屏蔽BT
if [ "`cat /etc/rc.local|grep BitTorrent`" == "" ];then
sed '$i iptables -A OUTPUT -m string --string "BitTorrent" --algo bm --to 65535 -j DROP' /etc/rc.local
fi
if [ "`cat /etc/rc.local|grep .torrent`" == "" ];then
sed '$i iptables -A OUTPUT -m string --string ".torrent" --algo bm --to 65535 -j DROP' /etc/rc.local
fi

#添加执行task计划任务
if [ "`echo /etc/crontab |grep task`" == "" ];then
echo "0 5 * * * root bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/gougogoal/ssr/manyuser/task.sh')" >>/etc/crontab
fi

#完善dns解锁
if [ "`cat /etc/smartdns.sh |grep -w 127.0.0.1:53`" == "" ];then
echo `#检查iptables规则，防止意外丢失
if [ "`iptables -t nat -nL |grep -w 127.0.0.1:53`" == "" ]; then
    iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1:53
fi`>>/etc/smartdns.sh
fi
#使用DNS进行屏蔽域名
if [ "`cat /etc/smartdns.sh |grep -w 'conf-file /etc/ban.conf'`" == "" ];then
wget --no-check-certificate -O /etc/ban.conf 'https://github.com/GouGoGoal/ssr/raw/manyuser/ban.conf'
echo `conf-file /etc/ban.conf`>>/etc/smartdns.sh
fi



