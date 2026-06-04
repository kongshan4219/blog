---
title: "云服务器配置SSL证书实现https访问"
date: 2026-06-04
tags: ["linux"]
---

#date/2024-09-21# #lastmod/2024-09-21#

---

## SSL申请工具

[acme.sh](https://github.com/acmesh-official/acme.sh) 实现了 `acme` 协议，可以从 `ZeroSSL`，`Let's Encrypt` 等 CA 生成免费的证书。

## 使用

以下是官方文档

### 安装 acme.sh

安装很简单，一条命令:

```
curl https://get.acme.sh | sh -s email=my@example.com
```

或者

```
wget -O -  https://get.acme.sh | sh -s email=my@example.com
```

普通用户和 root 用户都可以安装使用。

安装过程进行了以下几步:

1. 把 acme.sh 安装到你的 **home** 目录下:

```
~/.acme.sh/
```

并创建 一个 shell 的 alias，例如 `.bashrc`，方便你的使用: `alias acme.sh=~/.acme.sh/acme.sh`

1. 自动为你创建 cronjob， 每天 0:00 点自动检测所有的证书，如果快过期了，需要更新，则会自动更新证书。

更高级的安装选项请参考: https://github.com/acmesh-official/acme.sh/wiki/How-to-install

**安装过程不会污染已有的系统任何功能和文件**，所有的修改都限制在安装目录中: `~/.acme.sh/`

**注意**：如果安装完成后提示 `-bash: acme.sh: command not found`，需要手动执行 `source ~/.bashrc`

**PS：**  安装可能会提示需要先安装socat，不要理会

### 生成证书

我使用的是nginx模式

**acme.sh** 可以智能的从 **Nginx** 的配置中自动完成验证，你不需要指定网站根目录:

```
acme.sh --issue --nginx -d example.com -d www.example.com -d cp.example.com
```

**注意 acme.sh 在完成验证之后，会恢复到之前的状态，不会私自更改程序本身的配置. 好处是你不用担心配置被搞坏，也有一个缺点，你需要自己配置 SSL 项，否则只能成功生成证书，你的网站还是无法正常使用 HTTPS。**

**修改默认 CA**

acme.sh 脚本默认 CA 服务器是 `ZeroSSL`，有时可能会导致获取证书的时候一直出现：`Pending，The CA is processing your order，please just wait.`

只需要把 CA 服务器改成 `Let's Encrypt` 即可，虽然更改以后还是有概率出现 pending，但基本 2-3 次即可成功

```
acme.sh --set-default-ca --server letsencrypt
```

更高级的用法请参考: https://github.com/acmesh-official/acme.sh/wiki/How-to-issue-a-cert

### 复制证书

证书生成好以后，我们需要把证书复制给对应的 Apache、Nginx 或其他服务器去使用。

**必须使用** `--install-cert` 命令来把证书复制到目标文件，请勿直接使用 `~/.acme.sh/` 目录下的证书文件，这里面的文件都是内部使用，而且目录结构将来可能会变化。

```
acme.sh --install-cert -d example.com \
--key-file       /path/to/keyfile/in/nginx/key.pem  \
--fullchain-file /path/to/fullchain/nginx/cert.pem \
--reloadcmd     "service nginx reload"
```

Nginx 的配置项 `ssl_certificate` 需要使用 `/etc/nginx/ssl/fullchain.cer` ，而非 `/etc/nginx/ssl/<domain>.cer` ，否则 [SSL Labs](https://www.ssllabs.com/ssltest/) 的测试会报证书链问题（`Chain issues Incomplete`）。

默认情况下，证书每 60 天更新一次（可自定义）。更新证书后，Nginx 服务会通过 `reloadcmd` 传递的命令自动重载配置。

注意：`reloadcmd` 非常重要。证书会自动申请续签，但是如果没有正确的 `reloadcmd` 命令，证书可能无法被重新应用到 Nginx，因为配置没有被重载。

#### 配置nginx

**配置网站SSL证书**

~~~
server {
    listen       443 ssl;
    server_name  example.com;
    ssl_certificate      /path/to/fullchain/nginx/cert.pem;   # SSL证书配置
    ssl_certificate_key  /path/to/keyfile/in/nginx/key.pem;    # SSL证书配置
    location / {
        root             /usr/share/nginx/www;
        index            index.html index.htm index.php;
    }
}
~~~

**配置 HTTP 重定向到 HTTPS**

~~~
server {
    listen 80;
    server_name example.com;

    return 301 https://$host$request_uri;
}
~~~

### 查看已安装证书信息

```
acme.sh --info -d example.com
```

会输出如下内容：

```
DOMAIN_CONF=/root/.acme.sh/example.com/example.com.conf
Le_Domain=example.com
Le_Alt=no
Le_Webroot=dns_ali
Le_PreHook=
Le_PostHook=
Le_RenewHook=
Le_API=https://acme-v02.api.letsencrypt.org/directory
Le_Keylength=
Le_OrderFinalize=https://acme-v02.api.letsencrypt.org/acme/finalize/23xxxx150/781xxxx4310
Le_LinkOrder=https://acme-v02.api.letsencrypt.org/acme/order/233xxx150/781xxxx4310
Le_LinkCert=https://acme-v02.api.letsencrypt.org/acme/cert/04cbd28xxxxxx349ecaea8d07
Le_CertCreateTime=1649358725
Le_CertCreateTimeStr=Thu Apr  7 19:12:05 UTC 2022
Le_NextRenewTimeStr=Mon Jun  6 19:12:05 UTC 2022
Le_NextRenewTime=1654456325
Le_RealCertPath=
Le_RealCACertPath=
Le_RealKeyPath=/etc/acme/example.com/privkey.pem
Le_ReloadCmd=service nginx force-reload
Le_RealFullChainPath=/etc/acme/example.com/chain.pem
```

### 更新证书

目前证书每 60 天自动更新，你无需任何操作。

但是你也可以强制续签证书：

```
acme.sh --renew -d example.com --force
```

### 关于修改 `reloadcmd`

目前修改 `reloadcmd` 没有专门的命令，可以通过重新安装证书来实现修改 `reloadcmd` 的目的。

此外，安装证书后，相关信息是保存在 `~/.acme.sh/example.com/example.conf` 文件下的，内容就是 `acme.sh --info -d example.com` 输出的信息，不过 `reloadcmd` 在文件中使用了 Base64 编码。理论上可以通过直接修改该文件来修改 `ReloadCmd`，且修改时，无需 Base64 编码，直接写命令原文 `acme.sh` 也可以识别。

不过，由于 `example.conf` 文件的位置和内容格式以后可能会改变，且 `example.conf` 一直都是内部使用，后续也有可能会改为用 SQLite 或者 MySQL 格式存储. 所以一般不建议自己修改。

### 更新 acme.sh

acmd.sh 还在不断开发中，因此强烈建议保持并使用最新的版本。

升级 acme.sh 到最新版：

```
acme.sh --upgrade
```

如果你不想手动升级，可以开启自动升级:

```
acme.sh --upgrade --auto-upgrade
```

之后，acme.sh 就会自动保持更新了。

你也可以随时关闭自动更新:

```
acme.sh --upgrade --auto-upgrade  0
```
