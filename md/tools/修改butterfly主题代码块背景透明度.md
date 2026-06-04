---
title: "修改butterfly主题代码块背景透明度"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-08# #lastmod/2024-09-08#

## 新建 /theme/butterfly/source/css/self.css

添加代码

~~~css
#article-container pre, #article-container figure.highlight {
    background: #e6ebf190;
}

#article-container figure.highlight .gutter pre {
    background-color: #f6f8fa50;
}

#article-container .highlight-tools {
    background: #e6ebf150;
}

#article-container pre{
    background: #e6ebf100;
}
~~~

## 在/theme/butterfly/_config.yml的inject.head引入self.css

~~~yaml
inject:
  head:
    - <link rel="stylesheet" href="/css/self.css">
  bottom:
~~~

## 结束
