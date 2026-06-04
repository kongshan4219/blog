---
title: "Butterfly主题设置透明背景"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-05 20:50:54# #lastmod/2024-09-05 20:50:54#

修改 [Butterfly](https://butterfly.js.org/) 的配置文件 `_config.butterfly.yml`

编辑 `index_img`、`index_top_img_height`、`background`、`footer_bg`、`mask.header` 选项。

设置网站背景，将主页顶部图和页脚背景改为透明，移除顶部图的黑色半透遮罩。

```
index_img: transparent
background: url(https://example.com/img/background.jpg)
footer_bg: transparent
mask:
  header: false
```
