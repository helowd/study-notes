# java语法

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
* [基本概念](#基本概念)
* [命名](#命名)
* [注释](#注释)
* [声明](#声明)
* [修饰符](#修饰符)
* [算术](#算术)
* [循环](#循环)
* [条件判断](#条件判断)
* [switch case](#switch-case)
* [异常处理](#异常处理)
* [继承](#继承)
* [包](#包)

<!-- vim-markdown-toc -->
## 简介
Java 是由 Sun Microsystems 公司于 1995 年 5 月推出的高级程序设计语言。常用来开发android app．javac用来编译源码生成字节码，java用来运行字节码文件

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
* 类名：对于所有的类来说，类名的首字母应该大写。如果类名由若干单词组成，那么每个单词的首字母应该大写，例如 MyFirstJavaClass 。
* 变量和方法名：所有的方法名都应该以小写字母开头。如果方法名含有若干单词，则后面的每个单词首字母大写。
* 源文件名：源文件名必须和类名相同。当保存文件的时候，你应该使用类名作为文件名保存（切记 Java 是大小写敏感的），文件名的后缀为 .java。（如果文件名和类名不相同则会导致编译错误）。
* 主方法入口：所有的 Java 程序由 public static void main(String[] args) 方法开始执行。
* 包名：所有字母小写

## 注释
```java
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

## 声明
1. 变量
```java
int a, b, c;         // 声明三个int型整数：a、 b、c
int d = 3, e = 4, f = 5; // 声明三个整数并赋予初值
byte z = 22;         // 声明并初始化 z
String s = "runoob";  // 声明并初始化字符串 s
double pi = 3.14159; // 声明了双精度浮点型变量 pi
char x = 'x';        // 声明变量 x 的值是字符 'x'。
double[] myList = new double[d]; // 声明数组，长度为ｄ
double[] myList = {1.9, 2.9, 3.4, 3.5};　// 声明数组并赋值
String[][] str = new String[3][4];  //　声明二位数组
```
2. 其他类型
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
3. 强类型弱类型，动态语言静态语言
![](./language_type.jpeg)

## 修饰符
分为访问修饰符和非访问修饰符，修饰符用来定义类、方法或者变量，通常放在语句的最前端

1. 访问修饰符
   * default (即默认，什么也不写）: 在同一包内可见，不使用任何修饰符。使用对象：类、接口、变量、方法。
   * private : 在同一类内可见。使用对象：变量、方法。 注意：不能修饰类（外部类）
   * public : 对所有类可见。使用对象：类、接口、变量、方法
   * protected : 对同一包内的类和所有子类可见。使用对象：变量、方法。 注意：不能修饰类（外部类）。
2. 非访问修饰符
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

## 算术
1. 算数运算符
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
2. 关系运算符
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
3. 逻辑运算符
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
```

## 循环
1. while
```java
public class Test {
   public static void main(String[] args) {
      int x = 10;
      while( x < 20 ) {
         System.out.print("value of x : " + x );
         x++;
         System.out.print("\n");
      }
   }
}
```
2. do...while
```java
public class Test {
   public static void main(String[] args){
      int x = 10;
 
      do{
         System.out.print("value of x : " + x );
         x++;
         System.out.print("\n");
      }while( x < 20 );
   }
}
```
3. for
```java
public class Test {
   public static void main(String[] args) {
 
      for(int x = 10; x < 20; x = x+1) {
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

// 或
public class Test {
   public static void main(String[] args){
      int [] numbers = {10, 20, 30, 40, 50};
 
      for(int x : numbers ){
         System.out.print( x );
         System.out.print(",");
      }
      System.out.print("\n");
      String [] names ={"James", "Larry", "Tom", "Lacy"};
      for( String name : names ) {
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

## 条件判断
```java
// if
public class Test {
 
   public static void main(String args[]){
      int x = 10;
 
      if( x < 20 ){
         System.out.print("这是 if 语句");
      }
   }
}

// if...else
public class Test {
 
   public static void main(String args[]){
      int x = 30;
 
      if( x < 20 ){
         System.out.print("这是 if 语句");
      }else{
         System.out.print("这是 else 语句");
      }
   }
}

//if...else if...else
public class Test {
   public static void main(String args[]){
      int x = 30;
 
      if( x == 10 ){
         System.out.print("Value of X is 10");
      }else if( x == 20 ){
         System.out.print("Value of X is 20");
      }else if( x == 30 ){
         System.out.print("Value of X is 30");
      }else{
         System.out.print("这是 else 语句");
      }
   }
}

// 嵌套if...else
public class Test {
 
   public static void main(String args[]){
      int x = 30;
      int y = 10;
 
      if( x == 30 ){
         if( y == 10 ){
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
   public static void main(String args[]){
      //char grade = args[0].charAt(0);
      char grade = 'C';
 
      switch(grade)
      {
         case 'A' :
            System.out.println("优秀"); 
            break;
         case 'B' :
         case 'C' :
            System.out.println("良好");
            break;
         case 'D' :
            System.out.println("及格");
            break;
         case 'F' :
            System.out.println("你需要再努力努力");
            break;
         default :
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

1. 使用包

```java
package net.java.util;
public class Something{
   ...
}
```
那么它的路径应该是 net/java/util/Something.java 这样保存的

2. 创建包

创建一个animals包，往包中加入一个接口interface
```java
/* 文件名: Animal.java */
package animals;
 
interface Animal {
   public void eat();
   public void travel();
}
```
接下来，在同一个包中加入该接口的实现：
```java
package animals;
 
/* 文件名 : MammalInt.java */
public class MammalInt implements Animal{
 
   public void eat(){
      System.out.println("Mammal eats");
   }
 
   public void travel(){
      System.out.println("Mammal travels");
   } 
 
   public int noOfLegs(){
      return 0;
   }
 
   public static void main(String args[]){
      MammalInt m = new MammalInt();
      m.eat();
      m.travel();
   }
}
```
然后，编译这两个文件，并把他们放在一个叫做animals的子目录中。 用下面的命令来运行：
```bash
$ mkdir animals
$ cp Animal.class  MammalInt.class animals
$ java animals/MammalInt
Mammal eats
Mammal travel
```
3. import  

import 关键字用于引入其他包中的类、接口或静态成员，它允许你在代码中直接使用其他包中的类，而不需要完整地指定类的包名
```java
// 第一行非注释行是 package 语句
package com.example;
 
// import 语句引入其他包中的类
import java.util.ArrayList;
import java.util.List;
 
// 类的定义
public class MyClass {
    // 类的成员和方法
}
```
4. 目录组织
```java
// 文件名 :  Car.java
 
package vehicle;
 
public class Car {
   // 类实现  
}

// 把源文件放在一个目录中，这个目录要对应类所在包的名字
// ....\vehicle\Car.java
```
通常，一个公司使用它互联网域名的颠倒形式来作为它的包名.例如：互联网域名是 runoob.com，所有的包名都以 com.runoob 开头。包名中的每一个部分对应一个子目录。

例如：有一个 com.runoob.test 的包，这个包包含一个叫做 Runoob.java 的源文件，那么相应的，应该有如下面的一连串子目录：

....\com\runoob\test\Runoob.java
