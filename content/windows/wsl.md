---
title: WSL 环境
date: 2025-06-24 13:34:17
tag: windows
---

# 备份、恢复

```pwsh
wsl --export Debian debian_wsl.tar
# wsl --import <DistroName> <InstallLocation> <InstallTarFile>
wsl --import Debian D:\Debian .\debian_wsl.tar
```

# wsl 访问宿主机网络

```shell
# 获取宿主机 IP
ip route show default | awk '/default/ {print $3; exit}'
```

# [wsl.conf 配置](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config)
```txt
# 比如指定主机名
[network]
generateHosts=false
hostname=wsl-debian
```

# wsl 访问宿主机 bitwarden ssh agent

## wsl 需要安装 socat + npiperelay
- `sudo apt install socat`
- https://github.com/jstarks/npiperelay
  - release 中下载 npiperelay_windows_amd64.zip 解压 npiperelay.exe 到 /usr/local/bin

## bitwarden-ssh-agent.sh

```shell
#!/bin/bash

# 设置套接字路径
SOCKET_PATH="$HOME/.ssh/agent.sock"

# 清理旧套接字
rm -f $SOCKET_PATH

# 启动转发
setsid nohup socat \
  UNIX-LISTEN:$SOCKET_PATH,fork \
  EXEC:"/usr/local/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork \
  >/dev/null 2>&1 &

# 设置环境变量
export SSH_AUTH_SOCK=$SOCKET_PATH
```

## bitwarden-ssh-agent.sh 自动执行
> .bashrc/.zshrc

```shell
# 启动 Bitwarden SSH Agent 转发
if [ -z "$SSH_AUTH_SOCK" ]; then
    source ~/.ssh/bitwarden-ssh-agent.sh >/dev/null 2>&1
fi
```