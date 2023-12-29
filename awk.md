# awk
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file

awk脚本是由模式和操作组成的。

模式
模式可以是以下任意一个：

/正则表达式/：使用通配符的扩展集。
关系表达式：使用运算符进行操作，可以是字符串或数字的比较测试。
模式匹配表达式：用运算符~（匹配）和!~（不匹配）。
BEGIN语句块、pattern语句块、END语句块：参见awk的工作原理

操作
操作由一个或多个命令、函数、表达式组成，之间由换行符或分号隔开，并位于大括号内，主要部分是：
变量或数组赋值
输出命令
内置函数
控制流语句
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