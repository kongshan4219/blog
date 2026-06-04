---
title: "launch4j-maven-plugin"
date: 2026-06-04
tags: ["dev"]
---

#date/2025-01-26 14:48:27# #lastmod/2025-01-26 14:48:27#

---

# launch4j-maven-plugin

~~~yaml
 <plugin>
          <groupId>com.akathist.maven.plugins.launch4j</groupId>
          <artifactId>launch4j-maven-plugin</artifactId>
          <executions>
            <execution>
              <id>l4j-clui</id>
              <phase>package</phase>
              <goals><goal>launch4j</goal></goals>
              <configuration>
                <headerType>console</headerType>
                <outfile>target/encc.exe</outfile>
                <jar>target/encc-1.0.jar</jar>
                <errTitle>encc</errTitle>
                <classPath>
                  <mainClass>com.akathist.encc.Clui</mainClass>
                  <addDependencies>false</addDependencies>
                  <preCp>anything</preCp>
                </classPath>
                <jre>
                  <minVersion>1.5.0</minVersion>
                </jre>
                <versionInfo>
                  <fileVersion>1.2.3.4</fileVersion>
                  <txtFileVersion>txt file version?</txtFileVersion>
                  <fileDescription>a description</fileDescription>
                  <copyright>my copyright</copyright>
                  <productVersion>4.3.2.1</productVersion>
                  <txtProductVersion>txt product version</txtProductVersion>
                  <productName>E-N-C-C</productName>
                  <internalName>ccne</internalName>
                  <originalFilename>original.exe</originalFilename>
                </versionInfo>
              </configuration>
            </execution>
                <execution>
                  <id>l4j-gui</id>
                  <phase>package</phase>
                  <goals><goal>launch4j</goal></goals>
                  <configuration>
                    <headerType>gui</headerType>
                    <outfile>target/enccg.exe</outfile>
                    <jar>target/encc-1.0.jar</jar>
                    <errTitle>enccg</errTitle>
                    <classPath>
                      <mainClass>com.akathist.encc.Gui</mainClass>
                    </classPath>
                    <jre>
                      <minVersion>1.5.0</minVersion>
                    </jre>
                    <versionInfo>
                      <fileVersion>1.2.3.4</fileVersion>
                      <txtFileVersion>txt file version?</txtFileVersion>
                      <fileDescription>a description</fileDescription>
                      <copyright>my copyright</copyright>
                      <productVersion>4.3.2.1</productVersion>
                      <txtProductVersion>txt product version</txtProductVersion>
                      <productName>E-N-C-C</productName>
                      <internalName>ccne</internalName>
                      <originalFilename>original.exe</originalFilename>
                    </versionInfo>
                  </configuration>
                </execution>
          </executions>
        </plugin>
~~~

这是一个使用 **Launch4j Maven 插件**的配置示例，用于将 Java 应用打包成 Windows 可执行文件（`.exe`）。该配置通过 **两个执行流程** 分别生成 **控制台版本** 和 **GUI 版本** 的可执行文件。以下是逐层解析：

---

### 1️⃣ **插件基础信息**

```xml
<groupId>com.akathist.maven.plugins.llaunch4j</groupId>
<artifactId>launch4j-maven-plugin</artifactId>
```

- 使用第三方插件 **launch4j-maven-plugin**，用于将 Java 应用转换为 Windows 原生可执行文件
- 官方文档：[Launch4j Maven Plugin](http://launch4j.sourceforge.net/)

---

### 2️⃣ **双执行流程设计**

```xml
<executions>
  <!-- 第一个执行流程：生成控制台版 EXE -->
  <execution>
    <id>l4j-clui</id>
    <phase>package</phase>
    <goals><goal>launch4j</goal></goals>
    <configuration>...</configuration>
  </execution>

  <!-- 第二个执行流程：生成 GUI 版 EXE -->
  <execution>
    <id>l4j-gui</id>
    <phase>package</phase>
    <goals><goal>launch4j</goal></goals>
    <configuration>...</configuration>
  </execution>
</executions>
```

- **双 ID 区分**：`l4j-clui`（控制台版）和 `l4j-gui`（GUI 版）
- **绑定阶段**：均绑定到 `package` 生命周期阶段（执行 `mvn package` 时触发）
- **独立配置**：每个 `<execution>` 拥有独立的 `<configuration>`

---

### 3️⃣ **核心配置对比**

|配置项|控制台版 (`l4j-clui`)|GUI 版 (`l4j-gui`)|作用说明|
| ------| -----------| ---------| ------------------------------------------|
| **​`<headerType>`​**|`console`|`gui`|定义 EXE 类型（控制台窗口 / 无控制台窗口）|
| **​`<outfile>`​**|`target/encc.exe`|`target/enccg.exe`|输出的 EXE 文件名|
| **​`<jar>`​**|`target/encc-1.0.jar`|`target/encc-1.0.jar`|依赖的 JAR 文件路径（需先通过 `mvn package` 生成）|
| **​`<errTitle>`​**|`encc`|`enccg`|错误弹窗标题（GUI 版生效）|
| **​`<mainClass>`​**|`com.akathist.encc.Clui`|`com.akathist.encc.Gui`|主类入口（分别对应控制台和 GUI 的启动类）|

---

### 4️⃣ **其他关键配置**

#### 🔹 类路径配置 (`<classPath>`)

```xml
<classPath>
  <mainClass>...</mainClass>
  <addDependencies>false</addDependencies>
  <preCp>anything</preCp>
</classPath>
```

- **​`addDependencies`​**:
  - `false` 表示不自动添加项目依赖到 classpath
  - 若需要包含依赖，需改为 `true` 并配置 `<dependency>` 范围
- **​`preCp`​**:
  - 预定义 classpath（此处示例值 `anything` 需替换为实际路径）
  - 例如：`<preCp>lib/*.jar</preCp>`

#### 🔹 JRE 版本要求 (`<jre>`)

```xml
<jre>
  <minVersion>1.5.0</minVersion>
</jre>
```

- 指定运行所需 **最低 JRE 版本**（此处 1.5.0 极低，建议升级到 1.8+）
- 可扩展配置：
  ```xml
  <jre>
    <path>jre</path>              <!-- 嵌入 JRE 的路径 -->
    <maxVersion>11.0.0</maxVersion>
    <jdkPreference>jreOnly</jdkPreference>
  </jre>
  ```

#### 🔹 版本元信息 (`<versionInfo>`)

```xml
<versionInfo>
  <fileVersion>1.2.3.4</fileVersion>          <!-- EXE 文件版本 (四段式) -->
  <txtFileVersion>txt file version?</txtFileVersion>  <!-- 资源管理器显示的版本 -->
  <fileDescription>a description</fileDescription>    <!-- 文件描述 -->
  <copyright>my copyright</copyright>         <!-- 版权信息 -->
  <productVersion>4.3.2.1</productVersion>     <!-- 产品版本 -->
  <productName>E-N-C-C</productName>           <!-- 产品名称 -->
</versionInfo>
```

- 这些信息会写入 EXE 文件的属性页（右键 EXE → 属性 → 详细信息）

---

### 5️⃣ **典型执行流程**

```bash
mvn clean package
```

执行后会生成：

1. `target/encc.exe`（控制台版）
2. `target/enccg.exe`（GUI 版）
3. 原始 JAR 文件 `target/encc-1.0.jar`

---

### 6️⃣ **常见问题排查**

1. **EXE 文件无法运行**：

   - 检查 JAR 文件是否已正确生成
   - 确认 `<mainClass>` 路径是否正确
   - 使用 `-X` 参数查看调试信息：
     ```bash
     mvn clean package -X
     ```
2. **依赖缺失**：

   - 若运行时提示 `ClassNotFoundException`，需设置 `<addDependencies>true</addDependencies>`
   - 或手动配置 `<preCp>` 指向依赖目录
3. **版本号格式错误**：

   - `fileVersion` 和 `productVersion` 需符合四段式格式（如 `1.2.3.4`）
   - 非数字字符会导致编译失败
4. **重复执行冲突**：

   - 两个 `<execution>` 绑定到同一阶段可能引发顺序问题
   - 可通过 `<phase>` 拆分到不同阶段（如 `prepare-package` 和 `package`）

---

### 7️⃣ **扩展建议**

- **资源嵌入**：通过 `<resource>` 配置将图标、配置文件等打包进 EXE
  ```xml
  <configuration>
    <icon>src/main/resources/app.ico</icon>
    <jre>
      <bundledJrePath>jre</bundledJrePath>
    </jre>
  </configuration>
  ```
- **签名 EXE**：添加数字签名提升安全性
  ```xml
  <signature>
    <keystore>path/to/keystore</keystore>
    <alias>myalias</alias>
    <storepass>password</storepass>
  </signature>
  ```
