wget -N --no-check-certificate  -P /root/v2ray/Caddy "https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/caddy_load.pem"


systemctl restart caddy
