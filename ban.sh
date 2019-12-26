#! /bin/sh

iptables -F OUTPUT

#屏蔽敏感域名
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


#拉取规则
wget -N --no-check-certificate  -P /root/v2ray "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/ban.sh"
