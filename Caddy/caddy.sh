cd /root/v2ray/Caddy
chmod +x caddy *.sh
mv caddy /usr/bin
mv caddy.service  /etc/systemd/system/caddy.service
mkdir /etc/caddy && mv *  /etc/caddy

echo "10 3 * * 1 root /etc/caddy/tls_auto.sh">>/etc/crontab
rm -rf /etc/caddy/caddy.sh /etc/caddy/ssl.sh

systemctl enable caddy
systemctl restart caddy

rm -rf /root/v2ray/Caddy
