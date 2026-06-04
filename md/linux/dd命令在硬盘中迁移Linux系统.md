---
title: "dd命令在硬盘中迁移Linux系统"
date: 2026-06-04
tags: ["linux"]
---

### 备份原系统盘为镜像

**安装依赖工具（用于显示进度,压缩镜像）**

```bash
sudo apt update && sudo apt install pv gzip
```

**执行整盘备份**

```bash
sudo dd if=/dev/sda bs=4M status=progress | pv | sudo gzip > /mnt/backup/ubuntu_full_backup_$(date +%Y%m%d).img.gz
```

**生成校验值，验证备份完整性**

```bash
sha256sum /mnt/backup/ubuntu_full_backup_$(date +%Y%m%d).img.gz > /mnt/backup/backup_checksum.sha256
```

### 完整迁移，会清空目标盘数据

**if=/dev/sdb**：指定源盘为 /dev/sdb，即输入盘

**of=/dev/nvme0n1**：指定目标盘为 /dev/nvme0n1，即输出盘

**bs=16M**：设置块大小为 16MB

**status=progress:**  实时显示克隆进度

**conv=noerror,sync**：确保克隆过程中遇到错误也能继续，并且保证数据块对齐。noerror 意味着遇到错误时继续执行，sync 确保即使发生错误，数据块也会被完整写入，避免目标盘数据错位

```bash
dd if=/dev/sdb of=/dev/nvme0n1 bs=16M status=progress conv=noerror,sync
```

旧版dd没有参数status=progress

```bash
dd if=/dev/sdb of=/dev/nvme0n1 bs=16M conv=noerror,sync
```

### 备份恢复方式

直接恢复时目标盘容量必须大于解压后镜像(dd目录执行备份时原盘容量)大小，不然会失败

```bash
gunzip -c /mnt/backup/ubuntu_full_backup_xxx.img.gz | pv | sudo dd of=/dev/sdb bs=4M status=progress
```

‍
