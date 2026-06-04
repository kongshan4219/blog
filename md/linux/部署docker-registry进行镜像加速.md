---
title: "部署docker-registry进行镜像加速"
date: 2026-06-04
tags: ["linux"]
---

#date/2025-02-15 23:12:15# #lastmod/2025-03-13 22:39:28#

---

# 部署docker-registry进行镜像加速

## 部署 registry

~~~bash
docker run -d --name registry --restart always \
    -p 5000:5000 \
    -v /opt/docker_data/registry:/var/lib/registry \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
    registry:2
~~~

`-e REGISTRY_PROXY_REMOTEURL=[https://registry-1.docker.io](https://registry-1.docker.io/)`
为指定上游远程镜像仓库为官方镜像仓库.`

## 通过 ngixn 反向代理配置域名

**推荐为加速镜像仓库服务使用反向代理来配置域名和证书使用.**

## 客户端配置 daemon.json

~~~bash
{
        "dns": [
                "8.8.8.8",
                "114.114.114.114"
        ],
        "ipv6": false,
        "registry-mirrors": [
                "https://docker.kongshan.cc"
        ],
        "max-concurrent-downloads": 1,
        "max-download-attempts": 60000 
}

~~~

`max-download-attempts`设置拉取镜像超时时间，防止拉取多个镜像时数据太多导致超时并失败

配置完成需重载 daemon 并重启 docker

~~~bash
sudo systemctl daemon-reload
sudo systemctl restart docker
~~~
