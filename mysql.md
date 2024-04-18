# mysql

## 目录
<!-- vim-markdown-toc GFM -->

* [mysql管理](#mysql管理)
    * [用户设置](#用户设置)
    * [配置文件/etc/my.cnf](#配置文件etcmycnf)
    * [管理mysql的命令](#管理mysql的命令)

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
