---
title: "weed volume 命令参数说明"
date: 2026-06-04
tags: ["linux"]
---

# SeaweedFS `weed volume` 命令参数说明

本文档完整保留 `weed volume -help`​ 命令的**英文原文**，并补充**精准中文翻译**，严格对齐SeaweedFS官方术语，方便查阅使用。

## 命令示例 (Example)

**原文**：Example: weed volume -port=8080 -dir=/tmp -max=5 -ip=server_name -master=localhost:9333  
**翻译**：示例：weed volume -port=8080 -dir=/tmp -max=5 -ip=服务器名称 -master=localhost:9333

---

## 默认用法参数 (Default Usage)

|参数名|参数类型|英文描述|中文翻译|
| ------------------------------| ----------| -----------------------------------------------------------------------------------------------------------------------------------------------------------------------| ----------------------------------------------------------------------------------|
|-compactionMBps|int|limit background compaction or copying speed in mega bytes per second|限制后台数据压缩/复制速度（MB/秒）|
|-concurrentDownloadLimitMB|int|limit total concurrent download size, 0 means unlimited|并发下载总大小限制（MB），0表示无限制|
|-concurrentUploadLimitMB|int|limit total concurrent upload size, 0 means unlimited|并发上传总大小限制（MB），0表示无限制|
|-cpuprofile|string|cpu profile output file|CPU性能分析输出文件|
|-dataCenter|string|current volume server's data center name|当前卷服务器所属数据中心名称|
|-debug|-|serves runtime profiling data via pprof on the port specified by -debug.port|通过pprof在指定调试端口提供运行时性能分析数据|
|-debug.port|int|http port for debugging (default 6060)|调试用HTTP端口（默认值：6060）|
|-dir|string|directories to store data files. dir[,dir]... (default "/tmp")|数据文件存储目录（支持逗号分隔多目录，默认值：/tmp）|
|-dir.idx|string|directory to store .idx files|.idx索引文件存储目录|
|-disk|string|[hdd\|ssd\|<tag>] hard drive or solid state drive or any tag|存储介质类型：硬盘/固态硬盘/自定义标签|
|-fileSizeLimitMB|int|limit file size to avoid out of memory (default 256)|单文件大小限制，避免内存溢出（默认值：256MB）|
|-hasSlowRead|-|<experimental> if true, this prevents slow reads from blocking other requests, but large file read P99 latency will increase. (default true)|<实验性> 防止慢读阻塞其他请求，但大文件读取P99延迟会增加（默认值：true）|
|-id|string|volume server id. If empty, default to ip:port|卷服务器唯一标识，为空则默认使用ip:port|
|-idleTimeout|int|connection idle seconds (default 30)|连接空闲超时时间（秒，默认值：30）|
|-images.fix.orientation|-|Adjust jpg orientation when uploading.|上传JPG时自动校正图片方向|
|-index|string|Choose [memory\|leveldb\|leveldbMedium\|leveldbLarge] mode for memory~performance balance. (default "memory")|索引存储模式：内存/leveldb系列，平衡性能与内存（默认值：memory）|
|-index.leveldbTimeout|int|alive time for leveldb (default to 0). If leveldb of volume is not accessed in ldbTimeout hours, it will be off loaded to reduce opened files and memory consumption.|leveldb超时时间（小时），长期未访问则卸载以节约资源（默认值：0）|
|-inflightDownloadDataTimeout|duration|inflight download data wait timeout of volume servers (default 1m0s)|下载数据等待超时时间（默认值：1分钟）|
|-inflightUploadDataTimeout|duration|inflight upload data wait timeout of volume servers (default 1m0s)|上传数据等待超时时间（默认值：1分钟）|
|-ip|string|ip or server name, also used as identifier (default "192.168.254.253")|服务器IP/主机名，同时作为节点标识（默认值：192.168.254.253）|
|-ip.bind|string|ip address to bind to. If empty, default to same as -ip option.|绑定的IP地址，为空则默认与-ip一致|
|-maintenanceMBps|int|limit maintenance (replication / balance) IO rate in MB/s. Unset is 0, no limitation.|维护操作（副本/数据均衡）IO速度限制（MB/s），0表示无限制|
|-master|string|comma-separated master servers (default "localhost:9333")|主节点地址列表（逗号分隔，默认值：localhost:9333）|
|-max|string|maximum numbers of volumes, count[,count]... If set to zero, the limit will be auto configured as free disk space divided by volume size. (default "8")|最大卷数量（支持多目录对应配置，默认值：8）；设为0则根据磁盘空间自动计算|
|-memprofile|string|memory profile output file|内存性能分析输出文件|
|-metricsIp|string|metrics listen ip. If empty, default to same as -ip.bind option.|监控指标监听IP，为空则默认与-ip.bind一致|
|-metricsPort|int|Prometheus metrics listen port|Prometheus监控指标监听端口|
|-minFreeSpace|string|min free disk space (value<=100 as percentage like 1, other as human readable bytes, like 10GiB). Low disk space will mark all volumes as ReadOnly.|最小剩余磁盘空间（≤100为百分比，否则为容量，如10GiB）；空间不足时所有卷设为只读|
|-minFreeSpacePercent|string|minimum free disk space (default to 1%). Low disk space will mark all volumes as ReadOnly (deprecated, use minFreeSpace instead). (default "1")|最小剩余空间百分比（已废弃，使用minFreeSpace替代，默认值：1%）|
|-mserver|string|comma-separated master servers (deprecated, use -master instead)|主节点地址（已废弃，使用-master替代）|
|-options|string|a file of command line options, each line in optionName=optionValue format|命令行参数配置文件，每行格式：参数名=参数值|
|-port|int|http listen port (default 8080)|HTTP服务监听端口（默认值：8080）|
|-port.grpc|int|grpc listen port|gRPC服务监听端口|
|-port.public|int|port opened to public|对外开放的公共端口|
|-pprof|-|enable pprof http handlers. precludes -memprofile and -cpuprofile|启用pprof性能分析，会禁用memprofile/cpuprofile|
|-preStopSeconds|int|number of seconds between stop send heartbeats and stop volume server (default 10)|停止心跳到关闭卷服务器的间隔时间（秒，默认值：10）|
|-publicUrl|string|Publicly accessible address|公网可访问地址|
|-rack|string|current volume server's rack name|当前卷服务器所属机架名称|
|-readBufferSizeMB|int|<experimental> larger values can optimize query performance but will increase some memory usage,Use with hasSlowRead normally. (default 4)|<实验性> 读取缓冲区大小（MB），优化查询性能但占用更多内存（默认值：4）|
|-readMode|string|[local\|proxy\|redirect] how to deal with non-local volume: 'not found\|proxy to remote node\|redirect volume location'. (default "proxy")|非本地卷读取模式：返回不存在/代理到远程节点/重定向（默认值：proxy）|
|-whiteList|string|comma separated Ip addresses having write permission. No limit if empty.|拥有写入权限的IP白名单（逗号分隔），为空则无限制|

---

## 功能描述 (Description)

**原文**：start a volume server to provide storage spaces  
**翻译**：启动卷服务器，为SeaweedFS提供实际的文件存储空间

‍
