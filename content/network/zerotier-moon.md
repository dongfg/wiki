---
title: Zerotier Moon 节点使用
date: 2022-06-11 16:57:11
---

> 内容已失效

[Moon 节点搭建参考](https://www.tpfuture.top/views/linux/ZerotierOneAddMoon.html#%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEzerotier)

### 配置

[Moon 文件](https://wiki.dongfg.com/attach/000000356603d9b9.moon)

## Linux
```shell
wget https://wiki.dongfg.com/attach/000000356603d9b9.moon
sudo mkdir -p /var/lib/zerotier-one/moons.d
sudo mv 000000356603d9b9.moon /var/lib/zerotier-one/moons.d
sudo chown -R zerotier-one: /var/lib/zerotier-one/moons.d
sudo systemctl restart zerotier-one.service
```

## Windows

打开服务 `ZeroTier One`, 找到可执行文件路径

并且在其下建立 `moons.d` 文件夹, 放入 Moon 文件, 重启服务

路径一般是Windows: C:\ProgramData\ZeroTier\One

### 查看节点是否连接
```
sudo zerotier-cli listpeers

200 listpeers xx xxxx xx 1.8.10 MOON
```