# golang语法

## 目录
<!-- vim-markdown-toc GFM -->

* [code style](#code-style)
* [命令](#命令)
* [特性](#特性)
* [流程控制](#流程控制)
    * [if](#if)
    * [for](#for)
    * [switch](#switch)
* [函数](#函数)
    * [指针](#指针)
    * [defer](#defer)
    * [panic](#panic)
    * [recover](#recover)
    * [init函数](#init函数)
* [数据](#数据)
    * [输出](#输出)
    * [常量](#常量)
    * [变量](#变量)
    * [类型转换](#类型转换)
    * [new关键字分配内存](#new关键字分配内存)
    * [make](#make)
    * [数组](#数组)
    * [切片](#切片)
        * [扩展切片](#扩展切片)
        * [append](#append)
        * [删除](#删除)
        * [切片副本](#切片副本)
        * [二维切片（todo）](#二维切片todo)
    * [映射](#映射)
        * [访问](#访问)
        * [删除delete](#删除delete)
        * [循环](#循环)
    * [结构体](#结构体)
        * [结构嵌入](#结构嵌入)
        * [用json编码和解码结构](#用json编码和解码结构)
* [日志处理](#日志处理)
    * [log包](#log包)
    * [记录到文件](#记录到文件)
    * [记录框架](#记录框架)
* [包](#包)
* [模块](#模块)
    * [go.mod](#gomod)
* [方法](#方法)
    * [方法中的指针](#方法中的指针)
    * [嵌入方法](#嵌入方法)
    * [重载方法](#重载方法)
    * [封装](#封装)
* [接口](#接口)
    * [实现字符串接口](#实现字符串接口)
    * [扩展现有实现](#扩展现有实现)
    * [服务器api](#服务器api)
* [goroutine](#goroutine)
* [channel](#channel)
    * [有缓冲channel](#有缓冲channel)
    * [channel方向](#channel方向)
    * [多路复用](#多路复用)
    * [select](#select)
* [泛型 generics](#泛型-generics)
* [闭包 closures](#闭包-closures)
* [go web项目规范](#go-web项目规范)
* [test](#test)

<!-- vim-markdown-toc -->
## code style

gofmt程序能自动处理大部分格式问题

1. 使用tab缩进
2. 不限制行长度，也可以进行折行并插入适当缩进
3. 控制结构if for switch在语法上不需要使用圆括号
4. 块注释/**/ 和 行注释//。块注释主要用作包的注释，也可以用来禁止代码。godoc能提取包中的文档内容
5. 命名：包名用纯小写字母，接口命名应该加上er后缀，其他使用驼峰命名（MixedCaps大驼峰，mixedCaps小驼峰）
6. go以分号结束语句，一行中的多个语句需要用分号隔开，但是在标识符后词法分析器会自动插入分号

## 命令

go run  会执行两项操作，先编译成功再执行  
go build  仅仅把源码编程成可执行文件，不执行  
go get 下载和安装远程包或模块，以及相关依赖  
go test 单元测试，文件名格式 func_name_test.go，依赖testing包
go mod init 初始化一个新go模块，会在当前目录创建go.mod文件，用于管理项目依赖关系  
go mod tidy 移除未使用的依赖，整理和更新模块的依赖关系，更新go.mod和go.sum文件  
go mod edit 命令行方式编辑go.mod文件  
go clean -modcache  删除下载好的模块依赖  
go install 将套件编译成.a.file, main套件则编译成可执行档（路径在$GOPATH/bin中）  而有了第一项功能，在下次编译的时候，就不会将套件的程式码重新编译，而是直接用编译好的.a file。而.a file就位于GOPATH/pkg里面  
go list -f '{{.Target}}'  查看当前包的安装路径  
go work  用来管理工作区，达到跨模块编辑和运行程序  
go clean -modcache  清除已经下载的依赖模块

## 特性

基本类型：数字、字符串和布尔值  
聚合类型：数组和结构  
引用类型：指针、切片、映射、函数和通道  
接口类型：接口

在go中，如果你不对变量初始化，所有数据类型都有默认值  
int 类型的 0（及其所有子类型，如 int64）  
float32 和 float64 类型的 +0.000000e+000  
bool 类型的 false  
string 类型的空值

GOROOT为golang安装路径，例如/usr/local/go，存放了官方的模块  
GOPATH变量为工作区路径，存放了第三方模块，每个工作区都包含三个基本文件夹：

```
bin：包含应用程序中的可执行文件。
src：包括位于工作站中的所有应用程序源代码。
pkg：包含可用库的已编译版本。 编译器可以链接这些库，而无需重新编译它们。
```
当采用go modules时，下载下来的第三方模块会放到GOPATH/pkg/mod文件夹中

```golang
// main表示一个包，包是一组常用的源代码文件。这条语句表示创建的是一个可执行程序，每个可执行程序都应该是main包的一部分
package main

// import能够让程序可以访问其他包中的代码，导入fmt包能够让程序调用包中函数实现打印功能
// 如果导入的包未被使用，代码编译时会报错
import "fmt"

// func 语句是用于声明函数的保留字。 第一个函数名为“main”，因为它是程序的起始点。 整个 package main 中只能有一个 main
// () 函数（在第一行中定义的那个）。 在 main() 函数中，你调用了 fmt 包中的 Println 函数。 你发送了你希望在屏幕上看到的文本消息。
func main() {
 fmt.Println("Hello World!")
}
```

## 流程控制

Go 不再使用 do 或 while 循环

### if

num 变量存储从 givemeanumber() 函数返回的值，并且该变量在所有 if 分支中可用

```golang
package main

import "fmt"

func givemeanumber() int {
    return -1
}

func main() {
    if num := givemeanumber(); num < 0 {
        fmt.Println(num, "is negative")
    } else if num < 10 {
        fmt.Println(num, "has only one digit")
    } else {
        fmt.Println(num, "has multiple digits")
    }
}
```

### for

```golang
// Like a C for
for init; condition; post { }

// Like a C while
for condition { }

// Like a C for(;;)
for { }

// 使用下标遍历
sum := 0
for i := 0; i < 10; i++ {
    sum += i
}

// range来遍历
for key, value := range oldMap {
    newMap[key] = value
}

// 使用空白标识符下划线丢弃第一个值
sum := 0
for _, value := range array {
    sum += value
}

// 不能使用++ --进行变量赋值
```

### switch

case语句块中的fallthroughg关键字可以使逻辑进入下一个case而不经过验证

```golang
// FizzBuzz
package main

import (
    "fmt"
    "strconv"
)

func fizzbuzz(num int) string {
    switch {
    case num%15 == 0:
        return "FizzBuzz"
    case num%3 == 0:
        return "Fizz"
    case num%5 == 0:
        return "Buzz"
    }
    return strconv.Itoa(num)
}

func main() {
    for num := 1; num <= 100; num++ {
        fmt.Println(fizzbuzz(num))
    }
}

// 表达式无需为常量或者整数，若没有表达式则匹配true
// case可以通过逗号分隔来列举相同处理条件
func shouldEscape(c byte) bool {
    switch c {
    case ' ', '?', '&', '=', '#', '+', '%':
        return true
    }
    return false
}

// 结合for循环标签
Loop:
    for n := 0; n < len(src); n += size {
        switch {
        case src[n] < sizeOne:
            if validateOnly {
                break
            }
            size = 1
            update(src[n])

        case src[n] < sizeTwo:
            if n+1 >= len(src) {
                err = errShortInput
                break Loop  // 跳出整个loop循环，而不是仅跳出switch
            }
            if validateOnly {
                break
            }
            size = 2
            update(src[n] + src[n+1]<<shift)

        default:
            fmt.print("no match...")
        }
    }

// 判断接口变量的动态类型
var t interface{}
t = functionOfSomeType()
switch t := t.(type) {
default:
    fmt.Printf("unexpected type %T\n", t)     // %T prints whatever type t has
case bool:
    fmt.Printf("boolean %t\n", t)             // t has type bool
case int:
    fmt.Printf("integer %d\n", t)             // t has type int
case *bool:
    fmt.Printf("pointer to boolean %t\n", *t) // t has type *bool
case *int:
    fmt.Printf("pointer to integer %d\n", *t) // t has type *int
}
```

## 函数

所有可执行程序都有mian()函数，并且只有一个，它是程序的起点

### 指针

将值传递给函数时，该函数中的每个更改都不会影响调用方。 Go 是“按值传递”编程语言。 每次向函数传递值时，Go 都会使用该值并创建本地副本（内存中的新变量）

指针是包含另一个变量的内存地址的变量。 向函数发送指针时，不是传递值，而是传递内存地址，因此，对该变量所做的每个更改都会影响调用方。

& 运算符使用其后对象的地址。

\* 运算符取消引用指针。 你可以前往指针中包含的地址访问其中的对象。

```golang
package main

import "fmt"

func main() {
    firstName := "John"
    updateName(&firstName)
    fmt.Println(firstName)
}

func updateName(name *string) {
    *name = "David"
}
// 输出现在显示的是 David，而不是 John
// 首先要做的就是修改函数的签名，以指明你要接收指针。 为此，请将参数类型从 string 更改为 *string。 （后者仍是字符串，但现在它是指向字符串 的 指针。）然后，将新值分配给该变量时，需要在该变量的左侧添加星号 (*) 以暂停该变量的值。 调用 updateName 函数时，系统不会发送值，而是发送变量的内存地址。 变量左侧的 & 符号指示变量的地址。
```

### defer
defer函数按后进先出顺序执行
```golang
// 当defer语句被求值时，延迟函数的参数也会被求值，这里打印0
func a() {
    i := 0
    defer fmt.Println(i)
    i++
    return
}

// 延迟函数在周围函数返回后递增返回值 i 。因此，该函数返回 2
func c() (i int) {
    defer func() { i++ }()
    return 1
}

func exampleFunction() {
    // 在函数结束时执行清理操作
    defer cleanup()

    // 打开文件
    file := openFile("example.txt")
    // 确保在函数结束时关闭文件
    defer file.Close()

    // 一些其他操作
    // ...

    // 这里发生了错误，但清理操作仍会执行
    if isError {
        return
    }

    // 其他操作
    // ...
}

func cleanup() {
    // 清理操作
}

func openFile(filename string) *File {
    // 打开文件并返回文件对象
    // ...
}
```

### panic

内置函数panic可以停止go程序的正常控制流，当你使用 panic 调用时，任何延迟的函数调用都将正常运行，记录日志然后程序退出

```golang
package main

import "fmt"

func main() {
    f()
    fmt.Println("Returned normally from f.")
}

func f() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered in f", r)
        }
    }()
    fmt.Println("Calling g.")
    g(0)
    fmt.Println("Returned normally from g.")
}

func g(i int) {
    if i > 3 {
        fmt.Println("Panicking!")
        panic(fmt.Sprintf("%v", i))
    }
    defer fmt.Println("Defer in g", i)
    fmt.Println("Printing in g", i)
    g(i + 1)
}

// 输出：
Calling g.
Printing in g 0
Printing in g 1
Printing in g 2
Printing in g 3
Panicking!
Defer in g 3
Defer in g 2
Defer in g 1
Defer in g 0
Recovered in f 4
Returned normally from f.
```

### recover
Recover是一个内置函数，可以重新获得对发生恐慌的 goroutine 的控制。恢复仅在延迟函数内有用。在正常执行期间，调用recover将返回nil并且没有其他效果。如果当前 goroutine 发生恐慌，则调用恢复将捕获为恐慌提供的值并恢复正常执行。

### init函数

每个源文件都可以通过定义自己的无参数 init 函数来设置一些必要的状态，每个文件都可以拥有多个init函数

```golang
func init() {
    if user == "" {
        log.Fatal("$USER not set")
    }
    if home == "" {
        home = "/home/" + user
    }
    if gopath == "" {
        gopath = home + "/go"
    }
    // gopath may be overridden by --gopath flag on command line.
    flag.StringVar(&gopath, "gopath", gopath, "override default GOPATH")
}
```

## 数据

:= 语法用来声明并赋值一个变量，用在函数内部，可以代替var

### 输出

```golang
// 以下这些语句输出结果都一样
fmt.Printf("Hello %d\n", 23)  // 使用 fmt.Printf 函数，它允许您使用格式化字符串来构造输出。
fmt.Fprint(os.Stdout, "Hello ", 23, "\n")  // 允许您将输出写入指定的 io.Writer（在此例中是 os.Stdout，标准输出）
fmt.Println("Hello", 23)  // 它会将参数以空格分隔，然后附加一个换行符
fmt.Println(fmt.Sprint("Hello ", 23))  // 使用 fmt.Sprint 函数将 "Hello " 和整数 23 合并为一个字符串。然后使用 fmt.Println 打印合并后的字符串，并附加一个换行符 \n。

// 根据实参类型决定打印结果
var x uint64 = 1<<64 - 1
fmt.Printf("%d %x; %d %x\n", x, x, int64(x), int64(x))
// 输出：18446744073709551615 ffffffffffffffff; -1 -1
```

### 常量

常量是不变量  
无类型常量采用上下文所需类型

```golang
// 不能使用冒号等于号来声明常量
const HTTPStatusOK = 200

// iota创建连续增加的常量
type ByteSize float64

const (
    _           = iota // ignore first value by assigning to blank identifier
    KB ByteSize = 1 << (10 * iota)
    MB
    GB
    TB
    PB
    EB
    ZB
    YB
)
```

### 变量

如果声明了一个变量但未使用，go会抛出错误  
在声明函数外的变量时，必须使用 var 关键字执行此操作

```golang
var (
    home   = os.Getenv("HOME")
    user   = os.Getenv("USER")
    gopath = os.Getenv("GOPATH")
)

// var关键字用来声明变量
var firstName, lastName string
var age int

// 初始化变量
var (
    firstName string = "John"
    lastName  string = "Doe"
    age       int    = 32
)

// 也可以不指定类型，让go自动识别
var (
    firstName = "John"
    lastName  = "Doe"
    age       = 32
)

// 单行初始化
var (
    firstName, lastName, age = "John", "Doe", 32
)
```

### 类型转换

```golang
var integer16 int16 = 127
var integer32 int32 = 32767
fmt.Println(int32(integer16) + integer32)

// 利用strconv包转换
package main

import (
    "fmt"
    "strconv"
)

func main() {
    i, _ := strconv.Atoi("-42")
    s := strconv.Itoa(-42)
    fmt.Println(i, s)
}
```

### new关键字分配内存
new 用于创建一个新的零值对象，并返回一个指向该对象的指针。  
new 主要用于创建值类型（如整数、浮点数、结构体等）的实例。  
new 不会初始化内存，所以返回的对象的字段或元素将具有其类型的零值。

```golang
i := new(int)      // 创建一个整数指针，*i 指向的整数值为 0
person := new(struct{ name string }) // 创建一个匿名结构体指针，name 字段为空字符串
```

表达式 new(File) 和 &File{} 是等价的

### make
make 用于创建切片、映射和通道等引用类型的对象，返回一个已初始化的对象。  
make 会分配内存并初始化数据结构，以便对象可以立即使用。  
make 只能用于切片、映射和通道的创建，因为它们需要内部数据结构的初始化。

```golang
slice := make([]int, 5, 10)  // 创建一个长度为 5，容量为 10 的切片
m := make(map[string]int)    // 创建一个空映射
ch := make(chan int)         // 创建一个整数类型的通道
```

### 数组
数组是一种特定类型且长度固定的数据结构，必须在创建时定义大小  
将一个数组赋予另一个数组会复制其所有元素。  
特别地，若将某个数组传入某个函数，它将接收到该数组的一份副本而非指针。  

```golang
// 初始化数组
var a [3]int
cities := [5]string{"New York", "Paris", "Berlin", "Madrid"}
cities := [...]string{"New York", "Paris", "Berlin", "Madrid"}
numbers := [...]int{99: -1}

// 二维数组
func main() {
    var twoD [3][5]int
    for i := 0; i < 3; i++ {
        for j := 0; j < 5; j++ {
            twoD[i][j] = (i + 1) * (j + 1)
        }
        fmt.Println("Row", i, twoD[i])
    }
    fmt.Println("\nAll at once:", twoD)
}

// 三维数组
func main() {
    var threeD [3][5][2]int
    for i := 0; i < 3; i++ {
        for j := 0; j < 5; j++ {
            for k := 0; k < 2; k++ {
                threeD[i][j][k] = (i + 1) * (j + 1) * (k + 1)
            }
        }
    }
    fmt.Println("\nAll at once:", threeD)
}
```

### 切片

切片的大小是动态可变的。  
切片对数组进行了封保存了对底层数组的引用，若某个函数将一个切片作为参数传入，则它对该切片元素的修改对调用者而言同样可见，这可以理解为传递了底层数组的指针

#### 扩展切片

```golang
func main() {
    // 初始化切片
    months := []string{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
    quarter2 := months[3:6]
    quarter2Extended := quarter2[:4]
    fmt.Println(quarter2, len(quarter2), cap(quarter2))
    fmt.Println(quarter2Extended, len(quarter2Extended), cap(quarter2Extended))
}
// 输出：
// [April May June] 3 9
// [April May June July] 4 9
```

#### append

当切片容量不足以容纳更多元素时，Go 的容量将翻倍，它将新建一个具有新容量的基础数组

```golang
func main() {
    var numbers []int
    for i := 0; i < 10; i++ {
        numbers = append(numbers, i)
        fmt.Printf("%d\tcap=%d\t%v\n", i, cap(numbers), numbers)
    }
}
// 输出
// 0       cap=1   [0]
// 1       cap=2   [0 1]
// 2       cap=4   [0 1 2]
// 3       cap=4   [0 1 2 3]
// 4       cap=8   [0 1 2 3 4]
// 5       cap=8   [0 1 2 3 4 5]
// 6       cap=8   [0 1 2 3 4 5 6]
// 7       cap=8   [0 1 2 3 4 5 6 7]
// 8       cap=16  [0 1 2 3 4 5 6 7 8]
// 9       cap=16  [0 1 2 3 4 5 6 7 8 9]

// 将一个切片追加到另一个切片中
x := []int{1,2,3}
y := []int{4,5,6}
x = append(x, y...)
fmt.Println(x)
// 如果没有 ...，它就会由于类型错误而无法编译，因为 y 不是 int 类型的。
```

#### 删除

go没有内置函数删除切片中的元素

```golang
func main() {
    letters := []string{"A", "B", "C", "D", "E"}
    remove := 2

 if remove < len(letters) {

  fmt.Println("Before", letters, "Remove ", letters[remove])

  letters = append(letters[:remove], letters[remove+1:]...)

  fmt.Println("After", letters)
 }

}

// 输出：
// Before [A B C D E] Remove  C
// After [A B D E]
```

#### 切片副本

Go 具有内置函数 copy(dst, src []Type) 用于创建切片的副本。  
为何要创建副本？ 更改切片中的元素时，基础数组将随之更改。 引用该基础数组的任何其他切片都会受到影响。

```golang
func main() {
    letters := []string{"A", "B", "C", "D", "E"}
    fmt.Println("Before", letters)

    slice1 := letters[0:2]

    slice2 := make([]string, 3)
    copy(slice2, letters[1:4])

    slice1[1] = "Z"

    fmt.Println("After", letters)
    fmt.Println("Slice2", slice2)
}
// 输出：
// Before [A B C D E]
// After [A Z C D E]
// Slice2 [B C D]
```

请注意 slice1 中的更改如何影响基础数组，但它并未影响新的 slice2。

#### 二维切片（todo）

### 映射

映射中所有的键都必须具有相同的类型，它们的值也是如此。 不过，可对键和值使用不同的类型。 例如，键可以是数字，值可以是字符串

```golang
// 初始化
var timeZone = map[string]int{
    "UTC":  0*60*60,
    "EST": -5*60*60,
    "CST": -6*60*60,
    "MST": -7*60*60,
    "PST": -8*60*60,
}

// make创建空映射
studentsAge := make(map[string]int)

// 不存在的键来取值，就会返回与该映射中项的类型对应的零值
attended := map[string]bool{
    "Ann": true,
    "Joe": true,
    ...
}
```

#### 访问

在 Go 中，映射的下标表示法可生成两个值。 第一个是项的值。 第二个是指示键是否存在的布尔型标志

```golang
func main() {
    studentsAge := make(map[string]int)
    studentsAge["john"] = 32
    studentsAge["bob"] = 31

    age, exist := studentsAge["christy"]
    if exist {
        fmt.Println("Christy's age is", age)
    } else {
        fmt.Println("Christy's age couldn't be found")
    }
}
// 输出
// Christy's age couldn't be found
```

#### 删除delete

如果你尝试删除不存在的项，Go 不会执行 panic

```golang
func main() {
    studentsAge := make(map[string]int)
    studentsAge["john"] = 32
    studentsAge["bob"] = 31
    delete(studentsAge, "john")
    fmt.Println(studentsAge)
}
// 输出
// map[bob:31]
```

#### 循环

```golang
func main() {
    studentsAge := make(map[string]int)
    studentsAge["john"] = 32
    studentsAge["bob"] = 31
    for name, age := range studentsAge {
        fmt.Printf("%s\t%d\n", name, age)
    }
}
```

### 结构体

```golang
type Employee struct {
    ID        int
    FirstName string
    LastName  string
    Address   string
}

func main() {
    employee := Employee{LastName: "Doe", FirstName: "John"}
    fmt.Println(employee)
    employeeCopy := &employee
    employeeCopy.FirstName = "David"
    fmt.Println(employee)
}
// 输出
// {0 John Doe }
// {0 David Doe }
```

#### 结构嵌入

```golang
type Person struct {
    ID        int
    FirstName string
    LastName  string
    Address   string
}

type Employee struct {
    Information Person
    ManagerID   int
}

// 引用
var employee Employee
employee.Information.FirstName = "John"

// 或
// 请注意如何在无需指定 Person 字段的情况下访问 Employee 结构中的 FirstName 字段，因为它会自动嵌入其所有字段。 但在你初始化结构时，必须明确要给哪个字段分配值。
type Employee struct {
    Person
    ManagerID int
}

type Contractor struct {
    Person
    CompanyID int
}

func main() {
    employee := Employee{
        Person: Person{
            FirstName: "John",
        },
    }
    employee.LastName = "Doe"
    fmt.Println(employee.FirstName)
}
```

#### 用json编码和解码结构

编码成json：json.Marshal  
把json解码：json.Unmarshal

```golang
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    ID        int
    FirstName string `json:"name"`
    LastName  string
    Address   string `json:"address,omitempty"`  // omitempty表示json编码时，如果address为空则忽略这个字段
}

type Employee struct {
    Person
    ManagerID int
}

type Contractor struct {
    Person
    CompanyID int
}

func main() {
    employees := []Employee{
        Employee{
            Person: Person{
                LastName: "Doe", FirstName: "John",
            },
        },
        Employee{
            Person: Person{
                LastName: "Campbell", FirstName: "David",
            },
        },
    }

    data, _ := json.Marshal(employees)
    fmt.Printf("%s\n", data)

    var decoded []Employee
    json.Unmarshal(data, &decoded)
    fmt.Printf("%v", decoded)
}
// 输出
// [{"ID":0,"name":"John","LastName":"Doe","ManagerID":0},{"ID":0,"name":"David","LastName":"Campbell","ManagerID":0}]
// [{{0 John Doe } 0} {{0 David Campbell } 0}]
```

## 日志处理

编写程序时，需要考虑程序失败的各种方式，并且需要管理失败。 无需让用户看到冗长而混乱的堆栈跟踪错误。 让他们看到有关错误的有意义的信息更好。

```golang
// fmt.Errorf()
func getInformation(id int) (*Employee, error) {
    employee, err := apiCallEmployee(1000)
    if err != nil {
        return nil, fmt.Errorf("Got an error when getting the employee information: %v", err)
    }
    return employee, nil
}

// errors.New()
var ErrNotFound = errors.New("Employee not found!")

func getInformation(id int) (*Employee, error) {
    if id != 1001 {
        return nil, ErrNotFound
    }

    employee := Employee{LastName: "Doe", FirstName: "John"}
    return &employee, nil
}

// errors.Is()
employee, err := getInformation(1000)
if errors.Is(err, ErrNotFound) {
    fmt.Printf("NOT FOUND: %v\n", err)
} else {
    fmt.Print(employee)
}
```

### log包

```golang
// 默认打印时间
log.Print("Hey, I'm a log!")

// 打印错误并退出程序
log.Fatal("Hey, I'm an error log!")
log.Panic("Hey, I'm an error log!")

// 日志消息加前缀，只需设置一次
log.SetPrefix("main(): ")
```

### 记录到文件

运行前面的代码时，在控制台中看不到任何内容。 在目录中，你应看到一个名为 info.log 的新文件，其中包含使用 log.Print() 函数发送的日志

```golang
package main

import (
    "log"
    "os"
)

func main() {
    file, err := os.OpenFile("info.log", os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
    if err != nil {
        log.Fatal(err)
    }

    defer file.Close()

    log.SetOutput(file)
    log.Print("Hey, I'm a log!")
}
```

### 记录框架

增强处理日志的能力，记录框架有Logrus、zerolog、zap、Apex等

```golang
package main

import (
    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func main() {
    zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

    log.Debug().
        Int("EmployeeID", 1001).
        Msg("Getting employee information")

    log.Debug().
        Str("Name", "John").
        Send()
}
// 输出：
// {"level":"debug","EmployeeID":1001,"time":1609855731,"message":"Getting employee information"}
// {"level":"debug","Name":"John","time":1609855731}
```

## 包
当你使用 main 包时，程序将生成独立的可执行文件。 但当程序不是 main 包的一部分时，Go 不会生成二进制文件。 它生成包存档文件（具有 .a 扩展名的文件）

如需将某些内容设为专用内容，请以小写字母开始。
如需将某些内容设为公共内容，请以大写字母开始。

只能从包内调用 logMessage 变量。
可以从任何位置访问 Version 变量。 建议你添加注释来描述此变量的用途。 （此描述适用于包的任何用户。）
只能从包内调用 internalSum 函数。
可以从任何位置访问 Sum 函数。 建议你添加注释来描述此函数的用途。

```golang
package calculator

var logMessage = "[LOG]"

// Version of calculator
var Version = "1.0"

func internalSum(number int) int {
 return number - 1
}

// Sum two integer numbers
func Sum(number1, number2 int) int {
 return number1 + number2
}
```

## 模块
Go 模块通常包含可提供相关功能的包。 包的模块还指定了 Go 运行你组合在一起的代码所需的上下文。 此上下文信息包括编写代码时所用的 Go 版本

### go.mod
```golang
module example.com/hello

go 1.16

// 使用本地模块
replace example.com/greetings => ../greetings

// 指定远程模块的版本（相当于git仓库的tag） 
require example.com/greetings v1.1.0
```

## 方法
方法是一种特殊的函数，必须在函数名称之前加入一个额外的参数。 此额外参数称为“接收方”。
```golang
// 声明方法的语法
func (variable type) MethodName(parameters ...) {
    // method functionality
}

type triangle struct {
    size int
}

func (t triangle) perimeter() int {
    return t.size * 3
}

// 声明其他类型的语法
type upperstring string

func (s upperstring) Upper() string {
    return strings.ToUpper(string(s))
}

func main() {
    s := upperstring("Learning Go!")
    fmt.Println(s)
    fmt.Println(s.Upper())
}
```

### 方法中的指针
有时，方法需要更新变量。 或者，如果方法的参数太大，你可能希望避免复制它，这时可以用指针传递变量的地址
```golang
func (t *triangle) doubleSize() {
    t.size *= 2
}

func main() {
    t := triangle{3}
    t.doubleSize()
    fmt.Println("Size:", t.size)
    fmt.Println("Perimeter:", t.perimeter())
}
// 输出：
// Size: 6
// Perimeter: 18
```

### 嵌入方法
将之前声明的三角形结构放到新的结构里使用
```golang
type coloredTriangle struct {
    triangle
    color string
}

func main() {
    t := coloredTriangle{triangle{3}, "blue"}
    fmt.Println("Size:", t.size)
    fmt.Println("Perimeter", t.perimeter())
}

// 包装器
func (t coloredTriangle) perimeter() int {
    return t.triangle.perimeter()
}
```

### 重载方法
同一种方法不同的接收方
```golang
func (t coloredTriangle) perimeter() int {
    return t.size * 3 * 2
}

func main() {
    t := coloredTriangle{triangle{3}, "blue"}
    fmt.Println("Size:", t.size)
    fmt.Println("Perimeter (colored)", t.perimeter())
    fmt.Println("Perimeter (normal)", t.triangle.perimeter())
}

// 输出：
// Size: 3
// Perimeter (colored) 18
// Perimeter (normal) 9
```

### 封装
只能隐藏来自其他程序包的实现详细信息，而不能隐藏程序包本身。  
新程序包 geometry
```golang
package geometry

type Triangle struct {
    size int
}

func (t *Triangle) doubleSize() {
    t.size *= 2
}

func (t *Triangle) SetSize(size int) {
    t.size = size
}

func (t *Triangle) Perimeter() int {
    t.doubleSize()
    return t.size * 3
}

func main() {
    t := geometry.Triangle{}
    t.SetSize(3)
    fmt.Println("Perimeter", t.Perimeter())
}

// 输出：
// Perimeter 18
// 如果从main()函数中调用size字段或者doubleSize()方法会报错
```

## 接口
一种数据类型，让代码更加灵活、适应性更强，因为未绑定到特定的实现，go中的接口是满足隐式实现的。
```golang
// 声明接口
type Shape interface {
    Perimeter() float64
    Area() float64
}

// 实现接口
// Square 结构的方法签名与 Shape 接口的签名的匹配
type Square struct {
    size float64
}

func (s Square) Area() float64 {
    return s.size * s.size
}

func (s Square) Perimeter() float64 {
    return s.size * 4
}

// 使用接口
func main() {
    var s Shape = Square{3}
    fmt.Printf("%T\n", s)
    fmt.Println("Area: ", s.Area())
    fmt.Println("Perimeter:", s.Perimeter())
}
// 输出：
// main.Square
// Area:  9
// Perimeter: 12

// 不同的结构调用接口
type Circle struct {
    radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.radius * c.radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.radius
}

// 重构main()函数
func printInformation(s Shape) {
    fmt.Printf("%T\n", s)
    fmt.Println("Area: ", s.Area())
    fmt.Println("Perimeter:", s.Perimeter())
    fmt.Println()
}

// 请注意 printInformation 函数具有参数 Shape。 你可以将 Square 或 Circle 对象发送到此函数，尽管输出会有所不同，但仍可使用。 main() 函数此时将如下所示：
func main() {
    var s Shape = Square{3}
    printInformation(s)

    c := Circle{6}
    printInformation(c)
}
// 输出：
// main.Square
// Area:  9
// Perimeter: 12

// main.Circle
// Area:  113.09733552923255
// Perimeter: 37.69911184307752

// 输出会根据其收到的对象类型而变化。 你还可以看到输出中的对象类型不涉及 Shape 接口的任何内容。

// 使用接口的优点在于，对于 Shape的每个新类型或实现，printInformation 函数都不需要更改。 正如我们之前所述，当你使用接口时，代码会变得更灵活、更容易扩展。
```

### 实现字符串接口
fmt.Printf 函数使用Stringer接口中的String()方法来输出值，这意味着你可以编写自定义 String() 方法来打印自定义字符串
```golang
type Person struct {
    Name, Country string
}

func (p Person) String() string {
    return fmt.Sprintf("%v is from %v", p.Name, p.Country)
}

func main() {
    rs := Person{"John Doe", "USA"}
    ab := Person{"Mark Collins", "United Kingdom"}
    fmt.Printf("%s\n%s\n", rs, ab)
}

// 输出：
// John Doe is from USA
// Mark Collins is from United Kingdom
```

### 扩展现有实现
```golang
package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
)

type GitHubResponse []struct {
	FullName string `json:"full_name"`
}

type customWriter struct{}

func (w customWriter) Write(p []byte) (n int, err error) {
	var resp GitHubResponse
	json.Unmarshal(p, &resp)
	for _, r := range resp {
		fmt.Println(r.FullName)
	}
	return len(p), nil
}

func main() {
	resp, err := http.Get("https://api.github.com/users/microsoft/repos?page=15&per_page=5")
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

	writer := customWriter{}
	io.Copy(writer, resp.Body)
}
```

### 服务器api
```golang
package main

import (
    "fmt"
    "log"
    "net/http"
)

type dollars float32

func (d dollars) String() string {
    return fmt.Sprintf("$%.2f", d)
}

type database map[string]dollars

func (db database) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    for item, price := range db {
        fmt.Fprintf(w, "%s: %s\n", item, price)
    }
}

func main() {
    db := database{"Go T-Shirt": 25, "Go Jacket": 55}
    log.Fatal(http.ListenAndServe("localhost:8000", db))
}
``` 

## goroutine
不是通过共享内存通信，而是通过通信共享内存
```golang
package main

import (
    "fmt"
    "net/http"
    "time"
)

func checkAPI(api string) {
	_, err := http.Get(api)
	if err != nil {
		fmt.Printf("ERROR: %s is down!\n", api)
		return
	}

	fmt.Printf("SUCCESS: %s is up and running!\n", api)
}

func main() {
    start := time.Now()

    apis := []string{
        "https://management.azure.com",
        "https://dev.azure.com",
        "https://api.github.com",
        "https://outlook.office.com/",
        "https://api.somewhereintheinternet.com/",
        "https://graph.microsoft.com",
    }

	for _, api := range apis {
		go checkAPI(api)
	}

	time.Sleep(3 * time.Second)

    elapsed := time.Since(start)
    fmt.Printf("Done! It took %v seconds!\n", elapsed.Seconds())
}
```

## channel
channel是goroutine之间的通信机制，channel有类型之分，创建通道需要使用make `cn := make(chan int)`  
运算符为 <-，箭头指向数据方向
```golang
ch <- v    // Send v to channel ch.
v := <-ch  // Receive from ch, and
           // assign value to v.
<-ch // receives data, but the result is discarded

// 关闭通道
close(ch)

// 调用通道
func checkAPI(api string, ch chan string) {
    _, err := http.Get(api)
    if err != nil {
        ch <- fmt.Sprintf("ERROR: %s is down!\n", api)
        return
    }

    ch <- fmt.Sprintf("SUCCESS: %s is up and running!\n", api)
}

ch := make(chan string)

for _, api := range apis {
    go checkAPI(api, ch)
}

for i := 0; i < len(apis); i++ {
    fmt.Print(<-ch)

}
```

### 有缓冲channel
类似于队列，创建channel时可以限制此队列的大小
```golang
package main

import (
    "fmt"
)

func send(ch chan string, message string) {
    ch <- message
}

func main() {
    size := 4
    ch := make(chan string, size)
    send(ch, "one")
    send(ch, "two")
    send(ch, "three")
    send(ch, "four")
    fmt.Println("All data sent to the channel ...")

    for i := 0; i < size; i++ {
        fmt.Println(<-ch)
    }

    fmt.Println("Done!")
}
```

现在，你可能想知道何时使用这两种类型。 这完全取决于你希望 goroutine 之间的通信如何进行。 无缓冲 channel 同步通信。 它们保证每次发送数据时，程序都会被阻止，直到有人从 channel 中读取数据。

相反，有缓冲 channel 将发送和接收操作解耦。 它们不会阻止程序，但你必须小心使用，因为可能最终会导致死锁（如前文所述）。 使用无缓冲 channel 时，可以控制可并发运行的 goroutine 的数量。 例如，你可能要对 API 进行调用，并且想要控制每秒执行的调用次数。 否则，你可能会被阻止。

### channel方向
```golang
chan<- int // it's a channel to only send data
<-chan int // it's a channel to only receive data

package main

import "fmt"

func send(ch chan<- string, message string) {
    fmt.Printf("Sending: %#v\n", message)
    ch <- message
}

func read(ch <-chan string) {
    fmt.Printf("Receiving: %#v\n", <-ch)
}

func main() {
    ch := make(chan string, 1)
    send(ch, "Hello World!")
    read(ch)
}
// 输出：
// Sending: "Hello World!"
// Receiving: "Hello World!"
```

### 多路复用
replicate 函数首先完成，这就是首先在终端中看到其输出的原因。 main 函数存在一个循环，因为 select 语句在收到事件后立即结束，但我们仍在等待 process 函数完成
```golang
package main

import (
    "fmt"
    "time"
)

func process(ch chan string) {
    time.Sleep(3 * time.Second)
    ch <- "Done processing!"
}

func replicate(ch chan string) {
    time.Sleep(1 * time.Second)
    ch <- "Done replicating!"
}

func main() {
    ch1 := make(chan string)
    ch2 := make(chan string)
    go process(ch1)
    go replicate(ch2)

    for i := 0; i < 2; i++ {
        select {
        case process := <-ch1:
            fmt.Println(process)
        case replicate := <-ch2:
            fmt.Println(replicate)
        }
    }
}
// 输出：
// Done replicating!
// Done processing!
```

### select
```golang
package main

import (
	"fmt"
	"time"
)

func main() {
	tick := time.Tick(100 * time.Millisecond)  // 定义了一个定时管道
	boom := time.After(500 * time.Millisecond)  // 定义一个超时管道
	for {
		select {
		case <-tick:
			fmt.Println("tick.")
		case <-boom:
			fmt.Println("BOOM!")
			return
		default:
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
}
```

## 泛型 generics
```golang
package main

import "fmt"

type Number interface {
    int64 | float64
}

func main() {
    fmt.Printf("Generic Sums: %v and %v\n",
        SumIntsOrFloats[string, int64](ints),
        SumIntsOrFloats[string, float64](floats))

    fmt.Printf("Generic Sums, type parameters inferred: %v and %v\n",
        SumIntsOrFloats(ints),
        SumIntsOrFloats(floats))

    fmt.Printf("Generic Sums with Constraint: %v and %v\n",
        SumNumbers(ints),
        SumNumbers(floats))
}

func SumIntsOrFloats[K comparable, V int64 | float64](m map[K]V) V {
    var s V
    for _, v := range m {
        s += v
    }
    return s
}

// SumNumbers sums the values of map m. Its supports both integers
// and floats as map values.
func SumNumbers[K comparable, V Number](m map[K]V) V {
    var s V
    for _, v := range m {
        s += v
    }
    return s
}
```

## 闭包 closures
把函数当参数传递
```golang
func viewHandler(w http.ResponseWriter, r *http.Request, title string)
func editHandler(w http.ResponseWriter, r *http.Request, title string)
func saveHandler(w http.ResponseWriter, r *http.Request, title string)

func makeHandler(fn func (http.ResponseWriter, *http.Request, string)) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        // Here we will extract the page title from the Request,
        // and call the provided handler 'fn'
    }
}
```

## go web项目规范
基本原则：可读可维护，可扩展和模块化，规范一致

/cmd  项目主干，通常有一个main函数，从/internal和/pkg目录导入和调用代码，除此之外没有别的东西
```
cmd
├── ctl
│   └── main.go
├── server
│   └── main.go
└── task
    └── main.go
```
/internal  私有应用程序和库代码
```
internal
├── app
│   ├── ctl
│   ├── server
│   └── task
└── pkg

其中 /internal/app 下存放各个组件的逻辑代码，/internal/pkg 下存放各组件间的共享代码。
```
/pkg  外部应用程序可以使用的库代码  
/vendor  应用程序依赖项，go mod vendor命令会创建/vendor目录  
/api  openapi/swagger规范，json模式文件，协议定义文件  
/web  前端代码，如果为restful api项目就不需要此项目，将前端代码作为一个独立的项目  
/configs  配置目录  
/init  system init配置  
/scripts  执行各种构建、安装、分析等操作的脚本  
/build  打包和持续集成，将你的云( AMI )、容器( Docker )、操作系统( deb、rpm、pkg )包配置和脚本放在 /build/package 目录下。将你的 CI (travis、circle、drone)配置和脚本放在 /build/ci 目录中  
/deployments  aaS、PaaS、系统和容器编排部署配置和模板(docker-compose、kubernetes/helm、mesos、terraform、bosh)  
/test  额外的外部测试应用程序和测试数据  
/docs  设计和用户文档  
/tools  这个项目的支持工具。注意，这些工具可以从 /pkg 和 /internal 目录导入代码  
/examples  你的应用程序和/或公共库的示例。  
/assets  图像、徽标等  
/thied_party  外部辅助工具，分叉代码和其他第三方工具(例如 Swagger UI)。  

根目录下文件  
/README.md  
/Makefile  项目管理工具  
/CHANGELOG  存放项目更新记录  
/CONTRIBUTING.md  说明如何贡献代码、项目规范  
/LICENSE  

总结
```
project
├── CHANGELOG
├── CONTRIBUTING.md
├── LICENSE
├── Makefile
├── README.md
├── api
│   └── openapi
│       └── openapi.yaml
├── assets
├── build
├── cmd
│   ├── ctl
│   │   └── main.go
│   ├── server
│   │   └── main.go
│   └── task
│       └── main.go
├── configs
├── deployments
├── docs
├── examples
├── githooks
├── init
├── internal
│   ├── app
│   │   ├── ctl
│   │   ├── server
│   │   └── task
│   └── pkg
├── pkg
├── scripts
├── test
├── third_party
├── tools
└── web
```

## test
可以创建以`_test.go`为结尾的文件作为测试文件，其中包含以`Test`开头的函数`func (t *testing.T)`
```golang
package morestrings

import "testing"

func TestReverseRunes(t *testing.T) {
    cases := []struct {
        in, want string
    }{
        {"Hello, world", "dlrow ,olleH"},
        {"Hello, 世界", "界世 ,olleH"},
        {"", ""},
    }
    for _, c := range cases {
        got := ReverseRunes(c.in)
        if got != c.want {
            t.Errorf("ReverseRunes(%q) == %q, want %q", c.in, got, c.want)
        }
    }
}
```
