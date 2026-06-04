---
title: "fastgithub"
date: 2026-06-04
tags: ["linux"]
---

#date/2020-01-01# #lastmod/2020-01-01#

要在 Linux x64 终端上运行 `fastgithub` 并设置系统的自动代理或手动代理，可以按照以下步骤操作：

### 1. **运行 fastgithub**

确保您已经将 `fastgithub` 的可执行文件放在一个目录中，并授予它可执行权限。

```
sudo chmod +x ./fastgithub
sudo ./fastgithub
```

### 2. **设置系统代理**

#### 自动设置系统代理（通过环境变量）

在终端中，您可以通过以下命令设置 HTTP 和 HTTPS 的代理为 `127.0.0.1:38457`：

```
export http_proxy=http://127.0.0.1:38457
export https_proxy=http://127.0.0.1:38457
```

如果您希望这些代理设置在所有终端会话中都生效，可以将上述两行添加到您的 `~/.bashrc` 或 `~/.zshrc` 文件中，然后运行以下命令以重新加载配置：

```
source ~/.bashrc  # 或 source ~/.zshrc
```

#### 手动设置代理（用于特定应用程序）

有些情况下，您可能只想为特定的应用程序设置代理，例如 `wget`、`curl` 或 `git`。可以在运行命令时手动指定代理：

```
wget --proxy=on --no-check-certificate http://example.com
curl -x http://127.0.0.1:38457 http://example.com
```

对于 `git`，可以通过以下命令全局设置代理：

```
git config --global http.proxy http://127.0.0.1:38457
git config --global https.proxy http://127.0.0.1:38457
```

### 3. **验证代理设置**

要确认代理设置是否生效，您可以使用 `curl` 测试一个请求：

```
curl -I http://www.google.com
```

如果代理设置正确，您应该能够通过代理访问外部网站。

### 4. **取消代理**

如果您不再需要代理，可以使用以下命令取消设置：

```
unset http_proxy
unset https_proxy
```

同时，您可以在 `.bashrc` 或 `.zshrc` 文件中移除或注释掉相关的 `export` 行。

通过以上步骤，您应该能够成功配置并使用 `fastgithub` 提供的代理服务来访问被屏蔽的资源。

---

根据您提供的步骤，以下是安装和配置 NVM 的完整流程：

### 1. 克隆 NVM 仓库到您的用户配置文件根目录中

首先，确保您已经安装了 Git (v1.7.10+)。然后，打开终端并运行以下命令，将 NVM 仓库克隆到您的用户配置文件根目录中：

```
cd ~
git clone https://github.com/nvm-sh/nvm.git .nvm
```

### 2. 切换到指定的版本

进入 `.nvm` 目录，并将其切换到特定版本（如 v0.40.1）：

```
cd ~/.nvm
git checkout v0.40.1
```

### 3. 激活 NVM

要激活 NVM，您需要在当前的 shell 会话中加载 NVM：

```
. ./nvm.sh
```

这样，NVM 就会在当前的终端会话中激活。

### 4. 配置自动加载 NVM

为了在每次登录时自动加载 NVM，需要将以下行添加到 `~/.bashrc`、`~/.profile` 或 `~/.zshrc` 文件中：

```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

使用以下命令来编辑 `.bashrc` 文件（或者 `.profile` 或 `.zshrc`，取决于您使用的 shell）：

```
nano ~/.bashrc
```

然后将上述内容粘贴到文件末尾。保存并退出编辑器。

### 5. 应用更改

完成以上配置后，您可以通过重新加载 `.bashrc` 文件来应用更改，或者直接重新启动终端：

```
source ~/.bashrc
```

现在，NVM 应该可以正常工作，并且在每次登录时自动加载。您可以使用以下命令来验证 NVM 是否成功安装：

```
nvm --version
```

如果正确安装和配置，应该会看到 NVM 的版本号。
