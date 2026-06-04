---
title: "git 回滚"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-09-25# #lastmod/2024-09-25#

---

### 查看分支提交历史，确认需要回退的版本

~~~bash
git log
~~~

### 进行版本回退

~~~bash
git reset --hard commit_id
~~~

### 推送至远程分支

直接 `git push origin` 会报错，因为本地分支已经回滚，提交历史与远程分支不一致，导致 Git 拒绝推送。

Git 会提示需要先合并远程的更改，然后再推送。

所以需要强制推送，覆盖远程分支的提交历史。**强制推送会覆盖远程分支的历史,导致远程分支的领先的所有提交丢失**

~~~
git push --force origin
~~~
