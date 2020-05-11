cd /root/v2ray/Caddy
chmod +x caddy *.sh
mv caddy /usr/bin
mv caddy.service  /etc/systemd/system/caddy.service
mkdir /etc/caddy && mv *  /etc/caddy

echo "10 3 * * 1 root wget -N --no-check-certificate  -P /etc/caddy/ https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/caddy_load.pem ">>/etc/crontab
rm -rf /etc/caddy/caddy.sh /etc/caddy/ssl.sh

systemctl enable caddy
systemctl restart caddy

rm -rf /root/v2ray/Caddy
