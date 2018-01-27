---
title: "gogs 二进制版安装配置"
date:  2018-01-27 12:02:00
tag: gogs
---
[TOC]
> [官方文档](https://gogs.io/docs/installation/install_from_binary)

## 依赖
- github 下载最新版本 `linux_amd64.tar.gz`
- mysql 数据库

## 安装
### 解压
```
sudo tar -zxvf linux_amd64.tar.gz -C /opt
```

### 创建 repositories 文件夹
```
mdir -p /opt/gogs/repositories
```

### 启动进行初始化配置
```
./gogs web
```

注意运行用户及ssh 端口配置：
- 运行用户选择当前用户
- ssh 使用内置server 端口选择高于 1024 的端口 10022


### systemd 服务
`scripts/systemd/gogs.service` 编辑安装目录
```
sudo cp scripts/systemd/gogs.service /usr/lib/systemd/system/
sudo systemctl enable gogs
sudo systemctl start gogs
sudo systemctl status gogs
```

### ssh 端口映射
```
sudo firewall-cmd --permanent --add-forward-port=port=22:proto=tcp:toport=10022
sudo firewall-cmd --reload
```

端口配置修改：
```
[server]
SSH_PORT         = 22
SSH_LISTEN_PORT  = 10022
```

### 备份及恢复
```
./gogs backup
./gogs restore --from="gogs-backup-xxx.zip"
```