---
title: "reclone挂载onedrive"
date: 2026-06-04
tags: ["linux"]
---

​#lastmod/2025-03-26 21:16:19#​  #date/2025-03-20 08:58:58#

## windows

- 下载 [reclone](https://github.com/rclone/rclone/releases) 和 [winfsp](https://winfsp.dev/rel/)
- reclone配置onedrive[文档](https://rclone.org/onedrive/)
- 挂载OneDrive为本地硬盘

  - ​`rclone mount one:/  O: --cache-dir E:\OneDrive --vfs-cache-mode writes &`

    其中：

    ​`one` 为挂载盘的名称 

    ​`O:` 为挂载盘的盘符

    ​`E:\OneDrive` 为本地缓存目录

    出现：`The service rclone has been started` 则说明挂载成功。

## linux

```java
rclone mount one:/ /mnt/data/one --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000
```

‍

‍
