---
title: Teamcity 配置
date: 2018-10-26 14:14:24
tag: docker
---
### teamcity-docker
```yaml
version: "3"
services:
  server:
    image: jetbrains/teamcity-server
    container_name: teamcity-server
    ports:
      - "8111:8111"
    volumes:
      - /opt/docker/teamcity/data:/data/teamcity_server/datadir
      - /opt/docker/teamcity/logs:/opt/teamcity/logs
  teamcity-agent:
    image: jetbrains/teamcity-agent
    container_name: teamcity-agent-1
    environment:
      - SERVER_URL=http://server:8111
      - AGENT_NAME=agent-1
```
