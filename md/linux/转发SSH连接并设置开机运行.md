---
title: "转发SSH连接并设置开机运行"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-10-15 19:45:23# #lastmod/2024-10-15 19:45:23#

---

# 转发SSH连接并设置开机运行

## 建立反向SSH隧道

确保云服务器的防火墙允许外部访问端口

~~~bash
ssh -R 0.0.0.0:云服务器端口:localhost:22 username@云服务器ip
~~~

## 修改云服务器的SSH配置

1. **编辑SSH守护进程配置文件：**

   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
2. **找到 **​**​`GatewayPorts`​**​ ** 设置：**

   ```bash
   #GatewayPorts no
   ```
3. **修改为允许所有接口绑定：**

   ```bash
   GatewayPorts yes
   ```
4. 重新启动SSH守护进程

   ~~~bash
   sudo systemctl restart sshd
   ~~~

## 保持隧道的持久性

### 安装 `autossh`

~~~bash
sudo apt update
sudo apt install autossh
~~~

### 使用 `autossh` 建立隧道：

~~~bash
autossh -M 0 -N -R 0.0.0.0:云服务器端口:localhost:22 username@云服务器ip
~~~

解释：

- `-M 0`：禁用监控端口。
- `-f`：后台运行。
- `-N`：不执行远程命令，只进行端口转发。
- `-R 0.0.0.0:云服务器端口:localhost:22`：反向端口转发，绑定到所有接口。

##　验证端口转发

在 **云服务器本身** 上：

~~~bash
ssh -p 云服务器端口 localhost
~~~

在 **其他服务器** 上

~~~bash
ssh -p 云服务器端口 username@云服务器ip
~~~

## 设置开机自启的 `autossh` 服务

为了确保反向SSH隧道在系统重启后自动建立，可以创建一个 `systemd` 服务来管理 `autossh`。

1. **创建 **​**​`systemd`​**​ ** 服务文件：**

   ```
   sudo nano /etc/systemd/system/autossh-tunnel.service
   ```
2. **添加以下内容（根据你的实际情况修改）：**

   ```ini
   [Unit]
   Description=AutoSSH Tunnel Service
   After=network.target

   [Service]
   Environment="AUTOSSH_GATETIME=0"
   ExecStart=/usr/bin/autossh -M 0 -N -R 0.0.0.0:云服务器端口:localhost:22 username@云服务器ip
   Restart=always
   User=your-local-username
   # 如果需要，可以添加以下行以避免在系统启动时延迟
   # StartLimitInterval=0

   [Install]
   WantedBy=multi-user.target
   ```
   **注意：**

   - 替换 `your-local-username` 为运行 `autossh` 的本地用户。
   - 确保本地用户有权限执行 `ssh` 命令。
3. **重新加载 **​**​`systemd`​**​ ** 配置：**

   ```
   sudo systemctl daemon-reload
   ```
4. **启用并启动 **​**​`autossh`​**​ ** 服务：**

   ```
   sudo systemctl enable autossh-tunnel.service
   sudo systemctl start autossh-tunnel.service
   ```
5. **检查服务状态：**

   ```
   sudo systemctl status autossh-tunnel.service
   ```
   确认服务正在运行且没有错误。
