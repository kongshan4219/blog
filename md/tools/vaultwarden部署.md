---
title: "vaultwarden部署"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-16# #lastmod/2024-09-16#

---

vaultwarden 是 bitwarden 第三方服务端，相较官方服务端更加轻量。

docker 部署

~~~
docker pull vaultwarden/server:latest
docker run -d --name vaultwarden -v /vw-data/:/data/ --restart unless-stopped -p 10080:80 vaultwarden/server:latest
~~~

关闭注册

先删除，密码数据和注册用户都保存在挂载目录/vw-data 中，可以随意删除容器重新创建

~~~
docker stop vaultwarden
docker rm vaultwarden
~~~

添加禁止注册环境变量

~~~
docker run -d \
  --name vaultwarden \
  -v /vw-data/:/data/ \
  --restart unless-stopped \
  -p 10080:80 \
  -e SIGNUPS_ALLOWED=false \
  vaultwarden/server:latest
~~~
