# jenkins

## 目录

<!-- vim-markdown-toc GFM -->

* [介绍以及安装方式](#介绍以及安装方式)
* [目录结构](#目录结构)
* [风格规范](#风格规范)
* [agent](#agent)
* [最佳实践](#最佳实践)
    * [流水线组织](#流水线组织)
    * [pipeline编写](#pipeline编写)
    * [保护jenkins](#保护jenkins)
    * [备份和恢复](#备份和恢复)

<!-- vim-markdown-toc -->

## 介绍以及安装方式
jenkins由java开发，基于spring框架，主要的交互方式是web，jenkins war包能被所支持的java版本运行。

常见的部署方式：docker（dind）、kubernetes、linux、windows、war file

war:
```
WAR（Web Application Archive）是一种用于打包和部署 Java Web 应用程序的文件格式。它是一种压缩文件，通常以 .war 为文件扩展名。WAR 文件包含了整个 Java Web 应用程序的目录结构、类文件、JSP 页面、HTML 文件、XML 文件、静态资源等。

WAR 文件是一种方便的方式来打包和部署 Java Web 应用程序。开发者可以通过构建工具（如 Apache Maven 或 Gradle）将项目打包成 WAR 文件，然后将该文件部署到支持 Java Web 应用的服务器（如 Apache Tomcat、Jetty、WebLogic 等）中运行。
```

## 目录结构
家目录：基于$JENKINS_HOME
```
JENKINS_HOME
 +- builds            (build records)
    +- [BUILD_ID]     (subdirectory for each build)
         +- build.xml      (build result summary)
         +- changelog.xml  (change log)
 +- config.xml         (Jenkins root configuration file)
 +- *.xml              (other site-wide configuration files)
 +- fingerprints       (stores fingerprint records, if any)
 +- identity.key.enc   (RSA key pair that identifies an instance)
 +- jobs               (root directory for all Jenkins jobs)
     +- [JOBNAME]      (sub directory for each job)
         +- config.xml (job configuration file)
     +- [FOLDERNAME]   (sub directory for each folder)
         +- config.xml (folder configuration file)
         +- jobs       (subdirectory for all nested jobs)
 +- plugins            (root directory for all Jenkins plugins)
     +- [PLUGIN]       (sub directory for each plugin)
     +- [PLUGIN].jpi   (.jpi or .hpi file for the plugin)
 +- secret.key         (deprecated key used for some plugins' secure operations)
 +- secret.key.not-so-secret  (used for validating _$JENKINS_HOME_ creation date)
 +- secrets            (root directory for the secret+key for credential decryption)
     +- hudson.util.Secret   (used for encrypting some Jenkins data)
     +- master.key           (used for encrypting the hudson.util.Secret key)
     +- InstanceIdentity.KEY (used to identity this instance)
 +- userContent        (files served under your https://server/userContent/)
 +- workspace          (working directory for the version control system)
```

war包目录：/usr/share/jenkins (linux)

## 风格规范
命名要求：[a-zA-Z0-9_-]+

## agent
作为一个负载来实际运行jenkins控制器所分配的job

jnlp
```
JNLP 是 Java Network Launch Protocol（Java 网络启动协议）的缩写。它是由 Java Web Start（JWS）使用的一种协议。Java Web Start 是一种由 Sun Microsystems（现在是 Oracle Corporation）开发的技术，它允许用户通过网络从服务器上启动和安装 Java 应用程序，而不需要预先在本地安装。

JNLP 的主要作用是定义了如何描述和启动 Java 应用程序的配置文件。JNLP 文件是一个 XML 文件，其中包含了启动 Java 应用程序所需的信息，包括应用程序的名称、版本、主类、资源（JAR 文件等）的位置以及其他相关配置。
```

## 最佳实践

### 流水线组织
use organization folders, use multibranch Pipelines, use pipeline   
不使用maven作业类型，会引入复杂性

### pipeline编写
1. 一旦碰到错误就退出
2. 方便后续改动维护
3. 执行中失败后，再次从头开始执行不会受到之前失败的影响
4. 构建所需的依赖工具管理：假设目标agent没有安装必要工具，将工具的安装作为构建过程的一部分

### 保护jenkins
1. 设置身份验证（jenkins'own user database）和授权（Matrix Authorization Strategy Plugin）
2. 不在控制器上构建，在控制器上运行的任何构建都具有与jenkins进程相同级别的文件访问权限

### 备份和恢复
1. 文件系统快照
文件系统快照为备份提供最大的一致性

2. 用于备份的插件
目前仅维护开源插件中的thinBackup Plugin 

3. 编写一个备份 Jenkins 实例的 shell 脚本
您可以编写自己的 shell 脚本，将相应的文件和目录复制到备份位置。使用cron 安排备份脚本运行的时间。  
为每个备份创建唯一标识符（例如，使用时间戳）以确保今天的备份不会覆盖昨天的备份  
将文件写入本地文件系统是进行备份的最快方法。考虑将已完成的备份复制到远程备份服务器或设备以进行长期存储。

4. 单独备份controller key
controller key存在secrets目录下的hudson.utilSecret文件中，并使用master.key对其进行加密，所以单独备份master.key

5. 应该备份哪些文件？
备份整个$JENKINS_HOME目录会保留整个 Jenkins 实例。要恢复系统，只需将整个备份复制到新系统即可

6. 验证备份
将完整的备份放到临时目录，如/mnt/backup-test  
设置 export JENKINS_HOME=/mnt/backup-test
启动jenkins并指定一个随机端口，java -jar jenkins.war --httpPort=9999
