---
title: "Princess-farm-master迁移使用"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-10-27 19:32:52# #lastmod/2024-10-27 19:32:52#

---

# Princess-farm-master 迁移使用

## python 依赖直接从原电脑复制

## 雷电模拟器设置

1. 使用脚本自带的 init 命令安装模拟器依赖
2. 如果失败则手动安装

   1. 安装 `uiautomator2`

      ~~~powershell
      pip install uiautomator2 
      ~~~
   2. 手动初始化

      ~~~powershell
      python -m uiautomator2 init
      ~~~
   3. 从 `https://github.com/openatx/atx-agent/releases` 下载以 `linux_armv7.tar.gz` 结尾的二进制包，解压出 atx-agent 文件 atx-agent 文件
   4. 推送到模拟器并安装

      ~~~powershell
      #push 到手机指定路径下
      adb push D:/Useryaoye/Downloads/atx-agent_0.10.1_linux_armv7/atx-agent /data/local/tmp
      #授权
      adb shell chmod 755 /data/local/tmp/atx-agent
      #安装后查看版本号
      adb shell /data/local/tmp/atx-agent server -d
      #启动后台运行
      adb shell /data/local/tmp/atx-agent server -d --stop
      ~~~
   5. 从 `https://github.com/openatx/android-uiautomator-server/releases` 下载`app-uiautomator.apk`,`app-uiautomator-test.apk`,安装到模拟器
   6. 再次执行python -m uiautomator2 init 成功安装
