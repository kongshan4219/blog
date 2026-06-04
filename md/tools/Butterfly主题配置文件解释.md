---
title: "Butterfly主题配置文件解释"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-07 19:45:26# #lastmod/2024-09-07 19:45:26#

### `nav`

- `display_title`: 是否显示网站标题。
- `fixed`: 导航栏是否固定在页面顶部。

### `menu`

- `首页`、`归档`、`标签`、`分类`：定义网站菜单的名称及链接，后面为 FontAwesome 图标。

### `highlight_theme`

- `light`: 设置代码高亮的主题为浅色。
- `highlight_copy`: 启用复制代码功能。
- `highlight_lang`: 显示代码的语言。
- `highlight_shrink`: 是否启用代码块的折叠功能。
- `highlight_height_limit`: 是否限制代码块的高度。

### `code_word_wrap`

- `false`: 代码是否自动换行，设为 `false` 表示不换行。

### `favicon`

- 网站图标路径。

### `avatar`

- `img`: 头像图片的路径。
- `effect`: 头像是否显示动态效果。

### `disable_top_img`

- `false`: 是否禁用文章顶部图片。

### `index_img`, `archive_img`, `footer_img`

- 各个页面（首页、归档页、页脚）的背景图片设置。

### `cover`

- `index_enable`: 是否在首页显示封面图片。
- `aside_enable`: 是否在侧边栏显示封面图片。
- `archives_enable`: 是否在归档页显示封面图片。
- `position`: 封面图片显示位置（`both` 表示上下都显示）。
- `suffix`: 封面图片数量，用于随机选择封面图片。
- `default_cover`: 默认封面图片的 URL 列表。

### `error_img`

- 自定义错误页面图片。

### `error_404`

- `enable`: 是否启用 404 页面。
- `subtitle`: 404 页面的副标题。
- `background`: 404 页面背景图片。

### `post_meta`

- 控制页面和文章元数据的显示，如日期、分类、标签等。

### `index_post_content`

- `method`: 用来控制首页文章内容的截取方式，`3` 表示显示部分内容。
- `length`: 截取的文字长度。

### `anchor`

- 控制文章中的锚点链接的显示和自动更新。

### `photofigcaption`

- `false`: 是否为图片添加说明文字。

### `copy`

- `enable`: 是否启用复制文章功能。
- `copyright`: 控制文章复制时显示的版权声明。

### `toc`

- `post`: 是否在文章页启用目录（Table of Content）。
- `number`: 是否为目录项编号。
- `scroll_percent`: 是否显示文章滚动百分比。

### `post_copyright`

- `enable`: 启用文章版权声明。
- `license`: 文章版权的许可证类型。

### `reward`

- 启用赞赏功能。

### `post_edit`

- 显示文章编辑链接。

### `related_post`

- `enable`: 是否显示相关文章。
- `limit`: 显示的相关文章数量。

### `post_pagination`

- 定义文章分页设置。

### `noticeOutdate`

- 控制过期文章的提示信息。

### `footer`

- `owner`: 页脚显示所有者信息。
- `custom_text`: 自定义页脚文本和备案信息。

### `aside`

- 控制侧边栏的显示与功能设置。

### `busuanzi`

- 启用不蒜子统计网站和页面的浏览量。

### `runtimeshow`

- 显示网站运行时间。

### `newest_comments`

- 显示最新评论。

### `translate`

- 启用简繁转换功能。

### `readmode`

- 启用阅读模式按钮。

### `darkmode`

- 启用夜间模式，并提供夜间模式切换按钮。

### `rightside_scroll_percent`

- 是否在右侧显示文章阅读进度。

### `mathjax`, `katex`

- 是否启用 MathJax 或 KaTeX 数学公式渲染。

### `algolia_search`, `local_search`

- 搜索功能配置。

### `sharejs`, `addtoany`

- 配置文章的分享功能，`sharejs` 和 `addtoany` 都是不同的社交分享工具。

### `comments`

- 配置评论系统，支持多个评论平台如 Valine、Utterances 等。

### `chat_btn`

- 启用网站的在线聊天功能。

### `google_adsense`

- 配置 Google Adsense 广告。

### `text_align_justify`

- 控制文章文本的对齐方式。

### `background`

- 网站背景图片。

### `mask`

- 控制页头和页脚是否启用遮罩效果。

### `enter_transitions`

- 页面加载的过渡动画。

### `activate_power_mode`

- 开启 "Power Mode" 效果（输入时出现的动画）。

### `canvas_ribbon`, `canvas_fluttering_ribbon`, `canvas_nest`

- 各种动态背景效果的设置，如彩带、悬浮线条等。

### `fireworks`

- 启用烟花点击效果。

### `click_heart`

- 启用点击显示心形的效果。

### `display_mode`

- 设置默认显示模式（亮模式或暗模式）。

### `beautify`

- 是否启用页面美化功能。

### `subtitle`

- 启用副标题及其效果。

### `preloader`

- 启用页面加载动画。

### `wordcount`

- 显示文章字数统计。

### `medium_zoom`

- 启用图片的点击放大功能。

### `fancybox`

- 启用图片展示插件 Fancybox。

### `series`

- 启用文章系列功能，按标题排序。

### `abcjs`

- 启用 ABC 记谱法支持。

### `mermaid`

- 启用 Mermaid 图表渲染。

### `note`

- 控制注释框样式。

### `pjax`

- 启用 PJAX 无刷新页面加载功能。

### `aplayerInject`

- 启用 APlayer 播放器。

### `snackbar`

- 启用 Snackbar 提示消息。

### `instantpage`

- 启用 InstantPage 提前加载页面。

### `pangu`

- 启用 Pangu 插件来自动添加中文排版空格。

### `lazyload`

- 启用图片懒加载功能。

### `Open_Graph_meta`

- 启用 Open Graph 元数据，用于分享链接时的预览显示。

### `css_prefix`

- 为 CSS 样式加上前缀以避免冲突。

### `CDN`

- 设置静态资源的 CDN 提供商。

### `code_blocks`

- 配置代码块的样式和功能。

### `index_layout`

- 配置首页布局方式。

### `math`

- 数学公式渲染设置，支持 MathJax 和 KaTeX。

### `search`

- 搜索功能的详细配置。

### `share`

- 配置社交分享功能。

### `chat`

- 配置网站聊天功能的显示按钮。

### `rounded_corners_ui`

- 启用圆角 UI 样式。

### `pwa`

- 启用 PWA（渐进式网页应用）。
