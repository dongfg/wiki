---
title: R2S 软路由
date: 2020-04-29 08:08:34
---

[TOC]

> Writing ...

## ROM

https://github.com/klever1988/nanopi-openwrt

## 路由器 纯 AP 配置

设置成 AP 模式，接 lan 口，关闭 dhcp，设置静态 IP

## DNS 解析方案

https://github.com/pymumu/smartdns
大陆/非大陆两个服务

https://github.com/pexcn/openwrt-chinadns-ng
chinadns-ng 指定上述两个 dns

dnsmasq 指定为 chinadns-ng

adguardHome -> dnsmasq
