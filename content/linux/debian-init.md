---
title: Debian 基本及安全设置
date: 2018-12-03 09:21:21
tag: linux, debian
---
[TOC]

### 添加用户
```
adduser --disabled-password dongfg
apt install sudo

# 免密 dongfg ALL=(ALL) NOPASSWD:ALL
vi /etc/sudoers.d/90-init-user
```

### 自动更新
```
apt install unattended-upgrades

```

### ssh安全设置
```
...
PermitRootLogin no
...
PasswordAuthentication no
...
Port 22222
#AddressFamily any
ListenAddress 0.0.0.0
```

### 启用 ufw
