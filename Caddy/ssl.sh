wget -N --no-check-certificate  -P /etc/caddy/ssl "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/caddy_load.pem"

systemctl restart caddy
