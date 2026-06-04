---
title: "weed server 命令参数说明"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed server` 命令参数说明

本文档完整保留 `weed server -help`​ 命令的**英文原文**，并补充**精准中文翻译**，严格对齐SeaweedFS官方术语，方便查阅使用。

## 命令示例 (Example)

**原文**：Example: weed server -dir=/tmp -volume.max=5 -ip=server_name  
**翻译**：示例：weed server -dir=/tmp -volume.max=5 -ip=服务器名称

---

## 默认用法参数 (Default Usage)

|参数名|参数类型|英文描述|中文翻译|
| -------------------------------------| ----------| -----------------------------------------------------------------------------------------------------------------------------------------------------------------------| --------------------------------------------------------|
|-cpuprofile|string|cpu profile output file|CPU性能分析输出文件|
|-dataCenter|string|current volume server's data center name|当前卷服务器所属数据中心名称|
|-debug|-|serves runtime profiling data, e.g., http://localhost:6060/debug/pprof/goroutine?debug=2|提供运行时性能分析数据|
|-debug.port|int|http port for debugging (default 6060)|调试用HTTP端口（默认值：6060）|
|-dir|string|directories to store data files. dir[,dir]... (default "/tmp")|数据文件存储目录（支持逗号分隔多目录，默认值：/tmp）|
|-disableHttp|-|disable http requests, only gRPC operations are allowed.|禁用HTTP请求，仅允许gRPC操作|
|-filer|-|whether to start filer|是否启动Filer文件网关|
|-filer.allowedOrigins|string|comma separated list of allowed origins (default "*")|Filer允许的跨域来源（默认值：*）|
|-filer.collection|string|all data will be stored in this collection|Filer数据默认存储的数据集|
|-filer.concurrentFileUploadLimit|int|limit number of concurrent file uploads, 0 means unlimited|Filer并发文件上传数量限制，0表示无限制|
|-filer.concurrentUploadLimitMB|int|limit total concurrent upload size, 0 means unlimited|Filer并发上传总大小限制，0表示无限制|
|-filer.defaultReplicaPlacement|string|default replication type. If not specified, use master setting.|Filer默认副本策略，未指定则沿用Master配置|
|-filer.dirListLimit|int|limit sub dir listing size (default 1000)|Filer子目录列表数量上限（默认值：1000）|
|-filer.disableDirListing|-|turn off directory listing|禁用Filer目录列表展示|
|-filer.disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|Filer存储介质类型|
|-filer.downloadMaxMBps|int|download max speed for each download request, in MB per second|Filer单请求下载最大速度（MB/秒）|
|-filer.encryptVolumeData|-|encrypt data on volume servers|Filer上传时加密卷数据|
|-filer.exposeDirectoryData|-|expose directory data via filer. If false, filer UI will be innaccessible. (default true)|Filer暴露目录数据，为false则UI不可用（默认值：true）|
|-filer.filerGroup|string|share metadata with other filers in the same filerGroup|Filer组名，同组共享元数据|
|-filer.localSocket|string|default to /tmp/seaweedfs-filer-<port>.sock|Filer本地Unix套接字路径|
|-filer.maxMB|int|split files larger than the limit (default 4)|Filer文件自动分片大小（MB，默认值：4）|
|-filer.port|int|filer server http listen port (default 8888)|Filer服务HTTP端口（默认值：8888）|
|-filer.port.grpc|int|filer server grpc listen port|Filer服务gRPC端口|
|-filer.port.public|int|filer server public http listen port|Filer对外公共端口|
|-filer.saveToFilerLimit|int|Small files smaller than this limit can be cached in filer store.|小于该值的小文件直接缓存到Filer存储|
|-filer.tusBasePath|string|TUS resumable upload endpoint base path (e.g., /.tus) (default "/.tus")|Filer断点续传接口路径（默认值：/.tus）|
|-filer.ui.deleteDir|-|enable filer UI show delete directory button (default true)|Filer界面显示删除目录按钮（默认值：true）|
|-iam|-|whether to start IAM service|是否启动IAM身份认证服务|
|-iam.config|string|path to the advanced IAM config file for S3. An alias for -s3.iam.config, but with lower priority.|IAM高级配置文件路径（优先级低于s3.iam.config）|
|-iam.port|int|iam server http listen port (default 8111)|IAM服务端口（默认值：8111）|
|-idleTimeout|int|connection idle seconds (default 30)|连接空闲超时时间（秒，默认值：30）|
|-ip|string|ip or server name, also used as identifier (default "192.168.254.253")|服务IP/主机名，作为节点标识（默认值：192.168.254.253）|
|-ip.bind|string|ip address to bind to. If empty, default to same as -ip option.|绑定IP，为空则与-ip一致|
|-license|string|path to enterprise license file|企业版许可证文件路径|
|-master|-|whether to start master server (default true)|是否启动Master主节点（默认值：true）|
|-master.defaultReplication|string|Default replication type if not specified.|Master默认副本策略|
|-master.dir|string|data directory to store meta data, default to same as -dir specified|Master元数据存储目录，默认与-dir一致|
|-master.electionTimeout|duration|election timeout of master servers (default 10s)|Master选举超时时间（默认值：10秒）|
|-master.garbageThreshold|float|threshold to vacuum and reclaim spaces (default 0.3)|Master空间回收阈值（默认值：0.3）|
|-master.heartbeatInterval|duration|heartbeat interval of master servers, and will be randomly multiplied by [1, 1.25) (default 300ms)|Master心跳间隔（默认值：300毫秒）|
|-master.maxParallelVacuumPerServer|int|maximum number of volumes to vacuum in parallel on one volume server (default 1)|Master单节点并行清理最大卷数（默认值：1）|
|-master.metrics.address|string|Prometheus gateway address|Master监控推送网关地址|
|-master.metrics.intervalSeconds|int|Prometheus push interval in seconds (default 15)|Master监控推送间隔（秒，默认值：15）|
|-master.peers|string|all master nodes in comma separated ip:masterPort list|Master集群节点列表（逗号分隔ip:端口）|
|-master.port|int|master server http listen port (default 9333)|Master服务HTTP端口（默认值：9333）|
|-master.port.grpc|int|master server grpc listen port|Master服务gRPC端口|
|-master.raftBootstrap|-|Whether to bootstrap the Raft cluster|是否初始化Raft集群|
|-master.raftHashicorp|-|use hashicorp raft|使用HashiCorp Raft实现|
|-master.resumeState|-|resume previous state on start master server|启动Master时恢复上一次状态|
|-master.telemetry|-|enable telemetry reporting|Master启用遥测上报|
|-master.telemetry.url|string|telemetry server URL to send usage statistics (default "https://telemetry.seaweedfs.com/api/collect")|Master遥测上报地址|
|-master.volumePreallocate|-|Preallocate disk space for volumes.|Master为卷预分配磁盘空间|
|-master.volumeSizeLimitMB|uint|Master stops directing writes to oversized volumes. (default 30000)|Master卷大小上限（MB，默认值：30000）|
|-memprofile|string|memory profile output file|内存性能分析输出文件|
|-metricsIp|string|metrics listen ip. If empty, default to same as -ip.bind option.|监控指标监听IP|
|-metricsPort|int|Prometheus metrics listen port|Prometheus监控端口|
|-mq.agent|-|whether to start message queue agent|是否启动消息队列代理|
|-mq.agent.brokers|string|comma-separated message queue brokers (default "localhost:17777")|消息队列Broker地址|
|-mq.agent.port|int|message queue agent gRPC listen port (default 16777)|消息队列代理gRPC端口|
|-mq.broker|-|whether to start message queue broker|是否启动消息队列Broker|
|-mq.broker.logFlushInterval|int|log buffer flush interval in seconds (default 5)|消息队列日志刷新间隔|
|-mq.broker.port|int|message queue broker gRPC listen port (default 17777)|消息队列Broker端口|
|-options|string|a file of command line options, each line in optionName=optionValue format|命令行参数配置文件|
|-rack|string|current volume server's rack name|当前卷服务器所属机架|
|-s3|-|whether to start S3 gateway|是否启动S3兼容网关|
|-s3.allowDeleteBucketNotEmpty|-|allow recursive deleting all entries along with bucket (default true)|S3允许删除非空存储桶（默认值：true）|
|-s3.allowEmptyFolder|-|deprecated, ignored. Empty folder cleanup is now automatic. (default true)|已废弃，自动清理空文件夹|
|-s3.allowedOrigins|string|comma separated list of allowed origins (default "*")|S3允许的跨域来源（默认值：*）|
|-s3.auditLogConfig|string|path to the audit log config file|S3审计日志配置文件|
|-s3.cacert.file|string|path to the TLS CA certificate file|S3的TLS CA证书路径|
|-s3.cert.file|string|path to the TLS certificate file|S3的TLS证书路径|
|-s3.concurrentFileUploadLimit|int|limit number of concurrent file uploads for S3, 0 means unlimited|S3并发上传数量限制|
|-s3.concurrentUploadLimitMB|int|limit total concurrent upload size for S3, 0 means unlimited|S3并发上传总大小限制|
|-s3.config|string|path to the config file|S3配置文件路径|
|-s3.domainName|string|suffix of the host name in comma separated list, {bucket}.{domainName}|S3域名后缀|
|-s3.encryptVolumeData|-|encrypt data on volume servers for S3 uploads|S3上传加密卷数据|
|-s3.iam|-|enable embedded IAM API on the same S3 port (default true)|S3端口启用IAM（默认值：true）|
|-s3.iam.config|string|path to the advanced IAM config file for S3. Overrides -iam.config if both are provided.|S3 IAM高级配置（覆盖-iam.config）|
|-s3.iam.readOnly|-|disable IAM write operations on this server (default true)|S3 IAM只读模式（默认值：true）|
|-s3.idleTimeout|int|connection idle seconds (default 120)|S3连接空闲超时（秒，默认值：120）|
|-s3.ip.bind|string|ip address to bind to. If empty, default to same as -ip.bind option.|S3绑定IP|
|-s3.key.file|string|path to the TLS private key file|S3的TLS私钥路径|
|-s3.localSocket|string|default to /tmp/seaweedfs-s3-<port>.sock|S3本地套接字路径|
|-s3.port|int|s3 server http listen port (default 8333)|S3服务HTTP端口（默认值：8333）|
|-s3.port.grpc|int|s3 server grpc listen port|S3服务gRPC端口|
|-s3.port.https|int|s3 server https listen port|S3服务HTTPS端口|
|-s3.port.iceberg|int|Iceberg REST Catalog server listen port (0 to disable) (default 8181)|S3 Iceberg服务端口（默认值：8181）|
|-s3.tlsVerifyClientCert|-|whether to verify the client's certificate|S3校验客户端证书|
|-sftp|-|whether to start Sftp server|是否启动SFTP服务|
|-sftp.authMethods|string|comma-separated list of allowed auth methods: password, publickey, keyboard-interactive (default "password,publickey")|SFTP认证方式（默认：密码+公钥）|
|-sftp.bannerMessage|string|message displayed before authentication (default "SeaweedFS SFTP Server - Unauthorized access is prohibited")|SFTP登录提示信息|
|-sftp.clientAliveCountMax|int|maximum number of missed keep-alive messages before disconnecting (default 3)|SFTP最大心跳丢失次数|
|-sftp.clientAliveInterval|duration|interval for sending keep-alive messages (default 5s)|SFTP心跳间隔|
|-sftp.hostKeysFolder|string|path to folder containing SSH private key files for host authentication|SFTP主机密钥文件夹|
|-sftp.localSocket|string|default to /tmp/seaweedfs-sftp-<port>.sock|SFTP本地套接字路径|
|-sftp.loginGraceTime|duration|timeout for authentication (default 2m0s)|SFTP认证超时|
|-sftp.maxAuthTries|int|maximum number of authentication attempts per connection (default 6)|SFTP最大认证次数|
|-sftp.port|int|SFTP server listen port (default 2022)|SFTP服务端口（默认值：2022）|
|-sftp.sshPrivateKey|string|path to the SSH private key file for host authentication|SFTP主机私钥路径|
|-sftp.userStoreFile|string|path to JSON file containing user credentials and permissions|SFTP用户权限配置文件|
|-volume|-|whether to start volume server (default true)|是否启动Volume卷服务（默认值：true）|
|-volume.compactionMBps|int|limit compaction speed in mega bytes per second|卷后台压缩速度限制|
|-volume.concurrentDownloadLimitMB|int|limit total concurrent download size, 0 means unlimited|卷并发下载总大小限制|
|-volume.concurrentUploadLimitMB|int|limit total concurrent upload size, 0 means unlimited|卷并发上传总大小限制|
|-volume.dir.idx|string|directory to store .idx files|卷索引文件(.idx)存储目录|
|-volume.disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|卷存储介质类型|
|-volume.fileSizeLimitMB|int|limit file size to avoid out of memory (default 256)|卷单文件大小限制（默认值：256MB）|
|-volume.hasSlowRead|-|<experimental> if true, this prevents slow reads from blocking other requests, but large file read P99 latency will increase. (default true)|实验性：防止慢读阻塞请求（默认值：true）|
|-volume.id|string|volume server id. If empty, default to ip:port|卷服务器ID，默认ip:port|
|-volume.images.fix.orientation|-|Adjust jpg orientation when uploading.|上传JPG自动校正方向|
|-volume.index|string|Choose [memory\|leveldb\|leveldbMedium\|leveldbLarge] mode for memory~performance balance. (default "memory")|卷索引模式（默认：memory）|
|-volume.index.leveldbTimeout|int|alive time for leveldb (default to 0). If leveldb of volume is not accessed in ldbTimeout hours, it will be off loaded to reduce opened files and memory consumption.|LevelDB索引超时卸载时间|
|-volume.inflightDownloadDataTimeout|duration|inflight download data wait timeout of volume servers (default 1m0s)|卷下载等待超时|
|-volume.inflightUploadDataTimeout|duration|inflight upload data wait timeout of volume servers (default 1m0s)|卷上传等待超时|
|-volume.maintenanceMBps|int|limit maintenance (replication / balance) IO rate in MB/s. Unset is 0, no limitation.|卷维护（副本/均衡）IO限速|
|-volume.max|string|maximum numbers of volumes, count[,count]... If set to zero, the limit will be auto configured as free disk space divided by volume size. (default "8")|最大卷数量（默认值：8）|
|-volume.minFreeSpace|string|min free disk space (value<=100 as percentage like 1, other as human readable bytes, like 10GiB). Low disk space will mark all volumes as ReadOnly.|卷最小剩余磁盘空间|
|-volume.minFreeSpacePercent|string|minimum free disk space (default to 1%). Low disk space will mark all volumes as ReadOnly (deprecated, use minFreeSpace instead). (default "1")|已废弃，使用minFreeSpace替代|
|-volume.port|int|volume server http listen port (default 8080)|卷服务HTTP端口（默认值：8080）|
|-volume.port.grpc|int|volume server grpc listen port|卷服务gRPC端口|
|-volume.port.public|int|volume server public port|卷对外公共端口|
|-volume.pprof|-|enable pprof http handlers. precludes -memprofile and -cpuprofile|启用卷性能分析|
|-volume.preStopSeconds|int|number of seconds between stop send heartbeats and stop volume server (default 10)|卷停止前心跳等待时间|
|-volume.publicUrl|string|publicly accessible address|卷公网访问地址|
|-volume.readBufferSizeMB|int|<experimental> larger values can optimize query performance but will increase some memory usage,Use with hasSlowRead normally (default 4)|实验性：读取缓冲区大小|
|-volume.readMode|string|[local\|proxy\|redirect] how to deal with non-local volume: 'not found\|read in remote node\|redirect volume location'. (default "proxy")|非本地卷读取模式（默认：proxy）|
|-webdav|-|whether to start WebDAV gateway|是否启动WebDAV网关|
|-webdav.cacheCapacityMB|int|local cache capacity in MB|WebDAV本地缓存容量|
|-webdav.cacheDir|string|local cache directory for file chunks (default "/tmp")|WebDAV缓存目录|
|-webdav.cert.file|string|path to the TLS certificate file|WebDAV的TLS证书|
|-webdav.collection|string|collection to create the files|WebDAV数据集|
|-webdav.disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|WebDAV存储介质|
|-webdav.filer.path|string|use this remote path from filer server (default "/")|WebDAV映射的Filer路径|
|-webdav.key.file|string|path to the TLS private key file|WebDAV的TLS私钥|
|-webdav.maxMB|int|split files larger than the limit (default 4)|WebDAV文件分片大小|
|-webdav.port|int|webdav server http listen port (default 7333)|WebDAV服务端口（默认值：7333）|
|-webdav.replication|string|replication to create the files|WebDAV副本策略|
|-whiteList|string|comma separated Ip addresses having write permission. No limit if empty.|写入权限IP白名单|

---

## 功能描述 (Description)

**原文**：  
start both a volume server to provide storage spaces  
and a master server to provide volume=>location mapping service and sequence number of file ids

This is provided as a convenient way to start both volume server and master server.  
The servers acts exactly the same as starting them separately.  
So other volume servers can connect to this master server also.

Optionally, a filer server can be started.  
Also optionally, a S3 gateway can be started.

License file loading order:

1. -license flag path (if provided)
2. SEAWEED_LICENSE environment variable (if set)
3. Standard locations: "./seaweed-license.json", "$HOME/.seaweedfs/seaweed-license.json", "/usr/local/etc/seaweedfs/seaweed-license.json", "/etc/seaweedfs/seaweed-license.json"

**翻译**：  
同时启动**卷服务器**（提供实际存储空间）和**主节点服务器**（管理卷位置映射、分配文件ID）。

这是一键启动SeaweedFS的便捷方式，服务行为与单独启动完全一致，其他卷服务器也可以连接到此主节点。

可**可选启动**：

- Filer文件网关
- S3兼容网关

许可证文件加载优先级：

1. ​`-license`参数指定的路径（若配置）
2. ​`SEAWEED_LICENSE`环境变量（若配置）
3. 标准路径：当前目录 → 家目录 → /usr/local/etc → /etc
