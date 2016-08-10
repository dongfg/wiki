### sudo 出现 unable to resolve host
/etc/hosts中 添加 127.0.0.1与主机名的映射,eg:
127.0.0.1   dev

### 编译python需要的libssl-dev
sudo apt-get install libssl1.0.0/trusty libssl-dev/trusty openssl/trusty

### python pytz.exceptions.UnknownTimeZoneError: 'local'
配置timezone：
sudo dpkg-reconfigure tzdata

### dbus 
修改/etc/init.d/dbus，原路径不存在：
```
DAEMON=/bin/dbus-daemon
UUIDGEN=/bin/dbus-uuidgen
```

### initctl: Unable to connect to Upstart: Failed to connect to socket /com/ubuntu/upstart
```
cat > /usr/sbin/policy-rc.d <<EOF
#!/bin/sh
exit 101
EOF
sudo chmod +x /usr/sbin/policy-rc.d
sudo dpkg-divert --local --rename --add /sbin/initctl
sudo ln -s /bin/true /sbin/initctl
```
### 22端口被占用
win10 内置了SSH Server 服务占用了22端口，停用 SSH Server Proxy，SSH Server Broker服务

### ssh localhost 服务登录
修改/etc/ssh/sshd_config，更改以下配置：
```
ListenAddress 0.0.0.0
UsePrivilegeSeparation no
PasswordAuthentication yes
```