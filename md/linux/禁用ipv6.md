---
title: "禁用ipv6"
date: 2026-06-04
tags: ["linux"]
---

#date/2020-01-01# #lastmod/2020-01-01#

# 禁用ipv6

要在Linux系统上禁用IPv6，可以按照以下步骤进行操作。这些步骤适用于大多数Linux发行版（例如CentOS、Ubuntu、Debian等）。

### 方法1：临时禁用IPv6

这种方法将在系统重启后失效。

1. 打开终端并切换到root用户（或者使用`sudo`）。
2. 执行以下命令以禁用IPv6：

   ```
   sysctl -w net.ipv6.conf.all.disable_ipv6=1
   sysctl -w net.ipv6.conf.default.disable_ipv6=1
   sysctl -w net.ipv6.conf.lo.disable_ipv6=1
   ```

### 方法2：永久禁用IPv6

要永久禁用IPv6，你需要编辑系统的配置文件。

1. 打开`/etc/sysctl.conf`文件：

   ```
   vi /etc/sysctl.conf
   ```
2. 在文件末尾添加以下几行：

   ```
   net.ipv6.conf.all.disable_ipv6 = 1
   net.ipv6.conf.default.disable_ipv6 = 1
   net.ipv6.conf.lo.disable_ipv6 = 1
   ```
3. 保存并退出编辑器（在vi编辑器中，按`Esc`键后输入`:wq`并回车）。
4. 应用更改：

   ```
   sysctl -p
   ```

### 方法3：通过GRUB禁用IPv6

这种方法适用于CentOS/RHEL系统。

1. 编辑`/etc/default/grub`文件：

   ```
   vi /etc/default/grub
   ```
2. 找到包含`GRUB_CMDLINE_LINUX`的行，并在引号内添加以下内容：

   ```
   ipv6.disable=1
   ```

   修改后的行可能类似于：

   ```
   GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap crashkernel=auto ipv6.disable=1"
   ```
3. 保存并退出编辑器。
4. 重新生成GRUB配置文件：

   对于BIOS引导系统：

   ```
   grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

   对于UEFI引导系统：

   ```
   grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
   ```
5. 重启系统以应用更改：

   ```
   reboot
   ```

在重启后，IPv6应该被禁用了。你可以通过`ifconfig`或`ip a`命令来检查是否IPv6已经被禁用。
