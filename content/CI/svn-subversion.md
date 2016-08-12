---
title: "SVN搭建"
date: 2016-07-28 00:00
layout: page
tag: svn,subversion,apache,php
---

## Centos搭建SVN 服务器
环境：Centos7+Apache+Php

### 安装Apache
```
yum -y install httpd httpd-tools
```

### 安装Subversion
```
# Apache svn模块mod_dav_svn
yum -y install subversion subversion-tools mod_dav_svn
```
### SVNweb管理界面iF.SVNAdmin
```
# 自行安装PHP
# https://github.com/mfreiholz/iF.SVNAdmin
```

### 配置
#### 1. 创建SVN仓库存放的目录，eg : /opt/svnrepo
```
mkdir /opt/svnrepo
```
#### 2. 创建SVN系统管理员
```
htpasswd -cm /etc/svn-auth-users svnadmin
```
#### 3. 创建权限控制文件
```
touch /etc/svn-acl-conf
```
>  文件内容
```
[/]
*=r
```
#### 4. Apache 配置
```
vim /etc/httpd/conf.modules.d/10-subversion.conf
--------
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
LoadModule dontdothat_module  modules/mod_dontdothat.so

<Location /svn>
   DAV svn
   SVNListParentPath on
   SVNParentPath /opt/svnrepo
   AuthType Basic
   AuthName "Subversion repositories"
   AuthUserFile /etc/svn-auth-users
   AuthzSVNAccessFile /etc/svn-acl-conf
   Require valid-user
</Location>
```
#### 5. SVNAdmin配置
Subversion 授权文件 --> /etc/svn-acl-conf
用户身份验证文件 --> /etc/svn-auth-users
代码仓库的父目录 --> /opt/svnrepo
