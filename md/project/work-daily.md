---
title: "work-daily"
date: 2026-06-04
tags: ["project"]
---

#date/2024-10-19 08:32:04# #lastmod/2024-10-19 08:32:04#

---

# word-daily

## 10.18

1. 显示器上多个监控画面每隔一段时间黑屏

   显示器设置显示 9 个监控画面，实际有 10 个监控画面，导致循环翻页。

   修改显示器显示 16 个画面。
2. 电子秤磁盘空间不足，无法使用

   大概率是每次识别商品时会拍照且不删除

   更新系统，自动清理磁盘

### 交换机位置

<div>
<div style="display: flex; flex-wrap: wrap;">
    <img src="https://md.kongseek.com/202410211113370.jpg" alt="97fa2b91ee66e834bbb5b022566b678" style="width: 33.33%;" />
    <img src="https://md.kongseek.com/202410211114840.jpg" alt="780d68960f9bf5db94619ba368252b0" style="width: 33.33%;" />
    <img src="https://md.kongseek.com/202410211114365.png" alt="image-20241021111453584" style="width: 33.33%;" />
    <img src="https://md.kongseek.com/202410211115237.jpg" alt="c061eb260286eb448cda52703af45cc" style="width: 33.33%;" />
    <img src="https://md.kongseek.com/202410211115348.jpg" alt="54b71dbc5676ddf83d4f62b2f3d072e" style="width: 33.33%;" />
</div>
## 10.21
</div>

1. 电子秤按键失效

   虫虫乐园

   换按键解决

## 10.22

1. 音响一直电流音

   音响调到了收音机模式

   将模式调整为音频输入

## 10.23

调了一天电子 cheng

## 10.24

1. 手机看不到监视器画面

   交换机电源损坏，摄象头没有供电了
2. 电子秤转移位置，网络连接从有线改为 WiFi
3. 收银台监控画面与收银信息不匹配

   在收银机修改数据为需要转发的对应摄像头的 ip

## 10.29

换新 AI 称

1. 联网，在电子秤上固定 ip
2. 配置电子秤的设置
3. 商云 X 总部新增电子秤 ip
4. 向 ip 下传商品数据
5. 在电子秤网页端设置价格条样式

## 10.30

电子秤换位置，重新接网线

## 11.27

1. 换收银机主板
2. 送标签纸，称纸，小票纸
3. 送收银机

## 11.28

1. 商云 X 促销活动

   商品直接打折

   商品买一送一

## 12.2

1. 换摄像头位置
2. 重新整理摄像头网络
3. 整理电子价签

## 12.16

换屏幕、接网线

## 12.19

1. 导数据
2. 商云 x 对电子会员
3. 七华称升级，设置标签

## 12.27

1. 汉朔小助手推送电子价签需要注意 wifi 名称和密码不能出错，否则无法还原

## 12.31

1. 商云 X 设置会员积分规则
2. 银豹系统接入 ai 识别称需要在收银系统设置识别码，在称上需要清楚识别码

## 1.3

1. 安装跃臣云美食商业版
   1. 前台 pos 绑定时使用 admin 账号绑定，后续使用收银员账号登录
   2. 需要在后台为收银员账号开启权限
2. SQL Server2008 提示“评估期已过 " 无法打开数据库
   1. 第一步：进入 SQL2008 配置工具中的安装中心
   2. 第二步：再进入维护界面，选择版本升级
   3. 第三步：进入产品密钥，输入密钥
      SQL Server 2008 Developer(开发版)：PTTFM-X467G-P7RH2-3Q6CG-4DMYB
   4. 第四步：一直点下一步，直到升级完毕。再次打开数据库界面就可以
   5. 如果问题依然没有解决还是显示评估期已过
      1. 开始 –> 运行 –> Regedit
      2. 打开注册表后，找到并把 HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\100\ConfigurationState 里的 CommonFiles 值改成 3
      3. SQL Server 安装中心，维护，版本升级重来一次（由于前面已经升级了数据库，所以这次只用升级共享功能组件——下拉选择一下就可以看到）
   6. 如果是从 SQL Server Express 进行的升级，则必须执行以下额外步骤才能使用 SQL Server 的升级实例
      1. setup.exe /q /ACTION = editionupgrade /InstanceName = MSSQLSERVER /PID = FTNGC-R2J97-PJ4QG-U84VB-HTXK8 /SkipRules = Engine_SqlEngineHealthCheck /IACCEPTSQLSERVERLICENSETERMS

## 1.8

1. 大华称
   1. 以太网
   2. 热键
   3. 标签
   4. 先回收，在保存为txt
   5. 然后回收设置快捷键

## 1.16

1. AI称设置要注意传称单位设置为1kg
2. 关闭商云x前台pos的上单信息
   1. 需要直接使用sql语句修改数据库
3. 商云x出现数据库字段无效的相关错误时，需要先关注数据库的版本信息
