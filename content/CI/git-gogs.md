---
title: "Gogs 搭建GIT服务"
date: 2016-08-10 13:00
layout: page
tag: docker,gogs,git
---

### gogo 镜像
```
docker pull gogs/gogs
```
> docker-compose.yml
```
gogs:
  image: gogs/gogs
  container_name: gitserver
  ports:
    - "10022:22"
    - "10080:3000"
  volumes:
    - /opt/gogs/data:/data
```
