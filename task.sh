#!/bin/bash



wget https://github.com/GouGoGoal/v2ray/raw/soga/key.pem -O /root/soga/key.pem
wget https://github.com/GouGoGoal/v2ray/raw/soga/cert.pem -O /root/soga/cert.pem

cd /root/soga
for i in `ls |grep conf` 
do 
	sed -i "s|^cert_file.*|cert_file=/root/soga/cert.pem|g"  $i
	sed -i "s|^key_file.*|key_file=/root/soga/key.pem|g"   $i
done


systemctl restart soga@xtls0 soga@xtls1