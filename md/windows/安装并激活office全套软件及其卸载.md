---
title: "安装并激活office全套软件及其卸载"
date: 2026-06-04
tags: ["windows"]
---

#date/2024-09-29# #lastmod/2024-09-29#

---

# 下载安装及激活

来源： https://linux.do/t/topic/219478

## 前期准备

首先我们先下载一个工具，叫office tool plus：[otp.landian.vip](https://otp.landian.vip/zh-cn/download.html)

![img](https://s3.kongseek.com/markdown/f1e94939c1512260d766264e001758778f557390_2_690x321.png)

### [下载 | Office Tool Plus](https://otp.landian.vip/zh-cn/download.html)

Office Tool Plus 是一个用于部署、激活 Office、Visio、Project 的强大工具。

这里推荐山东大学镜像站，选择64位版本（这里推荐64为版本，可以去windows系统里面查看一下你是几位的操作系统，32位系统（x86架构）就下32位版本，如果不知道是什么那你就下64吧）

![S40929-09012330_org.mozilla.firefox](https://s3.kongseek.com/markdown/8681acfa36977deed6fcdb1a8c7a7e1d4c4d7244_2_345x112.jpeg)

## 安装

下载后解压，打开文件夹，以管理员身份运行exe文件（右击—以管理员身份运行）

![S40929-09063131_com.bilibili.app.in](https://s3.kongseek.com/markdown/2a85b8f0f84ef88028a3aeb24f322ff7c4452b43_2_345x131.jpeg)

此时如果你系统内有旧版的office，则需要先卸载他们

> ### 如何判断你电脑中有没有旧版的office？
>
> 随便找到一个docx文件，双击用默认方式打开他，看看有没有即可。或者去开始中搜索word、excel、powerpoint等

### 如何卸载原有的office？

我们在已经打开的office tool plus中，左侧边栏中找到工具箱，选择卸载office，弹出警告后选择“是”
![S40929-09132941_com.bilibili.app.in](https://s3.kongseek.com/markdown/bed201ec4829209ad41151c90092aa9a8ac267e3.jpeg)

![S40929-09203308_com.bilibili.app.in](https://s3.kongseek.com/markdown/3f5415c4acf0bec26c796ca2679d65a8d072025e_2_345x219.jpeg)

### 正式安装

左侧的选“部署”选项，点开小箭头，打开下拉选项。
体系结构一般都选64位（和上面同，不知道就选64位），更新通道选半年度企业通道，建议勾选创建桌面快捷方式，其余保持默认。

![S40929-09311984_com.bilibili.app.in](https://s3.kongseek.com/markdown/7fc623c6a78b9f327fab17abf1b29714f47d10cf_2_270x250.jpeg)

下面点添加产品，随便选一个即可，推荐选Microsoft 365应用企业版，选自己需要的软件。
注意：如果要用onedrive同步的话，有的软件只支持个人版，不支持企业版（如obsidian的remotely save插件）
点添加语言，拉到最下面，选简体中文(zh-cn)

![S40929-09404794_com.bilibili.app.in(1)](https://s3.kongseek.com/markdown/08abb9bcd7b99c3b072ff0e46efa4146433eb6ba_2_236x250.jpeg)

然后回到最上面，选开始部署

![S40929-10084557_com.bilibili.app.in](https://s3.kongseek.com/markdown/dd7768c32714ed7ed0a86ae7dede09512d3a4718_2_248x250.jpeg)

当进度条结束并出现下图时，安装就完成了（如果卡住了建议重启、重新安装，安装前先卸载）
![S40929-10100024_com.bilibili.app.in](https://s3.kongseek.com/markdown/6054bfd7c9d5b03047d5dc1a7bb8d658136a4779.jpeg)

### 激活

在开始中搜索Powershell，右键，“以管理员身份运行”

![S40929-10160678_com.bilibili.app.in](https://s3.kongseek.com/markdown/ab2a7bdf70ed1fedd61bd60833880851df1fb3ec_2_152x250.jpeg)

在对话框中输入：

```bash
irm https://massgrave.dev/get|iex
```

> 可以直接复制粘贴，旧版的powershell则需要右键粘贴，文中的竖线在键盘上反斜杠的上方，按住shift![:heavy_plus_sign:](https://linux.do/images/emoji/apple/heavy_plus_sign.png?v=12)反斜杠键即可输入（如图）
>
> ![KB_United_States-NoAltGr.svg(1)](https://s3.kongseek.com/markdown/58a6802b1eb5b97a8bb6065746db23107b760ddb_2_345x115.png)

输入后回车，会打开一个新窗口

![S40929-10313665_com.bilibili.app.in](https://s3.kongseek.com/markdown/9889a75c42760dd98ad136fe2bea855d2c7f570c_2_311x250.jpeg)

点击新窗口内任意位置，按数字键2，进入新窗口，按数字键1

![S40929-10350212_com.bilibili.app.in](https://s3.kongseek.com/markdown/fc0c1e1969b77d3d4496ec374c1a4d560c4acca0_2_345x178.jpeg)

显示下图界面则激活成功，就可以正常体验office了

![S40929-10360989_com.bilibili.app.in](https://s3.kongseek.com/markdown/b2b68a90eced1725f778bb57215de05e20c2451c_2_343x250.jpeg)
