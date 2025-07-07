---
title: Grafana Cloud Alloy 配置
date: 2025-07-07 10:29:24
tag: linux, debian
---
[TOC]

## Alloy 仓库配置
```
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://mirrors.aliyun.com/grafana/debian stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://mirrors.aliyun.com/grafana/debian stable main
```

## Alloy 安装

```
sudo apt update
sudo apt install alloy
```

## Alloy 配置

### 从 Grafana Cloud Alloy 安装脚本修改
```
# 原始脚本
xxxxxxx /bin/sh -c "$(curl -fsSL https://storage.googleapis.com/cloud-onboarding/alloy/scripts/install-linux.sh)"
# 修改为
xxxxxxx /bin/sh -c "$(curl -fsSL https://wiki.dongfg.com/attach/install-alloy.sh)"
```