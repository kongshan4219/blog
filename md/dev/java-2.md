---
title: "java"
date: 2026-06-04
tags: ["dev"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

#### 泛型

1. 泛型是在new一个类时，可以指定类的某一个属性的具体类型，此时该属性只能是指定的具体类型或者其子类。

   ```java
   public class MyClass<T>{
       //泛型属性
       private T data;
       //指定泛型的构造方法
       public Result<?> ok (T data) {
           this.code = AppHttpCodeEnum.SUCCESS.getCode();
           this.msg = AppHttpCodeEnum.SUCCESS.getMsg();
           this.data = data;
           return this;
       }
   }
   ```
   泛型使用：

   ```java
   MyClass<String> myclass = new MyClass<>();
   //此时maClass的data属性的类型只能是String或其子类
   ```
   tips:

   以后忘记的话就想想HashMap或ArrayList这些，直接 打“ new HashMapt<String,Long>().var ”或“ new ArrayList<String>().var ”。 应该就可以再理解了
2. 静态方法能不能用泛型？(可能可以，我还没搞懂，不太清楚，暂时先算不能用吧)

   (copy过来的)

   在java中泛型只是一个占位符，必须在传递类型后才能使用。就泛型类而言，类实例化时才能传递真正的类型参数，由于静态方法的加载先于类的实例化，也就是说类中的泛型还没有传递真正的类型参数时，静态方法就已经加载完成。显然，静态方法不能使用/访问泛型类中的泛型。这和静态方法不能调用普通方法/访问普通变量类似，都是因为静态申明与非静态申明的生命周期不同。

   (破案了，静态方法可以用泛型)

   直接上个最简单的例子吧

   ```java
   public class MyClass<T>{
       //泛型属性
       private T data;
       //静态方法
       public static <T> MyClass<T> success(T data) {
           //静态方法直接创建含泛型的对象，并返回这个对象
           MyClass<T> myClass = new MyClass<>();
           myClass.data = data;
           return myClass;
       }
   }
   ```
   使用：

   ```java
    String data = "test";
    MyClass<String> success = MyClass.success(data);
   ```
