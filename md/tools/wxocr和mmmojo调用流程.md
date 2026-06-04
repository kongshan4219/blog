---
title: "wxocr和mmmojo调用流程"
date: 2026-06-04
tags: ["tools"]
---

#date/2025-01-09 23:28:12# #lastmod/2025-01-09 23:28:12#

---

# wxocr和mmmojo调用流程

1. 文字版执行流程图

```
[main()]
│
├─> OcrManager.__init__(wechat_dir)
│    │
│    ├─> 输入：wechat_dir (微信安装目录)
│    ├─> 输出：初始化后的OcrManager实例
│    ├─> 内部流程：
│    │   ├─> platform.architecture() → 判断系统架构
│    │   ├─> os.path.join() → 构造mmmojo_dllpath
│    │   ├─> MmmojoDll.__init__(mmmojo_dllpath)
│    │   │    ├─> CDLL加载DLL文件
│    │   │    └─> init_funcs() 加载28个函数指针
│    │   ├─> Queue(OCR_MAX_TASK_ID) → 初始化任务队列
│    │   └─> m_id_path = {} 初始化任务字典
│    │
├─> SetExePath(wechat_ocr_dir)
│    │
│    ├─> 输入：exe_path (WeChatOCR.exe路径)
│    ├─> 输出：设置self.m_exe_path
│    ├─> 内部检查：
│    │   ├─ if not exe_path.endswith("WeChatOCR.exe") → 自动补全路径
│    │   └─ os.path.exists() 验证路径有效性
│    │
├─> SetUsrLibDir(wechat_dir)
│    │
│    ├─> 输入：usr_lib_dir (微信主程序目录)
│    ├─> 输出：设置self.m_usr_lib_dir
│    ├─> 调用链：
│    │   └─> AppendSwitchNativeCmdLine("user-lib-dir", usr_lib_dir)
│    │       ├─> 输入：arg="user-lib-dir", value=usr_lib_dir
│    │       └─> 输出：self.m_switch_native字典添加条目
│    │
├─> StartWeChatOCR()
│    │
│    ├─> 关键调用链：
│    │   ├─> InitMMMojoEnv()
│    │   │    ├─> self._dll.InitializeMMMojo(0, None)
│    │   │    │    ├─> 输入：argc=0, argv=None
│    │   │    │    └─> 输出：初始化Mojo底层环境
│    │   │    │
│    │   │    ├─> CreateMMMojoEnvironment()
│    │   │    │    ├─> 输入：无
│    │   │    │    └─> 输出：c_void_p环境指针
│    │   │    │
│    │   │    ├─> SetMMMojoEnvironmentCallbacks()
│    │   │    │    ├─> 输入：
│    │   │    │    │   - env_ptr: 环境指针
│    │   │    │    │   - callback_type: kMMUserData
│    │   │    │    │   - py_object(self)
│    │   │    │    └─> 输出：设置用户数据指针
│    │   │    │
│    │   │    ├─> SetDefaultCallbacks()
│    │   │    │    ├─> 遍历MMMojoEnvironmentCallbackType枚举
│    │   │    │    │   └─> 对每个类型设置回调：
│    │   │    │    │       ├─> 获取回调函数地址
│    │   │    │    │       └─> SetMMMojoEnvironmentCallbacks()
│    │   │    │    └─> 输出：完成4个核心回调注册
│    │   │    │
│    │   │    └─> StartMMMojoEnvironment()
│    │   │         ├─> 输入：env_ptr
│    │   │         └─> 输出：启动WeChatOCR.exe子进程
│    │   │
│    ├─> 状态变更：
│    │   └─> m_wechatocr_running = True
│    │
├─> DoOCRTask(pic_path)
│    │
│    ├─> 输入：pic_path (图片路径)
│    ├─> 输出：发送OCR任务到子进程
│    ├─> 详细流程：
│    │   ├─> os.path.abspath() 标准化路径
│    │   ├─> while循环等待m_connect_state.value变为True
│    │   ├─> GetIdleTaskId()
│    │   │    ├─> 从Queue获取可用ID (阻塞1秒)
│    │   │    └─> 返回task_id或None
│    │   ├─> SendOCRTask()
│    │   │    ├─> 构造ocr_protobuf_pb2.OcrRequest对象
│    │   │    │    ├─> task_id分配
│    │   │    │    └─> pic_path添加到pic_paths
│    │   │    ├─> SerializeToString() 序列化
│    │   │    └─> SendPbSerializedData()
│    │   │         ├─> 调用DLL函数：
│    │   │         │   ├─> CreateMMMojoWriteInfo()
│    │   │         │   │    ├─> 输入：method=kMMPush
│    │   │         │   │    └─> 输出：write_info指针
│    │   │         │   │
│    │   │         │   ├─> GetMMMojoWriteInfoRequest()
│    │   │         │   │    ├─> 输入：write_info, pb_size
│    │   │         │   │    └─> 输出：request内存指针
│    │   │         │   │
│    │   │         │   ├─> memmove() 数据拷贝
│    │   │         │   └─> SendMMMojoWriteInfo()
│    │   │         │        ├─> 输入：env_ptr, write_info
│    │   │         │        └─> 输出：发送成功状态
│    │   │         │
│    │   ├─> 记录任务ID到m_id_path字典
│    │
├─> [回调触发] OCRReadOnPush()
│    │
│    ├─> 输入参数：
│    │   - request_id: c_uint32
│    │   - request_info: c_void_p
│    │   - user_data: py_object
│    ├─> 处理流程：
│    │   ├─> GetPbSerializedData()
│    │   │    ├─> 调用DLL函数：
│    │   │    │   └─> GetMMMojoReadInfoRequest()
│    │   │    │        ├─> 输入：request_info指针
│    │   │    │        └─> 输出：pb_data指针和data_size
│    │   │    │
│    │   ├─> 构造ocr_response_ubyte数组
│    │   ├─> ParseFromString() 反序列化Protobuf
│    │   ├─> parse_json_response()
│    │   │    ├─> 输入：json_response_str
│    │   │    └─> 输出：结构化OCR结果字典
│    │   ├─> 调用用户回调ocr_result_callback()
│    │   └─> SetTaskIdIdle() 回收任务ID
│    │
└─> KillWeChatOCR()
     │
     ├─> 关键调用链：
     │   ├─> StopMMMojoEnvironment()
     │   │    ├─> 输入：env_ptr
     │   │    └─> 输出：停止消息循环
     │   │
     │   ├─> RemoveMMMojoEnvironment()
     │   │    ├─> 输入：env_ptr
     │   │    └─> 输出：释放环境资源
     │   │
     │   └─> 状态重置：
     │       ├─> m_connect_state.value = False
     │       └─> m_wechatocr_running = False
```
