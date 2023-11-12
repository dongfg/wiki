---
title: Scoop 快速安装 Windows 应用
date: 2023-11-11 20:08:00
tag: windows
---

### Scoop 安装

```shell
# 设置代理
[net.webrequest]::defaultwebproxy = new-object net.webproxy "http://127.0.0.1:7890"
# 设置 scoop 文件夹
[environment]::setEnvironmentVariable('SCOOP', 'D:\Scoop', 'User'); $env:SCOOP='D:\Scoop'
# 安装
irm get.scoop.sh | iex
```

### Scoop 设置

```
scoop config proxy 127.0.0.1:7890
scoop bucket add extras
```

### 应用安装

```
# 基础应用
scoop install main/oh-my-posh extras/peazip extras/powertoys
# 开发相关
scoop install main/nvm main/git extras/vscode main/kubectl extras/jetbrains-toolbox extras/wechat extras/insomnia
# 其他
scoop install extras/openvpn-connect extras/snipaste extras/honeyview
```
