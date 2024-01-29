# jenkins

## 目录

<!-- vim-markdown-toc GFM -->

* [最佳实践](#最佳实践)
* [介绍以及安装方式](#介绍以及安装方式)
* [agent](#agent)

<!-- vim-markdown-toc -->

## 最佳实践
编写一个pipeline要考虑的：
1. 一旦碰到错误就退出
2. 方便后续改动维护
3. 执行中失败后，再次从头开始执行不会受到之前失败的影响

构建所需的依赖工具管理：假设目标agent没有安装必要工具，将工具的安装作为构建过程的一部分

## 介绍以及安装方式
jenkins由java开发，基于spring框架，主要的交互方式是web，jenkins war包能被所支持的java版本运行。

常见的部署方式：docker（dind）、kubernetes、linux、windows、war file

war
```
WAR（Web Application Archive）是一种用于打包和部署 Java Web 应用程序的文件格式。它是一种压缩文件，通常以 .war 为文件扩展名。WAR 文件包含了整个 Java Web 应用程序的目录结构、类文件、JSP 页面、HTML 文件、XML 文件、静态资源等。

WAR 文件是一种方便的方式来打包和部署 Java Web 应用程序。开发者可以通过构建工具（如 Apache Maven 或 Gradle）将项目打包成 WAR 文件，然后将该文件部署到支持 Java Web 应用的服务器（如 Apache Tomcat、Jetty、WebLogic 等）中运行。
```

## agent
作为一个负载来实际运行jenkins控制器所分配的job

jnlp
```
JNLP 是 Java Network Launch Protocol（Java 网络启动协议）的缩写。它是由 Java Web Start（JWS）使用的一种协议。Java Web Start 是一种由 Sun Microsystems（现在是 Oracle Corporation）开发的技术，它允许用户通过网络从服务器上启动和安装 Java 应用程序，而不需要预先在本地安装。

JNLP 的主要作用是定义了如何描述和启动 Java 应用程序的配置文件。JNLP 文件是一个 XML 文件，其中包含了启动 Java 应用程序所需的信息，包括应用程序的名称、版本、主类、资源（JAR 文件等）的位置以及其他相关配置。
```
