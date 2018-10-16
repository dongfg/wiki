---
title: 用docker配置开发环境服务
date: 2018-10-16 09:30:48
tag: docker
---

### dev-server.yml
[点击此处下载](../../attach/dev-server.yml)

```yaml
version: '3.1'
services:
  mysql:
    image: mysql:5
    container_name: dev-server-mysql
    restart: always
    ports:
      - 53306:3306
    environment:
       MYSQL_ROOT_PASSWORD: "4DevOn1y"
  adminer:
    image: adminer
    restart: always
    container_name: dev-server-mysql-adminer
    ports:
      - 58080:8080
  redis:
    image: redis
    container_name: dev-server-redis
    restart: always
    ports:
      - 56379:6379
  mongo:
    image: mongo
    restart: always
    container_name: dev-server-mongo
    ports:
      - 57017:27017
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: "4DevOn1y"

  mongo-express:
    image: mongo-express
    restart: always
    container_name: dev-server-mongo-express
    ports:
      - 58081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: root
      ME_CONFIG_MONGODB_ADMINPASSWORD: "4DevOn1y"
```
