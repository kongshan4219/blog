---
title: "常用的 ADB（Android Debug Bridge）命令"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-10-27 17:12:37# #lastmod/2024-10-27 17:12:37#

---

# 常用的 ADB（Android Debug Bridge）命令

以下是一些常用的 ADB（Android Debug Bridge）命令，涵盖设备连接、文件操作、应用管理、设备信息获取等方面：

### 一、设备管理

1. **列出已连接设备**

   ```bash
   adb devices
   ```

   显示所有连接的 Android 设备及其状态。
2. **连接设备**

   ```bash
   adb connect <设备IP地址>:<端口号>
   ```

   在无线模式下，通过 IP 地址连接设备（默认端口为 `5555`）。
3. **断开设备连接**

   ```bash
   adb disconnect <设备IP地址>
   ```

   断开与指定设备的连接。
4. **重启设备**

   ```bash
   adb reboot
   ```

   将设备重启。
5. **进入恢复模式**

   ```bash
   adb reboot recovery
   ```
6. **进入引导加载模式**

   ```bash
   adb reboot bootloader
   ```

### 二、文件操作

1. **推送文件到设备**

   ```bash
   adb push <本地文件路径> <设备文件路径>
   ```

   将本地文件传输到设备指定位置。
2. **从设备拉取文件**

   ```bash
   adb pull <设备文件路径> <本地文件路径>
   ```

   从设备拉取文件到本地路径。

### 三、应用管理

1. **安装 APK**

   ```bash
   adb install <APK文件路径>
   ```

   将 APK 文件安装到设备。
2. **卸载应用**

   ```bash
   adb uninstall <包名>
   ```

   卸载指定包名的应用。
3. **更新安装（保留数据）**

   ```bash
   adb install -r <APK文件路径>
   ```

   通过 `-r` 选项更新应用并保留用户数据。
4. **清除应用数据**

   ```bash
   adb shell pm clear <包名>
   ```

   清除指定应用的数据和缓存。

### 四、设备信息获取

1. **获取设备的系统日志**

   ```bash
   adb logcat
   ```

   显示设备的系统日志，常用于调试。
2. **查看设备的硬件信息**

   ```bash
   adb shell getprop
   ```

   获取设备的系统和硬件信息。
3. **获取设备的当前活动信息**

   ```bash
   adb shell dumpsys activity
   ```

   显示当前活动的应用和服务信息。
4. **查看电池信息**

   ```bash
   adb shell dumpsys battery
   ```

   获取设备的电池状态信息。

### 五、屏幕操作

1. **截取屏幕截图**

   ```bash
   adb shell screencap -p /sdcard/screenshot.png
   adb pull /sdcard/screenshot.png <本地路径>
   ```

   将截图保存到设备，并将其传输到本地。
2. **录制屏幕**

   ```bash
   adb shell screenrecord /sdcard/screenrecord.mp4
   adb pull /sdcard/screenrecord.mp4 <本地路径>
   ```

   录制设备屏幕，保存并拉取到本地。

### 六、其他命令

1. **输入文本**

   ```bash
   adb shell input text '<文本内容>'
   ```

   向设备输入文本内容。
2. **模拟按键**

   ```bash
   adb shell input keyevent <键值>
   ```

   模拟设备的按键操作，例如 `adb shell input keyevent 26`（电源键），`adb shell input keyevent 3`（主页键）。
3. **停止应用**

   ```bash
   adb shell am force-stop <包名>
   ```

   强制停止指定应用。

### 七、网络操作

1. **端口转发**

   ```bash
   adb forward tcp:<本地端口> tcp:<设备端口>
   ```

   将本地端口转发到设备的指定端口上。
2. **查看 WiFi IP 地址**

   ```bash
   adb shell ip addr show wlan0
   ```

   获取设备连接的 WiFi 网络 IP 地址。

根据输出内容，你的 ADB 已成功连接到一个 Android 模拟器设备，设备 ID 为 `emulator-5554`，状态为 `device`，表示已连接且可用。接下来你可以执行其他 ADB 命令来与设备进行交互。

例如：

1. **查看设备信息**：

   ```bash
   adb -s emulator-5554 shell getprop
   ```

   获取该设备的详细系统和硬件信息。
2. **安装 APK 文件**：

   ```bash
   adb -s emulator-5554 install <APK文件路径>
   ```

   将应用安装到该模拟器。
3. **执行屏幕截图**：

   ```bash
   adb -s emulator-5554 shell screencap -p /sdcard/screenshot.png
   adb -s emulator-5554 pull /sdcard/screenshot.png ./
   ```

   截图并下载到本地路径。
4. **查看设备日志**：

   ```bash
   adb -s emulator-5554 logcat
   ```

   实时查看该设备的系统日志。

使用设备 ID 参数（`-s emulator-5554`）可以确保命令应用于此模拟器设备，避免在多个设备连接时的冲突。
