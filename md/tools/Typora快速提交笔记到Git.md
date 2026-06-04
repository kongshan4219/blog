---
title: "Typora快速提交笔记到Git"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-05 20:52:13# #lastmod/2024-09-05 20:52:13#

# Typora 快速提交笔记到 Git.md

## 流程

~~~mermaid
graph TD
check_local_commit_count[检查主仓库本地有几个未推送提交]
check_local_commit_count -- 0个 --> push_child[主仓库是最新，提交并推送子仓库修改]
push_child --> update_root_child[子仓库提交推送后，主仓库更新对其引用]
update_root_child --> push_root[更新sign.yml的count值为1,提交和推送更新后的子仓库引用]
push_root --> e[end]
check_local_commit_count -- 1个以上 --> update_count[更新sign.yml的count值为未提交数量]
~~~

## git_commit.bat

```bat
:: 提交脚本
@echo off
setlocal enabledelayedexpansion

:: 获取当前日期和时间
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
    set year=%%a
    set month=%%b
    set day=%%c
)

for /f "tokens=1-2 delims=: " %%d in ('time /t') do (
    set hour=%%d
    set minute=%%e
)

:: 修正小时和分钟的格式（如有必要）
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
if "%minute:~0,1%" == " " set minute=0%minute:~1,1%

:: 格式化日期时间
set datetime=%year%-%month%-%day% %hour%:%minute%

:: 切换到目标目录
cd /d C:\Users\kongshan\Documents\article

:: 检查是否有未推送的提交
git log origin/main..HEAD --oneline > nul 2>&1
if not errorlevel 1 (
    echo There are unpushed commits. Pushing them now...
    git push origin main
    if errorlevel 1 (
        echo Git push failed. Exiting.
        exit /b 1
    )
)

:: 检查是否有文件需要提交
git status --porcelain > nul
if errorlevel 1 (
    echo Failed to check git status. Exiting.
    exit /b 1
)

:: 检查 git status 输出是否为空
for /f %%i in ('git status --porcelain') do (
    set has_changes=true
    goto :found_changes
)
set has_changes=false

:found_changes
if "%has_changes%" == "false" (
    echo No changes to commit. Exiting.
    exit /b 0
)

:: 执行 Git 操作
git add .
git commit -m "update by Typora %datetime%"
if errorlevel 1 (
    echo Git commit failed. Exiting.
    exit /b 1
)
git push origin main
if errorlevel 1 (
    echo Git push failed. Exiting.
    exit /b 1
)

echo Git operations completed successfully.


:: 切换到 hexo 项目目录并更新子模块
cd /d C:\MyApplication\Work\GitProjects\hexo

:: 检查主仓库是否有更新
git fetch origin main
if errorlevel 1 (
    echo Git fetch failed. Exiting.
    exit /b 1
)

:: 检查本地是否有未提交的更改
git status --porcelain > nul
if not errorlevel 1 (
    echo Local changes detected. Resetting to origin/main.
    git reset --hard origin/main
    if errorlevel 1 (
        echo Git reset failed. Exiting.
        exit /b 1
    )
)


:: 更新子模块
git submodule update --remote
if errorlevel 1 (
    echo Git submodule update failed. Exiting.
    exit /b 1
)

:: 提交更新后的子模块更改
@REM git add source/_posts
git add .
git commit -m "submodules update by Typora %datetime%"
if errorlevel 1 (
    echo Git commit failed. Exiting.
    exit /b 1
)
git push origin main
if errorlevel 1 (
    echo Git push failed. Exiting.
    exit /b 1
)

endlocal
```

## deploy.yml

~~~yml
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
          export PATH=$PATH:/root/.nvm/versions/node/v18.20.4/bin
          if ! command -v hexo &> /dev/null
          then
            echo "Hexo 未安装，正在安装..."
            npm install -g hexo-cli
          fi
          cd /opt/application/hexo

          # 初始化计数器
          MAX_ATTEMPTS=60
          ATTEMPT=0
          # 持续检查主仓库是否有更新，最多检查10次
          while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
            git fetch origin
            LOCAL_COMMIT=$(git rev-parse HEAD)
            REMOTE_COMMIT=$(git rev-parse origin/main)

            if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
              echo "检测到更新，开始同步代码..."
              # 获取远程比本地多的提交数
              NEW_COMMITS=$(git rev-list --count HEAD..origin/main)

              if [ "$NEW_COMMITS" -gt 0 ]; then
                echo "远程分支有 $NEW_COMMITS 次新的提交。"
                # 从 sign.yml 中读取 count 值
                if [ -f sign.yml ]; then
                  COUNT=$(grep 'count:' sign.yml | awk '{print $2}')
                  echo "sign.yml 中的 count 值为: $COUNT"
                  # 判断远程的提交数是否等于 count
                  if [ "$NEW_COMMITS" -eq "$COUNT" ]; then
                    echo "远程提交的数量与 count 值匹配，开始同步..."
                    git reset --hard origin/main
                    # 将 count 值重置为 1
                    if grep -q 'count:' sign.yml; then
                      sed -i 's/count: [0-9]*/count: 1/' sign.yml
                      echo "count 值已重置为 1。"
                    else
                      echo "sign.yml 中未找到 count 字段。"
                    fi
                    break
                  else
                    echo "远程提交的数量 ($NEW_COMMITS) 与 count ($COUNT) 不匹配，继续等待下一次检查..."
                  fi
                else
                  echo "sign.yml 文件不存在，无法读取 count 值。"
                  exit 1
                fi
              else
                echo "远程分支没有新的提交。"
              fi
            else
              ATTEMPT=$((ATTEMPT+1))
              echo "没有检测到更新，继续等待... ($ATTEMPT/$MAX_ATTEMPTS)"
              sleep 2  # 等待 2 秒后再次检查
            fi
          done

          # 如果达到最大尝试次数，判断为失败
          if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
            echo "超过最大尝试次数，操作失败。"
            # 将 sign.yml 中 count 的值加1
            if [ -f sign.yml ]; then
              echo "更新 sign.yml 中的 count 值..."
              # 读取 count 的当前值并加1
              CURRENT_COUNT=$(grep 'count:' sign.yml | awk '{print $2}')
              NEW_COUNT=$((CURRENT_COUNT + 1))
              # 使用 sed 替换 count 的值
              sed -i "s/count: [0-9]*/count: $NEW_COUNT/" sign.yml
            else
              echo "sign.yml 文件不存在。"
            fi
            # 直接退出，不执行后续命令
            exit 1
          fi

          # git pull origin main
          # git submodule update --remote
          git fetch origin
          git reset --hard origin/main
          # git pull origin main
          # 这条命令会对每一个子模块执行 git fetch origin && git reset --hard origin/main 操作
          # git submodule foreach --recursive 'git fetch origin && git reset --hard origin/main'
          # 指定操作一个子模块
          cd /opt/application/hexo/source/_posts
          git fetch origin
          git reset --hard origin/main
          # 返回主仓库
          cd /opt/application/hexo
          # 这条命令用于初始化、更新子模块，并递归地处理所有子模块中的嵌套子模块
          git submodule update --init --recursive
          # git submodule update --init --recursive --remote source/_posts

          # 读取并解析 butterfly 主题中 package.json 文件中的版本号
          PACKAGE_JSON="/opt/application/hexo/themes/butterfly/package.json"
          TARGET_VERSION="4.13.0"

          if [ -f "$PACKAGE_JSON" ]; then
            CURRENT_VERSION=$(jq -r '.version' "$PACKAGE_JSON")

            if [ "$CURRENT_VERSION" == "$TARGET_VERSION" ]; then
              echo "版本匹配 ($CURRENT_VERSION)，运行复制自定义主题文件..."
              cp -r /opt/application/hexo/themes_me/butterfly/. /opt/application/hexo/themes/butterfly/
            else
              echo "版本不匹配，当前版本为 $CURRENT_VERSION，目标版本为 $TARGET_VERSION。跳过复制操作。"
            fi
          else
            echo "$PACKAGE_JSON 文件不存在。"
          fi

          # # 检查和复制 random_img.js
          # if [ ! -f /opt/application/hexo/themes/butterfly/scripts/random_img.js ]; then
          #   if [ -f /opt/application/hexo/themes_me/butterfly/scripts/random_img.js ]; then
          #     echo "复制 random_img.js..."
          #     cp /opt/application/hexo/themes_me/butterfly/scripts/random_img.js /opt/application/hexo/themes/butterfly/scripts/random_img.js
          #   else
          #     echo "/opt/application/hexo/themes_me/butterfly/scripts/random_img.js 不存在，不进行复制操作。"
          #   fi
          # else
          #   echo "/opt/application/hexo/themes/butterfly/scripts/random_img.js 已存在，不进行操作。"
          # fi

          # 构建hexo
          # rm -rf /opt/application/hexo/db.json
          rm -rf /opt/application/hexo/public
          hexo clean
          hexo generate
          # 构建两次防止一些乱七八糟的bug
          hexo generate
          node ./source/_posts/.script/send.mjs
        EOF
      env:
        SERVER_IP: ${{ secrets.SERVER_IP }}
        USERNAME: ${{ secrets.USERNAME }}
        SSH_PORT: ${{ secrets.SSH_PORT }}
~~~
