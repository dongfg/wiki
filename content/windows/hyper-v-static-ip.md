---
title: Hyper-V 虚拟机静态IP
date: 2019-04-17 08:34:28
draft: true
---

## Hyper-V Switch 配置
新建一个 NAT Switch，默认的 Switch 重启后设置的IP会变原因不明
设置 Switch 的 IP，不要跟局域网冲突，比如：
```
IP 地址： 192.168.168.1
子网掩码： 255.255.255.0
```


## 设置虚拟机的 IP 地址
### Debian
```
vi /etc/network/interfaces
# iface eth0 inet dhcp
iface eth0 inet static
    address 192.168.168.100
    netmask 255.255.255.0
    gateway 192.168.168.1
```