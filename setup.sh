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
sed -i "s/id_value/$1/g" config0.json
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
#修复BUG
sed -i 's|SHELL=/bin/sh|SHELL=/bin/bash|' /etc/crontab
echo 'if [ "`journalctl -u v2ray -n 20|grep TransientFailure`" != "" ];then for line in `systemctl|grep v2ray|grep -v system|awk '{print $1}'`;do systemctl restart $line;done;fi' >>/etc/crontab
#安装caddy
bash /root/v2ray/nginx/nginx.sh

