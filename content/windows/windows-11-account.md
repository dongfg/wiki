---
title: Windows 11 跳过TPM检查及微软账户
date: 2022-12-14 09:17:00
tag: windows
---
[TOC]

> Shift + F10 打开命令行窗口

### 跳过TPM检查

```text
reg add HKLM\System\Setup\LabConfig /v BypassTPMCheck /t reg_dword /d 1
```

### 直接创建本地账户

```shell
net user "admin" /add
net localgroup "Administrators" "admin" /add
cd oobe
msoobe && shutdown -r
## 开机后删除 defaultuser0
```

