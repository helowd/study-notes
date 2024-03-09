# groovy语法

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
    * [特性](#特性)
    * [helloworld](#helloworld)
* [与java的不同](#与java的不同)
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
      println('Hello World', x); 
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
