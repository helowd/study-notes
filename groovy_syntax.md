# groovy语法

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
    * [特性](#特性)
    * [helloworld](#helloworld)
* [与java的不同](#与java的不同)
* [列表](#列表)
* [映射](#映射)
    * [创建映射](#创建映射)
    * [访问Map](#访问map)
    * [修改Map](#修改map)
    * [删除键值对](#删除键值对)
    * [遍历Map](#遍历map)
    * [判断Map是否包含键或值](#判断map是否包含键或值)
    * [获取Map的大小](#获取map的大小)
* [闭包](#闭包)
    * [闭包中的形式参数](#闭包中的形式参数)
    * [闭包和变量](#闭包和变量)
    * [在方法中使用闭包](#在方法中使用闭包)
    * [集合和字符串中的闭包](#集合和字符串中的闭包)
        * [使用闭包和列表](#使用闭包和列表)
        * [使用映射闭包](#使用映射闭包)
* [jenkins pipeline](#jenkins-pipeline)
    * [groovy插值问题：使用单引号传递变量](#groovy插值问题使用单引号传递变量)
    * [可选步骤参数](#可选步骤参数)
    * [共享库](#共享库)
        * [定义共享库](#定义共享库)
        * [载入共享库](#载入共享库)
        * [动态加载库](#动态加载库)
        * [编写共享库](#编写共享库)
            * [传递steps](#传递steps)
            * [定义全局变量](#定义全局变量)
            * [自定义step](#自定义step)
            * [大规模DSL](#大规模dsl)
        * [使用第三方库](#使用第三方库)
* [坑](#坑)

<!-- vim-markdown-toc -->

## 简介
Apache的Groovy是Java平台上设计的面向对象编程语言。这门动态语言拥有类似Python、Ruby和Smalltalk中的一些特性，可以作为Java平台的脚本语言使用，Groovy代码动态地编译成运行于Java虚拟机（JVM）上的Java字节码，并与其他Java代码和库进行互操作。由于其运行在JVM上的特性，Groovy可以使用其他Java语言编写的库。Groovy的语法与Java非常相似，大多数Java代码也符合Groovy的语法规则，尽管可能语义不同。 Groovy 1.0于2007年1月2日发布，并于2012年7月发布了Groovy 2.0。从版本2开始，Groovy也可以静态编译，提供类型推论和Java相近的性能。Groovy 2.4是Pivotal软件赞助的最后一个主要版本，截止于2015年3月。Groovy已经将其治理结构更改为Apache软件基金会的项目管理委员会（PMC）。

### 特性
大部分有效的Java文件也是有效的Groovy文件。

Groovy代码比Java代码更加紧凑，因为它不需要Java需要的所有元素。这两种语言的相似性，让Java程序员可以先从熟悉的Java语法开始逐步学习Groovy。 Groovy特性包括了Java中不支持的静态和动态类型（使用关键字 def），运算符重载，提供了lists（列表）和关联数组(maps)提供了原生语法，原生支持正则表达式，多态迭代，字符串内嵌表达式，添加帮助方法以及Null条件运算符，自动空指针检查（列：variable?.method(),或 variable?.field）

与java不同的是，Groovy源代码文件可以当作（未编译的）脚本执行，如果它含有任何类定义之外的代码，或者它是具有main方法的类，或者它是Runnable或GroovyTestCase。 Groovy脚本在执行之前完成解析，编译和生成（类似于Perl和Ruby）。这发生在下一个层次，编译后的版本不会保存为进程的组件

可以直接通过groovy script.groovy的方式运行脚本，而无需先编译

### helloworld
```groovy
class Example {
   static void main(String[] args) {
      // One can see the use of a semi-colon after each statement
      // 用关键字def声明一个变量，这里会声明x成一个值为5的整数变量
      def x = 5;
      println('Hello World' + ", " + x); 
   }
}
```

## 与java的不同
groovy源自java，但在此之上增强了某些特性，并且允许某些简化
1. groovy默认导入以下库，无须再用import导入
```groovy
java.io.*
java.lang.*
java.math.BigDecimal
java.math.BigInteger
java.net.*
java.util.*
groovy.lang.*
groovy.util.*

// 可以直接使用println "hellowolrd!"打印
```

2. 类型推断:
    * Groovy 是一种动态类型语言，因此它可以进行类型推断，无需显式声明变量的类型。
    * 例如，在 Groovy 中可以直接给变量赋值，而无需指定类型。
```groovy
// Groovy 中的类型推断
def myVariable = 10
```

```java
// Java 中的显式类型声明
int myVariable = 10;
```

3. 闭包支持:
    * Groovy 对闭包（匿名函数）提供了更好的支持，使得编写函数式编程风格的代码更为简单。
    * 例如，可以在 Groovy 中直接将闭包传递给方法或赋值给变量。

```groovy
// Groovy 中的闭包
def closure = { name -> "Hello, $name!" }
println closure("John")  // 输出: Hello, John!
```

```java
// Java 中无法直接使用闭包，需使用接口或 lambda 表达式
// 以下示例使用 Java 8 的 lambda 表达式
import java.util.function.Function;

Function<String, String> closure = (String name) -> {
    return "Hello, " + name + "!";
};
System.out.println(closure.apply("John"));  // 输出: Hello, John!
```

4. groovy无须每条语句后面都加分号

5. def定义前可以添加修饰符，如 public，private 和 protected。默认情况下，如果未提供可见性修饰符，则该方法为 public。
```groovy
class Example {
   static def DisplayName() {
      println("This is how methods work in groovy");
      println("This is an example of a simple method");
   } 
    
   static void main(String[] args) {
      DisplayName();
   } 
}
```

6. def定义方法时不需要指定返回值，Groovy 是一种动态类型语言，它会根据函数体中的逻辑推断函数的返回值类型，因此不需要显式指定返回值类型。

## 列表
在 Groovy 中，List 保存了一系列对象引用。List 中的对象引用占据序列中的位置，并通过整数索引来区分。groovy中的一个列表中的数据可以是任何类型，与java下集合列表有些不同，java下的列表是同种类型。groovy列表可以嵌套列表，如[1, 2, [3, 4, 5], "aaa"]
```groovy
def list1 = []  
def list2 = [1, 2, 3, 4]  
list2.add(12)  
list2.add(12)  
println(list1.size())
```

## 映射
映射（也称为关联数组，字典，表和散列）是对象引用的无序集合。Map集合中的元素由键值访问。 Map中使用的键可以是任何类。当我们插入到Map集合中时，需要两个值：键和值。

### 创建映射
['TopicName': 'Lists'，'TopicName': 'Maps'] - 具有TopicName作为键的键值对的集合及其相应的值。

[:] - 空映射。

你可以使用花括号 `{}` 来创建一个Map，并使用 `:` 将键和值分隔开，多个键值对之间用逗号分隔。例如：

```groovy
def person = [
    name: "John",
    age: 30,
    city: "New York"
]
```

### 访问Map

你可以使用方括号 `[]` 来访问Map中的值，将键作为索引。例如：

```groovy
println(person["name"]) // 输出：John
println(person.age)     // 输出：30
```

### 修改Map

你可以直接使用键来修改Map中的值，或者使用 `put()` 方法。例如：

```groovy
person.age = 35
person.put("city", "Los Angeles")
```

### 删除键值对

你可以使用 `remove()` 方法来删除Map中的键值对。例如：

```groovy
person.remove("city")
```

### 遍历Map

你可以使用 `each` 方法来遍历Map中的所有键值对。例如：

```groovy
person.each { key, value ->
    println("$key: $value")
}
```

### 判断Map是否包含键或值

你可以使用 `containsKey()` 和 `containsValue()` 方法来判断Map中是否包含指定的键或值。例如：

```groovy
println(person.containsKey("name")) // 输出：true
println(person.containsValue("Chicago")) // 输出：false
```

### 获取Map的大小

你可以使用 `size()` 方法来获取Map中键值对的数量。例如：

```groovy
println(person.size()) // 输出：2
```

## 闭包
闭包是要一个短的匿名函数或者代码段。一个方法甚至可以将代码块作为参数，帮助简化代码并实现函数式编程风格

示例：
```groovy
class Example {
   static void main(String[] args) {
      def clos = {println "Hello World"};
      clos.call();
   } 
}

// 输出：
// Hello Wolrd
```
在上面的例子中，代码行 - {println“Hello World”}被称为闭包。此标识符引用的代码块可以使用call语句执行。

### 闭包中的形式参数
闭包也可以包含形式参数，以使它们更有用，就像groovy中的方法一样
```groovy
class Example {
   static void main(String[] args) {
      def clos = {param->println "Hello ${param}"};
      clos.call("World");
   } 
}
```
在上面的代码示例中，注意使用$ {param}，这导致closure接受一个参数。当通过clos.call语句调用闭包时，我们现在可以选择将一个参数传递给闭包。

下一个图重复了前面的例子并产生相同的结果，但显示可以使用被称为它的隐式单个参数。这里的'it'是Groovy中的关键字。
```groovy
class Example {
   static void main(String[] args) {
      def clos = {println "Hello ${it}"};
      clos.call("World");
   } 
}
```

### 闭包和变量
更正式地，闭包可以定义在闭包时引用变量
```groovy
class Example {     
   static void main(String[] args) {
      def str1 = "Hello";
      def clos = {param -> println "${str1} ${param}"}
      clos.call("World");
        
      // We are now changing the value of the String str1 which is referenced in the closure
      str1 = "Welcome";
      clos.call("World");
   } 
}
```
在上面的例子中，除了向闭包传递参数之外，我们还定义了一个名为str1的变量。闭包也接受变量和参数。

### 在方法中使用闭包
闭包也可以用作方法的参数。在Groovy中，很多用于数据类型（例如列表和集合）的内置方法都有闭包作为参数类型。
```groovy
class Example { 
   def static Display(clo) {
      // This time the $param parameter gets replaced by the string "Inner"         
      clo.call("Inner");
   } 
    
   static void main(String[] args) {
      def str1 = "Hello";
      def clos = { param -> println "${str1} ${param}" }
      clos.call("World");
        
      // We are now changing the value of the String str1 which is referenced in the closure
      str1 = "Welcome";
      clos.call("World");
        
      // Passing our closure to a method
      Example.Display(clos);
   } 
}
```
我们定义一个名为Display的静态方法，它将闭包作为参数。

然后我们在我们的main方法中定义一个闭包，并将它作为一个参数传递给我们的Display方法。

### 集合和字符串中的闭包
几个List，Map和String方法接受一个闭包作为参数。

#### 使用闭包和列表
以下示例显示如何使用闭包与列表。在下面的例子中，我们首先定义一个简单的值列表。列表集合类型然后定义一个名为.each的函数。此函数将闭包作为参数，并将闭包应用于列表的每个元素
```groovy
class Example {
   static void main(String[] args) {
      def lst = [11, 12, 13, 14];
      lst.each {println it}
   } 
}
```

#### 使用映射闭包
在下面的例子中，我们首先定义一个简单的关键值项Map。然后，映射集合类型定义一个名为.each的函数。此函数将闭包作为参数，并将闭包应用于映射的每个键值对。
```groovy
class Example {
   static void main(String[] args) {
      def mp = ["TopicName" : "Maps", "TopicDescription" : "Methods in Maps"]             
      mp.each {println it}
      mp.each {println "${it.key} maps to: ${it.value}"}
   } 
}
```
当我们运行上面的程序，我们将得到以下结果 -
```
TopicName = Maps 
TopicDescription = Methods in Maps 
TopicName maps to: Maps 
TopicDescription maps to: Methods in Maps
```

通常，我们可能希望遍历集合的成员，并且仅当元素满足一些标准时应用一些逻辑。这很容易用闭包中的条件语句来处理。
```groovy
class Example {
   static void main(String[] args) {
      def lst = [1,2,3,4];
      lst.each {println it}
      println("The list will only display those numbers which are divisible by 2")
      lst.each{num -> if(num % 2 == 0) println num}
   } 
}
```
上面的例子显示了在闭包中使用的条件if（num％2 == 0）表达式，用于检查列表中的每个项目是否可被2整除。

当我们运行上面的程序，我们会得到以下结果 -
```
1 
2 
3 
4 
The list will only display those numbers which are divisible by 2.
2 
4 
```

## jenkins pipeline
语法：
```groovy
//  声明式
pipeline {
    agent none
    stages {
        stage('Build') {
            agent any
            steps {
                checkout scm
                sh 'make'
                stash includes: '**/target/*.jar', name: 'app'
            }
        }
        stage('Test on Linux') {
            agent {
                label 'linux'
            }
            steps {
                unstash 'app'
                sh 'make check'
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
        stage('Test on Windows') {
            agent {
                label 'windows'
            }
            steps {
                unstash 'app'
                bat 'make check'
            }
            post {
                always {
                    junit '**/target/*.xml'
                }
            }
        }
    }
}

// 脚本式
stage('Build') {
    node {
        checkout scm
        sh 'make'
        stash includes: '**/target/*.jar', name: 'app'
    }
}

stage('Test') {
    node('linux') {
        checkout scm
        try {
            unstash 'app'
            sh 'make check'
        }
        finally {
            junit '**/target/*.xml'
        }
    }
    node('windows') {
        checkout scm
        try {
            unstash 'app'
            bat 'make check'
        }
        finally {
            junit '**/target/*.xml'
        }
    }
}
```

### groovy插值问题：使用单引号传递变量
1. Groovy 字符串插值永远不应该与凭据一起使用。例如，考虑传递到sh步骤的敏感环境变量。
```groovy
pipeline {
    agent any
    environment {
        EXAMPLE_CREDS = credentials('example-credentials-id')
    }
    stages {
        stage('Example') {
            steps {
                /* WRONG! */
                sh("curl -u ${EXAMPLE_CREDS_USR}:${EXAMPLE_CREDS_PSW} https://example.com/")
            }
        }
    }
}
```
如果 Groovy 执行插值，敏感值将被直接注入到该步骤的参数中，这意味着文字值将作为操作系统进程列表中代理上的进程的sh参数可见。sh引用这些敏感环境变量时使用单引号而不是双引号可以防止此类泄漏。
```groovy
pipeline {
    agent any
    environment {
        EXAMPLE_CREDS = credentials('example-credentials-id')
    }
    stages {
        stage('Example') {
            steps {
                /* CORRECT */
                sh('curl -u $EXAMPLE_CREDS_USR:$EXAMPLE_CREDS_PSW https://example.com/')
            }
        }
    }
}
```

2. Groovy 字符串插值可以通过特殊字符将恶意命令注入命令解释器。
用户控制的变量使用groovy字符串插值，并且通过将参数传递给命令解释器的步骤（例如 sh、bat、powershel）可能会导致类似sql注入的问题。当特殊字符，如`/ \ $ & % ^ > < | ;`使用groovy插值传递到解释器时，就会发生这种情况。例如：
```groovy
pipeline {
  agent any
  parameters {
    string(name: 'STATEMENT', defaultValue: 'hello; ls /', description: 'What should I say?')
  }
  stages {
    stage('Example') {
      steps {
        /* WRONG! */
        sh("echo ${STATEMENT}")
      }
    }
  }
}
```
在此示例中，步骤的参数sh由 Groovy 计算，并STATEMENT直接插入到参数中，就像sh('echo hello; ls /')已写入管道中一样。hello; ls /当在代理上处理此问题时，它将回hello显然后继续列出代理的整个根目录，而不是回显 value 。任何能够控制由此类步骤插入的变量的用户都可以使该sh步骤在代理上运行任意代码。为了避免此问题，请确保步骤的参数（例如sh或bat引用参数或其他用户控制的环境变量）使用单引号以避免 Groovy 插值。如下：
```groovy
pipeline {
  agent any
  parameters {
    string(name: 'STATEMENT', defaultValue: 'hello; ls /', description: 'What should I say?')
  }
  stages {
    stage('Example') {
      steps {
        /* CORRECT */
        sh('echo ${STATEMENT}')
      }
    }
  }
}
```

### 可选步骤参数
Pipeline 遵循 Groovy 语言约定，允许在方法参数周围省略括号。

许多 Pipeline 步骤还使用命名参数语法作为在 Groovy 中创建 Map 的简写，它使用语法[key1: value1, key2: value2]. 使如下语句在功能上等效：
```
git url: 'git://example.com/amazing-project.git', branch: 'master'
git([url: 'git://example.com/amazing-project.git', branch: 'master'])
```

为了方便起见，当调用只带一个参数（或只带一个强制参数）的步骤时，可以省略参数名称，例如：
```
sh 'echo hello' /* short form  */
sh([script: 'echo hello'])  /* long form */
```

### 共享库
共享库的目录结构如下：
```
(root)
+- src                     # Groovy source files
|   +- org
|       +- foo
|           +- Bar.groovy  # for org.foo.Bar class
+- vars
|   +- foo.groovy          # for global 'foo' variable
|   +- foo.txt             # help for 'foo' variable
+- resources               # resource files (external libraries only)
|   +- org
|       +- foo
|           +- bar.json    # static helper data for org.foo.Bar
```
src目录类似java项目的源代码目录，执行pipelines时，该目录会添加到类路径中

var目录是在pipeline中作为全局公开的变量的脚本文件。文件的名称是管道中变量的名称，因此，如果存在一个`var/log.groovy`文件，其中定义了一个函数`def info(message) ...`，然后pipeline中就可以通过`log.info "hello world"来调用它。每个文件名称遵循小骆驼风格。.txt文件是变量的说明的文档文件，格式可以是HTML, Markdown等。

目录resources允许libraryResource从外部库使用该步骤来加载关联的非 Groovy 文件。目前内部库不支持此功能。

根目录下的其他目录保留用于将来的增强。

#### 定义共享库
全局共享库，在Manage Jenkins ⇨ Configure System ⇨ Global Pipeline Libraries定义  
目录共享库，在目录或者子目录上定义  
某些插件可能会自动安装共享库  

#### 载入共享库
隐式载入：    
如果你把共享库标记为Load implicitly，则Pipeline可以直接使用。

静态载入：  
否则，必须通过注解@Library来启动：
```groovy
// 使用库的默认版本
@Library('my-library') _
// 指定版本
@Library('my-library@1.0') _
// 使用多个库
@Library(['my-library', 'otherlib@abc1234']) _
```

如果Pipeline仅仅需要使用全局变量，或者库仅仅包含了var目录，则可以使用 _后缀。否则，你需要使用import语句
```groovy
@Library('somelib')
import com.mycorp.pipeline.somelib.UsefulClass
```

在编译Pipeline脚本时，共享库被加载，之后Pipeline被执行。全局变量是在运行时动态解析的

#### 动态加载库
从Pipeline: Shared Groovy Libraries插件的 2.7 版开始，在构建过程中随时动态library加载库的步骤

如果只需要使用vars目录下的全局变量或函数，只需要这样：
```groovy
library 'my-shared-library@{BRANCH_NAME}'
```

对于src目录中，通过步骤的返回值中的完全限定名称来访问它们library
```groovy
library('my-shared-library').com.mycorp.pipeline.Utils.someStaticMethod()
```

也可以访问类中的静态字段，如果有静态方法，也可以通过new调用构造函数：
```groovy
def useSomeLib(helper) { // dynamic: cannot declare as Helper
    helper.prepare()
    return helper.count()
}

def lib = library('my-shared-library').com.mycorp.pipeline // preselect the package

echo useSomeLib(lib.Helper.new(lib.Constants.SOME_TEXT))
```

不需要在jenkins中预定义库，这种情况必须制定库版本
```groovy
library identifier: 'custom-lib@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'git@git.mycorp.com:my-jenkins-utils.git',
   credentialsId: 'my-private-key'])
```

#### 编写共享库
任何groovy代码都是允许的，如数据结构、工具函数、类，例如：
```groovy
// src/org/foo/Point.groovy
package org.foo

// point in 3D space
class Point {
  float x,y,z
}
```

sh库类不能直接调用或 等步骤git。需要先声明方法，在这些方法又调用管道步骤，例如：
```groovy
// src/org/foo/Zot.groovy
package org.foo

def checkOutFrom(repo) {
  git url: "git@github.com:jenkinsci/${repo}"
}

return this
```
然后可以从脚本化管道中调用：
```groovy
def z = new org.foo.Zot()
z.checkOutFrom(repo)
```
这种方法有其局限性；例如，它阻止声明超类。

##### 传递steps
当前可用的Step集合，可以通过this关键字传递给共享库。例如共享库代码：
```groovy
package cc.gmem.ci
class Utils implements Serializable {
  // 实例变量
  def steps
  // 构造函数
  Utils(steps) {this.steps = steps}
  // 方法
  def mvn(args) {
    steps.sh "${steps.tool 'Maven'}/bin/mvn -o ${args}"
  }
}
```
使用上述共享库的代码：
```groovy
@Library('utils') import cc.gmem.ci.Utils
def utils = new Utils(this)  // 传递this
node {
  // 调用共享库
  utils.mvn 'clean package'
}
```

##### 定义全局变量
共享库的var目录中的脚本，会被按需的创建为单例：
```groovy
def info(message) {
    echo "INFO: ${message}"
}
 
def warning(message) {
    echo "WARNING: ${message}"
}
```
你可以在pipeline中这样调用：
```groovy
// utils为库名
@Library('utils') _
 
// log为脚本文件名，info为其中定义的方法
log.info 'Starting'
log.warning 'Nothing to do!'
```
当使用声明式Pipeline时，你必须在script指令内部来使用共享库全局变量

##### 自定义step
如果要定义一个名为sayHello的Step，你需要：

创建脚本vars/sayHello.groovy  
在脚本中定义call方法   

这个call方法允许你像调用Step那样调用全局变量：
```groovy
def call(String name = 'human') {
    // 这个方法中可以调用任何合法的Step
    echo "Hello, ${name}."
}
```
你可以在自己的pipeline中调用上诉step：
```groovy
// 传递参数
sayHello 'Alex'
// 使用默认参数
sayHello() 
```

自定义step可以接受闭包：
```groovy
// 文件vars/windows.groovy
// 允许传递闭包
def call(Closure body) {
    node('windows') {
        body()
    }
}
```
调用上述step：
```groovy
windows {
    bat "cmd /?"
}
```
注意：要使用命名参数传参，必须使用下一节的def  call(Map config)方式，否则会报错：is applicable for argument 

##### 大规模DSL
如果你有很多大规模的、非常相似的Pipeline，可以将其直接封装到自定义Step中：
```groovy
// 文件var/buildPlugin.groovy
def call(Map config) {
    node {
        git url: "https://github.com/jenkinsci/${config.name}-plugin.git"
        sh 'mvn install'
        mail to: '...', subject: "${config.name} plugin build", body: '...'
    }
}
```
这样，只需要一行代码的脚本式Pipeline即可，代码大大简化：`buildPlugin name: 'git'`

甚至，完整的声明式pipeline也可以封装到自定义step中：
```groovy
// 文件vars/evenOrOdd.groovy
def call(int buildNumber) {
  if (buildNumber % 2 == 0) {
    pipeline {
      agent any
      stages {
        stage('Even Stage') {
          steps {
            echo "The build number is even"
          }
        }
      }
    }
  } else {
    pipeline {
      agent any
      stages {
        stage('Odd Stage') {
          steps {
            echo "The build number is odd"
          }
        }
      }
    }
  }
}
```

调用
```groovy
@Library('my-shared-library')

envenOrOdd(currentBuild.getNumber())
```

pipeline目前只能在共享库中定义整个。这只能在vars/*.groovy, 并且只能在call方法中完成。在一次构建中只能执行一个声明式管道，如果您尝试执行第二个，您的构建将会失败。

#### 使用第三方库
使用@Grab可以从Maven仓库动态的载入共享库：
```groovy
@Grab('org.apache.commons:commons-math3:3.4.1')
import org.apache.commons.math3.primes.Primes
void parallelize(int count) {
  // 调用第三方库
  if (!Primes.isPrime(count)) {
  }
}
```

## 坑
在jenkins共享库的groovy脚本中，sh包裹的多行语句块里，groovy不能正常解析sh中$符号和groovy中的$符号，例如以下代码会报错
```groovy
def call(String pyVersion='', List modules = []) {
    def moduleString = modules.join(' ') 
    sh """
        set -eux
        ${pyVersion} -m pip install --upgrade pip
        ${pyVersion} -m pip install ${moduleString}
        if (( $? != 0 )); then
            echo Failed to install ${moduleString}
            exit 1
        fi
    """
}
```
原因是sh多双引号包裹的语句里，既有shell中$，又有groovy中的$，因而groovy不能正常分别解析出来，解决办法是在shell中$符号前加入\转义字符
```groovy
sh """
    if (( \$? != 0 )); then
        echo Failed to install ${moduleString}
        exit 1
    fi
"""
```
