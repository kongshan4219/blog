---
title: "centos配置无密码登录ssh"
date: 2026-06-04
tags: ["linux"]
---

​#date/2020-01-01#​ #lastmod/2020-01-01#

## 生成 SSH 密钥

使用 SSH 工具生成 SSH 密钥对。在本地主机上执行以下命令：

```
ssh-keygen -t rsa -b 4096
```

-  **​`-t rsa`​** 指定使用 RSA 算法。
-  **​`-b 4096`​** 指定密钥的位数为 4096。

当提示输入文件保存路径时，按回车使用默认路径（通常是 `~/.ssh/id_rsa`）。之后会提示输入密码短语，如果希望无密码登录，直接回车跳过密码短语的设置。

## 将公钥复制到远程主机

生成密钥对后，将公钥复制到远程主机。使用以下命令：

```
ssh-copy-id [username]@[主机地址]
```

该命令会自动将生成的公钥添加到远程主机的 `~/.ssh/authorized_keys` 文件中。

## 测试无密码登录

完成公钥复制后，测试本地主机无密码登录远程主机ssh：

```
ssh [username]@[主机地址]
```

如果配置正确，应该能够直接登录到远程主机而无需输入密码。

## 多个远程主机可以共用同一个 SSH 密钥对

参考**步骤2**，将公钥复制到多个远程主机，完成复制后测试连接

## 简化多个主机的连接

在本地配置 `~/.ssh/config` 文件，将多个 `serv00` 主机的配置信息集中管理。

例如：

```
Host serv00-1
    HostName serv00_host1
    User user

Host serv00-2
    HostName serv00_host2
    User user

Host serv00-3
    HostName serv00_host3
    User user
```

这样你可以直接使用简化命令来连接主机：

```
ssh serv00-1
ssh serv00-2
ssh serv00-3
```

为每个注解指定私钥

~~~
Host serv00-1
    HostName ip
    User username
    IdentityFile ~/.ssh/id_rsa_svr # 秘钥文件路径
~~~

---

## 补充

不出意外应该是可以正常的无密码登录了

如果无密码登录无法正常工作，可以检查远程主机上的 SSH 配置文件，确保 `sshd_config` 中包含以下内容：

```
PasswordAuthentication no
PubkeyAuthentication yes
```

没有的话需要编辑文件 `/etc/ssh/sshd_config` 并确保这些选项启用，然后重启 SSH 服务：

```
sudo systemctl restart sshd
```

这样就完成了无密码的 SSH 登录配置。

---

要使用本机生成一个无密码的 SSH 密钥对，并将其用于连接 `ip`，可以按照以下步骤操作：

### 1. 生成 SSH 密钥对（无密码）

在本机上运行以下命令以生成一个新的 SSH 密钥对，不设置密码：

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

当系统提示你输入文件保存路径时，按 `Enter` 键以使用默认路径（通常是 `/root/.ssh/id_rsa`）。然后，当系统提示你输入密码时，直接按 `Enter` 键两次（密码为空）。

### 2. 将公钥添加到云服务器

要将生成的公钥添加到云服务器 `ip`，请按照以下步骤操作：

#### 2.1. 查看公钥内容

运行以下命令以查看公钥内容：

```
cat ~/.ssh/id_rsa.pub
```

#### 2.2. 将公钥复制到云服务器

1. 使用 SSH 连接到云服务器（如果你尚未设置公钥，可以使用密码连接）：

   ```
   ssh username@ip
   ```

   替换 `username` 为服务器的用户名。
2. 在服务器上，编辑 `~/.ssh/authorized_keys` 文件（如果文件不存在，则创建它）：

   ```
   nano ~/.ssh/authorized_keys
   ```
3. 将本机的公钥内容复制并粘贴到 `authorized_keys` 文件中。保存并退出编辑器。
4. 确保 `~/.ssh` 目录和 `authorized_keys` 文件的权限设置正确：

   ```
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```
5. 退出云服务器的 SSH 连接：

   ```
   exit
   ```

### 3. 使用 SSH 密钥连接到云服务器

在本机上使用生成的私钥文件连接到云服务器：

```
ssh -i ~/.ssh/id_rsa username@ip
```

替换 `username` 为你的云服务器用户名。

这样，你就可以使用 SSH 密钥对进行无密码的连接。如果有任何问题，随时告诉我！
