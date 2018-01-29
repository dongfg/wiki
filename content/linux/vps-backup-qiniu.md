---
title: "VPS 备份到七牛"
date:  2018-01-29 10:20:00
tag: [backup, qiniu]
---
[TOC]

## qshell 安装
```bash
wget https://dn-devtools.qbox.me/2.1.5/qshell-linux-x64
mv qshell-linux-x64 qshell
chmod +x qshell
sudo mv qshell /usr/bin/
qshell account ak sk
```

## 备份目录配置
```
sudo mkdir backup && sudo chown dongfg: backup
```
upload.conf:
```json
{
    "src_dir" : "/opt/backup",
    "ignore_dir" : true,
    "bucket" : "backup"
}
```

## [jobber](https://dshearer.github.io/jobber/) 定时任务
### 文件上传任务
```
- name: qiniu-backup 
  cmd: |
    /usr/bin/qshell qupload 5 /opt/backup/upload.conf
  time: "0 0 23 * * *"
```

### script备份
```
- name: script-backup 
  cmd: |
    /opt/script/script_backup.sh
  time: "0 0 22 * * *"
```

### 数据库备份
```
- name: mysql-backup 
  cmd: |
    /opt/script/mysql_backup.sh
  time: "0 1 22 * * *"
```

### nginx备份
```
- name: nginx-backup 
  cmd: |
    /opt/script/nginx_backup.sh
  time: "0 2 22 * * *"
```

### gogs备份
```
- name: gogs-backup 
  cmd: |
    /opt/script/gogs_backup.sh
  time: "0 3 22 * * *"
```  