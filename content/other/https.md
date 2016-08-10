# ngxin https双向认证及tomcat https单向认证
- - - - 
`nginx` 挂在公网上，可以通过[let's encrypt](https://letsencrypt.org) 申请免费证书；
`tomcat` 通过 `nginx` 反向代理，只配置单向认证；
### 1、基本概念及认证流程
![](http://i1.piimg.com/524586/9de2873563a65e08s.jpg)
### 2、申请let's encrypt 证书
申请过程参考 https://imququ.com/post/letsencrypt-certificate.html

```shell
# 创建存放证书相关文件的目录
mkdir ssl && cd ssl
mkdir nginx tomcat client
cd nginx

# letsencrypt的账号私钥，相当于账号密码
openssl genrsa 4096 > letsencrypt-account.key

# 域名私钥，用于创建csr证书申请请求文件
openssl genrsa 4096 > nginx-domain.key

# 交互方式创建csr证书请求文件
# 注意Common Name的值为访问的域名
openssl req -new -sha256 -key nginx-domain.key -out nginx-domain.csr
```
**使用acme_tiny.py申请证书**
```
wget https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
```
`acme_tiny.py` 依赖 `argparse` 使用`pip` 或 `easy_install` 自行安装

**nginx 验证服务搭建，nginx配置**
```
mkdir /usr/share/nginx/challenges/
vi /etc/nginx/conf.d/challenges.conf
```
**文件内容**
```
server {
    server_name aws.zczy56.com;

    location ^~ /.well-known/acme-challenge/ {
        alias /usr/share/nginx/challenges/;
        try_files $uri =404;
    }

    location / {
        rewrite ^/(.*)$ http://aws.zczy56.com/$1 permanent;
    }
}
```

**重启 nginx**
`nginx -s reload`
**打开防火墙**
```
python acme_tiny.py --account-key ./letsencrypt-account.key --csr ./nginx-domain.csr --acme-dir /usr/share/nginx/challenges/ > ./letsencrypt-signed.crt
```
> 提示无法下载文件可能是域名无法解析，可在/etc/hosts中配置解析

**合并中间证书**
```
wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
cat letsencrypt-signed.crt intermediate.pem > nginx-chained.pem
```

nginx  ssl配置（测试用）
```
cd /etc/nginx/conf.d/
cp example_ssl.conf ssl.conf
vi ssl.conf
```

```
# HTTPS server
server {
    listen       443 ssl;
    server_name  aws.zczy56.com;

    ssl_certificate      /root/ssl/nginx/nginx-chained.pem;
    ssl_certificate_key  /root/ssl/nginx/nginx-domain.key;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

}

```
重启nginx `nginx -s reload`
访问查看结果 `https://aws.zczy56.com/`

### 3、自建CA颁发appclient端证书
参考http://www.robinhowlett.com/blog/2016/01/05/everything-you-ever-wanted-to-know-about-ssl-but-were-afraid-to-ask/
#### 创建CA根证书
*openssl配置*
```
cd /etc/pki/tls
echo 100001 > serial
touch index.txt
mkdir newcerts
```

*vi openssl.cnf 修改`default_md` 为 sha512*
*修改 dir             = /etc/pki/tls          # Where everything is kept*

```
openssl req -new -x509 -extensions v3_ca -keyout private/cakey.pem -out cacert.pem -days 3650 -config ./openssl.cnf
```
*生成appclient需要两个的文件*
`client_keystore.jks` -- 存储由CA生成的证书，双向认证时发送给nginx认证
`client_truststore.jks`   -- 存储信任的服务端证书(即let's encrypt发放的证书)

ssl.conf 配置删除，其中的内容移动到api.conf，开启双向认证，文件内容见下：
`cacert.pem` 由上一步产生

```
# HTTPS server
server {
    listen       443 ssl;
    server_name  aws.zczy56.com;

    ssl_certificate      /root/ssl/nginx/nginx-chained.pem;
    ssl_certificate_key  /root/ssl/nginx/nginx-domain.key;

    # two way auth
    ssl_verify_client on;
    ssl_verify_depth 1;
    ssl_client_certificate /root/ssl/rootCA/cacert.pem;

    location /tomcat {
	proxy_pass http://127.0.0.1:8080/;
	proxy_redirect off ;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

}
```

**生成 client_keystore.jks :**
```
# 生成client的key及证书申请请求
openssl req -new -nodes -out client-req.pem -keyout private/client-key.pem -days 3650 -config openssl.cnf 

# 由CA根据证书请求 颁发证书client-cert.pem
openssl ca -out client-cert.pem -days 3650 -config openssl.cnf -infiles client-req.pem


# 转换成p12文件client-cert.p12，后续转成jks文件
openssl pkcs12 -export -in client-cert.pem -inkey private/client-key.pem -certfile cacert.pem -name "Client" -out client-cert.p12

# jks文件 client_keystore.jks
keytool -importkeystore -srckeystore client-cert.p12 -srcstoretype pkcs12 -destkeystore client_keystore.jks -deststoretype jks -deststorepass dfg123456

```
**生成client_truststore.jks :**
```
# nginx-chained.pem 为letsencrypt颁发的证书，client_truststore.jks 表示客户端信任该证书
keytool -import -v -trustcacerts -keystore client_truststore.jks -storepass dfg123456 -alias server -file /root/ssl/nginx/nginx-chained.pem

mv client* /root/ssl/client/
mv private/client-key.pem /root/ssl/client/
```

### 3、tomcat keystore生成
```
cd /root/ssl/tomcat
keytool -genkey -alias tomcat -keyalg RSA -keystore server_keystore.jks
```
**tomcat 开启Https配置：**
```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
        maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
        keystoreFile="/root/ssl/tomcat/server_keystore.jks" keystorePass="dfg123456"
        clientAuth="false" sslProtocol="TLS" />
```

