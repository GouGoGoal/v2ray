apt update
cd /root/v2ray/Caddy
chmod 755 *
mv -f  caddy.service  /etc/systemd/system/caddy.service

bash /etc/caddy/ssl.sh
echo "10 3 * * 1 root /root/v2ray/Caddy/tls_auto.sh">>/etc/crontab
rm -rf caddy.sh ssl.sh
systemctl enable caddy
systemctl restart caddy






