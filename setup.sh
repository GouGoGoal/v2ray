#!/bin/bash

if [ "`id -u`" != 0 ];then
	echo 'SB：请使用root用户执行脚本'
	exit
fi
if [ ! -f "/etc/redhat-release" ];then
    apt install git curl -y
else 
    yum install git curl -y
	systemctl stop firewalld
	systemctl disable firewalld
	setenforce 0
	echo 'SELINUX=disabled'>/etc/selinux/config
fi
if [ "$?" != '0' ];then
	echo 'SB：git curl安装失败，请手动安装成功后再次执行'
	exit
fi
cd /root
#如果已经对接过soga，存在/root/soga，则跳过git步骤
if [ ! -d "/root/soga" ];then
	git clone -b soga https://github.com/GouGoGoal/v2ray /root/soga
	cd soga
	chmod +x soga
	mv soga.service /etc/systemd/system/
	mv soga@.service /etc/systemd/system/
else 
	cd soga
fi
if [ ! "`echo $*|grep node_id|grep webapi_url|grep webapi_mukey`" ];then
	echo 'SB：必须参数不全，请修正后重新执行'
	exit
fi
#先循环一次，将带有-的参数进行配置
for i in $*
do
	if [ "${i:0:1}" == '-' ];then 
		i=${i:1}
		A=`echo $i|awk -F '=' '{print $1}'`
		case $A in 
		bbr)
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
net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_rmem = 4096 131072 16777216
net.ipv4.tcp_wmem = 4096 131072 16777216
net.ipv4.tcp_mem = 4096 131072 16777216
net.ipv4.tcp_ecn = 1
">/etc/sysctl.conf
			sysctl -p
			;;
		conf)
			B=`echo $i|awk -F '=' '{print $2}'`
			rm -f $B.conf
			cp example.conf $B.conf
			conf=$B.conf
		;;
		shield)
			if [ ! -f "/etc/rc.local" ];then 
				echo '#!/bin/bash' >/etc/rc.local
			fi
			if [ ! "`cat /etc/rc.local|grep soga.sprov.xyz`" ];then 
				iptables -A OUTPUT -m string --string 'soga.sprov.xyz' --algo bm --to 65535 -j DROP
				echo "iptables -A OUTPUT -m string --string 'soga.sprov.xyz' --algo bm --to 65535 -j DROP" >>/etc/rc.local
				chmod +x /etc/rc.local
			fi
			;;
		state)
			apt install -y python3 
			yum install -y python3 
			B=`echo $i|awk -F '=' '{print $2}'`
			if [ ! -f "/etc/state.py" ];then
				mv -f state.py /etc/state.py
			fi
			sed -i "s|^USER.*|USER = \"$B\"|g" /etc/state.py
			echo "[Unit]
Description=state deamon
After=rc-local.service

[Service]
Type=simple
ExecStart=/usr/bin/python3 /etc/state.py
Restart=on-failure
[Install]
WantedBy=multi-user.target">/etc/systemd/system/state.service
			systemctl enable state
			systemctl restart state
			;;
		task)
			if [ ! "`grep task.sh /etc/crontab`" ];then
				echo '
#每天05:55执行task
55 5 * * * root curl -k https://raw.githubusercontent.com/GouGoGoal/ssr/manyuser/task.sh|bash
#每天05:55清理日志日志
55 5 * * * root find /var/ -name "*.log.*" -exec rm -rf {} \;
#每天06:00点重启
0 6 * * * root init 6'>>/etc/crontab
			fi
			;;
		tls)
			if [ ! "`grep /root/soga /etc/crontab`" ];then
				echo "#定时从github上更新tls证书
50 5 * * 1 root wget -N --no-check-certificate -P /root/soga https://raw.githubusercontent.com/GouGoGoal/v2ray/soga/full_chain.pem 
50 5 * * 1 root wget -N --no-check-certificate -P /root/soga https://raw.githubusercontent.com/GouGoGoal/v2ray/soga/private.key">>/etc/crontab
			fi
		;;
		esac
	fi
done

#如果没有指定-conf，则默认为systemctl status soga
if [ ! "$conf" ];then 
	rm -f soga.conf
	cp example.conf soga.conf
	conf=soga.conf
fi
#再循环一次，将不带-的参数的配置进行替换
for i in $*
do
	if [ "${i:0:1}" == "-" ];then continue;fi
	A=`echo $i|awk -F '=' '{print $1}'`
	#防傻逼
	if [ "$A" == 'node_id' -o "$A" == 'webapi_url' -o "$A" == 'webapi_mukey' ];then 
		if [ ! "`echo $i|awk -F '=' '{print $2}'`" ];then 
			echo "SB：必须参数$A未填写，请修正后重新执行"
			rm -f $conf
			exit
		fi
	fi
	sed -i "s|^$A.*|$i|g" $conf
done

if [ "$conf" == 'soga.conf' ];then 
	systemctl daemon-reload
	systemctl enable soga
	systemctl restart soga
	echo '部署完毕，等待5秒将显示服务状态'
	sleep 5
	systemctl status soga
else 
	conf=`echo $conf|awk -F '.' '{print $1}'`
	systemctl daemon-reload
	systemctl enable soga@$conf
	systemctl restart soga@$conf
	echo '部署完毕，等待5秒将显示服务状态'
	sleep 5
	systemctl status soga@$conf
fi





