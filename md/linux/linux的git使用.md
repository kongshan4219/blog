---
title: "linux的git使用"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-05 20:52:04# #lastmod/2024-09-05 20:52:04#

# linux的git使用

**设置全局用户名和邮箱：** （适用于所有 Git 仓库）

```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

将 `Your Name` 替换为你的姓名，`you@example.com` 替换为你的邮箱地址。

**只为当前仓库设置用户名和邮箱：** （只适用于当前仓库）

```
git config user.name "Your Name"
git config user.email "you@example.com"
```

### 配置 Git 保存身份验证信息

为了避免每次推送都需要重新输入用户名和 PAT，可以使用 Git 的凭证缓存特性。

在命令行中运行以下命令以启用凭证缓存：

```
git config --global credential.helper cache
```

或者，可以将凭证保存到磁盘上：

```
git config --global credential.helper store
```

启用后，Git 会在推送时自动使用保存的凭证。
