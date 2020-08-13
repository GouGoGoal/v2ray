#!/bin/bash

echo "适配常用Linux发行版本(CentOS、Debian、Ubuntu)，根据 https://nginx.org/en/linux_packages.html 中的步骤编写而成"
echo '国内机访问nginx.org速度不佳，最好不要在用网高峰期执行'
seconds_left=5
while [ $seconds_left -gt 0 ];do
    echo -n "$seconds_left 后自动执行，CTRL+C可取消"
    sleep 1
    seconds_left=$(($seconds_left - 1))
    echo -ne "\r     \r" #清除本行文字
done

#根据系统版本添加官网源并安装
if [ "`grep  PRETTY_NAME /etc/os-release |grep CentOS`" ]; then
	#CentOS
	yum install -y yum-utils
	echo '[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true'>/etc/yum.repos.d/nginx.repo
	yum-config-manager --enable nginx-mainline	
	yum install -y nginx
elif [ "`grep  PRETTY_NAME /etc/os-release |grep Debian`" ]; then
	#Debian
	apt update
	apt install -y curl gnupg2 ca-certificates lsb-release
	echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" >/etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
	#apt-key fingerprint ABF5BD827BD9BF62
	apt update
	apt install -y nginx
elif [ "`grep  PRETTY_NAME /etc/os-release |grep Ubuntu`" ]; then
	#Ubuntu
	apt update
	apt install -y curl gnupg2 ca-certificates lsb-release
	echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
	curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
	apt update
	apt install -y nginx
else 
	echo "您的Linux发行版本可能不是CentOS、Debian、Ubuntu，更换系统后再做尝试"
fi


#更改nginx默认参数，优化连接
echo 'user  root;
worker_processes  auto;
worker_cpu_affinity auto;
worker_rlimit_nofile 51200;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
	use epoll;
	multi_accept on;
	worker_connections  4096;
}
http {
	include       /etc/nginx/mime.types;
	default_type  application/octet-stream;

	sendfile       on;
	tcp_nopush     on;
	tcp_nodelay    on;
	keepalive_timeout  60;
	#隐藏版本号
	server_tokens off;
	include /etc/nginx/conf.d/*.conf;
}'>/etc/nginx/nginx.conf


#添加一个伪装页面，自动跳转到speedtest
mkdir /etc/nginx/web/
echo '<script language=javascript>
    this.location = "https://www.speedtest.net/";
</script>'>/etc/nginx/web/index.html
#添加默认server
echo 'server
{
    listen 443 ssl  reuseport;
    listen 444 ssl  reuseport proxy_protocol;
    server_name *.lovegoogle.xyz;
    ssl_certificate    /etc/nginx/tls/full_chain.pem;
    ssl_certificate_key    /etc/nginx/tls/private.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers  ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    # TLS握手优化
    ssl_early_data on;
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;
    keepalive_timeout    75s;
    keepalive_requests   100;

    location /update {
                proxy_pass http://127.0.0.1:1000;
                proxy_read_timeout 60s;  #与代理服务器读的超时时间
                proxy_send_timeout 60s;  #与upstream服务器发送的超时时间
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;           #websocket需要
                proxy_set_header Connection "Upgrade";            #websocket需要
                set $real_ip $remote_addr;
                if ( $proxy_protocol_addr != "" ){
                        set $real_ip $proxy_protocol_addr;
                }
                proxy_set_header X-Real-IP $real_ip;
                proxy_set_header X-Forwarded-For $real_ip;
    }
	location /download {
                proxy_pass http://127.0.0.1:1001;
                proxy_read_timeout 60s;  #与代理服务器读的超时时间
                proxy_send_timeout 60s;  #与upstream服务器发送的超时时间
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;           #websocket需要
                proxy_set_header Connection "Upgrade";            #websocket需要
                set $real_ip $remote_addr;
                if ( $proxy_protocol_addr != "" ){
                        set $real_ip $proxy_protocol_addr;
                }
                proxy_set_header X-Real-IP $real_ip;
                proxy_set_header X-Forwarded-For $real_ip;
    }
    access_log  /var/log/nginx.log access;
    error_log  /var/log/nginx.error.log;
}
#server 
#{
#	listen 80 reuseport;
#	listen 80 reuseport proxy_protocol;
#	root /etc/nginx/web;
#	index index.html;
#	location / {
                proxy_pass http://127.0.0.1:1000;
                proxy_read_timeout 60s;  #与代理服务器读的超时时间
                proxy_send_timeout 60s;  #与upstream服务器发送的超时时间
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;           #websocket需要
                proxy_set_header Connection "Upgrade";            #websocket需要
                set $real_ip $remote_addr;
				set $real_ip $proxy_protocol_addr;
                if ( $proxy_protocol_addr != "" ){
						set $real_ip $remote_addr;
                        set $real_ip $proxy_protocol_addr;
                }
                proxy_set_header X-Real-IP $real_ip;
                proxy_set_header X-Forwarded-For $real_ip;
    }
#	error_log  /var/log/v2ray.error.log;
#}
'>/etc/nginx/conf.d/default.conf

#添加证书，并添加计划任务
wget -N --no-check-certificate  -P /etc/nginx/tls https://raw.githubusercontent.com/GouGoGoal/v2ray/master/nginx/tls/full_chain.pem
wget -N --no-check-certificate  -P /etc/nginx/tls https://raw.githubusercontent.com/GouGoGoal/v2ray/master/nginx/tls/private.key

echo "50 5 * * 1 root wget -N --no-check-certificate  -P /etc/nginx/tls https://raw.githubusercontent.com/GouGoGoal/v2ray/master/nginx/tls/full_chain.pem ">>/etc/crontab
echo "50 5 * * 1 root wget -N --no-check-certificate  -P /etc/nginx/tls https://raw.githubusercontent.com/GouGoGoal/v2ray/master/nginx/tls/private.key ">>/etc/crontab


#重写nginx.service，避免出现Can't open PID file /var/run/nginx.pid (yet?) after start错误提示
if [ "`command -v systemctl`" != "" ]; then
	rm -rf /lib/systemd/system/nginx.service
	echo '[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/usr/sbin/nginx -s stop
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/nginx.service
	systemctl daemon-reload
	systemctl enable nginx
	systemctl start nginx
fi



















	