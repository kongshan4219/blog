---
title: "Linux主机之间复制数据"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-10-05 23:35:51# #lastmod/2024-10-05 23:35:51#

---

# Linux主机之间复制数据

## 同步脚本

```bash
#!/bin/bash

LOCKFILE="/tmp/rsync.lock"

flock -n -E 1 $LOCKFILE -c "rsync -avzP --bwlimit=2048 --delete ubuntu@1.1.1.1:/var/discourse/shared/standalone/backups/default/ /data/backups/ld/"
```

### 脚本内容：

1. **​`LOCKFILE="/tmp/rsync.lock"`​**

   - **作用**：定义一个变量 `LOCKFILE`，其值为 `/tmp/rsync.lock`。这个文件将用作锁文件，防止多个 `rsync` 进程同时运行，避免潜在的文件冲突或数据不一致。
2. **​`flock -n -E 1 $LOCKFILE -c "rsync -avzP --bwlimit=2048 --delete ubuntu@1.1.1.1:/var/discourse/shared/standalone/backups/default/ /data/backups/ld/"`​**

   - **​`flock`​**：
     - **作用**：`flock` 用于管理文件锁，确保在同一时间只有一个进程可以访问特定资源。在这里，它用于确保只有一个 `rsync` 进程运行。
     - **选项解释**：
       - `-n`：非阻塞模式。如果锁无法立即获得，`flock` 会立即退出，而不是等待锁释放。
       - `-E 1`：如果由于信号导致 `flock` 失败，退出状态码将设为 `1`。
       - `-c "command"`：指定要在锁定期间执行的命令。
   -  **​`$LOCKFILE`​**：指定用作锁定的文件，即 `/tmp/rsync.lock`。
   - **​`rsync`​**​ ** 命令**：
     - **作用**：`rsync` 是一个强大的文件同步工具，用于在本地和远程系统之间高效地传输和同步文件。
     - **选项解释**：
       - `-a`（归档模式）：递归传输文件，并保持符号链接、权限、时间戳等信息。
       - `-v`（详细模式）：在传输过程中显示详细的信息。
       - `-z`（压缩）：在传输过程中压缩文件，减少带宽使用。
       - `-P`：相当于 `--partial --progress`，显示传输进度，并在中断后保留部分传输的文件，以便下次继续。
       - `--bwlimit=2048`：限制带宽使用为 2048 KB/s，防止 `rsync` 占用过多网络带宽。
       - `--delete`：在目标目录中删除那些在源目录中已不存在的文件，确保目标目录与源目录保持完全一致。
   - **源和目标路径**：
     - **源**：`ubuntu@1.1.1.1:/var/discourse/shared/standalone/backups/default/`
       - 这是远程服务器 `1.1.1.1` 上 `ubuntu` 用户的目录路径，表示需要同步的源文件夹。
     - **目标**：`/data/backups/ld/`
       - 这是本地系统上的目标目录，`rsync` 将文件同步到这里。

### 整体作用：

这个脚本的主要目的是通过 `rsync` 将远程服务器上的备份文件夹同步到本地目录 `/data/backups/ld/`。使用 `flock` 确保在同一时间只有一个同步任务在运行，避免可能的竞争条件或数据冲突。此外，通过 `rsync` 的各种选项，脚本实现了高效、可靠且受控的文件同步过程，包括带宽限制和删除不再需要的文件。

### 注意事项：

- **权限**：确保运行这个脚本的用户有权限访问 `/tmp/rsync.lock` 文件和目标目录 `/data/backups/ld/`。
- **SSH 认证**：`rsync` 使用 SSH 进行数据传输，确保本地服务器可以通过 SSH 无密码登录到远程服务器 `ubuntu@1.1.1.1`，通常通过设置 SSH 密钥认证来实现。
- **错误处理**：当前脚本设置了 `-E 1`，如果因为信号导致锁定失败，脚本会以状态码 `1` 退出。您可以根据需要添加更多的错误处理逻辑，比如记录日志或发送通知。
