---
title: "通用SSH密钥对"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-10-16 17:10:26# #lastmod/2024-10-16 17:10:26#

---

# 通用SSH密钥对

SSH 密钥对生成命令

```
root@kongshan-ubuntu:/opt/application/vue_press# ssh-keygen -t rsa -b 4096 -C "2996014561@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:aBGLco/pM+DE8RTq76pZYC1V0a2hW7SV3okVy8c+q8c 2996014561@qq.com
The key's randomart image is:
+---[RSA 4096]----+
|    .o+ . ...    |
|   ..o * +..o    |
|  +.+ = * +o.o   |
| oo* = * o oo    |
|.o=.+ * S    o   |
|.+.+ o        o  |
|  o =       ..   |
| o . o      .E   |
|o....      ..    |
+----[SHA256]-----+
```

id_rsa 私钥

```
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
```

id_rsa.pub 公钥

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPnvnINv2O+qNVcsM3hcq9wdN+soei09PS1ocl5s+kAjvXiD7gYMJYQ9p6ZzUh2DzFIXrNMZuU7KFpRgXTMCdACP32ra1uDD45RD3xZzDRJi7GeL9gBrZmCYgReSLx2+ZiQEnsuHizbb14ja59yGfKFVa31SdRPrUOelZ2wW6ZZFw8EnPOnO20LPCJ6oonL6mFR41dNePOEhuoYzabWIuHzSHf7FaEi1pP6AO8XRkeUgp7zVnZquIWM3Lbdc77xfrIKrKAq/oZOb4nccoZH2yy0oQn06GEubQMbip54OcJ7WihlLHZExzTYzwp0NIe4ndhAN4P3kcvDmIVTUtFI/I6tgI/vVQAHRTg9fdlPaTJpcrFaqlzPw4uqTde+9n+LPsbZQv9JEg1mdRaifopeWQxoP7Wju5eTmfF1wBRyGhn7eW7ltQU74hXqFSGK8CXitFW1BdnvHIjspedDzRoD7blIhR8c1IRHKAP83aiDuVxyCIL33B7sRvoYnx206nqH83zy4uL1EPotPGvomuUuTTaFD9l8ukoTsMkxPDRx0D7931Jw8kMQa8yzHx0rPakSmt3a2g45Aa5Jasn3i4g1RuXy+TaLs7vySECkDZuBlaJMfJoFBXOgOT5NYN1xgKuWiyUwU0P9996EUElf3Zf+66ZF6PxxlLA9Il2+vkpQxlWJQ== 2996014561@qq.com
```

## github ssh 克隆密钥对

SSH 密钥对生成命令

```
root@VM-4-15-debian:~# ssh-keygen -t rsa -b 4096 -C "2996014561@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:zFoZ6W2LWTZGxO+mVl5wqP59RXHrnaz9txq+wQaoAuI 2996014561@qq.com
The key's randomart image is:
+---[RSA 4096]----+
|         ..      |
|         o.    ..|
|        o .. .  +|
|       + =. + ...|
| . .    S.B+ oo.o|
|. . .  o.B.o* .+o|
| E   ...o..= *o .|
|      .   + +oo.o|
|         . ..++o=|
+----[SHA256]-----+
root@VM-4-15-debian:~# 

```

id_rsa 私钥

```
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
```

id_rsa.pub 公钥

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDf/dpXyLaCOAfcIcRhXQ2tp978Ur4ut7S+qCou2lguiXBhWw5eT0RvMOXhGwzMWpiey45FLtx6j0jGncqccqQTdXCOiiPemySjBakWmeu2t4uQxf6Ym4C5bnzVQ+CoE0Kjwt+drBux9vIFcvrkwHvbD+nohcxc5z4pLAoGZZXLYUk1l+ouPQDoVQjeFqN+wVYzovKHWb6occaZ3ZIU6RUm7sHNEZZFm69NQdbci1PWhoHtd92+xmbE5RqgqswjI6PZrBKImawaBMoNPUrboD+H09lblzl+d1wyfLuz36lhbG/qA0TEaqUXKa9j7b8TVTmoBSGDCdvfUIhyxNOuJzlKDmYH2lTjqb2GLJ1jTQId+RS4BaT9IRPBI3bNr19kVCoU+yO0JlUyK37vri4+K5Nn4BhasYPUXsnjY/d5LpfIP7YG67X2AldAUcJ0R67eCSVuzZh9lA2tXeMEiYWHLm/HStDsNIgQ871Ly1JhDKO8MxES8lmNV+vDWgoyR2+5feQHoQli6Uvbr28bYwBYslcko2FsFpYeFonYkMHd3CaYNyJ2dxKLTaJqX0OqN7Ay76DYsR9j4NY6O1pehJYYytrstNm19sAwHq2aU2PoHcmdLkBb3VYVl4ylgI8TU4OG9SMRYCW3sFTvzPALBc+VMaW3jg5C2ubFLniv/0Ra8AKAGw== 2996014561@qq.com
```
