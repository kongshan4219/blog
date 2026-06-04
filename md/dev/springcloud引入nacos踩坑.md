---
title: "springcloud引入nacos踩坑"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-09-24# #lastmod/2024-09-24#

---

### 在配置网关路由时，url 设置为服务名称时无法调用

### 1、将 url 设置为 ip 时可以正常访问，所以猜测时 nacos 的服务发现问题

~~~java
    private final DiscoveryClient discoveryClient;

    public ServiceDiscoveryController(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
    }

    @GetMapping("/services")
    public ResponseEntity<List<String>> getServices() {
        List<String> services = discoveryClient.getServices().stream().collect(Collectors.toList());
        return ResponseEntity.ok(services);
    }
~~~

通过代码测试服务能正常被网关发现

#### 2、后续查看开源项目的网关配置，发现当前依赖少了

~~~xml
       <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-loadbalancer</artifactId>
        </dependency>
~~~

添加依赖，服务可以正调用

#### 3、spring-cloud-loadbalancer 是什么

`Spring Cloud LoadBalancer` 是 Spring Cloud 提供的一个客户端负载均衡器（Client-Side Load Balancer）。它用于在微服务架构中，帮助客户端在多个服务实例之间进行负载均衡，从而提高系统的可用性和性能。

### 主要功能

1. **服务发现与负载均衡**：
   - `Spring Cloud LoadBalancer` 可以与服务发现组件（如 Eureka、Consul、Nacos 等）集成，自动发现可用的服务实例。
   - 它可以根据配置的负载均衡策略（如轮询、随机等），在多个服务实例之间分发请求。
2. **客户端负载均衡**：
   - 与传统的服务器端负载均衡（如 Nginx、HAProxy）不同，`Spring Cloud LoadBalancer` 是在客户端进行负载均衡。每个客户端服务都会维护一个服务实例列表，并根据负载均衡策略选择一个实例进行请求。
3. **集成方便**：
   - `Spring Cloud LoadBalancer` 可以很容易地集成到 Spring Cloud 应用中，通过简单的配置即可启用。
