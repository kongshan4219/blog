---
title: "github 从私有仓库下载最新版本的release"
date: 2026-06-04
tags: ["tools"]
---

#date/2025-01-24 01:11:23# #lastmod/2025-01-24 01:11:23#

---

# github 从私有仓库下载最新版本的release

单行命令

需要安装 jq

~~~bash
USERNAME="username" REPO="repo" TOKEN="git-access-token" ASSET_NAME="filename" DEST_DIR="out-path"; mkdir -p "$DEST_DIR" && ASSET_ID=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/repos/$USERNAME/$REPO/releases/latest" | jq -r --arg ASSET_NAME "$ASSET_NAME" '.assets[] | select(.name == $ASSET_NAME) | .id') && curl -LJ   -o "$DEST_DIR/$ASSET_NAME"   -H "Authorization: token $TOKEN"   -H "Accept: application/octet-stream"   "https://api.github.com/repos/$USERNAME/$REPO/releases/assets/$ASSET_ID"
~~~
