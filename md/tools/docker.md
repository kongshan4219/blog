---
title: "docker"
date: 2026-06-04
tags: ["tools"]
---

#date/2020-01-01# #lastmod/2020-01-01#

```
把tar包打成镜像
docker load -i 文件名

所有项目停止 
docker rm -f

删除镜像 
docker rmi 文件名:版本

强制关闭 
docker rm -f 名字 强制关闭
```

将镜像打包为 tar 文件

~~~
docker save -o ncmctl.tar chaunsin/ncmctl:latest
~~~

~~~
docker save -o syncclipboard-server.tar jericx/syncclipboard-server:latest
docker load -i syncclipboard-server.tar
~~~
