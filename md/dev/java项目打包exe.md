---
title: "java项目打包exe"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-11-21 22:12:20# #lastmod/2024-11-21 22:12:20#

---

# java 项目打包 exe

~~~
& "D:\Application\Develop\jdks\17.0.13\bin\jpackage.exe" --type app-image --input "D:\Application\Develop\build\jar" --runtime-image "D:\Application\Develop\jdks\17.0.13\jre" --name "test003" --main-jar "auto-toy-1.0-SNAPSHOT.jar" --main-class "com.kongshan.Main" --dest "D:\Application\Develop\build\exe" --win-console --app-version "1.0.0" --vendor "Kongshan Dev" --copyright "Copyright 2024 Kongshan" --description "A simple toy application created with Java."
~~~

## jpackage 使用

## launch4j-maven-plugin

~~~xml
<plugin>
    <groupId>com.akathist.maven.plugins.launch4j</groupId>
    <artifactId>launch4j-maven-plugin</artifactId>
    <version>2.5.2</version>
    <executions>
        <execution>
            <id>launch4j</id>
            <phase>package</phase>
            <goals>
                <goal>launch4j</goal>
            </goals>
            <configuration>
                <headerType>console</headerType> <!-- gui 或 console -->
                <outfile>${project.build.directory}/../out/${project.artifactId}.exe</outfile>
                <jar>${project.build.directory}/${project.build.finalName}.jar</jar>
                <errTitle>Error</errTitle>
                <classPath>
                    <mainClass>com.kongshan.Main</mainClass>
                </classPath>
                <chdir>.</chdir>
                <priority>normal</priority>
                <downloadUrl>http://java.com/download</downloadUrl>
                <supportUrl>https://yaoye.me</supportUrl>
                <stayAlive>false</stayAlive>
                <!-- JRE 配置 -->
                <jre>
                    <path>./jre</path>
                </jre>
                <versionInfo>
                    <fileVersion>1.0.0.0</fileVersion>
                    <txtFileVersion>1.0.0.0</txtFileVersion>
                    <fileDescription>My Application</fileDescription>
                    <copyright>Copyright (C) 2024</copyright>
                    <productVersion>1.0.0.0</productVersion>
                    <txtProductVersion>1.0.0.0</txtProductVersion>
                    <productName>My Application</productName>
                    <internalName>myapp</internalName>
                    <originalFilename>myapp.exe</originalFilename>
                </versionInfo>
            </configuration>
        </execution>
    </executions>
</plugin>
~~~

### 标签分析

#### headerType标签

launch4j-maven-plugin 中的 headerType 标签是用来设置生成的可执行文件的窗口类型的，具体可选的类别如下：

- console：控制台窗口，不带 UI。
- gui：带有界面（有 icon 等属性）的窗口，可以在 Windows 操作系统中看到窗体的图标和信息。
- service：用于创建 Windows Service（Windows 服务），通常使用于后台程序。

其中，如果设置为 console 类型，则会使用纯文本命令行界面，如果设置为 gui 类型，则可以自定义窗口的图标和信息，如果设置为 service 类型，则会作为后台服务运行，即使控制台窗口被关闭也不会影响服务的运行。

#### outfile标签

launch4j-maven-plugin 插件中的 outfile 标签是用来设置生成的可执行文件的输出路径和名称的。该标签设置的内容为生成的可执行文件的完整路径，如果只指定文件名，则会在插件的工作目录下生成可执行文件。
该标签的属性有以下几个：

- value：设置生成的可执行文件的完整路径及名称。
- replaceExtension：指定一个布尔值，如果为 true，则会将 outfile 指定的文件的扩展名替换为 exe。例如：将 "myapp.jar" 替换为 "myapp.exe"。
- createHeader：指定一个布尔值，如果为 true，则会在可执行文件顶部创建一个文件头信息，在文件的属性中可以查看到相关信息。

#### jar标签

launch4j-maven-plugin 插件中的 jar 标签是用来设置要生成的可执行文件所依赖的 jar 包的路径的。该标签的属性有以下两个：

- value：设置要生成的可执行文件所依赖的 jar 包的相对路径或绝对路径。
- path：设置要生成的可执行文件所依赖的 jar 包的类路径，这个路径是相对于生成的可执行文件的路径来定义的。

在使用 launch4j-maven-plugin 生成可执行文件时，需要在 pom.xml 文件中指定要包含哪些 jar 包。如果要生成的可执行文件有依赖其他的 jar 包，需要在该插件的配置文件中加入相应的依赖项，具体方法如下：

~~~
<build>
        <plugins>
            <plugin>
                <groupId>com.akathist.maven.plugins.launch4j</groupId>
                <artifactId>launch4j-maven-plugin</artifactId>
                <version>1.7.25</version>
                <executions>
                    <execution>
                        <id>l4j-clui</id>
                        <phase>package</phase>
                        <goals><goal>launch4j</goal></goals>
                        <configuration>
                            <!--运行方式，控制台-->
                            <headerType>gui</headerType>
 
                            <!--输出的exe文件-->
                            <outfile>${project.build.directory}/WeiKeDownload.exe</outfile>
 
                            <!--输出的jar-->
                            <jar>${project.build.directory}/${artifactId}-${version}.jar</jar>
                            <!--引用其他的jar-->
                            <jar>
                              <path>lib/dependency1.jar</path>
                              <path>lib/dependency2.jar</path>
                            </jar>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
~~~

#### errorTitle标签

launch4j-maven-plugin 插件中的 errTitle 标签是用来设置生成的可执行文件在发生错误时弹出的窗口的标题。该标签的属性有以下一个：

- value：设置生成的可执行文件在发生错误时弹出的窗口的标题。

当生成的可执行文件发生一些意外的错误时，例如无法找到依赖的库、文件格式不正确等，生成程序会报错并弹出一个窗口显示错误信息，这时候该标签的值就会被用作弹出窗口的标题。因此，给 errTitle 标签设置适当的值可以让用户更容易地了解错误信息、快速定位问题所在。

#### classPath标签

launch4j-maven-plugin 插件中的 classPath 标签是用来设置生成的可执行文件的[类路径](https://so.csdn.net/so/search?q=类路径&spm=1001.2101.3001.7020)的。该标签的子标签有以下三个：

- mainClass：设置程序的主类，即可执行文件的入口。
- preCp：设置 classpath 的前缀路径。
- postCp：设置 classpath 的后缀路径。

classPath 标签中的 mainClass 标签是必须设置的，因为它指定了程序的主类，如果将该标签设置为一个空字符串或者不设置，则生成的可执行文件将无法正常运行。

在配置 classPath 标签时，此标签中的路径应该与生成的可执行文件的路径相对应，同时可以使用相对路径或绝对路径。根据不同操作系统的不同，路径的格式可能会有所不同，因此需要根据实际情况进行调整。

例如，在如下的配置中，我们指定了 mainClass 的类路径，并指定了一个名为 "lib" 的文件夹作为 preCp 的前缀路径：

~~~
<classPath>
  <mainClass>com.example.Main</mainClass>
  <preCp>lib</preCp>
</classPath>
~~~

通过这种方式，生成的可执行文件就可以在预设的前缀路径下搜索并加载其依赖的库文件。如果有多个依赖库的话，可以在 preCp 和 postCp 标签中用逗号分隔开来。

#### versionInfo标签

launch4j-maven-plugin 插件中的 versionInfo 标签是用来设置生成的可执行文件的版本信息的。该标签的属性有以下几个：

- fileVersion：文件版本号。
- txtFileVersion：文本文件版本号。
- fileDescription：文件描述。
- productVersion：产品版本号。
- txtProductVersion：文本产品版本号。
- productName：产品名称。
- companyName：公司名称。
- internalName：内部名称。
- originalFilename：原始文件名。

这些版本信息可以让用户在查看文件的属性时了解到程序的版本、发布公司等信息，是程序发布时很重要的元素之一。

例如，在如下的配置中，我们设置了文件版本号为 "1.0.0.0"，产品版本号为 "2.0"，产品名称为 "myapp"，公司名称为 "example inc."，内部名称为 "myapp"：

~~~
<configuration>
    <versionInfo>
      <fileVersion>1.0.0.0</fileVersion>
      <productVersion>2.0</productVersion>
      <productName>myapp</productName>
      <companyName>example inc.</companyName>
      <internalName>myapp</internalName>
    </versionInfo>
</configutation>
~~~

#### icon标签

launch4j-maven-plugin 插件中的 icon 标签是用来设置生成的可执行文件的图标的。该标签的属性有以下一个：

- value：设置生成的可执行文件的图标的路径。

要设置一个图标，我们需要指定 value 属性为包含图标的文件的路径，这个文件可以是 ICO 格式、BMP 格式或者 PNG 格式的图像文件。在路径前面加上 "file:" 的前缀可以指定一个网络上的资源，或者是指定绝对路径。如果没有 value 属性，则默认使用操作系统的默认图标。

例如，在如下的配置中，我们指定了一个位于 "/path/to/myicon.ico" 的图标文件：

~~~
<icon>file:/path/to/myicon.ico</icon>
~~~

通过这种方式，生成的可执行文件就会自动加入我们指定的图标。

#### jre标签

launch4j-maven-plugin 插件中的 jre 标签是用来设置生成的可执行文件所需的 JRE 的版本和路径的。该标签的属性有以下几个：

- minVersion：设置生成的可执行文件所需的 JRE 的最低版本。如果系统上的 JRE 版本低于此版本，则无法运行程序。此属性是必需的。
- maxVersion：设置生成的可执行文件所需的 JRE 的最高版本。如果系统上的 JRE 版本高于此版本，则无法运行程序。
- jdkPreference：设置生成的可执行文件使用的 JDK 优先级。
- initialHeapSize：用来设置生成的可执行文件的初始堆内存大小的。
- path：用来指定 JRE 的路径，如果不设置 path，则插件将默认使用当前系统所安装的 JRE 路径（默认情况下，插件使用的是
- JAVA_HOME 环境变量所指定的 JRE）。

例如，在如下的配置中，我们指定了生成的可执行文件需要 JRE 1.8 及以上版本，并且将 JRE 的路径设置为相对路径 “../java/jre”：

~~~
<!--配置jre-->
<jre>
    <bundledJre64Bit>false</bundledJre64Bit>
    <bundledJreAsFallback>false</bundledJreAsFallback>
    <jdkPreference>preferJdk</jdkPreference>
    <initialHeapSize>128</initialHeapSize>
    <maxHeapSize>1024</maxHeapSize>
 
    <!--jre路径，将生成的exe文件放到和jre同级目录，并把jre文件夹命名为jre-->
    <path>../java/jre</path>
</jre>
~~~

通过这种方式，生成的可执行文件就会自动依赖我们指定的 JRE 版本和路径。

#### manifest标签

launch4j-maven-plugin 插件中的 manifest 标签是用来设置生成的可执行文件的 Manifest 文件中的信息的。Manifest 文件中包含了程序的元信息，和启动程序的相关参数。该标签的属性有以下一个：

- file：用来指定 Manifest 文件的路径。

在配置 Manifest 文件时，我们需要将文件的路径设置在 file 属性当中。如果未设置 file 属性，则插件将不会使用任何 Manifest 文件，程序将使用默认的 Manifest 信息。Manifest 文件的格式通常为文本格式，在文件中定义如下的所有参数：

- Main-Class：指定主类文件名，含有 main 方法的类。
- Class-Path：指定程序所需的全部类库的路径，多个类库路径使用空格分隔。
- Boot-Class-Path：指定程序启动时需要加载的额外的 class 文件路径。
- JavaFX-Version：指定可以使用的 JavaFX 版本。
- Mainfest-Version：指定 Manifest 文件的版本。
- Permissions：指定需要特别处理的安全权限。
- Codebase：指定程序所在域。
- Application-Name：指定应用程序的名称。
- Implementation-Vendor：指定程序实现供应商的名称

例如，在如下的配置中，我们将使用位于 "/path/to/manifest.mf" 的 Manifest 文件：

~~~
<manifest>/path/to/manifest.mf</manifest>
~~~

通过这种方式，生成的可执行文件就会自动使用我们指定的 Manifest 文件中的选项信息。

#### 设置exe文件管理员权限启动

紧接上述 9 的标签使用，引用manifest文件内容：

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
    <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
        <security>
            <requestedPrivileges>
                <requestedExecutionLevel level="requireAdministrator" uiAccess="false"/>
            </requestedPrivileges>
        </security>
    </trustInfo>
</assembly>
~~~
