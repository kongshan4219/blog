---
title: "修改butterfly页面加载动画只等待网站背景图"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-19# #lastmod/2024-09-19#

---

### start

hexo 的 butterfly 主题开启加载动画时会等待整个页面的请求全部加载结束后才关闭

### question

但是一些文章中插入了大图片，导致在大图片完成加载前长时间处于加载动画，浏览体验极差

所以想着让加载动画只等待网站背景图加载，完成后直接关闭加载页面

### solve

修改\themes\butterfly\layout\includes\loading\fullpage-loading.pug 文件，将原本的监听整个页面请求修改为监听网站背景图 <div id="web_bg"> </div> ，在背景图加载完后执行 preloader.endLoading() 结束加载动画

~~~pug
#loading-box
  .loading-left-bg
  .loading-right-bg
  .spinner-box
    .configure-border-1
      .configure-core
    .configure-border-2
      .configure-core
    .loading-word= _p('loading')

script.
  (() => {
    const $loadingBox = document.getElementById('loading-box');
    const $body = document.body;
  
    const preloader = {
      endLoading: () => {
        $body.style.overflow = '';
        $loadingBox.classList.add('loaded');
      },
      initLoading: () => {
        $body.style.overflow = 'hidden';
        $loadingBox.classList.remove('loaded');
      }
    };
  
    // 初始化加载
    preloader.initLoading();
  
    // 确保 DOM 完全加载后运行脚本
    document.addEventListener('DOMContentLoaded', () => {
      const $webBg = document.getElementById('web_bg');
  
      // 检查是否找到了 #web_bg 元素
      if ($webBg) {
        // 获取背景图片的 URL
        const bgImageUrl = $webBg.style.backgroundImage.replace(/^url\(['"](.+)['"]\)$/, '$1');
  
        // 创建 Image 对象用于手动加载背景图
        const img = new Image();
        img.src = bgImageUrl;
  
        // 监听背景图片的加载完成事件
        img.onload = () => {
          preloader.endLoading(); // 图片加载完成，结束加载动画
        };
  
        img.onerror = () => {
          console.error('Background image failed to load.');
          preloader.endLoading(); // 即使图片加载失败，也结束加载动画，避免页面卡住
        };
      } else {
        console.error('Element #web_bg not found.');
        preloader.endLoading(); // 如果未找到元素，结束加载动画
      }
    });
  
    // PJAX 部分（根据你是否启用 PJAX 而决定是否保留）
    if (!{theme.pjax && theme.pjax.enable}) {
      btf.addGlobalFn('pjaxSend', () => { preloader.initLoading() }, 'preloader_init');
      btf.addGlobalFn('pjaxComplete', () => { preloader.endLoading() }, 'preloader_end');
    }
  })();
~~~

![原本代码](https://md.kongseek.com/image-20240919173844762.png)

### end

![最终效果](https://md.kongseek.com/image-20240919173705448.png)
