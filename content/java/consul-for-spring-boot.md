---
title: Spring Boot 基于 consul 的服务发现于配置管理
date: 2019-04-15 15:07:44
tag: java, spring, spring-boot, consul
---
[TOC]

## Consul
### 下载地址 https://www.consul.io/downloads.html
使用 Centos 7 环境
```
mkdir -p /opt/apps/consul && cd /opt/apps/consul
mkdir conf.d data
wget https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip && unzip consul_1.4.4_linux_amd64.zip
mv consul /usr/local/bin/
rm -f consul_1.4.4_linux_amd64.zip
```
### 单机配置
```
cat <<EOF > conf.d/config.json
{
  "bootstrap": true,
  "bind_addr": "127.0.0.1",
  "client_addr": "10.64.90.127",
  "datacenter": "dev",
  "data_dir": "/opt/apps/consul/data",
  "log_level": "INFO",
  "node_name": "consul-dev",
  "server": true
}
EOF
```

### systemd 服务
```
sudo vi /etc/systemd/system/consul.service
[Unit]
Description=consul agent
Requires=network-online.target
After=network-online.target

[Service]
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/usr/local/bin/consul agent -config-dir=/opt/apps/consul/conf.d/ -ui
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
```

### ACL
https://learn.hashicorp.com/consul/advanced/day-1-operations/acl-guide

> 权限划分

#### 启用 ACL, 配置 agent token
|Policy Name|Node Policy|Service Policy|Key Policy(K/V)|
|-|-|-|-|
|Agent|write all|read all|read all|
|KV数据管理|read all|read all|write all|
|单个微服务|read all|read all, write self|read self(config/appName\[,env\]/data)|
> 样例：
> - read all: node_prefix "" { policy = "read" }, service_prefix "" { policy = "read" }
> - write all: node_prefix "" { policy = "write" }, service_prefix "" { policy = "write" }
> - read self: key_prefix "config/appName" { policy = "read" }
```
# 添加配置
"acl": {
  "enabled": true,
  "default_policy": "deny",
  "down_policy": "extend-cache"
}
# 重启服务后创建Bootstrap Token
consul acl bootstrap
AccessorID:   d985a0ae-8b42-3ec4-3333-6d2cc44fbd19
SecretID:     4e3ff3bd-5c63-71c2-328c-9b2a5bf7ff66
Description:  Bootstrap Token (Global Management)
Local:        false
Create Time:  2019-04-16 09:13:27.0869488 +0800 CST
Policies:
   00000000-0000-0000-0000-000000000001 - global-management

# 使用 Bootstrap Token 创建 Agent Token
# !妥善保管 Bootstrap Token
# 过程见下方演示，生成之后添加到配置文件，重启服务
"acl": {
  "enabled": true,
  "default_policy": "deny",
  "down_policy": "extend-cache",
  "tokens": {
    "agent": "da666809-98ca-0e94-a99c-893c4bf5f9eb"
  }
}
```

#### Policy 及 Token 创建流程
```
# 新建/更新 Policy
cat <<EOF > conf.d/config.json
node_prefix "" {
  policy = "read"
}
service_prefix "" {
  policy = "read"
}
key_prefix "" {
  policy = "write"
}
EOF
consul acl policy create/update -name "POLICY_NAME" -description "POLICY_DESC" -rules @policy.hcl
# 新建/更新 Token
consul acl token create -description "TOKEN_DESC" -policy-name "POLICY_NAME"
```

## Spring Boot
https://cloud.spring.io/spring-cloud-consul/single/spring-cloud-consul.html
### 依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-consul-discovery</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-consul-config</artifactId>
</dependency>
```

### bootstrap
```yaml
spring:
  profiles:
    active: dev
  application:
    name: api-template

---
spring:
  profiles: dev
  cloud:
    consul:
      host: 10.64.90.127
      port: 8500
      config:
        enabled: false
        format: yaml
        data-key: yaml
        acl-token: 18052848-44f7-dffa-d1af-e49eb484de49
```

### application config
```yaml
spring:
  cloud:
    consul:
      discovery:
        acl-token: 18052848-44f7-dffa-d1af-e49eb484de49
        instance-id: ${spring.application.name}:${spring.cloud.client.ip-address}:${server.port}
```

> spring.cloud.consul.discovery.instance-id 默认值是 应用名:端口，会导致多个 instance 的 instance-id 相同