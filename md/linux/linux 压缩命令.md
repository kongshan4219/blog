---
title: "linux 压缩命令"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-14# #lastmod/2024-09-14#

---

在 Linux 系统中，有多种压缩和解压缩命令，常用的包括 `tar`、`gzip`、`bzip2`、`zip` 等。以下是这些命令的详细说明和使用示例：

### 1. `tar` 命令

`tar` 命令用于创建和提取归档文件（tarball），通常与压缩工具（如 `gzip` 或 `bzip2`）结合使用。

#### 创建归档文件

```
tar -cvf archive.tar file1 file2 directory/
```

- `-c`：创建归档文件
- `-v`：显示详细信息
- `-f`：指定归档文件名

#### 提取归档文件

```
tar -xvf archive.tar
```

- `-x`：提取归档文件
- `-v`：显示详细信息
- `-f`：指定归档文件名

#### 创建压缩归档文件（gzip）

```
tar -czvf archive.tar.gz file1 file2 directory/
```

- `-z`：使用 gzip 压缩

#### 提取压缩归档文件（gzip）

```
tar -xzvf archive.tar.gz
```

- `-z`：使用 gzip 解压缩

#### 创建压缩归档文件（bzip2）

```
tar -cjvf archive.tar.bz2 file1 file2 directory/
```

- `-j`：使用 bzip2 压缩

#### 提取压缩归档文件（bzip2）

```
tar -xjvf archive.tar.bz2
```

- `-j`：使用 bzip2 解压缩

### 2. `gzip` 命令

`gzip` 命令用于压缩文件，压缩后的文件扩展名为 `.gz`。

#### 压缩文件

```
gzip file
```

#### 解压缩文件

```
gzip -d file.gz
```

- `-d`：解压缩文件

### 3. `bzip2` 命令

`bzip2` 命令用于压缩文件，压缩后的文件扩展名为 `.bz2`。

#### 压缩文件

```
bzip2 file
```

#### 解压缩文件

```
bzip2 -d file.bz2
```

- `-d`：解压缩文件

### 4. `zip` 命令

`zip` 命令用于创建压缩文件，压缩后的文件扩展名为 `.zip`。

#### 压缩文件

```
zip archive.zip file1 file2 directory/
```

#### 解压缩文件

```
unzip archive.zip
```

### 5. `unzip` 命令

`unzip` 命令用于解压缩 `.zip` 文件。

#### 解压缩文件

```
unzip archive.zip
```

### 6. `xz` 命令

`xz` 命令用于压缩文件，压缩后的文件扩展名为 `.xz`。

#### 压缩文件

```
xz file
```

#### 解压缩文件

```
xz -d file.xz
```

- `-d`：解压缩文件

### 总结

通过以上命令，你可以在 Linux 系统中进行文件的压缩和解压缩操作。根据不同的需求，选择合适的命令和参数进行操作。例如，使用 `tar` 命令创建和提取归档文件，使用 `gzip` 或 `bzip2` 进行压缩和解压缩，使用 `zip` 和 `unzip` 处理 `.zip` 文件。
