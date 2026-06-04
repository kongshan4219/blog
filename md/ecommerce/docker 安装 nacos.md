---
title: "docker 安装 nacos"
date: 2026-06-04
tags: ["ecommerce"]
---

#date/2024-09-14# #lastmod/2024-09-14#

---

### Docker 拉取镜像

~~~shell
docker pull nacos/nacos-server:v2.3.2
~~~

### 启动 nacos 并复制文件到宿主机，关闭容器

#### 启动容器

~~~
docker run -p 8848:8848 --name nacos -d nacos/nacos-server:v2.2.3
~~~

#### 创建挂载目录

~~~~
mkdir -p /root/docker/cloud/nacos
~~~~

#### 复制文件

```
docker cp nacos:/home/nacos/logs/ /root/docker/cloud/nacos
docker cp nacos:/home/nacos/conf/ /root/docker/cloud/nacos
docker cp nacos:/home/nacos/bin/ /root/docker/cloud/nacos
```

#### 关闭删除容器

~~~
docker stop nacos
docker rm nacos
~~~

### mysql 中创建 nacos 所需的表

- mysql 中新建一个库，名字可自定义，这里就用 nacos_config
- 使用/root/docker/cloud/nacos/conf 中的 mysql-schema.sql 创建表

### 再次启动 nacos

~~~
docker run -d \
  --name nacos \
  --restart=always \
  -e MODE=standalone \
  -p 8848:8848 \
  -p 9848:9848 \
  -v /opt/docker_data/nacos_2.3.2/logs:/home/nacos/logs \
  -v /opt/docker_data/nacos_2.3.2/bin:/home/nacos/bin \
  -v /opt/docker_data/nacos_2.3.2/conf:/home/nacos/conf \
  nacos/nacos-server:v2.3.2
~~~
