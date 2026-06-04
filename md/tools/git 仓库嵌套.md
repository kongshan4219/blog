---
title: "git 仓库嵌套"
date: 2026-06-04
tags: ["tools"]
---

#date/2020-01-01# #lastmod/2020-01-01#

当你在一个 Git 仓库中添加子模块（submodule）时，实际上是在该仓库中添加了一个指向另一个 Git 仓库的引用。具体来说，当你使用 `git submodule add <repository> <path>` 命令时，会执行以下操作：

1. **添加子模块**:
   - 在父仓库的 `.gitmodules` 文件中添加一个新的条目，记录子模块的 Git 仓库 URL 和子模块在父仓库中的路径。
   - 在指定的 `<path>` 目录下创建一个新目录，并在这个目录中初始化一个新的 Git 仓库，该仓库指向 `<repository>`。
2. **初始化子模块**:
   - 默认情况下，添加子模块后，还需要使用 `git submodule init` 和 `git submodule update` 命令来初始化并更新子模块，以便实际下载子模块的内容。
   - 如果你只想添加子模块而不立即下载内容，可以直接添加；但要使用子模块的内容，必须先初始化并更新。

### 嵌套仓库的克隆行为

当你直接克隆一个包含子模块的父仓库时，默认情况下不会同步拉取子模块的数据。这是因为克隆操作默认不会执行子模块的初始化和更新。如果你希望在克隆时也拉取子模块的数据，可以使用带有特定选项的克隆命令。

#### 克隆包含子模块的仓库

1. **默认克隆**:

   ```
   ```

git clone <parent-repository-url>

```

这种方式只会克隆父仓库，子模块的状态会被记录，但子模块的实际内容不会被拉取。

2. **克隆并初始化子模块**:

```

git clone --recurse-submodules <parent-repository-url>

```

使用 `--recurse-submodules` 选项会在克隆时自动初始化并更新子模块，从而拉取子模块的内容。

3. **克隆后手动初始化和更新子模块**: 如果你已经克隆了父仓库，但没有拉取子模块，可以手动初始化和更新子模块：

```

cd <parent-repository>
git submodule init
git submodule update

```

### 示例

假设你有一个父仓库 `parent-repo`，并且你想添加一个子模块 `child-repo` 到 `parent-repo` 的 `child` 目录下：

1. **添加子模块**:

```

cd parent-repo
git submodule add https://github.com/user/child-repo.git child

```

2. **克隆包含子模块的父仓库**:

```

git clone --recurse-submodules https://github.com/user/parent-repo.git

```

通过这种方式，你可以确保在克隆父仓库时同时拉取子模块的数据。如果不需要立即拉取子模块的数据，可以在后续需要时手动初始化和更新子模块。

---

先在主仓库删除需要作为子仓库的文件夹，如果提交修改

```

git add .
git commit -m "Remove _posts from index to add as a submodule"

```

将 `source/_posts` 作为子模块添加到主仓库中

```

git submodule add https://github.com/[已脱敏]/article.git source/_posts

```

添加完成后，提交子模块更改, 将这些更改提交到主仓库

```

git add .
git commit -m "Add _posts as a git submodule"

```

最后，将这些更改推送到远程主仓库。

```

git push origin master

```

当子仓库更新时，主仓库拉取子仓库更新

```

git submodule update --remote

```

ps: 子仓库更新后，主仓库执行 git submodule update --remote 时，会视为修改了子仓库文件夹



### 后续在其他地方clone仓库

### 步骤1：克隆主仓库

首先，克隆包含子模块的主仓库：

```

git clone <repository-url>

```

### 步骤2：初始化和更新子模块

进入克隆下来的主仓库目录，并初始化和更新子模块：

```

cd <repository-name>
git submodule update --init --recursive

```

- `git submodule update --init` 会初始化并更新子模块。
- `--recursive` 选项会递归地初始化和更新所有嵌套的子模块。
```
