---
title: "修改DNS重启后失效"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-10-03 23:13:37# #lastmod/2024-10-03 23:13:37#

---

# 修改DNS重启后失效

问题 `/etc/resolv.conf` 文件被 `systemd-resolved` 管理，这会在每次重启时自动覆盖你的修改。为了解决这个问题，可以通过以下几种方法来使你的 DNS 配置永久化：

## 解决方案 1：使用静态的 `/etc/resolv.conf` 文件

1. **取消 **​ **​`/etc/resolv.conf`​**​ ** 的符号链接**： 执行以下命令将当前符号链接删除：

   ```
   sudo unlink /etc/resolv.conf
   ```
2. **创建一个新的静态 **​ **​`/etc/resolv.conf`​**​ ** 文件**： 然后手动创建一个静态的 `resolv.conf` 文件，内容可以按照你的需要配置 DNS 服务器：

   ```
   sudo nano /etc/resolv.conf
   ```

   添加你需要的 DNS 服务器，例如：

   ```
   nameserver 8.8.8.8
   nameserver 8.8.4.4
   ```
3. **防止文件被修改**： 为了防止系统再次覆盖这个文件，可以将它设置为只读：

   ```
   sudo chattr +i /etc/resolv.conf
   ```

   这将使得 `/etc/resolv.conf` 文件变为不可修改状态，除非你手动取消该属性（使用 `chattr -i`）。

## 解决方案 2：配置 `systemd-resolved` 的 DNS 服务器

如果你想继续使用 `systemd-resolved` 进行 DNS 解析，但希望自定义 DNS 服务器，可以通过以下步骤：

1. **编辑 **​**​`resolved.conf`​**​ ** 文件**： 打开 `/etc/systemd/resolved.conf` 文件：

   ```
   sudo nano /etc/systemd/resolved.conf
   ```
2. **修改 DNS 配置**： 找到 `DNS=` 行，取消注释并填写你想使用的 DNS 服务器。例如：

   ```
   [Resolve]
   DNS=8.8.8.8 8.8.4.4
   ```
3. **重启 **​**​`systemd-resolved`​**​ ** 服务**： 保存文件后，重启 `systemd-resolved` 服务使更改生效：

   ```
   sudo systemctl restart systemd-resolved
   ```
4. **检查当前 DNS 配置**： 你可以使用以下命令检查当前 DNS 配置：

   ```
   resolvectl status
   ```

## 解决方案 3：使用 NetworkManager 管理 DNS（如果适用）

如果你的系统使用 NetworkManager 进行网络管理，你可以通过 NetworkManager 配置 DNS 服务器。

1. **编辑 NetworkManager 配置**： 打开 NetworkManager 的网络配置文件，通常位于 `/etc/NetworkManager/NetworkManager.conf`，或者你可以通过 GUI 工具配置 DNS。
2. **配置 DNS**： 在配置文件中，加入以下内容：

   ```
   [main]
   dns=none
   ```

   然后手动编辑 `/etc/resolv.conf` 文件，加入你想要的 DNS。
3. **重启 NetworkManager 服务**： 执行以下命令来重启 NetworkManager 服务：

   ```
   sudo systemctl restart NetworkManager
   ```

通过以上方法，你可以使 `/etc/resolv.conf` 的 DNS 配置持久化。

---

## 公共DNS服务器地址

- 腾讯

  119.29.29.29
- 阿里

  首选： 223.5.5.5 备用： 223.6.6.6
- 114

  首选： 114.114.114.114 备选： 114.114.115.115
