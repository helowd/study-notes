# powershell

## 目录
<!-- vim-markdown-toc GFM -->

* [系统特点](#系统特点)
* [常用命令](#常用命令)
* [脚本执行](#脚本执行)
* [命名](#命名)
* [判断](#判断)
* [循环](#循环)
* [函数](#函数)

<!-- vim-markdown-toc -->

## 系统特点
winget  包管理工具  
powershell支持在多个平台上使用，centos、ubuntu等，并且是开源的

## 常用命令
cmdlet 是已经编译的命令的总和，根据动词-名词命名标准命名  
.ps1 powershell脚本的后缀名  
$PSVersionTable 打印当前powershell版本信息  
get-command 列出系统上所有可用的cmdlet  
get-help 查看命令帮助文档，help以分页形式输出  
get-member 查看某个对象的属性和方法  
update-help -uiculture en-Us -verbose 更新英文帮助文档  
select-object 筛选输出结果  
get-process 列出所有进程  
sort-object 对输出数据进行排序  
write-output 打印到标准输出  
read-host 输入到标准输入  
new-item 新建文件  
stop-computer  关闭本地和远程计算机
restart-computer  重启机器 

## 脚本执行
绕过策略执行脚本
```powershell
powershell -ExecutionPolicy Bypass -File s:\git\scripts\like_grep.ps1 -targetDirectory . -pattern "\[toc\]"
```

## 命名

## 判断

## 循环

## 函数
