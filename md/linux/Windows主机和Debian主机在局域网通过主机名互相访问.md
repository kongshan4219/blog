---
title: "Windows主机和Debian主机在局域网通过主机名互相访问"
date: 2026-06-04
tags: ["linux"]
---

#date/2025-01-22 17:04:07# #lastmod/2025-01-22 17:04:07#

---

# Windows 主机和 Debian 主机在局域网通过主机名互相访问

以下是针对 **Windows 主机和 Debian 主机通过主机名互相访问** 的完整解决方案：

## **基础网络验证**

### 确保两台主机在同一局域网

- **Windows 主机**：

  ```cmd
  ipconfig
  ```

  查看 IPv4 地址（例如 `192.168.1.2`）。
- **Debian 主机**：

  ```bash
  ip a
  ```

  查看 IPv4 地址（例如 `192.168.1.3`）。

### 通过 IP 地址互相 ping 通

- **Windows → Debian**：

  ```cmd
  ping 192.168.1.3
  ```
- **Debian → Windows**：

  ```bash
  ping 192.168.1.2
  ```

  **如果失败**：检查网络连接、防火墙或路由器设置。

  默认 windows 防火墙是关闭 ping 命令的，需要手动开启

### **配置 Debian 主机的 Samba 和 NetBIOS 解析**

#### 安装 Samba 和 Winbind

```bash
apt update
apt install samba winbind
```

#### 配置 Samba

编辑 `/etc/samba/smb.conf`：

```bash
nano /etc/samba/smb.conf
```

修改 `[global]` 部分如下：

```ini
[global]
   workgroup = WORKGROUP
   netbios name = KONGSHAN
   wins support = yes
   dns proxy = no
```

- `workgroup` 必须与 Windows 主机的工作组一致（默认 `WORKGROUP`）。
- `netbios name` 是 Debian 主机的 NetBIOS 名称（可自定义）。

#### 重启 Samba 和 Winbind 服务

```bash
systemctl restart smbd nmbd winbind
systemctl enable smbd nmbd winbind
```

---

### 开放防火墙端口

~~~bash
ufw allow proto udp from 192.168.1.0/24 to any port 137,138,139
ufw allow proto tcp from 192.168.1.0/24 to any port 445
~~~

### **配置 Debian 主机的名称解析**

#### 修改 `/etc/nsswitch.conf`

```bash
nano /etc/nsswitch.conf
```

确保 `hosts` 行包含 `wins`，注意顺序不能错：

```ini
hosts: files wins dns
```

#### 重启网络服务

```bash
systemctl restart networking
```

---

### **配置 Windows 主机的 NetBIOS**

#### 启用 NetBIOS over TCP/IP

默认的也可以，不用修改

1. 打开 **控制面板 → 网络和共享中心 → 更改适配器设置**。
2. 右键点击当前网络连接 → **属性 → Internet 协议版本 4 (TCP/IPv4)**  → **高级 → WINS** 选项卡。
3. 选择 **启用 NetBIOS over TCP/IP**。

#### 设置主机名和工作组

1. 打开 **控制面板 → 系统 → 更改设置**。
2. 在 **计算机名** 选项卡中，点击 **更改**。
3. 设置计算机名为 `RUBY`，工作组为 `WORKGROUP`。

#### 允许防火墙规则

1. 打开 **控制面板 → 系统和安全 → Windows Defender 防火墙 → 允许应用通过防火墙**。
2. 启用 **文件和打印机共享** 和 **核心网络**、**网络发现(NB-Name-In)** 。

---

### **验证 NetBIOS 解析**

#### 在 Debian 主机上测试

```bash
nmblookup RUBY
```

- 成功输出示例：

  ```
  192.168.1.2 RUBY<00>
  ```
- 失败时检查：

  - Samba 服务是否运行：`systemctl status smbd nmbd`
  - Winbind 是否运行：`systemctl status winbind`
- 如果安装了 vm 虚拟机，则会多出两个 vm 创建的适配器的 ip，此时 ping 命令使用 windows 主机名时会报错，需要禁用 vm 的两个适配器

#### 在 Windows 主机上测试

```cmd
nbtstat -n
```

确保 `RUBY` 出现在 NetBIOS 名称表中。

---

### **最终测试**

#### 从 Debian 主机 ping Windows 主机名

```bash
ping RUBY
```

#### 从 Windows 主机 ping Debian 主机名

```cmd
ping KONGSHAN
```

---

### **故障排除**

#### 常见错误

- **​`ping: RUBY: No address associated with hostname`​**：
  - 检查 `/etc/nsswitch.conf` 是否包含 `wins`。
  - 确保 `winbind` 服务已启动。
- **​`System error`​**：
  - 检查 `/etc/nsswitch.conf` 语法是否正确。
  - 查看日志：`journalctl -xe`。

#### 备用方案（手动映射）

在 Debian 主机的 `/etc/hosts` 中添加：

```bash
192.168.1.2   RUBY
```

在 Windows 主机的 `C:\Windows\System32\drivers\etc\hosts` 中添加：

```
192.168.1.3   KONGSHAN
```

### **总结**

通过上述步骤，两台主机应能通过主机名互相访问。核心操作包括：

1. 配置 Samba 的 WINS 支持。
2. 启用 NetBIOS over TCP/IP（Windows）。
3. 修改 Debian 的 `/etc/nsswitch.conf` 以支持 WINS 解析。
4. 确保防火墙允许相关流量。

如果问题仍存，优先检查 `nmblookup` 和 `nbtstat` 的输出，定位 NetBIOS 解析的故障点。
