---
title: IDEA下spring-boot-freemarker 热部署
date: 2018-01-10 11:12:39
tag: java, spring, spring-boot,freemarker
---
### 1. 添加devtools依赖
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

### 2. IDEA 自动 build
File -> Settings -> Build, Execution, Deployment -> Compiler

选中 `Build project automatically`

Ctrl + Shift + A -> `Registry`

选中 `compiler.automake.allow.when.app.running`

> `compiler.automake.trigger.delay` 可以设置 automake 的延迟

### 3. 模板引擎设置
freemarker 在 property 文件中配置 `spring.freemarker.cache=false`

其他模板引擎参考 [Hot swapping](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-hotswapping.html)