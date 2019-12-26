#!/bin/bash

#获取当前的流媒体解锁IP
twip=`ping -c1 unlock.tw.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
hkip=`ping -c1 unlock.hk.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
jpip=`ping -c1 unlock.jp.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`
usip=`ping -c1 unlock.us.soulout.club|awk -F'[(|)]' 'NR==1{print $2}'`

nfip=$hkip

#写入dnsmasq缓存
touch_dnsmasq_tmp() {
echo "old_twip=$twip
old_hkip=$hkip
old_usip=$usip
old_jpip=$jpip">/tmp/dnsmasq_tmp
}

#定义刷新dnsmasq参数并重启的函数
flush_dnsmasq_conf() {
echo "#验证域名
domain-needed
#定义上游DNS
all-servers
server=1.1.1.1
server=8.8.8.8
query-port=54
#引入/etc/hosts文件
addn-hosts=/etc/hosts
#监听地址
listen-address=127.0.0.1
#最大缓存条数
cache-size=1000
dns-forward-max=1000

#奈飞
#address=/fast.com/$nfip
address=/netflix.com/$nfip
address=/netflix.net/$nfip
address=/nflxext.com/$nfip
address=/nflximg.net/$nfip
address=/nflxso.net/$nfip
address=/nflxvideo.net/$nfip

#香港TVB
address=/mytvsuper.com/$hkip
address=/tvb.com/$hkip

#台湾动画疯
address=/gamer.com.tw/$twip
address=/bahamut.com.tw/$twip
address=/hinet.net/$twip
#B站
address=/bilibili.com/$twip
address=/hdslb.com/$twip
#LineTV
#address=/line.me/$twip
#address=/line-apps.com/$twip
#日本AbemaTV
address=/abema.tv/$jpip
address=/ameblo.jp/$jpip
address=/akamaized.net/$jpip
#TVer
address=/tver.jp/$jpip
address=/amazonaws.com/$jpip
address=/yahoo.co.jp/$jpip
address=/brightcove.com/$jpip
#niconico
address=/nicovideo.jp/$jpip
address=/nimg.jp/$jpip

#使用流媒体解锁服务
#server=/abema.tv/198.13.32.209
#server=/ameblo.jp/198.13.32.209
#server=/akamaized.net/198.13.32.209

">/etc/dnsmasq.conf
systemctl restart dnsmasq ssr v2ray
}

if [ ! -f "/tmp/dnsmasq_tmp" ]; then 
	echo "无缓存，写入缓存并刷新配置"
        touch_dnsmasq_tmp
        flush_dnsmasq_conf
else
	echo "存在缓存，检查是否有变化"
        .  /tmp/dnsmasq_tmp
	#对比IP变化，有变化就刷新重启dnsmasq
	if [ $twip == "$old_twip" -a $hkip == "$old_hkip" -a $jpip == "$old_jpip" -a $usip == "$old_usip" ];then
	    echo "无变化，退出脚本"
	    exit
	else 
	    echo "IP有变动，刷新配置和缓存"
	    flush_dnsmasq_conf
            touch_dnsmasq_tmp
	fi
	        
fi
