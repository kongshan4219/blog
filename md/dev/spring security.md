---
title: "spring security"
date: 2026-06-04
tags: ["dev"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

### 使用

依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

##### 自己重新梳理下spring security的流程吧

- security有一个过滤链

  - 我自己项目的过滤器
    ![我自己的项目的过滤器](https://md.kongseek.com/1699758778598.png)
    三更的
  - ![三更项目的过滤器](https://md.kongseek.com/1699758886881.png)
    ~~自己的过滤器少几个（还是在加了自定义过滤器的情况下），初步判断是版本不同（未验证)。已经破案了~~

    我缺少的过滤器

    ![我缺少的过滤器](https://md.kongseek.com/1699773668947.png)

    其中：

    ```
    UsernamePasswordAuthenticationFilter:负责表单认证的；
    DefaultLoginPageGeneratingFilter:提供登录界面的；
    DefaultLogoutPageGeneratingFilter:提供注销界面的；
    ```

    是security默认的用户登录认证走的，我自己定义了JwtAuthenticationTokenFilter进行登录验证，并且加在了UsernamePasswordAuthenticationFilter前面所有pass了这三个，如果要走，需要在自定义的登录验证过滤器调用调用 HttpSecurity 中的 formLogin() 方法。[具体看这个文章](https://blog.csdn.net/qq_63691275/article/details/131029579?ops_request_misc=%7B%22request%5Fid%22%3A%22169977337616800182783736%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=169977337616800182783736&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~times_rank-1-131029579-null-null.142^v96^pc_search_result_base8&utm_term=查看springsecurity的过滤器&spm=1018.2226.3001.4187)

    对于BasicAuthenticationFilter，有可能是下面原因

    ```
    1.自定义配置：你可能在自定义 Spring Security 配置时，显式地排除了 BasicAuthenticationFilter 或者使用了其他方式来处理基本身份验证。例如，在配置类中通过 .addFilterBefore() 或 .addFilterAfter() 方法指定了自定义的过滤器，从而覆盖了默认的过滤器顺序。

    2.使用了其他认证方式：在某些情况下，你可能选择了其他的身份验证方式，如表单登录（Form-based Authentication）或者基于 Token 的认证（Token-based Authentication），而不是基本身份验证。这些方式可能会导致 BasicAuthenticationFilter 不出现在你的过滤链中。
    ```
- 具体流程

  ![三更的认证流程详解](https://md.kongseek.com/1699776369200.png)
- [这篇文章](https://blog.csdn.net/qq_63691275/article/details/131029579?ops_request_misc=%7B%22request%5Fid%22%3A%22169977337616800182783736%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=169977337616800182783736&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~times_rank-1-131029579-null-null.142^v96^pc_search_result_base8&utm_term=查看springsecurity的过滤器&spm=1018.2226.3001.4187)
  的自定义登录认证过滤器是去继承UsernamePasswordAuthenticationFilter，三更是继承OncePerRequestFilter，虽然不同，但是追踪下去后都是继承GenericFilterBean，所有应该没什么区别。
  不对，还是有区别的，三更的是直接pass了security默认的用户登录认证的那几个过滤器，那篇文章则是依然会走，只是修改了UsernamePasswordAuthenticationFilter中的认证方法。
- 流程实现

  - 实现UserDetails接口LoginUser（类名随意）记录登录用户的信息
  - 实现UserDetailsService接口并重写loadUserByUsername方法，在数据库中查找用户信息并封装成上一点的LoginUser返回

到这里基本就完成了登录接口是编写。

##### 跨域

在使用
//允许跨域
http.cors();
后，还需要

```
// 添加跨域配置
@Bean
public CorsConfigurationSource corsConfigurationSource() {
UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
CorsConfiguration config = new CorsConfiguration();
config.addAllowedOrigin("*");  // 允许所有域名
config.addAllowedHeader("*");  // 允许所有头部信息
config.addAllowedMethod("*");  // 允许所有请求方法
source.registerCorsConfiguration("/**", config);
return source;
}
```

##### UserDetailsService.loadUserByUsername()抛出的自定义异常不能被自定义异常处理器正常捕获

因为会先被springsecurity捕获并被包装成其自定义的InternalAuthenticationServiceException异常并抛出，然后被Exception处理器捕获
解决方法，在自己异常处理中添加InternalAuthenticationServiceException异常处理器，在进行处理

```java
    @ExceptionHandler(InternalAuthenticationServiceException.class)
    public Result internalAuthenticationServiceExceptionHandler(InternalAuthenticationServiceException e) {
        if (e.getCause() instanceof ResultException) {
            ResultException resultException = (ResultException) e.getCause();
            System.out.println("error：" + resultException.getMsg());
            return Result.error(resultException.getCode(), resultException.getMsg());
        }
        //其他异常就直接用exceptionHandler返回了
        return exceptionHandler(e);
    }
```
