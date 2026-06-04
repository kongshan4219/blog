---
title: "小米平板 5 Pro 5G 刷机和 root"
date: 2026-06-04
tags: ["windows"]
---

### 刷机

使用`MIUI线刷包刷写工具`输入指定版本系统,得到初始系统.

### root

安装面具,找到刷机工具输入的系统文件的`boot.img`​,复制到机器中,在面具中修补`boot.img`.

将修补后的`boot.img`​传到电脑,使用命令`fastboot boot boot.img`​测试`boot.img`​是否成功获取root且能开机.(这个命令是通过 fastboot 临时启动 `boot.img` 镜像,不永久写入，仅本次启动生效)

测试成功后使用`fastboot flash boot boot.img`​将修补后的`boot.img`输入机器
