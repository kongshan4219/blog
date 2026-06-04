---
title: "docker安装nacos"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-13# #lastmod/2024-09-13#

---

## docker安装nacos

### 拉取 Nacos 镜像

使用 Docker 拉取 Nacos 官方镜像。

```
docker pull nacos/nacos-server
```

### 运行 Nacos 容器

使用以下命令运行 Nacos 容器。可以根据需要调整端口映射、数据持久化等配置。

```
docker run -d \
  --name nacos \
  -e MODE=standalone \
  -p 8848:8848 \
  nacos/nacos-server
```

#### 参数解释

- `-d`: 后台运行容器。
- `--name nacos`: 指定容器名称为 `nacos`。
- `-e MODE=standalone`: 设置 Nacos 运行模式为单机模式。
- `-p 8848:8848`: 将主机的 8848 端口映射到容器的 8848 端口。
- `nacos/nacos-server`: 使用的镜像名称。

### 访问 Nacos 控制台

启动容器后，可以通过浏览器访问 Nacos 控制台。

```
http://<服务器IP>:8848/nacos
```

默认的用户名和密码是 `nacos`。

### 持久化数据

如果需要持久化 Nacos 的数据，可以将数据目录挂载到主机上。

```
docker run -d \
  --name nacos \
  -e MODE=standalone \
  -p 8848:8848 \
  -v /path/to/nacos/data:/home/nacos/data \
  -v /path/to/nacos/logs:/home/nacos/logs \
  nacos/nacos-server
```

### 使用 MySQL 作为数据源

如果需要使用 MySQL 作为 Nacos 的数据源，可以按照以下步骤操作：

#### 创建 MySQL 数据库

在 MySQL 中创建一个数据库和用户，并授权。

```
CREATE DATABASE nacos_devtest;
CREATE USER 'nacos'@'%' IDENTIFIED BY 'nacos';
GRANT ALL PRIVILEGES ON nacos_devtest.* TO 'nacos'@'%';
FLUSH PRIVILEGES;
```

#### 修改 Nacos 配置

在 `application.properties` 中配置 MySQL 连接信息。

```
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://127.0.0.1:3306/nacos_devtest?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user=nacos
db.password=nacos
```

#### 运行 Nacos 容器

使用以下命令运行 Nacos 容器，并指定 MySQL 配置。

```
docker run -d \
  --name nacos \
  -e MODE=standalone \
  -e SPRING_DATASOURCE_PLATFORM=mysql \
  -e MYSQL_SERVICE_HOST=127.0.0.1 \
  -e MYSQL_SERVICE_PORT=3306 \
  -e MYSQL_SERVICE_DB_NAME=nacos_devtest \
  -e MYSQL_SERVICE_USER=nacos \
  -e MYSQL_SERVICE_PASSWORD=nacos \
  -p 8848:8848 \
  nacos/nacos-server
```

### 验证安装

通过浏览器访问 Nacos 控制台，确认 Nacos 是否正常运行。

```
http://<服务器IP>:8848/nacos
```

### 总结

通过以上步骤，你可以在 Docker 中成功安装和运行 Nacos。如果你需要更多的配置选项，可以参考 Nacos 官方文档和 Docker 官方文档。

~~~
docker cp nacos:/home/nacos/conf /root/docker/cloud/nacos/
docker cp nacos:/home/nacos/logs /root/docker/cloud/nacos/
docker cp nacos:/home/nacos/bin /root/docker/cloud/nacos/
docker cp nacos:/home/nacos/data /root/docker/cloud/nacos/

~~~
