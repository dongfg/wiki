---
title: "postgresql docker 安装配置"
date: 2016-08-10 10:00
layout: page
tag: pg,postgresql,docker
---
### pull image
```
docker pull postgres
```

### docker-compose
```
mkdir -p /opt/postgresql/data
cd /opt/postgresql
touch docker-compose.yml
```
挂载data目录，设置super用户的用户名密码及其他设置，`docker-compose.yml` :
```
postgres:
  image: postgres
  container_name: postgresdb
  ports:
    - "5432:5432"
  environment:
    - POSTGRES_USER=develop
    - POSTGRES_PASSWORD=develop
  volumes:
    - /opt/postgresql/data:/var/lib/postgresql/data
```
