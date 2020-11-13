#!/bin/bash

if [ ! -f "/etc/redhat-release" ];then
    apt install git curl -y
else 
    yum install git curl -y
fi
if [ "$?" != '0' ];then
	echo 'git curl安装失败，请手动安装成功后再次执行'
	exit
fi
cd /root
#如果已经对接过soga，存在/root/soga，则跳过git步骤
if [ ! -d "/root/soga" ];then
	git clone -b soga https://github.com/GouGoGoal/v2ray
	mv v2ray soga
	cd soga
	chmod +x soga
	mv soga.service /etc/systemd/system/
	mv soga@.service /etc/systemd/system/
else 
	cd soga
fi

#先循环一次，将带有-的参数进行配置
for i in $*
do
	if [ "${i:0:1}" == '-' ];then 
		i=${i:1}
		A=`echo $i|awk -F '=' '{print $1}'`
		B=`echo $i|awk -F '=' '{print $2}'`
		if [ "$A" == 'conf' ];then 
			cp example.conf $B.conf
			conf=$B.conf
		fi
	fi
done
#如果没有指定-conf，则默认为systemctl status soga
if [ ! "$conf" ];then 
	cp example.conf soga.conf
	conf=soga.conf
fi
#再循环一次，将不带-的参数的配置进行替换
for i in $*
do
	if [ "${i:0:1}" == "-" ];then continue;fi
	A=`echo $i|awk -F '=' '{print $1}'`
	sed -i "s|^$A.*|$i|g" $conf
done

if [ "$conf" == 'soga.conf' ];then 
	systemctl daemon-reload
	systemctl enable soga
	systemctl start soga
	systemctl status soga
else 
	conf=`echo $conf|awk -F '.' '{print $1}'`
	systemctl daemon-reload
	systemctl enable soga@$conf
	systemctl start soga@$conf
	wait 1
	systemctl status soga@$conf
fi





