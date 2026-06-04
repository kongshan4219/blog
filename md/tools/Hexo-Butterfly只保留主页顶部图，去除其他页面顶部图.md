---
title: "Hexo-Butterfly只保留主页顶部图，去除其他页面顶部图"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-05 20:51:48# #lastmod/2024-09-05 20:51:48#

修改 /themes/butterfly/layout/includes/header/index.pug 文件

![image-20240905131217510](https://md.kongseek.com/image-20240905131217510.png)

```
var isHomeClass = is_home() ? 'full_page' : 'not-home-page'
后面添加或者修改为
var isHomeClass = is_home() ? 'full_page' : 'not-top-img'
top_img = is_home() 
```
