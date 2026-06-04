---
title: "为每个服务器生产一个frpc"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-10-18 21:34:05# #lastmod/2024-10-18 21:34:05#

---

# 为每个服务器生产一个frpc

~~~markdown
- 使用 go 编写程序
- 获取脚本所在目录，并设置 frpc_master_config.yaml 和原始 frpc 可执行文件的路径
- frpc_master_config.yaml 和原始 frpc 可执行文件和脚本在同一目录
- 检查 frpc 可执行文件是否存在，如果不存在则终止脚本。
- 读取 YAML 文件并生成配置
- frpc_master_config.yaml 文件配置如下
```
common:
  log_level: "info"

servers:
  - name: "199"
    server_addr: "服务器ip"
    server_port: 7000
    auth_token: "链接密钥"
    proxies:
      - name: "ssh"
        type: "tcp"
        local_ip: "127.0.0.1"
        local_port: 443
        remote_port: 1443

      - name: "halo"
        type: "tcp"
        local_ip: "127.0.0.1"
        local_port: 8080
        remote_port: 8080

  - name: "aliyun"
    server_addr: "服务器ip"
    server_port: 46959
    auth_token: "链接密钥"
    proxies:
  - name: "aljp"
    server_addr: "服务器ip"
    server_port: 7000
    auth_token: "链接密钥"
    proxies:
      - name: "alist"
        type: "tcp"
        local_ip: "127.0.0.1"
        local_port: 5244
        remote_port: 5244
```
- 遍历 frpc_master_config.yaml 中每个服务器的配置，包括 name、server_addr、server_port 和 auth_token。
- 为每个服务器创建一个目录和 frpc 副本，并赋予可执行权限。
- 生成相应的 .toml 配置文件，包含服务器的代理信息，如代理类型、代理本地和远程端口等。
- .toml 配置文件结构如下
```
serverAddr = "服务器ip"
serverPort = 7000
auth.token = "链接密钥"

[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 443
remotePort = 1443


[[proxies]]
name = "halo"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8080
remotePort = 8080
```
- 生成启动和停止脚本
- 每个服务器的 frpc 副本都会对应一个启动脚本和一个停止脚本，方便用户管理这些 frpc 实例。
- 最后创建启动和停止所有服务器脚本 start_all 和 stop_all 脚本
~~~

~~~go
package main

import (
	"fmt"
	"gopkg.in/yaml.v2"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
)

// Proxy represents a proxy configuration in the YAML file
type Proxy struct {
	Name       string `yaml:"name"`
	Type       string `yaml:"type"`
	LocalIP    string `yaml:"local_ip"`
	LocalPort  int    `yaml:"local_port"`
	RemotePort int    `yaml:"remote_port"`
}

// Server represents a server configuration in the YAML file
type Server struct {
	Name       string  `yaml:"name"`
	ServerAddr string  `yaml:"server_addr"`
	ServerPort int     `yaml:"server_port"`
	AuthToken  string  `yaml:"auth_token"`
	Proxies    []Proxy `yaml:"proxies"`
}

// Config represents the structure of the YAML file
type Config struct {
	Common  map[string]string `yaml:"common"`
	Servers []Server          `yaml:"servers"`
}

// getCurrentDir returns the current script directory
func getCurrentDir() string {
	ex, err := os.Executable()
	if err != nil {
		log.Fatalf("Cannot find executable: %v", err)
	}
	return filepath.Dir(ex)
}

// readConfig reads and parses the YAML configuration file
func readConfig(filePath string) Config {
	configData, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatalf("Failed to read config file: %v", err)
	}

	var config Config
	err = yaml.Unmarshal(configData, &config)
	if err != nil {
		log.Fatalf("Failed to parse YAML: %v", err)
	}
	return config
}

// createServerDirsAndFiles creates the necessary directories and files for each server
func createServerDirsAndFiles(server Server, frpcPath, baseDir string) {
	serverDir := filepath.Join(baseDir, server.Name)
	os.MkdirAll(serverDir, 0755)

	// Copy frpc to the server directory
	frpcDest := filepath.Join(serverDir, "frpc")
	if _, err := copyFile(frpcPath, frpcDest); err != nil {
		log.Fatalf("Failed to copy frpc: %v", err)
	}

	// Set executable permission
	if err := os.Chmod(frpcDest, 0755); err != nil {
		log.Fatalf("Failed to set frpc permissions: %v", err)
	}

	// Generate the .toml file for each server
	tomlContent := fmt.Sprintf(`serverAddr = "%s"
serverPort = %d
auth.token = "%s"
`, server.ServerAddr, server.ServerPort, server.AuthToken)

	for _, proxy := range server.Proxies {
		proxyStr := fmt.Sprintf(`[[proxies]]
name = "%s"
type = "%s"
localIP = "%s"
localPort = %d
remotePort = %d
`, proxy.Name, proxy.Type, proxy.LocalIP, proxy.LocalPort, proxy.RemotePort)
		tomlContent += proxyStr
	}

	tomlFile := filepath.Join(serverDir, "config.toml")
	ioutil.WriteFile(tomlFile, []byte(tomlContent), 0644)
}

// copyFile copies a file from src to dst
func copyFile(src, dst string) (int64, error) {
	sourceFileStat, err := os.Stat(src)
	if err != nil {
		return 0, err
	}

	if !sourceFileStat.Mode().IsRegular() {
		return 0, fmt.Errorf("%s is not a regular file", src)
	}

	source, err := os.Open(src)
	if err != nil {
		return 0, err
	}
	defer source.Close()

	destination, err := os.Create(dst)
	if err != nil {
		return 0, err
	}
	defer destination.Close()
	nBytes, err := io.Copy(destination, source)
	return nBytes, err
}

// generateScripts creates start.sh and stop.sh for each server
func generateScripts(server Server, serverDir string) {
	startScript := fmt.Sprintf(`#!/bin/bash
./frpc -c config.toml
`)
	stopScript := fmt.Sprintf(`#!/bin/bash
pkill -f './frpc -c config.toml'
`)

	ioutil.WriteFile(filepath.Join(serverDir, "start.sh"), []byte(startScript), 0755)
	ioutil.WriteFile(filepath.Join(serverDir, "stop.sh"), []byte(stopScript), 0755)
}

// generateAllScripts creates start_all.sh and stop_all.sh to manage all servers
func generateAllScripts(servers []Server, baseDir string) {
	startAll := "#!/bin/bash\n"
	stopAll := "#!/bin/bash\n"

	for _, server := range servers {
		startAll += fmt.Sprintf("(cd %s && ./start.sh) &\n", server.Name)
		stopAll += fmt.Sprintf("(cd %s && ./stop.sh) &\n", server.Name)
	}

	ioutil.WriteFile(filepath.Join(baseDir, "start_all.sh"), []byte(startAll), 0755)
	ioutil.WriteFile(filepath.Join(baseDir, "stop_all.sh"), []byte(stopAll), 0755)
}

func main() {
	// 获取当前目录和配置路径
	dir := getCurrentDir()
	configPath := filepath.Join(dir, "frpc_master_config.yaml")
	frpcPath := filepath.Join(dir, "frpc")

	// 检查 frpc 文件是否存在
	if _, err := os.Stat(frpcPath); os.IsNotExist(err) {
		log.Fatalf("frpc executable not found: %v", frpcPath)
	}

	// 读取配置文件
	config := readConfig(configPath)

	// 遍历服务器配置并生成文件
	for _, server := range config.Servers {
		createServerDirsAndFiles(server, frpcPath, dir)
		generateScripts(server, filepath.Join(dir, server.Name))
	}

	// 生成启动和停止所有服务器的脚本
	generateAllScripts(config.Servers, dir)
}
~~~

在 Linux 系统中，可以通过 `systemd` 来设置 `start_all.sh` 脚本在系统启动时自动运行。以下是详细步骤：

### 1. 创建 systemd 服务文件

首先，我们需要为 `start_all.sh` 创建一个 `systemd` 服务文件。假设 `start_all.sh` 存放在 `/path/to/your/script/start_all.sh`。

执行以下命令以创建一个新的服务文件：

```
sudo nano /etc/systemd/system/frpc_start_all.service
```

在打开的编辑器中，写入以下内容：

```
ini复制代码[Unit]
Description=Start all FRPC servers at boot
After=network.target

[Service]
ExecStart=/path/to/your/script/start_all.sh
Type=forking
User=your-username
WorkingDirectory=/path/to/your/script/
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### 解释：

- `Description`: 对该服务的简单描述。
- `After=network.target`: 确保在网络服务启动后执行该脚本，因为 FRPC 依赖网络。
- `ExecStart`: 设置启动时执行的命令（`start_all.sh` 的完整路径）。
- `Type=forking`: 由于 `start_all.sh` 脚本会启动后台进程（`frpc`），因此使用 `forking` 类型。
- `User`: 指定运行脚本的用户，将 `your-username` 替换为你的实际用户名。
- `WorkingDirectory`: 设置脚本运行的工作目录。
- `RemainAfterExit=yes`: 确保在脚本完成后服务状态保持激活。

### 2. 重新加载 systemd

保存并退出编辑器后，执行以下命令重新加载 `systemd` 配置：

```
sudo systemctl daemon-reload
```

### 3. 设置开机启动

接下来，启用该服务，使其在系统启动时自动运行：

```
sudo systemctl enable frpc_start_all.service
```

### 4. 手动启动服务

你也可以随时手动启动该服务，测试它是否正常工作：

```
sudo systemctl start frpc_start_all.service
```

### 5. 检查服务状态

执行以下命令，查看服务的运行状态：

```
sudo systemctl status frpc_start_all.service
```

如果配置正确，系统启动时 `start_all.sh` 将自动运行。
