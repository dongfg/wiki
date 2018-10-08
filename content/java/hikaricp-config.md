---
title: HikariCP 数据源常用配置
date: 2018-10-08 13:57:00
tag: java, database
---

## 常用配置项
### connectionTimeout
默认值： 30000 (30 seconds)
从连接池中取连接最大的等待时间，如果超时没取到，会抛出异常

### maxLifetime
默认值： 1800000 (30 minutes)
连接的最大生命周期，建议设置值比数据库自动断开连接时间（比如 mysql 的 wait_timeout ）小几秒

### maximumPoolSize
默认值：10
[建议设置](https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing)
connections = ((core_count * 2) + effective_spindle_count)