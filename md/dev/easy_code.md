---
title: "easy_code"
date: 2026-06-04
tags: ["dev"]
---

#date/2024-09-29# #lastmod/2024-09-29#

---

## controller.java.vm

~~~java
##定义初始变量
#set($tableName = $tool.append($tableInfo.name, "Controller"))
##设置回调
$!callback.setFileName($tool.append($tableName, ".java"))
$!callback.setSavePath($tool.append($tableInfo.savePath, "/controller"))
##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}controller;

import $!{tableInfo.savePackageName}.model.entity.$!{tableInfo.name};
import $!{tableInfo.savePackageName}.service.$!{tableInfo.name}Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * $!{tableInfo.comment}($!{tableInfo.name})表控制层
 *
 * @author $!author
 * @since $!time.currTime()
 */
@RestController
@RequestMapping("/$!tool.firstLowerCase($tableInfo.name)")
public class $!{tableName} {

    @Resource
    private $!{tableInfo.name}Service $!tool.firstLowerCase($tableInfo.name)Service;

}

~~~

## entity.java.vm

~~~java
##引入宏定义
$!{define.vm}

##使用宏定义设置回调（保存位置与文件后缀）
#save("/model/entity", ".java")

##使用宏定义设置包后缀
#setPackageSuffix("model.entity")

##使用全局变量实现默认包导入
$!{autoImport.vm}
import java.io.Serializable;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

##使用宏定义实现类注释信息
#tableComment("实体类")

@AllArgsConstructor
@Data
@NoArgsConstructor
@TableName(value ="$tableInfo.preName$!{tool.hump2Underline($!{tool.firstLowerCase($tableInfo.name)})}")
public class $!{tableInfo.name} implements Serializable {
    private static final long serialVersionUID = $!tool.serial();
###set($pkColumnName = $tableInfo.pkColumn[0].obj.name)

#foreach($column in $tableInfo.fullColumn)
    #if(${column.comment})
    /**${column.comment}*/
    #end
    #foreach($pkcolumn in $tableInfo.pkColumn)
        #if(${pkcolumn.name.equals($column.name)})
    @TableId(type = IdType.AUTO)
        #end
    #end
    private $!{tool.getClsNameByFullName($column.type)} $!{column.name};

#end

}
~~~

## mapper.xml.vm

~~~xml
##引入mybatis支持
$!{mybatisSupport.vm}

##设置保存名称与保存位置
$!callback.setFileName($tool.append($!{tableInfo.name}, "Mapper.xml"))
$!callback.setSavePath($tool.append($modulePath, "/src/main/resources/mapper"))

##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="$!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper">

    <resultMap type="$!{tableInfo.savePackageName}.model.entity.$!{tableInfo.name}" id="$!{tableInfo.name}Map">
#foreach($column in $tableInfo.fullColumn)
        <result property="$!column.name" column="$!column.obj.name" jdbcType="$!column.ext.jdbcType"/>
#end
    </resultMap>
    <sql id="Base_Column_List">
        #foreach($column in $tableInfo.fullColumn)
        $column.obj.name#if($foreach.hasNext),#end
        #end
    </sql>
    <insert id="addOne">
        insert into $!{tableInfo.obj.name}
            (
      #foreach($column in $tableInfo.otherColumn)
          #if(!$column.name.equals("id") && !$column.name.equals("delFlag"))
             <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end#if($column.type.equals("java.lang.Integer")) and $!column.name != 0#end#if($column.type.equals("java.lang.Long")) and $!column.name != 0L#end">$!column.obj.name,</if>
          #end
      #end
      #foreach($column in $tableInfo.otherColumn)
          #if($column.name.equals("createTime"))
             create_time,
          #end
          #if($column.name.equals("delFlag"))
             del_flag,
          #end
      #end
            ) 
        values 
            (
     #foreach($column in $tableInfo.otherColumn)
         #if(!$column.name.equals("id") && !$column.name.equals("delFlag"))
            <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end#if($column.type.equals("java.lang.Integer")) and $!column.name != 0#end#if($column.type.equals("java.lang.Long")) and $!column.name != 0L#end">$!column.obj.name,</if>
         #end
     #end
     #foreach($column in $tableInfo.otherColumn)
         #if($column.name.equals("createTime"))
            sysdate(),
         #end
         #if($column.name.equals("delFlag"))
            '0',
         #end
     #end            
            )
    </insert>
    <update id="updateOne">
        update $!{tableInfo.obj.name} set
      #foreach($column in $tableInfo.otherColumn)
        <if test="$!column.name != null#if($column.type.equals("java.lang.String")) and $!column.name != ''#end#if($column.type.equals("java.lang.Integer")) and $!column.name != 0#end#if($column.type.equals("java.lang.Long")) and $!column.name != 0L#end">$!column.obj.name = #{$!column.name},</if>
      #end
      where 1 = 0
    </update>
</mapper>
~~~

## service.java.vm

~~~java
##定义初始变量
#set($tableName = $tool.append($tableInfo.name, "Service"))
##设置回调
$!callback.setFileName($tool.append($tableName, ".java"))
$!callback.setSavePath($tool.append($tableInfo.savePath, "/service"))

##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import $!{tableInfo.savePackageName}.model.entity.$!{tableInfo.name};
import $!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper;
import org.springframework.stereotype.Service;

/**
 * $!{tableInfo.comment}($!{tableInfo.name})表服务接口
 *
 * @author $!author
 * @since $!time.currTime()
 */
 
@Service
public class $!{tableName} extends ServiceImpl<$!{tableInfo.name}Mapper, $!{tableInfo.name}> {

    @Resource
    private $!{tableInfo.name}Mapper $tool.firstLowerCase($!{tableInfo.name})Mapper; 

}
~~~

## mapper.java.vm

~~~java
##定义初始变量
#set($tableName = $tool.append($tableInfo.name, "Mapper"))
##设置回调
$!callback.setFileName($tool.append($tableName, ".java"))
$!callback.setSavePath($tool.append($tableInfo.savePath, "/mapper"))

##拿到主键
#if(!$tableInfo.pkColumn.isEmpty())
    #set($pk = $tableInfo.pkColumn.get(0))
#end

#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import $!{tableInfo.savePackageName}.model.entity.$!{tableInfo.name};
import org.apache.ibatis.annotations.Param;

/**
 * $!{tableInfo.comment}($!{tableInfo.name})表数据库访问层
 *
 * @author $!author
 * @since $!time.currTime()
 */
public interface $!{tableName}  extends BaseMapper<$!{tableInfo.name}> {

    int addOne(@Param("$tool.firstLowerCase($!{tableInfo.name})") $!{tableInfo.name} $tool.firstLowerCase($!{tableInfo.name}));

}
~~~
