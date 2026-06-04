---
title: "Elasticsearch"
date: 2026-06-04
tags: ["tools"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

## 安装

## 使用

### 基本概念

- **索引**
  在Elasticsearch中，数据被组织成索引。一个索引是一组相关的文档的集合，
  类似于mysql的数据库。
- **文档**
  文档是索引中的基本数据单元，以JSON格式表示。每个文档都有一个唯一的ID，用于标识和检索。
  相当于mysql表中的每一条数据。
- **类型**
  一个索引支持多个类型，如一个数据库可以有多张表。
  相当于mysql的表，同一个表中数据的字段完全相同，所以同一个类型的数据的字段也完全相同
  Elasticsearch 7.x及后不再支持多个类型
  就相当于将整个Elasticsearch作为一个数据库，每个
  索引就是一个数据库的表，字段的定义要在创建索引时进行，一个索引不能再存储不同类型的数据。在存储数据是统一使用_doc替换原来索引位置,如PUT /your_index/_doc/id
  8.x后不再支持在请求中指定类型,不知道是不是直接_doc都不需要了，如PUT /your_index/id,没用过，不知道了

### 使用

- **创建索引**

```json
PUT /your_index
{
  "settings": {
    "number_of_shards": 5,
    "number_of_replicas": 1,
    "analysis": {
      "analyzer": {
        "standard_analyzer": {
          "tokenizer": "standard",
          "filter": ["lowercase"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "field1": { "type": "text" },
      "field2": { "type": "keyword" },
      "field3": { "type": "date" }
    }
  }
}
```

settings用于定义索引的配置参数，这些参数包括分片数量（number_of_shards）、副本数量（number_of_replicas）、分析器（Analyzer）等.
按是否可以更改分为静态(static)属性与动态配置，静态配置即索引创建后不能修改，静态配置只能在创建索引时或者在状态为 closed index的索引（闭合的索引）上设置
**分片数量**
索引的主分片数量，控制索引数据的水平划分。主分片数在索引创建后不能更改。有10亿条日志数据，可以选择将索引分为10个主分片，以便每个分片处理1亿条数据。
**副本数量**
集群中使用，定义每一个主分片有几个副本，这些副本分布在集群的不同节点
创建了一个索引，主分片数量为5，副本数量为1，这将创建5个主分片和它们各自的1个副本。这些分片和副本将在整个集群的多个节点上分布，以确保即使某个节点发生故障，数据仍然可用。
副本数量设置为2，那么将有2个副本与每个主分片对应，总共是5个主分片和每个主分片2个副本共10个副本。这样，每个主分片都有一个主副本和一个从副本，它们分布在不同的节点上。
**分析器**
定义合适的数据和查询需求的分析器，包括分词器和过滤器。默认的分析器通常是 standard,可以自定义，如只有中文分词器lk

```json
 "settings": {
    "analysis": {
      "analyzer": {
        "ik_max_word": {
          "tokenizer": "ik_max_word"
        },
        "ik_smart": {
          "tokenizer": "ik_smart"
        }
      }
    }
  }
```

properties 是 Mappings 的主要层次，用于定义索引中的字段及其属性。每个字段都在 properties 下面，字段的名字是键，其属性是键对应的值。

```json
{
  "mappings": {
    "properties": {
      "field1": {
        "type": "text",
        "analyzer": "ik_smart"
      },
      "field2": {
        "type": "keyword"
      }
    }
  }
}
```

在这个示例中，有两个字段 field1 和 field2。field1 是一个 text 类型的字段，指定了使用 ik_smart 分析器。field2 是一个 keyword 类型的字段。
在 mappings 中为字段定义了自定义的 analyzer，Elasticsearch 将使用该字段级别的设置，而不是使用全局setting的 analyzer
**实例**

````json
PUT /txt
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ik_smart": {
          "tokenizer": "ik_smart"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text": {
        "type": "text"
      },
      "user_name": {
        "type": "keyword"
      },
      "user_id": {
        "type": "integer"
      },
      "title": {
        "type": "keyword"
      }
    }
  }
}
````

### 字段数据类型

#### 字符串类型

text、keyword
text：支持分词，全文检索,支持模糊、精确查询,不支持聚合,排序操作;text类型的最大支持的字符长度无限制,适合大字段存储；
keyword：不进行分词，直接索引、支持模糊、支持精确匹配，支持聚合、排序操作。keyword类型的最大支持的长度为——32766个UTF-8类型的字符,可以通过设置ignore_above指定自持字符长度，超过给定长度后的数据将不被索引，无法通过term精确匹配检索返回结果。

#### 数值型

long、Integer、short、byte、double、float、half float、scaled float

#### 日期类型

date

#### te布尔类型

boolean

#### 二进制类型

binary

### 索引操作

```xml
#创建索引
put /es_db

#查询索引
get es_db

#删除索引
delete es_db

#查询索引是否存在
HEAD es_db

#关闭索引
post /es_db/_close

#打开索引
post /es_db/_open

```

### 文档操作

#### 创建文档

put、post、_create都可以创建文档，put要指定id,post也可以跟put一样创建文档，区别是post如果不指定id的话es会自动生成，_create如果id有存在会添加失败

```java
#put添加文档
PUT /es_db/_doc/1
{
  "name":"张三",
  "sex":1,
  "age":25,
  "address":"广州天河公园",
  "remake":"java developer"
}


#post添加文档
POST /es_db/_doc
{
  "name":"张三2",
  "sex":1,
  "age":25,
  "address":"广州天河公园",
  "remake":"java developer"
}

POST /es_db/_doc/1
{
  "name":"张三2",
  "sex":1,
  "address":"广州天河公园",
  "remake":"java developer"
}

#_create添加文档

PUT /es_db/_create/1
{
  "name":"张三2",
  "sex":1,
  "address":"广州天河公园",
  "remake":"java developer"
}

```

#### 查看文档

```java
#根据ID查询指定文档
GET /es_db/_doc/1
#查询索引的全部文档
GET /es_db/_search

```

### 修改文档

post和put覆盖更新都是会删除原来的文档再插入，会导致文档的属性丢失，_update是局部更新，只会更新选择的属性不会丢失，所以更新一般用_update

```java
#post覆盖更新（删除原来的文档再插入）
POST /es_db/_doc/1
{
  "name":"张三2",
  "sex":1,
  "address":"广州天河公园",
  "remake":"java developer"
}

#put覆盖更新（删除原来的文档再插入）
PUT /es_db/_doc/1
{
  "name":"张三2",
  "sex":1,
  "address":"广州天河公园"
}

#局部更新文档（不会删除原来的属性，推荐用以下方法更新文档）
POST /es_db/_update/1
{
  "doc": {
    "age":27
  }
}

#查询后再更新
POST /es_db/_update_by_query
{
  "query":{
    "match":{
      "_id":1
    }
  },
  "script":{
    "source":"ctx._source.age=30"
  }
}


```

#### 删除文档

```java
#删除指定文档
DELETE /es_db/_doc/G17EmYgBvN_pzyBmoMoN
```

#### 复杂查询

##### 查询匹配（匹配、过滤、排序、分页）

**match**：匹配（会先将搜索词进行分词在去文档搜索）
 **_source**：过滤字段
**sort**：排序
**form、size** 分页

```java
## 查询匹配
  GET /blog/_doc/_search
  {
    "query":{
      "match":{
        "name":"流"
      }
    }
    ,
    "_source": ["name","desc"]
    ,
    "sort": [
      {
        "age": {
          "order": "asc"
        }
      }
    ]
    ,
    "from": 0
    ,
    "size": 1
  }
```

##### 多条件查询（must、should、filter）

**must** 相当于 and
**should** 相当于 or
**must_not** 相当于 not (… and …)
**filter** 过滤

```java
GET /blog/_doc/_search
{
  "query":{
    "bool": {
      "must": [
        {
          "match":{
            "age":3
          }
        },
        {
          "match": {
            "name": "流"
          }
        }
      ],
      "filter": {
        "range": {
          "age": {
            "gte": 1,
            "lte": 3
          }
        }
      }
    }
  }
}
```

##### match和term查询

match会对搜索词进行分词，将分词后的field去倒排索引寻找文档；
term不会对搜索词进行分词，用搜索词去倒排索引寻找文档；
match和term的区别在于是否拆解搜索词
数据类型text和keyword的区别也是是否对数据分词

```java
##term不分词,用java去搜索
GET /blog/_doc/_search
{
  "query":{
    "term":{
      "desc":"java"
    }
  }
}

##match分词，会将“java是”分成“java”和“是”再去搜索
GET /blog/_doc/_search
{
  "query":{
    "match":{
      "desc":"java是"
    }
  }
}
```

##### wildcard查询

用wildcard模拟mysql中的like “%java%”
通配符 * 来表示任意多个字符
? 来表示任意一个字符

```java
##wildcard 是一种查询方式，用于在文本字段中进行通配符匹配,用wildcard模拟mysql中的like "%java%"
GET /blog/_doc/_search
{
  "query": {
    "wildcard": {
      "tab": "*java*"
    }
  }
}
```

#### 高亮查询

```java
##高亮查询
GET blog/_doc/_search
{
  "query": {
    "match": {
      "name":"流"
    }
  }
  ,
  "highlight": {
    "fields": {
      "name": {}
    }
  }
}

##自定义前缀和后缀
GET blog/_doc/_search
{
  "query": {
    "match": {
      "name":"流"
    }
  }
  ,
  "highlight": {
    "pre_tags": "<p class='key' style='color:red'>",
    "post_tags": "</p>", 
    "fields": {
      "name": {}
    }
  }
}
```

分界线

---

分界线

### 直接springboot集成

#### 依赖

```xml
        <!--elasticsearch-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
        </dependency>
```

#### ElasticsearchRepository接口

ElasticsearchRepository接口定义了Elasticsearch的CRUD，继承了该接口的接口甚至无需定义任何其他的方法就能满足基本需求

```java
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface ArticleESRepository extends ElasticsearchRepository<Article,Integer> {
}
//<Article,Integer>,Article为该索引存储的文档类型，Integer为id的类型
```

## 遇到bug

### 当字段类型为keyword是，查询只能完全匹配查询，设置标题为"测试标题1"，只有"测试标题1"能查询到，"测试"、"标题"、"1"都不能查到数据
