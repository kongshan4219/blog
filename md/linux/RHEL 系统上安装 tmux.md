---
title: "在 CentOS/RHEL 系统上安装 tmux"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-05 20:52:09# #lastmod/2024-09-05 20:52:09#

### 在 CentOS/RHEL 系统上安装 tmux

1. **更新包列表**：

   ```
   ```

sudo yum update

```

2. **安装 tmux**：

```

sudo yum install tmux

```

### 在 Ubuntu/Debian 系统上安装 tmux

1. **更新包列表**：

```

sudo apt-get update

```

2. **安装 tmux**：

```

sudo apt-get install tmux

```

### 验证安装

安装完成后，您可以运行以下命令来验证 `tmux` 是否安装成功：

```

tmux -V

```

这将显示 `tmux` 的版本信息，确认安装成功。

### 使用 tmux

安装完成后，您可以运行 `tmux` 命令来启动一个新的 tmux 会话：

```

tmux

```

### 基本命令

1. **启动新的 tmux 会话**：

```

tmux

```

2. **启动新的命名会话**：

```

tmux new -s mysession

```

3. **列出所有会话**：

```

tmux ls

```

4. **附加到现有会话**：

```

tmux attach -t mysession

```

5. **从会话中分离**（在 tmux 会话中按下 `Ctrl+b` 然后按 `d`）：

```

Ctrl+b d

```

6. **终止会话**：

```

tmux kill-session -t mysession

```

### 窗口管理

1. **创建新窗口**（在 tmux 会话中按下 `Ctrl+b` 然后按 `c`）：

```

Ctrl+b c

```

2. **切换到下一个窗口**（在 tmux 会话中按下 `Ctrl+b` 然后按 `n`）：

bash

复制

```

Ctrl+b n

```

3. **切换到上一个窗口**（在 tmux 会话中按下 `Ctrl+b` 然后按 `p`）：

bash

复制

```

Ctrl+b p

```

4. **列出所有窗口**（在 tmux 会话中按下 `Ctrl+b` 然后按 `w`）：

bash

复制

```

Ctrl+b w

```

5. **重命名当前窗口**（在 tmux 会话中按下 `Ctrl+b` 然后按 `,`）：

bash

复制

```

Ctrl+b ,

```

### 面板管理

1. **垂直分割面板**（在 tmux 会话中按下 `Ctrl+b` 然后按 `%`）：

bash

复制

```

Ctrl+b %

```

2. **水平分割面板**（在 tmux 会话中按下 `Ctrl+b` 然后按 `"`）：

bash

复制

```

Ctrl+b "

```

3. **切换到下一个面板**（在 tmux 会话中按下 `Ctrl+b` 然后按 `o`）：

bash

复制

```

Ctrl+b o

```

4. **关闭当前面板**（在 tmux 会话中按下 `Ctrl+b` 然后按 `x`）：

bash

复制

```

Ctrl+b x

```

5. **最大化/恢复当前面板**（在 tmux 会话中按下 `Ctrl+b` 然后按 `z`）：

bash

复制

```

Ctrl+b z

```

### 其他常用命令

1. **显示时间**（在 tmux 会话中按下 `Ctrl+b` 然后按 `t`）：

bash

复制

```

Ctrl+b t

```

2. **进入复制模式**（在 tmux 会话中按下 `Ctrl+b` 然后按 `[`）：

bash

复制

```

Ctrl+b [

```

3. **粘贴复制的内容**（在 tmux 会话中按下 `Ctrl+b` 然后按 `]`）：

bash

复制

```

Ctrl+b ]

```
```
