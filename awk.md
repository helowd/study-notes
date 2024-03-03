# awk

## 目录

<!-- vim-markdown-toc GFM -->

* [基础](#基础)
    * [语法](#语法)
    * [记忆](#记忆)
    * [内建函数](#内建函数)
    * [流程控制](#流程控制)
    * [数组](#数组)
    * [printf](#printf)
* [参考资料](#参考资料)

<!-- vim-markdown-toc -->

## 基础

### 语法
awk是一行一行的来处理数据，每一行的字段默认以空白键或者tab键分隔。awk脚本是由模式和操作组成的。

模式
模式可以是以下任意一个：

/正则表达式/：使用通配符的扩展集。
关系表达式：使用运算符进行操作，可以是字符串或数字的比较测试。
模式匹配表达式：用运算符~（匹配）和!~（不匹配）。
BEGIN语句块、pattern语句块、END语句块

动作
动作由一个或多个命令、函数、表达式组成，之间由换行符或分号隔开，并位于大括号内，主要部分是： 
变量或数组赋值  
输出命令 
内置函数 
控制流语句

完整语法：
```bash
# BEGIN模式在第一个输入文件的第一行之前被匹配，END在最后一个输入文件的最后一行被处理之后匹配
# 一个动作就是一个语句序列，语句之间用分号或者换行符分开
awk 'BEGIN { print "start" } pattern1 { commands1 } pattern2 { commands2 } ...  END { print "end" }' file
```

### 记忆
```
$0  这一行的所有内容
NF  这一行拥有的字段数
NR  目前awk处理的第几行数
FS  字段分隔符，默认是空白
-f  告诉awk从指定文件提取程序
*  相乘，如$2 * $3
/  相除，如pay/n
> < == >= <= != && || !  一些可用的逻辑运算符
emp = emp + 1  awk中的变量都有初始值，不需要先初始化再使用
names = names $1 " "  字符串拼接
{ last=$0 } END { print last }  打印最后一行，END中NR值能读到，但$0不会
/Beth/  打印包含Beth的行
```

### 内建函数
```
length($1)  计算字符串中的字符数
```

### 流程控制
流程控制语句if-else以及循环语句只能用在动作里，这些流程控制都来之c语言

if-else
```bash
# if后面的条件为真则第一个print语句执行，否则第二个print语句执行，逗号后面断行可以将语句延续到下一行
$2 > 6 { n = n + 1; pay = pay + $2 * $3 }
END { if (n > 0)
        print n, "employees, total pay is", pay,
                "average pay is", pay/n
    else
        print "no employees are paid more than $6/hour"
    }
```

while
```bash
{   i = 1
    while (i <= $3) {
        printf("\t%.2f\n", $1 * (1 + $2) ^ i)
        i = i + 1
    }

}
```

for
```bash
{   for (i = 1; i <= $3; i = i + 1)
        printf("\t%.2f\n", $1 * (1 + $2) ^ i)
}
```

### 数组
```bash
# 行倒叙输出
{ line[NR] = $0 }
END {   i = NR
        while (i > 0) {
            print line[i]
            i = i - 1   
        } 
    }

## 等价for实现
{ line[NR] = $0 }
END {   for (i = NR; i > 0; i = i - 1)
            print line[i]
    }
```

### printf
语法格式：printf(format, value1, value2, ... , valueN)

示例：
```bash
# 在字符串中输出
{ printf("total pay for %s is $%.2f\n", $1, $2 * $3) }  

# 向左对齐8位，占6个字符宽度并保留两位小数
{ printf("%-8s $%6.2f\n", $1, $2 * $3) }
```

```bash
# 计算总额
#
# pay.txt
# Name 1st 2nd 3th
# VBird 23000 24000 25000
# DMTsai 21000 20000 23000
# Bird2 43000 42000 41000

# 语法一：
awk 'NR==1{printf "%10s %10s %10s %10s %10s\n", $1,$2,$3,$4,"Total"} NR>=2{total = $2 + $3 + $4;  printf "%10s %10d %10d %10d %10.2f\n", $1, $2, $3, $4, total}' pay.txt

# 语法二：类c
awk '{if(NR==1) printf "%10s %10s %10s %10s %10s\n",$1,$2,$3,$4,"Total "} {if(NR>=2) {total = $2 + $3 +$4; printf "%10s %10d %10d %10d %10.2f\n",$1, $2, $3, $4, total}}' pay.txt

# 统计响应成功率
#
# result.txt
# 时间         路由         状态码  
# 23:23:11     /aa              200  
# 12:23:12     /aa              200  
# 10:32:90     /bb              300
#
# 输出格式
# 路由     成功率  
# /aa     100%
# /bb     0%
awk 'NR>1{routes[$2]++; if($3==200) success[$2]++} END{printf "路由\t成功率\n"; for(route in routes) {rate=success[route]/routes[route]*100; printf "%s\t%.of%%\n", route,rate}}'
```

## 参考资料
https://wangchujiang.com/linux-command/c/awk.html  
https://www.runoob.com/w3cnote/awk-user-defined-functions.html
