# groovy语法

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
* [与java的区别](#与java的区别)
* [注释](#注释)
* [变量](#变量)
* [条件判断](#条件判断)
* [switch](#switch)
* [循环](#循环)
* [异常处理](#异常处理)
* [运算](#运算)
* [命名](#命名)
* [坑](#坑)
* [输出](#输出)

<!-- vim-markdown-toc -->
## 简介
需要运行在java平台上，通常作为java平台的脚本语言使用，groovy可以使用java语言编写的库，语法和java相似，源码可以当作脚本执行．

## 与java的区别
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
```
2. 多方法
```groovy
int method(String arg) {
    return 1;
}
int method(Object arg) {
    return 2;
}
Object o = "Object";
int result = method(o);

// in java
// assertEquals(2, result);

// in groovy
// assertEquals(1, result);
```
3. 数组初始化
```groovy
// java
int[] array = {1, 2, 3};
int[] array2 = new int[] {4, 5, 6};

// groovy
int[] array = [1, 2, 3]
def array2 = new int[] {1, 2, 3}  // groovy 3.0+
```
## 注释
```groovy
// 单行注释，可以独占一行，也可以放在语句后面
/* 多行注释　*/
/**
*文档注释
*/
```
## 变量
```groovy
// 变量定义
String x
def y
var z
// 变量赋值
x = 1
x = new java.util.Date()
x = -3.1499392
x = false
x = "Hi"
// 多重赋值
def (a, b, c) = [10, 20, 'foo']
assert a == 10 && b == 20 && c == 'foo'
// 或者声明类型
def (int i, String j) = [10, 'foo']
assert i == 10 && j == 'foo'
//　列表
def list = []
def list = ['foo', 'bar']  // list string
// 地图
def map = [:]
def map1 = [someKey: 'someValue']  // list String:String
def map2 = ['someKey': 'someValue']
```
## 条件判断
```groovy
def x = false
def y = false

if ( !x ) {
    x = true
}

assert x == true

if ( x ) {
    x = false
} else {
    y = true
}

assert x == y

if ( ... ) {
    ...
} else if (...) {
    ...
} else {
    ...
}

assert ('a' =~ /a/)
assert !('a' =~ /b/)
```
## switch
Groovy 中的 switch 语句向后兼容 Java 代码；因此您可能会遇到多次匹配共享相同代码的情况。但其中一个区别是 Groovy switch 语句可以处理任何类型的 switch 值，并且可以执行不同类型的匹配。
```groovy
def x = 1.23
def result = ""

switch (x) {
    case "foo":
        result = "found foo"
        // lets fall through

    case "bar":
        result += "bar"

    case [4, 5, 6, 'inList']:
        result = "list"
        break

    case 12..30:
        result = "range"
        break

    case Integer:
        result = "integer"
        break

    case Number:
        result = "number"
        break

    case ~/fo*/: // toString() representation of x matches the pattern?
        result = "foo regex"
        break

    case { it < 0 }: // or { x < 0 }
        result = "negative"
        break

    default:
        result = "default"
}

assert result == "number"
```
## 循环
1. for
```groovy
// java/c
String message = ''
for (int i = 0; i < 5; i++) {
    message += 'Hi '
}
assert message == 'Hi Hi Hi Hi Hi '

// groovy
// iterate over a range
def x = 0
for ( i in 0..9 ) {
    x += i
}
assert x == 45

// iterate over a list
x = 0
for ( i in [0, 1, 2, 3, 4] ) {
    x += i
}
assert x == 10

// iterate over an array
def array = (0..4).toArray()
x = 0
for ( i in array ) {
    x += i
}
assert x == 10

// iterate over a map
def map = ['abc':1, 'def':2, 'xyz':3]
x = 0
for ( e in map ) {
    x += e.value
}
assert x == 6

// iterate over values in a map
x = 0
for ( v in map.values() ) {
    x += v
}
assert x == 6

// iterate over the characters in a string
def text = "abc"
def list = []
for (c in text) {
    list.add(c)
}
assert list == ["a", "b", "c"]
```
2. while
```groovy
def x = 0
def y = 5

while ( y-- > 0 ) {
    x++
}

assert x == 5
```
3. do...while
```groovy
// classic Java-style do..while loop
def count = 5
def fact = 1
do {
    fact *= count--
} while(count > 1)
assert fact == 120
```
## 异常处理
与java相同
```groovy
try {
    'moo'.toLong()   // this will generate an exception
    assert false     // asserting that this point should never be reached
} catch ( e ) {
    assert e in NumberFormatException
}

def z
try {
    def i = 7, j = 0
    try {
        def k = i / j
        assert false        //never reached due to Exception in previous line
    } finally {
        z = 'reached here'  //always executed even if Exception thrown
    }
} catch ( e ) {
    assert e in ArithmeticException
    assert z == 'reached here'
}
```
## 运算
```groovy
// 一元运算符
def a = 2
def b = a++ * 3             

assert a == 3 && b == 6

def c = 3
def d = c-- * 2             

assert c == 2 && d == 6

def e = 1
def f = ++e + 3             

assert e == 2 && f == 5

def g = 4
def h = --g + 1             

assert g == 3 && h == 4

// 关系运算符
assert 1 + 2 == 3
assert 3 != 4

assert -2 < 3
assert 2 <= 2
assert 3 <= 4

assert 5 > 1
assert 5 >= -2

// 逻辑运算符
assert !false           
assert true && true     
assert true || false 
```
## 命名
类似java

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

## 输出
在Groovy中，`println`是用于输出文本到控制台的函数。它可以用于输出简单的文本、变量的值以及其他类型的数据。下面详细说明`println`的用法：

1. 输出文本：

你可以直接使用`println`来输出简单的文本：

```groovy
println "Hello, World!"
```

这将在控制台输出：`Hello, World!`

2. 输出变量的值：

你可以使用`${}`来在字符串中插入变量的值：

```groovy
def name = "John"
println "My name is ${name}."
```

这将在控制台输出：`My name is John.`

3. 输出多个值：

你可以使用逗号来输出多个值，并它们会用空格分隔：

```groovy
def x = 10
def y = 20
println "The values are: $x, $y"
```

这将在控制台输出：`The values are: 10, 20`

4. 输出多行文本：

你可以使用三引号字符串来输出多行文本：

```groovy
println """
This is a multi-line
text output in Groovy.
"""
```

这将在控制台输出：

```
This is a multi-line
text output in Groovy.
```

5. 输出其他类型的数据：

`println`可以输出除文本和变量外的其他数据类型，例如列表、映射、布尔值等：

```groovy
def list = [1, 2, 3]
def map = ['a': 1, 'b': 2]
def isTrue = true
def x = 8

println list
println map
println isTrue
println x
```

这将在控制台输出：

```
[1, 2, 3]
[a:1, b:2]
true
8
```
print函数会在输出时省略换行符，而println会添加换行符。
