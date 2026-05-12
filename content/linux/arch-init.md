---
title: Arch 系 OS 配置
date: 2026-05-12 08:41:00
tag: linux
---
[TOC]

## GTX 1060 驱动
> 驱动已从官方仓库移动到 aur 仓库

> 会从 nvidia 官网下载 .run 的包，比较大，下载速度慢时设置 http_proxy https_proxy 代理

```shell
yay -S nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils nvidia-settings
```

## 中文输入法 - rime-ice-installer
[aur](https://aur.archlinux.org/packages/rime-ice-installer)
[source](https://github.com/manateelazycat/rime-ice-installer)

> go 语言开发的自动安装脚本，会自动安装 go 环境

```shell
yay -S rime-ice-installer
```