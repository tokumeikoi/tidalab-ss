<img src='https://github.com/tokumeikoi/tidalab-trojan/raw/master/img/tidalab.png' width='100px' align='center'>

## 建议

我们建议您使用Debian(>=8)进行部署，当然你也可以选择CentOS(>=7)。

## Bash 部署

```
# 请将命令中的API替换成授权地址如：https://v2board.com
# 请将命令中的TOKEN替换成V2Board后台系统配置->服务端->通讯密钥
# 请将命令中的NODEID替换成V2Board后台Trojan中添加的节点ID
# 请将命令中的LICENSE替换成授权字符

curl -fsSL https://github.com/tokumeikoi/tidalab-ss/raw/master/install.sh | bash -s API TOKEN NODEID LICENSE 60
```

## Docker 部署

```
docker run -d --name=ss \
-v /root/.cert:/root/.cert \
-e API=授权地址 \
-e TOKEN=通讯密钥 \
-e NODE=节点ID \
-e LICENSE=授权码 \
-e SYNCINTERVAL=60 \
--restart=always \
--network=host \
tokumeikoi/tidalab-ss
```

## 动态

telegram@[tidalab](https://t.me/tidalab)
关注channel获得更多讯息
