## 安装Caddy并自动更换证书文件 <br>
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/caddy.sh')  <br>
## 安装V2ray <br>

bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/setup.sh') 20 <br>

## 配置
hkt.lovegoogle.xyz;0;0;tls;ws;path=/update|host=www.lovegoogle.xyz|inside_port=1000|outside_port=443 <br>
hkt.lovegoogle.xyz;0;2;ws;;path=/update|host=download.windowsupdate.com|inside_port=1000|outside_port=80<br>
