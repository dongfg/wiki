---
title: docker 基础配置
date: 2017-04-27 14:17:39
tag: docker, linux
---

### 安装 Docker
Docker 的 安装资源文件 存放在Amazon S3，会间歇性连接失败。所以安装Docker的时候，会比较慢。 你可以通过执行下面的命令，高速安装Docker。
```shell
curl -sSL https://get.daocloud.io/docker | sh
```

### 安装 Docker Compose
Docker Compose 存放在Git Hub，不太稳定。 
你可以也通过执行下面的命令，高速安装Docker Compose。
```shell
curl -L https://get.daocloud.io/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
你可以通过修改URL中的版本，可以自定义您的需要的版本。

### Docker加速器
针对Docker客户端版本大于1.10的用户
您可以通过修改daemon配置文件/etc/docker/daemon.json来使用加速器：
```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://dn3uqhye.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```