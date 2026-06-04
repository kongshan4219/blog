---
title: "EASYCODE"
date: 2026-06-04
tags: ["dev"]
---

​#date/2025-05-04#​ #lastmod/2025-05-04#

```json
{
  "author" : "kongshan",
  "version" : "1.2.9",
  "userSecure" : "",
  "currTypeMapperGroupName" : "kongshan",
  "currTemplateGroupName" : "kongshan",
  "currColumnConfigGroupName" : "Default",
  "currGlobalConfigGroupName" : "Default",
  "typeMapper" : {
    "kongshan" : {
      "name" : "kongshan",
      "elementList" : [ {
        "matchType" : "REGEX",
        "columnType" : "varchar(\\(\\d+\\))?",
        "javaType" : "java.lang.String"
      }, {
        "matchType" : "REGEX",
        "columnType" : "char(\\(\\d+\\))?",
        "javaType" : "java.lang.String"
      }, {
        "matchType" : "REGEX",
        "columnType" : "(tiny|medium|long)*text",
        "javaType" : "java.lang.String"
      }, {
        "matchType" : "REGEX",
        "columnType" : "decimal(\\(\\d+,\\d+\\))?",
        "javaType" : "java.lang.Double"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "integer",
        "javaType" : "java.lang.Integer"
      }, {
        "matchType" : "REGEX",
        "columnType" : "(tiny|small|medium)*int(\\(\\d+\\))?",
        "javaType" : "java.lang.Integer"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "int4",
        "javaType" : "java.lang.Integer"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "int8",
        "javaType" : "java.lang.Long"
      }, {
        "matchType" : "REGEX",
        "columnType" : "bigint(\\(\\d+\\))?",
        "javaType" : "java.lang.Long"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "date",
        "javaType" : "java.util.Date"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "datetime",
        "javaType" : "java.util.Date"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "timestamp",
        "javaType" : "java.util.Date"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "time",
        "javaType" : "java.time.LocalTime"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "boolean",
        "javaType" : "java.lang.Boolean"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "bigint unsigned",
        "javaType" : "java.lang.Long"
      }, {
        "matchType" : "ORDINARY",
        "columnType" : "int unsigned",
        "javaType" : "java.lang.Integer"
      } ]
    }
  },
  "template" : {
    "kongshan" : {
      "name" : "kongshan",
      "elementList" : [ {
        "name" : "controller.java.vm",
        "code" : "##定义初始变量\n#set($tableName = $tool.append($tableInfo.name, \"Controller\"))\n##设置回调\n$!callback.setFileName($tool.append($tableName, \".java\"))\n$!callback.setSavePath($tool.append($tableInfo.savePath, \"/controller\"))\n##拿到主键\n#if(!$tableInfo.pkColumn.isEmpty())\n    #set($pk = $tableInfo.pkColumn.get(0))\n#end\n\n#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}controller;\n\nimport $!{tableInfo.savePackageName}.entity.domain.$!{tableInfo.name};\nimport $!{tableInfo.savePackageName}.service.$!{tableInfo.name}Service;\nimport org.springframework.web.bind.annotation.RequestMapping;\nimport org.springframework.web.bind.annotation.RestController;\n\nimport jakarta.annotation.Resource;\n\n/**\n * $!{tableInfo.comment}($!{tableInfo.name})表控制层\n *\n * @author $!author\n * @since $!time.currTime()\n */\n@RestController\n@RequestMapping(\"/$!tool.firstLowerCase($tableInfo.name)\")\npublic class $!{tableName} {\n\n    @Resource\n    private $!{tableInfo.name}Service $!tool.firstLowerCase($tableInfo.name)Service;\n\n}\n"
      }, {
        "name" : "entity.java.vm",
        "code" : "##引入宏定义\n$!{define.vm}\n\n##使用宏定义设置回调（保存位置与文件后缀）\n#save(\"/entity/domain\", \".java\")\n\n##使用宏定义设置包后缀\n#setPackageSuffix(\"entity.domain\")\n\n##使用全局变量实现默认包导入\n$!{autoImport.vm}\nimport java.io.Serializable;\n\nimport com.baomidou.mybatisplus.annotation.IdType;\nimport com.baomidou.mybatisplus.annotation.TableId;\nimport com.baomidou.mybatisplus.annotation.TableName;\nimport lombok.AllArgsConstructor;\nimport lombok.Data;\nimport lombok.NoArgsConstructor;\n\n##使用宏定义实现类注释信息\n#tableComment(\"实体类\")\n\n@AllArgsConstructor\n@Data\n@NoArgsConstructor\n@TableName(value =\"$tableInfo.preName$!{tool.hump2Underline($!{tool.firstLowerCase($tableInfo.name)})}\")\npublic class $!{tableInfo.name} implements Serializable {\n    private static final long serialVersionUID = $!tool.serial();\n###set($pkColumnName = $tableInfo.pkColumn[0].obj.name)\n\n#foreach($column in $tableInfo.fullColumn)\n    #if(${column.comment})\n    /**${column.comment}*/\n    #end\n##    #if($column.name.equals($pkColumnName))\n    #if(${column.pk})\n    @TableId(type = IdType.AUTO)\n    #end\n    private $!{tool.getClsNameByFullName($column.type)} $!{column.name};\n\n#end\n\n}"
      }, {
        "name" : "mapper.xml.vm",
        "code" : "##引入mybatis支持\n$!{mybatisSupport.vm}\n\n##设置保存名称与保存位置\n$!callback.setFileName($tool.append($!{tableInfo.name}, \"Mapper.xml\"))\n$!callback.setSavePath($tool.append($modulePath, \"/src/main/resources/mapper\"))\n\n##拿到主键\n#if(!$tableInfo.pkColumn.isEmpty())\n    #set($pk = $tableInfo.pkColumn.get(0))\n#end\n\n<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"$!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper\">\n\n    <resultMap type=\"$!{tableInfo.savePackageName}.entity.domain.$!{tableInfo.name}\" id=\"$!{tableInfo.name}Map\">\n#foreach($column in $tableInfo.fullColumn)\n        <result property=\"$!column.name\" column=\"$!column.obj.name\" jdbcType=\"$!column.ext.jdbcType\"/>\n#end\n    </resultMap>\n    <sql id=\"Base_Column_List\">\n        #foreach($column in $tableInfo.fullColumn)\n        $column.obj.name#if($foreach.hasNext),#end\n        #end\n    </sql>\n    <insert id=\"addOne\">\n        insert into $!{tableInfo.obj.name}\n            (\n      #foreach($column in $tableInfo.otherColumn)\n          #if(!$column.name.equals(\"id\") && !$column.name.equals(\"delFlag\"))\n             <if test=\"$!column.name != null#if($column.type.equals(\"java.lang.String\")) and $!column.name != ''#end#if($column.type.equals(\"java.lang.Integer\")) and $!column.name != 0#end#if($column.type.equals(\"java.lang.Long\")) and $!column.name != 0L#end\">$!column.obj.name,</if>\n          #end\n      #end\n      #foreach($column in $tableInfo.otherColumn)\n          #if($column.name.equals(\"createTime\"))\n             create_time,\n          #end\n          #if($column.name.equals(\"delFlag\"))\n             del_flag,\n          #end\n      #end\n            ) \n        values \n            (\n     #foreach($column in $tableInfo.otherColumn)\n         #if(!$column.name.equals(\"id\") && !$column.name.equals(\"delFlag\"))\n            <if test=\"$!column.name != null#if($column.type.equals(\"java.lang.String\")) and $!column.name != ''#end#if($column.type.equals(\"java.lang.Integer\")) and $!column.name != 0#end#if($column.type.equals(\"java.lang.Long\")) and $!column.name != 0L#end\">$!column.obj.name,</if>\n         #end\n     #end\n     #foreach($column in $tableInfo.otherColumn)\n         #if($column.name.equals(\"createTime\"))\n            sysdate(),\n         #end\n         #if($column.name.equals(\"delFlag\"))\n            '0',\n         #end\n     #end            \n            )\n    </insert>\n    <update id=\"updateOne\">\n        update $!{tableInfo.obj.name} set\n      #foreach($column in $tableInfo.otherColumn)\n        <if test=\"$!column.name != null#if($column.type.equals(\"java.lang.String\")) and $!column.name != ''#end#if($column.type.equals(\"java.lang.Integer\")) and $!column.name != 0#end#if($column.type.equals(\"java.lang.Long\")) and $!column.name != 0L#end\">$!column.obj.name = #{$!column.name},</if>\n      #end\n      where 1 = 0\n    </update>\n</mapper>\n"
      }, {
        "name" : "service.java.vm",
        "code" : "##定义初始变量\n#set($tableName = $tool.append($tableInfo.name, \"Service\"))\n##设置回调\n$!callback.setFileName($tool.append($tableName, \".java\"))\n$!callback.setSavePath($tool.append($tableInfo.savePath, \"/service\"))\n\n##拿到主键\n#if(!$tableInfo.pkColumn.isEmpty())\n    #set($pk = $tableInfo.pkColumn.get(0))\n#end\n\n#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}service;\n\nimport com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;\nimport $!{tableInfo.savePackageName}.entity.domain.$!{tableInfo.name};\nimport $!{tableInfo.savePackageName}.mapper.$!{tableInfo.name}Mapper;\nimport org.springframework.stereotype.Service;\n\nimport jakarta.annotation.Resource;\n\n/**\n * $!{tableInfo.comment}($!{tableInfo.name})表服务接口\n *\n * @author $!author\n * @since $!time.currTime()\n */\n \n@Service\npublic class $!{tableName} extends ServiceImpl<$!{tableInfo.name}Mapper, $!{tableInfo.name}> {\n\n    @Resource\n    private $!{tableInfo.name}Mapper $tool.firstLowerCase($!{tableInfo.name})Mapper; \n\n}"
      }, {
        "name" : "mapper.java.vm",
        "code" : "##定义初始变量\n#set($tableName = $tool.append($tableInfo.name, \"Mapper\"))\n##设置回调\n$!callback.setFileName($tool.append($tableName, \".java\"))\n$!callback.setSavePath($tool.append($tableInfo.savePath, \"/mapper\"))\n\n##拿到主键\n#if(!$tableInfo.pkColumn.isEmpty())\n    #set($pk = $tableInfo.pkColumn.get(0))\n#end\n\n#if($tableInfo.savePackageName)package $!{tableInfo.savePackageName}.#{end}mapper;\n\nimport com.baomidou.mybatisplus.core.mapper.BaseMapper;\nimport $!{tableInfo.savePackageName}.entity.domain.$!{tableInfo.name};\nimport org.apache.ibatis.annotations.Param;\n\n/**\n * $!{tableInfo.comment}($!{tableInfo.name})表数据库访问层\n *\n * @author $!author\n * @since $!time.currTime()\n */\npublic interface $!{tableName}  extends BaseMapper<$!{tableInfo.name}> {\n\n    int addOne(@Param(\"$tool.firstLowerCase($!{tableInfo.name})\") $!{tableInfo.name} $tool.firstLowerCase($!{tableInfo.name}));\n\n}\n"
      } ]
    }
  },
  "columnConfig" : { },
  "globalConfig" : { }
}
```

‍
