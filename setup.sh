#!/bin/bash

#安装工具，克隆代码
apt update
apt install git -y
cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
rm -rf  README.md setup.sh 常用配置 .git/
chmod 755 /root/v2ray/*

#更改对接nodeid
sed -i "s/id_value/$1/g" config.json

#添加开机脚本，屏蔽域名
echo '#!/bin/sh -e
bash /root/v2ray/ban.sh
exit 0' >/etc/rc.local
chmod 755 /etc/rc.local
systemctl restart rc.local

#开机自启服务
cp v2ray.service /etc/systemd/system/
systemctl enable v2ray
systemctl restart v2ray
#安装caddy
bash /root/v2ray/Caddy/caddy.sh

