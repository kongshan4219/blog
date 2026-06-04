---
title: "html"
date: 2026-06-04
tags: ["dev"]
---

```html
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<title>CSV 目录树展示</title>

<style>
body {
    font-family: "Segoe UI", Arial;
    background: #f5f6fa;
}

.controls {
    margin: 15px 0;
}

select, button {
    padding: 6px 10px;
    margin-right: 10px;
}

.tree {
    background: white;
    padding: 15px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    max-height: 600px;
    overflow: auto;
}

ul {
    list-style: none;
    margin: 0;
    padding-left: 20px;
    position: relative;
}

ul::before {
    content: "";
    border-left: 1px solid #ddd;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 8px;
}

li {
    position: relative;
    margin: 4px 0;
}

li::before {
    content: "";
    border-top: 1px solid #ddd;
    position: absolute;
    top: 12px;
    left: 8px;
    width: 12px;
}

.node {
    display: flex;
    align-items: center;
    cursor: pointer;
    padding: 4px 6px;
    border-radius: 4px;
}

.node:hover {
    background: #eef2ff;
}

.arrow {
    width: 12px;
    margin-right: 4px;
    transition: transform 0.2s;
}

.arrow.open {
    transform: rotate(90deg);
}

.icon {
    width: 16px;
    margin-right: 6px;
}

.size {
    margin-left: auto;
    font-family: monospace;
    color: #666;
}

.size-bar {
    width: 120px;
    height: 6px;
    background: #e5e7eb;
    margin-left: 10px;
    border-radius: 4px;
    overflow: hidden;
}

.size-bar-inner {
    height: 100%;
    background: linear-gradient(90deg, #4f46e5, #06b6d4);
}

/* 进度条样式补充 */
.progress-container {
    width: 100%;
    height: 8px;
    background-color: #e5e7eb;
    border-radius: 4px;
    margin: 5px 0 15px 0;
    overflow: hidden;
}
.progress-bar {
    height: 100%;
    width: 0%;
    background: linear-gradient(90deg, #4f46e5, #06b6d4);
    transition: width 0.3s ease;
}
</style>
</head>

<body>

<h2>CSV 文件目录树展示</h2>

<input type="file" id="fileInput" accept=".csv">
<button id="startBtn">开始解析</button>

<div>解析进度</div>
<div class="progress-container">
    <div class="progress-bar" id="progressBar"></div>
</div>

<div class="tree" id="tree"></div>
<div class="controls">
排序：
<select id="sortType">
    <option value="name">名称</option>
    <option value="size">大小</option>
    <option value="type">类型</option>
</select>

<select id="sortOrder">
    <option value="asc">升序</option>
    <option value="desc">降序</option>
</select>
</div>
<script>

// =============================
// Web Worker 创建
// =============================

const workerCode = `
self.onmessage = function(e) {
    const file = e.data;
    const reader = new FileReader();

    reader.onload = function(event) {
        const text = event.target.result;
        const lines = text.split('\\n');
        const total = lines.length;

        const result = [];
        for (let i = 1; i < total; i++) {
            const row = lines[i].split(',');
            if (row.length < 5) continue;

            result.push({
                type: row[0],
                path: row[1],
                name: row[2],
                size: parseFloat(row[3]) || 0
            });

            if (i % 5000 === 0) {
                self.postMessage({
                    progress: (i / total * 100).toFixed(1)
                });
            }
        }

        self.postMessage({
            done: true,
            data: result
        });
    };

    reader.readAsText(file);
};
`;

const blob = new Blob([workerCode], { type: 'application/javascript' });
const worker = new Worker(URL.createObjectURL(blob));

// =============================
// 主线程逻辑
// =============================

const fileInput = document.getElementById('fileInput');
const startBtn = document.getElementById('startBtn');
const progressBar = document.getElementById('progressBar');
const treeContainer = document.getElementById('tree');

let treeData = {};
let totalSize = 0;

// 手动开始解析
startBtn.onclick = () => {
    if (!fileInput.files.length) return;
    progressBar.style.width = "0%";
    treeContainer.innerHTML = "";
    worker.postMessage(fileInput.files[0]);
};

worker.onmessage = function(e) {

    if (e.data.progress) {
        progressBar.style.width = e.data.progress + "%";
    }

    if (e.data.done) {
        buildTree(e.data.data);
        renderTree();
        progressBar.style.width = "100%";
    }
};

// =============================
// 构建目录树（O(n)）
// =============================

function buildTree(rows) {
    treeData = { children: {}, size: 0 };

    const pathMap = new Map();
    pathMap.set("/", treeData);

    rows.forEach(row => {
        const fullPath = row.path + "/" + row.name;
        const parts = fullPath.split('/').filter(Boolean);

        let current = treeData;
        let currentPath = "";

        parts.forEach((part, index) => {
            currentPath += "/" + part;

            if (!current.children[part]) {
                current.children[part] = {
                    children: {},
                    size: 0,
                    type: index === parts.length - 1 ? row.type : "文件夹"
                };
                pathMap.set(currentPath, current.children[part]);
            }

            current = current.children[part];

            if (index === parts.length - 1) {
                current.size = row.size;
            }
        });
    });

    totalSize = calculateFolderSize(treeData);
}

// 递归计算文件夹大小
function calculateFolderSize(node) {
    if (!node.children || Object.keys(node.children).length === 0)
        return node.size || 0;

    let sum = 0;
    for (let key in node.children) {
        sum += calculateFolderSize(node.children[key]);
    }
    node.size = sum;
    return sum;
}

// =============================
// 渲染目录树（带根目录）
// =============================

function renderTree() {
    treeContainer.innerHTML = "";
    const rootUl = document.createElement('ul');
    // 渲染根目录 /
    renderRootNode(treeData, rootUl);
    treeContainer.appendChild(rootUl);
}

// 渲染根目录节点
function renderRootNode(node, parentEl) {
    const li = document.createElement("li");

    const div = document.createElement("div");
    div.className = "node";

    const arrow = document.createElement("span");
    arrow.className = "arrow open";
    arrow.textContent = "▶";

    const icon = document.createElement("span");
    icon.className = "icon";
    icon.textContent = "🖥️";

    const text = document.createElement("span");
    text.textContent = "根目录 /";

    const sizeText = document.createElement("span");
    sizeText.className = "size";
    sizeText.textContent = formatSize(node.size);

    const bar = document.createElement("div");
    bar.className = "size-bar";

    const inner = document.createElement("div");
    inner.className = "size-bar-inner";
    inner.style.width = "100%"; // 根目录占满整个进度条

    bar.appendChild(inner);
    div.appendChild(arrow);
    div.appendChild(icon);
    div.appendChild(text);
    div.appendChild(sizeText);
    div.appendChild(bar);

    li.appendChild(div);

    // 子目录容器（默认展开）
    const subUl = document.createElement("ul");
    subUl.style.display = "block";
    li.appendChild(subUl);

    // 渲染子节点
    renderNode(node, subUl);

    // 根目录点击折叠/展开
    div.onclick = () => {
        const isOpen = subUl.style.display === "block";
        subUl.style.display = isOpen ? "none" : "block";
        arrow.classList.toggle("open");
    };

    parentEl.appendChild(li);
}

let sortType = "name";
let sortOrder = "asc";

document.getElementById("sortType").onchange = e => {
    sortType = e.target.value;
    treeContainer.innerHTML = "";
    renderTree();
};

document.getElementById("sortOrder").onchange = e => {
    sortOrder = e.target.value;
    treeContainer.innerHTML = "";
    renderTree();
};

// 渲染子节点
function renderNode(node, parentEl) {
    let entries = Object.entries(node.children);

    // 文件夹优先
    entries.sort((a, b) => {
        const A = a[1];
        const B = b[1];

        if (A.children && Object.keys(A.children).length > 0 && !(B.children && Object.keys(B.children).length > 0)) return -1;
        if (!(A.children && Object.keys(A.children).length > 0) && (B.children && Object.keys(B.children).length > 0)) return 1;

        let result = 0;
        if (sortType === "name") result = a[0].localeCompare(b[0]);
        if (sortType === "size") result = A.size - B.size;
        if (sortType === "type") result = (A.type || "").localeCompare(B.type || "");
        return sortOrder === "asc" ? result : -result;
    });

    const fragment = document.createDocumentFragment();

    entries.forEach(([name, child]) => {
        const li = document.createElement("li");
        const div = document.createElement("div");
        div.className = "node";

        const arrow = document.createElement("span");
        arrow.className = "arrow";
        const hasChild = child.children && Object.keys(child.children).length > 0;
        arrow.textContent = hasChild ? "▶" : "";

        const icon = document.createElement("span");
        icon.className = "icon";
        icon.textContent = hasChild ? "📁" : "📄";

        const text = document.createElement("span");
        text.textContent = name;

        const sizeText = document.createElement("span");
        sizeText.className = "size";
        sizeText.textContent = formatSize(child.size);

        const bar = document.createElement("div");
        bar.className = "size-bar";
        const inner = document.createElement("div");
        inner.className = "size-bar-inner";
        inner.style.width = totalSize > 0 ? ((child.size / totalSize) * 100).toFixed(2) + "%" : "0%";
        bar.appendChild(inner);

        div.appendChild(arrow);
        div.appendChild(icon);
        div.appendChild(text);
        div.appendChild(sizeText);
        div.appendChild(bar);
        li.appendChild(div);

        if (hasChild) {
            const subUl = document.createElement("ul");
            subUl.style.display = "none";
            li.appendChild(subUl);

            div.onclick = () => {
                const isOpen = subUl.style.display === "block";
                subUl.style.display = isOpen ? "none" : "block";
                arrow.classList.toggle("open");
                if (!subUl.hasChildNodes()) renderNode(child, subUl);
            };
        }

        fragment.appendChild(li);
    });

    parentEl.appendChild(fragment);
}

function formatSize(bytes) {
    if (bytes < 1024) return bytes + " B";
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + " KB";
    if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(2) + " MB";
    return (bytes / 1024 / 1024 / 1024).toFixed(2) + " GB";
}

</script>

</body>
</html>
```
