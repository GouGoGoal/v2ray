apt update
apt install -y curl

curl https://getcaddy.com | bash -s personal

mkdir /etc/caddy
touch /etc/caddy/Caddyfile
chown -R root:www-data /etc/caddy

mkdir /etc/caddy/ssl
chown -R www-data:root /etc/caddy/ssl
chmod 0770 /etc/caddy/ssl

mkdir /etc/caddy/www
chown www-data:www-data /etc/caddy/www

curl -s https://raw.githubusercontent.com/gougogoal/v2ray/master/Caddy/caddy.service  -o /etc/systemd/system/caddy.service
curl -s https://raw.githubusercontent.com/gougogoal/v2ray/master/Caddy/Caddyfile -o /etc/caddy/Caddyfile
wget --no-check-certificate -P /etc/caddy "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/ssl.sh"

systemctl enable caddy

chmod 755 /etc/caddy/ssl.sh
bash /etc/caddy/ssl.sh
echo "5 3 * * 1 root /etc/caddy/ssl.sh">>/etc/crontab
systemctl status caddy


