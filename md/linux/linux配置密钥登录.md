---
title: "linux配置密钥登录"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-23# #lastmod/2024-09-23#

---

### 生成 SSH 密钥对

生成一个新的 SSH 密钥对，不设置密码：

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

当系统提示你输入文件保存路径时，按 `Enter` 键以使用默认路径（通常是 `/root/.ssh/id_rsa`）。然后，当系统提示你输入密码时，直接按 `Enter` 键两次（密码为空）。

### 配置密钥对

`/root/.ssh` 目录下应该会有密钥文件 `id_rsa` 和公钥文件 `id_rsa.pub`

密钥需要存放在 `连接的机器上`, 公钥需要将其内容写入 `被连接的机器` 的 `/root/.ssh/authorized_keys` 文件中

### 使用密钥连接

~~~
ssh -i ~/.ssh/id_rsa username@ip
~~~
