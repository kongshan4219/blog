---
title: "Samba 服务配置笔记（Linux 目录共享到 Windows）"
date: 2026-06-04
tags: ["linux"]
---

## 一、Samba 简介

- 核心作用：实现 Linux 与 Windows 跨系统文件共享，基于 SMB 协议，Windows 原生兼容（无需额外安装客户端）。
- 优势：支持权限精细化控制、局域网稳定运行、可同时管理多个共享目录。
- 适用场景：局域网长期文件共享、多用户权限隔离访问、跨系统协作办公。

## 二、环境准备

### 1. 系统要求

- Linux 系统：Ubuntu/Debian 或 CentOS/RHEL 系列（需联网）。
- Windows 系统：任意版本（自带 SMB 客户端）。
- 网络条件：Linux 与 Windows 处于同一局域网（同网段，如 192.168.1.x）。

### 2. 依赖安装

#### Ubuntu/Debian 系

```bash
sudo apt update && sudo apt install samba samba-common-bin
```

#### CentOS/RHEL 系

```bash
sudo yum install samba samba-client
```

## 三、基础配置步骤（单共享目录）

### 1. 创建共享目录

```bash
# 示例：创建共享目录 /home/yourname/linux_share（自定义路径）
sudo mkdir -p /home/yourname/linux_share
# 配置目录权限（避免访问报错）
sudo chmod 777 /home/yourname/linux_share
sudo chown -R yourname:yourname /home/yourname/linux_share
```

### 2. 编辑 Samba 配置文件

```bash
sudo nano /etc/samba/smb.conf
```

在文件末尾添加共享规则：

```ini
[LinuxShare]  # Windows 中显示的共享名称（自定义）
    comment = Linux 公共共享目录  # 备注说明（可选）
    path = /home/yourname/linux_share  # 共享目录路径（必填）
    browseable = yes  # 允许 Windows 浏览该共享
    writable = yes  # 允许写入（只读设为 no）
    guest ok = no  # 禁止匿名访问（需账号密码）
    valid users = yourname  # 允许访问的 Linux 用户名
    create mask = 0644  # 新建文件权限（Linux 端）
    directory mask = 0755  # 新建目录权限（Linux 端）
```

#### 简化规则

```ini
[LinuxShare]
	comment = 公共共享目录
	path = /mnt/data
	read only = No
	valid users = root # 允许多个用户访问（用逗号分隔）


[minio1]
	comment = minio1共享目录
	path = /mnt/minio1
	read only = No
	valid users = root # 允许多个用户访问（用逗号分隔）
```

### 3. 添加 Samba 授权用户

Samba 不使用 Linux 系统密码，需单独设置：

```bash
sudo smbpasswd -a yourname  # 替换为 Linux 用户名
# 按提示输入密码（Windows 访问时使用）
```

### 4. 验证配置并重启服务

```bash
# 验证配置无语法错误
testparm

# 重启 Samba 服务
# Ubuntu/Debian
sudo systemctl restart smbd nmbd
# CentOS/RHEL
sudo systemctl restart smb nmb

# 查看服务状态（确认正常运行）
sudo systemctl status smbd nmbd
```

### 5. 开放防火墙端口

```bash
# Ubuntu（ufw 防火墙）
sudo ufw allow 139/tcp && sudo ufw allow 445/tcp && sudo ufw reload

# CentOS（firewalld 防火墙）
sudo firewall-cmd --permanent --add-port=139/tcp --add-port=445/tcp
sudo firewall-cmd --reload
```

## 四、进阶配置：多共享目录（同时部署多个共享）

无需安装多个 Samba 服务，在 `smb.conf` 中添加多个共享规则即可。

### 1. 新增第二个共享目录

```bash
# 示例：创建私人共享目录 /home/yourname/private_share
sudo mkdir -p /home/yourname/private_share
sudo chmod 755 /home/yourname/private_share
sudo chown -R yourname:yourname /home/yourname/private_share
```

### 2. 补充 Samba 配置

在 `smb.conf` 末尾继续添加第二个共享规则：

```ini
# 第二个共享：私人共享目录（仅指定用户访问）
[PrivateShare]
    comment = 私人专属共享（仅自己访问）
    path = /home/yourname/private_share  # 第二个共享目录路径
    browseable = no  # 禁止他人浏览（仅知道名称可访问）
    writable = yes  # 允许写入
    guest ok = no  # 禁止匿名访问
    valid users = yourname  # 仅允许当前用户访问
    create mask = 0600  # 新建文件仅所有者可读可写
    directory mask = 0700  # 新建目录仅所有者可访问
```

### 3. 生效配置

```bash
testparm  # 验证配置
sudo systemctl restart smbd nmbd  # 重启服务
```

## 五、Windows 端访问方法

### 1. 获取 Linux 局域网 IP

在 Linux 终端执行：

```bash
ip addr  # 或 ifconfig
```

找到局域网 IP（如 192.168.1.100）。

### 2. 访问共享目录

#### 方法 1：直接访问

按 `Win + R`​，输入 `\\LinuxIP\共享名称`，示例：

- 公共共享：`\\192.168.1.100\LinuxShare`
- 私人共享：`\\192.168.1.100\PrivateShare`

输入 Samba 用户名和密码，即可访问。

#### 方法 2：映射网络驱动器（开机自动挂载）

1. 打开 Windows 文件资源管理器，点击「此电脑」→「映射网络驱动器」。
2. 选择未使用的盘符（如 Z:），文件夹输入 `\\192.168.1.100\LinuxShare`。
3. 勾选「登录时重新连接」，点击「完成」，输入账号密码即可。

## 六、常见问题排查

### 1. 挂载失败：找不到网络路径

- 检查 Linux 与 Windows 是否同网段，关闭双方防火墙。
- 验证 Samba 服务是否正常运行（`systemctl status smbd nmbd`）。

### 2. 访问时提示权限不足

- 确认 Linux 共享目录权限正确（`ls -ld 目录路径`）。
- 检查 Samba 配置中 `valid users`​ 包含当前用户，`writable = yes`。

### 3. 无法添加 root 用户到 Samba

执行以下命令启用 root 访问：

```bash
sudo smbpasswd -e root
```

### 4. Windows 重启后挂载消失

- 映射时勾选「登录时重新连接」。
- 创建批处理脚本（.bat）放入开机启动项，内容：

  ```bash
  net use Z: \\192.168.1.100\LinuxShare /persistent:yes
  ```

## 七、关键配置参数说明

|参数|作用|可选值|
| ------| ----------------------------------| ----------------|
|​`[共享名称]`|Windows 中显示的共享标识|自定义（唯一）|
|​`path`|Linux 端共享目录路径|绝对路径|
|​`browseable`|是否允许 Windows 浏览该共享|yes/no|
|​`writable`|是否允许写入文件|yes/no|
|​`guest ok`|是否允许匿名访问|yes/no|
|​`valid users`|允许访问的用户（多个用逗号分隔）|系统用户名|
|​`create mask`|新建文件的 Linux 权限|0644/0600 等|
|​`directory mask`|新建目录的 Linux 权限|0755/0700 等|
