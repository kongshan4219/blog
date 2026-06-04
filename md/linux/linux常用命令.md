---
title: "linux常用命令"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-05 20:51:56# #lastmod/2024-09-05 20:51:56#

## 查看端口的使用情况

```
ss -tuln
```

```
netstat -tulnp
```

## systemd 命令相关

### **重新加载 **​**​`systemd`​**​ ** 配置**：

```
sudo systemctl daemon-reload
```

### 启动

```
sudo systemctl start frps
```

### 设置为开机自启

```
sudo systemctl enable frps
```

### 检查服务状态

```
sudo systemctl status frps
```

## 定时任务相关

### **编辑用户的定时任务：**

```
crontab -e
```

此命令会打开当前用户的 `crontab` 文件，你可以在其中添加或编辑定时任务。

### **查看当前用户的定时任务：**

```
crontab -l
```

此命令会列出当前用户的所有定时任务。

### **删除当前用户的定时任务：**

```
crontab -r
```

此命令会删除当前用户的所有定时任务。

### **编辑指定用户的定时任务：**

```
crontab -u username -e
```

使用 `-u` 选项可以编辑指定用户的 `crontab` 文件（需要 root 权限）。

### **查看指定用户的定时任务：**

```
crontab -u username -l
```

查看指定用户的 `crontab` 内容。

### **系统级定时任务文件：**

- `/etc/crontab`：系统级别的定时任务，通常由系统管理员编辑。
- `/etc/cron.d/` 目录：可以在此目录下创建新的文件来定义定时任务。
- `/etc/cron.hourly/`、`/etc/cron.daily/`、`/etc/cron.weekly/`、`/etc/cron.monthly/`：分别对应每小时、每日、每周、每月执行的任务。

### 7. **重启或重新加载 **​**​`cron`​**​ ** 服务：**

当你修改了 `/etc/crontab` 或 `/etc/cron.d/` 中的文件时，需要重启 `cron` 服务以应用更改。

```
sudo systemctl restart cron
```

~~~bash
sudo systemctl restart crond
~~~

或重新加载配置而不重启服务：

```
sudo systemctl reload cron
```

### **​`crontab`​**​ ** 格式：**

`crontab` 文件中的每一行定义一个定时任务，其格式如下：

```
* * * * * command
```

每个字段的含义为：

- 第 1 列：分钟（0-59）
- 第 2 列：小时（0-23）
- 第 3 列：日期（1-31）
- 第 4 列：月份（1-12）
- 第 5 列：星期（0-7，0 和 7 都表示星期日）
- `command`：要执行的命令

例如，设置每天凌晨 2 点执行备份脚本：

```
0 2 * * * /path/to/backup.sh
```

### **查看 **​**​`cron`​**​ ** 日志：**

定时任务的执行情况可以在系统日志中查看：

```
tail -f /var/log/cron
```

### 补充

在某些 Linux 发行版中，`cron` 服务可能使用的是 `crond` 而不是 `cron`。如果在 `systemctl` 中找不到 `cron.service`，可以尝试重启 `crond` 服务。

```
sudo systemctl restart crond
```

检查 `crond` 服务的状态：

```
sudo systemctl status crond
```

如果 `crond` 服务没有安装，可以通过以下命令安装（以 Red Hat/CentOS 为例）：

```
sudo yum install cronie
sudo systemctl enable crond
sudo systemctl start crond
```

执行这些命令后，再尝试重启 `crond` 服务，确保你的定时任务能够正常运行。

## 赋予执行权限

赋予脚本执行权限：

```
chmod +x frpc.sh
```
