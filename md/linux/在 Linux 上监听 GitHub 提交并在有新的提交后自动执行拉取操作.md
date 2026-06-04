---
title: "在 Linux 上监听 GitHub 提交并在有新的提交后自动执行拉取操作"
date: 2026-06-04
tags: ["linux"]
---

#date/2020-01-01# #lastmod/2020-01-01#

# 在 Linux 上监听 GitHub 提交并在有新的提交后自动执行拉取操作

### 1. 使用 GitHub Webhooks 通知服务器

首先，需要设置一个 GitHub Webhook，当有新的提交时，它会发送一个 HTTP 请求到你的服务器。

1. 在 GitHub 仓库中创建 Webhook：
   - 打开你的 GitHub 仓库，点击“Settings”。
   - 在左侧菜单中选择“Webhooks”。
   - 点击“Add webhook”按钮。
   - 在“Payload URL”字段中，填写你的服务器地址以及你设置的接收请求的路径，比如 `http://your-server.com/webhook`。
   - 在“Content type”中选择 `application/json`。
   - 在“Which events would you like to trigger this webhook?” 中，选择 “Just the push event”。
   - 最后，点击“Add webhook”。

### 2. 在服务器上设置一个 Webhook 接收服务

你需要在服务器上设置一个服务来接收 Webhook 的 POST 请求，并执行 `git pull` 操作。

可以使用 Python 的 Flask 框架来简易实现这个 Webhook 接收服务。下面是一个简单的示例：

```
# 安装Flask
pip install flask
```

创建一个 Flask 应用程序：

```
from flask import Flask, request
import os

app = Flask(__name__)

@app.route("/webhook", methods=["POST"])
def webhook():
    if request.method == "POST":
        # 切换到你的项目目录
        os.system("cd /path/to/your/repo && git pull")
        return "Pulled", 200
    else:
        return "Wrong event type", 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

- **注意**：请将 `/path/to/your/repo` 替换为你要监听的 Git 仓库的本地路径。

### 3. 启动 Flask 服务

启动 Flask 服务来监听 Webhook 请求：

```
python your_flask_app.py
```

此时，服务器就会监听指定的端口 (如上例中的 5000 端口)，一旦收到来自 GitHub 的 POST 请求，它就会执行 `git pull` 操作来拉取最新的代码。

### 4. 保证 Flask 应用持续运行

为了保证 Flask 应用在服务器上持续运行，可以使用 `systemd`、`screen`、`tmux` 或 `nohup` 等工具。

例如，使用 `nohup`：

```
nohup python your_flask_app.py &
```

这将让 Flask 应用在后台运行，并继续监听来自 GitHub 的 Webhook 请求。

### 5. 测试 Webhook

你可以通过在 GitHub 仓库中提交新的代码并推送到远程仓库，观察服务器上的日志或代码更新情况，确认一切工作正常。

这就是如何在 Linux 上监听 GitHub 提交并自动执行 `git pull` 操作的基本步骤。

---

### 1. **使用 GitHub Actions 和部署密钥**

你可以使用 GitHub Actions 自动拉取代码并部署到你的服务器上。

**步骤：**

1. **在服务器上生成 SSH 密钥对**：

   - 生成一个新的 SSH 密钥对：

     ```
     ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
     ```
   - 把公钥 (`~/.ssh/id_rsa.pub`) 添加到 GitHub 仓库的“Settings -> Deploy keys”中，勾选“Allow write access”。
   - 私钥部分可以保存在服务器上，用于在 GitHub Actions 中进行部署。
2. **在 GitHub Actions 中创建工作流**：

   - 在你的仓库中创建一个 `.github/workflows/deploy.yml` 文件，内容如下：

   ```
   name: Deploy

   on:
     push:
       branches:
         - main

   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
       - name: Checkout code
         uses: actions/checkout@v2

       - name: Deploy to server
         uses: appleboy/ssh-action@v0.1.1
         with:
           host: ${{ secrets.SERVER_IP }}
           username: ${{ secrets.USERNAME }}
           key: ${{ secrets.SSH_PRIVATE_KEY }}
           script: |
             cd /path/to/your/repo
             git pull origin main
   ```
3. **配置 GitHub Secrets**：

   - 在 GitHub 仓库的“Settings -> Secrets and variables -> Actions”中，添加以下密钥：
     - `SERVER_IP`: 你的服务器 IP 地址
     - `USERNAME`: 登录服务器的用户名
     - `SSH_PRIVATE_KEY`: 上面生成的私钥内容
4. **推送代码到 GitHub**：

   - 每次推送到 `main` 分支时，GitHub Actions 会自动连接到你的服务器，并拉取最新的代码。

### 2. **使用 Cron Job 定时检查并拉取**

如果不需要实时监听，你可以设置一个 cron job 定时检查远程仓库，并在检测到更新时执行 `git pull` 操作。

**步骤：**

1. **编辑 Cron 任务**：

   - 打开 cron 编辑器：

     ```
     crontab -e
     ```
   - 添加一个任务，每分钟检查一次远程仓库是否有更新：

     ```
     * * * * * cd /path/to/your/repo && git fetch origin && git reset --hard origin/main
     ```
   - 这个命令每分钟运行一次，检查远程仓库是否有新的提交，并重置本地分支到远程分支。
2. **保存并退出**。

### 3. **使用 Git 自带的 **​**​`post-receive`​**​ ** Hook**

你也可以利用 Git 自带的 `post-receive` hook 来实现自动拉取。

**步骤：**

1. **配置裸仓库**：

   - 在服务器上创建一个裸仓库：

     ```
     mkdir /path/to/bare/repo.git
     cd /path/to/bare/repo.git
     git init --bare
     ```
2. **设置 **​**​`post-receive`​**​ ** Hook**：

   - 在裸仓库中创建 `hooks/post-receive` 脚本：

     ```
     #!/bin/bash
     git --work-tree=/path/to/your/repo --git-dir=/path/to/bare/repo.git checkout -f
     ```
   - 赋予执行权限：

     ```
     chmod +x hooks/post-receive
     ```
3. **推送代码到裸仓库**：

   - 在本地开发环境中，将代码推送到裸仓库：

     ```
     git remote add production user@server:/path/to/bare/repo.git
     git push production main
     ```
   - 每次推送代码时，`post-receive` hook 会自动更新目标目录中的代码。

### 4. **使用 CI/CD 工具（如 Jenkins、GitLab CI 等）**

如果你的项目规模较大或需要更复杂的部署流水线，可以使用 Jenkins、GitLab CI 或其他 CI/CD 工具来自动化拉取和部署操作。

**Jenkins 示例：**

1. **在 Jenkins 中创建一个项目**，并配置为 Git SCM。
2. **设置 GitHub Webhook**，触发 Jenkins 在每次提交后运行构建。
3. **在 Jenkins 的构建步骤中**，添加一个脚本执行 `git pull` 或其他部署命令。****

---

## 完美运行

1. **在本地生成 SSH 密钥对**：

   - 生成一个新的 SSH 密钥对：

     ```
     ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
     ```
   - 把公钥 (`~/.ssh/id_rsa.pub`) 在添加到 GitHub 仓库的“Settings -> Deploy keys”中，勾选“Allow write access”。

     ps: windows 默认密钥对生成在 C:\Users\用户名 目录下
   - 私钥部分可以保存在服务器上，用于在 GitHub Actions 中进行部署。
2. **在 本地、github、服务器 新建仓库，并将 本地和服务器的仓库连接到github**

   ```
   git init
   git branch -M main 或 git checkout -b main
   git status
   git remote add origin [git地址]
   git remote -v
   ```
3. **配置 GitHub Secrets**：

   - 在 GitHub 仓库的“Settings -> Secrets and variables -> Actions”中，添加以下密钥：
     - `SERVER_IP`: 你的服务器 IP 地址
     - `USERNAME`: 登录服务器的用户名
     - `SSH_PRIVATE_KEY`: 上面生成的私钥内容
4. **本地仓库创建文件**：

   - 在你的仓库中创建一个 `.github/workflows/deploy.yml` 文件，内容如下：

   ```
   name: Deploy

   on:
     push:
       branches:
         - main

   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
       - name: Checkout code
         uses: actions/checkout@v2

       - name: Deploy to server
         uses: appleboy/ssh-action@v0.1.1
         with:
           host: ${{ secrets.SERVER_IP }}
           username: ${{ secrets.USERNAME }}
           key: ${{ secrets.SSH_PRIVATE_KEY }}
           script: |
             cd /path/to/your/repo
             git pull origin main
   ```
5. **提交文件到github**

   ```
   git add .github/workflows/deploy.yml
   git commit -m "Add GitHub Actions deployment workflow"
   git push origin main
   ```

   出现错误

   ```
    ! [remote rejected] main -> main (refusing to allow a Personal Access Token to create or update workflow `.github/workflows/deploy.yml` without `workflow` scope)
   error: failed to push some refs to 'https://github.com/****/****.git'
   ```

   因为Personal Access Token (PAT) 没有足够的权限来更新工作流文件

   ### **修改 PAT 权限**

   1. **登录 GitHub**：前往 GitHub 网站并登录到你的账户。
   2. **访问设置**：点击你的头像，选择 "Settings"。
   3. **访问开发者设置**：在设置菜单中，点击左侧的 "Developer settings"。
   4. **生成或修改 PAT**：

      - 点击 "Personal access tokens"。
      - 如果你还没有 PAT，可以点击 "Generate new token" 来生成一个新的 PAT。
      - 如果你已经有 PAT，找到相关的 PAT 并点击 "Edit"。
   5. **设置权限**：

      - 在生成或编辑 PAT 的页面中，确保选择了 `workflow` 权限。这个权限允许你创建和更新 GitHub Actions 工作流。
   6. **保存和更新 PAT**：

      - 生成或更新 PAT 后，将其复制并替换你本地配置中的旧 PAT。你可以使用以下命令设置新的 PAT：

        ```
        git remote set-url origin https://<your_new_pat>@github.com/****/****.git
        ```
6. **推送代码到 GitHub**：

   - 每次推送到 `main` 分支时，GitHub Actions 会自动连接到你的服务器，并拉取最新的代码。

---

## 完美运行2

一般上面那个就可以了，但是在将本地主机ssh的22端口通过frp转发到云服务器时，使用密钥连接会失败，所以换成密码连接

步骤都一样只是将 deploy.yml 修改一下

```
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Install sshpass
      run: sudo apt-get install -y sshpass

    - name: Deploy to server
      run: |
        sshpass -p ${{ secrets.PASSWORD }} ssh -o StrictHostKeyChecking=no -p ${{ secrets.SSH_PORT }} ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }} << 'EOF'
          cd /opt/document/article
          git pull origin main
        EOF
      env:
        SERVER_IP: ${{ secrets.SERVER_IP }}
        USERNAME: ${{ secrets.USERNAME }}
        SSH_PORT: ${{ secrets.SSH_PORT }}
        PASSWORD: ${{ secrets.PASSWORD }}
```

需要在 GitHub 仓库的“Settings -> Secrets and variables -> Actions”中额外添加

- SSH_PORT 转发后的端口
- PASSWORD 主机登录密码

---

## 完美运行3

这次是真的完美啦,具体执行的命令可以随意更改

修改 deploy.yml

```
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      with:
        submodules: true

    - name: Set up SSH key
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        echo "Host *" > ~/.ssh/config
        echo "  StrictHostKeyChecking no" >> ~/.ssh/config
        chmod 600 ~/.ssh/config

    - name: Deploy to server
      run: |
        ssh -p ${{ secrets.SSH_PORT }} ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }} << 'EOF'
          cd /opt/document/article
          git pull origin main
          rm -rf /opt/application/vue_press/kongshan/docs/article
          mkdir -p /opt/application/vue_press/kongshan/docs/article
          shopt -s extglob
          cp -r /opt/document/article/!(.*) /opt/application/vue_press/kongshan/docs/article
        EOF
      env:
        SERVER_IP: ${{ secrets.SERVER_IP }}
        USERNAME: ${{ secrets.USERNAME }}
        SSH_PORT: ${{ secrets.SSH_PORT }}
```
