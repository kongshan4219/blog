---
title: "Debian 使用 TinyProxy 创建代理"
date: 2026-06-04
tags: ["linux"]
---

本文档详细记录在 Debian 系统中搭建、配置 TinyProxy 代理的完整流程，包括基础搭建、访问控制、密码认证及本地使用方法。

## 一、TinyProxy 简介

TinyProxy 是一款轻量级 HTTP/HTTPS 代理服务器，特点是体积小、配置简单，适合快速搭建轻量级代理服务，支持访问控制、密码认证等基础功能。

## 二、安装 TinyProxy

1. 更新系统软件包索引：

   ```bash
   sudo apt update
   ```
2. 安装 TinyProxy：

   ```bash
   sudo apt install tinyproxy -y
   ```

## 三、核心配置（/etc/tinyproxy/tinyproxy.conf）

TinyProxy 主配置文件路径为 `/etc/tinyproxy/tinyproxy.conf`，通过编辑该文件实现自定义配置。编辑命令：

```bash
sudo nano /etc/tinyproxy/tinyproxy.conf
```

### 3.1 基础配置

|配置项|说明|示例配置|
| --------| ----------------------------------------------| ------------|
|**Port**|代理监听端口，默认 8888，可自定义（如 9999）|​`Port 9999`|
|**Timeout**|连接超时时间（秒），默认 600|​`Timeout 600`|
|**MaxClients**|最大并发连接数，默认 100|​`MaxClients 100`|
|**LogFile**|日志文件路径，记录代理运行日志|​`LogFile "/var/log/tinyproxy/tinyproxy.log"`|
|**User/Group**|代理进程运行的用户/组，默认 tinyproxy|​`User tinyproxy` <br /> `Group tinyproxy`|

### 3.2 访问控制配置（Allow）

通过 `Allow` 配置允许访问代理的 IP/网段，未配置时默认拒绝所有外部访问。

- 允许所有 IP 访问（测试场景可用，生产环境不推荐）：

  ```conf
  Allow 0.0.0.0/0  # IPv4 所有地址
  Allow ::1        # IPv6 本地地址
  ```
- 仅允许指定网段（如局域网 192.168.1.0/24）：

  ```conf
  Allow 192.168.1.0/24
  ```

### 3.3 密码认证配置（Basic Auth）

启用 HTTP 基础认证，限制未授权用户访问，需手动启用 `BasicAuth` 配置。

1. 在配置文件中添加（或取消注释）以下内容，格式为 `BasicAuth 用户名 密码`：

   ```conf
   # 单用户示例
   BasicAuth proxyuser proxypass123
   # 多用户示例（一行一个）
   # BasicAuth alice alice123
   # BasicAuth bob bob456
   ```
2. **注意**：密码在配置文件中明文存储，传输时通过 Base64 编码，适合内部信任网络，公网场景建议搭配 HTTPS 加密。

### 3.4 HTTPS 代理支持

TinyProxy 默认支持 HTTPS 代理，需确保 `ConnectPort` 配置未被注释（用于处理 HTTPS 的 CONNECT 方法）：

```conf
ConnectPort 443  # HTTPS 标准端口
ConnectPort 563  # 新闻组 SSL 端口
```

## 四、服务管理

配置修改后需重启服务生效，常用命令如下：

|操作|命令|
| --------------| ------|
|重启服务|​`service tinyproxy restart`|
|启动服务|​`service tinyproxy start`|
|停止服务|​`service tinyproxy stop`|
|查看监听端口|​`netstat -tulpn`|

## 五、防火墙配置

若 Debian 启用 UFW 防火墙，需开放代理端口（以 9999 为例）：

```bash
# 允许 9999 端口 TCP 访问
sudo ufw allow 9999/tcp
# 查看防火墙状态
sudo ufw status
```

## 六、本地主机使用代理

本地设备需与代理服务器网络互通，根据使用场景选择对应配置方式。

### 6.1 浏览器使用（Chrome/Edge 为例）

1. 进入浏览器代理设置：

   - Chrome：地址栏输入 `chrome://settings/proxy`
   - Edge：地址栏输入 `edge://settings/proxy`
2. 点击「打开计算机的代理设置」，跳转到系统代理配置：

#### Windows 系统

- 启用「手动设置代理」，填写：

  - 地址：代理服务器 IP（公网/局域网 IP）
  - 端口：配置的代理端口（如 9999）
- 保存后，首次访问网站会弹出认证窗口，输入 `BasicAuth` 配置的用户名和密码。

#### macOS 系统

- 系统设置 → 网络 → 选中当前网络 → 详细信息 → 代理
- 勾选「Web 代理（HTTP）」和「安全 Web 代理（HTTPS）」
- 填写代理服务器 IP 和端口，保存后输入认证信息。

#### Linux 系统（GNOME 桌面）

- 设置 → 网络 → 网络代理 → 选择「手动」
- 填写 HTTP/HTTPS 代理的 IP 和端口，应用系统范围。

### 6.2 命令行工具使用

#### 临时生效（当前终端会话）

设置环境变量指定代理（含认证信息）：

```bash
# 格式：http://用户名:密码@服务器IP:端口
export http_proxy="http://proxyuser:proxypass123@服务器IP:9999"
export https_proxy="http://proxyuser:proxypass123@服务器IP:9999"
```

- 测试是否生效：

  ```bash
  curl http://icanhazip.com  # 返回代理服务器 IP 即生效
  ```
- 取消代理：

  ```bash
  unset http_proxy https_proxy
  ```

#### 永久配置（特定工具）

- **wget**：编辑 `~/.wgetrc`，添加：

  ```bash
  http_proxy = http://proxyuser:proxypass123@服务器IP:9999/
  https_proxy = http://proxyuser:proxypass123@服务器IP:9999/
  ```
- **apt**：临时使用代理更新软件包：

  ```bash
  sudo http_proxy="http://proxyuser:proxypass123@服务器IP:9999" apt update
  ```

## 七、常见问题排查

1. **代理无法连接**

   - 检查服务状态：`sudo systemctl status tinyproxy`​，确保显示 `active (running)`。
   - 验证端口监听：`netstat -tulpn | grep 9999`，确认端口正常监听。
   - 检查防火墙：`sudo ufw status`，确认代理端口已开放。
   - 查看日志排查：`sudo tail -f /var/log/tinyproxy/tinyproxy.log`。
2. **HTTPS 网站无法访问**

   - 确认配置文件中 `ConnectPort 443` 未被注释，重启服务生效。
3. **认证失败**

   - 检查 `BasicAuth` 配置的用户名和密码是否正确，配置文件中无多余空格。

## 八、注意事项

1. **安全性**：`BasicAuth` 认证不加密，公网环境建议搭配 VPN 或使用更安全的代理协议（如 Squid + HTTPS）。
2. **权限控制**：生产环境避免使用 `Allow 0.0.0.0/0`，仅开放指定 IP/网段，降低被滥用风险。
3. **日志监控**：定期查看代理日志，及时发现异常访问行为。

要不要我帮你整理一份 **TinyProxy 配置文件模板**，包含基础配置、密码认证、访问控制等核心功能，可直接复制使用？
