## 安装Caddy并自动更换证书文件 <br>
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/Caddy/caddy.sh')  <br>
## 安装V2ray <br>

bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/setup.sh') 20 <br>

##替换为nginx<br>

systemctl disable caddy<br>
systemctl stop caddy<br>
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/nginx/nginx.sh') <br>
## 配置<br>
hkt.lovegoogle.xyz;0;0;tls;ws;path=/update|host=www.lovegoogle.xyz|inside_port=1000|outside_port=443 <br>
hkt.lovegoogle.xyz;0;0;ws;;path=/update|host=download.windowsupdate.com|inside_port=1000|outside_port=80<br>

## 手动更改时间


timedatectl set-timezone Asia/Shanghai<br>
date -s 00:00:00 <br>
hwclock -w <br>
hwclock --hctosys<br>

## 禁用UDP的时候使用   rdate -s time.nist.gov  来同步
