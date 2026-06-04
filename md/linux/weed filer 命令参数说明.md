---
title: "weed filer 命令参数说明"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed filer` 命令参数说明

本文档完整保留 `weed filer -help`​ 命令的**英文原文**，并补充**精准中文翻译**，适配SeaweedFS官方术语，方便查阅使用。

## 命令示例 (Example)

**原文**：Example: weed filer -port=8888 -master=<ip:port>[,<ip:port>]*  
**翻译**：示例：weed filer -port=8888 -master=[主节点IP:端口](%E4%B8%BB%E8%8A%82%E7%82%B9IP:%E7%AB%AF%E5%8F%A3)[,[主节点IP:端口](%E4%B8%BB%E8%8A%82%E7%82%B9IP:%E7%AB%AF%E5%8F%A3)]*

## 默认用法参数 (Default Usage)

|参数名|参数类型|英文描述|中文翻译|
| -------------------------------| ----------| ------------------------------------------------------------------------------------------------------------------------------------------| -----------------------------------------------------------------------|
|-allowedOrigins|string|comma separated list of allowed origins (default "*")|允许的跨域来源列表（逗号分隔，默认值：* 允许所有）|
|-collection|string|all data will be stored in this default collection|所有数据默认存储的数据集名称|
|-concurrentFileUploadLimit|int|limit number of concurrent file uploads, 0 means unlimited|并发文件上传数量限制，0表示无限制|
|-concurrentUploadLimitMB|int|limit total concurrent upload size, 0 means unlimited|并发上传总大小限制（MB），0表示无限制|
|-dataCenter|string|prefer to read and write to volumes in this data center|优先读写该数据中心内的存储卷|
|-debug|-|serves runtime profiling data, e.g., http://localhost:<debug.port>/debug/pprof/goroutine?debug=2|提供运行时性能分析数据|
|-debug.port|int|http port for debugging (default 6060)|调试用HTTP端口（默认值：6060）|
|-defaultReplicaPlacement|string|default replication type. If not specified, use master setting.|默认副本策略，未指定则沿用主节点配置|
|-defaultStoreDir|string|if filer.toml is empty, use an embedded filer store in the directory (default ".")|无filer.toml时，嵌入式元数据存储目录（默认值：当前目录）|
|-dirListLimit|int|limit sub dir listing size (default 100000)|子目录列表数量上限（默认值：100000）|
|-disableDirListing|-|turn off directory listing|禁用目录列表展示|
|-disableHttp|-|disable http request, only gRpc operations are allowed|禁用HTTP请求，仅允许gRPC操作|
|-disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|存储介质类型：硬盘/固态硬盘/自定义标签|
|-downloadMaxMBps|int|download max speed for each download request, in MB per second|单请求下载最大速度（MB/秒）|
|-encryptVolumeData|-|encrypt data on volume servers|对存储卷服务器上的数据进行加密|
|-exposeDirectoryData|-|whether to return directory metadata and content in Filer UI (default true)|是否在Filer界面返回目录元数据和内容（默认值：true）|
|-filerGroup|string|share metadata with other filers in the same filerGroup|同组Filer节点共享元数据|
|-iam|-|whether to start IAM service|是否启动身份访问管理（IAM）服务|
|-iam.ip|string|iam server http listen ip address (default "192.168.254.253")|IAM服务监听IP（默认值：192.168.254.253）|
|-iam.port|int|iam server http listen port (default 8111)|IAM服务监听端口（默认值：8111）|
|-ip|string|filer server http listen ip address (default "192.168.254.253")|Filer服务监听IP（默认值：192.168.254.253）|
|-ip.bind|string|ip address to bind to. If empty, default to same as -ip option.|绑定的IP地址，为空则默认与-ip一致|
|-localSocket|string|default to /tmp/seaweedfs-filer-<port>.sock|Unix本地套接字路径（默认值：/tmp/seaweedfs-filer-<端口>.sock）|
|-master|string|comma-separated master servers or a single DNS SRV record of at least 1 master server, prepended with dnssrv+ (default "localhost:9333")|主节点地址列表（逗号分隔），支持DNS SRV解析（默认值：localhost:9333）|
|-maxMB|int|split files larger than the limit (default 4)|超过该大小的文件自动分片（MB，默认值：4）|
|-metricsIp|string|metrics listen ip. If empty, default to same as -ip.bind option.|监控指标监听IP，为空则默认与-ip.bind一致|
|-metricsPort|int|Prometheus metrics listen port|Prometheus监控指标监听端口|
|-options|string|a file of command line options, each line in optionName=optionValue format|命令行参数配置文件，格式：参数名=参数值|
|-port|int|filer server http listen port (default 8888)|Filer服务HTTP监听端口（默认值：8888）|
|-port.grpc|int|filer server grpc listen port|Filer服务gRPC监听端口|
|-port.readonly|int|readonly port opened to public|对外开放的只读端口|
|-rack|string|prefer to write to volumes in this rack|优先写入该机架内的存储卷|
|-s3|-|whether to start S3 gateway|是否启动S3兼容网关|
|-s3.allowDeleteBucketNotEmpty|-|allow recursive deleting all entries along with bucket (default true)|允许删除非空存储桶（递归删除，默认值：true）|
|-s3.allowEmptyFolder|-|deprecated, ignored. Empty folder cleanup is now automatic. (default true)|已废弃，自动清理空文件夹|
|-s3.allowedOrigins|string|comma separated list of allowed origins (default "*")|S3网关允许的跨域来源（默认值：*）|
|-s3.auditLogConfig|string|path to the audit log config file|S3审计日志配置文件路径|
|-s3.cacert.file|string|path to the TLS CA certificate file|S3 TLS CA证书文件路径|
|-s3.cert.file|string|path to the TLS certificate file|S3 TLS证书文件路径|
|-s3.concurrentFileUploadLimit|int|limit number of concurrent file uploads for S3, 0 means unlimited|S3并发文件上传数量限制，0无限制|
|-s3.concurrentUploadLimitMB|int|limit total concurrent upload size for S3, 0 means unlimited|S3并发上传总大小限制，0无限制|
|-s3.config|string|path to the config file|S3配置文件路径|
|-s3.dataCenter|string|prefer to read and write to volumes in this data center|S3优先读写该数据中心的存储卷|
|-s3.domainName|string|suffix of the host name in comma separated list, {bucket}.{domainName}|S3域名后缀，格式：存储桶.域名|
|-s3.encryptVolumeData|-|encrypt data on volume servers for S3 uploads|S3上传数据时加密存储卷数据|
|-s3.iam|-|enable embedded IAM API on the same S3 port (default true)|在S3端口启用内置IAM接口（默认值：true）|
|-s3.iam.config|string|path to the advanced IAM config file|S3高级IAM配置文件路径|
|-s3.iam.readOnly|-|disable IAM write operations on this server (default true)|禁用IAM写入操作（默认值：true）|
|-s3.idleTimeout|int|connection idle seconds (default 120)|S3连接空闲超时时间（秒，默认值：120）|
|-s3.ip.bind|string|ip address to bind to. If empty, default to same as -ip.bind option.|S3绑定IP，为空则默认与-ip.bind一致|
|-s3.key.file|string|path to the TLS private key file|S3 TLS私钥文件路径|
|-s3.localSocket|string|default to /tmp/seaweedfs-s3-<port>.sock|S3本地套接字路径|
|-s3.metricsIp|string|metrics listen ip. If empty, default to same as -s3.ip.bind option.|S3监控IP，为空则默认与-s3.ip.bind一致|
|-s3.metricsPort|int|Prometheus metrics listen port|S3监控指标监听端口|
|-s3.port|int|s3 server http listen port (default 8333)|S3服务HTTP端口（默认值：8333）|
|-s3.port.grpc|int|s3 server grpc listen port|S3服务gRPC端口|
|-s3.port.https|int|s3 server https listen port|S3服务HTTPS端口|
|-s3.port.iceberg|int|Iceberg REST Catalog server listen port (0 to disable) (default 8181)|Iceberg目录服务端口（0禁用，默认值：8181）|
|-s3.tlsVerifyClientCert|-|whether to verify the client's certificate|是否校验客户端TLS证书|
|-saveToFilerLimit|int|files smaller than this limit will be saved in filer store|小于该值的文件直接存储在Filer元数据中|
|-sftp|-|whether to start the SFTP server|是否启动SFTP文件服务器|
|-sftp.authMethods|string|comma-separated list of allowed auth methods: password, publickey, keyboard-interactive (default "password,publickey")|SFTP认证方式（默认值：密码+公钥）|
|-sftp.bannerMessage|string|message displayed before authentication (default "SeaweedFS SFTP Server - Unauthorized access is prohibited")|SFTP认证前提示信息|
|-sftp.clientAliveCountMax|int|maximum number of missed keep-alive messages before disconnecting (default 3)|SFTP最大心跳丢失次数（默认值：3）|
|-sftp.clientAliveInterval|duration|interval for sending keep-alive messages (default 5s)|SFTP心跳发送间隔（默认值：5秒）|
|-sftp.dataCenter|string|prefer to read and write to volumes in this data center|SFTP优先读写该数据中心的存储卷|
|-sftp.hostKeysFolder|string|path to folder containing SSH private key files for host authentication|SFTP SSH主机密钥文件夹路径|
|-sftp.ip.bind|string|ip address to bind to. If empty, default to same as -ip.bind option.|SFTP绑定IP，为空则默认与-ip.bind一致|
|-sftp.localSocket|string|default to /tmp/seaweedfs-sftp-<port>.sock|SFTP本地套接字路径|
|-sftp.loginGraceTime|duration|timeout for authentication (default 2m0s)|SFTP认证超时时间（默认值：2分钟）|
|-sftp.maxAuthTries|int|maximum number of authentication attempts per connection (default 6)|SFTP单连接最大认证次数（默认值：6）|
|-sftp.port|int|SFTP server listen port (default 2022)|SFTP服务端口（默认值：2022）|
|-sftp.sshPrivateKey|string|path to the SSH private key file for host authentication|SFTP SSH私钥文件路径|
|-sftp.userStoreFile|string|path to JSON file containing user credentials and permissions|SFTP用户权限配置文件路径|
|-tusBasePath|string|TUS resumable upload endpoint base path (e.g., /.tus) (default "/.tus")|TUS断点续传接口根路径（默认值：/.tus）|
|-ui.deleteDir|-|enable filer UI show delete directory button (default true)|Filer界面显示删除目录按钮（默认值：true）|
|-webdav|-|whether to start webdav gateway|是否启动WebDAV网关|
|-webdav.cacheCapacityMB|int|local cache capacity in MB|WebDAV本地缓存容量（MB）|
|-webdav.cacheDir|string|local cache directory for file chunks (default "/tmp")|WebDAV文件分片缓存目录（默认值：/tmp）|
|-webdav.cert.file|string|path to the TLS certificate file|WebDAV TLS证书路径|
|-webdav.collection|string|collection to create the files|WebDAV文件存储的数据集|
|-webdav.disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|WebDAV存储介质类型|
|-webdav.filer.path|string|use this remote path from filer server (default "/")|WebDAV映射的Filer远程路径（默认值：根目录）|
|-webdav.key.file|string|path to the TLS private key file|WebDAV TLS私钥路径|
|-webdav.maxMB|int|split files larger than the limit (default 4)|WebDAV文件分片大小上限（MB，默认值：4）|
|-webdav.port|int|webdav server http listen port (default 7333)|WebDAV服务端口（默认值：7333）|
|-webdav.replication|string|replication to create the files|WebDAV文件副本策略|

---

## 功能描述 (Description)

**原文**：  
start a file server which accepts REST operation for any files.

//create or overwrite the file, the directories /path/to will be automatically created  
POST /path/to/file  
//get the file content  
GET /path/to/file  
//create or overwrite the file, the filename in the multipart request will be used  
POST /path/to/  
//return a json format subdirectory and files listing  
GET /path/to/

The configuration file "filer.toml" is read from ".", "$HOME/.seaweedfs/", "/usr/local/etc/seaweedfs/", or "/etc/seaweedfs/", in that order.  
If the "filer.toml" is not found, an embedded filer store will be created under "-defaultStoreDir".

The example filer.toml configuration file can be generated by "weed scaffold -config=filer"

**翻译**：  
启动文件网关服务，支持通过REST接口管理任意文件。

// 创建或覆盖文件，自动创建父目录 /path/to  
POST /path/to/file  
// 获取文件内容  
GET /path/to/file  
// 创建或覆盖文件，使用请求中的文件名  
POST /path/to/  
// 返回JSON格式的子目录和文件列表  
GET /path/to/

程序按以下顺序读取 `filer.toml` 配置文件：  
当前目录 → 用户家目录/.seaweedfs/ → /usr/local/etc/seaweedfs/ → /etc/seaweedfs/

若未找到配置文件，会在 `-defaultStoreDir` 指定目录下创建嵌入式元数据存储。

可通过命令 `weed scaffold -config=filer`​ 生成 `filer.toml` 配置文件示例。

---

## 支持的Filer元数据存储引擎 (Supported Filer Stores)

**原文**：  
arangodb  
cassandra  
cassandra2  
etcd  
hbase  
leveldb  
leveldb2  
leveldb3  
mongodb  
mysql  
mysql2  
postgres  
postgres2  
redis  
redis2  
redis2_sentinel  
redis3  
redis3_sentinel  
redis_cluster  
redis_cluster2  
redis_cluster3

**翻译**：  
SeaweedFS Filer支持的元数据存储后端：  
ArangoDB、Cassandra、ETCD、HBase、LevelDB、MongoDB、MySQL、PostgreSQL、Redis（单机/哨兵/集群）
