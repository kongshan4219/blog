---
title: "打包maven项目"
date: 2026-06-04
tags: ["dev"]
---

#date/2025-01-26 01:00:22# #lastmod/2025-01-26 01:00:22#

---

# 打包maven项目

## `maven-assembly-plugin`

`maven-assembly-plugin`可以将所有的东西都打包到一个jar包中。

~~~xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
            <configuration>
                <archive>
                <manifest>
                    <mainClass>
                        com.example.main
                    </mainClass>
                </manifest>
                </archive>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
            </configuration>
        </execution>
    </executions>
</plugin>
~~~

执行`mvn package`后，会在target文件夹下生成两个jar包，一个是不带依赖的jar包，一个是后缀有`-dependencies`带有依赖的jar包
