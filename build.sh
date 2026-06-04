#!/usr/bin/env bash
set -euo pipefail

# 用法: ./build.sh <工具.主题>
# 示例: ./build.sh hugo.papermod
#       ./build.sh hexo.next

if [ $# -lt 1 ]; then
    echo "用法: $0 <工具.主题>"
    echo "示例: $0 hugo.papermod"
    exit 1
fi

# 解析参数: 工具.主题
ARG="$1"
TOOL="${ARG%%.*}"
THEME="${ARG#*.}"

if [ "$TOOL" = "$ARG" ]; then
    echo "❌ 格式错误，请使用: 工具.主题"
    echo "   示例: $0 hugo.papermod"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
MD_DIR="$REPO_ROOT/md"
THEMES_TOML="$REPO_ROOT/themes.toml"

# ── 从 themes.toml 解析字段 ──
parse_toml() {
    local theme="$1" field="$2" in_section=""
    while IFS= read -r line; do
        [[ "$line" =~ ^\[([a-zA-Z0-9_.-]+)\]$ ]] && in_section="${BASH_REMATCH[1]}"
        if [ "$in_section" = "$theme" ] && [[ "$line" =~ ^$field[[:space:]]*=[[:space:]]*\"(.+)\"$ ]]; then
            echo "${BASH_REMATCH[1]}"
            return
        fi
    done < "$THEMES_TOML"
}

# ── 获取覆盖文件映射 ──
parse_overrides() {
    local theme="$1" in_files=false from=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^\[\[$theme\.files\]\]$ ]]; then
            in_files=true
            continue
        fi
        [ "$in_files" = true ] && [[ "$line" =~ ^\[ ]] && in_files=false
        if [ "$in_files" = true ]; then
            if [[ "$line" =~ ^from[[:space:]]*=[[:space:]]*\"(.+)\"$ ]]; then
                from="${BASH_REMATCH[1]}"
            fi
            if [[ "$line" =~ ^to[[:space:]]*=[[:space:]]*\"(.+)\"$ ]]; then
                echo "$REPO_ROOT/$from|${BASH_REMATCH[1]}"
                from=""
            fi
        fi
    done < "$THEMES_TOML"
}

# ── 拉取主题 + 应用覆盖 ──
fetch_theme() {
    local tool_dir="$1" theme="$2"

    REPO="$(parse_toml "$theme" repo)"
    if [ -z "$REPO" ]; then
        echo "❌ 未在 themes.toml 中找到主题 [$theme]"
        exit 1
    fi

    THEME_DIR="$tool_dir/themes/$theme"
    if [ ! -d "$THEME_DIR" ]; then
        echo "📥 拉取主题 $theme ..."
        mkdir -p "$(dirname "$THEME_DIR")"
        git clone --depth 1 "$REPO" "$THEME_DIR" 2>&1 | tail -1
    else
        echo "📦 使用已有主题: $theme"
    fi

    # 应用文件覆盖
    local count=0
    while IFS='|' read -r from to; do
        [ -z "$from" ] && continue
        if [ -f "$from" ]; then
            cp "$from" "$THEME_DIR/$to"
            echo "   📝 覆盖: $to"
            ((count++))
        else
            echo "   ⚠️  覆盖源文件不存在: $from"
        fi
    done < <(parse_overrides "$theme")

    if [ $count -gt 0 ]; then
        echo "   共覆盖 $count 个文件"
    fi
}

# ── 构建逻辑 ──
build_hugo() {
    local tool_dir="$REPO_ROOT/hugo"
    [ -d "$tool_dir" ] || { echo "❌ hugo 目录不存在"; exit 1; }
    cd "$tool_dir"

    rm -rf content
    ln -sf "$MD_DIR" content
    echo "📁 content -> $(readlink content)"

    fetch_theme "$tool_dir" "$THEME"
    sed -i "s/^theme = .*/theme = \"$THEME\"/" hugo.toml

    echo "🔨 Hugo 构建中..."
    hugo --minify
    echo "✅ 构建完成: $tool_dir/public"
}

build_hexo() {
    local tool_dir="$REPO_ROOT/hexo"
    [ -d "$tool_dir" ] || { echo "❌ hexo 目录不存在"; exit 1; }
    cd "$tool_dir"

    rm -rf source/_posts
    ln -sf "$MD_DIR" source/_posts
    echo "📁 source/_posts -> $(readlink source/_posts)"

    fetch_theme "$tool_dir" "$THEME"
    sed -i "s/^theme: .*/theme: $THEME/" _config.yml

    echo "🔨 Hexo 构建中..."
    hexo generate
    echo "✅ 构建完成: $tool_dir/public"
}

build_zola() {
    local tool_dir="$REPO_ROOT/zola"
    [ -d "$tool_dir" ] || { echo "❌ zola 目录不存在"; exit 1; }
    cd "$tool_dir"

    rm -rf content
    ln -sf "$MD_DIR" content
    echo "📁 content -> $(readlink content)"

    fetch_theme "$tool_dir" "$THEME"
    sed -i "s/^theme = .*/theme = \"$THEME\"/" config.toml

    echo "🔨 Zola 构建中..."
    zola build
    echo "✅ 构建完成: $tool_dir/public"
}

case "$TOOL" in
    hugo) build_hugo ;;
    hexo) build_hexo ;;
    zola) build_zola ;;
    *)
        echo "❌ 未知工具: $TOOL (支持: hugo, hexo, zola)"
        exit 1
        ;;
esac
