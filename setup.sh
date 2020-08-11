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
rm -rf  README.md setup.sh .git*
#更改对接nodeid
sed -i "s/id_value/$1/g" config.json
#开机自启服务
echo "[Unit]
Description=V2Ray@%i Service
After=rc-local.service
[Service]
Type=simple
ExecStart=/root/v2ray/v2ray -config /root/v2ray/config%i.json
Restart=always
LimitNOFILE=512000
LimitNPROC=512000
# 柔性限制
# MemoryHigh=90%
# 刚性限制
# MemoryMax=25%

[Install]
WantedBy=multi-user.target">/etc/systemd/system/v2ray@.service 
systemctl enable v2ray@0
systemctl restart v2ray@0
#安装caddy
bash /root/v2ray/Caddy/caddy.sh

