---
title: "mysql"
date: 2026-06-04
tags: ["tools"]
---

#date/2022-09-11# #lastmod/2022-09-11#

---

## 索引

对于设置了索引的字段，会计算出一个值，在索引页中按照这个值排序，查找时使用二分查找快速定位
联合索引会按照联合顺序进行排序，如果查询时没有指定联合索引中的第一个字段，则无法使用索引

### 配置远程连接用户

在MySQL 8.0及更高版本中，GRANT语句中的IDENTIFIED BY部分不再被支持。可以先创建用户，然后赋予权限。

#### 创建用户：

```sql
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
```

#### 赋予权限：

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
```

#### 刷新权限：

```sql
FLUSH PRIVILEGES;
```

#### 完整的操作流程如下：

```sql
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
```

### 删除远程连接用户

#### 先撤销用户的所有权限，然后再删除用户

```sql
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'root'@'%';
DROP USER 'root'@'%';
```

### 设置`wait_timeout` 和 `interactive_timeout`

查看当前的 `wait_timeout` 和 `interactive_timeout` 设置：

```bash
SHOW VARIABLES LIKE 'wait_timeout';
SHOW VARIABLES LIKE 'interactive_timeout';
```

修改 `wait_timeout` 和 `interactive_timeout` 设置：

```bash
SET GLOBAL wait_timeout = 300;   -- 设置为5分钟
SET GLOBAL interactive_timeout = 300;  -- 设置为5分钟
```

**查看最大连接数：**

```bash
SHOW VARIABLES LIKE 'max_connections';
```
