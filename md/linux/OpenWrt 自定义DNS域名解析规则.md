---
title: "OpenWrt 自定义DNS域名解析规则"
date: 2026-06-04
tags: ["linux"]
---

​#date/2025-10-12 23:17:35#​ #lastmod/2025-10-14 21:49:32#

# OpenWrt 自定义域名解析规则

### 通过 `/etc/config/dhcp` 文件配置

1. **编辑配置文件**  

   ```bash
   vi /etc/config/dhcp
   ```
2. **添加解析规则**在 `config dnsmasq` 段落中，添加类似以下格式的配置：  

   ```conf
   # 格式：list address '/域名/IP地址'
   list address '/example.com/192.168.254.100'
   list address '/test.com/192.168.254.101'
   list address '/sub.domain.com/192.168.254.102'
   list address '/kongseek.com/192.168.254.254'
   ```
   > 说明：已存在的 `list address '/kongseek.com/192.168.254.254'` 就是一个有效的解析规则示例
   >
3. **保存配置并重启服务**  

   ```bash
   # 保存配置
   :wq

   # 重启 dnsmasq 服务使配置生效,会报错，但是会执行成功
   /etc/init.d/dnsmasq restart  
   ```
