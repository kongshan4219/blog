---
title: "slf4j+logback"
date: 2026-06-04
tags: ["dev"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

依赖

```xml
<dependencies>
    <!--日志-->
    <!--slf4j依赖-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
    </dependency>
    <!-- logback 依赖 -->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
    </dependency>
</dependencies>
```

application.yml 配置

```yaml
# slf4j日志配置
logging:
  # 配置级别
  level:
    root: info
    #分包配置级别，即不同的目录下可以使用不同的级别
    com.kongshan.*: debug
  #配置文件
  config: classpath:logback-spring.xml
  #设置logback.xml位置
  #config: classpath:log/logback.xml
  #设置log4j.properties位置
  #config: classpath:log4j.properties
```

logback.xml配置

~~~xml
<?xml version='1.0' encoding='UTF-8'?>
<!--日志配置-->
<configuration>
    <!--直接定义属性-->
    <property name="logFile" value="logs/mutest"/>
    <property name="maxFileSize" value="30MB"/>

    <!--控制台日志-->
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d [%thread] %-5level %logger{50} -[%file:%line]- %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>

	<!--滚动文件日志-->
    <appender name="fileLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${logFile}.log</file>
        <encoder>
        	<!--日志输出格式-->
            <pattern>%d [%thread] %-5level -[%file:%line]- %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>${logFile}.%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <maxFileSize>${maxFileSize}</maxFileSize>
        </rollingPolicy>
    </appender>
    <!--创建一个具体的日志输出-->
    <logger name="com.mutest" level="info" additivity="true">
    	<!--可以有多个appender-ref，即将日志记录到不同的位置-->
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="fileLog"/>
    </logger>

    <!--基础的日志输出-->
    <root level="info">
    </root>
</configuration>
~~~

自定义 log 工具类

```java
package com.kongshan.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * 日志工具类
 * @Author: 空山
 * @Date: 2023/11/12/17:26
 * @Description:
 */


public class LogUtils {
    private static final Logger logger = LoggerFactory.getLogger(LogUtils.class);

    public static void trace(String message) {
        if (logger.isTraceEnabled()) {
            logger.trace(message);
        }
    }

    public static void debug(String message) {
        if (logger.isDebugEnabled()) {
            logger.debug(message);
        }
    }

    public static void info(String message) {
        if (logger.isInfoEnabled()) {
            logger.info(message);
        }
    }

    public static void warn(String message) {
        if (logger.isWarnEnabled()) {
            logger.warn(message);
        }
    }

    public static void error(String message, Throwable throwable) {
        logger.error(message, throwable);
    }
}

```
