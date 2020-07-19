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
sed -i "s/id_value/$1/g" config.json
#开机自启服务
mv -f v2ray.service /etc/systemd/system/
systemctl enable v2ray
systemctl restart v2ray
#安装caddy
bash /root/v2ray/Caddy/caddy.sh

