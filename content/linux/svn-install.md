---
title: "SVN服务器搭建"
date:  2016-12-12 15:12
tag: 
    - svn
---
> 运行环境：CentOS 7+Apache+Php
总览:

![](../../attach/svn.png)


## 安装
### Apache
```
yum -y install httpd httpd-tools
```

### Subversion
```
# Apache svn模块mod_dav_svn
yum -y install subversion subversion-tools mod_dav_svn
```

### web管理界面
```
# 安装PHP
yum install php

# https://github.com/mfreiholz/iF.SVNAdmin
# 假设安装在/opt/svnadmin目录
```

## 配置
### 1. 创建SVN仓库存放的目录，eg : /opt/svnrepo
```
mkdir /opt/svnrepo
```

### 2. 创建SVN系统管理员
```
htpasswd -cm /etc/svn-auth-users svnadmin
```

### 3. 创建权限控制文件
```
# touch /etc/svn-acl-conf
[/]
*=r
```

### 4. Apache 配置
> vi /etc/httpd/conf/httpd.conf
修改原有80端口，添加8080, 9080两个端口
Listen 8080
Listen 9080
> 添加`RequestHeader edit Destination ^https http early`

/etc/httpd/conf.modules.d/11-subversion.conf
```
<VirtualHost *:8080>
	ServerName localhost
	ServerAlias localhost

	LoadModule dav_svn_module     modules/mod_dav_svn.so
	LoadModule authz_svn_module   modules/mod_authz_svn.so
	LoadModule dontdothat_module  modules/mod_dontdothat.so

	LimitXMLRequestBody 0 
	LimitRequestBody 0

	<Location />
		DAV svn
		SVNListParentPath on
		SVNParentPath /opt/svnrepo
		AuthType Basic
		AuthName "Subversion repositories"
		AuthUserFile /etc/svn-auth-users
		AuthzSVNAccessFile /etc/svn-acl-conf
		Require valid-user
	</Location>
</VirtualHost>
```
/etc/httpd/conf.modules.d/12-svnadmin.conf
```
<VirtualHost *:9080>
	DirectoryIndex index.php
        DocumentRoot /opt/svnadmin
	ServerName localhost
	RewriteEngine on
	RewriteRule ^index\.html$ index.php$1 [L,R=301]

	<Directory "/opt/svnadmin">
		Options Indexes FollowSymLinks
		Require all granted
        </Directory>
</VirtualHost>
```

### 5. Nginx配置
```
client_max_body_size     1024m;
server {
    ...
    location /svnadmin{
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:9080/;
    }

    location ^~ /{
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:8080;
    }
    ...
}
```

### 6. SVNAdmin配置
Subversion 授权文件 --> /etc/svn-acl-conf 用户身份验证文件 --> /etc/svn-auth-users 代码仓库的父目录 --> /opt/svnrepo
