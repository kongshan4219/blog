---
title: "springBoot.md"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-12-23 01:23:15# #lastmod/2024-12-23 01:23:15#

## 这里算是一些tips吧

#### \<parent> 和 \<dependencyManagement>

当同时使用 <parent> 和 <dependencyManagement> 时，子模块中的依赖版本通常会遵循 <dependencyManagement> 中指定的版本。这意味着，如果在 <dependencyManagement> 中指定了某个依赖的版本，而在子模块中引入该依赖时没有指定版本，Maven 将使用 <dependencyManagement> 中指定的版本,当 <dependencyManagement> 中也没有指定的版本是使用 <parent> 中指定的版本，如果 <parent> 中也没有指定，则需要子模块自己指定版本，否则报错。
