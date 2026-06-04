---
title: "spring boot 动态切换数据源"
date: 2026-06-04
tags: ["dev"]
---

​#lastmod/2025-07-25 15:41:36#​ #date/2025-07-24 11:45:18#

```java
package com.kongseek.datebase;

import com.zaxxer.hikari.HikariDataSource; // 假设使用 HikariCP 连接池
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 动态数据源类，继承自 AbstractRoutingDataSource，实现数据源的动态切换。
 * <p>
 * 该类通过线程本地存储 (ThreadLocal) 管理数据源，支持根据不同的上下文切换数据源。
 * 还可以通过提供的静态方法切换当前数据源，支持将多个数据源动态地添加到应用程序中。
 * 增加了数据源切换时的连接池状态检查和阻塞机制，确保在所有连接空闲时才进行切换。
 * </p>
 */
@Getter
@Component
public class DynamicDataSource1 extends AbstractRoutingDataSource {

    // 用于同步数据源切换的锁和条件变量
    private final ReentrantLock switchLock = new ReentrantLock();
    private final Condition idleConnectionsCondition = switchLock.newCondition();
    // 标志位，指示数据源切换是否正在进行中
    private volatile boolean switchingInProgress = false;

    // 用于存储已解析的数据源及其键，以便进行监控
    private final Map<Object, DataSource> activeDataSources = new ConcurrentHashMap<>();

    @PostConstruct
    public void init() {
        // 默认数据源为 SQLite
        DataSource defaultDataSource = createDataSource("jdbc:sqlite:C:\\Develop\\Project\\Java\\easy-server\\src\\main\\resources\\easy-server.db", "", "", "sqlite");

        // 配置数据源集合，将 SQLite 和 MySQL 数据源加入集合
        Map<Object, Object> dataSourceMap = new HashMap<>();
        dataSourceMap.put("sqlite", defaultDataSource);
        dataSourceMap.put("mysql", createDataSource("jdbc:mysql://192.168.10.254:3306/easy_server", "root", "mysql_CNRtcB", "mysql"));

        this.setDefaultTargetDataSource(defaultDataSource);
        this.setTargetDataSources(dataSourceMap);
        this.springDataSource = "sqlite";

        // 初始化 activeDataSources 映射
        dataSourceMap.forEach((key, value) -> activeDataSources.put(key, (DataSource) value));
        super.afterPropertiesSet(); // 设置数据源后，务必调用此方法进行初始化
    }

    /**
     * 确定当前要使用的数据源。
     * 如果数据源切换正在进行中，此方法将阻塞，直到切换完成。
     *
     * @return 当前线程的数据库类型（如 mysql 或 sqlite）
     */
    @Override
    protected Object determineCurrentLookupKey() {
        // 如果数据源切换正在进行中，则阻塞
        if (switchingInProgress) {
            switchLock.lock();
            try {
                while (switchingInProgress) {
                    try {
                        // 等待一小段时间，然后重新检查。
                        // 考虑设置超时时间，以防止在出现问题时无限期阻塞。
                        idleConnectionsCondition.await(100, TimeUnit.MILLISECONDS);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        throw new RuntimeException("等待数据源切换完成时被中断", e);
                    }
                }
            } finally {
                switchLock.unlock();
            }
        }
        // 先使用线程本地数据源，若为空则使用 spring 数据源
        return localDataSource.get() != null ? localDataSource.get() : springDataSource;
    }

    /**
     * 线程本地存储，用于存放每个线程的数据源。
     */
    private final ThreadLocal<String> localDataSource = new ThreadLocal<>();

    /**
     * Spring 数据源，优先级低于线程本地数据源。
     */
    private String springDataSource;

    /**
     * 获取当前线程或 Spring 数据源。
     *
     * @return 当前的数据源类型名称
     */
    public String getDataSourceType() {
        if (localDataSource.get() != null) {
            return localDataSource.get();
        }
        if (springDataSource != null) {
            return springDataSource;
        }
        // 如果未设置 springDataSource，则回退到已解析的默认数据源
        // 注意：这依赖于 AbstractRoutingDataSource 的内部状态，如果未设置 `springDataSource`，
        // 则不适合外部查找。
        DataSource resolvedDefaultDataSource = getResolvedDefaultDataSource();
        for (Map.Entry<Object, DataSource> entry : activeDataSources.entrySet()) {
            if (resolvedDefaultDataSource == entry.getValue()) {
                return entry.getKey().toString();
            }
        }
        return null;
    }

    /**
     * 切换 Spring 数据源类型。此方法将尝试阻塞，直到当前活动数据源中的所有连接都空闲。
     *
     * @param newDataSourceType 数据源类型（如 mysql、sqlite）
     * @throws IllegalStateException 如果数据源切换失败
     */
    public void setSpringDataSourceType(String newDataSourceType) {
        if (!activeDataSources.containsKey(newDataSourceType)) {
            throw new IllegalArgumentException("未找到数据源类型 '" + newDataSourceType + "'。");
        }

        switchLock.lock();
        try {
            if (switchingInProgress) {
                throw new IllegalStateException("另一个数据源切换已在进行中。");
            }
            switchingInProgress = true;

            String currentDataSourceKey = getDataSourceType(); // 获取当前活动的数据源键
            DataSource currentDataSource = activeDataSources.get(currentDataSourceKey);

            if (currentDataSource instanceof HikariDataSource) {
                HikariDataSource hikariDataSource = (HikariDataSource) currentDataSource;
                // 等待所有活动连接空闲
                // 通常需要轮询，因为连接池不总是提供直接的阻塞机制
                long startTime = System.currentTimeMillis();
                long timeout = 30000; // 30秒超时，等待连接空闲

                while (hikariDataSource.getHikariPoolMXBean().getActiveConnections() > 0) {
                    try {
                        System.out.println("等待 " + currentDataSourceKey + " 连接空闲。活动连接数：" +
                                hikariDataSource.getHikariPoolMXBean().getActiveConnections());
                        Thread.sleep(500); // 每500毫秒检查一次
                        if (System.currentTimeMillis() - startTime > timeout) {
                            throw new IllegalStateException("等待数据源 " + currentDataSourceKey + " 连接空闲超时。活动连接数：" +
                                    hikariDataSource.getHikariPoolMXBean().getActiveConnections());
                        }
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        throw new RuntimeException("等待连接空闲时被中断。", e);
                    }
                }
                System.out.println(currentDataSourceKey + " 的所有连接现在都已空闲。继续切换。");
            } else {
                System.out.println("当前数据源不是 HikariDataSource，无法监控活动连接。立即切换。");
                // 如果不是 Hikari，则立即切换，这可能存在风险。
                // 您可能希望在此处抛出异常或记录警告。
            }

            this.springDataSource = newDataSourceType;
            // 无需在此处调用 afterPropertiesSet()，因为当新请求进入时，
            // determineCurrentLookupKey 会处理它。`springDataSource` 字段是 `determineCurrentLookupKey` 使用的。

            // 通知所有等待的线程切换已完成
            idleConnectionsCondition.signalAll();
        } finally {
            switchingInProgress = false; // 确保此标志始终被重置
            switchLock.unlock();
        }
    }

    /**
     * 切换当前线程的数据源类型。
     *
     * @param dataSourceType 数据源类型（如 mysql、sqlite）
     */
    public void setLocalDataSourceType(String dataSourceType) {
        if (switchingInProgress) {
            // 如果全局切换正在进行中，线程本地切换理想情况下应该等待
            // 或被阻止以避免冲突。为简单起见，我们将允许它继续，
            // 但如果 `switchingInProgress` 为 true，`determineCurrentLookupKey` 仍将阻塞。
            System.out.println("警告：尝试在全局切换进行中时设置本地数据源。");
        }
        localDataSource.set(dataSourceType);
    }

    /**
     * 清空当前线程本地存储的数据源类型。
     */
    public void clearLocalDataSource() {
        localDataSource.remove();
    }

    /**
     * 动态添加新的数据源。
     * 此方法在更新过程中也会阻塞新的连接。
     *
     * @param dataSourceType 数据源类型
     * @param url            数据库连接 URL
     * @param username       数据库用户名
     * @param password       数据库密码
     * @param dbType         数据库类型（如：mysql、postgresql、oracle等）
     */
    public void addDataSource(String dataSourceType, String url, String username, String password, String dbType) {
        switchLock.lock();
        try {
            if (switchingInProgress) {
                throw new IllegalStateException("无法在另一个切换进行中时添加数据源。");
            }
            switchingInProgress = true;

            // 创建 DataSource 实例
            DataSource newDataSource = createDataSource(url, username, password, dbType);

            // 临时存储现有和新的数据源以进行更新
            Map<Object, Object> updatedDataSources = new HashMap<>(getResolvedDataSources());
            updatedDataSources.put(dataSourceType, newDataSource);

            // 更新 Spring 数据源
            updateSpringDataSource(updatedDataSources);

            // 更新我们内部的活动数据源映射
            activeDataSources.put(dataSourceType, newDataSource);

            System.out.println("新数据源 '" + dataSourceType + "' 添加成功。");
            idleConnectionsCondition.signalAll(); // 如果有任何线程在等待通用切换，则发出信号
        } finally {
            switchingInProgress = false;
            switchLock.unlock();
        }
    }


    /**
     * 更新 Spring 数据源。
     *
     * @param dataSourceMap 更新后的数据源集合
     */
    private void updateSpringDataSource(Map<Object, Object> dataSourceMap) {
        super.setTargetDataSources(dataSourceMap);
        // 更新目标数据源后，调用 afterPropertiesSet() 进行重新初始化
        afterPropertiesSet();
    }

    /**
     * 根据连接信息和数据库类型创建 DataSource 实例
     *
     * @param url      数据库连接 URL
     * @param username 数据库用户名
     * @param password 数据库密码
     * @param dbType   数据库类型（如：mysql、postgresql、oracle等）
     * @return 创建的 DataSource 实例
     */
    private DataSource createDataSource(String url, String username, String password, String dbType) {
        DataSourceBuilder<?> dataSourceBuilder = DataSourceBuilder.create()
                .url(url)
                .username(username)
                .password(password);
        // 根据数据库类型设置不同的 JDBC 驱动类
        switch (dbType.toLowerCase()) {
            case "mysql":
                dataSourceBuilder.driverClassName("com.mysql.cj.jdbc.Driver");
                break;
            case "sqlite":
                dataSourceBuilder.driverClassName("org.sqlite.JDBC");
                break;
            case "postgresql":
                dataSourceBuilder.driverClassName("org.postgresql.Driver");
                break;
            case "oracle":
                dataSourceBuilder.driverClassName("oracle.jdbc.OracleDriver");
                break;
            case "sqlserver":
                dataSourceBuilder.driverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                break;
            // 添加其他数据库类型的驱动类
            default:
                throw new IllegalArgumentException("不支持的数据库类型: " + dbType);
        }
        return dataSourceBuilder.build();
    }
}

```

- [ ] ‍

- [ ] ‍
