---
title: nexus3 docker private registry
date: 2020-05-19 21:36:06
tag: docker
---

## Nexus3 部署
docker-compose.yml：
```
version: "3"

services:
  nexus:
    image: sonatype/nexus3
    container_name: nexus3
    volumes:
      - "/mnt/disk2/nexus3:/nexus-data"
    ports:
      - "8081:8081"
      - "8082:8082"
      - "8083:8083"
```

> 8081 nexus web端口
> 8082 docker group 端口，docker pull 等操作
> 8083 docker hosted 端口，docker push 等操作

## Nexus3 配置
### 创建 Blob store
*Repository -> Blob Stores*
分别创建 proxy 跟 hosted 对应 Blob store

### 创建仓库
*Repository -> Repositories*
#### Hosted 仓库，私有仓库
- 启用 HTTP 8083 端口
- 允许匿名pull

#### Proxy 仓库，代理 docker hub
- 允许匿名pull
- Remote Storgae： https://registry-1.docker.io
- Docker Index: Use Docker Hub

#### Group 仓库，聚合其他仓库
- 启用 HTTP 8082 端口
- 允许匿名pull
- Group 选择上述创建的仓库

### 权限配置
#### Realms
*Security -> Realms*，添加 `Docker Bearer Token Realm`

#### 角色及用户
角色权限(所有仓库可读，hosted仓库可写)：
- nx-repository-view-docker-*-browse
- nx-repository-view-docker-*-read
- nx-repository-view-docker-docker-hosted-*

创建用户并赋予角色


## Nginx 配置
### Nexus 域名
普通反向代理配置，端口8081

### Registry 域名

```
# group 仓库端口
upstream nexus-docker {
	server 10.64.90.162:8082;
}

# hosted 仓库端口
upstream nexus-docker-push {
	server 10.64.90.162:8083;
}

server {
	...

	client_max_body_size 1G;

	location / {
		...

        # docker login
		if ( $request_uri ~ "/v2/token") {
			proxy_pass http://nexus-docker-push;
		}

        # docker pull
		if ( $request_method ~ GET ) {
			proxy_pass http://nexus-docker;
		}

        # other
		proxy_pass http://nexus-docker-push;
	}

}
```
