---
title: "Fyne 窗口结构层次笔记"
date: 2026-06-04
tags: ["dev"]
---

​#lastmod/2025-08-13 14:39:43#​ #date/2025-08-13 14:28:04#

# Fyne 窗口结构层次笔记

## 1. 最顶层：`App`（应用程序实例）

- 每个 Fyne 应用有且仅有一个 `App`​ 实例（通过 `app.New()` 创建）
- 是所有窗口、资源和应用级配置的容器
- 负责管理应用生命周期（启动、退出、系统事件等）
- 可以创建多个窗口（`Window`​），但通常有一个主窗口（通过 `SetMaster()` 标记）

```go
myApp := app.New() // 顶层应用实例
```

## 2. 第二层：`Window`（窗口实例）

- 由 `App`​ 创建（`myApp.NewWindow(title)`），是独立的操作系统窗口
- 每个窗口有自己的标题、尺寸、位置和生命周期
- 窗口之间是平级关系，但可以通过 `SetMaster()` 标记主窗口（主窗口关闭时整个应用退出）
- 窗口必须设置内容（`SetContent()`）才能显示 UI 元素

```go
mainWindow := myApp.NewWindow("主窗口")
dialogWindow := myApp.NewWindow("对话框")
mainWindow.SetMaster() // 标记为主窗口
```

## 3. 第三层：`Canvas`（画布）

- 每个 `Window`​ 内部包含一个 `Canvas`​（通过 `window.Canvas()` 获取）
- 是所有 UI 元素的绘制区域，负责渲染和事件处理
- 管理图层（`Layer`），可以在画布上叠加不同层级的内容（如弹窗、通知）
- 处理鼠标、键盘等输入事件，并分发给对应的 UI 元素

```go
canvas := mainWindow.Canvas()
canvas.SetBackgroundColor(color.White) // 设置画布背景
```

## 4. 第四层：`Container`​ 与 `Widget`（容器与组件）

- 窗口的 `Content`​ 必须是一个 `CanvasObject`（通常是容器或组件）

### 容器（`Container`）

- 用于组织多个 UI 元素，如 `VBox`​（垂直布局）、`HBox`​（水平布局）、`Grid`（网格布局）等
- 容器可以嵌套，形成复杂的 UI 结构
- 负责子元素的布局和尺寸计算

### 组件（`Widget`）

- 具体的交互元素，如 `Label`​、`Button`​、`Entry`​、`Slider` 等
- 所有组件都实现了 `CanvasObject` 接口，可以被添加到容器中

```go
// 容器嵌套示例
content := container.NewVBox(
    widget.NewLabel("用户名:"),
    widget.NewEntry(),
    container.NewHBox( // 嵌套水平容器
        widget.NewButton("确定", func() {}),
        widget.NewButton("取消", func() {}),
    ),
)
mainWindow.SetContent(content) // 窗口内容为顶级容器
```

## 5. 层级关系总结

```
App（应用）
  ├─ Window（窗口1，主窗口）
  │   └─ Canvas（画布）
  │       └─ Content（顶级容器，如VBox）
  │           ├─ Widget（组件1，如Label）
  │           ├─ Widget（组件2，如Entry）
  │           └─ Container（子容器，如HBox）
  │               └─ Widget（组件3，如Button）
  │
  └─ Window（窗口2，子窗口）
      └─ Canvas（画布）
          └─ ...（其他UI元素）
```

## 关键特性

- **单根节点**：每个窗口的内容是一个单一的 `CanvasObject`（通常是容器），形成树形结构
- **布局驱动**：容器通过布局（`Layout`）自动管理子元素的位置和大小，无需手动计算坐标
- **事件冒泡**：用户事件（如点击）会从最底层组件向上传递，直到被处理
- **独立渲染**：每个窗口有自己的渲染上下文，窗口操作（如移动、最小化）不影响其他窗口
