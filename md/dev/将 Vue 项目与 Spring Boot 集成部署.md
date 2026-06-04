---
title: "将 Vue 项目与 Spring Boot 集成部署"
date: 2026-06-04
tags: ["dev"]
---

​#lastmod/2025-05-07 00:30:30#​ #date/2025-05-06 00:50:37#

### **将 Vue 项目与 Spring Boot 集成部署的总结笔记**

#### **1. Vue 项目构建与打包**

- 使用 Vue CLI 构建项目，运行 `npm run build`​ 命令，生成 `dist` 目录，包含所有静态资源（HTML、CSS、JS 文件等）。

#### **2. 将前端静态资源放入 Spring Boot 项目**

- 创建 `src/main/resources/static` 目录（如果没有的话）。
- 将 Vue 项目打包后的 `dist`​ 目录内容（`index.html`​、`js`​、`css`​ 等）复制到 `static` 目录下。

#### **3. 配置 Spring Boot 处理前端路由**

- **处理 Vue 路由**： 如果使用 Vue Router 的 History 模式，浏览器向服务器发送的请求是当前的`URL`​地址，如果 `URL`​不匹配任何静态资源或接口会得到一个 404 错误 **。** 需要配置 Spring Boot 控制器来处理前端路由跳转：

  1. 直接用 Controller 转发

     ```java
     @Controller
     public class VueRouterController {
         @GetMapping("/{path:^(?!api$|swagger-ui).*$}")
         public String redirectToVueApp() {
             return "forward:/index.html"; // 所有非 API 路径转发到 Vue 应用的首页
         }
     }

     ```
  2. 重写WebMvcConfigurer类的​addViewControllers方法

     ```java
     @Configuration
     public class WebConfig implements WebMvcConfigurer {

         @Override
         public void addViewControllers(ViewControllerRegistry registry) {
             // 匹配所有未匹配的路由，转发到 index.html
             registry.addViewController("/{spring:\\w+}")
                     .setViewName("forward:/index.html");
             
             registry.addViewController("/**/{spring:\\w+}")
                     .setViewName("forward:/index.html");
             
             registry.addViewController("/{spring:\\w+}/**{spring:?!(\\.js|\\.css|\\.png|\\.jpg)$}")
                     .setViewName("forward:/index.html");
         }
     }
     ```
  3. Spring Boot 2.6+ 及 Spring Framework 5.3+默认启用了 PathPatternParser（新路径匹配器），`PathPatternParser` 的规则更加严格，编写的路径正则可能会报错

     1. 切换回 AntPathMatcher（旧解析器）

        在 `application.properties` 中加入：

        ```properties
        spring.mvc.pathmatch.matching-strategy=ant_path_matcher
        ```

        ✅ 这样就会恢复 **旧版路径匹配行为**，允许 `/**/{spring:\w+}` 这种模式。

        ⚠️ **缺点**：将整个项目切换回旧解析器，可能影响未来升级兼容性。
     2. 按照新的`PathPatternParser`规则重写正则

#### **4. Spring Boot 项目端口配置**

- Spring Boot 默认通过 `server.port=8080` 来开启一个端口。
- **前后端共享同一个端口**，例如：`http://localhost:8080/`​ 访问前端，`http://localhost:8080/api/**` 访问后端 API。
- **Spring Boot 提供前端静态资源**，即从 `src/main/resources/static`​ 提供文件（如 `index.html`）。

#### **5. 部署与启动**

- 使用 Maven 或 Gradle 打包 Spring Boot 项目：

  - Maven：`mvn clean package`
  - Gradle：`gradle build`
- 生成 `.jar` 文件，运行：

  ```bash
  java -jar target/your-springboot-app.jar
  ```
- 通过浏览器访问后端与前端，确认部署成功。

## 为前端页面配置前缀

### 📝  **（一）Vue 前端设置 base 路径**

必须在 `vue-router`​ 和 `vite.config.js`​（或 `vue.config.js`​）中配置 **base 路径**：

#### 1️⃣ Vue Router 中设置：

```js
const router = createRouter({
  history: createWebHistory('/vue/'),
  routes: [ /* your routes */ ]
});
```

✅ 这里的 `/vue/`​ 表示路由会以 `/vue` 作为“根”。

---

#### 2️⃣ vite.config.js（如果是 Vite 项目）：

```js
export default defineConfig({
  base: '/vue/'
});
```

或 **vue.config.js（如果是 Vue CLI 项目）：**

```js
module.exports = {
  publicPath: '/vue/'
};
```

✅ 这样构建时所有静态资源、路由路径都会自动带 `/vue/`。

---

### 📝  **（二）Spring Boot 后端配置**

因为浏览器会请求 `/vue/...` 的 URL，  
Spring Boot 需要：

✅ **将所有**  **​`/vue/**`​** ​ **的路径转发到**  **​`/vue/index.html`​**

即：

- ​`/vue/`​ → `/vue/index.html`
- ​`/vue/admin`​ → `/vue/index.html`
- ​`/vue/user/settings`​ → `/vue/index.html`

---

## ✅ **3️⃣ 后端转发代码**

推荐方案 → 使用 `@Controller`​ 转发 `/vue/**`：

```java
@Controller
public class VueRouteController {

    @RequestMapping(value = {"/vue/{path:[^\\.]+}", "/vue/**/{path:[^\\.]+}"})
    public String forward() {
        return "forward:/vue/index.html";
    }
}
```

✅ **解释：**

- ​`/vue/{path:[^\\.]+}`​ → 匹配 `/vue/xxx`​ 但排除 `.js`​ `.css`​ `.png` 等文件
- ​`/vue/**/{path:[^\\.]+}`​ → 匹配 `/vue/xxx/yyy/zzz` 嵌套路由
- 其他 `/vue/*.js`​ `/vue/*.css` 静态资源 → 不会被转发，直接由 Spring Boot 静态资源处理

---

## ✅ **4️⃣ 静态资源放置目录**

👉 Vue 构建后的 `dist` 目录需要放到：

```
src/main/resources/static/vue/
```

结构示例：

```
src/main/resources/static/vue/index.html
src/main/resources/static/vue/js/app.js
src/main/resources/static/vue/css/style.css
...
```

---

## ✅ **5️⃣ API 路**

### **关键点**

- **Vue 项目和 Spring Boot 后端共享同一个端口**。
- 前端资源通过 Spring Boot 提供（`static` 目录）并配置路由处理。
- 对于 Vue 的 History 模式，需要 Spring Boot 配置重定向，确保前端路由能正确加载。

---

**Q1:**  如何使用 Spring Boot 配置自定义的静态资源路径，并确保多环境部署时的路径一致性？

**Q2:**  Vue 应用在构建时，如何优化静态资源的加载速度和性能，特别是在集成到 Spring Boot 后端时？

**Q3:**  如何解决 Vue 项目中跨域请求的问题，确保前端与 Spring Boot 后端在同一个端口时能够正常交互？
