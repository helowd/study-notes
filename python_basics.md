# python基础

[toc]

## 对象

python是一门面向对象的语言，一切皆对象，程序运行中，所有的数据都是存储到内存中然后再运行
对象就是内存中专门用来存储指定数据的一块区域，实际就是一个容器专门用来存储数据，数值、字符串、布尔、none都是对象

对象的结构：每个对象中都要保存三种数据

​	id：标识，用来标识对象的唯一性，每个对象都有唯一的id，就像人的身份证一样，可以通过id()函数来查看id，id由解析器生成的，在cpython中，id就是对象的内存地址，对象一旦创建，id就永远不能改变

​	type：类型，标识当前对象所属的类型，比如int、str、float、bool，类型决定了对象有哪些功能，python是强类型语言，对象一旦创建类型就不能修改，通过type()函数来查看对象类型

​	value：值，就是对象中存储的具体的数据，对于有些对象值可以改变，可变于不可变

变量和对象：变量中存储的是对象的id

类型转化：不是改变对象本身的类型，而是根据当前对象的值创建一个新对象

## 闭包

```python
# 将函数作为返回值返回，也是一种高阶函数
# 通过闭包可以创建一些只有当前函数能访问的变量，可以将一些私有函数藏到闭包中
# 形成闭包的条件：1、函数嵌套 2、将内部函数作为返回值返回 3、内部函数必须要使用到外部函数的变量
# 示例
def fn():
    a = 10
    # 函数内部再定义一个函数
    def inner():
        print("我是fn2", a)
    return inner

# r是一个函数，是调用fn()后返回的函数
#这个函数是在fn()内部定义，并不是全局函数，所以这个函数总是能访问到fn()函数内的变量
r = fn()
r()


# 闭包实现求平均数，让nums变量作用域在函数内，确保数据安全
def make_averager()
	# 创建一个列表，用来保存数值
    nums = []
    # 创建一个函数，用来计算平均值
    def averager(n)
    	# 将n添加到列表中
        nums.append(n)
        # 求平均值
        return sum(nums)/len(nums)
    return averager

averager = make_averager()
print(averager(10))
print(averager(20))
```

## 装饰器

```python
# 本质上是一个闭包
# 修改函数时如果需要修改函数的很多，比较麻烦，并且不方便后期的维护，也违反了开闭原则ocp
# ocp：程序的设计要求开发对程序的扩展，但要关闭对程序的修改
# 我们希望在不修改原函数的情况下，来对函数进行扩展

# 示例
def begin_end(old):
    """用来对其他函数进行扩展，使其他函数可以在执行前打印开始执行,执行后打印执行结束
    参数：old是要扩展的函数对象"""
    def new_function(*args, **kwargs):
        print("开始执行")
        # 把参数传进去
        result = old(*args, **kwargs)
        print("执行结束")
    	return result
    return new_function

# 对fn函数用begin_end函数进行扩展，begin_end()这种函数就是装饰器，同通过装饰器可以在不修改原来函数的情况下对函数进行扩展
f = begin_end(fn)
r = f(11, 22)
print(r)

# 在定义函数时，可以通过@装饰器来使用指定的装饰器，可以同时为一个函数指定多个装饰器，这样函数将会按照由内到外的顺序被装饰
@begin_end
@fn3
def say_hello():
    print("大家好")

sya_hello()


# 装饰器实现权限控制
def login_required(func):
    def inner(*args, **kwargs):
        if username == "root":
            print("欢迎")
            result = func(*args, **kwargs)
            return result
        else:
            return "权限不够"
    return inner

@login_required
def add(a, b):
    return a + b

username = input("请输入用户名：")
result = add(1, 2)
print(result)
```

## 上下文管理器

```python
import pymysql
from pymysql.constants import CLIENT


class ContextManagerMysql():
    """
    上下文管理器一般用在资源释放和回收上面
    """

    def __init__(self):
        self.connection = None
        self.cursor = None

    def __enter__(self):
        print("connecting mysql")
        self.connection = pymysql.connect(host="192.168.50.88", user="root", passwd="123456", port=3306,\
                                          database="python",charset="utf8", client_flag=CLIENT.MULTI_STATEMENTS)
        self.cursor = self.connection.cursor()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """
        该方法有三个参数
        如果with语句正常结束，没有发生异常的时候，三个参数都是None
        如果发生异常，三个参数的值为：异常类型，异常值（异常实例），跟踪记录
        """
        if self.connection:
            print("close mysql connection")
            self.cursor.close()
        # 返回值为真，终止异常；返回值为假，传播异常
        return True


cm = ContextManagerMysql()
with ContextManagerMysql() as cm:
    sql = """create table contextmanager7(id int,name char);"""
    cm.cursor.execute(sql)
    print(cm.cursor.fetchall())

######################################################################################################
# 网络编程 socket，tcp粘包

######################################################################################################
"""epoll（nginx）
1、没有并发数的限制
2、效率提升，不是采用轮询方式，而是回调
3、fd在这里没有限制，使用了共享内存
"""

import pymysql
class ContextManger():
    def __init__(self):
        self.db = None
        self.cursor = None

    def __enter__(self):
        print("connecting mysql..........")
        self.db = pymysql.connect(
            host="192.168.50.88",
            user="root",
            passwd="123456",
            database="python"
        )
        self.cursor = self.db.cursor()
        return self
    #接收三个参数
    def __exit__(self, exc_type, exc_val, exc_tb):
       if self.db:
            print("close mysql...........")
            # 关闭游标连接
            self.cursor.close()
            # 关闭数据库
            self.db.close()
            return True  #返回值为真，终止异常；为假，传播异常


# cm = ContextManger()
with ContextManger() as cm:
    sql = "show tables;"
    # 使用execute执行sql语句
    cm.cursor.execute(sql)
    data = cm.cursor.fetchall()
    print(data)
```

## 类

面向对象编程，代码易于阅读，方便修改维护，容易复用
面向对象的思想：1、找对象	2、搞对象
像数字、字符串等都是python的内置对象，内置对象并不能满足所有的需求，所以在开发中经常需要自定义一些对象
在程序中我们需要根据类来创建对象，类是对象的图纸
int()\floart()\str()\list()\dict()等这些都是类，内置类
a = int(10) 创建一个int类的实例，等价于a = 10

类也是一个对象，是用来创建对象的对象，类是一个type类型的对象
对象中的变量称为属性，语法：对象.属性名 = 属性值
对象中函数称为方法，语法：对象.方法名()

创建对象的流程：1、创建一个变量mc	2、在内存中创建一个新对象	3、init方法执行	4、将对象的id赋值给变量

属性和方法的查找流程：当调用一个对象的属性时，解析器会先在当前对象中寻找是否含有该属性
	如果有，则返回当前的对象的属性值
	如果没有，则去当前对象的类对象中去寻找，如果有则返回类对象的属性值，没有则报错

示例：

```python
class MyClass():
	pass

mc = MyClass()  # mc就是通过MyClass创建的对象，mc是MyClass的实例
result = isinstance(mc, MyClass)   # isinstance用来检查一个对象是否是一个类的实例，返回布尔类型值

# 定义一个人类
class Person():
   	print("Person代码块中的代码")
    
    # 在类的代码块中，我们可以定义变量和函数
    # 在类中所定义的变量，将会成为所有实例的公共属性，所有该类实例都可以访问这些变量
    name = "swk"
    
    # 在类中可以定义一些特殊方法（魔术方法），特殊方法都是以__开头__结尾的方法，特殊方法不需要自己调用
    # 特殊方法会在特殊的时刻自动调用
    # 调用类创建对象时，类后边的所有参数都会依次传入init方法中
    def __init__(self, name):
        # 通过self向新建的对象中初始化属性
        print("init方法执行了")
        self.name = name
   
    # 如果函数调用，调用时传几个参数，就会有几个实参
    # 但如果是方法调用，默认传递一个参数（一般命名为self，表示是哪个对象调用的），所以方法中至少要定义一个形参
    # 方法可以被所有的该类实例所调用
    def say_hello(self):
        pritn("hello%s"%self.name)
   
p = Person()
p.say_hello()  # 调用方法
```

## @property装饰器
属性命名以单下划线开头，表示是受保护的属性，可以通过getter访问和setter修改
```python
class Person(object):

    def __init__(self, name, age):
        self._name = name
        self._age = age

    # 访问器 - getter方法
    @property
    def name(self):
        return self._name

    # 访问器 - getter方法
    @property
    def age(self):
        return self._age

    # 修改器 - setter方法
    @age.setter
    def age(self, age):
        self._age = age

    def play(self):
        if self._age <= 16:
            print('%s正在玩飞行棋.' % self._name)
        else:
            print('%s正在玩斗地主.' % self._name)


def main():
    person = Person('王大锤', 12)
    person.play()
    person.age = 22
    person.play()
    # person.name = '白元芳'  # AttributeError: can't set attribute


if __name__ == '__main__':
    main()
```

## __slots__魔术方法
python为动态语言，允许程序运行时给对象绑定新的属性或方法．
在类中定义__slots__能限定对象只能绑定某些属性，但对子类不起作用
```python
class Person(object):

    # 限定Person对象只能绑定_name, _age和_gender属性
    __slots__ = ('_name', '_age', '_gender')

    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def name(self):
        return self._name

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, age):
        self._age = age

    def play(self):
        if self._age <= 16:
            print('%s正在玩飞行棋.' % self._name)
        else:
            print('%s正在玩斗地主.' % self._name)


def main():
    person = Person('王大锤', 22)
    person.play()
    person._gender = '男'
    # AttributeError: 'Person' object has no attribute '_is_gay'
    # person._is_gay = True
```

## 静态方法　@staticmethod
当创建一个三角形类，可以定义一个验证三条边是否合法的方法作为静态方法
**__init__()方法只会在创建对象时被调用**
```python
from math import sqrt


class Triangle(object):

    def __init__(self, a, b, c):
        self._a = a
        self._b = b
        self._c = c

    @staticmethod
    def is_valid(a, b, c):
        return a + b > c and b + c > a and a + c > b

    def perimeter(self):
        return self._a + self._b + self._c

    def area(self):
        half = self.perimeter() / 2
        return sqrt(half * (half - self._a) *
                    (half - self._b) * (half - self._c))


def main():
    a, b, c = 3, 4, 5
    # 静态方法和类方法都是通过给类发消息来调用的
    if Triangle.is_valid(a, b, c):
        t = Triangle(a, b, c)
        print(t.perimeter())
        # 也可以通过给类发消息来调用对象方法但是要传入接收消息的对象作为参数
        # print(Triangle.perimeter(t))
        print(t.area())
        # print(Triangle.area(t))
    else:
        print('无法构成三角形.')


if __name__ == '__main__':
    main()
```

## 类方法　@classmethod
```python
from time import time, localtime, sleep


class Clock(object):
    """数字时钟"""

    def __init__(self, hour=0, minute=0, second=0):
        self._hour = hour
        self._minute = minute
        self._second = second

    @classmethod
    def now(cls):
        ctime = localtime(time())
        return cls(ctime.tm_hour, ctime.tm_min, ctime.tm_sec)

    def run(self):
        """走字"""
        self._second += 1
        if self._second == 60:
            self._second = 0
            self._minute += 1
            if self._minute == 60:
                self._minute = 0
                self._hour += 1
                if self._hour == 24:
                    self._hour = 0

    def show(self):
        """显示时间"""
        return '%02d:%02d:%02d' % \
               (self._hour, self._minute, self._second)


def main():
    # 通过类方法创建对象并获取系统时间
    clock = Clock.now()
    while True:
        print(clock.show())
        sleep(1)
        clock.run()


if __name__ == '__main__':
    main()
```

## 继承
子类继承父类后，除了继承父类提供的属性和方法，还可以定义自己特有的属性和方法
```python
class Person(object):
    """人"""

    def __init__(self, name, age):
        self._name = name
        self._age = age

    @property
    def name(self):
        return self._name

    @property
    def age(self):
        return self._age

    @age.setter
    def age(self, age):
        self._age = age

    def play(self):
        print('%s正在愉快的玩耍.' % self._name)

    def watch_av(self):
        if self._age >= 18:
            print('%s正在观看爱情动作片.' % self._name)
        else:
            print('%s只能观看《熊出没》.' % self._name)


class Student(Person):
    """学生"""

    def __init__(self, name, age, grade):
        super().__init__(name, age)
        self._grade = grade

    @property
    def grade(self):
        return self._grade

    @grade.setter
    def grade(self, grade):
        self._grade = grade

    def study(self, course):
        print('%s的%s正在学习%s.' % (self._grade, self._name, course))


class Teacher(Person):
    """老师"""

    def __init__(self, name, age, title):
        super().__init__(name, age)
        self._title = title

    @property
    def title(self):
        return self._title

    @title.setter
    def title(self, title):
        self._title = title

    def teach(self, course):
        print('%s%s正在讲%s.' % (self._name, self._title, course))


def main():
    stu = Student('王大锤', 15, '初三')
    stu.study('数学')
    stu.watch_av()
    t = Teacher('骆昊', 38, '砖家')
    t.teach('Python程序设计')
    t.watch_av()


if __name__ == '__main__':
    main()
```

## 多态
子类在继承了父类的方法后，可以重写父类的方法，通过方法重写可以让父类的同一个行为在子类拥有不同的实现版本，当我们调用这个经过子类重写的方法时，不同的子类对象会表现出不同的行为，这个就是多态（poly-morphism）。
**子类有init方法时会执行自己的init，相当于重写了，如果子类没有则会调用父类的init方法**
```python
from abc import ABCMeta, abstractmethod


class Pet(object, metaclass=ABCMeta):
    """宠物"""

    def __init__(self, nickname):
        self._nickname = nickname

    @abstractmethod
    def make_voice(self):
        """发出声音"""
        pass


class Dog(Pet):
    """狗"""

    def make_voice(self):
        print('%s: 汪汪汪...' % self._nickname)


class Cat(Pet):
    """猫"""

    def make_voice(self):
        print('%s: 喵...喵...' % self._nickname)


def main():
    pets = [Dog('旺财'), Cat('凯蒂'), Dog('大黄')]
    for pet in pets:
        pet.make_voice()


if __name__ == '__main__':
    main()
```
在上面的代码中，我们将Pet类处理成了一个**抽象类**，所谓抽象类就是不能够创建对象的类，这种类的存在就是专门为了让其他类去继承它。Python从语法层面并没有像Java或C#那样提供对抽象类的支持，但是我们可以通过abc模块的ABCMeta元类和abstractmethod包装器来达到抽象类的效果，如果一个类中存在抽象方法那么这个类就不能够实例化（创建对象）。上面的代码中，Dog和Cat两个子类分别对Pet类中的make_voice抽象方法进行了重写并给出了不同的实现版本，当我们在main函数中调用该方法时，这个方法就表现出了多态行为（同样的方法做了不同的事情）。
