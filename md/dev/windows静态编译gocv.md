---
title: "windows静态编译gocv"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-12-01 14:22:23# #lastmod/2024-12-01 14:22:23#

---

# windows 静态编译 gocv

当前使用版本

- gocv：0.39.0
- go：1.21.13
- opencv：4.10.0
- MinGW-W64：8.1.0
- CMake：3.31.1

## 安装 MinGW-W64

下载 [x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z/download)，解压出来是 `mingw64` 文件夹。

将 `mingw64` 文件夹移动到任意目录安装，如 `D:\mingw64`

将 `bin` 目录 `D:\mingw64\bin` 添加到环境变量 PATH

## 安装 CMake

下载 CMake `https://cmake.org/download/`, 解压，同样将 `bin` 目录添加到环境变量 PATH

## 下载 gocv

在 go 项目目录下执行命令，把 gocv 的源码下到本地。一般会下到 `pkg\mod\gocv.io\x` 目录

~~~powershell
go get -u -d gocv.io/x/gocv
~~~

## 静态编译 opencv

注意：编译opencv前需要将系统环境变量中python先删除，否则编译会出错

进到 `gocv` 这个目录, 修改 `win_build_opencv.cmd` 脚本, 在 cmake 命令末尾添加 `-DWITH_QUIRC=ON`。

quirc 在 gocv 中使用，但在 opencv 的默认规则中被禁用，因此需要通过 `-DWITH_QUIRC=ON` 手动启用它。

~~~
cmake C:\opencv\opencv-4.10.0 -G "MinGW Makefiles" -BC:\opencv\build -DENABLE_CXX11=ON -DOPENCV_EXTRA_MODULES_PATH=C:\opencv\opencv_contrib-4.10.0\modules -DBUILD_SHARED_LIBS=OFF -DWITH_IPP=OFF -DWITH_MSMF=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=ON -DBUILD_opencv_java=OFF -DBUILD_opencv_python=OFF -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=OFF -DBUILD_DOCS=OFF -DENABLE_PRECOMPILED_HEADERS=OFF -DBUILD_opencv_saliency=OFF -DBUILD_opencv_wechat_qrcode=ON -DCPU_DISPATCH= -DOPENCV_GENERATE_PKGCONFIG=ON -DWITH_OPENCL_D3D11_NV=OFF -DOPENCV_ALLOCATOR_STATS_COUNTER_TYPE=int64_t -Wno-dev -DWITH_QUIRC=ON
~~~

然后运行 `win_build_opencv.cmd static` 脚本，需要添加 static 参数设置为静态编译 opencv，最好是使用 cmd 执行，使用 power shell 需要额外手动确认下载文件

opencv 编译成功后会安装到 C 盘的 `C:\opencv\build\install` 文件夹下

系统路径中添加 `C:\opencv\build\install\x64\mingw\bin`

## 静态编译测试gocv

在gocv目录下，使用命令` go build -tags "opencvstatic windows" -o test.exe cmd\version\main.go`

运行 test.exe还是会缺少`libgcc_s_seh-1.dll`,`libstdc+ +-6.dl`，`libwinpthread-1.dll`

如果当前go版本和gocv使用的版本不同会报错`go\pkg\tool\windows_amd64\link.exe: running g++ failed: exit status 1`

### 修改gocv目录下的`cgo_static_windows.go`,`contrib/cgo_static_windows.go` 和`cuda/cgo_static_windows.go`

~~~
/*
#cgo CXXFLAGS:   --std=c++11
#cgo CPPFLAGS:   -IC:/opencv/build/install/include
#cgo LDFLAGS:    -LC:/opencv/build/install/x64/mingw/staticlib -lopencv_stereo4100 -lopencv_tracking4100 -lopencv_superres4100 -lopencv_stitching4100 -lopencv_optflow4100 -lopencv_gapi4100 -lopencv_face4100 -lopencv_dpm4100 -lopencv_dnn_objdetect4100 -lopencv_ccalib4100 -lopencv_bioinspired4100 -lopencv_bgsegm4100 -lopencv_aruco4100 -lopencv_xobjdetect4100 -lopencv_ximgproc4100 -lopencv_xfeatures2d4100 -lopencv_videostab4100 -lopencv_video4100 -lopencv_structured_light4100 -lopencv_shape4100 -lopencv_rgbd4100 -lopencv_rapid4100 -lopencv_objdetect4100 -lopencv_mcc4100 -lopencv_highgui4100 -lopencv_datasets4100 -lopencv_calib3d4100 -lopencv_videoio4100 -lopencv_text4100 -lopencv_line_descriptor4100 -lopencv_imgcodecs4100 -lopencv_img_hash4100 -lopencv_hfs4100 -lopencv_fuzzy4100 -lopencv_features2d4100 -lopencv_dnn_superres4100 -lopencv_dnn4100 -lopencv_xphoto4100 -lopencv_wechat_qrcode4100 -lopencv_surface_matching4100 -lopencv_reg4100 -lopencv_quality4100 -lopencv_plot4100 -lopencv_photo4100 -lopencv_phase_unwrapping4100 -lopencv_ml4100 -lopencv_intensity_transform4100 -lopencv_imgproc4100 -lopencv_flann4100 -lopencv_core4100 -lade -lquirc -llibprotobuf -lIlmImf -llibpng -llibopenjp2 -llibwebp -llibtiff -llibjpeg-turbo -lzlib -lkernel32 -lgdi32 -lwinspool -lshell32 -lole32 -loleaut32 -luuid -lcomdlg32 -ladvapi32 -luser32
*/
~~~

在`-LC:/opencv/build/install/x64/mingw/staticlib`前添加参数`--static`

再次执行build命令，test.exe正常运行并输出

~~~
gocv version: 0.39.0
opencv lib version: 4.10.0
~~~

### 或者用标签`-tags customenv`使用自定义环境

使用自定义环境是需要在执行build命令设置环境，并且每次build都需要设置一次。

不想每次都设置环境的话，可以直接添加到系统环境变量中

cmd

~~~cmd
set CGO_CXXFLAGS="--std=c++11"
set CGO_CPPFLAGS=-IC:\opencv\build\install\include
set CGO_LDFLAGS=--static -LC:/opencv/build/install/x64/mingw/staticlib -lopencv_stereo4100 -lopencv_tracking4100 -lopencv_superres4100 -lopencv_stitching4100 -lopencv_optflow4100 -lopencv_gapi4100 -lopencv_face4100 -lopencv_dpm4100 -lopencv_dnn_objdetect4100 -lopencv_ccalib4100 -lopencv_bioinspired4100 -lopencv_bgsegm4100 -lopencv_aruco4100 -lopencv_xobjdetect4100 -lopencv_ximgproc4100 -lopencv_xfeatures2d4100 -lopencv_videostab4100 -lopencv_video4100 -lopencv_structured_light4100 -lopencv_shape4100 -lopencv_rgbd4100 -lopencv_rapid4100 -lopencv_objdetect4100 -lopencv_mcc4100 -lopencv_highgui4100 -lopencv_datasets4100 -lopencv_calib3d4100 -lopencv_videoio4100 -lopencv_text4100 -lopencv_line_descriptor4100 -lopencv_imgcodecs4100 -lopencv_img_hash4100 -lopencv_hfs4100 -lopencv_fuzzy4100 -lopencv_features2d4100 -lopencv_dnn_superres4100 -lopencv_dnn4100 -lopencv_xphoto4100 -lopencv_wechat_qrcode4100 -lopencv_surface_matching4100 -lopencv_reg4100 -lopencv_quality4100 -lopencv_plot4100 -lopencv_photo4100 -lopencv_phase_unwrapping4100 -lopencv_ml4100 -lopencv_intensity_transform4100 -lopencv_imgproc4100 -lopencv_flann4100 -lopencv_core4100 -lade -lquirc -llibprotobuf -lIlmImf -llibpng -llibopenjp2 -llibwebp -llibtiff -llibjpeg-turbo -lzlib -lkernel32 -lgdi32 -lwinspool -lshell32 -lole32 -loleaut32 -luuid -lcomdlg32 -ladvapi32 -luser32
~~~

powershell

~~~powershell
$env:CGO_CXXFLAGS = "--std=c++11"
$env:CGO_CPPFLAGS = "-IC:/opencv/build/install/include"
$env:CGO_LDFLAGS = "--static -LC:/opencv/build/install/x64/mingw/staticlib -lopencv_stereo4100 -lopencv_tracking4100 -lopencv_superres4100 -lopencv_stitching4100 -lopencv_optflow4100 -lopencv_gapi4100 -lopencv_face4100 -lopencv_dpm4100 -lopencv_dnn_objdetect4100 -lopencv_ccalib4100 -lopencv_bioinspired4100 -lopencv_bgsegm4100 -lopencv_aruco4100 -lopencv_xobjdetect4100 -lopencv_ximgproc4100 -lopencv_xfeatures2d4100 -lopencv_videostab4100 -lopencv_video4100 -lopencv_structured_light4100 -lopencv_shape4100 -lopencv_rgbd4100 -lopencv_rapid4100 -lopencv_objdetect4100 -lopencv_mcc4100 -lopencv_highgui4100 -lopencv_datasets4100 -lopencv_calib3d4100 -lopencv_videoio4100 -lopencv_text4100 -lopencv_line_descriptor4100 -lopencv_imgcodecs4100 -lopencv_img_hash4100 -lopencv_hfs4100 -lopencv_fuzzy4100 -lopencv_features2d4100 -lopencv_dnn_superres4100 -lopencv_dnn4100 -lopencv_xphoto4100 -lopencv_wechat_qrcode4100 -lopencv_surface_matching4100 -lopencv_reg4100 -lopencv_quality4100 -lopencv_plot4100 -lopencv_photo4100 -lopencv_phase_unwrapping4100 -lopencv_ml4100 -lopencv_intensity_transform4100 -lopencv_imgproc4100 -lopencv_flann4100 -lopencv_core4100 -lade -lquirc -llibprotobuf -lIlmImf -llibpng -llibopenjp2 -llibwebp -llibtiff -llibjpeg-turbo -lzlib -lkernel32 -lgdi32 -lwinspool -lshell32 -lole32 -loleaut32 -luuid -lcomdlg32 -ladvapi32 -luser32"
~~~

~~~
go build -tags customenv -o test.exe cmd\version\main.go
~~~

### 其实都是为CGO_LDFLAGS添加参数`--static`
