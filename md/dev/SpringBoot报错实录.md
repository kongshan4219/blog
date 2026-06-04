---
title: "SpringBoot报错实录"
date: 2026-06-04
tags: ["dev"]
---

#date/2022-09-11# #lastmod/2025-03-13 22:39:28#

---

## SpringBoot报错实录

#### 1、springboot启动后无报错自动结束

![1699492469130](https://md.kongseek.com/1699492469130.png)
原因：没有选择好依赖包，相当于没有内置的Tomcat，我们运行的Main函数其实就是一个普通的Main函数，所以运行完毕了之后就关闭了

pom.xml中SpringBootStarter依赖如下

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <version>2.3.12.RELEASE</version>
</dependency>
```

需要修改成

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.3.12.RELEASE</version>
</dependency>
```

#### 2、maven打包后运行没有主程序清单

原因是打包后的jar包的MANIFEST.MF文件中缺少Main-Class，需要添加依赖repackage成有Main-Class的可执行的jar包。

原pom.xml

```xml
    <build>
<!--        <finalName>${project.artifactId}</finalName>-->
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.3.12.RELEASE</version>
            </plugin>
        </plugins>
    </build>
```

修改后pom.xml

```xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.3.12.RELEASE</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

**puling：**

- 1：遇到**3、4**的问题后，将

```xml
<executions>
    <execution>
        <goals>
            <goal>repackage</goal>
        </goals>
    </execution>
</executions>
```

移除，发现仍然可以正常打包，所以最开始'maven打包后运行没有主程序清单'的原因应该不是这个，是什么我也不知道了。有机会在找找看一下吧。

#### 3、maven打包子项目 报错 缺少父项目资源（jar/pom）

maven打包子项目报错程序包org.mybatis.spring.annotation（例子）不存在，该包依赖在父项目中引入，子项目是直接在<dependencies/>中引入父项目

这个我不知到怎么解决的，突然就直接跳到 **4** 的错误了

#### 4、maven打包公共资源模块找不到主类

解决：不能直接在最外层父项目的pom中添加spring-boot-maven-plugin插件，也不能在没有主类的公共模块添加，这个SpringBoot插件会在Maven的package后进行二次打包，目的为了生成可执行jar包，如果C中定义了这个插件，会报错提示没有找到main函数，这个插件应该在有主类的子模块的pom中添加。

然后我在搜索这个问题是看到还需要在root项目，也就是总目录下的pom文件对应的install操作，但我实测直接执行需要打包的子项目对应的install就可以完成打包，甚至不需要先去执行子模块依赖的公共模块的install

#### 5、读取 jar时出错； error in opening zip file

本地maven仓库文件损坏，下载时网络故障导致的。

删除本地仓库对应的jar包，重新下载

#### 6、使用springsecurity时一直在filterChain过滤链循环，导致栈溢出

这次是因为UserDetailsService的实现类没有加@Service注解

#### 7、springsecurity中的异常不能被全局异常处理器捕获

- 相关连接

  [spring框架集成：全局异常处理类无法捕获springsecurity抛出异常的问题](https://blog.csdn.net/toytoytelecar/article/details/126675646)

  [spring全局异常处理针对spring security 异常处理失效问题](https://blog.csdn.net/zhangyongbink/article/details/112678052)

  [捕获SpringSecurity异常，进行统一返回](https://blog.csdn.net/qq_39354140/article/details/129157567?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-129157567-blog-126675646.235^v38^pc_relevant_default_base3&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~CTRLIST~Rate-1-129157567-blog-126675646.235^v38^pc_relevant_default_base3&utm_relevant_index=2)
- 解决方法
  在原本抛出异常的地方直接返回HttpServletResponse
  ![](https://md.kongseek.com/1699935838949.png)    ![](https://md.kongseek.com/1699935858692.png)

  ```java
  public class WebUtils {
      public static void renderString(HttpServletResponse response, String string) {
          try
          {
              response.setStatus(200);
              response.setContentType("application/json");
              response.setCharacterEncoding("utf-8");
              response.getWriter().print(string);
          }
          catch (IOException e)
          {
              e.printStackTrace();
          }
      }

      public static void renderString(HttpServletResponse response, Result result) {
          try
          {
              String json = JSON.toJSONString(result);
              response.setStatus(result.getCode());
              response.setContentType("application/json");
              response.setCharacterEncoding("utf-8");
              response.getWriter().print(json);
          }
          catch (IOException e)
          {
              e.printStackTrace();
          }
      }

      public static void setDownLoadHeader(String filename, ServletContext context, HttpServletResponse response) throws UnsupportedEncodingException {
          String mimeType = context.getMimeType(filename);//获取文件的mime类型
          response.setHeader("content-type",mimeType);
          String fname= URLEncoder.encode(filename,"UTF-8");
          response.setHeader("Content-disposition","attachment; filename="+fname);

          //        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
          //        response.setCharacterEncoding("utf-8");
      }
  }
  ```

#### 8、文件上传接口默认大小限制为1M

```java
@PostMapping("/upload")
public void upload(@RequestParam MultipartFile file){}
```

自定义大小限制

```yaml
spring:
  servlet:
    multipart:
      max-file-size: 100MB # 设置单个文件的大小为10M
      max-request-size: 500MB # 设置总上传的数据大小为50M
```

#### 9、put和post接口使用@RequestParam接收参数

在vue使用axios封装api时，通过params和data来选择传参方式，params只能使用@RequestParam接收参数，data只能使用@RequestBody接收参数
原因：params会将Object类型的参数转换为key=value&key=value的形式添加到请求地址中，而@RequestBody会直接将Object类型的参数转换为json格式加入请求体
![api](https://md.kongseek.com/1712723641557.png)
