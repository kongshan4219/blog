---
title: "docker-compose快速部署服务器"
date: 2026-06-04
tags: ["linux"]
---

#date/2025-02-23 23:05:07# #lastmod/2025-02-23 23:05:07#

---

# docker-compose快速部署服务器

## 主服务器

`docker-compose-server1.yml`

~~~yaml
version: '3.8'

networks:
  kongshan:
    driver: bridge

services:
  mysql:
    image: mysql:8.0.28
    container_name: mysql_8_0_28
    networks:
      - kongshan
    volumes:
      - /opt/docker_data/mysql/8.0.28/data:/var/lib/mysql
      - /opt/docker_data/mysql/8.0.28/config/my.cnf:/etc/mysql/my.cnf
    ports:
      - "3306:3306"
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: G5s-T3y2h!QpL@8vN4d  # 需修改为实际密码

  redis:
    image: redis:6.2.14
    container_name: redis_6_2_14
    networks:
      - kongshan
    volumes:
      - /opt/docker_data/redis/6.2.14/data:/data
      - /opt/docker_data/redis/6.2.14/redis.conf:/usr/local/etc/redis/redis.conf
    ports:
      - "6379:6379"
    restart: always
    command: redis-server /usr/local/etc/redis/redis.conf

  nacos:
    image: nacos/nacos-server:v2.2.3
    container_name: nacos_2_2_3
    networks:
      - kongshan
    environment:
      MODE: standalone
    volumes:
      - /opt/docker_data/nacos/2.2.3:/home/nacos
    ports:
      - "8848:8848"
      - "9848:9848"
    restart: always

  elasticsearch:
    image: elasticsearch:8.12.1
    container_name: elasticsearch_8_12_1
    networks:
      - kongshan
    environment:
      discovery.type: single-node
    volumes:
      - /opt/docker_data/elasticsearch/8.12.1:/usr/share/elasticsearch
    ports:
      - "9200:9200"
      - "9300:9300"
    restart: always

  alist:
    image: xhofe/alist:latest
    container_name: alist
    networks:
      - kongshan
    volumes:
      - /opt/docker_data/alist:/opt/alist/data
      - /opt/docker_data/alist-md:/opt/alist/md
    environment:
      PUID: 0
      PGID: 0
      UMASK: "022"
      TZ: Asia/Shanghai
    ports:
      - "5244:5244"
    restart: always

  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    networks:
      - kongshan
    environment:
      SIGNUPS_ALLOWED: "false"
      INVITATIONS_ALLOWED: "false"
      ADMIN_TOKEN: your_admin_token  # 需修改为实际token
      LOG_FILE: /data/vaultwarden.log
      ROCKET_PORT: 8080
    volumes:
      - /opt/docker_data/vaultwarden:/data
    ports:
      - "8080:8080"
    restart: always
~~~

## 副服务器

`docker-compose-server2.yml`

~~~yaml
version: '3.8'

services:
  registry:
    image: registry:2
    container_name: registry
    volumes:
      - /opt/docker_data/registry:/var/lib/registry
    environment:
      REGISTRY_PROXY_REMOTEURL: https://registry-1.docker.io
    ports:
      - "5000:5000"
    restart: always
~~~

## 本地执行shell脚本

`deploy_volumes.sh`

~~~shell
#!/bin/bash
set -e  # 遇到错误立即退出

# 配置目标服务器信息
SERVER1="root@192.168.1.8"  # 修改为实际服务器1的SSH地址
SERVER2="root@192.168.1.7"  # 修改为实际服务器2的SSH地址
LOCKFILE="/tmp/rsync.lock"

# 创建目录结构
echo "正在创建服务器目录结构..."
ssh $SERVER1 "mkdir -p /opt/docker_data/{alist,alist-md,elasticsearch/8.12.1,redis/6.2.14,mysql/8.0.28,nacos/2.2.3,vaultwarden}"
ssh $SERVER2 "mkdir -p /opt/docker_data/registry"

# 同步数据卷
echo "开始同步数据卷..."
flock -n -E 1 $LOCKFILE -c "
rsync -avzP --delete /opt/docker_data/alist $SERVER1:/opt/docker_data/ &&
rsync -avzP --delete /opt/docker_data/alist-md $SERVER1:/opt/docker_data/ &&
rsync -avzP --delete /opt/docker_data/elasticsearch/8.12.1 $SERVER1:/opt/docker_data/elasticsearch/ &&
rsync -avzP --delete /opt/docker_data/redis/6.2.14 $SERVER1:/opt/docker_data/redis/ &&
rsync -avzP --delete /opt/docker_data/mysql/8.0.28 $SERVER1:/opt/docker_data/mysql/ &&
rsync -avzP --delete /opt/docker_data/nacos/2.2.3 $SERVER1:/opt/docker_data/nacos/ &&
rsync -avzP --delete /opt/docker_data/vaultwarden $SERVER1:/opt/docker_data/ &&
rsync -avzP --delete /opt/docker_data/registry $SERVER2:/opt/docker_data/
"

# 上传 compose 文件
echo "上传 Docker Compose 配置文件..."
scp docker-compose-server1.yml $SERVER1:/opt/docker_data/docker-compose.yml
scp docker-compose-server2.yml $SERVER2:/opt/docker_data/docker-compose.yml

# 启动容器
echo "在服务器1上启动容器..."
ssh $SERVER1 "cd /opt/docker_data && docker-compose up -d --remove-orphans"

echo "在服务器2上启动容器..."
ssh $SERVER2 "cd /opt/docker_data && docker-compose up -d --remove-orphans"

echo "所有服务已成功部署！"
~~~
