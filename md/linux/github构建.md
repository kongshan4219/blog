---
title: "github构建"
date: 2026-06-04
tags: ["linux"]
---

#date/2020-01-01# #lastmod/2020-01-01#

## github构建

~~~yml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    concurrency:
      group: deploy-group-hexo  # 定义一个统一的组，确保工作流顺序执行
      cancel-in-progress: false  # 等待前一个工作流执行完成，而不是取消
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
      with:
        submodules: true
        ref: hexo

    - name: Set up Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18.20.4'

    - name: Print current working directory
      run: pwd

    - name: Install dependencies
      run: npm install

    - name: Build Hexo
      run: |
        npm install -g hexo
        hexo clean
        hexo generate
        sleep 5
        hexo generate

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
        ssh ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }} "rm -rf /home/zjh199/domains/hexo.kongshan.cc/public_html"
        rsync -avz --delete ./public/ ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }}:/home/zjh199/domains/hexo.kongshan.cc/public_html
        # ssh ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }} "rm -rf /opt/application/hexo/public"ssh ${{ secrets.USERNAME }}@${{ secrets.SERVER_IP }} "node /opt/application/hexo/source/_posts/.script/send.mjs"
      env:
        SERVER_IP: ${{ secrets.SERVER_IP }}
        USERNAME: ${{ secrets.USERNAME }}
        SSH_PORT: ${{ secrets.SSH_PORT }}
        GIT_USERNAME: ${{ secrets.GIT_USERNAME }}
        GIT_TOKEN: ${{ secrets.GIT_TOKEN }}
~~~

## 服务器构建
