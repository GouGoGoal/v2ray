```
bash <(curl -k 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/setup.sh') node_id=114514 -webapi_url=https://www.example.com webapi_mukey=password [...]
#必须参数，配置文件名 对接ID，URL，Key
node_id=114514
webapi_url=https://www.example.com
webapi_mukey=password
#可选参数
-conf=0 #指定参数文件名，后续通过 systemctl status soga@0管理服务，不填则用 systemctl status soga 来管理
v2ray_reduce_memory=true #省内存模式
#手动指定tls证书位置
cert_file=/root/soga/full_chain.pem
key_file=/root/soga/private.key
#传递真实IP
proxy_protocol=true
#强制忽略tls选项(面板指定情况下)，通过caddy或nginx启用tls
force_close_ssl=true
更多参数请参阅soga使用帮助
```
