#!/bin/sh
echo '正在安装依赖'
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum install tar wget curl -y > /dev/null
    yum update curl -y
else
    apt-get install tar wget curl -y > /dev/null
    apt-get update curl -y
    echo '环境优化'
    ulimit -n 51200
    echo "soft nofile 51200" >> /etc/security/limits.conf
    echo "hard nofile 51200" >> /etc/security/limits.conf
    (cat <<EOF
fs.file-max = 102400
net.core.somaxconn = 1048576
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_fin_timeout = 30
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_max_syn_backlog = 1048576
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_orphan_retries = 1
net.ipv4.ip_local_port_range = 32768 65535
net.ipv4.tcp_mem = 88560 118080 177120
net.ipv4.tcp_wmem = 4096 16384 8388608
EOF
    ) > /etc/sysctl.conf
fi

api=$1
key=$2
nodeId=$3
license=$4
folder=$key-ss
if [[ "$5" -ne "" ]]
    then
    syncInterval=$5
else
    syncInterval=60
fi
#kill process and delete dir
kill -9 $(ps -ef | grep ${folder} | grep -v grep | grep -v bash | awk '{print $2}') 1 > /dev/null
kill -9 $(ps -ef | grep defunct | grep -v grep | awk '{print $2}') 1 > /dev/null
echo '结束进程'
rm -rf $folder

#create dir, init files
mkdir $folder
cd $folder
wget https://github.com/tokumeikoi/tidalab-ss/releases/latest/download/tidalab-ss
wget https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v1.3.4/outline-ss-server_1.3.4_linux_x86_64.tar.gz
wget https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz
tar zxvf outline-ss-server_1.3.4_linux_x86_64.tar.gz -C ./
tar zxvf prometheus-2.24.1.linux-amd64.tar.gz -C ./
mv prometheus-2.24.1.linux-amd64/* ./
chmod 755 *

#run server
nohup `pwd`/tidalab-ss -api=$api -token=$key -node=$nodeId -license=$license -syncInterval=$syncInterval > tidalab.log 2>&1 &
echo '部署完成'
sleep 3
cat tidalab.log
if ls | grep "service.log"
	then
	cat service.log
else
	echo '启动失败'
fi
