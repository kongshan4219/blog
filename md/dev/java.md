---
title: "java"
date: 2026-06-04
tags: ["dev"]
---

​#lastmod/2025-10-12 09:13:27#​ #date/2025-07-19 10:52:47#

- ​`ThreadLocal`​  
  单纯是一个变量，可以看作是一个长度为1的集合，使用泛型实现存储任意类型的数据。这个变量会为每一个线程都创建一个副本，即在同一个线程中的任何位置访问都是同一个变量。  
  ​`ThreadLocal<T> threadLocal= new ThreadLocal<>();`其中T就是要存储的数据。

  ```java
  threadLocal.set(Object o);//存储值
  threadLocal.get();//获取值，在同一个线程中的任何位置获取的都是threadLocal.set(Object o);存储的值
  threadLocal.remove();//清除值
  ```

‍
