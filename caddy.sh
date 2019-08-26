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
curl -s  https://raw.githubusercontent.com/gougogoal/caddy_install/master/caddy.service  -o /etc/systemd/system/caddy.service
systemctl enable caddy
curl -s https://raw.githubusercontent.com/gougogoal/caddy_install/master/Caddyfile -o /etc/caddy/Caddyfile
vi /etc/caddy/Caddyfile
