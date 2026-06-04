---
title: "Homepage导航站"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-25# #lastmod/2024-09-25#

---

### 创建挂载目录

~~~
mkdir -p /opt/docker_data/homepage
~~~

### 运行 docker 容器

我使用的是 root 用户，PUID 和 PGID 都是 0。

如果使用其他用户可以在终端输入 `id` 命令查看当前用户的 PUID 和 PGID

~~~bash
docker run -d --name homepage \
  -e PUID=0 \
  -e PGID=0 \
  -p 3000:3000 \
  -v /opt/docker_data/homepage:/app/config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --restart unless-stopped \
  ghcr.io/gethomepage/homepage:latest
~~~
