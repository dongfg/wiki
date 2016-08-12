---
title: "docker 加速器配置"
date: 2016-08-10 10:00
layout: page
tag: docker,mirror
---

> 以下配置仅在 1.12 版本验证
> daocloud 及 aliyun 都提供加速器，需要注册登录获取自己独有的加速器地址

## For Linux
Centos 7 配置：
修改 `/usr/lib/systemd/system/docker.service` 
ExecStart 添加 `--registry-mirror=https://dn3uqhye.mirror.aliyuncs.com`，eg：
```
ExecStart=/usr/bin/dockerd --registry-mirror=https://dn3uqhye.mirror.aliyuncs.com
```
## For Windows
Docker Toolbox 配置：
```
docker-machine ssh default
```
修改 `/var/lib/boot2docker/profile`
EXTRA_ARGS 中添加 `--registry-mirror=https://dn3uqhye.mirror.aliyuncs.com`，eg：
```
EXTRA_ARGS='
--label provider=virtualbox
--registry-mirror=https://dn3uqhye.mirror.aliyuncs.com
'
```
退出 `exit` ，重启 `docker-machine restart default`