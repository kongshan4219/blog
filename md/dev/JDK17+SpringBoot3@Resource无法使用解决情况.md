---
title: "JDK17+SpringBoot3@Resource无法使用解决情况"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-09-19# #lastmod/2024-09-19#

---

之前我在使用Spring mvc时，发现@Resource 无法使用，但是只要引入：

<div>
<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
    <version>1.3.2</version>
</dependency>
</div>

就可以使用

但是在Spring Boot3 中就不行！！！

首先，为什么javax.annotation.Resource注解不存在呢？
从Jdk9开始，JavaEE从Jdk中分离，jdk就移除掉了javax.annotation.jar包的默认集成，从而导致版本不兼容。所以一旦spring项目从JDK8升到高版本，都会出现javax.annotation.Resource无法引用报红。

```
java EE 即 java Enterprise Edition，企业级应用，目标是制定一系列企业级应用的标准服务。常见的 javax.servlet, javax.annotation。

Oracle 收购了创造 java 的 SUN 公司，Oracle 又不想发展 java EE 了，就把 java EE 交给 Eclipse 社区了，但是又因为不知名的原因，禁止社区使用 javax 这个名字。所以，javax.servlet 就变成了 jakarta.servlet, jakarta.annotation。api无法向前兼容。

 java ee 的最后一个版本也是 8，以后就再也没有 java ee 的新版本
```

Springboot3/Spring6.0以上版本的问题
从Java EE APIs 到 Jakarta EE

```
Spring Boot 3开始，所有的Java EE Api都需要迁移到Jakarta EE上来。

大部分用户需要修改import相关API的时候，要用jakarta替换javax。比如：原来引入javax.servlet.Filter的地方，需要替换为jakarta.servlet.Filter
```

但是当Spring版本升级到6.0以上的版本，即使手动引入javax.annotation包，但是还是会有问题，你会发现类无法注入，导致引用的类is Null,报空指针。

因为Spring也放弃了javax.annotation.Resource注解的支持，而是对jakarta.annotation.Resource注解的支持

private InjectionMetadata buildResourceMetadata(Class<?> clazz) {
if (!AnnotationUtils.isCandidateClass(clazz, resourceAnnotationTypes)) {
return InjectionMetadata.EMPTY;
} else {
List<InjectedElement> elements = new ArrayList();
Class targetClass = clazz;

```
        do {
            List<InjectedElement> currElements = new ArrayList();
            ReflectionUtils.doWithLocalFields(targetClass, (field) -> {
                if (ejbClass != null && field.isAnnotationPresent(ejbClass)) {
                    if (Modifier.isStatic(field.getModifiers())) {
                        throw new IllegalStateException("@EJB annotation is not supported on static fields");
                    }
 
                    currElements.add(new CommonAnnotationBeanPostProcessor.EjbRefElement(field, field, (PropertyDescriptor)null));
                } else if (field.isAnnotationPresent(Resource.class)) {
                    if (Modifier.isStatic(field.getModifiers())) {
                        throw new IllegalStateException("@Resource annotation is not supported on static fields");
                    }
 
                    if (!this.ignoredResourceTypes.contains(field.getType().getName())) {
                        currElements.add(new CommonAnnotationBeanPostProcessor.ResourceElement(field, field, (PropertyDescriptor)null));
                    }
                }
 
            });
            ReflectionUtils.doWithLocalMethods(targetClass, (method) -> {
                Method bridgedMethod = BridgeMethodResolver.findBridgedMethod(method);
                if (BridgeMethodResolver.isVisibilityBridgeMethodPair(method, bridgedMethod)) {
                    if (method.equals(ClassUtils.getMostSpecificMethod(method, clazz))) {
                        if (ejbClass != null && bridgedMethod.isAnnotationPresent(ejbClass)) {
                            if (Modifier.isStatic(method.getModifiers())) {
                                throw new IllegalStateException("@EJB annotation is not supported on static methods");
                            }
 
                            if (method.getParameterCount() != 1) {
                                throw new IllegalStateException("@EJB annotation requires a single-arg method: " + method);
                            }
 
                            PropertyDescriptor pdx = BeanUtils.findPropertyForMethod(bridgedMethod, clazz);
                            currElements.add(new CommonAnnotationBeanPostProcessor.EjbRefElement(method, bridgedMethod, pdx));
                        } else if (bridgedMethod.isAnnotationPresent(Resource.class)) {
                            if (Modifier.isStatic(method.getModifiers())) {
                                throw new IllegalStateException("@Resource annotation is not supported on static methods");
                            }
 
                            Class<?>[] paramTypes = method.getParameterTypes();
                            if (paramTypes.length != 1) {
                                throw new IllegalStateException("@Resource annotation requires a single-arg method: " + method);
                            }
 
                            if (!this.ignoredResourceTypes.contains(paramTypes[0].getName())) {
                                PropertyDescriptor pd = BeanUtils.findPropertyForMethod(bridgedMethod, clazz);
                                currElements.add(new CommonAnnotationBeanPostProcessor.ResourceElement(method, bridgedMethod, pd));
                            }
                        }
                    }
 
                }
            });
            elements.addAll(0, currElements);
            targetClass = targetClass.getSuperclass();
        } while(targetClass != null && targetClass != Object.class);
 
        return InjectionMetadata.forElements(elements, clazz);
    }
}
```

通过跟代码进去，发现@Resouce的源代码是 jakarta.annotation下的

package jakarta.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Repeatable;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.TYPE, ElementType.FIELD, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Repeatable(Resources.class)
public @interface Resource {
String name() default "";

```
String lookup() default "";
 
Class<?> type() default Object.class;
 
Resource.AuthenticationType authenticationType() default Resource.AuthenticationType.CONTAINER;
 
boolean shareable() default true;
 
String mappedName() default "";
 
String description() default "";
 
public static enum AuthenticationType {
    CONTAINER,
    APPLICATION;
 
    private AuthenticationType() {
    }
}
```

}
