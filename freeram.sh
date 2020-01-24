#Swap使用到limit_swap时释放内存，设置swappiness=0
used_swap=`free -m | awk '/Swap/ {print $3}'`
limit_swap=10
if [ $used_swap -gt $limit_swap ]; then
       #内存释放执行的命令,重启docker之类的
       echo "重启SSR、V2ray服务，释放内存"
       systemctl restart ssr v2ray
       swapoff -a && swapon -a
else
       echo "内存无需释放"
fi
