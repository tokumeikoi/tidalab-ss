#!/bin/sh
echo '正在安装依赖'
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum install tar wget curl -y > /dev/null
    yum update curl -y
else
    apt-get install tar wget curl -y > /dev/null
    apt-get update curl -y
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
wget https://github.com/Jigsaw-Code/outline-ss-server/releases/download/v1.3.4/outline-ss-server_1.3.4_linux_x86_64.tar.gz
wget https://github.com/prometheus/prometheus/releases/download/v2.24.1/prometheus-2.24.1.linux-amd64.tar.gz
tar zxvf outline-ss-server_1.3.4_linux_x86_64.tar.gz -d ./
tar zxvf prometheus-2.24.1.linux-amd64.tar.gz -d ./
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
