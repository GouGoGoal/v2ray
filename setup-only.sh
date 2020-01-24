#!/bin/bash

#安装工具，克隆代码
apt update
apt install git -y
cd /root
git clone -b master https://github.com/GouGoGoal/v2ray
cd v2ray
rm -rf  README.md setup.sh 常用配置 .git
chmod 755 /root/v2ray/*

#更改对接nodeid
sed -i "s/id_value/$1/g" config.json

#添加开机脚本，屏蔽域名
echo '#!/bin/sh -e
bash /root/v2ray/ban.sh
exit 0' >/etc/rc.local
chmod 755 /etc/rc.local
systemctl restart rc.local

echo "
#每晚三点重启
0 3 * * * root init 6
#每隔10分钟检查内存，高则自动释放
*/10 * * * * root /root/ssr/freeram.sh
#每周一删除日志
29 2 * * 1 root rm -rf /var/log/*.gz ">>/etc/crontab



#开机自启服务
cp v2ray.service /etc/systemd/system/
systemctl enable v2ray
systemctl restart v2ray
#安装caddy
bash /root/v2ray/Caddy/caddy.sh


