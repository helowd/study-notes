# mysql

## 目录
<!-- vim-markdown-toc GFM -->

* [mysql管理](#mysql管理)
    * [用户设置](#用户设置)
    * [配置文件/etc/my.cnf](#配置文件etcmycnf)
    * [管理mysql的命令](#管理mysql的命令)
* [可观测性](#可观测性)
    * [关键指标](#关键指标)
        * [延迟](#延迟)
        * [流量](#流量)
        * [错误](#错误)
        * [饱和度](#饱和度)

<!-- vim-markdown-toc -->

## mysql管理
mysql安装好后默认有四个库（普通用户只能看到第一个库）：
```
information_schema：是一个信息数据库，它保存着关于MySQL服务器所维护的所有其他数据库的信息。(如数据库名，数据库的表，表栏的数据类型与访问权 限等 数据字典--》元数据：描述其他数据的数据 中央情报局（统计局）：收录了整个MySQL里的信息（能统计的一切信息）

performance_schema：性能架构库，主要用于收集数据库服务器性能参数。 执行某些操作会有性能相关的参数 存放MySQL运行起来后相关的数据，例如登陆用户，变量，内存的消耗等

mysql ：存放的是MySQL程序相关的表：登录用户表、时间相关表、db、权限表 mysql的核心数据库，类似于sql server中的master表，主要负责存储数据库的用户、权限设置、关键字等mysql自己需要使用的控制和管理信息

sys： MySQL系统 Sys库所有的数据源来自：performance_schema。目标是把performance_schema的把复杂度降低，让DBA能更好的阅读这个库里的内容。让DBA更快的了解DB的运行情况。
```

### 用户设置
1. 如果需要添加mysql用户，只需要在mysql数据库的user表添加新用户即可

以下为添加用户的实例，用户名为guest，密码为guest123，并授权用户可进行 SELECT, INSERT 和 UPDATE操作权限：
```
root@host# mysql -u root -p
Enter password:*******
mysql> use mysql;
Database changed

mysql> INSERT INTO user 
          (host, user, password, 
           select_priv, insert_priv, update_priv) 
           VALUES ('localhost', 'guest', 
           PASSWORD('guest123'), 'Y', 'Y', 'Y');
Query OK, 1 row affected (0.20 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 1 row affected (0.01 sec)

mysql> SELECT host, user, password FROM user WHERE user = 'guest';
+-----------+---------+------------------+
| host      | user    | password         |
+-----------+---------+------------------+
| localhost | guest | 6f8c114b58f2ce9e |
+-----------+---------+------------------+
1 row in set (0.00 sec)
```
在添加用户时，请注意使用MySQL提供的 PASSWORD() 函数来对密码进行加密。 你可以在以上实例看到用户密码加密后为： 6f8c114b58f2ce9e.

注意：在 MySQL5.7 中 user 表的 password 已换成了authentication_string。

注意：password() 加密函数已经在 8.0.11 中移除了，可以使用 MD5() 函数代替。

注意：在注意需要执行 FLUSH PRIVILEGES 语句。 这个命令执行后会重新载入授权表。

如果你不使用该命令，你就无法使用新创建的用户来连接mysql服务器，除非你重启mysql服务器。

你可以在创建用户时，为用户指定权限，在对应的权限列中，在插入语句中设置为 Y 即可。

mysql.user表中常见字段列表及其含义：
```
Host: 用户连接的来源主机。
User: 用户名。
Password: 加密后的密码。
Select_priv: 是否允许用户执行 SELECT 操作。
Insert_priv: 是否允许用户执行 INSERT 操作。
Update_priv: 是否允许用户执行 UPDATE 操作。
Delete_priv: 是否允许用户执行 DELETE 操作。
Create_priv: 是否允许用户创建新表或数据库。
Drop_priv: 是否允许用户删除表或数据库。
Reload_priv: 是否允许用户执行 FLUSH 操作。
Shutdown_priv: 是否允许用户执行 SHUTDOWN 操作。
Process_priv: 是否允许用户查看其他用户的进程。
File_priv: 是否允许用户执行文件操作（如 LOAD DATA INFILE）。
Grant_priv: 是否允许用户授予或撤销其他用户的权限。
References_priv: 是否允许用户创建外键约束。
Index_priv: 是否允许用户创建或删除索引。
Alter_priv: 是否允许用户执行 ALTER TABLE 操作。
Show_db_priv: 是否允许用户执行 SHOW DATABASES 操作。
Super_priv: 是否允许用户执行超级权限的操作。
Create_tmp_table_priv: 是否允许用户创建临时表。
Lock_tables_priv: 是否允许用户锁定表。
Execute_priv: 是否允许用户执行存储过程和函数。
Repl_slave_priv: 是否允许用户作为复制从库。
Repl_client_priv: 是否允许用户作为复制客户端。
Create_view_priv: 是否允许用户创建视图。
Show_view_priv: 是否允许用户执行 SHOW CREATE VIEW 操作。
Create_routine_priv: 是否允许用户创建存储过程和函数。
Alter_routine_priv: 是否允许用户修改存储过程和函数。
Create_user_priv: 是否允许用户创建、删除和重命名用户。
Event_priv: 是否允许用户创建、修改、删除事件。
Trigger_priv: 是否允许用户创建、修改、删除触发器。
Create_tablespace_priv: 是否允许用户创建和删除表空间。
ssl_type: SSL 类型。
ssl_cipher: SSL 密码。
x509_issuer: X.509 证书颁发者。
x509_subject: X.509 证书主题。
max_questions: 用户可以执行的最大查询数量。
max_updates: 用户可以执行的最大更新数量。
max_connections: 用户可以同时打开的最大连接数。
max_user_connections: 用户可以同时打开的最大用户连接数。
```

2. 另一种添加方式通过sql的GRANT命令

假设我们要添加一个用户名为 newuser，密码为 password123，允许从任何主机连接，并且拥有对名为 exampledb 数据库的所有权限。
```
GRANT ALL PRIVILEGES ON exampledb.* TO 'newuser'@'%' IDENTIFIED BY 'password123';
```
说明：
```
GRANT ALL PRIVILEGES: 授予用户所有权限。
ON exampledb.*: 将权限限制在 exampledb 数据库中的所有表上。
TO 'newuser'@'%': 创建了一个名为 newuser，可以从任何主机连接的用户。
IDENTIFIED BY 'password123': 设置了用户的密码为 password123。
最后，还需要执行 FLUSH PRIVILEGES 来刷新权限
```

### 配置文件/etc/my.cnf
/etc/my.cnf 文件是 MySQL 配置文件，用于配置 MySQL 服务器的各种参数和选项。

一般情况下，你不需要修改该配置文件，该文件默认配置如下：
```
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

[mysql.server]
user=mysql
basedir=/var/lib

[safe_mysqld]
err-log=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```
在配置文件中，你可以指定不同的错误日志文件存放的目录，一般你不需要改动这些配置。

/etc/my.cnf 文件在不同的系统和 MySQL 版本中可能有所不同，但是一般包含以下几个部分：

1. 基本设置
```
basedir: MySQL 服务器的基本安装目录。
datadir: 存储 MySQL 数据文件的位置。
socket: MySQL 服务器的 Unix 套接字文件路径。
pid-file: 存储当前运行的 MySQL 服务器进程 ID 的文件路径。
port: MySQL 服务器监听的端口号，默认是 3306。
```

2. 服务器选项
```
bind-address: 指定 MySQL 服务器监听的 IP 地址，可以是 IP 地址或主机名。
server-id: 在复制配置中，为每个 MySQL 服务器设置一个唯一的标识符。
default-storage-engine: 默认的存储引擎，例如 InnoDB 或 MyISAM。
max_connections: 服务器可以同时维持的最大连接数。
thread_cache_size: 线程缓存的大小，用于提高新连接的启动速度。
query_cache_size: 查询缓存的大小，用于提高相同查询的效率。
default-character-set: 默认的字符集。
collation-server: 服务器的默认排序规则。
```

3. 性能调优
```
innodb_buffer_pool_size: InnoDB 存储引擎的缓冲池大小，这是 InnoDB 性能调优中最重要的参数之一。
key_buffer_size: MyISAM 存储引擎的键缓冲区大小。
table_open_cache: 可以同时打开的表的缓存数量。
thread_concurrency: 允许同时运行的线程数。
```

4. 安全设置
```
skip-networking: 禁止 MySQL 服务器监听网络连接，仅允许本地连接。
skip-grant-tables: 以无需密码的方式启动 MySQL 服务器，通常用于恢复忘记的 root 密码，但这是一个安全风险。
auth_native_password=1: 启用 MySQL 5.7 及以上版本的原生密码认证。
```

5. 日志设置
```
log_error: 错误日志文件的路径。
general_log: 记录所有客户端连接和查询的日志。
slow_query_log: 记录执行时间超过特定阈值的慢查询。
log_queries_not_using_indexes: 记录未使用索引的查询。
```

6. 复制设置
```
master_host 和 master_user: 主服务器的地址和复制用户。
master_password: 复制用户的密码。
master_log_file 和 master_log_pos: 用于复制的日志文件和位置。
```

### 管理mysql的命令
USE 数据库名 :
```
选择要操作的Mysql数据库，使用该命令后所有Mysql命令都只针对该数据库。

mysql> use RUNOOB;
Database changed
SHOW DATABASES:
列出 MySQL 数据库管理系统的数据库列表。

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| RUNOOB             |
| cdcol              |
| mysql              |
| onethink           |
| performance_schema |
| phpmyadmin         |
| test               |
| wecenter           |
| wordpress          |
+--------------------+
10 rows in set (0.02 sec)
```

SHOW TABLES:
```
显示指定数据库的所有表，使用该命令前需要使用 use 命令来选择要操作的数据库。

mysql> use RUNOOB;
Database changed
mysql> SHOW TABLES;
+------------------+
| Tables_in_runoob |
+------------------+
| employee_tbl     |
| runoob_tbl       |
| tcount_tbl       |
+------------------+
3 rows in set (0.00 sec)
```

SHOW COLUMNS FROM 数据表:
```
显示数据表的属性，属性类型，主键信息 ，是否为 NULL，默认值等其他信息。

mysql> SHOW COLUMNS FROM runoob_tbl;
+-----------------+--------------+------+-----+---------+-------+
| Field           | Type         | Null | Key | Default | Extra |
+-----------------+--------------+------+-----+---------+-------+
| runoob_id       | int(11)      | NO   | PRI | NULL    |       |
| runoob_title    | varchar(255) | YES  |     | NULL    |       |
| runoob_author   | varchar(255) | YES  |     | NULL    |       |
| submission_date | date         | YES  |     | NULL    |       |
+-----------------+--------------+------+-----+---------+-------+
4 rows in set (0.01 sec)
```

SHOW INDEX FROM 数据表:
```
显示数据表的详细索引信息，包括PRIMARY KEY（主键）。

mysql> SHOW INDEX FROM runoob_tbl;
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table      | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| runoob_tbl |          0 | PRIMARY  |            1 | runoob_id   | A         |           2 |     NULL | NULL   |      | BTREE      |         |               |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
1 row in set (0.00 sec)
```

`SHOW TABLE STATUS [FROM db_name] [LIKE 'pattern'] \G:`
```
该命令将输出Mysql数据库管理系统的性能及统计信息。

mysql> SHOW TABLE STATUS  FROM RUNOOB;   # 显示数据库 RUNOOB 中所有表的信息

mysql> SHOW TABLE STATUS from RUNOOB LIKE 'runoob%';     # 表名以runoob开头的表的信息
mysql> SHOW TABLE STATUS from RUNOOB LIKE 'runoob%'\G;   # 加上 \G，查询结果按列打印
```

## 可观测性
google四个黄金指标
```
延迟：请求花费的时间，注意区分成功请求和失败请求
流量：每秒请求数量、事务数量等
错误：每秒错误次数
饱和度：描述应用程序有多“满”
```

### 关键指标

#### 延迟
应用程序会向 MySQL 发起 SELECT、UPDATE 等操作，处理这些请求花费了多久，是非常关键的，甚至我们还想知道具体是哪个 SQL 最慢，这样就可以有针对性地调优。我们应该如何采集这些延迟数据呢？典型的方法有三种。

1. 在客户端埋点。即上层业务程序在请求 MySQL 的时候，记录一下每个 SQL 的请求耗时，把这些数据统一推给监控系统，监控系统就可以计算出平均延迟、95 分位、99 分位的延迟数据了。不过因为要埋点，对业务代码有一定侵入性。

2. Slow queries。MySQL 提供了慢查询数量的统计指标，通过下面这段命令就可以拿到。
```
show global status like 'Slow_queries';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Slow_queries  | 107   |
+---------------+-------+
1 row in set (0.000 sec)
```
这个指标是 Counter 类型的，即单调递增，如果想知道最近一分钟有多少慢查询，需要使用 increase 函数做二次计算。

3. 通过 performance schema 和 sys schema 拿到统计数据。比如 performance schema 的 events_statements_summary_by_digest 表，这个表捕获了很多关键信息，比如延迟、错误量、查询量。我们看下面的例子，SQL 执行了 2 次，平均执行时间是 325 毫秒，表里的时间度量指标都是以皮秒为单位。
```
*************************** 1. row ***************************
                SCHEMA_NAME: employees
                     DIGEST: 0c6318da9de53353a3a1bacea70b4fce
                DIGEST_TEXT: SELECT * FROM `employees` WHERE `emp_no` > ?
                 COUNT_STAR: 2
             SUM_TIMER_WAIT: 650358383000
             MIN_TIMER_WAIT: 292045159000
             AVG_TIMER_WAIT: 325179191000
             MAX_TIMER_WAIT: 358313224000
              SUM_LOCK_TIME: 520000000
                 SUM_ERRORS: 0
               SUM_WARNINGS: 0
          SUM_ROWS_AFFECTED: 0
              SUM_ROWS_SENT: 520048
          SUM_ROWS_EXAMINED: 520048
...
          SUM_NO_INDEX_USED: 0
     SUM_NO_GOOD_INDEX_USED: 0
                 FIRST_SEEN: 2016-03-24 14:25:32
                  LAST_SEEN: 2016-03-24 14:25:55
```

针对即时查询、诊断问题的场景，我们还可以使用 sys schema，sys schema 提供了一种组织良好、人类易读的指标查询方式，查询起来更简单。比如我们可以用下面的方法找到最慢的 SQL。这个数据在 statements_with_runtimes_in_95th_percentile 表中。
```
SELECT * FROM sys.statements_with_runtimes_in_95th_percentile;
```

#### 流量
关于流量，我们最耳熟能详的是统计 SELECT、UPDATE、DELETE、INSERT 等语句执行的数量。如果流量太高，超过了硬件承载能力，显然是需要监控、需要扩容的。这些类型的指标在 MySQL 的全局变量中都可以拿到。我们来看下面这个例子。
```
show global status where Variable_name regexp 'Com_insert|Com_update|Com_delete|Com_select|Questions|Queries';
+-------------------------+-----------+
| Variable_name           | Value     |
+-------------------------+-----------+
| Com_delete              | 2091033   |
| Com_delete_multi        | 0         |
| Com_insert              | 8837007   |
| Com_insert_select       | 0         |
| Com_select              | 226099709 |
| Com_update              | 24218879  |
| Com_update_multi        | 0         |
| Empty_queries           | 25455182  |
| Qcache_queries_in_cache | 0         |
| Queries                 | 704921835 |
| Questions               | 461095549 |
| Slow_queries            | 107       |
+-------------------------+-----------+
12 rows in set (0.001 sec)
```
例子中的这些指标都是 Counter 类型，单调递增，另外 Com_ 是 Command 的前缀，即各类命令的执行次数。整体吞吐量主要是看 Questions 指标，但 Questions 很容易和它上面的 Queries 混淆。从例子里我们可以明显看出 Questions 的数量比 Queries 少。Questions 表示客户端发给 MySQL 的语句数量，而 Queries 还会包含在存储过程中执行的语句，以及 PREPARE 这种准备语句，所以监控整体吞吐一般是看 Questions。

流量方面的指标，一般我们会统计写数量（Com_insert + Com_update + Com_delete）、读数量（Com_select）、语句总量（Questions）。


#### 错误
错误量这类指标有多个应用场景，比如客户端连接 MySQL 失败了，或者语句发给 MySQL，执行的时候失败了，都需要有失败计数。典型的采集手段有两种。

1. 在客户端采集、埋点，不管是 MySQL 的问题还是网络的问题，亦或者中间负载均衡的问题或 DNS 解析的问题，只要连接失败了，都可以发现。缺点刚刚我们也介绍了，就是会有代码侵入性。

2. 从 MySQL 中采集相关错误，比如连接错误可以通过 Aborted_connects 和 Connection_errors_max_connections 拿到。
```
show global status where Variable_name regexp 'Connection_errors_max_connections|Aborted_connects';
+-----------------------------------+--------+
| Variable_name                     | Value  |
+-----------------------------------+--------+
| Aborted_connects                  | 785546 |
| Connection_errors_max_connections | 0      |
+-----------------------------------+--------+
```
只要连接失败，不管是什么原因，Aborted_connects 都会 +1，而更常用的是 Connection_errors_max_connections ，它表示超过了最大连接数，所以 MySQL 拒绝连接。MySQL 默认的最大连接数只有 151，在现在这样的硬件条件下，实在是太小了，因此出现这种情况的频率比较高，需要我们多多关注，及时发现这一情况。

刚刚我们在介绍延迟指标的时候，提到了 events_statements_summary_by_digest 表，我们也可以通过这个表拿到错误数量。
```
SELECT schema_name
     , SUM(sum_errors) err_count
  FROM performance_schema.events_statements_summary_by_digest
 WHERE schema_name IS NOT NULL
 GROUP BY schema_name;
+--------------------+-----------+
| schema_name        | err_count |
+--------------------+-----------+
| employees          |         8 |
| performance_schema |         1 |
| sys                |         3 |
+--------------------+-----------+
```

#### 饱和度
对于 MySQL 而言，用什么指标来反映资源有多“满”呢？首先我们要关注 MySQL 所在机器的 CPU、内存、硬盘 I/O、网络流量这些基础指标，这些指标我们在第 11 讲机器监控中已经讲解过了，你可以自己再回顾一下。

MySQL 本身也有一些指标来反映饱和度，比如刚才我们讲到的连接数，当前连接数（Threads_connected）除以最大连接数（max_connections）可以得到连接数使用率，是一个需要重点监控的饱和度指标。

另外就是 InnoDB Buffer pool 相关的指标，一个是 Buffer pool 的使用率，一个是 Buffer pool 的内存命中率。Buffer pool 是一块内存，专门用来缓存 Table、Index 相关的数据，提升查询性能。对 InnoDB 存储引擎而言，Buffer pool 是一个非常关键的设计。我们查看一下 Buffer pool 相关的指标。
```
MariaDB [(none)]> show global status like '%buffer%';
+---------------------------------------+--------------------------------------------------+
| Variable_name                         | Value                                            |
+---------------------------------------+--------------------------------------------------+
| Innodb_buffer_pool_dump_status        |                                                  |
| Innodb_buffer_pool_load_status        | Buffer pool(s) load completed at 220825 11:11:13 |
| Innodb_buffer_pool_resize_status      |                                                  |
| Innodb_buffer_pool_load_incomplete    | OFF                                              |
| Innodb_buffer_pool_pages_data         | 5837                                             |
| Innodb_buffer_pool_bytes_data         | 95633408                                         |
| Innodb_buffer_pool_pages_dirty        | 32                                               |
| Innodb_buffer_pool_bytes_dirty        | 524288                                           |
| Innodb_buffer_pool_pages_flushed      | 134640371                                        |
| Innodb_buffer_pool_pages_free         | 1036                                             |
| Innodb_buffer_pool_pages_misc         | 1318                                             |
| Innodb_buffer_pool_pages_total        | 8191                                             |
| Innodb_buffer_pool_read_ahead_rnd     | 0                                                |
| Innodb_buffer_pool_read_ahead         | 93316                                            |
| Innodb_buffer_pool_read_ahead_evicted | 203                                              |
| Innodb_buffer_pool_read_requests      | 8667876784                                       |
| Innodb_buffer_pool_reads              | 236654                                           |
| Innodb_buffer_pool_wait_free          | 5                                                |
| Innodb_buffer_pool_write_requests     | 533520851                                        |
+---------------------------------------+--------------------------------------------------+
19 rows in set (0.001 sec)
```
这里有 4 个指标我重点讲一下。Innodb_buffer_pool_pages_total 表示 InnoDB Buffer pool 的页总量，页（page）是 Buffer pool 的一个分配单位，默认的 page size 是 16KiB，可以通过 show variables like "innodb_page_size" 拿到。

Innodb_buffer_pool_pages_free 是剩余页数量，通过 total 和 free 可以计算出 used，用 used 除以 total 就可以得到使用率。当然，使用率高并不是说有问题，因为 InnoDB 有 LRU 缓存清理机制，只要响应得够快，高使用率也不是问题。

Innodb_buffer_pool_read_requests 和 Innodb_buffer_pool_reads 是另外两个关键指标。read_requests 表示向 Buffer pool 发起的查询总量，如果 Buffer pool 缓存了相关数据直接返回就好，如果 Buffer pool 没有相关数据，就要穿透内存去查询硬盘了。有多少请求满足不了需要去查询硬盘呢？

这就要看 Innodb_buffer_pool_reads 指标统计的数量。所以，reads 这个指标除以 read_requests 就得到了穿透比例，这个比例越高，性能越差，一般可以通过调整 Buffer pool 的大小来解决。

根据 Google 四个黄金指标的方法论，我们梳理了 MySQL 相关的指标，这些指标大多是可以通过 global status 和 variables 拿到的。performance schema 和 sys schema 相对难搞，一是 sys schema 需要较高版本才能支持，二是这两个 schema 的数据不太适合放到 metrics 库里。常见做法是通过一些偏全局的统计指标，比如 Slow_queries，先发现问题，再通过这两个 schema 的数据分析细节。
