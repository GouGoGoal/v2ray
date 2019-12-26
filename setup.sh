#!/bin/bash

apt update
apt install git -y
cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
chmod 755 /root/v2ray/*
sed -i "s/id_value/$1/g" config.json
cp v2ray.service /etc/systemd/system/
systemctl enable v2ray
systemctl restart v2ray
rm -rf  README.md setup.sh 常用配置 .git/
bash /root/v2ray/Caddy/caddy.sh

