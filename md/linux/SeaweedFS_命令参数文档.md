---
title: "SeaweedFS_命令参数文档"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed server` 参数配置详解

本文档是对 SeaweedFS `weed server` 命令行工具通过 `-h` 参数输出的完整参数列表进行的专业化整理与翻译。该命令用于启动集成了 Master、Volume Server 及可选组件（Filer、S3、SFTP、WebDAV 等）的一体化服务实例。本文档将所有参数按功能模块分类，提供结构化的表格展示，包含参数名称、类型/默认值、中文描述与英文原文，便于系统部署、调优和故障排查。

---

## 文档概述

- **用途**：作为 SeaweedFS 部署与运维的权威参考手册
- **适用版本**：基于当前 `weed server -h` 输出内容（适用于主流稳定版及企业版）
- **核心功能**：支持同时启动 Master 和 Volume Server，并可选择性启用 Filer、S3 Gateway、SFTP、WebDAV、IAM、消息队列等高级组件
- **启动模式**：一体化启动方式，行为等同于分别启动各服务，其他 Volume Server 也可连接至此 Master
- **许可证加载顺序**：
  1. `-license` 命令行参数指定路径
  2. `SEAWEED_LICENSE` 环境变量
  3. 标准位置：`./seaweed-license.json`, `$HOME/.seaweedfs/seaweed-license.json`, `/usr/local/etc/seaweedfs/seaweed-license.json`, `/etc/seaweedfs/seaweed-license.json`

---

## 参数分类表

### 通用参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| :--: | --------| --------------------------| --------------------------------------------------------------------------------| ----------------------------------------------------------------------------------------|
|1|`-cpuprofile`|string|CPU 性能分析输出文件路径|cpu profile output file|
|2|`-debug`|bool|启用运行时性能分析服务，例如 http://localhost:6060/debug/pprof/goroutine?debug=2|serves runtime profiling data, e.g., http://localhost:6060/debug/pprof/goroutine?debug=2|
|3|`-debug.port`|int (6060)|调试 HTTP 端口|http port for debugging|
|4|`-dir`|string ("/tmp")|存储数据文件的目录，支持多个目录 dir[,dir]...|directories to store data files. dir[,dir]...|
|5|`-disableHttp`|bool|禁用 HTTP 请求，仅允许 gRPC 操作|disable http requests, only gRPC operations are allowed.|
|6|`-idleTimeout`|int (30)|连接空闲超时秒数|connection idle seconds|
|7|`-ip`|string ("192.168.254.253")|IP 或服务器名称，也用作标识符|ip or server name, also used as identifier|
|8|`-ip.bind`|string|绑定的 IP 地址。若为空，则默认与 `-ip` 相同|ip address to bind to. If empty, default to same as -ip option.|
|9|`-license`|string|企业许可证文件路径|path to enterprise license file|
|10|`-memprofile`|string|内存性能分析输出文件路径|memory profile output file|
|11|`-metricsIp`|string|指标监听 IP。若为空，默认与 `-ip.bind` 相同|metrics listen ip. If empty, default to same as -ip.bind option.|
|12|`-metricsPort`|int|Prometheus 指标监听端口|Prometheus metrics listen port|
|13|`-options`|string|包含命令行选项的文件，每行格式为 optionName=optionValue|a file of command line options, each line in optionName=optionValue format|
|14|`-whiteList`|string|具有写权限的逗号分隔 IP 地址列表。若为空则无限制|comma separated Ip addresses having write permission. No limit if empty.|

---

### Master 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| ----------------| ----------------------------------------------------| ----------------------------------------------------------------------------------|
|1|`-master`|bool (true)|是否启动 Master 服务|whether to start master server|
|2|`-master.defaultReplication`|string|若未指定，则使用此默认复制类型|Default replication type if not specified.|
|3|`-master.dir`|string|存储元数据的数据目录，默认与 `-dir` 相同|data directory to store meta data, default to same as -dir specified|
|4|`-master.electionTimeout`|duration (10s)|Master 节点选举超时时间|election timeout of master servers|
|5|`-master.garbageThreshold`|float (0.3)|清理空间的阈值（小于该比例的空间将被回收）|threshold to vacuum and reclaim spaces|
|6|`-master.heartbeatInterval`|duration (300ms)|Master 心跳间隔，会随机乘以 [1, 1.25)|heartbeat interval of master servers, and will be randomly multiplied by [1, 1.25)|
|7|`-master.maxParallelVacuumPerServer`|int (1)|单个 Volume Server 上并行清理的最大卷数量|maximum number of volumes to vacuum in parallel on one volume server|
|8|`-master.metrics.address`|string|Prometheus 网关地址|Prometheus gateway address|
|9|`-master.metrics.intervalSeconds`|int (15)|Prometheus 推送间隔（秒）|Prometheus push interval in seconds|
|10|`-master.peers`|string|所有 Master 节点的逗号分隔列表，格式为 ip:masterPort|all master nodes in comma separated ip:masterPort list|
|11|`-master.port`|int (9333)|Master 服务 HTTP 监听端口|master server http listen port|
|12|`-master.port.grpc`|int|Master 服务 gRPC 监听端口|master server grpc listen port|
|13|`-master.raftBootstrap`|bool|是否引导 Raft 集群|Whether to bootstrap the Raft cluster|
|14|`-master.raftHashicorp`|bool|使用 HashiCorp Raft 实现|use hashicorp raft|
|15|`-master.resumeState`|bool|启动 Master 服务时恢复之前的状态|resume previous state on start master server|
|16|`-master.telemetry`|bool|启用遥测报告|enable telemetry reporting|
|17|`-master.telemetry.url`|string (`https://telemetry.seaweedfs.com/api/collect`)|发送使用统计信息的遥测服务器 URL|telemetry server URL to send usage statistics|
|18|`-master.volumePreallocate`|bool|预分配卷的磁盘空间|Preallocate disk space for volumes.|
|19|`-master.volumeSizeLimitMB`|uint (30000)|Master 停止向超过大小限制的卷写入数据|Master stops directing writes to oversized volumes.|

---

### Volume 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| -----------------| -----------------------------------------------------------------------------------------------------------| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|1|`-volume`|bool (true)|是否启动 Volume 服务|whether to start volume server|
|2|`-dataCenter`|string|当前 Volume Server 所属数据中心名称|current volume server's data center name|
|3|`-rack`|string|当前 Volume Server 所属机架名称|current volume server's rack name|
|4|`-volume.compactionMBps`|int|限制合并操作的速度（MB/s）|limit compaction speed in mega bytes per second|
|5|`-volume.concurrentDownloadLimitMB`|int|限制总并发下载大小，0 表示无限制|limit total concurrent download size, 0 means unlimited|
|6|`-volume.concurrentUploadLimitMB`|int|限制总并发上传大小，0 表示无限制|limit total concurrent upload size, 0 means unlimited|
|7|`-volume.dir.idx`|string|存储 .idx 文件的目录|directory to store .idx files|
|8|`-volume.disk`|string|[hdd\|ssd\<tag>] 硬盘或固态硬盘或任意标签|[hdd|
|9|`-volume.fileSizeLimitMB`|int (256)|限制文件大小以避免内存溢出|limit file size to avoid out of memory|
|10|`-volume.hasSlowRead`|bool (true)|<实验性> 若为 true，则防止慢速读取阻塞其他请求，但大文件读取 P99 延迟会增加|<experimental> if true, this prevents slow reads from blocking other requests, but large file read P99 latency will increase.|
|11|`-volume.id`|string|Volume Server ID。若为空，则默认为 ip:port|volume server id. If empty, default to ip:port|
|12|`-volume.images.fix.orientation`|bool|上传 JPG 文件时调整方向|Adjust jpg orientation when uploading.|
|13|`-volume.index`|string ("memory")|选择 [memory\|leveldb\|leveldbMedium\|leveldbLarge] 模式以平衡内存与性能|Choose [memory|
|14|`-volume.index.leveldbTimeout`|int (0)|LevelDB 的存活时间（小时）。若 Volume 的 LevelDB 在指定时间内未被访问，则会被卸载以减少打开的文件和内存消耗|alive time for leveldb (default to 0). If leveldb of volume is not accessed in ldbTimeout hours, it will be off loaded to reduce opened files and memory consumption.|
|15|`-volume.inflightDownloadDataTimeout`|duration (1m0s)|Volume Server 下载数据等待超时时间|inflight download data wait timeout of volume servers|
|16|`-volume.inflightUploadDataTimeout`|duration (1m0s)|Volume Server 上传数据等待超时时间|inflight upload data wait timeout of volume servers|
|17|`-volume.maintenanceMBps`|int|限制维护操作（复制/均衡）的 IO 速率（MB/s），未设置则为 0（无限制）|limit maintenance (replication / balance) IO rate in MB/s. Unset is 0, no limitation.|
|18|`-volume.max`|string ("8")|最大卷数量，count[,count]... 若设为零，则根据可用磁盘空间自动配置|maximum numbers of volumes, count[,count]... If set to zero, the limit will be auto configured as free disk space divided by volume size.|
|19|`-volume.minFreeSpace`|string|最小空闲磁盘空间（值≤100 视为百分比如 1，其余为可读字节如 10GiB）。磁盘空间不足会将所有卷标记为只读|min free disk space (value<=100 as percentage like 1, other as human readable bytes, like 10GiB). Low disk space will mark all volumes as ReadOnly.|
|20|`-volume.minFreeSpacePercent`|string ("1")|最小空闲磁盘空间（已弃用，请使用 minFreeSpace）|minimum free disk space (default to 1%). Low disk space will mark all volumes as ReadOnly (deprecated, use minFreeSpace instead).|
|21|`-volume.port`|int (8080)|Volume Server HTTP 监听端口|volume server http listen port|
|22|`-volume.port.grpc`|int|Volume Server gRPC 监听端口|volume server grpc listen port|
|23|`-volume.port.public`|int|Volume Server 公共端口|volume server public port|
|24|`-volume.pprof`|bool|启用 pprof HTTP 处理程序（与 -memprofile 和 -cpuprofile 互斥）|enable pprof http handlers. precludes -memprofile and -cpuprofile|
|25|`-volume.preStopSeconds`|int (10)|停止发送心跳与停止 Volume Server 之间的秒数|number of seconds between stop send heartbeats and stop volume server|
|26|`-volume.publicUrl`|string|可公开访问的地址|publicly accessible address|
|27|`-volume.readBufferSizeMB`|int (4)|<实验性> 更大的值可优化查询性能但会增加内存使用，通常与 hasSlowRead 配合使用|<experimental> larger values can optimize query performance but will increase some memory usage,Use with hasSlowRead normally|
|28|`-volume.readMode`|string ("proxy")|[local\|proxy\|redirect] 如何处理非本地卷：“未找到”\|“在远程节点读取”\|“重定向到卷位置”|[local|

---

### Filer 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| ----------------| ---------------------------------------------------------| --------------------------------------------------------------------------|
|1|`-filer`|bool|是否启动 Filer 服务|whether to start filer|
|2|`-filer.allowedOrigins`|string ("*")|允许的跨域来源列表，逗号分隔|comma separated list of allowed origins|
|3|`-filer.collection`|string|所有数据将存储在此集合中|all data will be stored in this collection|
|4|`-filer.concurrentFileUploadLimit`|int|限制并发文件上传数量，0 表示无限制|limit number of concurrent file uploads, 0 means unlimited|
|5|`-filer.concurrentUploadLimitMB`|int|限制总并发上传大小，0 表示无限制|limit total concurrent upload size, 0 means unlimited|
|6|`-filer.defaultReplicaPlacement`|string|默认副本放置策略。若未指定，则使用 Master 设置|default replication type. If not specified, use master setting.|
|7|`-filer.dirListLimit`|int (1000)|限制子目录列出的大小|limit sub dir listing size|
|8|`-filer.disableDirListing`|bool|关闭目录列表功能|turn off directory listing|
|9|`-filer.disk`|string|[hdd\|ssd\<tag>] 硬盘或固态驱动器或任意标签|[hdd|
|10|`-filer.downloadMaxMBps`|int|每个下载请求的最大下载速度（MB/s）|download max speed for each download request, in MB per second|
|11|`-filer.encryptVolumeData`|bool|在 Volume Server 上加密数据|encrypt data on volume servers|
|12|`-filer.exposeDirectoryData`|bool (true)|通过 Filer 暴露目录数据。若为 false，则 Filer UI 不可访问|expose directory data via filer. If false, filer UI will be innaccessible.|
|13|`-filer.filerGroup`|string|与同一 filerGroup 中的其他 Filer 共享元数据|share metadata with other filers in the same filerGroup|
|14|`-filer.localSocket`|string|默认为 /tmp/seaweedfs-filer-<port>.sock|default to /tmp/seaweedfs-filer-<port>.sock|
|15|`-filer.maxMB`|int (4)|超过此限制的文件将被拆分|split files larger than the limit|
|16|`-filer.port`|int (8888)|Filer 服务 HTTP 监听端口|filer server http listen port|
|17|`-filer.port.grpc`|int|Filer 服务 gRPC 监听端口|filer server grpc listen port|
|18|`-filer.port.public`|int|Filer 服务公共 HTTP 监听端口|filer server public http listen port|
|19|`-filer.saveToFilerLimit`|int|小于该限制的小文件可在 Filer 存储中缓存|Small files smaller than this limit can be cached in filer store.|
|20|`-filer.tusBasePath`|string ("/.tus")|TUS 断点续传上传端点基础路径（例如 /.tus）|TUS resumable upload endpoint base path (e.g., /.tus)|
|21|`-filer.ui.deleteDir`|bool (true)|启用 Filer UI 显示删除目录按钮|enable filer UI show delete directory button|

---

### S3 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| ---------------| --------------------------------------------------------| ----------------------------------------------------------------------------------------|
|1|`-s3`|bool|是否启动 S3 网关|whether to start S3 gateway|
|2|`-s3.allowDeleteBucketNotEmpty`|bool (true)|允许递归删除桶内所有条目及桶本身|allow recursive deleting all entries along with bucket|
|3|`-s3.allowEmptyFolder`|bool (true)|已弃用，忽略。空文件夹清理现在是自动的|deprecated, ignored. Empty folder cleanup is now automatic.|
|4|`-s3.allowedOrigins`|string ("*")|允许的跨域来源列表，逗号分隔|comma separated list of allowed origins|
|5|`-s3.auditLogConfig`|string|审计日志配置文件路径|path to the audit log config file|
|6|`-s3.cacert.file`|string|TLS CA 证书文件路径|path to the TLS CA certificate file|
|7|`-s3.cert.file`|string|TLS 证书文件路径|path to the TLS certificate file|
|8|`-s3.concurrentFileUploadLimit`|int|限制 S3 并发文件上传数量，0 表示无限制|limit number of concurrent file uploads for S3, 0 means unlimited|
|9|`-s3.concurrentUploadLimitMB`|int|限制 S3 总并发上传大小，0 表示无限制|limit total concurrent upload size for S3, 0 means unlimited|
|10|`-s3.config`|string|配置文件路径|path to the config file|
|11|`-s3.domainName`|string|主机名后缀，逗号分隔列表，格式为 {bucket}.{domainName}|suffix of the host name in comma separated list, {bucket}.{domainName}|
|12|`-s3.encryptVolumeData`|bool|对 S3 上传的数据在 Volume Server 上加密|encrypt data on volume servers for S3 uploads|
|13|`-s3.iam`|bool (true)|在相同 S3 端口上启用嵌入式 IAM API|enable embedded IAM API on the same S3 port|
|14|`-s3.iam.config`|string|S3 高级 IAM 配置文件路径。若同时提供，则覆盖 -iam.config|path to the advanced IAM config file for S3. Overrides -iam.config if both are provided.|
|15|`-s3.iam.readOnly`|bool (true)|在此服务器上禁用 IAM 写操作|disable IAM write operations on this server|
|16|`-s3.idleTimeout`|int (120)|连接空闲超时秒数|connection idle seconds|
|17|`-s3.ip.bind`|string|绑定的 IP 地址。若为空，默认与 `-ip.bind` 相同|ip address to bind to. If empty, default to same as -ip.bind option.|
|18|`-s3.key.file`|string|TLS 私钥文件路径|path to the TLS private key file|
|19|`-s3.localSocket`|string|默认为 /tmp/seaweedfs-s3-<port>.sock|default to /tmp/seaweedfs-s3-<port>.sock|
|20|`-s3.port`|int (8333)|S3 服务 HTTP 监听端口|s3 server http listen port|
|21|`-s3.port.grpc`|int|S3 服务 gRPC 监听端口|s3 server grpc listen port|
|22|`-s3.port.https`|int|S3 服务 HTTPS 监听端口|s3 server https listen port|
|23|`-s3.port.iceberg`|int (8181)|Iceberg REST Catalog 服务监听端口（0 表示禁用）|Iceberg REST Catalog server listen port (0 to disable)|
|24|`-s3.tlsVerifyClientCert`|bool|是否验证客户端证书|whether to verify the client's certificate|

---

### SFTP 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| -----------------------------| ---------------------------------------------------------------------| ---------------------------------------------------------------------------------------|
|1|`-sftp`|bool|是否启动 SFTP 服务|whether to start Sftp server|
|2|`-sftp.authMethods`|string ("password,publickey")|逗号分隔的允许认证方法列表：password, publickey, keyboard-interactive|comma-separated list of allowed auth methods: password, publickey, keyboard-interactive|
|3|`-sftp.bannerMessage`|string (`SeaweedFS SFTP Server - Unauthorized access is prohibited`)|认证前显示的消息|message displayed before authentication|
|4|`-sftp.clientAliveCountMax`|int (3)|在断开连接前允许丢失的最大保活消息数|maximum number of missed keep-alive messages before disconnecting|
|5|`-sftp.clientAliveInterval`|duration (5s)|发送保活消息的时间间隔|interval for sending keep-alive messages|
|6|`-sftp.hostKeysFolder`|string|包含用于主机认证的 SSH 私钥文件的文件夹路径|path to folder containing SSH private key files for host authentication|
|7|`-sftp.localSocket`|string|默认为 /tmp/seaweedfs-sftp-<port>.sock|default to /tmp/seaweedfs-sftp-<port>.sock|
|8|`-sftp.loginGraceTime`|duration (2m0s)|认证超时时间|timeout for authentication|
|9|`-sftp.maxAuthTries`|int (6)|每个连接的最大认证尝试次数|maximum number of authentication attempts per connection|
|10|`-sftp.port`|int (2022)|SFTP 服务监听端口|SFTP server listen port|
|11|`-sftp.sshPrivateKey`|string|用于主机认证的 SSH 私钥文件路径|path to the SSH private key file for host authentication|
|12|`-sftp.userStoreFile`|string|包含用户凭据和权限的 JSON 文件路径|path to JSON file containing user credentials and permissions|

---

### WebDAV 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| ---------------| -----------------------------------------| --------------------------------------|
|1|`-webdav`|bool|是否启动 WebDAV 网关|whether to start WebDAV gateway|
|2|`-webdav.cacheCapacityMB`|int|本地缓存容量（MB）|local cache capacity in MB|
|3|`-webdav.cacheDir`|string ("/tmp")|文件块的本地缓存目录|local cache directory for file chunks|
|4|`-webdav.cert.file`|string|TLS 证书文件路径|path to the TLS certificate file|
|5|`-webdav.collection`|string|创建文件的集合|collection to create the files|
|6|`-webdav.disk`|string|[hdd\|ssd\<tag>] 硬盘或固态驱动器或任意标签|[hdd|
|7|`-webdav.filer.path`|string ("/")|使用 Filer 服务器上的此远程路径|use this remote path from filer server|
|8|`-webdav.key.file`|string|TLS 私钥文件路径|path to the TLS private key file|
|9|`-webdav.maxMB`|int (4)|超过此限制的文件将被拆分|split files larger than the limit|
|10|`-webdav.port`|int (7333)|WebDAV 服务 HTTP 监听端口|webdav server http listen port|
|11|`-webdav.replication`|string|创建文件时使用的复制策略|replication to create the files|

---

### IAM 参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| ---------------| ----------------------------------------------------------------| --------------------------------------------------------------------------------------------------|
|1|`-iam`|bool|是否启动 IAM 服务|whether to start IAM service|
|2|`-iam.config`|string|S3 高级 IAM 配置文件路径。是 -s3.iam.config 的别名，但优先级较低|path to the advanced IAM config file for S3. An alias for -s3.iam.config, but with lower priority.|
|3|`-iam.port`|int (8111)|IAM 服务 HTTP 监听端口|iam server http listen port|

---

### 消息队列参数

|编号|参数名称|参数类型/默认值|中文描述|英文描述|
| ----| --------| --------------------------| ------------------------------| -------------------------------------|
|1|`-mq.agent`|bool|是否启动消息队列代理|whether to start message queue agent|
|2|`-mq.agent.brokers`|string ("localhost:17777")|逗号分隔的消息队列 Broker 列表|comma-separated message queue brokers|
|3|`-mq.agent.port`|int (16777)|消息队列代理 gRPC 监听端口|message queue agent gRPC listen port|
|4|`-mq.broker`|bool|是否启动消息队列 Broker|whether to start message queue broker|
|5|`-mq.broker.logFlushInterval`|int (5)|日志缓冲区刷新间隔（秒）|log buffer flush interval in seconds|
|6|`-mq.broker.port`|int (17777)|消息队列 Broker gRPC 监听端口|message queue broker gRPC listen port|
