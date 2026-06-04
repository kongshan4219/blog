---
title: "spring-cloud-gateway"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-09-25# #lastmod/2024-09-25#

---

## spring-cloud-gateway

spring-cloud-gateway 共有 3 种过滤器：

1. 全局过滤器 (GlobalFilter)
2. 路由过滤器 (GatewayFilter)
3. 自定义过滤器工厂 (AbstractGatewayFilterFactory)

### 现在选择自定义过滤器工厂 (AbstractGatewayFilterFactory)

继承抽象类 `AbstractGatewayFilterFactory`, 实现 `apply` 方法

可以传入一个自定义的配置类

~~~java
@Component
public class SignatureVerificationGatewayFilterFactory extends AbstractGatewayFilterFactory<SignatureVerificationGatewayFilterFactory.Config> {

    public SignatureVerificationGatewayFilterFactory() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            // 验证签名
            if (!validateSignature(request)) {
                return Mono.error(new RuntimeException("Invalid signature"));
            }
            return chain.filter(exchange);
        };
    }

    private boolean validateSignature(ServerHttpRequest request) {
        // 实现签名验证逻辑
        return true; // 假设验证成功
    }

    public static class Config {}
}
~~~
