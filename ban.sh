#! /bin/sh

#屏蔽部分法轮功域名
iptables -A OUTPUT -m string --string "gov.cn" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "12377.cn" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "falunaz.net" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "falundafa.org" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "minghui.org" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "epochtimes.com" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "dongtaiwang.com" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "wujieliulan.com" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "mhradio.org" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "ntdtv.com" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "法轮功" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "反共" --algo bm --to 65535 -j DROP
iptables -A OUTPUT -m string --string "台毒" --algo bm --to 65535 -j DROP

wget -N --no-check-certificate  -P /root/v2ray "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/ban.sh"
