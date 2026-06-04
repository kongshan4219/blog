---
title: "slf4j"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-10-03 01:18:29# #lastmod/2024-10-03 01:18:29#

---

# slf4j

## 依赖

~~~xml
<!--slf4j依赖-->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
</dependency>
~~~

## 配置

### application.yml 配置

~~~yaml
# slf4j日志配置
logging:
  # 配置级别
  level:
    root: info
    #分包配置级别，即不同的目录下可以使用不同的级别
    com.kongshan.*: debug
  #配置文件
  #config: classpath:logback-spring.xml
  #设置logback.xml位置
  #config: classpath:log/logback.xml
  #设置log4j.properties位置
  config: classpath:log4j.properties
~~~

### log4j.properties配置

~~~properties
# 定义根节点
log4j.rootLogger=debug,CONSOLE,info,error,DEBUG

# 设置控制台打印
log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern=---------------------------------\
%n [%d{yyyy-MM-dd-HH-mm}] %n [%t] %n [%c] %n [%p] %n - %m%n
log4j.appender.CONSOLE.Threshold=info
log4j.appender.console.an.si.enabled = true
# 输出到info日志文件
log4j.appender.info=org.apache.log4j.DailyRollingFileAppender
log4j.appender.info.layout=org.apache.log4j.PatternLayout
log4j.appender.info.layout.ConversionPattern=---------------------------------\
%n [%d{yyyy-MM-dd-HH-mm}] %n [%t] %n [%c] %n [%p] %n - %m%n
log4j.appender.info.datePattern='.'yyyy-MM-dd
log4j.appender.info.Threshold =INFO
log4j.appender.info.append=true
log4j.appender.info.File=E:/dance/demo/log/info.log
#  原本日志格式  %d{yyyy-MM-dd-HH-mm} [%t] [%c] [%p] - %m%n
#  第二版       %d{yyyy-MM-dd-HH-mm} %n [%l] %n [%t] %n [%c] %n [%p] %n - %m%n
# 输出到error日志文件
log4j.appender.error=org.apache.log4j.DailyRollingFileAppender
log4j.appender.error.layout=org.apache.log4j.PatternLayout
log4j.appender.error.layout.ConversionPattern=---------------------------------\
%n [%d{yyyy-MM-dd-HH-mm}] %n [%t] %n [%c] %n [%p] %n - %m%n
log4j.appender.error.datePattern='.'yyyy-MM-dd
log4j.appender.error.Threshold =ERROR
log4j.appender.error.append=true
log4j.appender.error.File=E:/dance/demo/log/error.log

# 输出到debug日志文件
log4j.appender.DEBUG=org.apache.log4j.DailyRollingFileAppender
log4j.appender.DEBUG.layout=org.apache.log4j.PatternLayout
log4j.appender.DEBUG.layout.ConversionPattern=---------------------------------\
%n [%d{yyyy-MM-dd-HH-mm}] %n [%t] %n [%c] %n [%p] %n - %m%n
log4j.appender.DEBUG.datePattern='.'yyyy-MM-dd
log4j.appender.DEBUG.Threshold =DEBUG
log4j.appender.DEBUG.append=true
log4j.appender.DEBUG.File=E:/dance/demo/log/debug.log
~~~

### slf4j2.xml

~~~xml
<Configuration status="WARN">
    <Appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%highlight{%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n}{FATAL=red blink, ERROR=red, WARN=yellow bold, INFO=green, DEBUG=blue bold, TRACE=blue}"/>
        </Console>
    </Appenders>
    <Loggers>
        <Root level="info">
            <AppenderRef ref="Console"/>
        </Root>
    </Loggers>
</Configuration>
~~~
