```
bash <(curl -k 'https://raw.githubusercontent.com/GouGoGoal/v2ray/master/setup.sh') node_id=114514 -webapi_url=https://www.example.com webapi_mukey=password [...]
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
