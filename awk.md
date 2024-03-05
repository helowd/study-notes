# awk

## 目录

<!-- vim-markdown-toc GFM -->

* [基础](#基础)
    * [语法](#语法)
    * [记忆](#记忆)
    * [内建函数](#内建函数)
    * [关键字](#关键字)
    * [流程控制](#流程控制)
    * [数组](#数组)
    * [自定义函数](#自定义函数)
* [printf](#printf)
* [案例](#案例)
    * [依据日志文件计算流量](#依据日志文件计算流量)
    * [nginx access.log日志分析](#nginx-accesslog日志分析)
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
> < == >= <= != && || ! ~ !~ 一些可用的逻辑运算符
emp = emp + 1  awk中的变量都有初始值，不需要先初始化再使用
names = names $1 " "  字符串拼接
{ last=$0 } END { print last }  打印最后一行，END中NR值能读到，但$0不会
/Beth/  打印包含Beth的行
$4 ~ /Asia/  匹配所有第四个字段包含Asia的输入行
ARGC  命令行参数的个数
ARGV  命令行参数数组
FILENAME  当前输入文件名
FNR  当前输入文件的记录个数
OFMT  数值的输出格式，默认"%.6g"
OFS  输出字段的分隔符，默认空白
ORS  输出的记录的分隔符，默认"\n"
RLENGTH  被函数match匹配的字符串的长度
RS  控制着输入行的记录分隔符，默认"\n"
RSTART  被函数match匹配的字符串的开始
SUBSEP  下标分隔符，默认"\034"
```

### 内建函数
```
length($1)  计算字符串中的字符数
rand()  返回一个大于等于0，小于1的伪随机浮点数
srand(x)  可以使随机数生成器的开始点从x开始，随机数种子
int(x)  取x的整数部分
sqrt(x)  x的方根
sub(r,s)  将$0的最左最长的，能被r匹配的子字符串替换为s，返回替换发生的次数
sub(r,s,t)  在t中执行替换
split(s,a)  用FS将s分割到数组a中，返回字段的个数
split(s,a,fs)  用fs分割
substr(s,p,n)  返回s中从位置p开始的，长度为n的子字符串
system(expression)  用于执行unix命令，命令由expression给出，system的返回值就是命令的退出状态
```

### 关键字
```
break
continue
next  开始主循环的下一次迭代
exit expression  马上执行END动作，如果已经在END中就退出程序，将expression作为程序退出状态返回
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

for (expression in array) statements
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

### 自定义函数
函数定义可以出现在任何 模式-动作 语句可以出现的地方  
函数体内，参数是局部变量，其它所有变量都是全局的

语法：
```
function name(parameter-list) {
    statements
}

# 计算参数的最大值，如果没有为return提供表达式，或者最后一句执行的语句不是return，那么返回值就是未定义的
function max(m, n) {
    return m > n ? m : n
}
```

## printf
语法格式：printf(format, value1, value2, ... , valueN)

示例：
```bash
# 在字符串中输出
{ printf("total pay for %s is $%.2f\n", $1, $2 * $3) }  

# 向左对齐8位，占6个字符宽度并保留两位小数
{ printf("%-8s $%6.2f\n", $1, $2 * $3) }
```

## 案例
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


```bash
awk -F ".”'{
    if(NF!=4)
        print "error";
    else {
        msg = “yes" ;
        for(i=1 ; i<=NF;i++){
            if($i<0[|$i>255){
                msg ="no";
                break;
            }
        }
        print msg;
    }
}' nowcoder .txt
```

### 依据日志文件计算流量

算出2022年7月份的每一分钟的流量.-----使用循环多级嵌套，正则结合for循环，流量需要求和
```
2022-7-1 00:01:01 78
2022-7-1 00:01:04 89
2022-7-1 00:02:04 89
2022-7-1 00:03:01 178
....
2022-7-3 00:04:34 839
2022-7-4 00:01:04 189
2022-7-4 00:01:54 89
.... 
2022-7-30 00:03:01 178
2022-7-31 00:07:05 8900
```
脚本：
```bash
awk '{time[$1,substr($1,5,1),substr($2,1,5)]+=$3}END{for (i in time)print i,time[i]}'  test.txt |sort -n -k 3 -t -
```

### nginx access.log日志分析
对nginx的日志文件access.log进行分析，分析出单个ip地址累计下载获取的文件大小的总数（对每次访问数据的大小进行求和)，显示下载总数最大的前100个ip地址和下载文件大小，按照下载文件大小的降序排列
```
以下是nginx日志的字段含义
$time_iso8601|$host $http_cf_connecting_ip |$request |$status|$body_bytes_sent|$http_referer |$http_user_agent

2019-04-25T09:51:58+08:00 | a.google.com|47.52.197.27|GET /2/depth?symbol=aaaHTTP/1.1 | 200| 24|-| apple
2019-04-25TO9:52:58+08:00 | b.google.com |47.75.159.123|GET /2/depth?symbol=bbbHTTP/1.1 [ 200| 407|-l python-requests/2.20.0
2019-04-25T09:53:58+08:00 | c.google.com | 13.125.219.4|GET /2/ticker?timestamp=1556157118&symbol=ccc HTTP/1.1|200|162/|-|chrome
2019-04-25TO9:54:58+08:00 | d.shuzibi.co|-/|HEAD /justfor.txt HTTP/1.0|200|0/-1-
2019-04-25T09:55:58+08:00| e.google.com |13.251.98.2|GET /2/order_detail?apiKey=dddHTTP/1.1 [200| 231/-l python-requests/2.18.4
2019-04-25T09:56:58+08:00|f.google.com|210.3.168.106|GET /v2/trade_detail?apiKey=eeeHTTP/1.1 | 200|24|-l-
```
脚本：
```
awk '{access[$1]+=$10}END{for (i in access) print i,access[i]}'access.log |sort -k 2 -n -r / head -100 result.txt
```

计算每分钟带宽（body_bytes_sent）
```bash
awk -F"/" '{f1ow[substr($1,1,16)]+=$(NF-2)}END{for (i in flow) printi,f1ow[i]3' nginx.log
```

统计每个URL（即不带问号的前面的内容）的每分钟的频率
```bash
awk -F"[l ?]+" '{flow[substr($1,1,16)$5]+=1}END{for (i in flow)print i,fTow[i]}' nginx.1og
```

编写时间段的正则，使用sed/grep/awk过滤出下面时间段的日志，输出到屏幕  
06/Jul/2022:1:24    06/Jul/2022:23:24
```bash
awk '$4~/01\/Jul\/2022:([1-9]|1[0-9]|2[0-3])/{print $0}' access.log |wc -l
```

对nginx的日志文件access.log进行分析，分析出单个ip地址累计下载获取的文件大小的总数（对每次访问数据的大小进行求和），显示下载总数最大的前100个ip地址和下载文件大小，按照下载文件大小的降序排列
```bash
awk '{ip[$1]+=$10}END{for(i in ip) print i,ip[i]}' access.log |sort -r -n -k 2 |head -100
```

## 参考资料
https://wangchujiang.com/linux-command/c/awk.html  
https://www.runoob.com/w3cnote/awk-user-defined-functions.html
