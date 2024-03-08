# java语法

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
    * [安装](#安装)
* [基本概念](#基本概念)
* [命名](#命名)
* [注释](#注释)
* [变量和数据类型](#变量和数据类型)
    * [变量声明示例：](#变量声明示例)
    * [基本数据类型](#基本数据类型)
    * [引用类型](#引用类型)
        * [字符串](#字符串)
        * [空值null](#空值null)
        * [数组](#数组)
            * [命令行参数](#命令行参数)
    * [var关键字](#var关键字)
    * [其他类型](#其他类型)
    * [强类型弱类型，动态语言静态语言](#强类型弱类型动态语言静态语言)
* [运算](#运算)
    * [算数运算符](#算数运算符)
    * [关系运算符](#关系运算符)
    * [逻辑运算符](#逻辑运算符)
    * [位运算](#位运算)
* [输入和输出](#输入和输出)
    * [输出](#输出)
        * [格式化输出](#格式化输出)
    * [输入](#输入)
* [if else](#if-else)
* [switch case](#switch-case)
* [循环](#循环)
    * [while](#while)
    * [do...while](#dowhile)
* [修饰符](#修饰符)
    * [访问修饰符](#访问修饰符)
    * [非访问修饰符](#非访问修饰符)
* [异常处理](#异常处理)
* [继承](#继承)
* [包](#包)
    * [包的作用域](#包的作用域)
    * [import](#import)
    * [java文件编译顺序](#java文件编译顺序)
    * [最佳实践](#最佳实践)
        * [编译和运行](#编译和运行)

<!-- vim-markdown-toc -->

## 简介
Java 是由 Sun Microsystems 公司于 1995 年 5 月推出的高级程序设计语言。常用来开发android app。javac用来编译源码生成字节码，java用来运行字节码文件，解释型的强类型静态语言，语句用分号结束

从互联网到企业平台，Java是应用最广泛的编程语言，原因在于：

Java是基于JVM虚拟机的跨平台语言，一次编写，到处运行；

Java程序易于编写，而且有内置垃圾收集，不必考虑内存管理；

Java虚拟机拥有工业级的稳定性和高度优化的性能，且经过了长时期的考验；

Java拥有最广泛的开源社区支持，各种高质量组件随时可用。

Java语言常年霸占着三大市场：

互联网和企业应用，这是Java EE的长期优势和市场地位；

大数据平台，主要有Hadoop、Spark、Flink等，他们都是Java或Scala（一种运行于JVM的编程语言）开发的；

Android移动平台。

helloworld：
```java
// HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}

// 执行javac HelloWorld.java（或者javac -encoding UTF-8 HelloWorld.java ）
// 会在当前目录下生成HelloWorld.class文件
// 执行java HelloWorld，打印"Hello World"
```

### 安装
1. 从oracle官网下载稳定版jdk
2. 设置环境变量JAVA_HOME（指向jdk的安装目录）和PATH
3. 如果java -version输出的不是指定版本，说明系统存在多个jdk，需要把当前安装jdk版本路径放到PATH之前

jdk：
```
Java Development Kit（JDK）是Sun微系统针对Java开发人员发布的免费软件开发工具包（SDK，Software development kit）。自从Java推出以来，JDK已经成为使用最广泛的Java SDK。由于JDK的一部分特性采用商业许可证，而非开源[2]。因此，2006年Sun微系统宣布将发布基于GPL的开源JDK，使JDK成为自由软件。在去掉了少量闭源特性之后，Sun微系统最终促成了GPL的OpenJDK的发布。sun已经被oracle收购

作为Java语言的SDK，普通用户并不需要安装JDK来运行Java程序，而只需要安装JRE（Java Runtime Environment）。而程序开发者必须安装JDK来编译、调试程序。

JDK包含了一批用于Java开发的组件，其中包括：

javac：编译器，将后缀名为.java的源代码编译成后缀名为“.class”的字节码
java：运行工具，运行.class的字节码
jar：打包工具，将相关的类文件打包成一个文件（.jar），便于发布
javadoc：文档生成器，从源码注释中提取文档，注释需符合规范
jdb debugger：调试工具
jps：显示当前java程序运行的进程状态
javap：反编译程序
appletviewer：运行和调试applet程序的工具，不需要使用浏览器
javah：从Java类生成C头文件和C源文件。这些文件提供了连接胶合，使Java和C代码可进行交互。[3]
javaws：运行JNLP程序
extcheck：一个检测jar包冲突的工具
apt：注释处理工具[4]
jhat：java堆分析工具
jstack：栈跟踪程序
jstat：JVM检测统计工具
jstatd：jstat守护进程
jinfo：获取正在运行或崩溃的java程序配置信息
jmap：获取java进程内存映射信息
idlj：IDL-to-Java编译器。将IDL语言转化为java文件[5]
policytool：一个GUI的策略文件创建和管理工具
jrunscript：命令行脚本运行
JDK中还包括完整的JRE（Java Runtime Environment），Java运行环境，也被称为private runtime。包括了用于产品环境的各种库类，如基础类库rt.jar，以及给开发人员使用的补充库，如国际化与本地化的类库、IDL库等等。

JDK中还包括各种样例程序，用以展示Java API中的各部分。
```

jvm：
```
Java虚拟机（英语：Java Virtual Machine，缩写：JVM），一种能够执行Java字节码的虚拟机，以堆栈结构机器来实现。最早由Sun微系统所研发并实现第一个实现版本，是Java平台的一部分，能够执行以Java语言写作的软件程序。

Java虚拟机有自己完善的硬件架构，如处理器、堆栈、寄存器等，还具有相应的指令系统。JVM屏蔽了与具体操作系统平台相关的信息，使得Java程序只需生成在Java虚拟机上运行的目标代码（字节码），就可以在多种平台上不加修改地运行。通过对中央处理器（CPU）所执行的软件实现，实现能执行编译过的Java程序码（Applet与应用程序）。

作为一种编程语言的虚拟机，实际上不只是专用于Java语言，只要生成的编译文件符合JVM对加载编译文件格式要求，任何语言都可以由JVM编译运行。此外，除了甲骨文公司提供的Java虚拟机，也有其他开源或闭源的实现。
```

## 基本概念
一个 Java 程序可以认为是一系列对象的集合，而这些对象通过调用彼此的方法来协同工作。

* 对象：对象是类的一个实例，有状态和行为。例如，一条狗是一个对象，它的状态有：颜色、名字、品种；行为有：摇尾巴、叫、吃等。
* 类：类是一个模板，它描述一类对象的行为和状态。
* 方法：方法就是行为，一个类可以有很多方法。逻辑运算、数据修改以及所有动作都是在方法中完成的。
* 实例变量：每个对象都有独特的实例变量，对象的状态由这些实例变量的值决定。

基本格式解释：
![](./syntax_explain.jpg)

## 命名
大小写敏感：Java 是大小写敏感的，这就意味着标识符 Hello 与 hello 是不同的。
* 类名：大驼峰，对于所有的类来说，类名的首字母应该大写。如果类名由若干单词组成，那么每个单词的首字母应该大写，例如 MyFirstJavaClass 。
* 变量和方法名：小驼峰，所有的方法名都应该以小写字母开头。如果方法名含有若干单词，则后面的每个单词首字母大写。
* 源文件名：源文件名必须和类名相同。当保存文件的时候，你应该使用类名作为文件名保存（切记 Java 是大小写敏感的），文件名的后缀为 .java。（如果文件名和类名不相同则会导致编译错误）。
* 主方法入口：所有的 Java 程序由 public static void main(String[] args) 方法开始执行。
* 包名：所有字母小写

## 注释
```java
/**
 * 可以用来自动创建文档的注释
 */
public class HelloWorld {
   /* 这是第一个Java程序
    * 它将输出 Hello World
    * 这是一个多行注释的示例
    */
    public static void main(String[] args){
       // 这是单行注释的示例
       /* 这个也是单行注释的示例 */
       System.out.println("Hello World"); 
    }
}
```

## 变量和数据类型 
java中变量分为两种：基本类型变量和引用类型变量  
java中变量需要先声明后使用，也需要被初始化 

### 变量声明示例：
```java
int a, b, c;         // 声明三个int型整数：a、 b、c
int d = 3, e = 4, f = 5; // 声明三个整数并赋予初值
byte z = 22;         // 声明并初始化 z
String s = "runoob";  // 声明并初始化字符串 s
double pi = 3.14159; // 声明了双精度浮点型变量 pi
final double PI = 3.14; // PI是一个常量
char x = 'x';        // 声明变量 x 的值是字符 'x'。
double[] myList = new double[d]; // 声明数组，长度为ｄ
double[] myList = {1.9, 2.9, 3.4, 3.5};　// 声明数组并赋值
String[][] str = new String[3][4];  //　声明二维数组
```

### 基本数据类型
基本数据类型是CPU可以直接进行运算的类型。Java定义了以下几种基本数据类型：
整数类型：byte，short，int，long  
浮点数类型：float，double  
字符类型：char  
布尔类型：boolean  

### 引用类型
除了上述基本类型的变量，剩下的都是引用类型。例如，引用类型最常用的就是String字符串，引用类型的变量类似于C语言的指针，它内部存储一个“地址”，指向某个对象在内存的位置

#### 字符串
java中加号+用来连接任意字符串和其它数据类型，其它数据类型会自动转为字符串再连接，从java13开始字符串可以用"""..."""来表示多行字符串
```java
public class Main {
    public static void main(String[] args) {
        String s = """
                   SELECT * FROM
                     users
                   WHERE id > 100
                   ORDER BY name DESC
                   """;
        System.out.println(s);
    }
}

// 多行字符串前面共同的空格会被去掉，总是以最短的行首空格为基准
String s = """
...........SELECT * FROM
...........  users
...........WHERE id > 100
...........ORDER BY name DESC
...........""";
```

#### 空值null
引用类型的变量可以指向一个空值null，它表示不存在，即该变量不指向任何对象。例如：
```java
String s1 = null; // s1是null
String s2 = s1; // s2也是null
String s3 = ""; // s3指向空字符串，不是null
```
注意要区分空值null和空字符串""，空字符串是一个有效的字符串对象，它不等于null。

#### 数组
数组所有元素初始化为默认值，整型都是0，浮点型是0.0，布尔型是false；  
数组一旦创建后，大小就不可改变。

##### 命令行参数
java程序的入口是main方法，而main方法可以接受一个命令行参数，它是一个String[]数组。这个命令行参数由JVM接收用户输入并传给main方法：
```java
public class Main {
    public static void main(String[] args) {
        for (String arg : args) {
            System.out.println(arg);
        }
    }
}
```

利用接收到的命令行参数，根据不同的参数执行不同的代码，-version参数，打印程序版本号：
```java
public class Main {
    public static void main(String[] args) {
        for (String arg : args) {
            if ("-version".equals(arg)) {
                System.out.println("v 1.0");
                break;
            }
        }
    }
}

// 必须在命令行执行
// java Main -version
// v 1.0
```

### var关键字
var关键字只能用于局部变量的声明，不能用于成员变量、方法参数、方法返回类型等其它地方
```
有些时候，类型的名字太长，写起来比较麻烦。例如:
StringBuilder sb = new StringBuilder();

这个时候，如果想省略变量类型，可以使用var关键字：
var sb = new StringBuilder();

编译器会根据赋值语句自动推断出变量sb的类型是StringBuilder。对编译器来说，语句：
var sb = new StringBuilder();

实际上会自动变成：
StringBuilder sb = new StringBuilder();

因此，使用var定义变量，仅仅是少写了变量类型而已。

var x = 10; // 编译器推断 x 的类型为 int
var str = "Hello"; // 编译器推断 str 的类型为 String
```

### 其他类型
```java
public class RunoobTest {
    // 成员变量
    private int instanceVar;
    // 静态变量
    private static int staticVar;
    
    public void method(int paramVar) {
        // 局部变量
        int localVar = 10;
        
        // 使用变量
        instanceVar = localVar;
        staticVar = paramVar;
        
        System.out.println("成员变量: " + instanceVar);
        System.out.println("静态变量: " + staticVar);
        System.out.println("参数变量: " + paramVar);
        System.out.println("局部变量: " + localVar);
    }
    
    // 入口
    public static void main(String[] args) {
        RunoobTest v = new RunoobTest();
        v.method(20);
    }
}
```

### 强类型弱类型，动态语言静态语言  
![](./language_type.jpeg)

## 运算 
如果参与运算的两个数其中一个是整型，那么整型可以自动提升到浮点型

###  算数运算符
```java
public class Test {
 
  public static void main(String[] args) {
     int a = 10;
     int b = 20;
     int c = 25;
     int d = 25;
     System.out.println("a + b = " + (a + b) );
     System.out.println("a - b = " + (a - b) );
     System.out.println("a * b = " + (a * b) );
     System.out.println("b / a = " + (b / a) );
     System.out.println("b % a = " + (b % a) );
     System.out.println("c % a = " + (c % a) );
     System.out.println("a++   = " +  (a++) );
     System.out.println("a--   = " +  (a--) );
     // 查看  d++ 与 ++d 的不同
     System.out.println("d++   = " +  (d++) );
     System.out.println("++d   = " +  (++d) );
  }
}

/* 输出
a + b = 30
a - b = -10
a * b = 200
b / a = 2
b % a = 0
c % a = 5
a++   = 10
a--   = 11
d++   = 25
++d   = 27 
*/
```

### 关系运算符
```java
public class Test {
 
  public static void main(String[] args) {
     int a = 10;
     int b = 20;
     System.out.println("a == b = " + (a == b) );
     System.out.println("a != b = " + (a != b) );
     System.out.println("a > b = " + (a > b) );
     System.out.println("a < b = " + (a < b) );
     System.out.println("b >= a = " + (b >= a) );
     System.out.println("b <= a = " + (b <= a) );
  }
}

/* 输出
a == b = false
a != b = true
a > b = false
a < b = true
b >= a = true
b <= a = false
*/
```

### 逻辑运算符
```java
public class Test {
  public static void main(String[] args) {
     boolean a = true;
     boolean b = false;
     System.out.println("a && b = " + (a&&b));
     System.out.println("a || b = " + (a||b) );
     System.out.println("!(a && b) = " + !(a && b));
  }
}

/* 输出
a && b = false
a || b = true
!(a && b) = true
*/

// 三元运算符：int x = n >= 0 ? n : -n;
```

### 位运算
pass

## 输入和输出

### 输出
```java
public class Main {
    public static void main(String[] args) {
        System.out.print("A,");
        System.out.print("B,");
        System.out.print("C.");  // 输出不换行
        System.out.println();  // 输出并换行
        System.out.println("END");
    }
}
```

#### 格式化输出
格式化输出使用System.out.printf()
```java
public class Main {
    public static void main(String[] args) {
        double d = 3.1415926;
        System.out.printf("%.2f\n", d); // 显示两位小数3.14
        System.out.printf("%.4f\n", d); // 显示4位小数3.1416
    }
}

// 把一个整数格式化成十六进制，并用0补足8位
public class Main {
    public static void main(String[] args) {
        int n = 12345000;
        System.out.printf("n=%d, hex=%08x", n, n); // 注意，两个%占位符必须传入两个数
    }
}
```

### 输入
从控制台读取一个字符串和一个整数
```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in); // 创建Scanner对象
        System.out.print("Input your name: "); // 打印提示
        String name = scanner.nextLine(); // 读取一行输入并获取字符串
        System.out.print("Input your age: "); // 打印提示
        int age = scanner.nextInt(); // 读取一行输入并获取整数
        System.out.printf("Hi, %s, you are %d\n", name, age); // 格式化输出
    }
}
```



## if else 
在Java中，判断值类型的变量是否相等，可以使用==运算符。但是，判断引用类型的变量是否相等，==表示“引用是否相等”，或者说，是否指向同一个对象。例如，下面的两个String类型，它们的内容是相同的，但是，分别指向不同的对象，用==判断，结果为false, 要判断引用类型的变量内容是否相等，必须使用equals()方法
```java
// if
public class Test {
 
   public static void main(String args[]){
      int x = 10;
 
      if (x < 20) {
         System.out.print("这是 if 语句");
      }
   }
}

// if...else
public class Test {
 
   public static void main(String args[]){
      int x = 30;
 
      if (x < 20) {
         System.out.print("这是 if 语句");
      } else {
         System.out.print("这是 else 语句");
      }
   }
}

//if...else if...else
public class Test {
   public static void main(String args[]){
      int x = 30;
 
      if (x == 10) {
         System.out.print("Value of X is 10");
      } else if (x == 20) {
         System.out.print("Value of X is 20");
      } else if (x == 30) {
         System.out.print("Value of X is 30");
      } else {
         System.out.print("这是 else 语句");
      }
   }
}

// 嵌套if...else
public class Test {
 
   public static void main(String args[]){
      int x = 30;
      int y = 10;
 
      if (x == 30) {
         if (y == 10) {
             System.out.print("X = 30 and Y = 10");
          }
       }
    }
}
```

## switch case
switch语句中的变量可以是：byte、short、int 或者 char
```java
public class Test {
   public static void main(String args[]) {
      //char grade = args[0].charAt(0);
      char grade = 'C';
 
      switch (grade) {
         case 'A':
            System.out.println("优秀"); 
            break;
         case 'B':
         case 'C': 
            System.out.println("良好");
            break;
         case 'D':
            System.out.println("及格");
            break;
         case 'F':
            System.out.println("你需要再努力努力");
            break;
         default:
            System.out.println("未知等级");
      }
      System.out.println("你的等级是 " + grade);
   }
}

/* 输出
良好
你的等级是 C
*/
```

## 循环

### while
```java
public class Test {
   public static void main(String[] args) {
      int x = 10;
      while(x < 20) {
         System.out.print("value of x : " + x );
         x++;
         System.out.print("\n");
      }
   }
}
```
### do...while
```java
public class Test {
   public static void main(String[] args){
      int x = 10;
 
      do {
         System.out.print("value of x : " + x );
         x++;
         System.out.print("\n");
      } while(x < 20);
   }
}
```
3. for
```java
public class Test {
   public static void main(String[] args) {
 
      for (int x=10; x<20; x=x+1) {
         System.out.print("value of x : " + x );
         System.out.print("\n");
      }
   }
}
/* 输出
value of x : 10
value of x : 11
value of x : 12
value of x : 13
value of x : 14
value of x : 15
value of x : 16
value of x : 17
value of x : 18
value of x : 19
*/

// 或 for each
public class Test {
   public static void main(String[] args) {
      int [] numbers = {10, 20, 30, 40, 50};
 
      for (int x : numbers) {
         System.out.print( x );
         System.out.print(",");
      }
      System.out.print("\n");
      String [] names ={"James", "Larry", "Tom", "Lacy"};
      for (String name : names) {
         System.out.print( name );
         System.out.print(",");
      }
   }
}
/*　输出
10,20,30,40,50,
James,Larry,Tom,Lacy,
*/
```

## 修饰符
分为访问修饰符和非访问修饰符，修饰符用来定义类、方法或者变量，通常放在语句的最前端

### 访问修饰符
   * default (即默认，什么也不写）: 在同一包内可见，不使用任何修饰符。使用对象：类、接口、变量、方法。
   * private : 在同一类内可见。使用对象：变量、方法。 注意：不能修饰类（外部类）
   * public : 对所有类可见。使用对象：类、接口、变量、方法
   * protected : 对同一包内的类和所有子类可见。使用对象：变量、方法。 注意：不能修饰类（外部类）。
### 非访问修饰符
   * static 修饰符，用来修饰类方法和类变量。
        ```java
        public class InstanceCounter {
        private static int numInstances = 0;
        protected static int getCount() {
            return numInstances;
        }

        private static void addInstance() {
            numInstances++;
        }

        InstanceCounter() {
            InstanceCounter.addInstance();
        }

        public static void main(String[] arguments) {
            System.out.println("Starting with " +
            InstanceCounter.getCount() + " instances");
            for (int i = 0; i < 500; ++i){
                new InstanceCounter();
                }
            System.out.println("Created " +
            InstanceCounter.getCount() + " instances");
        }
        }
        ```
   * final 修饰符，用来修饰类、方法和变量，final 修饰的类不能够被继承，修饰的方法不能被继承类重新定义，修饰的变量为常量，是不可修改的。
   * abstract 修饰符，用来创建抽象类和抽象方法。
   * synchronized 和 volatile 修饰符，主要用于线程的编程。

## 异常处理
1. 异常捕获try/catch
```java
// 文件名 : ExcepTest.java
import java.io.*;
public class ExcepTest{
 
   public static void main(String args[]){
      try{
         int a[] = new int[2];
         System.out.println("Access element three :" + a[3]);
      }catch(ArrayIndexOutOfBoundsException e){
         System.out.println("Exception thrown  :" + e);
      }
      System.out.println("Out of the block");
   }
}

/* 输出：
Exception thrown  :java.lang.ArrayIndexOutOfBoundsException: 3
Out of the block
*/
```
2. 异常抛出
```java
public void checkNumber(int num) {
  if (num < 0) {
    throw new IllegalArgumentException("Number must be positive");
  }
}
```

3. finally，无论是否发生异常，finally 代码块中的代码总会被执行
```java
public class ExcepTest{
  public static void main(String args[]){
    int a[] = new int[2];
    try{
       System.out.println("Access element three :" + a[3]);
    }catch(ArrayIndexOutOfBoundsException e){
       System.out.println("Exception thrown  :" + e);
    }
    finally{
       a[0] = 6;
       System.out.println("First element value: " +a[0]);
       System.out.println("The finally statement is executed");
    }
  }
}

/* 输出
Exception thrown  :java.lang.ArrayIndexOutOfBoundsException: 3
First element value: 6
The finally statement is executed
*/
```

## 继承
```java
// 公共父类
public class Animal { 
    private String name;  
    private int id; 
    public Animal(String myName, int myid) { 
        name = myName; 
        id = myid;
    } 
    public void eat(){ 
        System.out.println(name+"正在吃"); 
    }
    public void sleep(){
        System.out.println(name+"正在睡");
    }
    public void introduction() { 
        System.out.println("大家好！我是"         + id + "号" + name + "."); 
    } 
}

// 企鹅类
public class Penguin extends Animal { 
    public Penguin(String myName, int myid) { 
        super(myName, myid); 
    } 
}

//　老鼠类
public class Mouse extends Animal { 
    public Mouse(String myName, int myid) { 
        super(myName, myid); 
    } 
}
```
super与this关键字
```java
class Animal {
  void eat() {
    System.out.println("animal : eat");
  }
}
 
class Dog extends Animal {
  void eat() {
    System.out.println("dog : eat");
  }
  void eatTest() {
    this.eat();   // this 调用自己的方法
    super.eat();  // super 调用父类方法
  }
}
 
public class Test {
  public static void main(String[] args) {
    Animal a = new Animal();
    a.eat();
    Dog d = new Dog();
    d.eatTest();
  }
}

/* 输出
animal : eat
dog : eat
animal : eat
*/
```

## 包
在java中，使用package来解决名字冲突，Java定义了一种名字空间，称之为包：package。一个类总是属于某个包，类名（比如Person）只是一个简写，真正的完整类名是包名.类名

在Java虚拟机执行的时候，JVM只看完整类名，因此，只要包名不同，类就不同

要特别注意：包没有父子关系。java.util和java.util.zip是不同的包，两者没有任何继承关系。

在定义class的时候，我们需要在第一行声明这个class属于哪个包
```java
// Person.java文件
package ming; // 申明包名ming

public class Person {
}

// Arrays.jva文件
package mr.jun; // 申明包名mr.jun

public class Arrays {
}
```

没有定义包名的class，它使用的是默认包，非常容易引起名字冲突，因此，不推荐不写包名的做法。

我们还需要按照包结构把上面的Java文件组织起来。假设以package_sample作为根目录，src作为源码目录，那么所有文件结构就是：
```
package_sample
└─ src
    ├─ hong
    │  └─ Person.java
    │  ming
    │  └─ Person.java
    └─ mr
       └─ jun
          └─ Arrays.java
```

即所有Java文件对应的目录层次要和包的层次一致。

编译后的.class文件也需要按照包结构存放。如果使用IDE，把编译后的.class文件放到bin目录下，那么，编译的文件结构就是：
```
package_sample
└─ bin
   ├─ hong
   │  └─ Person.class
   │  ming
   │  └─ Person.class
   └─ mr
      └─ jun
         └─ Arrays.class
```

### 包的作用域
位于同一个包的类，可以访问包作用域的字段和方法。不用public、protected、private修饰的字段和方法就是包作用域。例如，Person类定义在hello包下面：
```java
package hello;

public class Person {
    // 包作用域:
    void hello() {
        System.out.println("Hello!");
    }
}
```
Main类也定义在hello包下面：
```java
package hello;

public class Main {
    public static void main(String[] args) {
        Person p = new Person();
        p.hello(); // 可以调用，因为Main和Person在同一个包
    }
}
```

### import
在一个class中，我们总会引用其他的class。例如，小明的ming.Person类，如果要引用小军的mr.jun.Arrays类，他有三种写法：

1. 直接写出完整类名
```java
// Person.java
package ming;

public class Person {
    public void run() {
        mr.jun.Arrays arrays = new mr.jun.Arrays();
    }
}
```

2. 使用import语句，导入Arrays，然后写简单类名
```java
// Person.java
package ming;

// 导入完整类名:
import mr.jun.Arrays;

public class Person {
    public void run() {
        Arrays arrays = new Arrays();
    }
}
```

3. import static
```java
package main;

// 导入System类的所有静态字段和静态方法:
import static java.lang.System.*;

public class Main {
    public static void main(String[] args) {
        // 相当于调用System.out.println(…)
        out.println("Hello, world!");
    }
}
```

### java文件编译顺序
java编译器最终编译出.class文件只使用完整类名，因此在代码中，当编译器遇到一个class名称时：

如果是完整类名，就直接根据完整类名查找这个class；

如果是简单类名，按下面的顺序依次查找：

查找当前package是否存在这个class；

查找import的包是否包含这个class；

查找java.lang包是否包含这个class。

如果按照上面的规则还无法确定类名，则编译报错。

如果有两个class名称相同，例如，mr.jun.Arrays和java.util.Arrays，那么只能import其中一个，另一个必须写完整类名。

示例：
```java
// Main.java
package test;

import java.text.Format;

public class Main {
    public static void main(String[] args) {
        java.util.List list; // ok，使用完整类名 -> java.util.List
        Format format = null; // ok，使用import的类 -> java.text.Format
        String s = "hi"; // ok，使用java.lang包的String -> java.lang.String
        System.out.println(s); // ok，使用java.lang包的System -> java.lang.System
        MessageFormat mf = null; // 编译错误：无法找到MessageFormat: MessageFormat cannot be resolved to a type
    }
}

// 在编译class的时候，编译器会自动帮我们做两个import动作：

// 默认自动import当前package的其他class；
// 默认自动import java.lang.*。

//  注意：自动导入的是java.lang包，但类似java.lang.reflect这些包仍需要手动导入。
```

### 最佳实践
为了避免名字冲突，我们需要确定唯一的包名。推荐的做法是使用倒置的域名来确保唯一性。例如：
```
org.apache
org.apache.commons.log
com.liaoxuefeng.sample
```
子包就可以根据功能自行命名。

要注意不要和java.lang包的类重名，即自己的类不要使用这些名字：
```
String
System
Runtime
...
```
要注意也不要和JDK常用类重名：
```
java.util.List
java.text.Format
java.math.BigInteger
...
```

#### 编译和运行
假设我们创建了如下的目录结构：
```
work
├── bin
└── src
    └── com
        └── itranswarp
            ├── sample
            │   └── Main.java
            └── world
                └── Person.java
```
其中，bin目录用于存放编译后的class文件，src目录按包结构存放Java源码，我们怎么一次性编译这些Java源码呢？

首先，确保当前目录是work目录，即存放src和bin的父目录：
```
$ ls 
bin src
```

然后，编译src目录下的所有Java文件：
```
$ javac -d ./bin src/**/*.java

命令行-d指定输出的class文件存放bin目录，后面的参数src/**/*.java表示src目录下的所有.java文件，包括任意深度的子目录。
```

如果编译无误，则javac命令没有任何输出。可以在bin目录下看到如下class文件：
```
bin
└── com
    └── itranswarp
        ├── sample
        │   └── Main.class
        └── world
            └── Person.class
```

现在，我们就可以直接运行class文件了。根据当前目录的位置确定classpath，例如，当前目录仍为work，则classpath为bin或者./bin：
```
-cp 等于 -classpath
$ java -cp bin com.itranswarp.sample.Main  
Hello, world!
```
