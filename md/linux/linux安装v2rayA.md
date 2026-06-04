---
title: "linux安装v2rayA"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-12# #lastmod/2024-09-12#

---

### 来源：https://github.com/ningmoon/v2ray

### 安装 V2ray 内核

v2rayA 的功能依赖于 V2Ray 内核，所以需要先装内核

V2Ray 官方脚本 安装参考：https://github.com/v2fly/fhs-install-v2ray

Xray 官方脚本 安装参考：https://github.com/XTLS/Xray-install

本次内核安装基于 v2rayA 官方镜像安装：

```
curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash
```

## 安装 V2rayA

1. 添加公钥

```
wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/v2raya.asc   #添加公钥
```

```
echo "deb https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list    #添加v2rayA软件源
sudo apt update    #更新软件源
```

2. 安装 v2rayA

```
sudo apt install v2raya
```

3. 启动 v2rayA

```
sudo systemctl start v2raya.service
```

部署成功！

## GUI 界面

通过 2017 端口进入 web 管理界面

> [http://localhost: 2017](http://localhost:2017/)

如果无法访问请检查服务是否启动！

![在这里插入图片描述](https://md.kongseek.com/v2raya2.png)

第一次进入创建一个管理员账号和密码。后续重置可以通过命令：

```
sudo v2raya --reset-password  #重置密码
```

第一次进入之后导入你的订阅链接，或是输入自己部署的节点！

导入之后点击更新，之后切换标签至你的节点处查看你的全部节点情况

![在这里插入图片描述](https://md.kongseek.com/v2raya3.png)
在未启动服务时，连接的节点呈现柚红色。我们在左上角点击相应按钮启动服务。

选择一个或多个节点连接。这里不建议选择过多的节点，4 个以内为佳。之后启动服务！启动之后启动的节点呈现蓝色，左上角的图标也显示为蓝色的正在运行。启动成功。

![在这里插入图片描述](https://md.kongseek.com/v2raya4.png)
配置代理

默认情况下 v2rayA 会通过核心开放 20170(socks5), 20171(http), 20172(带分流规则的 http) 端口。
![Linux 使用 v2ray 客户端带 WEB GUI 部署教程](https://md.kongseek.com/v2raya5.png)

这种方法是 v2rayA 推荐的方法。它相比于其他方法具有诸多优势，v2rayA 可以一键开启透明代理，为所有程序提供代理服务。

在设置中选择透明代理的分流方式，以及实现方式，然后保存即可。

注意，如需选择 GFWList，需要下载对应的规则库，请点击右上角的更新以完成下载。
