---
title: "Windows环境快速搭建"
date: 2026-06-04
tags: ["windows"]
---

#date/2024-10-24 15:36:33# #lastmod/2024-10-24 15:36:33#

---

# Windows 环境快速搭建

- 所有软件都尽量使用便携版，方便后续数据转移
- 软件安装路径原则

  - 所有软件尽量安装在 D 盘 Application `D:\Application` 目录下。(无法选择安装路径的软件除外，如 chrome)
  - Application 目录结构

    ~~~mermaid
    graph LR
        A[Application]
        A --> B[Tool]
        A --> C[Develop]
        A --> D[等等]
    ~~~

    Tool：常用的工具类软件如 clash，7z 等

    Develop：开发用软件，如 VScode、JetBrains 全家桶、Git、pyenv 等
- 下载内容需要及时清理

  - 如下载的便携版的软件 zip 压缩包等，安装配置完成后及时删除原压缩包

## Windows 软件目录

## 配置 PowerShell 7

1. 从 [PowerShell 的 git 仓库](https://github.com/PowerShell/PowerShell/releases) 下载 `win-x64.zip`
2. 解压到 `D:\Application\Develop\PowerShell`
3. 将 PowerShell 7 的路径（即 `D:\Application\Develop\PowerShell`）添加到系统环境变量 Path 列表中。
4. 配置 Windows Terminal 添加 PowerShell 7 配置项

   1. 打开 Windows Terminal。
   2. 点击右上角下拉菜单，选择“设置”。
   3. 在左侧“配置文件”中，点击“添加新配置文件”并命名为“PowerShell 7”。
   4. 在配置中找到  **"commandline"**  项，将其值设为以下路径：

      ```
      "commandline": "D:\\Application\\Develop\\PowerShell\\pwsh.exe"
      ```

      设置图标（可选）：你可以设置  **"icon"**  项，路径可以是 PowerShell 图标的文件位置，例如：

      ```
      "icon": "D:\\Application\\Develop\\PowerShell\\assets\\icon.png"
      ```

      设置起始目录（可选）：如果希望 PowerShell 7 启动时进入特定目录

## Win11 切换经典右键菜单

cmd 执行

Win11 切换经典右键菜单：

```cmd
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
taskkill /f /im explorer.exe & start explorer.exe
```

Win11 恢复回新右键菜单：

```cmd
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
taskkill /f /im explorer.exe & start explorer.exe 
```

## 配置微软账户自动登录 windows

1. 打开注册表，浏览到路径：

   ~~~
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
   ~~~
2. 在 Winlogon 下修改 AutoAdminLogon **字符串值**（如果没有就新建），将值设置为

   - `0` 禁用自动登录
   - `1` 启用自动登录
3. 修改 `DefaultUserName` 和 `DefaultPassword` 的 **字符串值**（如果没有就新建），将值设置为：

   - `DefaultUserName` 用于微软账户，如邮箱
   - `DefaultPassword` 对应的微软账户密码
4. 注册表更改完成后，重启 Windows 就会生效。

## 修改新内容的保存位置

![image-20241024154302064](https://md.kongseek.com/202410241549625.png)

全部修改为 D 盘之类的

## 配置 git

1. 从 [git 官网]([Git%20-%20Downloading%20Package](https://git-scm.com/downloads/win))下载 Portable 版本的 git，解压到 `D:\Application\Develop\PortableGit`
2. 配置环境变量

   新建系统变量 `GIT_HOME`, 值 `D:\Application\Develop\PortableGit`

   path 新建 `%GIT_HOME%`, `%GIT_HOME%\bin`, `%GIT_HOME%\usr\bin`
3. 配置 git-bash 右键菜单 `Git Bash Here`

   - 添加：

     ~~~powershell
     # 定义 PortableGit 的安装路径
     $gitPath = "D:\Application\Develop\PortableGit"

     # 创建或获取注册表项
     $shellKeyPath = "HKLM:\SOFTWARE\Classes\Directory\Background\shell"
     if (!(Test-Path $shellKeyPath)) {
         $shellKey = New-Item -Path $shellKeyPath -Force
     } else {
         $shellKey = Get-Item -Path $shellKeyPath
     }

     $gitBashKey = New-Item -Path "$($shellKey.PSPath)\open in Git" -Force

     # 设置右键菜单显示名称
     Set-ItemProperty -Path $gitBashKey.PSPath -Name "(Default)" -Value "Git Bash Here"

     # 设置图标
     $iconPath = Join-Path $gitPath "mingw64\share\git\git-for-windows.ico"
     New-ItemProperty -Path $gitBashKey.PSPath -Name "Icon" -PropertyType String -Value $iconPath

     # 设置命令
     $commandKey = New-Item -Path "$($gitBashKey.PSPath)\command" -Force
     $gitBashExe = Join-Path $gitPath "git-bash.exe"
     Set-ItemProperty -Path $commandKey.PSPath -Name "(Default)" -Value "`"$gitBashExe`""

     Write-Host "Git Bash Here has been added to the right-click menu."
     ~~~
   - 删除：

     ~~~powershell
     # 定义要删除的注册表路径
     $gitBashKeyPath = "HKLM:\SOFTWARE\Classes\Directory\Background\shell\open in Git"

     # 检查路径是否存在
     if (Test-Path $gitBashKeyPath) {
         # 删除整个 "open in Git" 键（包括其所有子键）
         Remove-Item -Path $gitBashKeyPath -Recurse -Force
         Write-Host "Git Bash Here has been removed from the right-click menu."
     } else {
         Write-Host "Git Bash Here entry not found in the registry."
     }

     # 可选：检查并删除空的 shell 键
     $shellKeyPath = "HKLM:\SOFTWARE\Classes\Directory\Background\shell"
     if (Test-Path $shellKeyPath) {
         $shellKey = Get-Item -Path $shellKeyPath
         if ($shellKey.SubKeyCount -eq 0 -and $shellKey.ValueCount -eq 0) {
             Remove-Item -Path $shellKeyPath -Force
             Write-Host "Empty shell key removed."
         }
     }
     ~~~
4. 添加登录凭证

   - 在 PortableGit 根目录下创建一个名为.git-credentials 的文件。
   - 在.git-credentials 文件中按以下格式添加凭据:

     ~~~.git-credentials
     https://username:password@github.com
     https://username:password@gitee.com
     ~~~

     替换 username 和 password 为实际 GitHub 和 Gitee 用户名和密码。最好可以使用个人访问令牌(Personal Access Token)代替密码
   - 打开 PortableGit 根目录下的 etc/gitconfig 文件。
   - 在文件中修改 helper 配置:

     ~~~gitconfig
     [credential]
     	# helper = helper-selector
     	helper = store --file=D:/Application/PortableGit/.git-credentials
     ~~~
5. 全局用户名：`空山`
6. 全局邮箱: `2996014561@qq.com`

## 配置 nvm

1. 下载 [no-install.zip](https://github.com/coreybutler/nvm-windows/releases), 解压到 `D:\Application\Develop\nvm`
2. 管理员运行 install.cmd 配置环境变量
3. 常用命令

   ~~~powershell
   nvm list	#查看已经安装的版本
   nvm list installed	#查看已经安装的版本
   nvm list available	#查看网络可以安装的版本
   nvm arch	#查看当前系统的位数和当前nodejs的位数
   nvm install [arch]	#安装制定版本的node 并且可以指定平台 version 版本号 arch 平台
   nvm on	#打开nodejs版本控制
   nvm off	#关闭nodejs版本控制
   nvm proxy [url]	#查看和设置代理
   nvm node_mirror [url]	#设置或者查看setting.txt中的node_mirror，如果不设置的默认是 https://nodejs.org/dist/
   nvm npm_mirror [url]	#设置或者查看setting.txt中的npm_mirror,如果不设置的话默认的是：https://github.com/npm/npm/archive/.
   nvm uninstall	#卸载指定的版本
   nvm use [version] [arch]	#切换指定的node版本和位数
   nvm root [path]	#设置和查看root路径
   nvm version	#查看当前的版本
   ~~~

## 配置 pyenv

1. git 克隆下载 pyenv 到 `D:\Application\Develop\pyenv`

   ~~~powershell
   git clone https://github.com/pyenv-win/pyenv-win.git D:\Application\Develop\pyenv
   ~~~
2. 配置环境变量

   新建系统变量 `PYENV`, 值 `D:\Application\Develop\pyenv\pyenv-win`

   path 新建 `%PYENV%`, `%PYENV%\bin`, `%PYENV%\shims`
3. 常用命令

   ~~~powershell
      commands     List all available pyenv commands
      local        Set or show the local application-specific Python version
      latest       Print the latest installed or known version with the given prefix
      global       Set or show the global Python version
      shell        Set or show the shell-specific Python version
      install      Install 1 or more versions of Python
      uninstall    Uninstall 1 or more versions of Python
      update       Update the cached version DB
      rehash       Rehash pyenv shims (run this after switching Python versions)
      vname        Show the current Python version
      version      Show the current Python version and its origin
      version-name Show the current Python version
      versions     List all Python versions available to pyenv
      exec         Runs an executable by first preparing PATH so that the selected 
                   Python version's `bin' directory is at the front
      which        Display the full path to an executable
      whence       List all Python versions that contain the given executable
   ~~~

## windows 配置 Go 环境(Zip archive 方式)

1. 从 [官网](https://golang.google.cn/dl/) 下载 `go1.23.2.windows-amd64.zip`
2. 解压 `go1.23.2.windows-amd64.zip` 压缩包至 `D:\Application\Develop\go`
3. `GOROOT`：Go 的安装路径（例如：`D:\Application\Develop\go`）
4. `GOPATH`：工作目录（例如：`D:\Application\Develop\Project\Go\OutPut`）
5. `PATH`：追加 `%GOROOT%\bin`

## 配置 JetBrains 全家桶

操作其实都一样，都是修改 `bin` 目录下的 `idea.properties` 文件

### idea

打开 idea 配置文件：`idea安装目录/bin/idea.properties`, 分别查找以下四行

~~~properties
# idea.config.path=${user.home}/.IntelliJIdea/config
# idea.system.path=${user.home}/.IntelliJIdea/system
# idea.plugins.path=${idea.config.path}/plugins
# idea.log.path=${idea.system.path}/log
~~~

取消 `#` 注释，并修改为自定义路径，同时在最上面添加一行

~~~properties
confighome=D:/Application/Develop/JetBrains
idea.config.path=${confighome}/.IntelliJIdea/config
idea.system.path=${confighome}/.IntelliJIdea/system
idea.plugins.path=${idea.config.path}/plugins
idea.log.path=${idea.system.path}/log
~~~

最后还需要配置全局默认的maven信息

### GoLand

打开 GoLand 配置文件：`GoLand安装目录/bin/idea.properties`, 分别查找以下四行

~~~properties
# idea.config.path=${user.home}/.GoLand/config
# idea.system.path=${user.home}/.GoLand/system
# idea.plugins.path=${idea.config.path}/plugins
# idea.log.path=${idea.system.path}/log
~~~

取消 `#` 注释，并修改为自定义路径，同时在最上面添加一行

~~~properties
confighome=D:/Application/Develop/JetBrains
idea.config.path=${confighome}/.GoLand/config
idea.system.path=${confighome}/.GoLand/system
idea.plugins.path=${idea.config.path}/plugins
idea.log.path=${idea.system.path}/log
~~~

### PyCharm

打开 PyCharm 配置文件：`PyCharm安装目录/bin/idea.properties`, 分别查找以下四行

```properties
# idea.config.path=${user.home}/.PyCharm/config
# idea.system.path=${user.home}/.PyCharm/system
# idea.plugins.path=${idea.config.path}/plugins
# idea.log.path=${idea.system.path}/log
```

取消 `#` 注释，并修改为自定义路径，同时在最上面添加一行

```properties
confighome=D:/Application/Develop/JetBrains
idea.config.path=${confighome}/.PyCharm/config
idea.system.path=${confighome}/.PyCharm/system
idea.plugins.path=${idea.config.path}/plugins
idea.log.path=${idea.system.path}/log
```

### 激活

使用 `ja-netfilter` +`https://jbls.ide-soft.com/`

1. 在对应 idea 的 `/bin` 目录下的 `idea64.exe.vmoptions` 文件末尾添加

   ~~~
   --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
   --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

   -javaagent:D:/Application/Tool/ja-netfilter/ja-netfilter.jar
   ~~~
2. 打开 idea，使用 `License server` 激活，在 `License server` 填写 `https://jbls.ide-soft.com/`, 点击激活
