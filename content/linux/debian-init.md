---
title: Debian 基本及安全设置
date: 2018-12-03 09:21:21
tag: linux, debian
---
[TOC]

### [源](https://mirror.nju.edu.cn/mirrorz-help/debian/?mirror=NJU)
```
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirror.nju.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirror.nju.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirror.nju.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirror.nju.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirror.nju.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirror.nju.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://mirror.nju.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://mirror.nju.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware

# deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# # deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
```

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
# Origins-Pattern 选择自动更新的 package
vi /etc/apt/apt.conf.d/50unattended-upgrades
# 开启自动更新
sudo dpkg-reconfigure unattended-upgrades
# 测试
sudo unattended-upgrades --dry-run --debug
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
