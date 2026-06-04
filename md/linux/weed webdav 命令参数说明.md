---
title: "weed webdav 命令参数说明"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed webdav` 命令参数说明

本文档完整保留 `weed webdav -help`​ 命令的**英文原文**，并补充**精准中文翻译**，严格对齐SeaweedFS官方术语，方便查阅使用。

## 命令示例 (Example)

**原文**：Example: weed webdav -port=7333 -filer=<ip:port>  
**翻译**：示例：weed webdav -port=7333 -filer=[文件网关IP:端口](%E6%96%87%E4%BB%B6%E7%BD%91%E5%85%B3IP:%E7%AB%AF%E5%8F%A3)

---

## 默认用法参数 (Default Usage)

|参数名|参数类型|英文描述|中文翻译|
| ------------------| ----------| ----------------------------------------------------------------------------| -------------------------------------------------|
|-cacheCapacityMB|int|local cache capacity in MB|本地缓存容量（单位：MB）|
|-cacheDir|string|local cache directory for file chunks (default "/tmp")|文件分片本地缓存目录（默认值：/tmp）|
|-cert.file|string|path to the TLS certificate file|TLS 证书文件路径|
|-collection|string|collection to create the files|创建文件所属的数据集名称|
|-disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|存储介质类型：硬盘/固态硬盘/自定义标签|
|-filer|string|filer server address (default "localhost:8888")|文件网关服务地址（默认值：localhost:8888）|
|-filer.path|string|use this remote path from filer server (default "/")|映射的文件网关远程路径（默认值：根目录 /）|
|-ip.bind|string|ip address to bind to. Default listen to all.|绑定的IP地址，默认监听所有网卡|
|-key.file|string|path to the TLS private key file|TLS 私钥文件路径|
|-maxMB|int|split files larger than the limit (default 4)|超过该大小的文件自动分片（单位：MB，默认值：4）|
|-options|string|a file of command line options, each line in optionName=optionValue format|命令行参数配置文件，每行格式：参数名=参数值|
|-port|int|webdav server http listen port (default 7333)|WebDAV服务HTTP监听端口（默认值：7333）|
|-replication|string|replication to create the files|创建文件使用的副本策略|

---

## 功能描述 (Description)

**原文**：start a webdav server that is backed by a filer.  
**翻译**：启动一个以文件网关（Filer）为存储后端的 WebDAV 服务。
