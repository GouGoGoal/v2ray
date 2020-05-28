#!/bin/bash

if [ ! -f "/etc/redhat-release" ]; then
    apt update && apt install git -y
else 
    yum update && yum install git -y
fi

cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
chmod +x v2ray v2ctl *.sh
rm -rf  README.md setup.sh 常用配置 .git*
#更改对接nodeid
sed -i "s/id_value/$1/g" config0.json

#添加iptables屏蔽
if [ ! -f "/etc/rc.local" ]; then
    if [ -f "/etc/rc.d/rc.local" ]; then
        ln -s /etc/rc.d/rc.local /etc/rc.local
    fi
    echo '#!/bin/sh -e
bash /root/v2ray/ban.sh
exit 0' >/etc/rc.local
    chmod +x /etc/rc.local
    systemctl restart rc-local
else 
    sed -i '$i\bash /root/v2ray/ban.sh' /etc/rc.local
fi

#开机自启服务
mv -f v2ray.service /etc/systemd/system/
systemctl enable v2ray@0
systemctl restart v2ray@0
#安装caddy
bash /root/v2ray/Caddy/caddy.sh

