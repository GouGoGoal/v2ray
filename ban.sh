#! /bin/sh

iptables -F OUTPUT

#政府地址
iptables -A OUTPUT -m string --string "gov.cn" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "12377.cn" --algo bm --to 65535 -j REJECT
#法*功
iptables -A OUTPUT -m string --string "falunaz" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "falundafa" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "minghui" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "epochtimes" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "dongtaiwang" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "wujieliulan" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "mhradio" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "ntdtv" --algo bm --to 65535 -j REJECT
#360和百度
iptables -A OUTPUT -m string --string "360.c" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "so.c" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "shifen.com" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string "www.baidu.com" --algo bm --to 65535 -j ACCEPT
iptables -A OUTPUT -m string --string "baidu.com" --algo bm --to 65535 -j REJECT
#BT
iptables -A OUTPUT -m string --string "BitTorrent" --algo bm --to 65535 -j REJECT
iptables -A OUTPUT -m string --string ".torrent" --algo bm --to 65535 -j REJECT



#拉取规则
wget -N --no-check-certificate  -P /root/v2ray "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/ban.sh"
