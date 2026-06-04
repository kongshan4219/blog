---
title: "OpenWrt 系统服务创建笔记（以 ttt HTTP 服务为例）"
date: 2026-06-04
tags: ["linux"]
---

## 一、服务需求背景

- 目标程序：`ttt`​（可执行文件，启动 HTTP 服务，路径为 `/mnt/usb/sda1/ttt/ttt`）
- 核心需求：

  1. 开机自动启动
  2. 程序在自身目录（`/mnt/usb/sda1/ttt`）运行（解决相对路径依赖）
  3. 输出/错误日志重定向到程序目录
  4. 程序异常退出后自动重启
  5. 支持手动启停、状态查看

## 二、服务创建步骤

### 1. 创建服务配置文件

在 `/etc/init.d/`​ 目录下新建服务文件，命名为 `ttt_service`（可自定义，建议与程序关联）：

```bash
vi /etc/init.d/ttt_service
```

### 2. 编写服务脚本内容

将以下代码写入文件，**需根据实际路径调整** **​`TTT_DIR`​**​ **和** **​`TTT_EXE`​**​ **变量**：

```bash
#!/bin/sh /etc/rc.common
# 服务描述：自动启动 ttt HTTP 服务，支持日志重定向与状态检查
# 启动优先级：START=99（确保 USB 设备挂载后启动）
# 停止优先级：STOP=10（优先停止）

START=99
STOP=10

# 配置程序路径（关键！需与实际路径一致）
TTT_DIR="/mnt/usb/sda1/ttt"  # 程序所在目录
TTT_EXE="$TTT_DIR/ttt"       # 可执行程序完整路径
TTT_LOG="$TTT_DIR/ttt.log"   # 日志文件路径（重定向输出用）

# 启动服务
start() {
    echo "Starting ttt HTTP service..."
    # 1. 进入程序目录；2. 重定向输出/错误到日志；3. 后台运行
    (cd $TTT_DIR && $TTT_EXE > $TTT_LOG 2>&1 &)
    
    # 简单重试逻辑：启动后2秒检查，未运行则重试1次
    sleep 2
    if ! pgrep -x "ttt" > /dev/null; then
        echo "ttt service failed to start, retrying..."
        (cd $TTT_DIR && $TTT_EXE > $TTT_LOG 2>&1 &)
    fi
}

# 停止服务
stop() {
    echo "Stopping ttt HTTP service..."
    # 终止所有名为 ttt 的进程（-q 静默模式，无进程时不报错）
    killall -q ttt
}

# 重启服务（先停后启）
restart() {
    stop
    start
}

# 检查服务状态
status() {
    if pgrep -x "ttt" > /dev/null; then
        echo "✅ ttt service is running"
        return 0
    else
        echo "❌ ttt service is not running"
        return 1
    fi
}
```

### 3. 配置服务权限与自启动

#### （1）赋予脚本可执行权限

```bash
chmod +x /etc/init.d/ttt_service
```

#### （2）启用开机自启动

```bash
# 启用自启动（OpenWrt 会自动添加启动项到 rc.d）
/etc/init.d/ttt_service enable
```

## 三、自动重启配置（关键）

通过 `crontab` 定时检查进程状态，异常退出时自动重启：

### 1. 编辑定时任务

```bash
crontab -e
```

### 2. 添加检查规则

在文件末尾添加以下内容（**每2分钟检查1次**，可调整频率）：

```bash
# 格式：分 时 日 月 周 命令（状态非运行则启动）
*/2 * * * * /etc/init.d/ttt_service status || /etc/init.d/ttt_service start
```

- 频率说明：`*/2`​ 表示每2分钟，可改为 `*/1`​（每分钟）、`*/5`（每5分钟）等
- 逻辑说明：`||` 表示“前命令失败时执行后命令”，即服务未运行时自动启动

## 四、服务管理常用命令

|命令|功能|
| ------| --------------------------------|
|​`/etc/init.d/ttt_service start`|手动启动服务|
|​`/etc/init.d/ttt_service stop`|手动停止服务|
|​`/etc/init.d/ttt_service restart`|重启服务|
|​`/etc/init.d/ttt_service status`|查看服务运行状态|
|​`cat /mnt/usb/sda1/ttt/ttt.log`|查看程序输出日志（排查错误用）|

## 五、注意事项

1. **USB 挂载延迟问题**：  
   若程序依赖 USB 设备（如本例中 `ttt`​ 在 `/mnt/usb`​ 下），需确保服务启动时 USB 已挂载，`START=99`​（高优先级，晚启动）可规避此问题；若仍启动失败，可在 `start()`​ 函数中添加延迟（如 `sleep 10 && cd $TTT_DIR...`）。
2. **程序权限问题**：  
   确保 `ttt`​ 可执行：`chmod +x /mnt/usb/sda1/ttt/ttt`。
3. **日志排查**：  
   若服务启动失败，优先查看日志 `ttt.log`，定位错误（如路径错误、依赖缺失等）。
4. **取消自启动**：  
   若需禁用服务，执行 `/etc/init.d/ttt_service disable`​，并删除 `crontab` 中的检查规则。

‍

‍

### 新脚本模板,不一定好

```bash
#!/bin/sh /etc/rc.common
# 通用服务脚本模板
# 用于管理任何程序的启动、停止、重启和状态检查

# 配置服务参数 - 根据实际情况修改以下变量
##############################################
SERVICE_NAME="my_service"          # 服务名称（用于标识）
SERVICE_DESC="General service template"  # 服务描述

# 启动/停止优先级
START=99
STOP=10

# 程序路径配置
APP_DIR="/path/to/application"     # 程序所在目录
APP_EXE="$APP_DIR/executable"      # 可执行程序完整路径
APP_LOG="$APP_DIR/service.log"     # 日志文件路径
APP_ARGS=""                        # 程序启动参数（可选）
##############################################

# 启动服务
start() {
    echo "Starting $SERVICE_NAME..."
    
    # 检查目录是否存在
    if [ ! -d "$APP_DIR" ]; then
        echo "Error: Directory $APP_DIR does not exist"
        return 1
    fi
    
    # 检查可执行文件是否存在且可执行
    if [ ! -x "$APP_EXE" ]; then
        echo "Error: Executable $APP_EXE not found or not executable"
        return 1
    fi
    
    # 启动程序并将输出重定向到日志
    (cd "$APP_DIR" && "$APP_EXE" $APP_ARGS >> "$APP_LOG" 2>&1 &)
    
    # 检查启动状态并在需要时重试
    sleep 2
    if ! is_running; then
        echo "$SERVICE_NAME failed to start, retrying..."
        (cd "$APP_DIR" && "$APP_EXE" $APP_ARGS >> "$APP_LOG" 2>&1 &)
    fi
}

# 停止服务
stop() {
    echo "Stopping $SERVICE_NAME..."
    
    if is_running; then
        # 尝试正常终止
        pkill -x "$(basename "$APP_EXE")"
        sleep 2
        
        # 如果仍在运行，强制终止
        if is_running; then
            echo "Force stopping $SERVICE_NAME..."
            pkill -x -9 "$(basename "$APP_EXE")"
        fi
    else
        echo "$SERVICE_NAME is not running"
    fi
}

# 重启服务
restart() {
    stop
    sleep 1
    start
}

# 检查服务状态
status() {
    if is_running; then
        echo "✅ $SERVICE_NAME is running"
        return 0
    else
        echo "❌ $SERVICE_NAME is not running"
        return 1
    fi
}

# 内部函数：检查程序是否正在运行
is_running() {
    pgrep -x "$(basename "$APP_EXE")" > /dev/null
}

```
