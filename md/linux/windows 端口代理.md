---
title: "windows 端口代理"
date: 2026-06-04
tags: ["linux"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

### windows 端口代理

#### 添加端口代理

```sql
netsh interface portproxy add v4tov4 listenport=6379 listenaddress=127.0.0.1 connectport=6379 connectaddress=192.168.1.19
```

**listenport**: 本地需要监听的端口
**listenaddress**: 本地监听的ip
**connectport**: 远程连接的端口
**connectaddress**: 远程连接的ip

#### 删除端口代理

```sql
netsh interface portproxy delete v4tov4 listenport=6379 listenaddress=127.0.0.1
```

**listenport**: 本地需要监听的端口
**listenaddress**: 本地监听的ip
