---
title: "linux 创建服务"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-14# #lastmod/2024-09-14#

---

在 Linux 系统中，你可以将一个应用程序或脚本配置为系统服务，以便在系统启动时自动启动，并在需要时手动启动、停止或重启。通常，服务配置文件位于 `/etc/systemd/system/` 目录下，使用 `systemd` 管理服务。

以下是创建和配置系统服务的步骤：

### 1. 创建服务文件

在 `/etc/systemd/system/` 目录下创建一个新的服务文件，例如 `myapp.service`：

```
sudo nano /etc/systemd/system/myapp.service
```

### 2. 编写服务文件

在服务文件中定义服务的配置。以下是一个示例服务文件的内容：

```
[Unit]
Description=My Custom Application
After=network.target

[Service]
ExecStart=/path/to/myapp/start.sh
ExecStop=/path/to/myapp/stop.sh
Restart=on-failure
User=myuser
Group=mygroup
WorkingDirectory=/path/to/myapp

[Install]
WantedBy=multi-user.target
```

#### 解释

- **[Unit]** ：定义服务的元数据和依赖关系。
  - `Description`：服务的描述。
  - `After`：指定服务在哪些目标之后启动，例如 `network.target` 表示在网络启动后启动。
- **[Service]** ：定义服务的执行行为。
  - `ExecStart`：指定启动服务的命令。
  - `ExecStop`：指定停止服务的命令。
  - `Restart`：指定服务在失败时是否重启，例如 `on-failure` 表示在失败时重启。
  - `User`：指定运行服务的用户。
  - `Group`：指定运行服务的用户组。
  - `WorkingDirectory`：指定服务的工作目录。
- **[Install]** ：定义服务的安装行为。
  - `WantedBy`：指定服务的目标，例如 `multi-user.target` 表示在多用户模式下启动。

### 3. 重新加载 systemd

在修改服务文件后，需要重新加载 `systemd` 配置：

```
sudo systemctl daemon-reload
```

### 4. 启动服务

启动服务：

```
sudo systemctl start myapp.service
```

### 5. 查看服务状态

查看服务状态：

```
sudo systemctl status myapp.service
```

### 6. 设置服务开机自启

设置服务在系统启动时自动启动：

```
sudo systemctl enable myapp.service
```

### 7. 停止服务

停止服务：

```
sudo systemctl stop myapp.service
```

### 8. 重启服务

重启服务：

```
sudo systemctl restart myapp.service
```

### 9. 禁用服务开机自启

禁用服务在系统启动时自动启动：

```
sudo systemctl disable myapp.service
```

### 总结

通过以上步骤，你可以将一个应用程序或脚本配置为系统服务，并使用 `systemd` 进行管理。服务文件的配置可以根据具体需求进行调整，例如指定启动命令、用户、工作目录等。通过 `systemctl` 命令，你可以启动、停止、重启服务，并设置服务在系统启动时自动启动。

---

在 Linux 系统中，删除一个服务通常涉及以下几个步骤：停止服务、禁用服务开机自启、删除服务文件。以下是具体步骤：

### 1. 停止服务

首先，停止正在运行的服务：

```
sudo systemctl stop myapp.service
```

### 2. 禁用服务开机自启

禁用服务在系统启动时自动启动：

```
sudo systemctl disable myapp.service
```

### 3. 删除服务文件

删除服务文件，通常位于 `/etc/systemd/system/` 目录下：

```
sudo rm /etc/systemd/system/myapp.service
```

### 4. 重新加载 systemd

在删除服务文件后，需要重新加载 `systemd` 配置：

```
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

### 5. 确认服务已删除

确认服务已删除，可以使用以下命令查看所有服务：

```
systemctl list-units --type=service
```

或者查看特定服务的状态：

```
systemctl status myapp.service
```

如果服务已成功删除，`systemctl status myapp.service` 将返回类似以下的错误信息：

```
Unit myapp.service could not be found.
```

### 总结

通过以上步骤，你可以成功删除一个系统服务。具体步骤包括停止服务、禁用服务开机自启、删除服务文件，并重新加载 `systemd` 配置。确认服务已删除后，服务将不再在系统启动时自动启动，也不会在 `systemctl` 命令中显示。
