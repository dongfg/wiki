---
title: Maven 依赖使用最新版本
date: 2018-01-10 11:12:39
tag: java, maven
---

### 错误的配置
version 使用 `LATEST` 或 `RELEASE`

这是 maven2 的用法，maven3 虽然能用，但后面会删除

### 正确做法
```shell
# 从所有 repository 中查找最新版本
mvn versions:use-latest-releases
# 保存修改（会删除pom文件的备份）
mvn versions:commit
```