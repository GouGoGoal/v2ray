```
bash <(curl -k 'https://raw.githubusercontent.com/GouGoGoal/v2ray/soga/setup.sh') node_id=114514 webapi_url=https://www.example.com webapi_mukey=password [...]
#参数分为两种，带- 和不带-的
#带-的不涉及对接信息，都是非必须参数
-conf=0 #指定参数文件名，后续通过 systemctl status soga@0 管理服务，不填则用 systemctl status soga 来管理
-tls #添加自动更新tls证书的任务
-shield #屏蔽soga授权地址(可能是心理作用)
-bbr #同时开启BBR(若内核不支持则不生效)，并优化内核参数
-state=123 #对接探针
-task #添加定时重启，定时清理日志等计划任务

#不带-的，修改soga的配置文件，全部参数请查看example.conf，以下三种为必须参数
node_id=114514
webapi_url=https://www.example.com
webapi_mukey=password
#不带-的可选参数
v2ray_reduce_memory=true #省内存模式
cert_file=/root/soga/full_chain.pem #手动指定tls证书位置
key_file=/root/soga/private.key #手动指定tls证书位置
proxy_protocol=true #传递真实IP
force_close_ssl=true #强制忽略tls选项(面板指定情况下)，通过caddy或nginx启用tls
更多信息请参阅soga使用文档
```



### 套nginx获取真实IP
```
http {
	access_log off;
	error_log /dev/null;
	server {
		listen unix:/var/run/nginx.sock ssl proxy_protocol;
		ssl_certificate    /root/soga/full_chain.pem;
		ssl_certificate_key    /root/soga/private.key;
		
		ssl_protocols       TLSv1.2 TLSv1.3;
		ssl_ciphers  ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
		ssl_early_data on;
		ssl_stapling on;
		ssl_stapling_verify on;
		ssl_session_cache    shared:SSL:1m;
		ssl_session_timeout  5m;
		#直连
		location /update {
			proxy_pass http://127.0.0.1:442;
			proxy_read_timeout 10s;  #与代理服务器读的超时时间
			proxy_send_timeout 10s;  #与upstream服务器发送的超时时间
			proxy_http_version 1.1;
			proxy_set_header Upgrade $http_upgrade;
			proxy_set_header Connection "Upgrade";
			proxy_set_header X-Real-IP $proxy_protocol_addr;
			proxy_set_header X-Forwarded-For $proxy_protocol_addr;	
	}
	}	
}
```

