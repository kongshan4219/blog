---
title: "服务器docker数据备份"
date: 2026-06-04
tags: ["linux"]
---

​#lastmod/2025-09-14 00:03:46#​ #date/2025-09-13 23:58:44#

### mysql数据备份

```bash
#!/bin/bash
set -euo pipefail

# === 配置部分 ===
# 容器名、root密码、宿主机备份目录
declare -A MYSQL_CONTAINERS=(
  ["mysql-8-4-4"]="p82q3J8bk9E9RQ7cFeqjP4QDd3w23XsQ"
  ["mysql-8-0-28"]="G5s-T3y2h!QpL@8vN4d"
)

BACKUP_BASE_DIR="/opt/docker-data/mysql"

# === 主逻辑 ===
for CONTAINER in "${!MYSQL_CONTAINERS[@]}"; do
  ROOT_PASSWORD="${MYSQL_CONTAINERS[$CONTAINER]}"
  TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
  BACKUP_FILE="all_databases_${TIMESTAMP}.sql"
  BACKUP_DIR="$BACKUP_BASE_DIR/${CONTAINER}/backups"

  echo "=============================="
  echo "开始备份容器: $CONTAINER"
  echo "=============================="

  # 确保目录存在
  mkdir -p "$BACKUP_DIR"

  echo "[1/4] 在容器内执行 mysqldump..."
  docker exec "$CONTAINER" sh -c "exec mysqldump --all-databases \
    -uroot -p\"$ROOT_PASSWORD\" \
    --single-transaction --routines --triggers --events --hex-blob \
    --set-gtid-purged=OFF > /tmp/all_databases.sql"

  echo "[2/4] 复制备份文件到宿主机..."
  docker cp "$CONTAINER:/tmp/all_databases.sql" "$BACKUP_DIR/$BACKUP_FILE"

  echo "[3/4] 校验备份文件..."
  ls -lh "$BACKUP_DIR/$BACKUP_FILE"
  sha256sum "$BACKUP_DIR/$BACKUP_FILE"

  echo "[4/4] 清理容器内临时文件..."
  docker exec "$CONTAINER" rm /tmp/all_databases.sql

  echo "✅ $CONTAINER 备份完成：$BACKUP_DIR/$BACKUP_FILE"
  echo
done

```
