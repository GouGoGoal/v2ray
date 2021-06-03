#!/bin/bash

sed -i '/.*root for i in.*/d' /etc/crontab
sed -i '/.*重启服务/d' /etc/crontab

echo '#每天06:00点重启服务'>>/etc/crontab
echo "0 6 * * * root for i in \`systemctl |grep -E \"soga|nginx|state|sniproxy\"|grep service|awk '{print \$1}'\`;do systemctl restart \$i;done" >>/etc/crontab