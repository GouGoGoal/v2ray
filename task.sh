#!/bin/bash

#将crontab默认shell改成bash
sed -i "s|SHELL=/bin/sh|SHELL=/bin/bash|g" /etc/crontab
#删除自动重启的那行
sed -i '/init 6/d' /etc/crontab
sed -i '/重启/d' /etc/crontab

if [ ! "`cat /etc/crontab|grep '重启服务'`" ];then
	echo '
#每天06:00点重启服务
0 6 * * * root for i in `systemctl |grep -E "soga|nginx|state|sniproxy"|grep -v system|awk "{print $1}"`;do systemctl restart $i;done'>>/etc/crontab
fi