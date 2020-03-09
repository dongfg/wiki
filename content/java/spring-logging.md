---
title: Spring 日志配置
date: 2020-03-09 10:12:48
tag: java, spring
---

> 官方文档 [howto-logging](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto-logging)

## 剥离 appender
`logback-appender.xml`: 
```xml
<?xml version="1.0" encoding="UTF-8"?>
<included>
    <appender name="APP_FILE"
              class="ch.qos.logback.core.rolling.RollingFileAppender">
        <encoder>
            <pattern>${APP_FILE_LOG_PATTERN:-${FILE_LOG_PATTERN}}</pattern>
        </encoder>
        <file>${APP_LOG_FILE}</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <cleanHistoryOnStart>${APP_LOG_FILE_CLEAN_HISTORY_ON_START:-${LOG_FILE_CLEAN_HISTORY_ON_START:-false}}
            </cleanHistoryOnStart>
            <fileNamePattern>${APP_ROLLING_FILE_NAME_PATTERN:-${APP_LOG_FILE}.%d{yyyy-MM-dd}.%i.gz}</fileNamePattern>
            <maxFileSize>${APP_LOG_FILE_MAX_SIZE:-${LOG_FILE_MAX_SIZE:-10MB}}</maxFileSize>
            <maxHistory>${APP_LOG_FILE_MAX_HISTORY:-${LOG_FILE_MAX_HISTORY:-7}}</maxHistory>
            <totalSizeCap>${APP_LOG_FILE_TOTAL_SIZE_CAP:-${LOG_FILE_TOTAL_SIZE_CAP:-0}}</totalSizeCap>
        </rollingPolicy>
    </appender>
</included>
```

### spring-logback 配置
`spring-logback.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <include resource="org/springframework/boot/logging/logback/defaults.xml"/>
    <property name="LOG_FILE" value="${LOG_FILE:-${LOG_PATH:-${LOG_TEMP:-${java.io.tmpdir:-/tmp}}/}spring.log}"/>
    <property name="APP_LOG_FILE"
              value="${APP_LOG_FILE:-${LOG_PATH:-${LOG_TEMP:-${java.io.tmpdir:-/tmp}}/}application.log}"/>
    <include resource="org/springframework/boot/logging/logback/console-appender.xml"/>
    <include resource="org/springframework/boot/logging/logback/file-appender.xml"/>
    <include resource="logback-appender.xml"/>
    
    <logger name="com.change.it" level="DEBUG">
        <appender-ref ref="APP_FILE"/>
    </logger>
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/>
    </root>
</configuration>
```