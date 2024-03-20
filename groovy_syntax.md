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
    * [声明式](#声明式)
        * [agent](#agent)
        * [post](#post)
        * [stages](#stages)
        * [steps](#steps)
        * [enviornment](#enviornment)
        * [options](#options)
        * [parameters](#parameters)
        * [trigger](#trigger)
        * [jenkins cron syntax](#jenkins-cron-syntax)
        * [stage](#stage)
        * [tools](#tools)
        * [input](#input)
        * [when](#when)
        * [sequential stages](#sequential-stages)
        * [parallel](#parallel)
        * [Matrix](#matrix)
            * [axes](#axes)
            * [stages](#stages-1)
            * [excludes (optional)](#excludes-optional)
            * [Matrix cell-level directives (optional)](#matrix-cell-level-directives-optional)
        * [step-script](#step-script)
    * [脚本式](#脚本式)
        * [声明式和脚本式语法的差异](#声明式和脚本式语法的差异)
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
* [坑?](#坑)

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

### 声明式
1. 所有有效的声明性管道必须包含在一个pipeline块中，例如：pipeline { }

2. 声明式管道中有效的基本语句和表达式遵循与Groovy 语法相同的规则，但有以下例外：
Pipeline 的顶层必须是一个block，具体来说：pipeline { }。

没有分号作为语句分隔符。每个语句必须独占一行。

块必须仅包含Sections、Directives、Steps或赋值语句。

属性引用语句被视为无参数方法调用。因此，例如，input被视为input()。
```groovy 
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
```

#### agent
该agent部分指定整个管道或特定阶段将在 Jenkins 环境中执行的位置，具体取决于该agent部分的放置位置。该部分必须在块内的顶层定义pipeline，但阶段级别的使用是可选的。

pipeline agent和stage agent的区别：在pipeline agent当中options { timeout() }会在代理被分配之后启用，而stage agent会在代理被分配之前就启用，超时将包括代理分配的时间。是必须的，允许在顶级pipeline块和每个stage块中。

语法：
```groovy
// any：在任何可用代理上执行
agent any

// none：当应用于块的顶层时，pipeline不会为整个管道运行分配全局代理，并且每个stage部分都需要包含自己的agent部分
agent none

// lable：使用提供的标签在 Jenkins 环境中可用的代理上执行管道或阶段
agent { lable 'my-defined-lable' }

// node：agent { node { label 'labelName' } }行为与agent { label 'labelName' }相同，但node允许其他选项（例如customWorkspace）
agent {
    node {
        label 'my-defined-label'
        // 默认相对路径是在节点的workspace目录下，也可以指定绝对路径，此选项对 Node、docker 和 dockerfile 有效。
        customWorkspace '/some/other/path'
    }
}

// docker：使用预先在jenkins中配置好的docker以及label
agent {
    docker {
        image 'maven:3.9.3-eclipse-temurin-17'
        label 'my-defined-label'
        args  '-v /tmp:/tmp'
    }
}

// Dockerfile：从源代码库中的Dockerfile文件动态构建并运行作为agent
agent {
    // Equivalent to "docker build -f Dockerfile.build --build-arg version=1.0.2 ./build/
    dockerfile {
        filename 'Dockerfile.build'
        dir 'build'
        label 'my-defined-label'
        additionalBuildArgs  '--build-arg version=1.0.2'
        args '-v /tmp:/tmp'
    }
}

// kubernetes：在kubernetes 集群上部署的 Pod 内执行管道或阶段。
agent {
    kubernetes {
        defaultContainer 'kaniko'
        yaml '''
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
      - name: aws-secret
        mountPath: /root/.aws/
      - name: docker-registry-config
        mountPath: /kaniko/.docker
  volumes:
    - name: aws-secret
      secret:
        secretName: aws-secret
    - name: docker-registry-config
      configMap:
        name: docker-registry-config
'''
   }
}
```

#### post
该部分定义了pipeline或stage运行完成时的动作。支持always、changed、fixed、regression、aborted、failure、success、unstable、unsuccessful和cleanup，这些条件块允许根据管道或阶段的完成状态执行每个条件内的步骤。条件块按如下所示的顺序执行。不是必须的，允许在顶级pipeline块和每个stage块中。
```
always
post无论管道或阶段运行的完成状态如何，都运行本部分中的步骤。

changed
post仅当当前管道的运行与之前的运行具有不同的完成状态时才运行中的步骤。

fixed
post仅当当前管道运行成功并且先前运行失败或不稳定时才运行中的步骤。

regression
post仅当当前管道的状态为失败、不稳定或中止并且先前运行成功时才运行中的步骤。

aborted
post仅当当前管道的运行处于“已中止”状态（通常是由于管道被手动中止）时才运行中的步骤。这通常在 Web UI 中用灰色表示。

failure
post仅当当前管道或阶段的运行处于“失败”状态（通常在 Web UI 中用红色表示）时才运行其中的步骤。

success
post仅当当前管道或阶段的运行具有“成功”状态（通常在 Web UI 中以蓝色或绿色表示）时才运行其中的步骤。

unstable
仅当当前管道的运行处于“不稳定”状态（通常是由测试失败、代码违规等引起）时才运行中的步骤post。这通常在 Web UI 中用黄色表示。

unsuccessful
post仅当当前管道或阶段的运行没有“成功”状态时才运行其中的步骤。这通常在 Web UI 中表示，具体取决于前面提到的状态（对于阶段，如果构建本身不稳定，则可能会触发）。

cleanup
在评估post所有其他条件后，运行此条件下的步骤，无论管道或阶段的状态如何。
```

语法：
```groovy 
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
    post {
        always {
            echo 'I will always say Hello again!'
        }
    }
}
```

#### stages
该部分包含一个或多个stage指令，stages至少包含一个stage指令。是必须的，允许在pipeline或stage

语法：
```
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### steps
该部分定义了一个或多个指令步骤。是必须的，允许在每个stage中
```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### enviornment
该指令指定了一系列键值对，这些键值对将被定义为所有步骤或特定于某个stage的环境变量，取决该指令在pipeline中的位置，该指令支持一种特殊的帮助程序方法credentials()，可用于通过 Jenkins 环境中的标识符来访问预定义的凭据。不是必须的，允许在pipeline块内或stage指令内。

支持凭证类型：
```
Secret Text
指定的环境变量将设置为秘密文本内容。

Secret File
指定的环境变量将设置为临时创建的 File 文件的位置。

Username and password
指定的环境变量将设置为username:password，并且将自动定义两个附加环境变量：MYVARNAME_USR和MYVARNAME_PSW。

SSH with Private Key
指定的环境变量将设置为临时创建的 SSH 密钥文件的位置，并且将自动定义两个附加环境变量：MYVARNAME_USR和MYVARNAME_PSW（保存密码）。

不支持的凭据类型会导致管道失败
```

语法：
```groovy
// secret text
pipeline {
    agent any
    environment {
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment {
                AN_ACCESS_KEY = credentials('my-predefined-secret-text')
            }
            steps {
                sh 'printenv'
            }
        }
    }
}

// username and password
pipeline {
    agent any
    stages {
        stage('Example Username/Password') {
            environment {
                SERVICE_CREDS = credentials('my-predefined-username-password')
            }
            steps {
                sh 'echo "Service user is $SERVICE_CREDS_USR"'
                sh 'echo "Service password is $SERVICE_CREDS_PSW"'
                sh 'curl -u $SERVICE_CREDS https://myservice.example.com'
            }
        }
        stage('Example SSH Username with private key') {
            environment {
                SSH_CREDS = credentials('my-predefined-ssh-creds')
            }
            steps {
                sh 'echo "SSH private key is located at $SSH_CREDS"'
                sh 'echo "SSH user is $SSH_CREDS_USR"'
                sh 'echo "SSH passphrase is $SSH_CREDS_PSW"'
            }
        }
    }
}
```

#### options
该options指令允许从管道本身配置特定于管道的选项。Pipeline 提供了许多这样的选项，例如buildDiscarder，但它们也可以由插件提供，例如timestamps。不是必须的，允许在pipeline或在stage指令内（有限制）

可用options：
```
buildDiscarder
Persist artifacts and console output for the specific number of recent Pipeline runs. For example: options { buildDiscarder(logRotator(numToKeepStr: '1')) }

checkoutToSubdirectory
Perform the automatic source control checkout in a subdirectory of the workspace. For example: options { checkoutToSubdirectory('foo') }

disableConcurrentBuilds
Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources, etc. For example: options { disableConcurrentBuilds() } to queue a build when there’s already an executing build of the Pipeline, or options { disableConcurrentBuilds(abortPrevious: true) } to abort the running one and start the new build.

disableResume
Do not allow the pipeline to resume if the controller restarts. For example: options { disableResume() }

newContainerPerStage
Used with docker or dockerfile top-level agent. When specified, each stage will run in a new container instance on the same node, rather than all stages running in the same container instance.

overrideIndexTriggers
Allows overriding default treatment of branch indexing triggers. If branch indexing triggers are disabled at the multibranch or organization label, options { overrideIndexTriggers(true) } will enable them for this job only. Otherwise, options { overrideIndexTriggers(false) } will disable branch indexing triggers for this job only.

preserveStashes
Preserve stashes from completed builds, for use with stage restarting. For example: options { preserveStashes() } to preserve the stashes from the most recent completed build, or options { preserveStashes(buildCount: 5) } to preserve the stashes from the five most recent completed builds.

quietPeriod
Set the quiet period, in seconds, for the Pipeline, overriding the global default. For example: options { quietPeriod(30) }

retry
On failure, retry the entire Pipeline the specified number of times. For example: options { retry(3) }

skipDefaultCheckout
Skip checking out code from source control by default in the agent directive. For example: options { skipDefaultCheckout() }

skipStagesAfterUnstable
Skip stages once the build status has gone to UNSTABLE. For example: options { skipStagesAfterUnstable() }

timeout
Set a timeout period for the Pipeline run, after which Jenkins should abort the Pipeline. For example: options { timeout(time: 1, unit: 'HOURS') }

timestamps
Prepend all console output generated by the Pipeline run with the time at which the line was emitted. For example: options { timestamps() }

parallelsAlwaysFailFast
Set failfast true for all subsequent parallel stages in the pipeline. For example: options { parallelsAlwaysFailFast() }

disableRestartFromStage
Completely disable option "Restart From Stage" visible in classic Jenkins UI and Blue Ocean as well. For example: options { disableRestartFromStage() }. This option can not be used inside of the stage.
```

stage options
```
与声明式pipeline中根options相识，但是stage-level options只能包含retry、timeout或timestamps，或者与stage相关的声明选项，如skipDefaultCheckout

在stage内部中，options会在进入agent或检查when之前执行

skipDefaultCheckout
Skip checking out code from source control by default in the agent directive. For example: options { skipDefaultCheckout() }

retry
On failure, retry this stage the specified number of times. For example: options { retry(3) }
```

#### parameters
该parameters指令提供了用户在触发管道时应提供的参数列表。这些用户指定参数的值可通过params对象提供给管道步骤。每个参数都有一个Name和Value，具体取决于参数类型。当构建开始时，此信息将导出为环境变量，从而允许构建配置的后续部分访问这些值。如使用`${PARAMETER_NAME}`在bash中访问。不是必须的，允许在pipeline中且只有一次

可选参数：
```
string
A parameter of a string type, for example: parameters { string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '') }.

text
A text parameter, which can contain multiple lines, for example: parameters { text(name: 'DEPLOY_TEXT', defaultValue: 'One\nTwo\nThree\n', description: '') }.

booleanParam
A boolean parameter, for example: parameters { booleanParam(name: 'DEBUG_BUILD', defaultValue: true, description: '') }.

choice
A choice parameter, for example: parameters { choice(name: 'CHOICES', choices: ['one', 'two', 'three'], description: '') }. The first value is the default.

password
A password parameter, for example: parameters { password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'A secret password') }.
```

语法：
```groovy
pipeline {
    agent any
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    }
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"

                echo "Biography: ${params.BIOGRAPHY}"

                echo "Toggle: ${params.TOGGLE}"

                echo "Choice: ${params.CHOICE}"

                echo "Password: ${params.PASSWORD}"
            }
        }
    }
}
```

#### trigger
该triggers指令定义了重新触发管道的自动方式。对于与 GitHub 或 BitBucket 等源集成的管道，triggers可能没有必要，因为基于 Webhooks 的集成可能已经存在。当前可用的触发器有cron、pollSCM和upstream。不是必须的，允许在pipeline中且只有一次

cron
接受 cron 样式的字符串来定义重新触发 Pipeline 的定期间隔，例如：`triggers { cron('H */4 * * 1-5') }`

pollSCM
接受 cron 样式字符串来定义 Jenkins 应检查新源更改的定期间隔。如果存在新的更改，将重新触发 Pipeline。例如：`triggers { pollSCM('H */4 * * 1-5') }`。该pollSCM触发器仅在 Jenkins 2.22 或更高版本中可用。

upstream
接受以逗号分隔的作业字符串和阈值。当字符串中的任何作业以最小阈值完成时，管道将被重新触发。例如：`triggers { upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS) }`

语法：
```groovy
// Declarative //
pipeline {
    agent any
    triggers {
        cron('H */4 * * 1-5')
    }
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### jenkins cron syntax
jenkins cron语法遵循unix-like cron（有细微差异）具体来说，每行由 5 个由 TAB 或空格分隔的字段组成：
```
Minutes within the hour (0–59)

The hour of the day (0–23)

The day of the month (1–31)

The month (1–12)

The day of the week (0–7) where 0 and 7 are Sunday.

要为一个字段指定多个值，可以使用以下运算符。按照优先顺序，

*指定所有有效值

M-N指定值的范围

M-N/X或按指定范围或整个有效范围*/X的间隔步进X

A,B,…,Z枚举多个值

为了允许定期计划的任务在系统上产生均匀的负载，H应尽可能使用符号（“哈希”）。例如，用于0 0 * * *十几个日常工作将导致午夜出现大幅峰值。相比之下，使用H H * * *仍然会每天执行每个作业一次，但不是同时执行所有作业，更好地利用有限的资源。

该H符号可以被认为是一定范围内的随机值，但它实际上是作业名称的哈希值，而不是随机函数，因此该值对于任何给定项目都保持稳定。
```

#### stage
该stage指令位于该stages部分中，并且应包含步骤部分、可选agent部分或其他特定于阶段的指令。实际上，管道完成的所有实际工作都将包含在一个或多个stage指令中。是必须的，有一个强制的字符串参数，作为阶段名称，允许在stages中

语法：
```
// Declarative //
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

#### tools
定义自动安装并放在 PATH 上的工具的部分。如果未指定代理，则忽略此选项。不是必须的，允许在pipelin或stage中

支持的工具有：maven、jdk、gradle

语法：
```groovy
pipeline {
    agent any
    tools {
        // 工具名称必须在 Jenkins 中的“管理 Jenkins → 工具”下预先配置。
        maven 'apache-maven-3.0.1'
    }
    stages {
        stage('Example') {
            steps {
                sh 'mvn --version'
            }
        }
    }
}
```

#### input
input在stage当中，允许你按提示输入。stage在options之后，agent和when之前暂停，如果input被通过，stage将继续执行，作为输入提交的一部分提供的任何参数都将在该阶段的其余部分的环境中可用。

配置选项：
```
message
Required. This will be presented to the user when they go to submit the input.

id
An optional identifier for this input. The default value is based on the stage name.

ok
Optional text for the "ok" button on the input form.

submitter
An optional comma-separated list of users or external group names who are allowed to submit this input. Defaults to allowing any user.

submitterParameter
An optional name of an environment variable to set with the submitter name, if present.

parameters
An optional list of parameters to prompt the submitter to provide. Refer to parameters for more information.
```

语法：
```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo "Hello, ${PERSON}, nice to meet you."
            }
        }
    }
}
```

#### when
该when指令允许管道根据给定条件确定是否应执行该阶段。该when指令必须至少包含一个条件。如果when指令包含多个条件，则所有子条件都必须返回 true 才能执行该阶段。这与子条件嵌套在条件中相同allOf（请参阅下面的示例）。如果anyOf使用条件，请注意，一旦找到第一个“真”条件，该条件就会跳过剩余的测试。可以使用嵌套条件构建更复杂的条件结构：not、allOf或anyOf。嵌套条件可以嵌套到任意深度。不是必须的，允许在stage中

内置条件：
```
branch
当前正在构建的分支与给定的分支模式匹配时，执行该阶段，例如：when { branch 'master' }。仅适用多分支管道

buildingTag
当构建正在构建标签时执行该阶段。例如：when { buildingTag() }

changelog
如果构建的 SCM 变更日志包含给定的正则表达式模式，则执行该阶段，例如：when { changelog '.*^\\[DEPENDENCY\\] .+$' }。

changeset
如果构建的 SCM 变更集包含一个或多个与给定模式匹配的文件，则执行该阶段。例子：when { changeset "**/*.js" }

changeRequest
如果当前构建用于“更改请求”（也称为 GitHub 和 Bitbucket 上的拉取请求、GitLab 上的合并请求、Gerrit 中的更改等），则执行该阶段。当没有传递参数时，该阶段会在每个更改请求上运行，例如：when { changeRequest() }。

environment
当指定的环境变量设置为给定值时执行该阶段，例如：when { environment name: 'DEPLOY_TO', value: 'production' }。

equals
当期望值等于实际值时执行该阶段，例如：when { equals expected: 2, actual: currentBuild.number }。

expression
当指定的 Groovy 表达式计算结果为 true 时执行该阶段，例如：when { expression { return params.DEBUG_BUILD } }。从表达式返回字符串时，必须将它们转换为布尔值或返回null以计算为 false。简单地返回“0”或“false”仍将计算为“true”。

tag
TAG_NAME如果变量与给定模式匹配，则执行该阶段。例如：when { tag "release-*" } 如果提供了空模式，则该阶段将在TAG_NAME变量存在时执行（与 相同buildingTag()）。

not
当嵌套条件为 false 时执行该阶段。必须包含一个条件。例如：when { not { branch 'master' } }

allOf
当所有嵌套条件都为真时执行该阶段。必须至少包含一个条件。例如：when { allOf { branch 'master'; environment name: 'DEPLOY_TO', value: 'production' } }

anyOf
当至少一个嵌套条件为真时执行该阶段。必须至少包含一个条件。例如：when { anyOf { branch 'master'; branch 'staging' } }

triggeredBy
当给定的参数触发当前构建时执行该阶段。例如：

when { triggeredBy 'SCMTrigger' }

when { triggeredBy 'TimerTrigger' }

when { triggeredBy 'BuildUpstreamCause' }

when { triggeredBy cause: "UserIdCause", detail: "vlinde" }

beforeAgent
在agent之前执行when

beforeInput
在input之前执行when

beforeOptions
在options之前执行when

beforeOptions true优先于beforeInput true和beforeAgent true
```

语法：
```groovy
pipeline {
    agent none
    stages {
        stage('Example Build') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Example Deploy') {
            agent {
                label "some-label"
            }
            when {
                beforeAgent true
                branch 'production'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

#### sequential stages
声明式管道中的stage可能有一个stages部分，其中包含要按顺序运行的嵌套stage列表。

一个stage必须有且只有一个steps、stages、parallel或matrix。如果指令嵌套在parallel或matrix块本身中，则不可能在stage指令中嵌套parallel或matrix。但是，parallel或matrix中的stage指令可以使用stage的所有功能，包括agent、tools、when等

语法：
```groovy 
pipeline {
    agent none
    stages {
        stage('Non-Sequential Stage') {
            agent {
                label 'for-non-sequential'
            }
            steps {
                echo "On Non-Sequential Stage"
            }
        }
        stage('Sequential') {
            agent {
                label 'for-sequential'
            }
            environment {
                FOR_SEQUENTIAL = "some-value"
            }
            stages {
                stage('In Sequential 1') {
                    steps {
                        echo "In Sequential 1"
                    }
                }
                stage('In Sequential 2') {
                    steps {
                        echo "In Sequential 2"
                    }
                }
                stage('Parallel In Sequential') {
                    parallel {
                        stage('In Parallel 1') {
                            steps {
                                echo "In Parallel 1"
                            }
                        }
                        stage('In Parallel 2') {
                            steps {
                                echo "In Parallel 2"
                            }
                        }
                    }
                }
            }
        }
    }
}
```

#### parallel
声明式管道中的stage可能有一个parallel部分，其中包含要并行运行的嵌套stage列表

此外，你可以通过将failFast true添加到包含parallel的stage，强制所有parallel stages在其中任何一个stage失败时中止。添加failfast的另一个选项式向管道定义添加一个选项：parallelsAlwaysFailFast()

语法：
```groovy
pipeline {
    agent any
    options {
        parallelsAlwaysFailFast()
    }
    stages {
        stage('Non-Parallel Stage') {
            steps {
                echo 'This stage will be executed first.'
            }
        }
        stage('Parallel Stage') {
            when {
                branch 'master'
            }
            parallel {
                stage('Branch A') {
                    agent {
                        label "for-branch-a"
                    }
                    steps {
                        echo "On Branch A"
                    }
                }
                stage('Branch B') {
                    agent {
                        label "for-branch-b"
                    }
                    steps {
                        echo "On Branch B"
                    }
                }
                stage('Branch C') {
                    agent {
                        label "for-branch-c"
                    }
                    stages {
                        stage('Nested 1') {
                            steps {
                                echo "In stage Nested 1 within Branch C"
                            }
                        }
                        stage('Nested 2') {
                            steps {
                                echo "In stage Nested 2 within Branch C"
                            }
                        }
                    }
                }
            }
        }
    }
}
```

#### Matrix
声明式管道中的阶段可能有一个matrix部分定义要并行运行的名称-值组合的多维矩阵。我们将这些组合称为矩阵中的“单元”。矩阵中的每个单元可以包括一个或多个要使用该单元的配置顺序运行的阶段。

matrix部分必须包含一个axes和一个stages，axes部分为每个在matrix中的axis定义了值。stages部分定了每个单元中按顺序运行的stage列表。一个matrix可能有一个排除部分，用于从matrix中删除无效的单元。stage中可用的许多指令，包括agent、tools、when等，也可以添加到matrix中以控制每个单元的行为

##### axes
axes部分指定一个或多个axis指令。每个axis由名称和值列表组成。每个axis的所有值都与其他axis组合以生成单元格。

语法：
```groovy
// One-axis with 3 cells
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
    }
    // ...
}

// Two-axis with 12 cells (three by four)
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
    }
    // ...
}

// Three-axis matrix with 24 cells (three by four by two)
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
        axis {
            name 'ARCHITECTURE'
            values '32-bit', '64-bit'
        }
    }
    // ...
}
```

##### stages
stages部分指定要在每个单元中顺序执行的一个或多个stages。此部分与任何其他stages部分相同

语法：
```groovy
// One-axis with 3 cells, each cell runs three stages - "build", "test", and "deploy"
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
    }
    stages {
        stage('build') {
            // ...
        }
        stage('test') {
            // ...
        }
        stage('deploy') {
            // ...
        }
    }
}

// Two-axis with 12 cells (three by four)
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
    }
    stages {
        stage('build-and-test') {
            // ...
        }
    }
}

```

##### excludes (optional)
可选excludes部分允许作者指定一个或多个exclude过滤表达式，用于选择要从扩展的矩阵单元集中排除的单元（也称为稀疏）。过滤器是使用一个或多个排除指令的基本指令结构构造的，axis每个排除指令都带有一个name和values列表。

axis内部的指令生成exclude一组组合（类似于生成矩阵单元）。与组合中所有值匹配的矩阵单元exclude将从矩阵中删除。如果提供了多个exclude指令，则分别评估每个指令以删除单元格。

当处理一长串要排除的值时，排除axis指令可以使用notValues代替values。这些将排除与传递给 的值之一不notValues匹配的单元格。

语法：
```groovy
// Three-axis matrix with 24 cells, exclude '32-bit, mac' (4 cells excluded)
matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'edge', 'firefox', 'safari'
        }
        axis {
            name 'ARCHITECTURE'
            values '32-bit', '64-bit'
        }
    }
    excludes {
        exclude {
            axis {
                name 'PLATFORM'
                values 'mac'
            }
            axis {
                name 'ARCHITECTURE'
                values '32-bit'
            }
        }
    }
    // ...
}
```
排除linux, safari组合并排除任何不随 windows浏览edge器提供的平台。

##### Matrix cell-level directives (optional)
Matrix 允许用户通过在其自身下添加阶段级指令来有效地配置每个单元的整体环境matrix。这些指令的行为与在舞台上的行为相同，但它们也可以接受矩阵为每个单元提供的值。

和axis指令exclude定义组成矩阵的静态单元集。该组组合是在管道运行开始之前生成的。另一方面，“每单元”指令是在运行时评估的。

这些指令包括：
agent

environment

input

options

post

tools

when

语法：
```groovy
// Complete Matrix Example, Declarative Pipeline
pipeline {
    parameters {
        choice(name: 'PLATFORM_FILTER', choices: ['all', 'linux', 'windows', 'mac'], description: 'Run on specific platform')
    }
    agent none
    stages {
        stage('BuildAndTest') {
            matrix {
                agent {
                    label "${PLATFORM}-agent"
                }
                when { anyOf {
                    expression { params.PLATFORM_FILTER == 'all' }
                    expression { params.PLATFORM_FILTER == env.PLATFORM }
                } }
                axes {
                    axis {
                        name 'PLATFORM'
                        values 'linux', 'windows', 'mac'
                    }
                    axis {
                        name 'BROWSER'
                        values 'firefox', 'chrome', 'safari', 'edge'
                    }
                }
                excludes {
                    exclude {
                        axis {
                            name 'PLATFORM'
                            values 'linux'
                        }
                        axis {
                            name 'BROWSER'
                            values 'safari'
                        }
                    }
                    exclude {
                        axis {
                            name 'PLATFORM'
                            notValues 'windows'
                        }
                        axis {
                            name 'BROWSER'
                            values 'edge'
                        }
                    }
                }
                stages {
                    stage('Build') {
                        steps {
                            echo "Do Build for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                    stage('Test') {
                        steps {
                            echo "Do Test for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                }
            }
        }
    }
}
```

#### step-script
该步骤采用脚本化管道script块并在声明式管道中执行它。对于大多数用例，该步骤在声明性管道中应该是不必要的，但它可以提供有用的“逃生舱口”。 大小和/或复杂性较大的块应移至共享库中。

语法：
```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'

                script {
                    def browsers = ['chrome', 'firefox']
                    for (int i = 0; i < browsers.size(); ++i) {
                        echo "Testing the ${browsers[i]} browser"
                    }
                }
            }
        }
    }
}
```

### 脚本式
脚本化管道与声明式管道一样，构建在底层管道子系统之上。与声明式不同，脚本化管道实际上是使用Groovy构建的通用 DSL [ 1 ]。Groovy 语言提供的大部分功能都可供脚本管道的用户使用，这意味着它可以是一种非常具有表现力和灵活的工具，人们可以用它来编写持续交付管道。脚本化管道不需要steps块

语法：
```groovy
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

// if语句
node {
    stage('Example') {
        if (env.BRANCH_NAME == 'master') {
            echo 'I only execute on the master branch'
        } else {
            echo 'I execute elsewhere'
        }
    }
}

// 管理脚本化管道流控制的另一种方法是使用 Groovy 的异常处理支持。当步骤由于某种原因失败时，它们会抛出异常。处理错误行为必须使用try/catch/finallyGroovy 中的块，例如：
node {
    stage('Example') {
        try {
            sh 'exit 1'
        }
        catch (exc) {
            echo 'Something failed, I should sound the klaxons!'
            throw
        }
    }
}
```

#### 声明式和脚本式语法的差异
脚本化管道为 Jenkins 用户提供了巨大的灵活性和可扩展性。Groovy 学习曲线通常并不适合给定团队的所有成员，因此创建声明式管道是为了为编写 Jenkins 管道提供更简单、更自以为是的语法。

两者本质上是相同的管道子系统。它们都是“管道即代码”的持久实现。它们都可以使用 Pipeline 中内置的步骤或插件提供的步骤。两者都能够利用共享库

然而它们的不同之处在于语法和灵活性。声明式通过更严格和预定义的结构限制了用户可用的内容，使其成为更简单的连续交付管道的理想选择。脚本化提供的限制非常少，结构和语法的唯一限制往往是由 Groovy 本身定义，而不是任何特定于管道的系统，这使其成为高级用户和具有更复杂需求的用户的理想选择。顾名思义，声明式管道鼓励声明式编程模型。 [ 2 ] 而脚本化管道遵循更命令式的编程模型。 


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

## 坑?
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
