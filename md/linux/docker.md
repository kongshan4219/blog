---
title: "docker"
date: 2026-06-04
tags: ["linux"]
---

#date/2025-03-10 12:28:56# #lastmod/2025-03-10 12:28:56#

---

# docker

## 将多个镜像源添加到 Docker 配置

要将多个镜像源添加到 Docker 配置中，可以在 `daemon.json` 文件中配置多个镜像源。

### **编辑 Docker 配置文件**： 创建或编辑 `/etc/docker/daemon.json` 文件：

```
sudo vi /etc/docker/daemon.json
```

### **配置 Docker 使用多个镜像源**： 在 `daemon.json` 文件中添加或修改以下内容：

```
{
  "registry-mirrors": [
    "https://hub.atomgit.com/"
  ]
}
```

### 重新启动 Docker 服务  **： 保存文件后，重新启动 Docker 服务以应用更改：**

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### **验证配置**： 运行以下命令来验证新的镜像源是否生效：

```
docker info
```

在输出信息中查找 `Registry Mirrors` 部分，确保显示 `https://hub.atomgit.com/` 和 `https://0vsv80z0.mirror.aliyuncs.com`。

### 完成这些步骤后，Docker 将使用多个镜像源。然后可以再次尝试构建镜像：

```
docker build -t qmsgredis -f qmsg-redis-Dockerfile .
```

这样配置后，Docker 将从多个镜像源拉取镜像，加快下载速度并提高可靠性。
