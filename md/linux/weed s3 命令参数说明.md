---
title: "weed s3 命令参数说明"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed s3` 命令参数说明

本文档完整保留 `weed s3 -help`​ 命令的**英文原文**，并补充**精准中文翻译**，严格对齐SeaweedFS官方术语，方便查阅使用。

## 命令示例 (Example)

**原文**：Example: weed s3 [-port=8333] [-filer=<ip:port>[,<ip:port>]...] [-config=</path/to/config.json>]  
**翻译**：示例：weed s3 [-port=8333] [-filer=[文件网关IP:端口](%E6%96%87%E4%BB%B6%E7%BD%91%E5%85%B3IP:%E7%AB%AF%E5%8F%A3)[,<IP:端口>...]] [-config=</配置文件路径/config.json>]

---

## 默认用法参数 (Default Usage)

|参数名|参数类型|英文描述|中文翻译|
| ----------------------------| ----------| -----------------------------------------------------------------------------------------| -------------------------------------------------------------|
|-allowDeleteBucketNotEmpty|-|allow recursive deleting all entries along with bucket (default true)|允许删除非空存储桶（递归删除所有内容，默认值：true）|
|-allowEmptyFolder|-|deprecated, ignored. Empty folder cleanup is now automatic. (default true)|已废弃，忽略该参数。空文件夹已自动清理（默认值：true）|
|-allowedOrigins|string|comma separated list of allowed origins (default "*")|允许的跨域来源列表（逗号分隔，默认值：* 允许所有）|
|-auditLogConfig|string|path to the audit log config file|审计日志配置文件路径|
|-cacert.file|string|path to the TLS CA certificate file|TLS CA根证书文件路径|
|-cert.file|string|path to the TLS certificate file|TLS服务证书文件路径|
|-concurrentFileUploadLimit|int|limit number of concurrent file uploads, 0 means unlimited|并发文件上传数量限制，0表示无限制|
|-concurrentUploadLimitMB|int|limit total concurrent upload size, 0 means unlimited|并发上传总大小限制（MB），0表示无限制|
|-config|string|path to the config file|S3认证/权限配置文件路径（JSON格式）|
|-dataCenter|string|prefer to read and write to volumes in this data center|优先读写该数据中心内的存储卷|
|-debug|-|serves runtime profiling data via pprof on the port specified by -debug.port|通过pprof在指定端口提供运行时性能分析数据|
|-debug.port|int|http port for debugging (default 6060)|调试用HTTP端口（默认值：6060）|
|-domainName|string|suffix of the host name in comma separated list, {bucket}.{domainName}|域名后缀列表（逗号分隔），格式：{存储桶}.{域名}|
|-encryptVolumeData|-|encrypt data on volume servers|对存储卷服务器上的文件数据进行加密|
|-filer|string|comma-separated filer server addresses for high availability (default "localhost:8888")|高可用文件网关地址列表（逗号分隔，默认值：localhost:8888）|
|-iam|-|enable embedded IAM API on the same port (default true)|在同一端口启用内置IAM身份认证接口（默认值：true）|
|-iam.config|string|path to the advanced IAM config file|高级IAM配置文件路径|
|-iam.readOnly|-|disable IAM write operations on this server (default true)|禁用IAM写入操作（只读模式，默认值：true）|
|-idleTimeout|int|connection idle seconds (default 120)|连接空闲超时时间（秒，默认值：120）|
|-ip.bind|string|ip address to bind to. If empty, default to 0.0.0.0.|服务绑定的IP地址，为空则默认监听所有网卡（0.0.0.0）|
|-key.file|string|path to the TLS private key file|TLS私钥文件路径|
|-localFilerSocket|string|local filer socket path|本地文件网关Unix套接字路径|
|-localSocket|string|default to /tmp/seaweedfs-s3-<port>.sock|本地Unix套接字路径（默认值：/tmp/seaweedfs-s3-<端口>.sock）|
|-metricsIp|string|metrics listen ip. If empty, default to same as -ip.bind option.|监控指标监听IP，为空则默认与-ip.bind一致|
|-metricsPort|int|Prometheus metrics listen port|Prometheus监控指标监听端口|
|-options|string|a file of command line options, each line in optionName=optionValue format|命令行参数配置文件，每行格式：参数名=参数值|
|-port|int|s3 server http listen port (default 8333)|S3服务HTTP监听端口（默认值：8333）|
|-port.grpc|int|s3 server grpc listen port|S3服务gRPC监听端口|
|-port.https|int|s3 server https listen port|S3服务HTTPS监听端口|
|-port.iceberg|int|Iceberg REST Catalog server listen port (0 to disable) (default 8181)|Iceberg数据目录服务监听端口（0为禁用，默认值：8181）|
|-tlsVerifyClientCert|-|whether to verify the client's certificate|是否开启客户端TLS证书校验|

---

## 功能描述 (Description)

**原文**：  
start a s3 API compatible server that is backed by filer(s).

Multiple filer addresses can be specified for high availability, separated by commas.  
The S3 server will automatically failover between filers if one becomes unavailable.

By default, you can use any access key and secret key to access the S3 APIs.  
To enable credential based access, create a config.json file similar to this:

```json
{
  "identities": [
    {
      "name": "anonymous",
      "actions": [
        "Read"
      ]
    },
    {
      "name": "some_admin_user",
      "credentials": [
        {
          "accessKey": "some_access_key1",
          "secretKey": "some_secret_key1"
        }
      ],
      "actions": [
        "Admin",
        "Read",
        "List",
        "Tagging",
        "Write"
      ]
    },
    {
      "name": "some_read_only_user",
      "credentials": [
        {
          "accessKey": "some_access_key2",
          "secretKey": "some_secret_key2"
        }
      ],
      "actions": [
        "Read"
      ]
    },
    {
      "name": "some_normal_user",
      "credentials": [
        {
          "accessKey": "some_access_key3",
          "secretKey": "some_secret_key3"
        }
      ],
      "actions": [
        "Read",
        "List",
        "Tagging",
        "Write"
      ]
    },
    {
      "name": "user_limited_to_bucket1",
      "credentials": [
        {
          "accessKey": "some_access_key4",
          "secretKey": "some_secret_key4"
        }
      ],
      "actions": [
        "Read:bucket1",
        "List:bucket1",
        "Tagging:bucket1",
        "Write:bucket1"
      ]
    }
  ]
}
```

Alternatively, you can use environment variables as fallback admin credentials:

AWS_ACCESS_KEY_ID=your_access_key AWS_SECRET_ACCESS_KEY=your_secret_key weed s3

Environment variables are only used when no S3 configuration file is provided  
and no configuration is available from the filer. This provides a simple way  
to get started without requiring configuration files.

**翻译**：  
启动一个**兼容AWS S3 API**的网关服务，底层依赖SeaweedFS Filer提供存储能力。

可指定多个Filer地址（逗号分隔）实现高可用，当某个Filer节点不可用时，S3服务会**自动故障切换**到其他可用节点。

**默认情况下**，可使用任意Access Key/Secret Key访问S3接口；  
如需开启密钥认证权限控制，可创建类似如下的`config.json`配置文件：

（配置示例：包含匿名用户、管理员、只读用户、普通用户、单存储桶受限用户）

另外，也可以通过**环境变量**设置管理员密钥（简易模式）：

```bash
AWS_ACCESS_KEY_ID=自定义AccessKey AWS_SECRET_ACCESS_KEY=自定义SecretKey weed s3
```

**环境变量仅在以下情况生效**：  
未提供S3配置文件 + Filer中无权限配置  
该方式无需配置文件，适合快速入门测试使用。
