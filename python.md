# python

## 目录
<!-- vim-markdown-toc GFM -->

* [简介](#简介)
* [安装](#安装)
    * [python解释器](#python解释器)
* [python基础](#python基础)
    * [代码规范pep8](#代码规范pep8)
    * [输入输出](#输入输出)
        * [输出](#输出)
        * [输入](#输入)
    * [数据类型和变量](#数据类型和变量)
    * [格式化](#格式化)
    * [内置四种数据结构](#内置四种数据结构)
        * [list列表](#list列表)
        * [tuple元组](#tuple元组)
        * [dict字典](#dict字典)
            * [定义](#定义)
            * [取值](#取值)
            * [新增和修改](#新增和修改)
            * [删除](#删除)
            * [合并](#合并)
            * [遍历key/value对](#遍历keyvalue对)
            * [遍历key](#遍历key)
            * [遍历value](#遍历value)
            * [字典内置方法](#字典内置方法)
        * [set集合](#set集合)
        * [数据结构总结](#数据结构总结)
        * [可变与不可变](#可变与不可变)
    * [条件判断](#条件判断)
    * [模式匹配](#模式匹配)
    * [循环](#循环)
* [函数](#函数)
    * [调用函数](#调用函数)
    * [定义函数](#定义函数)
        * [空函数](#空函数)
        * [参数检查](#参数检查)
        * [返回多个值](#返回多个值)
    * [函数的参数](#函数的参数)
        * [位置参数（必选参数）](#位置参数必选参数)
        * [默认参数](#默认参数)
        * [可变参数](#可变参数)
        * [关键字参数](#关键字参数)
        * [命名关键字参数](#命名关键字参数)
        * [参数组合](#参数组合)
        * [递归函数（todo）](#递归函数todo)
* [高级特性](#高级特性)
    * [切片](#切片)
    * [迭代](#迭代)
    * [列表生成器](#列表生成器)
    * [生成器](#生成器)
    * [迭代器](#迭代器)
* [函数式编程](#函数式编程)
    * [高阶函数](#高阶函数)
        * [map/reduce](#mapreduce)
        * [fiter](#fiter)
        * [sorted](#sorted)
    * [返回函数](#返回函数)
        * [函数作为返回值](#函数作为返回值)
        * [闭包](#闭包)
        * [nonlocal](#nonlocal)
    * [匿名函数](#匿名函数)
    * [装饰器](#装饰器)
        * [__name__问题](#__name__问题)
    * [偏函数](#偏函数)
* [模块](#模块)
    * [作用域](#作用域)
    * [安装第三方模块](#安装第三方模块)
    * [模块搜索路径](#模块搜索路径)
    * [常用内建模块](#常用内建模块)
        * [argparse](#argparse)
    * [常用第三方模块](#常用第三方模块)
        * [requests](#requests)
* [venv](#venv)

<!-- vim-markdown-toc -->

## 简介
python由荷兰人“龟叔”guido van rossum在1989年开发出来的。

python有非常完善的内置代码库，覆盖网络、文件、GUI、数据库、文本等，除了内置库外，python还有大量的第三方库

许多大型网站就是python开发的，比如Youtube、instagram，还有国内的豆瓣。

python的特点是优雅、明确、简单

python适合开发网络应用，包括网站、后台服务等，还适合开发许多日常需要的小工具，包括系统管理员需要的脚本任务等。

python缺点：
1. 运行速度慢，因为是解释型语言，代码会在执行时一行一行的翻译成cpu能理解的机器码，翻译的过程很耗时。而C程序是运行前直接编译成CPU能执行的机器码，所以非常快。

2. 是代码不能加密。如果要发布你的Python程序，实际上就是发布源代码，这一点跟C语言不同，C语言不用发布源代码，只需要把编译后的机器码（也就是你在Windows上常见的xxx.exe文件）发布出去。要从机器码反推出C代码是不可能的，所以，凡是编译型的语言，都没有这个问题，而解释型的语言，则必须把源码发布出去。

## 安装
因为Python是跨平台的，它可以运行在Windows、Mac和各种Linux/Unix系统上。在Windows上写Python程序，放到Linux上也是能够运行的。

安装后，你会得到Python解释器（就是负责运行Python程序的），一个命令行交互环境，还有一个简单的集成开发环境。

目前，Python有两个版本，一个是2.x版，一个是3.x版，这两个版本是不兼容的。

### python解释器
当我们编写Python代码时，我们得到的是一个包含Python代码的以.py为扩展名的文本文件。要运行代码，就需要Python解释器去执行.py文件。

由于整个Python语言从规范到解释器都是开源的，所以理论上，只要水平够高，任何人都可以编写Python解释器来执行Python代码（当然难度很大）。事实上，确实存在多种Python解释器。

1. CPython（默认）  
当我们从Python官方网站下载并安装好Python 3.x后，我们就直接获得了一个官方版本的解释器：CPython。这个解释器是用C语言开发的，所以叫CPython。在命令行下运行python就是启动CPython解释器。

2. IPython  
IPython是基于CPython之上的一个交互式解释器，也就是说，IPython只是在交互方式上有所增强，但是执行Python代码的功能和CPython是完全一样的。好比很多国产浏览器虽然外观不同，但内核其实都是调用了IE。

CPython用>>>作为提示符，而IPython用In [序号]:作为提示符。

3. PyPy  
PyPy是另一个Python解释器，它的目标是执行速度。PyPy采用JIT技术，对Python代码进行动态编译（注意不是解释），所以可以显著提高Python代码的执行速度。

绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些是不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。如果你的代码要放到PyPy下执行，就需要了解PyPy和CPython的不同点。

4. Jython   
Jython是运行在Java平台上的Python解释器，可以直接把Python代码编译成Java字节码执行。

5. IronPython  
IronPython和Jython类似，只不过IronPython是运行在微软.Net平台上的Python解释器，可以直接把Python代码编译成.Net的字节码。

小结：  
Python的解释器很多，但使用最广泛的还是CPython。如果要和Java或.Net平台交互，最好的办法不是用Jython或IronPython，而是通过网络调用来交互，确保各程序之间的独立性。

## python基础
Python的语法比较简单，采用缩进方式，写出来的代码就像下面的样子：
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# print absolute value of an integer:
a = 100
if a >= 0:
    print(a)
else:
    print(-a)
```

### 代码规范pep8
1. 使用4个空格缩进，不要使用制表符
2. 使用拆行符（\）以确保不会超过79个字符
3. 本页的一级类或者方法之间空2行，二级类或方法之间空1行，大块代码也空1行
4. 单行注释：若注释独占一行，#号顶头，空1格后写注释；若是行尾注释，空2格后#号再空1格写注释。多行注释：三对双引号（推荐使用）和三对单引号
5. 运算符周围和逗号后面使用空格，但是括号里侧不加空格，作为参数时符号周围不加空格
6. 类命名使用大驼峰命名（不使用下划线、数字），方法和变量命名全小写字符或者下划线，常量命名以大写字母开头，全部大写字母或下划线或数字
7. 导入顺序为：先导入python包，再导入第三方包，最后导入自定义的包。

### 输入输出

#### 输出
print
```
(function) def print(
    *values: object,
    sep: str | None = " ",
    end: str | None = "\n",
    file: SupportsWrite[str] | None = None,
    flush: Literal[False] = False
) -> None
Prints the values to a stream, or to sys.stdout by default.

sep
  string inserted between values, default a space.
end
  string appended after the last value, default a newline.
file
  a file-like object (stream); defaults to the current sys.stdout.
flush
  whether to forcibly flush the stream.
```

#### 输入
input返回的数据类型是str
```
(function) def input(
    prompt: object = "",
    /
) -> str
Read a string from standard input. The trailing newline is stripped.

The prompt string, if given, is printed to standard output without a trailing newline before reading input.

If the user hits EOF (*nix: Ctrl-D, Windows: Ctrl-Z+Return), raise EOFError. On *nix systems, readline is used if available.
```

### 数据类型和变量
1. 整数
2. 浮点数
3. 字符串
4. 布尔值：True、False
5. 空值：None
6. 常量：大写表示，但事实上PI仍然是一个变量，Python根本没有任何机制保证PI不会被改变

python字符串变量在内存中的表示：  
a = 'ABC'

python解释器干了两件事：  
1. 在内存中创建了一个`ABC`的字符串
2. 在内存中创建了一个名为`a`的变量，并把它指向`ABC`

也可以把一个变量a赋值给另一个变量b，这个操作实际上是把变量b指向变量a所指向的数据，例如下面的代码：
```python
a = 'ABC'
b = a
a = 'XYZ'
print(b)  # 打印ABC
```

精确除法：10 / 3，会得到浮点数，即使恰好整除  
地板除：10 // 3，会得到整数


Python支持多种数据类型，在计算机内部，可以把任何数据都看成一个“对象”，而变量就是在程序中用来指向这些数据对象的，对变量赋值就是把数据和变量给关联起来。

对变量赋值x = y是把变量x指向真正的对象，该对象是变量y所指向的。随后对变量y的赋值不影响变量x的指向。

### 格式化
在Python中，采用的格式化方式和C语言是一致的，用%实现，举例如下：
```
>>> 'Hello, %s' % 'world'
'Hello, world'
>>> 'Hi, %s, you have $%d.' % ('Michael', 1000000)
'Hi, Michael, you have $1000000.'
```

常见占位符：
```
占位符  替换内容
%d  整数
%f  浮点数
%s  字符串
%x  十六进制整数
%%  表示%
```

基本格式：`%[(name)][flags][width].[precision]typecode`  
name：命名  
flags：+表示右对齐；-表示左对齐；' '为一个空格，表示在正数的左侧填充一个空格，从而与负数对齐；0表示使用0填充。  
width：表示显示宽度  
precision：表示小数点后精度

### 内置四种数据结构

#### list列表
list是一种有序的列表，可以随时添加和删除其中的元素，list里面的元素的数据类型也可以不同。下标从0开始，-1表示列表最后一个元素下标。

示例：
```
# 定义
>>> classmates = ['Michael', 'Bob', 'Tracy']
>>> classmates
['Michael', 'Bob', 'Tracy']

# 获取列表元素总数
>>> len(classmates)
3

# 取值
>>> classmates[0]
'Michael'
>>> classmates[1]
'Bob'
>>> classmates[2]
'Tracy'
>>> classmates[3]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: list index out of range

# 追加append：作为整体追加，类型不限
k

```

#### tuple元组
另一种有序列表叫元组：tuple。tuple和list非常类似，但是tuple一旦初始化就不能修改，比如同样是列出同学的名字：
```
>>> classmates = ('Michael', 'Bob', 'Tracy')`
>>> classmates[0] = "zj"
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'tuple' object does not support item assignment
```

定义只有一个元素的tuple，Python在显示只有1个元素的tuple时，也会加一个逗号,，以免你误解成数学计算意义上的括号。：
```
>>> t = (1,)
>>> t
(1,)
```

#### dict字典
键值映射、无序、可变数据类型、key唯一天生去重、key必须是一个可hash对象（不可变数据类型，如字符串、数字、布尔值），value可以是任何数据类型

##### 定义
```
# 使用大括号 {} 来创建空字典
emptyDict = {}

# 也可以如此创建字典
tinydict1 = { 'abc': 456 }
tinydict2 = { 'abc': 123, 98.6: 37 }

# 使用内建函数dict创建空字典 
emptyDict = dict()

# 打印字典
print(emptyDict)
 
# 查看字典的数量，key的数量
print("Length:", len(emptyDict))
 
# 查看类型
print(type(emptyDict))
```

##### 取值
```
>>> d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
>>> d['Michael']
95

# dict提供get()方法，如果key不存在，可以返回None，而不是报错，或者自己指定的value
>>> d.get('Thomas')
>>> d.get('Thomas', -1)
-1
```

##### 新增和修改
```
# 如果key存在就是修改，否则就是新增
dict[key] = values 
```

##### 删除
```
tinydict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
 
del tinydict['Name'] # 删除键 'Name'
tinydict.clear()     # 清空字典
del tinydict         # 删除字典，del删除字典后字典将不再存在
 
print ("tinydict['Age']: ", tinydict['Age'])
print ("tinydict['School']: ", tinydict['School'])

# 指定key删除
dict.pop(key)

# 默认删除最后一个元素
dict.popitem()
```

##### 合并
```
# 将dict2合并到dict1
dict1.update(dict2)

# 将dict1与dict2合并生成一个新字典
dict(dict1, **dict2)
```

##### 遍历key/value对
```
dict1 = {"a": "aa", "b": "bb", "c": "cc"}

print(dict1.itmes())

for item in dict1.items():
    print(item)

# 输出
dict_items([("a", "aa"), ("b", "bb"), ("c", "cc")])
("a", "aa")
("b", "bb")
("c", "cc")
```

##### 遍历key
```
print(dict1.keys())

for key in dict1.keys():
    print(key)

# 输出
dict_keys(["a", "b", "c"])
a
b
c
```

##### 遍历value
```
print(dict1.values())

for value in dcit1.values():
    print(value)

# 输出
dict_values(["aa", "bb", "cc"])
aa
bb
cc
```

##### 字典内置方法
```
1   dict.clear()
删除字典内所有元素
2   dict.copy()
返回一个字典的浅复制
3   dict.fromkeys()
创建一个新字典，以序列seq中元素做字典的键，val为字典所有键对应的初始值
4   dict.get(key, default=None)
返回指定键的值，如果键不在字典中返回 default 设置的默认值
5   key in dict
如果键在字典dict里返回true，否则返回false
6   dict.items()
以列表返回一个视图对象
7   dict.keys()
返回一个视图对象
8   dict.setdefault(key, default=None)
和get()类似, 但如果键不存在于字典中，将会添加键并将值设为default
9   dict.update(dict2)
把字典dict2的键/值对更新到dict里
10  dict.values()
返回一个视图对象
11  dict.pop(key[,default])
删除字典 key（键）所对应的值，返回被删除的值。
12  dict.popitem()
返回并删除字典中的最后一对键和值。
```

#### set集合
set和dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key。

示例：
```
# 要创建一个set，需要提供一个list作为输入集合
>>> s = set([1, 1, 2, 2, 3, 3])
>>> s
{1, 2, 3}

# 或者使用花括号{}来定义
a = {1, 2, 3}
```

#### 数据结构总结
- `list`（列表）是一种有序的可变序列，可以存储任意类型的元素。列表使用方括号`[]`来表示，元素之间用逗号`,`分隔。列表支持索引、切片、添加、删除、修改等操作，是Python中最常用的数据类型之一。

- `tuple`（元组）是一种有序的不可变序列，可以存储任意类型的元素。元组使用圆括号`()`来表示，元素之间用逗号`,`分隔。元组支持索引、切片等操作，但不支持添加、删除、修改等操作。元组通常用于存储不可变的数据，如坐标、颜色等。

- `dict`（字典）是一种无序的键值对集合，可以存储任意类型的键和值。字典使用花括号`{}`来表示，每个键值对之间用冒号`:`分隔，键值对之间用逗号`,`分隔。字典支持通过键来访问值，也支持添加、删除、修改等操作。字典通常用于存储具有映射关系的数据，如姓名和电话号码的对应关系。

- `set`（集合）是一种无序的元素集合，可以存储任意类型的元素。集合使用花括号`{}`来表示，元素之间用逗号`,`分隔。集合支持添加、删除、交集、并集、差集等操作。集合通常用于去重、交集、并集等操作。

需要注意的是，`list`、`tuple`、`dict`和`set`是不同的数据类型，它们之间不能直接进行转换。如果需要将它们之间进行转换，需要使用相应的转换函数，如`list()`、`tuple()`、`dict()`和`set()`。


#### 可变与不可变
可变：  
list，set，dict

不可变：  
bool、int、flaot、tuple、str、frozenset

可变和不可变 主要看在原来的内存地址上能不能修改值，能修改则可变，不能修改则不可变

修改数据的时候，可变数据类型传递的是内存中的地址

### 条件判断
```
if <条件判断1>:
    <执行1>
elif <条件判断2>:
    <执行2>
elif <条件判断3>:
    <执行3>
else:
    <执行4>

age = 20
if age >= 6:
    print('teenager')
elif age >= 18:
    print('adult')
else:
    print('kid')
```

### 模式匹配
```
score = 'B'

match score:
    case 'A':
        print('score is A.')
    case 'B':
        print('score is B.')
    case 'C':
        print('score is C.')
    case _: # _表示匹配到其他任何情况
        print('score is ???.')


# 复杂匹配
age = 15

match age:
    case x if x < 10:
        print(f'< 10 years old: {x}')
    case 10:
        print('10 years old.')
    case 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18:
        print('11~18 years old.')
    case 19:
        print('19 years old.')
    case _:
        print('not sure.')


# 匹配列表
args = ['gcc', 'hello.c', 'world.c']
# args = ['clean']
# args = ['gcc']

match args:
    # 如果仅出现gcc，报错:
    case ['gcc']:
        print('gcc: missing source file(s).')
    # 出现gcc，且至少指定了一个文件:
    case ['gcc', file1, *files]:
        print('gcc compile: ' + file1 + ', ' + ', '.join(files))
    # 仅出现clean:
    case ['clean']:
        print('clean')
    case _:
        print('invalid command.')
```

### 循环
支持break，continue语句
```
# for
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print(name)

sum = 0
for x in range(101):
    sum = sum + x
print(sum)


# while
sum = 0
n = 99
while n > 0:
    sum = sum + n
    n = n - 2
print(sum)
```

## 函数

### 调用函数
Python内置了很多有用的函数，我们可以直接调用。

要调用一个函数，需要知道函数的名称和参数，比如求绝对值的函数abs，只有一个参数。可以直接从Python的官方网站查看文档：

http://docs.python.org/3/library/functions.html#abs

也可以在交互式命令行通过help(abs)查看abs函数的帮助信息。

示例：
```
>>> abs(100)
100
>>> abs(-20)
20
>>> abs(12.34)
12.34

# 数据类型转换
>>> int('123')
123
>>> int(12.34)
12
>>> float('12.34')
12.34
>>> str(1.23)
'1.23'
>>> str(100)
'100'
>>> bool(1)
True
>>> bool('')
False

>>> a = abs # 变量a指向abs函数
>>> a(-1) # 所以也可以通过a调用abs函数
1
```

### 定义函数
在Python中，定义一个函数要使用def语句，依次写出函数名、括号、括号中的参数和冒号:，然后，在缩进块中编写函数体，函数的返回值用return语句返回。

示例：
```python
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
```
函数体内部的语句在执行时，一旦执行到return时，函数就执行完毕，并将结果返回。如果没有return语句，函数执行完毕后也会返回结果，只是结果为None。return None可以简写为return

#### 空函数
如果想定义一个什么事也不做的空函数，可以用pass语句：
```python
def nop():
    pass
```

#### 参数检查
调用函数时，如果参数个数不对，Python解释器会自动检查出来，并抛出TypeError：
```
>>> my_abs(1, 2)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: my_abs() takes 1 positional argument but 2 were given
```

但是如果参数类型不对，Python解释器就无法帮我们检查。试试my_abs和内置函数abs的差别：
```
>>> my_abs('A')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 2, in my_abs
TypeError: unorderable types: str() >= int()
>>> abs('A')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: bad operand type for abs(): 'str'
```

#### 返回多个值
python函数可以返回多个值，是一个tuple

示例：
```
import math

def move(x, y, step, angle=0):
    nx = x + step * math.cos(angle)
    ny = y - step * math.sin(angle)
    return nx, ny

>>> x, y = move(100, 100, 60, math.pi / 6)
>>> print(x, y)
151.96152422706632 70.0

>>> r = move(100, 100, 60, math.pi / 6)
>>> print(r)
(151.96152422706632, 70.0)
```
原来返回值是一个tuple！但是，在语法上，返回一个tuple可以省略括号，而多个变量可以同时接收一个tuple，按位置赋给对应的值，所以，Python的函数返回多值其实就是返回一个tuple，但写起来更方便。

### 函数的参数
Python的函数定义非常简单，但灵活度却非常大。除了正常定义的必选参数外，还可以使用默认参数、可变参数和关键字参数，使得函数定义出来的接口，不但能处理复杂的参数，还可以简化调用者的代码。

#### 位置参数（必选参数）
下面代码中，x和n就是位置参数，调用函数时，传入的两个值按照位置顺序依次赋值给x和n，必须传递两个值
```python
def power(x, n):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
```

#### 默认参数
第二个参数n的默认值设定为2，表示默认参数，当这个参数未传值时，会设置成默认参数的值。  
一是必选参数在前，默认参数在后，否则Python的解释器会报错
二是如何设置默认参数。当函数有多个参数时，把变化大的参数放前面，变化小的参数放后面。变化小的参数就可以作为默认参数。  
默认参数必须指向不变对象，如None

示例：
```python
def power(x, n=2):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s

def add_end(L=None):
    if L is None:
        L = []
    L.append('END')
    return L
```

#### 可变参数
在Python函数中，还可以定义可变参数。顾名思义，可变参数就是传入的参数个数是可变的，可以是1个、2个到任意个，还可以是0个。

定义可变参数和定义一个list或tuple参数相比，仅仅在参数前面加了一个`*`号。在函数内部，参数numbers接收到的是一个tuple，因此，函数代码完全不变。但是，调用该函数时，可以传入任意个参数，包括0个参数：

示例：
```
def calc(*numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum

>>> calc(1, 2)
5
>>> calc()
0
```

如果已经有一个list或者tuple，要调用一个可变参数怎么办？可以这样做：
```
>>> nums = [1, 2, 3]
>>> calc(*nums)
14
```
`*`nums表示把nums这个list的所有元素作为可变参数传进去。这种写法相当有用，而且很常见。

#### 关键字参数
关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict。请看示例：
```
def person(name, age, **kw):
    print('name:', name, 'age:', age, 'other:', kw)
```

函数person除了必选参数name和age外，还接受关键字参数kw。在调用该函数时，可以只传入必选参数：
```
>>> person('Michael', 30)
name: Michael age: 30 other: {}
```

也可以传入任意个数的关键字参数：
```
>>> person('Bob', 35, city='Beijing')
name: Bob age: 35 other: {'city': 'Beijing'}
>>> person('Adam', 45, gender='M', job='Engineer')
name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
```

和可变参数类似，也可以先组装出一个dict，然后，把该dict转换为关键字参数传进去：
```
>>> extra = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, **extra)
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
```
**extra表示把extra这个dict的所有key-value用关键字参数传入到函数的**kw参数，kw将获得一个dict，注意kw获得的dict是extra的一份拷贝，对kw的改动不会影响到函数外的extra。

#### 命名关键字参数
如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接收city和job作为关键字参数。这种方式定义的函数如下：
```
def person(name, age, *, city, job):
    print(name, age, city, job)
```
和关键字参数`**kw`不同，命名关键字参数需要一个特殊分隔符`*`, 分隔符后面的参数被视为命名关键字参数。

调用方式如下：
```
>>> person('Jack', 24, city='Beijing', job='Engineer')
Jack 24 Beijing Engineer
```

如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符`*`了：
```
def person(name, age, *args, city, job):
    print(name, age, args, city, job)
```

命名关键字参数必须传入参数名，这和位置参数不同。如果没有传入参数名，调用将报错：
```
>>> person('Jack', 24, 'Beijing', 'Engineer')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: person() missing 2 required keyword-only arguments: 'city' and 'job'
```

#### 参数组合
在Python中定义函数，可以用必选参数、默认参数、可变参数、关键字参数和命名关键字参数，这5种参数都可以组合使用。但是请注意，参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。

示例：
```
def f1(a, b, c=0, *args, **kw):
    print('a =', a, 'b =', b, 'c =', c, 'args =', args, 'kw =', kw)

def f2(a, b, c=0, *, d, **kw):
    print('a =', a, 'b =', b, 'c =', c, 'd =', d, 'kw =', kw)

# 调用
>>> f1(1, 2)
a = 1 b = 2 c = 0 args = () kw = {}
>>> f1(1, 2, c=3)
a = 1 b = 2 c = 3 args = () kw = {}
>>> f1(1, 2, 3, 'a', 'b')
a = 1 b = 2 c = 3 args = ('a', 'b') kw = {}
>>> f1(1, 2, 3, 'a', 'b', x=99)
a = 1 b = 2 c = 3 args = ('a', 'b') kw = {'x': 99}
>>> f2(1, 2, d=99, ext=None)
a = 1 b = 2 c = 0 d = 99 kw = {'ext': None}
```

所以，对于任意函数，都可以通过类似`func(*args, **kw)`的形式调用它，无论它的参数是如何定义的。

#### 递归函数（todo）
```
def fact(n):
    if n==1:
        return 1
    return n * fact(n - 1)
```

## 高级特性

### 切片
```
L = ['Michael', 'Sarah', 'Tracy', 'Bob', 'Jack']

# L[0:3]表示，从索引0开始取，直到3三个元素为止，但不包括索引3。即索引0，1，2，正好是3个元素。
>>> L[0:3]
['Michael', 'Sarah', 'Tracy']

# 如果第一个索引是0，还可以省略：
>>> L[:3]
['Michael', 'Sarah', 'Tracy']

# 倒数切片，倒数第一个索引是-1
>>> L[-2:]
['Bob', 'Jack']
>>> L[-2:-1]
['Bob']

# 前10个数，每两个取一个：
>>> L[:10:2]
[0, 2, 4, 6, 8]

# tuple也是一种list，唯一区别是tuple不可变。因此，tuple也可以用切片操作，只是操作的结果仍是tuple：
>>> (0, 1, 2, 3, 4, 5)[:3]
(0, 1, 2)


# 字符串'xxx'也可以看成是一种list，每个元素就是一个字符。因此，字符串也可以用切片操作，只是操作结果仍是字符串：
>>> 'ABCDEFG'[:3]
'ABC'
>>> 'ABCDEFG'[::2]
'ACEG'
```

### 迭代
如果给定一个list或tuple，我们可以通过for循环来遍历这个list或tuple，这种遍历我们称为迭代（Iteration）。只要是可迭代对象，无论有无下标，都可以迭代。

示例：
```
# dict
>>> d = {'a': 1, 'b': 2, 'c': 3}
>>> for key in d:
...     print(key)
...
a
c
b

# 默认情况下，dict迭代的是key。如果要迭代value，可以用for value in d.values()，如果要同时迭代key和value，可以用for k, v in d.items()。

# str
>>> for ch in 'ABC':
...     print(ch)
...
A
B
C
```

判断对象是否是可迭代对象：
```
>>> from collections.abc import Iterable
>>> isinstance('abc', Iterable) # str是否可迭代
True
>>> isinstance([1,2,3], Iterable) # list是否可迭代
True
>>> isinstance(123, Iterable) # 整数是否可迭代
False
```

Python内置的enumerate函数可以把一个list变成索引-元素对，这样就可以在for循环中同时迭代索引和元素本身：
```
>>> for i, value in enumerate(['A', 'B', 'C']):
...     print(i, value)
...
0 A
1 B
2 C
```

### 列表生成器
```
>>> list(range(1, 11))
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

>>> [x * x for x in range(1, 11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# 条件判断
>>> [x * x for x in range(1, 11) if x % 2 == 0]
[4, 16, 36, 64, 100]

# 两层循环
>>> [m + n for m in 'ABC' for n in 'XYZ']
['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']

# 两个变量
>>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
>>> [k + '=' + v for k, v in d.items()]
['y=B', 'x=A', 'z=C']
```

### 生成器
通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。

所以，如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list，从而节省大量的空间。在Python中，这种一边循环一边计算的机制，称为生成器：generator。
```
>>> L = [x * x for x in range(10)]
>>> L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x1022ef630>
```
创建L和g的区别仅在于最外层的[]和()，L是一个list，而g是一个generator。

调用generator
```
# next
>>> next(g)
0
>>> next(g)
1
>>> next(g)
4
>>> next(g)
9
>>> next(g)
16
>>> next(g)
25
>>> next(g)
36
>>> next(g)
49
>>> next(g)
64
>>> next(g)
81
>>> next(g)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration


>>> g = (x * x for x in range(10))
>>> for n in g:
...     print(n)
... 
0
1
4
9
16
25
36
49
64
81
```
所以，我们创建了一个generator后，基本上永远不会调用next()，而是通过for循环来迭代它，并且不需要关心StopIteration的错误。

yield关键字
```
# 斐波拉契
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        # print(b)
        yield b
        a, b = b, a + b
        n = n + 1
    return 'done'

for x in fib(1000):
    print(x)
```
或者 next 函数之类的，实际上的运行方式是每次的调用都在 yield 处中断并返回一个结果，然后再次调用的时候再恢复中断继续运行。

但是用for循环调用generator时，发现拿不到generator的return语句的返回值。如果想要拿到返回值，必须捕获StopIteration错误，返回值包含在StopIteration的value中：
```
>>> g = fib(6)
>>> while True:
...     try:
...         x = next(g)
...         print('g:', x)
...     except StopIteration as e:
...         print('Generator return value:', e.value)
...         break
...
g: 1
g: 1
g: 2
g: 3
g: 5
g: 8
Generator return value: done
```

### 迭代器
我们已经知道，可以直接作用于for循环的数据类型有以下几种：

一类是集合数据类型，如list、tuple、dict、set、str等；

一类是generator，包括生成器和带yield的generator function。

这些可以直接作用于for循环的对象统称为可迭代对象：Iterable。

可以使用isinstance()判断一个对象是否是Iterable对象：
```
>>> from collections.abc import Iterable
>>> isinstance([], Iterable)
True
>>> isinstance({}, Iterable)
True
>>> isinstance('abc', Iterable)
True
>>> isinstance((x for x in range(10)), Iterable)
True
>>> isinstance(100, Iterable)
False
```

而生成器不但可以作用于for循环，还可以被next()函数不断调用并返回下一个值，直到最后抛出StopIteration错误表示无法继续返回下一个值了。

可以被next()函数调用并不断返回下一个值的对象称为迭代器：Iterator。

可以使用isinstance()判断一个对象是否是Iterator对象：
```
>>> from collections.abc import Iterator
>>> isinstance((x for x in range(10)), Iterator)
True
>>> isinstance([], Iterator)
False
>>> isinstance({}, Iterator)
False
>>> isinstance('abc', Iterator)
False
```

生成器都是Iterator对象，但list、dict、str虽然是Iterable，却不是Iterator。

把list、dict、str等Iterable变成Iterator可以使用iter()函数：
```
>>> isinstance(iter([]), Iterator)
True
>>> isinstance(iter('abc'), Iterator)
True
```

你可能会问，为什么list、dict、str等数据类型不是Iterator？

这是因为Python的Iterator对象表示的是一个数据流，Iterator对象可以被next()函数调用并不断返回下一个数据，直到没有数据时抛出StopIteration错误。可以把这个数据流看做是一个有序序列，但我们却不能提前知道序列的长度，只能不断通过next()函数实现按需计算下一个数据，所以Iterator的计算是惰性的，只有在需要返回下一个数据时它才会计算。

Iterator甚至可以表示一个无限大的数据流，例如全体自然数。而使用list是永远不可能存储全体自然数的。

小结：  
凡是可作用于for循环的对象都是Iterable类型；

凡是可作用于next()函数的对象都是Iterator类型，它们表示一个惰性计算的序列；

集合数据类型如list、dict、str等是Iterable但不是Iterator，不过可以通过iter()函数获得一个Iterator对象。

Python的for循环本质上就是通过不断调用next()函数实现的，例如：
```
for x in [1, 2, 3, 4, 5]:
    pass
```
实际上完全等价于：
```
# 首先获得Iterator对象:
it = iter([1, 2, 3, 4, 5])
# 循环:
while True:
    try:
        # 获得下一个值:
        x = next(it)
    except StopIteration:
        # 遇到StopIteration就退出循环
        break
```

## 函数式编程

### 高阶函数

#### map/reduce
map()函数接收两个参数，一个是函数，一个是Iterable，map将传入的函数依次作用到序列的每个元素，并把结果作为新的Iterator返回。

示例：
```
>>> def f(x):
...     return x * x
...
>>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
>>> list(r)
[1, 4, 9, 16, 25, 36, 49, 64, 81]

# 把所有数字转为字符串：
>>> list(map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
['1', '2', '3', '4', '5', '6', '7', '8', '9']
```


reduce把一个函数作用在一个序列[x1, x2, x3, ...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算，其效果就是：`reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)`

比方说对一个序列求和，就可以用reduce实现：
```
>>> from functools import reduce
>>> def add(x, y):
...     return x + y
...
>>> reduce(add, [1, 3, 5, 7, 9])
25
```

把序列[1, 3, 5, 7, 9]变换成整数13579，reduce就可以派上用场：
```
>>> from functools import reduce
>>> def fn(x, y):
...     return x * 10 + y
...
>>> reduce(fn, [1, 3, 5, 7, 9])
13579
```

#### fiter
Python内建的filter()函数用于过滤序列。

和map()类似，filter()也接收一个函数和一个序列。和map()不同的是，filter()把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。

例如，在一个list中，删掉偶数，只保留奇数，可以这么写：
```
def is_odd(n):
    return n % 2 == 1

list(filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]))
# 结果: [1, 5, 9, 15]
```

把一个序列中的空字符串删掉，可以这么写：
```
def not_empty(s):
    return s and s.strip()

list(filter(not_empty, ['A', '', 'B', None, 'C', '  ']))
# 结果: ['A', 'B', 'C']
```

把一个序列中的空字符串删掉，可以这么写：
```
def not_empty(s):
    return s and s.strip()

list(filter(not_empty, ['A', '', 'B', None, 'C', '  ']))
# 结果: ['A', 'B', 'C']
```

注意到filter()函数返回的是一个Iterator，也就是一个惰性序列，所以要强迫filter()完成计算结果，需要用list()函数获得所有结果并返回list。


#### sorted
```
# 对列表进行排序，返回排序后的列表
>>> sorted([36, 5, -12, 9, -21])
[-21, -12, 5, 9, 36]

# 此外，sorted()函数也是一个高阶函数，它还可以接收一个key函数来实现自定义的排序，例如按绝对值大小排序：
>>> sorted([36, 5, -12, 9, -21], key=abs)
[5, 9, -12, -21, 36]

# 可实现忽略大小写的排序：
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower)
['about', 'bob', 'Credit', 'Zoo']

# 要进行反向排序，不必改动key函数，可以传入第三个参数reverse=True：
>>> sorted(['bob', 'about', 'Zoo', 'Credit'], key=str.lower, reverse=True)
['Zoo', 'Credit', 'bob', 'about']
```

### 返回函数

#### 函数作为返回值
高阶函数除了可以接受函数作为参数外，还可以把函数作为结果值返回。

比如一个求和的函数是这样定义的：

```python
def calc_sum(*args):
    ax = 0
    for n in args:
        ax = ax + n
    return ax
```

但是，如果不需要立即求和，而是在后面的代码中，根据需要再计算，就可以不反悔求和的结果，而是返回求和的函数：

```python
def lazy_sum(*args):
    def sum():
        ax = 0
        for n in args:
            ax = ax + n
        return ax
    return sum
```

当我们调用lazy_sum()时，返回的并不是求和结果，而是求和函数，调用f时，才真正计算求和的结果:

```
>>> f = lazy_sum(1, 3, 5, 7, 9)
>>> f
<function lazy_sum.<locals>.sum at 0x101c6ed90>

>>> f()
25
```

#### 闭包

在这个例子中，我们在函数lazy_sum中又定义了函数sum，并且，内部函数sum可以引用外部函数lazy_sum的参数和局部变量，当lazy_sum返回函数sum时，相关参数和变量都保存在返回的函数中，这种称为闭包（closure）的程序结构拥有极大的威力。

注意，当我们调用lazy_sum()时，每次调用都会返回一个新的函数，即使传入相同的参数：

```
>>> f1 = lazy_sum(1, 3, 5, 7, 9)
>>> f2 = lazy_sum(1, 3, 5, 7, 9)
>>> f1 = f2
False
```

f1()和f2()的调用结果互不影响

#### nonlocal

如果内函数对外层变量赋值，由于python解释器会把x当作函数fn()的局部变量，它会报错：

```
def inc():
    x = 0
    def fn():
        # nonlocal x 
        x = x + 1
        return x
    return fn

f = inc()
print(f())  # 1
print(f())  # 2
```

原因是x作为局部变量并有没有初始化，直接计算x+1是不行的。但我们其实是想引用inc()函数内部的x，所以需要在fn()函数内部加一个nonlocal x的声明。加上这个声明后，解释器把fn()的x看作外层函数的局部变量，它已经被初始化了，可以正确计算x+1

使用闭包时，对外层变量赋值前，需要先使用nonlocal声明该变量不是当前函数的局部变量。

### 匿名函数
当我们在传入函数时，有些时候，不需要显示地定义函数，直接传入匿名函数更方便。

在计算f(x)=x^2时，除了定义一个f(x)的函数外，还可以直接传入匿名函数：

```
>>> list(map(lambda x: x * x, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
[1, 4, 9, 16, 25, 36, 49, 64, 81]
```

通过对比可以看出，匿名函数`lambda x : x * x`实际上就是

```
def f(x):
    return x * x
```

关键字lambda表示匿名函数，冒号前面x表示函数参数

匿名函数有个限制，就是只能有一个表达式，不用写return，返回值就是该表达式的结果。

匿名函数没有名字，不必担心函数名冲突。此外匿名函数也是一个函数对象，也可以把匿名函数赋值给一个变量，再利用变量来调用该函数：

```
>>> f = lambda x: x * x
>>> f
<function <lambda> at 0x101c6ef28>
>>> f(5)
25
```

同样，也可以把匿名函数作为返回值返回，比如：

```python
def build(x, y):
    return lambda: x * x + y * y
```

### 装饰器
在代码运行期间动态增加功能的方式，称为装饰器（Decorator），本质上decorator就是一个返回函数的高阶函数。所以我们要定义一个能打印日志的decorator，可以定义如下：

```python
def log(func):
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```

观察上面的log，因为他是一个decorator，所以接受一个函数作为参数，并返回一个函数。我们要借助python的@语法，把decorator置于函数的定义处：

```python
@log
def now():
    print('2015-3-25')
```

调用now()函数，不仅会运行now()函数本身，还会运行now()函数前打印一行日志：

```
>>> now()
call now():
2015-3-25
```

把@log放到now()函数的定义处，相当于执行了语句：`now = log(now)`

由于log()是一个decorator，返回一个函数，所以原来的now()函数仍然存在，只是现在同名的now变量指向了新的函数，于是调用now()将执行新函数，即在log()函数中返回的wrapper()函数。

wrapper()函数的参数定义是`(*args, **kw)`，因此，wrapper()函数可以接受任何参数的调用。在wrapper()函数内，首先打印日志，再紧接着调用原始函数。

如果decorator本身需要传入参数，那就需要编写一个返回decorator的高阶函数，写出来会更复杂，比如要自定义log的文本：

```python
def log(text):
    def decorator(func):
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(**args, **kw)
        return wrapper
    return decorator
```

这三层嵌套的decorator用法如下：

```python
@log('execute')
def now():
    print('2015-3-25')
```

执行结果如下：

```
>>> now()
execute now():
2015-3-25
```

和两层嵌套的decorator相比，3层嵌套的效果是这样的：

`>>> now = log('execute')(now)`

我们来剖析上面的语句，首先执行log('execute')，返回的是decorator函数，再调用返回的函数，参数是now函数，返回值最终是wrapper函数。

#### __name__问题
以上两种decorator的定义都没有问题，但还差最后一步。因为我们讲了函数也是对象，它有__name__等属性，但你去看经过decorator装饰之后的函数，它们的__name__已经从原来的'now'变成了'wrapper'：

```
>>> now.__name__
'wrapper'
```

因为返回的那个wrapper()函数名字就是'wrapper'，所以，需要把原始函数的__name__等属性复制到wrapper()函数中，否则，有些依赖函数签名的代码执行就会出错。

不需要编写wrapper.__name__ = func.__name__这样的代码，Python内置的functools.wraps就是干这个事的，所以，一个完整的decorator的写法如下：
```python
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```

或者针对带参数的decorator：
```python
import functools

def log(text):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(*args, **kw)
        return wrapper
    return decorator
```

### 偏函数
python中的functools模块提供了很多有用的功能，其中一个就是偏函数（partial function）。通过设定参数的默认值，额可以降低函数调用的难度。而偏函数也可以做到这一点。举例如下：

int()函数可以把字符串转换为整数，当仅传入字符串时，int()函数默认按十进制转换：

```
>>> int("12345")
12345
```

但如果int()函数还提供额外的base参数，默认值为10。如果传入base参数，就可以做N进制的转换：

```
>>> int('12345', base=8)
5349

>>> int('12345', 16)
74565
```

假设要转换大量的二进制字符串，每次都传入int(x, base=2)非常麻烦，于是可以定义一个int2()的函数，默认把base=2传进去:

```python
def int2(x, base=2)
    return int(x, base)
```

functools.parial就是帮助我们创建一个偏函数的，不需要我们自定义int2()，可以直接使用下面的代码创建一个新的函数int2：
```
>>> import functools
>>> int2 = functools.partial(int, base=2)
>>> int2('1000000')
64
>>> int2('1010101')
85
```

所以，简单总结functools.partial的作用就是，把一个函数的某些参数给固定住（也就是设置默认值）返回一个新的函数，调用这个新函数会更加简单。

上面新的int2函数，仅仅是把base参数重新设置默认值为2，但也可以在函数调用时传入其他值：

```
>>> int('1000000', base=10)
1000000
```

## 模块

pyhon本身就内置了很多非常有用的模块，只要安装完毕，这些模块就可以立即使用。

我们以内建的sys模块为例，编写一个hello的模块：

```
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'a test module'

__author__ = 'Michael Liao'

import sys

def test():
    args = sys.argv
    if len(args) == 1:
        print("Hello, world!")
    elif len(args) == 2:
        print("Hello, %s!" % args[1])
    else:
        print("Too many arguments!")

if __name__ == "__main__":
    test()
```

第1行和第2行是标准注释，第1行注释可以让这个hello.py文件直接在Unix/Linux/Mac上运行，第2行注释表示.py文件本身使用标准UTF-8编码；

第4行是一个字符串，表示模块的文档注释，任何模块代码的第一个字符串都被视为模块的文档注释；

第6行使用__author__变量把作者写进去，这样当你公开源代码后别人就可以瞻仰你的大名；

以上就是Python模块的标准文件模板，当然也可以全部删掉不写，但是，按标准办事肯定没错。

后面开始就是真正的代码部分。

当我们在命令行运行hello模块文件时，Python解释器把一个特殊变量__name__置为__main__，而如果在其他地方导入该hello模块时，if判断将失败，因此，这种if测试可以让一个模块通过命令行运行时执行一些额外的代码，最常见的就是运行测试。

### 作用域

在一个模块中，我们可能会定义很多函数和变量，但有的函数和变量我们希望给别人使用，有的函数和变量我们希望仅仅在模块内部使用。在Python中，是通过_前缀来实现的。

正常的函数和变量名是公开的（public），可以被直接引用，比如：abc，x123，PI等；

类似__xxx__这样的变量是特殊变量，可以被直接引用，但是有特殊用途，比如上面的__author__，__name__就是特殊变量，hello模块定义的文档注释也可以用特殊变量__doc__访问，我们自己的变量一般不要用这种变量名；

类似_xxx和__xxx这样的函数或变量就是非公开的（private），不应该被直接引用，比如_abc，__abc等；

之所以我们说，private函数和变量“不应该”被直接引用，而不是“不能”被直接引用，是因为Python并没有一种方法可以完全限制访问private函数或变量，但是，从编程习惯上不应该引用private函数或变量。


private函数或变量不应该被别人引用，那它们有什么用呢？请看例子：
```python
def _private_1(name):
    return "Hello, %s" % name

def _private_2(name):
    return "Hi, %s" % name

def greeting(name):
    if len(name) > 3:
        return _private_1(name)
    else:
        return _private_2(name)
```

我们在模块里公开greeting()函数，而把内部逻辑用private函数隐藏起来了，这样，调用greeting()函数不用关心内部的private函数细节，这也是一种非常有用的代码封装和抽象的方法，即：

外部不需要引用的函数全部定义成private，只有外部需要引用的函数才定义为public。

### 安装第三方模块
在python中，安装第三方模块，是通过包管理工具pip完成的。python3和python2并存的时候，对应的pip命令是pip3

一般来说，第三方库都会在Python官方的pypi.python.org网站注册，要安装一个第三方库，必须先知道该库的名称，可以在官网或者pypi上搜索，比如Pillow的名称叫Pillow，因此，安装Pillow的命令就是：

```
pip install Pillow

```

### 模块搜索路径
当我们试图加载一个模块时，python会在指定的路径下搜索对应的.py文件，如果找不到就会报错：

```
>>> import mymodule
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: No module named mymodule
```

默认情况下，python解释器会搜索当前目录、所有已安装的内置模块和第三方模块，搜索路径存放在sys模块的path变量中：

```
>>> import sys
>>> sys.path
['', '/Library/Frameworks/Python.framework/Versions/3.6/lib/python36.zip', '/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6', ..., '/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages']
```

如果我们要添加自己的搜索目录，有两种方法：

一是直接修改sys.path，添加要搜索的目录，这种方法是在运行时修改，运行结束后失效：

```
>>> import sys
>>> sys.path.append('/Users/michael/my_py_scripts')
```

第二种方法是设置环境变量PYTHONPATH，该环境变量的内容会被自动添加到模块搜索路径中。设置方式与设置Path环境变量类似。注意只需要添加你自己的搜索路径，Python自己本身的搜索路径不受影响。

### 常用内建模块

#### argparse

为了简化参数解析，我们可以使用内置的argparse库，定义好各个参数类型后，它能直接返回有效的参数。

假设我们想编写一个备份MySQL数据库的命令行程序，需要输入的参数如下：

```
host参数：表示MySQL主机名或IP，不输入则默认为localhost；
port参数：表示MySQL的端口号，int类型，不输入则默认为3306；
user参数：表示登录MySQL的用户名，必须输入；
password参数：表示登录MySQL的口令，必须输入；
gz参数：表示是否压缩备份文件，不输入则默认为False；
outfile参数：表示备份文件保存在哪，必须输入。
```

其中，outfile是位置参数，而其他则是类似--user root这样的“关键字”参数。

用argparse来解析参数，一个完整示例如下：

```python
# backup.py

import argparse

def main():
    # 定义一个ArgumentParser实例:
    parser = argparse.ArgumentParser(
        prog='backup', # 程序名
        description='Backup MySQL database.', # 描述
        epilog='Copyright(r), 2023' # 说明信息
    )
    # 定义位置参数:
    parser.add_argument('outfile')
    # 定义关键字参数:
    parser.add_argument('--host', default='localhost')
    # 此参数必须为int类型:
    parser.add_argument('--port', default='3306', type=int)
    # 允许用户输入简写的-u:
    parser.add_argument('-u', '--user', required=True)
    parser.add_argument('-p', '--password', required=True)
    parser.add_argument('--database', required=True)
    # gz参数不跟参数值，因此指定action='store_true'，意思是出现-gz表示True:
    parser.add_argument('-gz', '--gzcompress', action='store_true', required=False, help='Compress backup files by gz.')


    # 解析参数:
    args = parser.parse_args()

    # 打印参数:
    print('parsed args:')
    print(f'outfile = {args.outfile}')
    print(f'host = {args.host}')
    print(f'port = {args.port}')
    print(f'user = {args.user}')
    print(f'password = {args.password}')
    print(f'database = {args.database}')
    print(f'gzcompress = {args.gzcompress}')

if __name__ == '__main__':
    main()    
```

输入有效的参数，则程序能解析出所需的所有参数：
```
$ ./backup.py -u root -p hello --database testdb backup.sql
parsed args:
outfile = backup.sql
host = localhost
port = 3306
user = root
password = hello
database = testdb
gzcompress = False
```

缺少必要的参数，或者参数不对，将报告详细的错误信息：
```
$ ./backup.py --database testdb backup.sql
usage: backup [-h] [--host HOST] [--port PORT] -u USER -p PASSWORD --database DATABASE outfile
backup: error: the following arguments are required: -u/--user, -p/--password
```

更神奇的是，如果输入-h，则打印帮助信息：
```
$ ./backup.py -h                          
usage: backup [-h] [--host HOST] [--port PORT] -u USER -p PASSWORD --database DATABASE outfile

Backup MySQL database.

positional arguments:
  outfile

optional arguments:
  -h, --help            show this help message and exit
  --host HOST
  --port PORT
  -u USER, --user USER
  -p PASSWORD, --password PASSWORD
  --database DATABASE
  -gz, --gzcompress     Compress backup files by gz.

Copyright(r), 2023
```

获取有效参数的代码实际上是这一行：
```
args = parser.parse_args()
```

我们不必捕获异常，parse_args()非常方便的一点在于，如果参数有问题，则它打印出错误信息后，结束进程；如果参数是-h，则它打印帮助信息后，结束进程。只有当参数全部有效时，才会返回一个NameSpace对象，获取对应的参数就把参数名当作属性获取，非常方便。

可见，使用argparse后，解析参数的工作被大大简化了，我们可以专注于定义参数，然后直接获取到有效的参数输入。

### 常用第三方模块

#### requests
我们已经讲解了Python内置的urllib模块，用于访问网络资源。但是，它用起来比较麻烦，而且，缺少很多实用的高级功能。

更好的方案是使用requests。它是一个Python第三方库，处理URL资源特别方便。    

要通过GET访问一个页面，只需要几行代码：
```
>>> import requests
>>> r = requests.get('https://www.douban.com/') # 豆瓣首页
>>> r.status_code
200
>>> r.text
r.text
'<!DOCTYPE HTML>\n<html>\n<head>\n<meta name="description" content="提供图书、电影、音乐唱片的推荐、评论和...'
```

对于带参数的URL，传入一个dict作为params参数：
```
>>> r = requests.get('https://www.douban.com/search', params={'q': 'python', 'cat': '1001'})
>>> r.url # 实际请求的URL
'https://www.douban.com/search?q=python&cat=1001'
```

requests自动检测编码，可以使用encoding属性查看：
```
>>> r.encoding
'utf-8
```

无论响应是文本还是二进制内容，我们都可以用content属性获得bytes对象：
```
>>> r.content
b'<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n...'
```

requests的方便之处还在于，对于特定类型的响应，例如JSON，可以直接获取：
```
>>> r = requests.get('https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%202151330&format=json')
>>> r.json()
{'query': {'count': 1, 'created': '2017-11-17T07:14:12Z', ...
```

需要传入HTTP Header时，我们传入一个dict作为headers参数：
```
>>> r = requests.get('https://www.douban.com/', headers={'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit'})
>>> r.text
'<!DOCTYPE html>\n<html>\n<head>\n<meta charset="UTF-8">\n <title>豆瓣(手机版)</title>...'
```

要发送POST请求，只需要把get()方法变成post()，然后传入data参数作为POST请求的数据：
```
>>> r = requests.post('https://accounts.douban.com/login', data={'form_email': 'abc@example.com', 'form_password': '123456'})
```

requests默认使用application/x-www-form-urlencoded对POST数据编码。如果要传递JSON数据，可以直接传入json参数：
```
params = {'key': 'value'}
r = requests.post(url, json=params) # 内部自动序列化为JSON
```

类似的，上传文件需要更复杂的编码格式，但是requests把它简化成files参数：
```
>>> upload_files = {'file': open('report.xls', 'rb')}
>>> r = requests.post(url, files=upload_files)
```
在读取文件时，注意务必使用'rb'即二进制模式读取，这样获取的bytes长度才是文件的长度。

把post()方法替换为put()，delete()等，就可以以PUT或DELETE方式请求资源。

除了能轻松获取响应内容外，requests对获取HTTP响应的其他信息也非常简单。例如，获取响应头：
```
>>> r.headers
{Content-Type': 'text/html; charset=utf-8', 'Transfer-Encoding': 'chunked', 'Content-Encoding': 'gzip', ...}
>>> r.headers['Content-Type']
'text/html; charset=utf-8'
```

requests对Cookie做了特殊处理，使得我们不必解析Cookie就可以轻松获取指定的Cookie：
```
>>> r.cookies['ts']
'example_cookie_12345'
```

要在请求中传入Cookie，只需准备一个dict传入cookies参数：
```
>>> cs = {'token': '12345', 'status': 'working'}
>>> r = requests.get(url, cookies=cs)
```

最后，要指定超时，传入以秒为单位的timeout参数：
```
>>> r = requests.get(url, timeout=2.5) # 2.5秒后超时
```

## venv
在开发Python应用程序的时候，系统安装的Python3只有一个版本：3.10。所有第三方的包都会被pip安装到Python3的site-packages目录下。

如果我们要同时开发多个应用程序，那这些应用程序都会共用一个Python，就是安装在系统的Python 3。如果应用A需要jinja 2.7，而应用B需要jinja 2.6怎么办？

这种情况下，每个应用可能需要各自拥有一套“独立”的Python运行环境。venv就是用来为一个应用创建一套“隔离”的Python运行环境。

首先，我们假定要开发一个新的项目project101，需要一套独立的Python运行环境，可以这么做：

第一步，创建目录，这里把venv命名为proj101env，因此目录名为proj101env：
```
~$ mkdir proj101env
~$ cd proj101env/
proj101env$
```
第二步，创建一个独立的Python运行环境：
```
proj101env$ python3 -m venv .
```
查看当前目录，可以发现有几个文件夹和一个pyvenv.cfg文件：
```
proj101env$ ls
bin  include  lib  pyvenv.cfg
```
命令python3 -m venv <目录>就可以创建一个独立的Python运行环境。观察bin目录的内容，里面有python3、pip3等可执行文件，实际上是链接到Python系统目录的软链接。

继续进入bin目录，Linux/Mac用source activate，Windows用activate.bat激活该venv环境：
```
proj101env$ cd bin
bin$ source activate
(proj101env) bin$
```
注意到命令提示符变了，有个(proj101env)前缀，表示当前环境是一个名为proj101env的Python环境。

下面正常安装各种第三方包，并运行python命令：
```
(proj101env) bin$ pip3 install jinja2
...
Successfully installed jinja2-xxx
(proj101env) bin$ python3
>>> import jinja2
>>> exit()
```
在venv环境下，用pip安装的包都被安装到proj101env这个环境下，具体目录是proj101env/lib/python3.x/site-packages，因此，系统Python环境不受任何影响。也就是说，proj101env环境是专门针对project101这个应用创建的。

退出当前的proj101env环境，使用deactivate命令：
```
(proj101env) bin$ deactivate
bin$
```
此时就回到了正常的环境，现在pip或python均是在系统Python环境下执行。

完全可以针对每个应用创建独立的Python运行环境，这样就可以对每个应用的Python环境进行隔离。

venv是如何创建“独立”的Python运行环境的呢？原理很简单，就是把系统Python链接或复制一份到venv的环境，用命令source activate进入一个venv环境时，venv会修改相关环境变量，让命令python和pip均指向当前的venv环境。

如果不再使用某个venv，例如proj101env，删除它也很简单。首先确认该venv没有处于“激活”状态，然后直接把整个目录proj101env删掉就行。
