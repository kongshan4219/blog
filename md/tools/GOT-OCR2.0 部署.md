---
title: "GOT-OCR2.0 部署"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-12-31 23:58:37# #lastmod/2024-12-31 23:58:37#

---

# GOT-OCR2.0 部署

## 克隆仓库

~~~
git clone git@github.com:Ucas-HaoranWei/GOT-OCR2.0.git
~~~

## 安装cuda

~~~
nvcc --version
~~~

## 使用Anaconda Prompt

~~~
cd GOT-OCR2.0/GOT-OCR-2.0-master/
~~~

~~~
conda create -n got python=3.10 -y
conda activate got
~~~

### 安装 PyTorch 和 TorchVision

~~~
pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118
~~~

~~~
pip install -e .
~~~

## 安装DeepSpeed报错（Unable to pre-compile async_io）

[链接](https://blog.csdn.net/2401_82799238/article/details/137292726)

### 首先通过git下载deepspeed：

~~~
git clone https://github.com/microsoft/DeepSpeed.git
~~~

### 运行如下命令：

~~~
Set-Item Env:\DS_BUILD_OPS 0
set DS_BUILD_OPS=0
~~~

### 进入deepspeed文件夹下，运行build_win.bat编译DeepSpeed

### 进入dist文件夹，运行pip install命令进行安装

~~~
 pip install .\deepspeed-0.14.1+unknown-py3-none-any.whl
~~~

### 也可以直接使用官方的Github项目地址发布的whl包

[whl](https://github.com/melMass/DeepSpeed/releases/tag/v0.14.3)

~~~
pip install deepspeed-0.14.3+cf8316a4-cp310-cp310-win_amd64.whl
~~~

### **修改pyproject.toml 文件中的安装deepspeed版本设置（默认版本的没有在官方下找到对应whl包），再返回进行pip install -e . 才能安装成功**

![image-20250101114915678](https://md.kongseek.com/image-20250101114915678.png)

## 测试

~~~
python GOT/demo/run_ocr_2.0.py --model-name "D:\Application\Develop\Project\python\GOT-OCR2.0\GOT-OCR-2.0-master\GOT\GOT_weights" --image-file "D:\User\yaoye\Pictures\QQ20241226-004924.png" --type ocr
~~~
