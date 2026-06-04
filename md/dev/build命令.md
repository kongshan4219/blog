---
title: "build命令"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-10-13 22:01:43# #lastmod/2024-10-13 22:01:43#

---

# build命令

## 目录结构

~~~powershell
C:\MyApplication\Work\Projects\go\hexo_util>
│  go.mod
│  go.sum
│  main.go
│
├─git-commit-push
│      git-commit-push.go
│
├─init-time
│      init-time.go
│
└─update-time
        update-time
        update-time.go
~~~

## 构建主应用程序

假设 `main.go` 是主应用程序的入口：

```powershell
go build -o hexo_util.exe main.go
```

**跨平台构建示例**

构建适用于不同操作系统和架构的二进制文件：

```powershell
# 构建 Windows 64位
$env:GOOS = "windows"
$env:GOARCH = "amd64"
$env:CGO_ENABLED = "0"
go build -o hexo_util_windows_amd64.exe main.go

# 构建 Linux 64位
$env:GOOS = "linux"
$env:GOARCH = "amd64"
$env:CGO_ENABLED = "0"
go build -o hexo_util_linux_amd64 main.go

# 构建 macOS 64位
$env:GOOS = "darwin"
$env:GOARCH = "amd64"
$env:CGO_ENABLED = "0"
go build -o hexo_util_darwin_amd64 main.go
```

## 构建子模块

对于每个子目录，导航到该目录并运行 `go build` 命令：

```powershell
# 构建 git-commit-push
cd git-commit-push
go build -o git-commit-push.exe git-commit-push.go

# 构建 init-time
cd ..\init-time
go build -o init-time.exe init-time.go

# 构建 update-time
cd ..\update-time
go build -o update-time.exe update-time.go
```
