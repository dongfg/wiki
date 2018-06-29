---
title: "VPS 备份到七牛"
date:  2018-01-29 10:20:00
updated: 2018-06-29 09:36
tag: [backup, qiniu, jobber]
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
	"src_dir": "/opt/backup",
	"bucket": "backup",
	"check_exists": true,
	"check_size": true,
	"rescan_local": true,
	"overwrite": true
}
```

## [jobber](https://dshearer.github.io/jobber/) 定时任务
```
---
- name: qiniu-backup
  cmd: |
    /usr/bin/qshell qupload 5 /opt/backup/upload.conf
  time: "0 0 23 * * *"
- name: script-backup
  cmd: |
    /opt/script/script_backup.sh
  time: "0 0 22 * * *"
- name: mysql-backup
  cmd: |
    /opt/script/mysql_backup.sh
  time: "0 1 22 * * *"
- name: nginx-backup
  cmd: |
    /opt/script/nginx_backup.sh
  time: "0 2 22 * * *"
- name: gogs-backup
  cmd: |
    /opt/script/gogs_backup.sh
  time: "0 3 22 * * *"
- name: mongo-backup
  cmd: |
    /opt/script/mongo_backup.sh
  time: "0 4 22 * * *"
```

## 备份脚本
### mysql
```
# backup
mysqldump --databases db1 db2 -uroot -pXXXXXX > /opt/backup/mysql_dump.sql

# restore
mysql -uroot -pXXXXXX < /opt/backup/mysql_dump.sql
```

### gogo
```
# backup
/opt/gogs/gogs backup
mv gogs-backup-*.zip /opt/backup/gogs-backup.zip

# restore
/opt/gogs/gogs restore --database-only --from="/opt/backup/gogs-backup.zip"
```

### mongo
```
# backup
/usr/bin/mongodump --db DBNAME --username USER --password "XXXXXX" --out /tmp/mongo-backup
tar -zcvf /tmp/mongo-backup.tar.gz --directory /tmp mongo-backup
mv /tmp/mongo-backup.tar.gz /opt/backup/mongo-backup.tar.gz
rm -rf /tmp/mongo-backup

# restore
tar -zxvf /opt/backup/mongo-backup.tar.gz -C /tmp
/usr/bin/mongorestore --nsInclude 'DBNAME.*' --drop --username USER --password "XXXXXX" /tmp/mongo-backup
```